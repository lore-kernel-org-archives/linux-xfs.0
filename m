Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38039 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfCWIXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Mar 2019 04:23:50 -0400
Date: Sat, 23 Mar 2019 16:23:39 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] generic: test stale data exposure after writeback crash
Message-ID: <20190323082339.GR2824@desktop>
References: <20190318172216.20098-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318172216.20098-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Mar 18, 2019 at 01:22:16PM -0400, Brian Foster wrote:
> XFS has historically had a stale data exposure window if a crash
> occurs after a delalloc->physical extent conversion but before
> writeback completes to the associated extent. While this should be a
> rare occurrence in production environments due to typical writeback
> ordering and such, it is not guaranteed in all cases until data
> extents are initialized as unwritten (or otherwise zeroed) before
> they are written.
> 
> Add a test that performs selective writeback ordering to reproduce
> stale data exposure after a crash. Note that this test currently
> fails on XFS.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> As noted in the commit log, this test currently fails on XFS. I think
> it's worth considering regardless because we're pretty close to fixing
> this problem in the kernel. Darrick has posted a patch[1] that while
> apparently still needs a bit of work to accommodate performance
> concerns, does allow XFS to pass this test.
> 
> Thoughts, reviews, flames appreciated.
> 
> Brian
> 
> [1] https://marc.info/?l=linux-xfs&m=155259894926863&w=2
> 
>  tests/generic/999     | 70 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out | 13 ++++++++
>  tests/generic/group   |  1 +
>  3 files changed, 84 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..46c85d07
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,70 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# Test a some write patterns for stale data exposure after a crash.  XFS is
> +# historically susceptible to this problem in the window between delalloc to
> +# physical extent conversion and writeback completion.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_scratch_shutdown
> +
> +# create a small fs and initialize free blocks with a unique pattern
> +_scratch_mkfs_sized $((1024 * 1024 * 100)) >> $seqres.full 2>&1
> +_scratch_mount
> +$XFS_IO_PROG -f -c "pwrite -S 0xab 0 100m" -c fsync $SCRATCH_MNT/spc \
> +	>> $seqres.full 2>&1
> +rm -f $SCRATCH_MNT/spc
> +$XFS_IO_PROG -c fsync $SCRATCH_MNT
> +
> +# Write a couple files with particular writeback sequences. The first writes a
> +# delalloc extent and triggers writeback on the last page. The second triggers
> +# post-eof preallocation (on XFS), write extends into the preallocation and
> +# triggers writeback of the last written page.
> +$XFS_IO_PROG -fc "pwrite 0 64k" -c "sync_range -w 60k 4k" \
> +	-c "sync_range -a 60k 4k" $SCRATCH_MNT/file.1 >> $seqres.full 2>&1

I suspect that on hosts with 64k pagesize, the sync_range call will
write the whole page back and we see no zero after shutdown, but I don't
have the hardware to test..

Also, 0-60k being zero only happens if delalloc is enabled, so testing
on ext4 with "nodelalloc" mount option fails the test. Perhaps we could
skip the test on ext4 if "nodelalloc" is given in mount option.

> +$XFS_IO_PROG -fc "pwrite 0 68k" -c fsync -c "pwrite 96k 4k" \
> +	-c "sync_range -w 96k 4k" -c "sync_range -a 96k 4k" \
> +	$SCRATCH_MNT/file.2 >> $seqres.full 2>&1
> +
> +# Shut down before any other writeback completes. Flush the log to persist inode
> +# size updates.
> +_scratch_shutdown -f
> +
> +# Now dump both files. The region prior to the last page in the first file
> +# should be zero filled. The region between the two writes to the second file
> +# should also be zero filled.
> +_scratch_cycle_mount
> +hexdump $SCRATCH_MNT/file.1
> +hexdump $SCRATCH_MNT/file.2
> +
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..db3c5b7e
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,13 @@
> +QA output created by 999
> +0000000 0000 0000 0000 0000 0000 0000 0000 0000
> +*
> +000f000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> +*
> +0010000
> +0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> +*
> +0011000 0000 0000 0000 0000 0000 0000 0000 0000
> +*
> +0018000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> +*
> +0019000
> diff --git a/tests/generic/group b/tests/generic/group
> index 78b9b45d..aa4734af 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -538,3 +538,4 @@
>  533 auto quick attr
>  534 auto quick log
>  535 auto quick log
> +999 auto quick rw

Also in 'shutdown' group.

Thanks,
Eryu
> -- 
> 2.17.2
> 
