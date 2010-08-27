Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7RLnT55113710 for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 16:49:29 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52A1B2EE72
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 14:49:58 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 50cK1SfyEudsTug7 for
	<xfs@oss.sgi.com>; Fri, 27 Aug 2010 14:49:58 -0700 (PDT)
Message-ID: <4C783305.5060506@sandeen.net>
Date: Fri, 27 Aug 2010 16:49:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Test to ensure that the EOFBLOCK_FL gets set/unset
	correctly.
References: <1282941224-5805-1-git-send-email-alal@google.com>
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

Akshay Lal wrote:

> As found by Theodore Ts'o: If a 128K file is falloc'ed using the
> KEEP_SIZE flag, and then write exactly 128K, the EOFBLOCK_FL doesn't
> get cleared correctly. This forces e2fsck to complain about that
> inode.

Thanks, a few comments below...

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

I'm thinking one of the values in the comment is not right :)

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

I guess a little more comment here about why we do this only for ext4 might
be good.

Just to make it more obvious in the main test could you maybe call
it something like _check_ext4_eof_flag() ?  If we ever need to do
testing on other filesystems we can adjust it.

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

This will cause the test to fail on anything but ext4 because
it's expected in the output but only happens for ext4...

You could redirect it into $seq.full, just to have it for analysis
if the test ever fails.

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
> +        fi
> +
> +        # Mount the ${TEST_DEV}
> +        mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
> +   else
> +        # Run fsck on the fs. fsck -t ${FSTYP} -fn ${TEST_DEV}.
> +        _check_test_fs

Ah now I see why you didn't call it _check_ext4_eof_flag() ;)

This may not be necessary, the harness runs fsck after each 
test anyway.  On a large filesystem this could take a pretty
long time if you run fsck 6 times.  I'd just drop
this and let the post-test-fsck catch any problems.

> +   fi
> +
> +   # Remove test file
> +   rm -f ${TEST_DIR}/${1}

... but I suppose you'd need to leave the files around for that to work,
which is fine; the test_dir is supposed to age anyway.

Thanks,
-Eric

> +}
> +
> +# Get standard environment, filters and checks.
> +. ./common.rc
> +. ./common.filter
> +
> +# Prerequisites for the test run.
> +_supported_fs generic
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
