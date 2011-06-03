Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53JHWgw029758 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 14:17:32 -0500
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F23CB72FAF3
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 12:17:31 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id gkBJc7gFxtfPCFoC for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2011 12:17:31 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p53J5qNL012568
	for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 13:05:52 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p53JHKVO078976 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 13:17:22 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p53DHJOE008886
	for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 07:17:19 -0600
Message-ID: <4DE9333F.2020901@linux.vnet.ibm.com>
Date: Fri, 03 Jun 2011 12:17:19 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Fwd: Re: [XFSTEST Add Fallocate Punch Hole Tests 2/3 v4] Expand 252
	punch hole test to cover additional corner cases
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
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>



-------- Original Message --------
Subject: Re: [XFSTEST Add Fallocate Punch Hole Tests 2/3 v4] Expand 252 punch hole test to cover additional corner cases
Date: Wed, 01 Jun 2011 16:01:42 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
To: xfs-oss <xfs@oss.sgi.com>

On 5/25/2011 7:34 PM, Allison Henderson wrote:
> This patch adds additional punch hole tests to 252
> that were used to test ext4 punch hole. The _test_generic_punch
> routine has been modified to accept two new flags:
>
> -k To keep the test file between tests.
>     This will test the handling of existing holes
>
> -d To not sync the file between tests.
>     This will test the handling of delayed extents
>
> Four new corner cases have also been added to the routine:
> 14. data ->  hole @ EOF
> 15. data ->  hole @ 0
> 16. data ->  cache cold ->hole
> 17. data ->  hole in single block file
>
>
> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>
> ---
> :100755 100755 dfdf3f8... 5efa243... M	252
> :100644 100644 cd8e4b4... 930c924... M	252.out
> :100644 100644 e2da5d8... ddf63b0... M	common.punch
>   252          |   10 +++
>   252.out      |  192 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   common.punch |  150 ++++++++++++++++++++++++++++++++++++++-------
>   3 files changed, 330 insertions(+), 22 deletions(-)
>
> diff --git a/252 b/252
> index dfdf3f8..5efa243 100755
> --- a/252
> +++ b/252
> @@ -52,6 +52,16 @@ _require_xfs_io_fiemap
>
>   testfile=$TEST_DIR/252.$$
>
> +# Standard punch hole tests
>   _test_generic_punch falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
>
> +# Delayed allocation punch hole tests
> +_test_generic_punch -d falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
> +
> +# Multi hole punch tests
> +_test_generic_punch -k falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
> +
> +# Delayed allocation multi punch hole tests
> +_test_generic_punch -d -k falloc fpunch fpunch fiemap _filter_fiemap $testfile -F
> +
>   status=0 ; exit
> diff --git a/252.out b/252.out
> index cd8e4b4..930c924 100644
> --- a/252.out
> +++ b/252.out
> @@ -45,3 +45,195 @@ QA output created by 252
>   0: [0..7]: data
>   1: [8..31]: hole
>   2: [32..39]: data
> +	14. data ->  hole @ EOF
> +0: [0..23]: data
> +1: [24..39]: hole
> +	15. data ->  hole @ 0
> +0: [0..15]: hole
> +1: [16..39]: data
> +	16. data ->  cache cold ->hole
> +0: [0..15]: hole
> +1: [16..39]: data
> +	17. data ->  hole in single block file
> +0: [0..7]: data
> +	1. into a hole
> +	2. into allocated space
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	3. into unwritten space
> +0: [0..7]: unwritten
> +1: [8..23]: hole
> +2: [24..39]: unwritten
> +	4. hole ->  data
> +0: [0..23]: hole
> +1: [24..31]: data
> +2: [32..39]: hole
> +	5. hole ->  unwritten
> +0: [0..23]: hole
> +1: [24..31]: unwritten
> +2: [32..39]: hole
> +	6. data ->  hole
> +0: [0..7]: data
> +1: [8..39]: hole
> +	7. data ->  unwritten
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..31]: unwritten
> +3: [32..39]: hole
> +	8. unwritten ->  hole
> +0: [0..7]: unwritten
> +1: [8..39]: hole
> +	9. unwritten ->  data
> +0: [0..7]: unwritten
> +1: [8..23]: hole
> +2: [24..31]: data
> +3: [32..39]: hole
> +	10. hole ->  data ->  hole
> +	11. data ->  hole ->  data
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	12. unwritten ->  data ->  unwritten
> +0: [0..7]: unwritten
> +1: [8..31]: hole
> +2: [32..39]: unwritten
> +	13. data ->  unwritten ->  data
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	14. data ->  hole @ EOF
> +0: [0..23]: data
> +1: [24..39]: hole
> +	15. data ->  hole @ 0
> +0: [0..15]: hole
> +1: [16..39]: data
> +	16. data ->  cache cold ->hole
> +0: [0..15]: hole
> +1: [16..39]: data
> +	17. data ->  hole in single block file
> +0: [0..7]: data
> +	1. into a hole
> +0: [0..7]: data
> +1: [8..39]: hole
> +	2. into allocated space
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	3. into unwritten space
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	4. hole ->  data
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	5. hole ->  unwritten
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	6. data ->  hole
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	7. data ->  unwritten
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	8. unwritten ->  hole
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	9. unwritten ->  data
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	10. hole ->  data ->  hole
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	11. data ->  hole ->  data
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	12. unwritten ->  data ->  unwritten
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	13. data ->  unwritten ->  data
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	14. data ->  hole @ EOF
> +0: [0..23]: data
> +1: [24..39]: hole
> +	15. data ->  hole @ 0
> +0: [0..15]: hole
> +1: [16..39]: data
> +	16. data ->  cache cold ->hole
> +0: [0..15]: hole
> +1: [16..39]: data
> +	17. data ->  hole in single block file
> +0: [0..7]: data
> +	1. into a hole
> +0: [0..7]: data
> +1: [8..39]: hole
> +	2. into allocated space
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	3. into unwritten space
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	4. hole ->  data
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	5. hole ->  unwritten
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	6. data ->  hole
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	7. data ->  unwritten
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	8. unwritten ->  hole
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	9. unwritten ->  data
> +0: [0..7]: data
> +1: [8..23]: hole
> +2: [24..39]: data
> +	10. hole ->  data ->  hole
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	11. data ->  hole ->  data
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	12. unwritten ->  data ->  unwritten
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	13. data ->  unwritten ->  data
> +0: [0..7]: data
> +1: [8..31]: hole
> +2: [32..39]: data
> +	14. data ->  hole @ EOF
> +0: [0..23]: data
> +1: [24..39]: hole
> +	15. data ->  hole @ 0
> +0: [0..15]: hole
> +1: [16..39]: data
> +	16. data ->  cache cold ->hole
> +0: [0..15]: hole
> +1: [16..39]: data
> +	17. data ->  hole in single block file
> +0: [0..7]: data
> diff --git a/common.punch b/common.punch
> index e2da5d8..ddf63b0 100644
> --- a/common.punch
> +++ b/common.punch
> @@ -256,8 +256,39 @@ die_now()
>   #	11. data ->  hole ->  data
>   #	12. unwritten ->  data ->  unwritten
>   #	13. data ->  unwritten ->  data
> +#	14. data ->  hole @ EOF
> +#	15. data ->  hole @ 0
> +#	16. data ->  cache cold ->hole
> +#	17. data ->  hole in single block file
> +#
> +# Test file is removed, created and sync'd between tests.
> +#
> +# Use -k flag to keep the file between tests.  This will
> +# test the handling of pre-existing holes.
> +#
> +# Use the -d flag to not sync the file between tests.
> +# This will test the handling of delayed extents
> +#
>   _test_generic_punch()
>   {
> +
> +	remove_testfile=1
> +	sync_cmd="-c fsync"
> +	OPTIND=1
> +	while getopts 'dk' OPTION
> +	do
> +		case $OPTION in
> +		k)	remove_testfile=
> +		;;
> +		d)	sync_cmd=
> +		;;
> +		?)	echo Invalid flag
> +		exit 1
> +		;;
> +		esac
> +	done
> +	shift $(($OPTIND - 1))
> +
>   	alloc_cmd=$1
>   	punch_cmd=$2
>   	zero_cmd=$3	#if not testing zero just set to punch
> @@ -267,22 +298,28 @@ _test_generic_punch()
>   	xfs_io_opt=$7	#needs to be -F if not testing xfs
>
>   	echo "	1. into a hole"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>   		-c "$zero_cmd 4k 8k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	2. into allocated space"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "pwrite 0 20k" -c "fsync" \
> +		-c "pwrite 0 20k" $sync_cmd \
>   		-c "$zero_cmd 4k 8k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	3. into unwritten space"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>   		-c "$alloc_cmd 0 20k" \
>   		-c "$zero_cmd 4k 8k" \
> @@ -290,15 +327,19 @@ _test_generic_punch()
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	4. hole ->  data"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "pwrite 8k 8k" -c "fsync" \
> +		-c "pwrite 8k 8k" $sync_cmd \
>   		-c "$zero_cmd 4k 8k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	5. hole ->  unwritten"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>   		-c "$alloc_cmd 8k 8k" \
>   		-c "$zero_cmd 4k 8k" \
> @@ -306,24 +347,30 @@ _test_generic_punch()
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	6. data ->  hole"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "pwrite 0 8k" -c "fsync" \
> +		-c "pwrite 0 8k" $sync_cmd \
>   		-c "$zero_cmd 4k 8k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	7. data ->  unwritten"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "pwrite 0 8k" -c "fsync" \
> +		-c "pwrite 0 8k" $sync_cmd \
>   		-c "$alloc_cmd 8k 8k" \
>   		-c "$zero_cmd 4k 8k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	8. unwritten ->  hole"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>   		-c "$alloc_cmd 0 8k" \
>   		-c "$zero_cmd 4k 8k" \
> @@ -331,49 +378,108 @@ _test_generic_punch()
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	9. unwritten ->  data"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>   		-c "$alloc_cmd 0 8k" \
> -		-c "pwrite 8k 8k" -c "fsync" \
> +		-c "pwrite 8k 8k" $sync_cmd \
>   		-c "$zero_cmd 4k 8k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	10. hole ->  data ->  hole"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "pwrite 8k 4k" -c "fsync" \
> +		-c "pwrite 8k 4k" $sync_cmd \
>   		-c "$zero_cmd 4k 12k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	11. data ->  hole ->  data"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>   		-c "$alloc_cmd 0 20k" \
>   		-c "pwrite 0 8k" \
> -		-c "pwrite 12k 8k" -c "fsync" \
> +		-c "pwrite 12k 8k" $sync_cmd \
>   		-c "$punch_cmd 8k 4k" \
>   		-c "$zero_cmd 4k 12k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now
>
>   	echo "	12. unwritten ->  data ->  unwritten"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>   		-c "$alloc_cmd 0 20k" \
> -		-c "pwrite 8k 4k" -c "fsync" \
> +		-c "pwrite 8k 4k" $sync_cmd \
>   		-c "$zero_cmd 4k 12k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now

Hi all,

I had some questions about test 12. The output for this test is:

        12. unwritten -> data -> unwritten
0: [0..7]: unwritten
1: [8..31]: hole
2: [32..39]: unwritten

But ext4 gets data extents here instead of unwritten extents (on the 
first test with the fsync flag on).  I did some investigating and it 
looks like the fsync command causes the extents to be written out before 
the punch hole operation even starts.  So it makes sense to me that it 
should end up with data extents.  Can someone explain why the golden 
output has unwritten extents here? Thx!

Allison Henderson

>
>   	echo "	13. data ->  unwritten ->  data"
> -	rm -f $testfile
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
>   	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>   		-c "$alloc_cmd 0 20k" \
> -		-c "pwrite 0k 8k" -c "fsync" \
> +		-c "pwrite 0k 8k" $sync_cmd \
>   		-c "pwrite 12k 8k" -c "fsync" \
>   		-c "$zero_cmd 4k 12k" \
>   		-c "$map_cmd -v" $testfile | $filter_cmd
>   	[ $? -ne 0 ]&&  die_now
> +
> +	echo "	14. data ->  hole @ EOF"
> +	rm -f $testfile
> +	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +		-c "pwrite 0 20k" $sync_cmd \
> +		-c "$zero_cmd 12k 8k" \
> +		-c "$map_cmd -v" $testfile | $filter_cmd
> +	[ $? -ne 0 ]&&  die_now
> +
> +	echo "	15. data ->  hole @ 0"
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
> +	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +		-c "pwrite 0 20k" $sync_cmd \
> +		-c "$zero_cmd 0k 8k" \
> +		-c "$map_cmd -v" $testfile | $filter_cmd
> +	[ $? -ne 0 ]&&  die_now
> +
> +	echo "	16. data ->  cache cold ->hole"
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +		rm -f $testfile.2
> +	else
> +		cp $testfile $testfile.2
> +	fi
> +	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +		-c "pwrite 8k 12k" -c "fsync" $testfile.2 \
> +		>  /dev/null
> +	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +		-c "pwrite 0 20k" $sync_cmd \
> +		-c "$zero_cmd 0k 8k" \
> +		-c "fadvise -d" \
> +		-c "$map_cmd -v" $testfile | $filter_cmd
> +	diff $testfile $testfile.2
> +	[ $? -ne 0 ]&&  die_now
> +	rm -f $testfile.2
> +
> +	echo "	17. data ->  hole in single block file"
> +	if [ "$remove_testfile" ]; then
> +		rm -f $testfile
> +	fi
> +	block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	$XFS_IO_PROG $xfs_io_opt -f -c "truncate $block_size" \
> +		-c "pwrite 0 $block_size" $sync_cmd \
> +		-c "$zero_cmd 128 128" \
> +		-c "$map_cmd -v" $testfile | $filter_cmd
> +	[ $? -ne 0 ]&&  die_now
> +
>   }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
