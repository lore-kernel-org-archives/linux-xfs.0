Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2476BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 18:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07AA361AFF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 18:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhKQSEG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Nov 2021 13:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhKQSEE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Nov 2021 13:04:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E155C61AF7;
        Wed, 17 Nov 2021 18:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637172066;
        bh=Syaly6nBNHhb0tkGR6oGFi1/9hm37Fw07JGggM5cFtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RlZDxlCpFCib8yy8xFLBRHU7OXtV84NJFw47+YjeN2Ly34fb1DESaNs135aoOuGx0
         nXb2kRZ4vASpbAGIGY5l+Xa3IeUs8ReBmKHBjZqthYgg6KtiRcGoS8clKZ3ZQdNJN1
         uo+eyz25WDltWe1WwC4Tvxf9x6ORaNHCaYDifBDmtdQLcYFb/F6sy09mrlg2Eju4Rz
         baGI5IFCvw/31yL8fULYpUKHwTXzrCephCI8NWmNJX4Xcx45xvXFHdDYnxOz59NVkJ
         +EJe6mUgXHDyW9NKmiE9J6D98sOh0L7QuhZmNm21gjy8MbdoGXGwrIg2rINGgOsUph
         Gofb5Oisi6Q8w==
Date:   Wed, 17 Nov 2021 10:01:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] tests/xfs: test COW writeback failure when
 overlapping non-shared blocks
Message-ID: <20211117180105.GP24282@magnolia>
References: <20211025130053.8343-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025130053.8343-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 25, 2021 at 09:00:53AM -0400, Brian Foster wrote:
> Test that COW writeback that overlaps non-shared delalloc blocks
> does not leave around stale delalloc blocks on I/O failure. This
> triggers assert failures and free space accounting corruption on
> XFS.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v2:
> - Explicitly set COW extent size hint.
> - Move to tests/xfs.
> - Various minor cleanups.
> v1: https://lore.kernel.org/fstests/20211021163959.1887011-1-bfoster@redhat.com/
> 
>  tests/xfs/999     | 62 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |  2 ++
>  2 files changed, 64 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..f27972bc
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# Test that COW writeback that overlaps non-shared delalloc blocks does not
> +# leave around stale delalloc blocks on I/O failure. This triggers assert
> +# failures and free space accounting corruption on XFS.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick clone
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +# Import common functions.
> +. ./common/reflink
> +. ./common/dmflakey
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch_reflink
> +_require_cp_reflink
> +_require_xfs_io_command "cowextsize"
> +_require_flakey_with_error_writes
> +
> +_scratch_mkfs >> $seqres.full
> +_init_flakey
> +_mount_flakey
> +
> +blksz=$(_get_file_block_size $SCRATCH_MNT)
> +
> +# Set the COW extent size hint to guarantee COW fork preallocation occurs over a
> +# bordering block offset.
> +$XFS_IO_PROG -c "cowextsize $((blksz * 2))" $SCRATCH_MNT >> $seqres.full
> +
> +# create two files that share a single block
> +$XFS_IO_PROG -fc "pwrite $blksz $blksz" $SCRATCH_MNT/file1 >> $seqres.full
> +_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
> +
> +# Perform a buffered write across the shared and non-shared blocks. On XFS, this
> +# creates a COW fork extent that covers the shared block as well as the just
> +# created non-shared delalloc block. Fail the writeback to verify that all
> +# delayed allocation is cleaned up properly.
> +_load_flakey_table $FLAKEY_ERROR_WRITES
> +$XFS_IO_PROG -c "pwrite 0 $((blksz * 2))" \
> +	-c fsync $SCRATCH_MNT/file2 >> $seqres.full
> +_load_flakey_table $FLAKEY_ALLOW_WRITES

Hmm.  So I've been running this test in my djwong-dev tree and hit this
last night:

--- xfs/999.out
+++ xfs/999.out.bad
@@ -1,2 +1,3 @@
 QA output created by 999
-fsync: Input/output error
+stat: Input/output error
+cp: failed to access '/opt/file3': Input/output error

Digging into the kernel log, I see this happen:

[10240.821719] XFS (dm-0): Mounting V5 Filesystem
[10240.855461] XFS (dm-0): Ending clean mount
[10240.857030] XFS (dm-0): Quotacheck needed: Please wait.
[10240.860095] XFS (dm-0): Quotacheck: Done.
[10240.977055] XFS (dm-0): log I/O error -5
[10240.977459] XFS (dm-0): Log I/O Error (0x2) detected at xlog_ioend_work+0x5f/0xb0 [xfs] (fs/xfs/xfs_log.c:1377).  Shutting down filesystem.
[10240.978682] XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
[10241.044886] XFS (dm-0): Unmounting Filesystem

I guess the log tried to checkpoint for the brief window where the
flakey table was enabled, and shut down the whole fs?  I don't have any
good ideas for how to solve this, though.

Hm.  What if you did something like:

$XFS_IO_PROG -c 'pwrite...' $SCRATCH_MNT/file2
_load_flakey_table $FLAKEY_ERROR_WRITES
$XFS_IO_PROG -c 'sync_range -wa' $SCRATCH_MNT/file2
+_load_flakey_table $FLAKEY_ALLOW_WRITES

to constrain the window in which disk write will fail?  Seeing as s_f_r
doesn't actually tell the fs to flush its own metadata or anything.

(Yikes, did I finally find a use for sync_file_range??)

--D

> +
> +# Try a post-fail reflink and then unmount. Both of these are known to produce
> +# errors and/or assert failures on XFS if we trip over a stale delalloc block.
> +_cp_reflink $SCRATCH_MNT/file2 $SCRATCH_MNT/file3
> +_unmount_flakey
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..88b69c4c
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +fsync: Input/output error
> -- 
> 2.31.1
> 
