Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbeHUTRo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Aug 2018 15:17:44 -0400
MIME-Version: 1.0
In-Reply-To: <20180819231126.GU2234@dastard>
References: <20180817083924.16916-1-fdmanana@kernel.org> <20180819231126.GU2234@dastard>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 21 Aug 2018 16:57:00 +0100
Message-ID: <CAL3q7H5Y-86eXNr_nfKokE0gr6evyk4GuKwn-YJMv7WdJ_4L3g@mail.gmail.com>
Subject: Re: [PATCH] generic: test for deduplication between different files
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: fstests <fstests@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org

On Mon, Aug 20, 2018 at 12:11 AM, Dave Chinner <david@fromorbit.com> wrote:
> [cc linux-xfs@vger.kernel.org]
>
> On Fri, Aug 17, 2018 at 09:39:24AM +0100, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Test that deduplication of an entire file that has a size that is not
>> aligned to the filesystem's block size into a different file does not
>> corrupt the destination's file data.
>>
>> This test is motivated by a bug found in Btrfs which is fixed by the
>> following patch for the linux kernel:
>>
>>   "Btrfs: fix data corruption when deduplicating between different files"
>>
>> XFS also fails this test, at least as of linux kernel 4.18-rc7, exactly
>> with the same corruption as in Btrfs - some bytes of a block get replaced
>> with zeroes after the deduplication.
>
> Filipe, in future can please report XFS bugs you find to the XFS
> list the moment you find them. We shouldn't ever find out about a
> data corruption bug we need to fix via a "oh, by the way" comment in
> a commit message for a regression test....

I actually intended to add linux-xfs in CC, but I clearly forgot to do it.

>
> Cheers,
>
> Dave.
>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  tests/generic/505     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/generic/505.out | 33 ++++++++++++++++++++
>>  tests/generic/group   |  1 +
>>  3 files changed, 118 insertions(+)
>>  create mode 100755 tests/generic/505
>>  create mode 100644 tests/generic/505.out
>>
>> diff --git a/tests/generic/505 b/tests/generic/505
>> new file mode 100755
>> index 00000000..5ee232a2
>> --- /dev/null
>> +++ b/tests/generic/505
>> @@ -0,0 +1,84 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
>> +#
>> +# FS QA Test No. 505
>> +#
>> +# Test that deduplication of an entire file that has a size that is not aligned
>> +# to the filesystem's block size into a different file does not corrupt the
>> +# destination's file data.
>> +#
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +tmp=/tmp/$$
>> +status=1     # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +     cd /
>> +     rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/reflink
>> +
>> +# real QA test starts here
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_scratch_dedupe
>> +
>> +rm -f $seqres.full
>> +
>> +_scratch_mkfs >>$seqres.full 2>&1
>> +_scratch_mount
>> +
>> +# The first byte with a value of 0xae starts at an offset (2518890) which is not
>> +# a multiple of the block size.
>> +$XFS_IO_PROG -f \
>> +     -c "pwrite -S 0x6b 0 2518890" \
>> +     -c "pwrite -S 0xae 2518890 102398" \
>> +     $SCRATCH_MNT/foo | _filter_xfs_io
>> +
>> +# Create a second file with a length not aligned to the block size, whose bytes
>> +# all have the value 0x6b, so that its extent(s) can be deduplicated with the
>> +# first file.
>> +$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 557771" $SCRATCH_MNT/bar | _filter_xfs_io
>> +
>> +# The file is filled with bytes having the value 0x6b from offset 0 to offset
>> +# 2518889 and with the value 0xae from offset 2518890 to offset 2621287.
>> +echo "File content before deduplication:"
>> +od -t x1 $SCRATCH_MNT/foo
>> +
>> +# Now deduplicate the entire second file into a range of the first file that
>> +# also has all bytes with the value 0x6b. The destination range's end offset
>> +# must not be aligned to the block size and must be less then the offset of
>> +# the first byte with the value 0xae (byte at offset 2518890).
>> +$XFS_IO_PROG -c "dedupe $SCRATCH_MNT/bar 0 1957888 557771" $SCRATCH_MNT/foo \
>> +     | _filter_xfs_io
>> +
>> +# The bytes in the range starting at offset 2515659 (end of the deduplication
>> +# range) and ending at offset 2519040 (start offset rounded up to the block
>> +# size) must all have the value 0xae (and not replaced with 0x00 values).
>> +# In other words, we should have exactly the same data we had before we asked
>> +# for deduplication.
>> +echo "File content after deduplication and before unmounting:"
>> +od -t x1 $SCRATCH_MNT/foo
>> +
>> +# Unmount the filesystem and mount it again. This guarantees any file data in
>> +# the page cache is dropped.
>> +_scratch_cycle_mount
>> +
>> +# The bytes in the range starting at offset 2515659 (end of the deduplication
>> +# range) and ending at offset 2519040 (start offset rounded up to the block
>> +# size) must all have the value 0xae (and not replaced with 0x00 values).
>> +# In other words, we should have exactly the same data we had before we asked
>> +# for deduplication.
>> +echo "File content after unmounting:"
>> +od -t x1 $SCRATCH_MNT/foo
>> +
>> +status=0
>> +exit
>> diff --git a/tests/generic/505.out b/tests/generic/505.out
>> new file mode 100644
>> index 00000000..7556b9fb
>> --- /dev/null
>> +++ b/tests/generic/505.out
>> @@ -0,0 +1,33 @@
>> +QA output created by 505
>> +wrote 2518890/2518890 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 102398/102398 bytes at offset 2518890
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 557771/557771 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +File content before deduplication:
>> +0000000 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> +*
>> +11467540 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ae ae ae ae ae ae
>> +11467560 ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae
>> +*
>> +11777540 ae ae ae ae ae ae ae ae
>> +11777550
>> +deduped 557771/557771 bytes at offset 1957888
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +File content after deduplication and before unmounting:
>> +0000000 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> +*
>> +11467540 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ae ae ae ae ae ae
>> +11467560 ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae
>> +*
>> +11777540 ae ae ae ae ae ae ae ae
>> +11777550
>> +File content after unmounting:
>> +0000000 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>> +*
>> +11467540 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ae ae ae ae ae ae
>> +11467560 ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae ae
>> +*
>> +11777540 ae ae ae ae ae ae ae ae
>> +11777550
>> diff --git a/tests/generic/group b/tests/generic/group
>> index 55155de8..2ff1bd7e 100644
>> --- a/tests/generic/group
>> +++ b/tests/generic/group
>> @@ -507,3 +507,4 @@
>>  502 auto quick log
>>  503 auto quick dax punch collapse zero
>>  504 auto quick locks
>> +505 auto quick clone dedupe
>> --
>> 2.11.0
>>
>>
>
> --
> Dave Chinner
> david@fromorbit.com
