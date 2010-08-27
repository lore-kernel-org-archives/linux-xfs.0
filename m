Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7RNVk3O117136 for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 18:31:46 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3F791782F39
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 16:32:20 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	2LgV0xamMCFVXlfB for <xfs@oss.sgi.com>;
	Fri, 27 Aug 2010 16:32:20 -0700 (PDT)
Date: Sat, 28 Aug 2010 09:32:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Test to ensure that the EOFBLOCK_FL gets set/unset
	correctly. As found by Theodore Ts'o: If a 128K file is falloc'ed using
	the KEEP_SIZE flag, and then write exactly 128K, the EOFBLOCK_FL doesn't
	get cleared correctly. This forces e2fsck to complain about that inode.
Message-ID: <20100827233216.GJ705@dastard>
References: <1282941224-5805-1-git-send-email-alal@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282941224-5805-1-git-send-email-alal@google.com>
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
To: Akshay Lal <alal@google.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 27, 2010 at 01:33:44PM -0700, Akshay Lal wrote:
> Bug reference:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/20682

The test looks good - a few minor things, though. Firstly Can you
add a brief description rather than just a URL as this forms the
commit message?

> ---
>  243     |  145 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  243.out |   25 +++++++++++
>  group   |    1 +
>  3 files changed, 171 insertions(+), 0 deletions(-)
>  create mode 100644 243
>  create mode 100644 243.out
> 
> diff --git a/243 b/243
> new file mode 100644
> index 0000000..8102f24
> --- /dev/null
> +++ b/243
> @@ -0,0 +1,145 @@
> +#! /bin/bash
> +# FS QA Test No. 243
> +#
> +# Test to ensure that the EOFBLOCK_FL gets set/unset correctly.
> +#
> +# As found by Theodore Ts'o:
> +# If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
> +# write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
> +# This forces e2fsck to complain about that inode.
> +#
> +# creator

Please retain the GPL license text here as per the new test template
and all other tests.

> +owner=alal@google.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1        # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# Test specific macros.
> +BIT_NOT_SET=0   # inode flag - 0x40000 bit is set.
> +BIT_SET=1       # inode flag - 0x400000 bit is not set.
> +
> +# Generic test cleanup function.
> +_cleanup()
> +{
> +   cd /
> +   rm -f $tmp.*
> +}
> +
> +# Checks the state of the sample file in the filesystem and returns whether
> +# the inode flag 0x400000 is set or not.
> +_check_file_state()
> +{
> +   bit_set=1
> +
> +   # Check whether EOFBLOCK_FL is set.
> +   if [ "${FSTYP}" == "ext4" ]; then
> +        # Unmount the ${TEST_DEV}
> +        umount ${TEST_DEV}
> +
> +        # Run debugfs to gather file_parameters - specifically iflags.
> +        file_params=`debugfs ${TEST_DEV} -R "stat ${1}" 2>&1 | grep -e Flags:`
> +        iflags=${file_params#*Flags: }
> +
> +        # Ensure that the iflags value was parsed correctly.
> +        if [ -z ${iflags} ]; then
> +                echo "iFlags value was not parsed successfully."
> +                status=1
> +                exit ${status}
> +        fi
> +
> +        if ((${iflags} & 0x400000)); then
> +                echo "EOFBLOCK_FL bit is set."
> +                bit_set=1
> +        else
> +                echo "EOFBLOCK_FL bit is not set."
> +                bit_set=0
> +        fi
> +
> +        # Check current bit state to expected value.
> +        if [ ${bit_set} -ne ${2} ]; then
> +                echo "Error: Current bit state incorrect."
> +                exit ${status}

That needs to be:

		status=1
		exit

For the cleanup trap to set the exit status correctly.

> +        fi
> +
> +        # Mount the ${TEST_DEV}
> +        mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
> +   else
> +        # Run fsck on the fs. fsck -t ${FSTYP} -fn ${TEST_DEV}.
> +        _check_test_fs
> +   fi
> +
> +   # Remove test file
> +   rm -f ${TEST_DIR}/${1}
> +}
> +
> +# Get standard environment, filters and checks.
> +. ./common.rc
> +. ./common.filter
> +
> +# Prerequisites for the test run.
> +_supported_fs generic

I'm not sure this really is a generic test - it's testing an ext4
specific bug. We've got other generic tests that exercise fallocate,
and some filesystems (like XFS) don't have special bits to say there
are extents beyond EOF and checking a filesystem repeated won't
report any problems.  So perhaps if should be '_supported_fs ext4'

> +_supported_os Linux
> +_require_xfs_io_falloc
> +
> +# Real QA test starts here.
> +rm -f $seq.full
> +
> +# Begin test cases.
> +
> +# Using FALLOC_FL_KEEP_SIZE
> +# Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io).
> +echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)."

No need for the comment and the echo. Just remove the comments.

> +${XFS_IO_PROG} -F -f                            \
> +  -c 'falloc -k 0 40960'                        \
> +  -c 'pwrite 0 4096'                    \
> +  ${TEST_DIR}/test_1 | _filter_xfs_io_unique
> +_check_file_state test_1 ${BIT_SET}
> +
> +# Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io).
> +echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)."
> +${XFS_IO_PROG} -F -f -d                         \
> +  -c 'falloc -k 0 40960'                        \
> +  -c 'pwrite 0 4096'                    \
> +  ${TEST_DIR}/test_2 | _filter_xfs_io_unique
> +_check_file_state test_2 ${BIT_SET}
> +
> +# Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io).
> +echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)."
> +${XFS_IO_PROG} -F -f                            \
> +  -c 'falloc -k 0 40960'                        \
> +  -c 'pwrite 0 40960'                   \
> +  ${TEST_DIR}/test_3 | _filter_xfs_io_unique
> +_check_file_state test_3 ${BIT_NOT_SET}
> +
> +# Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io).
> +echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)."
> +${XFS_IO_PROG} -F -f -d                         \
> +  -c 'falloc -k 0 40960'                        \
> +  -c 'pwrite 0 40960'                   \
> +  ${TEST_DIR}/test_4 | _filter_xfs_io_unique
> +_check_file_state test_4 ${BIT_NOT_SET}
> +
> +# Test 5: Fallocate 128k, seek to 256k and write a 4k block (buffered io).
> +echo "Test 5: Fallocate 128k, seek to 256k and write a 4k block (buffered io)."
> +${XFS_IO_PROG} -F -f                            \
> +  -c 'falloc -k 0 128k'                 \
> +  -c 'pwrite 256k 4k'                   \
> +  ${TEST_DIR}/test_5 | _filter_xfs_io_unique
> +_check_file_state test_5 ${BIT_NOT_SET}
> +
> +# Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io).
> +echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io)."
> +${XFS_IO_PROG} -F -f -d                         \
> +  -c 'falloc -k 0 128k'                 \
> +  -c 'pwrite 256k 4k'                   \
> +  ${TEST_DIR}/test_6 | _filter_xfs_io_unique
> +_check_file_state test_6 ${BIT_NOT_SET}
> +
> +
> +status=0
> +exit ${status}
> diff --git a/243.out b/243.out
> new file mode 100644
> index 0000000..35583e8
> --- /dev/null
> +++ b/243.out
> @@ -0,0 +1,25 @@
> +QA output created by 243
> +Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io).
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +EOFBLOCK_FL bit is set.
> +Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io).
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +EOFBLOCK_FL bit is set.
> +Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io).
> +wrote 40960/40960 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +EOFBLOCK_FL bit is set.
> +Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io).
> +wrote 40960/40960 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +EOFBLOCK_FL bit is set.
> +Test 5: Fallocate 128k, seek to 256k and write a 4k block (buffered io).
> +wrote 4096/4096 bytes at offset 262144
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +EOFBLOCK_FL bit is not set.
> +Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io).
> +wrote 4096/4096 bytes at offset 262144
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +EOFBLOCK_FL bit is not set.
> diff --git a/group b/group
> index ff16bb3..e6dab13 100644
> --- a/group
> +++ b/group
> @@ -356,3 +356,4 @@ deprecated
>  240 auto aio quick rw
>  241 auto
>  242 auto quick prealloc
> +243 auto quick prealloc
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
