Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7RNNIXU116884 for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 18:23:19 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85AE81782ED7
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 16:23:53 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id GH5GEIuaal7UnXjq for
	<xfs@oss.sgi.com>; Fri, 27 Aug 2010 16:23:53 -0700 (PDT)
Message-ID: <4C784908.30802@sandeen.net>
Date: Fri, 27 Aug 2010 18:23:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Test to ensure that the EOFBLOCK_FL gets set/unset
	correctly.
References: <1282941224-5805-1-git-send-email-alal@google.com>
	<4C783305.5060506@sandeen.net>
	<AANLkTi=gRE8=oK2EW6u1LGGUnCEfcrSK7hnWc+mzA1dq@mail.gmail.com>
In-Reply-To: <AANLkTi=gRE8=oK2EW6u1LGGUnCEfcrSK7hnWc+mzA1dq@mail.gmail.com>
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
To: alal@google.com
Cc: xfs@oss.sgi.com

Akshay Lal wrote:
>>> +# Test specific macros.
>>> +BIT_NOT_SET=0   # inode flag - 0x40000 bit is set.
>>> +BIT_SET=1       # inode flag - 0x400000 bit is not set.
>> I'm thinking one of the values in the comment is not right :)
> Duh. Thats silly of me.
> Done.
> 
>>> +# Checks the state of the sample file in the filesystem and returns whether
>>> +# the inode flag 0x400000 is set or not.
>> I guess a little more comment here about why we do this only for ext4 might
>> be good.
>>
>> Just to make it more obvious in the main test could you maybe call
>> it something like _check_ext4_eof_flag() ?  If we ever need to do
>> testing on other filesystems we can adjust it.
> Done.
> 
> 
>>> +        if ((${iflags} & 0x400000)); then
>>> +                echo "EOFBLOCK_FL bit is set."
>> This will cause the test to fail on anything but ext4 because
>> it's expected in the output but only happens for ext4...
>>
>> You could redirect it into $seq.full, just to have it for analysis
>> if the test ever fails.
> I've added an else condition to exit the test with the error message
> that the test is only
> supported on ext4 filesystems.

If you only want to run on ext4, just set _supported_fs ext4

but I think the test is fine to run on other filesystems, it
exercises some boundary conditions, it just doesn't do the low-level
testing for other filesystems.  But that's ok, it's a regression
test specifically for ext4 which can be sanity-checked on other
filesystems.

I'd prefer to keep it a generic test, and only do the low-level
debugfs checks for ext4....

More below.

> I've also redirected all echo messages to $seq.full
> 
> 
>>> +        # Run fsck on the fs. fsck -t ${FSTYP} -fn ${TEST_DEV}.
>>> +        _check_test_fs
>> Ah now I see why you didn't call it _check_ext4_eof_flag() ;)
>>
>> This may not be necessary, the harness runs fsck after each
>> test anyway.  On a large filesystem this could take a pretty
>> long time if you run fsck 6 times.  I'd just drop
>> this and let the post-test-fsck catch any problems.
> Removed.
> 
> ---------------------------------------------------------------------------------------
> Updated patch:
> ---------------------------------------------------------------------------------------
> 
> From f1e8df788e4b93ae33e01c48a859f2b21c425357 Mon Sep 17 00:00:00 2001
> From: Akshay Lal <alal@google.com>
> Date: Fri, 27 Aug 2010 13:14:18 -0700
> Subject: [PATCH] Test to ensure that the EOFBLOCK_FL gets set/unset correctly.
>  As found by Theodore Ts'o:
>  If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
>  write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
>  This forces e2fsck to complain about that inode.
> 
> Bug reference:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
> ---
>  243     |  157 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  243.out |   13 +++++
>  group   |    1 +
>  3 files changed, 171 insertions(+), 0 deletions(-)
>  create mode 100644 243
>  create mode 100644 243.out
> 
> diff --git a/243 b/243
> new file mode 100644
> index 0000000..804513f
> --- /dev/null
> +++ b/243
> @@ -0,0 +1,157 @@
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
> +# Ref: http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
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
> +BIT_NOT_SET=0   # inode flag - 0x40000 bit is not set.
> +BIT_SET=1       # inode flag - 0x400000 bit is set.

still different ;)

> +
> +# Generic test cleanup function.
> +_cleanup()
> +{
> +   cd /
> +   rm -f $tmp.*
> +}
> +
> +# Ext4 uses the EOFBLOCKS_FL bit when fallocating blocks with KEEP_SIZE
> +# enabled. The only time this bit should be set is when extending the allocated
> +# blocks further than what the i_size represents. In the situations wherein the
> +# i_size covers all allocated blocks, this bit should be cleared.
> +
> +# Checks the state of the sample file in the filesystem and returns whether
> +# the inode flag 0x400000 is set or not.
> +_check_ext4_eof_flag()
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
> +                echo "iFlags value was not parsed successfully." >> $seq.full
> +                status=1
> +                exit ${status}
> +        fi
> +
> +        # Check if EOFBLOCKS_FL is set.
> +        if ((${iflags} & 0x400000)); then
> +                echo "EOFBLOCK_FL bit is set." >> $seq.full
> +                bit_set=1
> +        else
> +                echo "EOFBLOCK_FL bit is not set." >> $seq.full
> +                bit_set=0
> +        fi
> +
> +        # Check current bit state to expected value.
> +        if [ ${bit_set} -ne ${2} ]; then
> +                echo "Error: Current bit state incorrect." >> $seq.full
> +                exit ${status}
> +        fi
> +
> +        # Mount the ${TEST_DEV}
> +        mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
> +   else
> +     echo "Only EXT4 filesystems supported." >> $seq.full
> +     status=1
> +     exit ${status}

this will make it -fail- on other filesystems, at worst we want to
not run, but in reality we can just skip the debugfs steps for non-ext4
and do the quick checks on other filesystems, with the built-in fsck
backing us up.

So I'd just say "if not ext4 return" and then let the rest
of the function do the ext4 checking.

(FYI if/when you ever do want to bail like above, you can either:

_notrun "Sorry, Dave, I'm afraid I can't do that"

or

_fail "Something terrible has gone wrong!"

and the user will see the results during the test run and
get the right test status)

> +  fi
> +}
> +
> +# Get standard environment, filters and checks.
> +. ./common.rc
> +. ./common.filter
> +
> +# Prerequisites for the test run.
> +_supported_fs generic

so you have "generic" supported but it fails on non-ext4 now ;)

Really you probably want to have:

_supported_fs ext4 xfs btrfs gfs2

since those are the ones which support preallocation.

(sorry, I didn't catch that the first time)

-Eric

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
> +echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f                    \
> +  -c 'falloc -k 0 40960'                \
> +  -c 'pwrite 0 4096'                    \
> +  ${TEST_DIR}/test_1 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_1 ${BIT_SET}
> +
> +# Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io).
> +echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f -d                 \
> +  -c 'falloc -k 0 40960'                \
> +  -c 'pwrite 0 4096'                    \
> +  ${TEST_DIR}/test_2 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_2 ${BIT_SET}
> +
> +# Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io).
> +echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f                    \
> +  -c 'falloc -k 0 40960'                \
> +  -c 'pwrite 0 40960'                   \
> +  ${TEST_DIR}/test_3 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_3 ${BIT_NOT_SET}
> +
> +# Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io).
> +echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f -d                 \
> +  -c 'falloc -k 0 40960'                \
> +  -c 'pwrite 0 40960'                   \
> +  ${TEST_DIR}/test_4 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_4 ${BIT_NOT_SET}
> +
> +# Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io).
> +echo "Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f                    \
> +  -c 'falloc -k 0 128k'                 \
> +  -c 'pwrite 256k 4k'                   \
> +  ${TEST_DIR}/test_5 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_5 ${BIT_NOT_SET}
> +
> +# Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io).
> +echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f -d                 \
> +  -c 'falloc -k 0 128k'                 \
> +  -c 'pwrite 256k 4k'                   \
> +  ${TEST_DIR}/test_6 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_6 ${BIT_NOT_SET}
> +
> +
> +status=0
> +exit ${status}
> diff --git a/243.out b/243.out
> new file mode 100644
> index 0000000..290a005
> --- /dev/null
> +++ b/243.out
> @@ -0,0 +1,13 @@
> +QA output created by 243
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 40960/40960 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 40960/40960 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 4096/4096 bytes at offset 262144
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 4096/4096 bytes at offset 262144
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
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
