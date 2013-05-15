Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 01C1D7F3F
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 08:59:23 -0500 (CDT)
Message-ID: <519394D8.2050005@sgi.com>
Date: Wed, 15 May 2013 08:59:52 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5] xfstests: add a new test case for ext4 indirect-based
	file
References: <1368463235-14478-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1368463235-14478-1-git-send-email-wenqing.lz@taobao.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 05/13/2013 11:40 AM, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> After applied this commit (864688d3), xfstests #255 will not test a
> file system that cannot support fallocate(2), such as a indirect-based
> file in ext4.  So we need to add a new generic test case to test it.
>
> The difference between #255 and this test case is only to use pwrite to
> allocate blocks.  Other filesystems should survive in this test case.
> In the mean time, a new argument '-u' is added into _test_generic_punch
> not to run unwritten tests.
>
> Meanwhile this commit fixes a minor problem in #255 that testfile should
> use $seq.$$ as testfile.
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Eric Sandeen <sandeen@sandeen.net>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Rich Johnston <rjohnston@sgi.com>
> ---
> changelog:
>   * rebase against Eric's patch
>   * remove 'prealloc" from group
>
> Hi Eric,
>
> I take a close look at your patch, and 'xfs_io_opt' has been removed in your
> patch.  I am not sure whether I need to adjust my patch or not.  Please let me
> know if I need to change it.  Currently I only remove '-F' argument from test
> case.
>
> Thanks,
> 						- Zheng
>
>   common/punch          | 164 ++++++++++++++++++++++++++-----------------------
>   tests/generic/255     |   2 +-
>   tests/generic/314     |  67 ++++++++++++++++++++
>   tests/generic/314.out | 165 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/generic/group   |   1 +
>   5 files changed, 323 insertions(+), 76 deletions(-)
>   create mode 100755 tests/generic/314
>   create mode 100644 tests/generic/314.out
>
> diff --git a/common/punch b/common/punch
> index b9f9acd..f1fc92d 100644
> --- a/common/punch
> +++ b/common/punch
> @@ -285,19 +285,25 @@ die_now()
>   # Use the -d flag to not sync the file between tests.
>   # This will test the handling of delayed extents
>   #
> +# Use the -u flag to not run unwritten tests.
> +# This will eliminate some unnecessary information.
> +#
>   _test_generic_punch()
>   {
>
>   	remove_testfile=1
>   	sync_cmd="-c fsync"
> +	unwritten_tests=1
>   	OPTIND=1
> -	while getopts 'dk' OPTION
> +	while getopts 'dku' OPTION
>   	do
>   		case $OPTION in
>   		k)	remove_testfile=
>   		;;
>   		d)	sync_cmd=
>   		;;
> +		u)	unwritten_tests=
> +		;;
>   		?)	echo Invalid flag
>   		exit 1
>   		;;
> @@ -334,16 +340,18 @@ _test_generic_punch()
>   	[ $? -ne 0 ] && die_now
>   	_md5_checksum $testfile
>
> -	echo "	3. into unwritten space"
> -	if [ "$remove_testfile" ]; then
> -		rm -f $testfile
> +	if [ "$unwritten_tests" ]; then
> +		echo "	3. into unwritten space"
> +		if [ "$remove_testfile" ]; then
> +			rm -f $testfile
> +		fi
> +		$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +			-c "$alloc_cmd 0 20k" \
> +			-c "$zero_cmd 4k 8k" \
> +			-c "$map_cmd -v" $testfile | $filter_cmd
> +		[ $? -ne 0 ] && die_now
> +		_md5_checksum $testfile
>   	fi
> -	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "$alloc_cmd 0 20k" \
> -		-c "$zero_cmd 4k 8k" \
> -		-c "$map_cmd -v" $testfile | $filter_cmd
> -	[ $? -ne 0 ] && die_now
> -	_md5_checksum $testfile
>
>   	echo "	4. hole -> data"
>   	if [ "$remove_testfile" ]; then
> @@ -356,16 +364,18 @@ _test_generic_punch()
>   	[ $? -ne 0 ] && die_now
>   	_md5_checksum $testfile
>
> -	echo "	5. hole -> unwritten"
> -	if [ "$remove_testfile" ]; then
> -		rm -f $testfile
> +	if [ "$unwritten_tests" ]; then
> +		echo "	5. hole -> unwritten"
> +		if [ "$remove_testfile" ]; then
> +			rm -f $testfile
> +		fi
> +		$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +			-c "$alloc_cmd 8k 8k" \
> +			-c "$zero_cmd 4k 8k" \
> +			-c "$map_cmd -v" $testfile | $filter_cmd
> +		[ $? -ne 0 ] && die_now
> +		_md5_checksum $testfile
>   	fi
> -	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "$alloc_cmd 8k 8k" \
> -		-c "$zero_cmd 4k 8k" \
> -		-c "$map_cmd -v" $testfile | $filter_cmd
> -	[ $? -ne 0 ] && die_now
> -	_md5_checksum $testfile
>
>   	echo "	6. data -> hole"
>   	if [ "$remove_testfile" ]; then
> @@ -378,40 +388,42 @@ _test_generic_punch()
>   	[ $? -ne 0 ] && die_now
>   	_md5_checksum $testfile
>
> -	echo "	7. data -> unwritten"
> -	if [ "$remove_testfile" ]; then
> -		rm -f $testfile
> -	fi
> -	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "pwrite 0 8k" $sync_cmd \
> -		-c "$alloc_cmd 8k 8k" \
> -		-c "$zero_cmd 4k 8k" \
> -		-c "$map_cmd -v" $testfile | $filter_cmd
> -	[ $? -ne 0 ] && die_now
> -	_md5_checksum $testfile
> -
> -	echo "	8. unwritten -> hole"
> -	if [ "$remove_testfile" ]; then
> -		rm -f $testfile
> -	fi
> -	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "$alloc_cmd 0 8k" \
> -		-c "$zero_cmd 4k 8k" \
> -		-c "$map_cmd -v" $testfile | $filter_cmd
> -	[ $? -ne 0 ] && die_now
> -	_md5_checksum $testfile
> -
> -	echo "	9. unwritten -> data"
> -	if [ "$remove_testfile" ]; then
> -		rm -f $testfile
> +	if [ "$unwritten_tests" ]; then
> +		echo "	7. data -> unwritten"
> +		if [ "$remove_testfile" ]; then
> +			rm -f $testfile
> +		fi
> +		$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +			-c "pwrite 0 8k" $sync_cmd \
> +			-c "$alloc_cmd 8k 8k" \
> +			-c "$zero_cmd 4k 8k" \
> +			-c "$map_cmd -v" $testfile | $filter_cmd
> +		[ $? -ne 0 ] && die_now
> +		_md5_checksum $testfile
> +
> +		echo "	8. unwritten -> hole"
> +		if [ "$remove_testfile" ]; then
> +			rm -f $testfile
> +		fi
> +		$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +			-c "$alloc_cmd 0 8k" \
> +			-c "$zero_cmd 4k 8k" \
> +			-c "$map_cmd -v" $testfile | $filter_cmd
> +		[ $? -ne 0 ] && die_now
> +		_md5_checksum $testfile
> +
> +		echo "	9. unwritten -> data"
> +		if [ "$remove_testfile" ]; then
> +			rm -f $testfile
> +		fi
> +		$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +			-c "$alloc_cmd 0 8k" \
> +			-c "pwrite 8k 8k" $sync_cmd \
> +			-c "$zero_cmd 4k 8k" \
> +			-c "$map_cmd -v" $testfile | $filter_cmd
> +		[ $? -ne 0 ] && die_now
> +		_md5_checksum $testfile
>   	fi
> -	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "$alloc_cmd 0 8k" \
> -		-c "pwrite 8k 8k" $sync_cmd \
> -		-c "$zero_cmd 4k 8k" \
> -		-c "$map_cmd -v" $testfile | $filter_cmd
> -	[ $? -ne 0 ] && die_now
> -	_md5_checksum $testfile
>
>   	echo "	10. hole -> data -> hole"
>   	if [ "$remove_testfile" ]; then
> @@ -438,30 +450,32 @@ _test_generic_punch()
>   	[ $? -ne 0 ] && die_now
>   	_md5_checksum $testfile
>
> -	echo "	12. unwritten -> data -> unwritten"
> -	if [ "$remove_testfile" ]; then
> -		rm -f $testfile
> -	fi
> -	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "$alloc_cmd 0 20k" \
> -		-c "pwrite 8k 4k" $sync_cmd \
> -		-c "$zero_cmd 4k 12k" \
> -		-c "$map_cmd -v" $testfile | $filter_cmd
> -	[ $? -ne 0 ] && die_now
> -	_md5_checksum $testfile
> -
> -	echo "	13. data -> unwritten -> data"
> -	if [ "$remove_testfile" ]; then
> -		rm -f $testfile
> +	if [ "$unwritten_tests" ]; then
> +		echo "	12. unwritten -> data -> unwritten"
> +		if [ "$remove_testfile" ]; then
> +			rm -f $testfile
> +		fi
> +		$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +			-c "$alloc_cmd 0 20k" \
> +			-c "pwrite 8k 4k" $sync_cmd \
> +			-c "$zero_cmd 4k 12k" \
> +			-c "$map_cmd -v" $testfile | $filter_cmd
> +		[ $? -ne 0 ] && die_now
> +		_md5_checksum $testfile
> +
> +		echo "	13. data -> unwritten -> data"
> +		if [ "$remove_testfile" ]; then
> +			rm -f $testfile
> +		fi
> +		$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> +			-c "$alloc_cmd 0 20k" \
> +			-c "pwrite 0k 8k" $sync_cmd \
> +			-c "pwrite 12k 8k" -c "fsync" \
> +			-c "$zero_cmd 4k 12k" \
> +			-c "$map_cmd -v" $testfile | $filter_cmd
> +		[ $? -ne 0 ] && die_now
> +		_md5_checksum $testfile
>   	fi
> -	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> -		-c "$alloc_cmd 0 20k" \
> -		-c "pwrite 0k 8k" $sync_cmd \
> -		-c "pwrite 12k 8k" -c "fsync" \
> -		-c "$zero_cmd 4k 12k" \
> -		-c "$map_cmd -v" $testfile | $filter_cmd
> -	[ $? -ne 0 ] && die_now
> -	_md5_checksum $testfile
>
>   	echo "	14. data -> hole @ EOF"
>   	rm -f $testfile


Hey Zheng,

Thanks for submitting this patch. Looks like this patch does not apply 
cleanly.

--Rich

Applying 
patch..v5-xfstests-add-a-new-test-case-for-ext4-indirect-based-file.patch
error: patch failed: common/punch:334
error: common/punch: patch does not apply
Context reduced to (2/2) to apply fragment at 51
To force apply this patch, use 'guilt push -f'

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
