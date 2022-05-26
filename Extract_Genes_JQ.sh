#!/bin/bash

SCRIPT="Extract genes from Nirvana JSON file"
AUTHOR="Copyright 2022 Usama Bakry (u.bakry@icloud.com)"

## Command line options
## -----------------------------------------------------------------------------
while getopts i:g:o: OPTION
do
case "${OPTION}"
in
# Input directory
i) INPUT=${OPTARG};;
# Genes file
g) GENE_LIST=${OPTARG};;
# Output directory
o) OUTPUT=${OPTARG};;
esac
done
## -----------------------------------------------------------------------------

## Print user args
## -----------------------------------------------------------------------------                     
echo -e "[     INFO    ] Input Directory  : ${INPUT}"
echo -e "[     INFO    ] Output Directory : ${OUTPUT}"
## -----------------------------------------------------------------------------

## User confirmation
## -----------------------------------------------------------------------------
read -p "Continue (y/n)?" CHOICE
case "$CHOICE" in 
	y|Y ) 

main () {

## Print pipeline info
## -----------------------------------------------------------------------------                     
echo -e "[     INFO    ] ${SCRIPT}"
echo -e "[     INFO    ] ${AUTHOR}"
## -----------------------------------------------------------------------------  
echo -e "[     INFO    ] Input Directory  : ${INPUT}"
echo -e "[     INFO    ] Output Directory : ${OUTPUT}\n"
## -----------------------------------------------------------------------------

## Print start date/time
## -----------------------------------------------------------------------------                     
echo -e "[    START    ] $(date)\n"
## -----------------------------------------------------------------------------  

## Create output directory
## -----------------------------------------------------------------------------                     
echo -e "[   PROCESS   ] Creating output directory..."

# Check if output directory is exist
if [ -d "${OUTPUT}/" ] 
then
    echo -e "[    ERROR    ] The output directory already exists.\n"
    exit 0
else
    mkdir -p ${OUTPUT}/
fi

echo -e "[      OK     ] Output directory is ready on ${OUTPUT}/\n"
## ----------------------------------------------------------------------------- 

## Extract genes from Nirvana JSON file
## -----------------------------------------------------------------------------
time {
echo -e "[   PROCESS   ] Extract genes..."

echo -e "SAMPLE\tCOUNT\tGENES" >> ${OUTPUT}/Output.tsv

FILES=$(ls ${INPUT} | grep ".json")
for FILE in $FILES; do
    PREFIX=$(basename "$FILE" | cut -d. -f1)

    time jq '.genes | .[] |.name' ${INPUT}/${FILE} | sed 's/\"//g' | sort > ${OUTPUT}/${PREFIX}.genes 
    GENES=`comm -12 ${GENE_LIST} ${OUTPUT}/${PREFIX}.genes | sed 's/ /\n/g'`
    COUNT=`echo ${GENES} | sed 's/ /\n/g' | wc -l`
    GENE_LST=`echo ${GENES} | sed 's/ /, /g'`

    echo -e "${PREFIX}\t${COUNT}\t${GENE_LST}" >> ${OUTPUT}/Output.tsv    

done

echo -e "[      OK     ] Extraction is done.\n"
}
## -----------------------------------------------------------------------------

## Print end date/time
## -----------------------------------------------------------------------------                     
echo -e "[     END     ] $(date)\n"
## -----------------------------------------------------------------------------  

} ## End of main function
## -----------------------------------------------------------------------------                      

## Prepare output log file
## -----------------------------------------------------------------------------                     
LOG=$( { time main > "$(dirname "${OUTPUT}")"/genes_extraction.log 2>&1; } 2>&1 )
echo -e "Duration:${LOG}" >> "$(dirname "${OUTPUT}")"/genes_extraction.log 2>&1                    

exit 0

;;

	n|N ) echo -e "[      OK     ] Process stopped.";;
	* ) echo -e   "[     ERROR   ] invalid";;
esac