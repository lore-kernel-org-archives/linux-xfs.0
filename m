Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4IKwkRL260806 for <xfs@oss.sgi.com>; Wed, 18 May 2011 15:58:46 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7C1F467A48
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 13:58:45 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id SXrGJxFNATFnHK9v for
	<xfs@oss.sgi.com>; Wed, 18 May 2011 13:58:45 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4IKbq2j024300
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:37:52 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4IKwhvu114308 for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:58:44 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p4IKwhFY004127 for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:58:43 -0400
Message-ID: <4DD43300.6010908@linux.vnet.ibm.com>
Date: Wed, 18 May 2011 13:58:40 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch Hole
	Test Routines
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>

This patch adds low level routines to common.punch
for populating test files and punching holes in them using
fallocate.  When a hole is punched, file is then analyzed to
verify that the hole was punched correctly.  These routines will
be used to test various corner cases in the new fallocate
punch hole tests.

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 e2da5d8... 778389a... M	common.punch
 common.punch |  393 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 393 insertions(+), 0 deletions(-)

diff --git a/common.punch b/common.punch
index e2da5d8..778389a 100644
--- a/common.punch
+++ b/common.punch
@@ -377,3 +377,396 @@ _test_generic_punch()
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
 }
+
+
+#_fill_file()
+#
+#Fills a file with the given byte value up to the
+#given number of bytes.
+#
+# $1: The name of the file to fill
+# $2: The byte value to fill the file with
+# $3: The number of bytes to put in the file
+# $4: The block size used when copying in 
+#     "block" sized chunks of data
+_fill_file() {
+	local file_to_fill=$1
+	local byte_value=$2
+	local number_of_bytes=$3
+	local blk_size=$4
+	
+	remaining_bytes=$number_of_bytes
+	blk=""
+
+	for (( i=0; i<blk_size; i++ ))
+	do
+		blk=$blk$byte_value
+	done
+
+	while [ $remaining_bytes -ge $blk_size ]
+	do
+		printf "$blk" >> $file_to_fill
+		remaining_bytes=$(($remaining_bytes - $blk_size))
+	done
+
+	for (( i=0; i<$remaining_bytes; i++ ))
+	do
+		printf "$byte_value" >> $file_to_fill
+	done
+	
+
+}
+
+# _hole_test()
+#
+# Punches a hole in the test file.
+# The hole is the checked to make sure the correct number
+# of blocks are released and the associated extents are 
+# removed
+#
+# Usage: _hole_test [options] file_name hole_offset hole_length
+# Options:
+#    -c <length> Create a file of the given length full of data to punch a hole in
+#    -p <length> Preallocate a file to the given length to punch a hole in
+#    -s          Sync the file before punching the hole
+#    -m          Remount the device before punching the hole
+#
+# This test is successful when the following conditions are met:
+#  - ls shows that the number of blocks occupied by the file
+#    has decreased by the number of blocks punched out.
+#  - df shows number of available blocks has increased by the number
+#    of blocks punched out
+#  - File frag shows that the blocks punched out are absent from
+#    the extents
+#  - The test file contains zeros where the hole should be
+# 
+_hole_test() {
+
+	err=0
+	sflag=
+	mflag=
+	pflag=
+	cflag=
+	lflag=
+	oflag=
+	OPTIND=1
+	while getopts 'smc:p:' OPTION
+	do
+		case $OPTION in
+		s)	sflag=1
+		;;
+		m)	mflag=1
+		;;
+		p)	pflag="$OPTARG"
+		;;
+		c)	cflag="$OPTARG"
+		;;
+		?)	echo Invalid flag
+		echo "Usage: $(basename $0): [options]  file_name hole_offset hole_length" >&2
+		echo "Options:" >&2
+		echo "-c <length> Create a file of the given length full of data to punch a hole in" >&2
+		echo "-p <length> Preallocate a file to the given length to punch a hole in" >&2
+		echo "-s          Sync the file before punching the hole" >&2
+		echo "-m          Remount the device before punching the hole"
+		exit 1
+		;;
+		esac
+	done
+	shift $(($OPTIND - 1))
+
+	local file_name=$1
+	local hole_offset=$2
+	local hole_length=$3
+	local hole_offset_orig=$hole_offset
+	local hole_length_orig=$hole_length
+
+	if [ "$cflag" ]; then
+		local file_length=$cflag
+	elif [ "$pflag" ]; then
+		local file_length=$pflag
+	else
+		local file_length=`ls -ls $file_name | cut -d ' ' -f6`
+	fi
+
+	# If the hole to punch out extends off the edge of the file, 
+	# then we need to expect a smaller hole to be punched
+	if [ $hole_offset -ge $file_length ]; then
+		local hole_length=0
+		local hole_offset=$file_length
+	elif [ $(($hole_offset + $hole_length)) -gt $file_length ]; then
+		local hole_length=$(($file_length - $hole_offset))
+	fi
+
+	# locations to store hexdumps must not be in the filesystem
+	# or it will skew the results.  When we measure used
+	# available blocks. Also, there may not be enough
+	# room to store them in the fs during ENOSPC tests
+	# So store the dumps in the cwd by stripping the path
+	expected=`echo $file_name.hexdump.expected | sed 's/.*\///'`
+	result=`echo $file_name.hexdump.result | sed 's/.*\///'`
+
+	#calculate the end points of the hole in blocks
+	local block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	local hole_first_blk=$(( $hole_offset / $block_size ))
+	if [ $(($hole_offset % $block_size)) != 0 ]
+	then
+		local hole_first_blk=$(( $hole_first_blk + 1 ))
+	fi
+
+	local hole_last_blk=$(( ($hole_offset + $hole_length) / $block_size ))
+
+	#calculate the length of the hole in blocks
+	if [ $hole_first_blk -gt $hole_last_blk ]
+	then
+		local hole_length_block=0
+	else
+		local hole_length_block=$(( $hole_last_blk - $hole_first_blk ))
+	fi
+
+	#record how many blocks free blocks the filesystem has
+	local fs_used_before=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $3 }'`
+	local fs_avail_before=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $4 }'`
+
+	rm $expected &> /dev/null
+	rm $result &> /dev/null
+	local total_hole_overlap=0
+
+	#if we are preallocating, then just fallocate the file
+	if [ "$pflag" ]; then
+		rm $file_name &> /dev/null
+
+		fallocate -o 0 -l $file_length $file_name
+
+		#get the hexdump, this is what the punch hole should look like
+		hexdump -C $file_name > $expected
+
+	#else if createing the file, manually construct the file
+	elif [ "$cflag" ]; then
+		rm $file_name &> /dev/null
+		#create a file full of data with zeros in the middle
+		
+		#Fill in head of file
+		_fill_file $file_name "\xFF" $hole_offset $block_size
+
+		#Fill in hole with zeros
+		if [ $hole_length -gt 0 ]; then
+			(dd if=/dev/zero of=$file_name obs=1 ibs=1 seek=$(($hole_offset + $hole_length - 1)) \
+			count=1 conv=notrunc) &> /dev/null
+		fi
+
+		#Fill in tail of file
+		_fill_file $file_name "\xFF" $(( $file_length - $hole_offset - $hole_length )) $block_size
+
+		#get the hexdump, this is what the punch hole should look like
+		hexdump -C $file_name > $expected
+
+		#refill the file
+		rm $file_name
+		_fill_file $file_name "\xFF" $file_length $block_size
+
+	#else we are punching a hole in an existing file
+	else
+
+		local tmp_file=`echo $file_name.tmp | sed 's/.*\///'`
+
+		#make a back up of the test file
+		cp $file_name $tmp_file
+
+		#Fill in hole with zeros
+		if [ $hole_length -gt 0 ]; then
+			(dd if=/dev/zero of=$tmp_file obs=1 ibs=1 seek=$(($hole_offset)) \
+			count=$hole_length conv=notrunc) &> /dev/null
+		fi
+
+		#get the hexdump, this is what the punch hole should look like
+		hexdump -C $tmp_file > $expected
+		rm $tmp_file
+
+		# Now we need to check for existing holes
+		# Holes that are already punched out will need to be subtracted from the
+		# total blocks expected to be punched out
+		# Walk over the extents, to find existing holes.
+		if [ $hole_length_block -gt 0 ]; then
+			IFS="
+"
+			local prev_logical_blk=0
+			local prev_ext_len=0
+			local prev_last_logical_blk=0
+			extents=`filefrag -v $file_name | sed '1,3d' | sed '$d'`
+			for extent in $extents
+			do
+				#extract info from extent
+				ext_num=`echo $extent | cut -c1-4 | tr -d " "`
+				logical_blk=`echo $extent | cut -c5-12 | tr -d " "`
+				phys_blk=`echo $extent | cut -c13-21 | tr -d " "`
+				expct_phys_blk=`echo $extent | cut -c22-30 | tr -d " "`
+				ext_len=`echo $extent | cut -c31-37 | tr -d " "`
+				ext_flags=`echo $extent | cut -c38- | tr -d " "`
+				last_logical_blk=$(( $logical_blk + $ext_len ))
+
+				#calculate the space between this extent and the last
+				existing_hole_start=$prev_last_logical_blk
+				existing_hole_len=$(( $logical_blk - $prev_last_logical_blk ))
+				existing_hole_end=$(( $existing_hole_start + $existing_hole_len ))
+				hole_overlap=0;
+
+				#if there is a hole, check to see if it intersects with the new hole
+				if [ $existing_hole_len -gt 0 ]; then
+					if [[ $hole_first_blk -le $existing_hole_start && \
+						$existing_hole_start -lt $hole_last_blk ]]; then
+
+						if [[ $hole_first_blk -lt $existing_hole_end && \
+							$existing_hole_end -le $hole_last_blk ]] ;then
+
+							#The new hole contains an old hole
+							hole_overlap=$existing_hole_len;
+						else
+							#The new hole contains the start of an old hole
+							hole_overlap=$(( $hole_last_blk - $existing_hole_start ))
+						fi
+
+					elif [[ $hole_first_blk -lt $existing_hole_end && \
+						$existing_hole_end -le $hole_last_blk ]]; then
+
+						#The new hole contains the tail of an old hole
+						hole_overlap=$(( $existing_hole_end - $hole_first_blk ))
+
+					elif [[ $existing_hole_start -le $hole_first_blk && \
+						$hole_first_blk -lt $existing_hole_end ]] && \
+					     [[ $existing_hole_start -lt $hole_last_blk && \
+						$hole_last_blk -le $existing_hole_end ]]; then
+
+						#The old hole contains the new hole
+						hole_overlap=$hole_length_block
+
+					fi
+
+				fi
+
+				#tally up the total number of already punched out blocks
+				total_hole_overlap=$(( $total_hole_overlap + $hole_overlap ))
+
+				prev_logical_blk=$logical_blk
+				prev_ext_len=$ext_len
+				prev_last_logical_blk=$last_logical_blk
+			done
+		fi
+
+
+	fi
+
+	if [ "$sflag" ]
+	then
+		sync
+	fi
+
+
+	if [ "$mflag" ]
+	then
+		umount $TEST_DEV
+		mount $TEST_DEV $TEST_DIR
+	fi
+
+	#record how many blocks free blocks the filesystem has
+	local fs_used_before=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $3 }'`
+	local fs_avail_before=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $4 }'`
+	local file_used_before=`ls -ls --block-size=$block_size $file_name | cut -d " " -f1`
+
+	#punch the hole
+	$XFS_IO_PROG -F -f -c "fpunch $hole_offset_orig $hole_length_orig " $file_name
+
+	#get the results
+	local fs_used_after=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $3 }'`
+	local fs_avail_after=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $4 }'`
+	local file_used_after=`ls -ls --block-size=$block_size $file_name | cut -d " " -f1`
+	hexdump -C $file_name > $result #this must be collected last or it will skew the results
+
+
+	# verify results
+	#------------------------------------
+
+	# Does the file contain zeros where it should?
+	diff $expected $result
+	if [ "$?" -ne "0" ]; then
+		echo Punch hole failed: Expected file and resulting file differ 
+		echo Check $expected vs $result
+		err=1
+	fi
+
+	# Has the number of used filesystem blocks decreased by the size of the hole?
+	if [ $(($fs_used_before - $fs_used_after)) != $(($hole_length_block - $total_hole_overlap)) ]; then
+		echo Punch hole failed: Filesystem shows an incorrect number of used blocks
+		echo Used blocks before: $fs_used_before
+		echo Used blocks after:  $fs_used_after
+		echo Hole Length: $hole_length_block
+		echo Blocks already punched out: $total_hole_overlap
+		echo Total blocks that should be punched out from this hole: $hole_length_block
+		err=1
+	fi
+
+	# Has the number of free filesystem blocks increased by the size of the hole?
+	if [ $(($fs_avail_after - $fs_avail_before)) != $(($hole_length_block - $total_hole_overlap)) ]; then
+		echo Punch hole failed: Filesystem shows an incorrect number of available blocks
+		echo Available blocks before: $fs_avail_before
+		echo Available blocks after:  $fs_avail_after
+		echo Hole Length: $hole_length_block
+		echo Blocks already punched out: $total_hole_overlap
+		echo Total blocks that should be punched out from this hole: $hole_length_block
+		err=1
+	fi
+
+	# Has the number of blocks the file occupies decreased by the size of the hole?
+	if [ $(($file_used_before - $file_used_after)) != $(($hole_length_block - $total_hole_overlap)) ]; then
+		echo Punch hole failed: File shows an incorrect number of used blocks
+		echo Used blocks before: $file_used_before
+		echo Used blocks after:  $file_used_after
+		echo Hole Length: $hole_length_block
+		echo Blocks already punched out: $total_hole_overlap
+		echo Total blocks that should be punched out from this hole: $hole_length_block
+		err=1
+	fi
+
+
+	#Check the file extents.  There should be no extent present where the hole is
+	if [ $hole_length_block -gt 0 ]; then
+		IFS="
+"
+
+		extents=`filefrag -v $file_name | sed '1,3d' | sed '$d'`
+		for extent in $extents 
+		do
+			ext_num=`echo $extent | cut -c1-4 | tr -d " "`
+			logical_blk=`echo $extent | cut -c5-12 | tr -d " "`
+			phys_blk=`echo $extent | cut -c13-21 | tr -d " "`
+			expct_phys_blk=`echo $extent | cut -c22-30 | tr -d " "`
+			ext_len=`echo $extent | cut -c31-37 | tr -d " "`
+			ext_flags=`echo $extent | cut -c38- | tr -d " "`
+			last_logical_blk=$(( $logical_blk + $ext_len ))
+
+			#check to see if the extent intersects with the hole
+			if	[[ $hole_first_blk -le $logical_blk && $logical_blk -lt $hole_last_blk ]] || \
+				[[ $hole_first_blk -lt $last_logical_blk && $last_logical_blk -le $hole_last_blk ]] || \
+				[[ $logical_blk -le $hole_first_blk && $hole_first_blk -lt $last_logical_blk ]] || \
+				[[ $logical_blk -lt $hole_last_blk && $hole_last_blk -le $last_logical_blk ]]
+			then
+
+				echo File fragmentation shows extents that should have been punched out
+				filefrag -v $file_name
+				echo Bad extent: $extent
+				echo Hole Start Block: $hole_first_blk End Block:$hole_last_blk Length:$hole_length_block
+				err=1	
+			fi
+		done
+	fi
+
+	if [ $err -gt 0 ]; then
+		echo Hole Punch Test Failed
+		status=1
+		exit $err
+	else
+		rm $expected
+		rm $result
+	fi
+
+}
+
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
