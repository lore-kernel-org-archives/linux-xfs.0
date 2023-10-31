Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EFAC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 21:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjJaVZE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 17:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjJaVZD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 17:25:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDD0FE
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 14:25:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A28C433C7;
        Tue, 31 Oct 2023 21:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698787500;
        bh=v4rP/GnoadJW0JP8/YFl63nAgZgBI+CPrilnlqN/wzs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=teexWeztF5K/qTLgJxBgBipYYjmHiWoq+1FDGSm6f+WD32pRfULlo3CRnf3lUDY94
         dG5Jm63U/xK5ZfEIzjIef5jy9Fda8EjTB/f0zdbBZAf91VSKu3ii/H74B184ANccWy
         7LbTtJblXM3lmJUMgsysp/E+igW6fE7GSVXKfh7GFnbn1qETRCORjDxbhbRqqHeGLA
         D0z7KwA/7uegIWc9osXw+VLqID6UaBhPrs2yORiCgWfSQe2NVbK5O3FyrQbrx52VKt
         AQBtth3cy/pFivf2yvaju6KuHuhjHkzQiHXpKWNrE2uRWtTONe3M05DA22nGowN3jB
         g03TRwrXfvNbw==
Date:   Tue, 31 Oct 2023 14:24:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        kernel-team@fb.com, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH fstests v2] xfs: test refilling AGFL after lots of btree
 splits
Message-ID: <20231031212459.GB1205143@frogsfrogsfrogs>
References: <68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com>
 <fe622bff22bca23648ed1154faeadce3ed51ad3b.1698699498.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe622bff22bca23648ed1154faeadce3ed51ad3b.1698699498.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 30, 2023 at 02:00:15PM -0700, Omar Sandoval wrote:
> This is a regression test for patch "xfs: fix internal error from AGFL
> exhaustion"), which is not yet merged. Without the fix, it will fail
> with a "Structure needs cleaning" error.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Changes since v1 [1]:
> 
> - Fixed to check whether mkfs.xfs supports -m rmapbt.
> - Changed bare $XFS_DB calls to _scratch_xfs_db.
> - Expanded comment about what happens without the fix.
> 
> I didn't add a check for whether everything ended up in AG 0, because it
> wasn't clear to me what to do in that case. We could skip the test, but
> it also doesn't hurt to run it anyways.
> 
> 1: https://lore.kernel.org/linux-xfs/c7be2fe66a297316b934ddd3a1368b14f39a9f22.1698190540.git.osandov@osandov.com/
> 
>  tests/xfs/601     | 68 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/601.out |  2 ++
>  2 files changed, 70 insertions(+)
>  create mode 100755 tests/xfs/601
>  create mode 100644 tests/xfs/601.out
> 
> diff --git a/tests/xfs/601 b/tests/xfs/601
> new file mode 100755
> index 00000000..68df6ac0
> --- /dev/null
> +++ b/tests/xfs/601
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) Meta Platforms, Inc. and affiliates.
> +#
> +# FS QA Test 601
> +#
> +# Regression test for patch "xfs: fix internal error from AGFL exhaustion".
> +#
> +. ./common/preamble
> +_begin_fstest auto prealloc punch
> +
> +. ./common/filter
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_test_program punch-alternating
> +_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: fix internal error from AGFL exhaustion"
> +
> +# Disable the rmapbt so we only need to worry about splitting the bnobt and
> +# cntbt at the same time.
> +opts=
> +if $MKFS_XFS_PROG |& grep -q rmapbt; then
> +	opts="-m rmapbt=0"
> +fi
> +_scratch_mkfs $opts | _filter_mkfs > /dev/null 2> "$tmp.mkfs"
> +. "$tmp.mkfs"
> +_scratch_mount
> +
> +alloc_block_len=$((_fs_has_crcs ? 56 : 16))
> +allocbt_leaf_maxrecs=$(((dbsize - alloc_block_len) / 8))
> +allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
> +
> +# Create a big file with a size such that the punches below create the exact
> +# free extents we want.
> +num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
> +$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
> +
> +# Fill in any small free extents in AG 0. After this, there should be only one,
> +# large free extent.
> +_scratch_unmount
> +mapfile -t gaps < <(_scratch_xfs_db -c 'agf 0' -c 'addr cntroot' -c btdump |
> +	$SED_PROG -rn 's/^[0-9]+:\[[0-9]+,([0-9]+)\].*/\1/p' |
> +	tac | tail -n +2)
> +_scratch_mount
> +for gap_i in "${!gaps[@]}"; do
> +	gap=${gaps[$gap_i]}
> +	$XFS_IO_PROG -c "falloc 0 $((gap * dbsize))" -f "$SCRATCH_MNT/gap$gap_i"
> +done
> +
> +# Create enough free space records to make the bnobt and cntbt both full,
> +# 2-level trees, plus one more record to make them split all the way to the
> +# root and become 3-level trees. After this, there is a 7-block free extent in
> +# the rightmost leaf of the cntbt, and all of the leaves of the cntbt other
> +# than the rightmost two are full. Without the fix, the free list is also
> +# empty.
> +$XFS_IO_PROG -c "fpunch $dbsize $((7 * dbsize))" "$SCRATCH_MNT/big"
> +"$here/src/punch-alternating" -o 9 "$SCRATCH_MNT/big"
> +
> +# Do an arbitrary operation that refills the free list. Without the fix, this
> +# will allocate 6 blocks from the 7-block free extent in the rightmost leaf of
> +# the cntbt, then try to insert the remaining 1 block free extent in the
> +# leftmost leaf of the cntbt. But that leaf is full, so this tries to split the
> +# leaf and fails because the free list is empty, returning EFSCORRUPTED.
> +$XFS_IO_PROG -c "fpunch 0 $dbsize" "$SCRATCH_MNT/big"
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/xfs/601.out b/tests/xfs/601.out
> new file mode 100644
> index 00000000..0d70c3e5
> --- /dev/null
> +++ b/tests/xfs/601.out
> @@ -0,0 +1,2 @@
> +QA output created by 601
> +Silence is golden
> -- 
> 2.41.0
> 
