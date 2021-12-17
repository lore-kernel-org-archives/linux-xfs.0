Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D92C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 17:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239619AbhLQRHC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 12:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbhLQRHC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 12:07:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869BBC061574;
        Fri, 17 Dec 2021 09:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC907CE2597;
        Fri, 17 Dec 2021 17:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81DCC36AE1;
        Fri, 17 Dec 2021 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639760817;
        bh=a48+sPRP2ez+GWMoiUQjK4IcJC/NpLdtFA1qN4JerbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=klYFFJ01+S9tFzq46+5eScuOuxn0nJDB+Di4/Qb5SpdnXt0aUmtKQVe/5MFBgKenX
         3kO14XlUn4LH3yffraImERW24yvMRD3GB6JRHYSj1EbFU9vnpajdod3W80jjApyDje
         DBe7YxEsmK7Ih2N+byGaDMGpB8GVs0nTsVWy41SqZjd71yoYYxE6/JZjvk74o4sb4O
         4+jJ4HspPwYAyYFl2Kl0ybQGuSabhoc3l5mXxWG/NYpMJGcUNwHYV+FxvcgHixGR+Z
         W3u8vRf6hujlFSJaxekAvBvfl0yZt/ndvR8mKrMh3awc8upjvsynTugVbbngYVABKc
         drpc5xLJqotlw==
Date:   Fri, 17 Dec 2021 09:06:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] tests/xfs: test COW writeback failure when
 overlapping non-shared blocks
Message-ID: <20211217170657.GH27664@magnolia>
References: <20211217153234.279540-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217153234.279540-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 17, 2021 at 10:32:34AM -0500, Brian Foster wrote:
> Test that COW writeback that overlaps non-shared delalloc blocks
> does not leave around stale delalloc blocks on I/O failure. This
> triggers assert failures and free space accounting corruption on
> XFS.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v3:
> - Use fsync and sync_range to avoid spurious failure caused by log I/O
>   errors.
> - Add kernel commit reference.
> v2: https://lore.kernel.org/fstests/20211025130053.8343-1-bfoster@redhat.com/
> - Explicitly set COW extent size hint.
> - Move to tests/xfs.
> - Various minor cleanups.
> v1: https://lore.kernel.org/fstests/20211021163959.1887011-1-bfoster@redhat.com/
> 
>  tests/xfs/999     | 67 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |  2 ++
>  2 files changed, 69 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..4308c0da
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# Test that COW writeback that overlaps non-shared delalloc blocks does not
> +# leave around stale delalloc blocks on I/O failure. This triggers assert
> +# failures and free space accounting corruption on XFS. Fixed by upstream kernel
> +# commit 5ca5916b6bc9 ("xfs: punch out data fork delalloc blocks on COW
> +# writeback failure").
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
> +$XFS_IO_PROG -fc "reflink $SCRATCH_MNT/file1" \
> +	-c fsync $SCRATCH_MNT/file2 >> $seqres.full
> +
> +# Perform a buffered write across the shared and non-shared blocks. On XFS, this
> +# creates a COW fork extent that covers the shared block as well as the just
> +# created non-shared delalloc block. Fail the writeback to verify that all
> +# delayed allocation is cleaned up properly.
> +_load_flakey_table $FLAKEY_ERROR_WRITES
> +len=$((blksz * 2))
> +$XFS_IO_PROG -c "pwrite 0 $len" \
> +	-c "sync_range -w 0 $len" $SCRATCH_MNT/file2 \
> +	-c "sync_range -a 0 $len" >> $seqres.full

Nit: put $SCRATCH_MNT/file2 at the end?

Otherwise looks ok to me, so I'll give this one a spin on my test
infrastructure tonight.  In the mean time,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +_load_flakey_table $FLAKEY_ALLOW_WRITES
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
> index 00000000..95d64cf0
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +sync_file_range: Input/output error
> -- 
> 2.31.1
> 
