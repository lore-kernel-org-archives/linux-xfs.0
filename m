Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8F8C3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Aug 2022 15:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237364AbiHXPFv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Aug 2022 11:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiHXPFt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Aug 2022 11:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B3784ED9;
        Wed, 24 Aug 2022 08:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9B2D6188C;
        Wed, 24 Aug 2022 15:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F61CC433C1;
        Wed, 24 Aug 2022 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661353545;
        bh=74u1AMY+frKIJLQa2qIhCk6O9IzEZU9s9XBB42TQTGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CiJpTtmZ9OjJppacjvOpoMRqLBsvOf3WZruVYyiMKV9cTZzG7SPLZiJPbTpgqXi4U
         0QzwoO7mcVQRjBrgWEHIlY8C3YxbYbV8BgdjwZgs17mjaQsVU13XrCNuHPmBkbNWaG
         apMdiJImO9imrjWwzei9iDfCNPOYAzNrvm6GHUHMOx2k1WTtPxIa3wHad98B+576+H
         QymlvR8xXgpxTSjfqRDAQTmVd7qIbAtyhUaaD8GMZx9+C6eBkBXnjUmuIGn0ekqrh5
         FV2Y6XPw9CNnEfJjDSa1Uzp3/a80f7erl5ZD5yyMbHDEP/fBQdegB9QANbXt40fs2f
         9cxfcH8USVFUw==
Date:   Wed, 24 Aug 2022 08:05:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Check if a direct write can result in a false
 ENOSPC error
Message-ID: <YwY+SBk+fOh83PdI@magnolia>
References: <20220824093057.197585-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824093057.197585-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 24, 2022 at 03:00:57PM +0530, Chandan Babu R wrote:
> This commit adds a test to check if a direct write on a delalloc extent
> present in CoW fork can result in a false ENOSPC error. The bug has been fixed
> by upstream commit d62113303d691 ("xfs: Fix false ENOSPC when performing
> direct write on a delalloc extent in cow fork").
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
> Changelog:
> V1 -> V2:
>   1. Use file blocks as units instead of bytes to specify file offsets.
> 
>  tests/xfs/553     | 65 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/553.out |  9 +++++++
>  2 files changed, 74 insertions(+)
>  create mode 100755 tests/xfs/553
>  create mode 100644 tests/xfs/553.out
> 
> diff --git a/tests/xfs/553 b/tests/xfs/553
> new file mode 100755
> index 00000000..ae52e9fc
> --- /dev/null
> +++ b/tests/xfs/553
> @@ -0,0 +1,65 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 553
> +#
> +# Test to check if a direct write on a delalloc extent present in CoW fork can
> +# result in an ENOSPC error.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick clone
> +
> +# Import common functions.
> +. ./common/reflink
> +. ./common/inject
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_fixed_by_kernel_commit d62113303d691 \
> +	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
> +_require_scratch_reflink
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +_require_xfs_io_command "reflink"
> +_require_xfs_io_command "cowextsize"
> +
> +source=${SCRATCH_MNT}/source
> +destination=${SCRATCH_MNT}/destination
> +fragmented_file=${SCRATCH_MNT}/fragmented_file
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +blksz=$(_get_block_size $SCRATCH_MNT)

_get_file_block_size, since COW can only be done in file allocation
units.

This is (currently) a distinction that won't make a difference until
realtime reflink, where we'll have to deal with rextsize > 1FSB, but we
might as well get this correct from the start.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +
> +echo "Create source file"
> +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 8192))" $source >> $seqres.full
> +
> +echo "Reflink destination file with source file"
> +$XFS_IO_PROG -f -c "reflink $source" $destination >> $seqres.full
> +
> +echo "Set destination file's cowextsize to 4096 blocks"
> +$XFS_IO_PROG -c "cowextsize $((blksz * 4096))" $destination >> $seqres.full
> +
> +echo "Fragment FS"
> +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 16384))" $fragmented_file >> $seqres.full
> +sync
> +$here/src/punch-alternating $fragmented_file >> $seqres.full
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +echo "Create delalloc extent of length 4096 blocks in destination file's CoW fork"
> +$XFS_IO_PROG -c "pwrite 0 $blksz" $destination >> $seqres.full
> +
> +sync
> +
> +echo "Direct I/O write at 3rd block in destination file"
> +$XFS_IO_PROG -d -c "pwrite $((blksz * 3)) $((blksz * 2))" $destination >> $seqres.full
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/553.out b/tests/xfs/553.out
> new file mode 100644
> index 00000000..9f5679de
> --- /dev/null
> +++ b/tests/xfs/553.out
> @@ -0,0 +1,9 @@
> +QA output created by 553
> +Format and mount fs
> +Create source file
> +Reflink destination file with source file
> +Set destination file's cowextsize to 4096 blocks
> +Fragment FS
> +Inject bmap_alloc_minlen_extent error tag
> +Create delalloc extent of length 4096 blocks in destination file's CoW fork
> +Direct I/O write at 3rd block in destination file
> -- 
> 2.35.1
> 
