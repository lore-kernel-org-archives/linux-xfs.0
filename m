Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DBEC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 18:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A8B1611C7
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 18:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhJUSmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 14:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhJUSmV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Oct 2021 14:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E095611CE;
        Thu, 21 Oct 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634841605;
        bh=dcgcKm67LjtMLgr8bSW4wZ6zVXrA5S6scsLkpALv/WM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZeJOdX0guhVLGL62v7t7TlzliMVhJU/66b6pa/qPAYwYYwmnEB44fmY2cB3ni0HqG
         HBsI0rCTmz++Ol0qmwctyQ/XdXSYqW3UAqwJ/G+YuiXgx1LeJSKoq8NPS8OfgyR4io
         diSTn92cOtzwoYHloaQfNY6ftGcQ7pF/096fBO70Kwm5Qe+Hbmsqf3zdsA+zK1hBZs
         33NDa6m3cnXeyvGud84mn9oE39FtIydOsh6gR2nP7hSSV0SgGPkMinv5bOwdr6nXki
         3v2RHZavc802DzAEZAL0cwOowr/sBOSEoFrzLoJ+a5asoRk8Imp1HeHV/ZkyajDJeo
         QrkaPNbtPhZJw==
Date:   Thu, 21 Oct 2021 11:40:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: test COW writeback failure when overlapping
 non-shared blocks
Message-ID: <20211021184005.GV24307@magnolia>
References: <20211021163959.1887011-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021163959.1887011-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 21, 2021 at 12:39:59PM -0400, Brian Foster wrote:
> Test that COW writeback that overlaps non-shared delalloc blocks
> does not leave around stale delalloc blocks on I/O failure. This
> triggers assert failures and free space accounting corruption on
> XFS.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This test targets the problem addressed by the following patch in XFS:
> 
> https://lore.kernel.org/linux-xfs/20211021163330.1886516-1-bfoster@redhat.com/
> 
> Brian
> 
>  tests/generic/651     | 53 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/651.out |  2 ++
>  2 files changed, 55 insertions(+)
>  create mode 100755 tests/generic/651
>  create mode 100644 tests/generic/651.out
> 
> diff --git a/tests/generic/651 b/tests/generic/651
> new file mode 100755
> index 00000000..8d4e6728
> --- /dev/null
> +++ b/tests/generic/651
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 651
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
> +_supported_fs generic
> +_require_scratch_reflink
> +_require_flakey_with_error_writes

_require_cp_reflink

> +
> +_scratch_mkfs >> $seqres.full
> +_init_flakey
> +_mount_flakey
> +
> +# create two files that share a single block
> +$XFS_IO_PROG -fc "pwrite 4k 4k" $SCRATCH_MNT/file1 >> $seqres.full

Please use:

blksz=$(_get_file_block_size $SCRATCH_MNT)
$XFS_IO_PROG -fc "pwrite $blksz $blksz" $SCRATCH_MNT/file1 >> $seqres.full

So that this test will work properly on filesystems with bs > 4k.

> +cp --reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2

Nit: This could be shortened to use the _cp_reflink helper, though it
doesn't really matter to me if you do.

> +# Perform a buffered write across the shared and non-shared blocks. On XFS, this
> +# creates a COW fork extent that covers the shared block as well as the just

Ah, the reason why there's a cow fork extent covering the delalloc
reservation is due to the default cow extent size hint, right?  In that
case, you need:

_require_xfs_io_command "cowextsize"
$XFS_IO_PROG -c "cowextsize 0" $SCRATCH_MNT >> $seqres.full

to ensure that the speculative cow preallocation actually gets set up.
Otherwise, I think test won't reproduce the bug if the test config has
-d cowextsize=1 in the mkfs options.

> +# created non-shared delalloc block. Fail the writeback to verify that all
> +# delayed allocation is cleaned up properly.
> +_load_flakey_table $FLAKEY_ERROR_WRITES
> +$XFS_IO_PROG -c "pwrite 0 8k" -c fsync $SCRATCH_MNT/file2 >> $seqres.full

$((2 * blksz)), not 8k

Other than that, this looks reasonable to me.  I'll go look at the fix
patch now. :)

--D

> +_load_flakey_table $FLAKEY_ALLOW_WRITES
> +
> +# Try a post-fail reflink and then unmount. Both of these are known to produce
> +# errors and/or assert failures on XFS if we trip over a stale delalloc block.
> +cp --reflink $SCRATCH_MNT/file2 $SCRATCH_MNT/file3
> +_unmount_flakey
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/651.out b/tests/generic/651.out
> new file mode 100644
> index 00000000..bd44c80c
> --- /dev/null
> +++ b/tests/generic/651.out
> @@ -0,0 +1,2 @@
> +QA output created by 651
> +fsync: Input/output error
> -- 
> 2.31.1
> 
