Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBF6C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Oct 2021 16:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3BE660EFF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Oct 2021 16:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhJYQMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Oct 2021 12:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhJYQMp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Oct 2021 12:12:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99B2160C41;
        Mon, 25 Oct 2021 16:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635178222;
        bh=jq/w1O54hjmInpMBBlL1vX5HQHF/OnwNZl0dfqObay0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HBsV0Cc3gxiWhSpiuquM7PZZRlaFWe0ec0Vy3UyTL8c2Mk6szQbN8UCKMFNbJQ5+s
         pholuj38A1CvgjEd8e1CSiS2ndoqW7Jcz1d8YTYoCxAMwyPw30QROYOQQnrUeGaqsw
         n8P+gFTaUoPXNFQkMPlh2mcsVcCOKo/+qaxiCRQw2vLmjAH0unhxmfoGl5hE4xkwxE
         K8JsySOYcFxddMmYE6Qd+7+DVO0QwfCHIko3WuHFH5Pmr7ydrM2S1JpxYT38XgOtqF
         wI3JBdelAHZmTFjY/hGv64IPXTksUGyyVUpwM8HSn99U1xhck1Tse7X1y7ySxjPraZ
         cNMtyqZzZk/EQ==
Date:   Mon, 25 Oct 2021 09:10:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] tests/xfs: test COW writeback failure when
 overlapping non-shared blocks
Message-ID: <20211025161022.GM24282@magnolia>
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

LGTM.  Thanks for the patch + reproducer!

At some point this test ought to grow a link to the upstream fix patch,
which is currently in the 5.16 merge branch, e.g.:

# Regression test for kernel commit:
#
# 5ca5916b6bc9 ("xfs: punch out data fork delalloc blocks on COW
# writeback failure")

...but as Sunday afternoon came and went with neither -rc7 nor a final
release being tagged, I'm not sure when that commit will appear
upstream.  It's entirely possible that Linus is sitting in the dark
right now, since I came back from my long weekend to a noticeable
amount of downed trees around town.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

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
