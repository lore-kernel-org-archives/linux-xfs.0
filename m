Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FA7C0032E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 15:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbjJYP2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 11:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbjJYP22 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 11:28:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D0B1BD1;
        Wed, 25 Oct 2023 08:27:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD09C433C8;
        Wed, 25 Oct 2023 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698247624;
        bh=iMjpVlqRZG6NV9dBjKnPJzQL+6vQrFuoi83YYzumUuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t567bhxyLFdsy+7UW/DwRko4qGh1GBndbISpMqChM7HSxzgGKMuMsjm+hVOB0Cjjh
         y8vSBVzc/dmYi2qzg5yF9qAfKbHa/B51xa7sJ++h9At0IUXUxzvbJKeLoNbASBmu89
         YcVRxzXm3yqBY9cKPDU1lmeu00BtT4Y1OPZsO1wWnKong0BgSfhwRtItUrxnuSmrLa
         hrG2TW0nRH+0QuNAdhXEiC0Kd6j4P2biRnsvUxwhXo95ANsFodJHdXZnzB/Ww6xnBp
         mpcoxNxOQHEnsOa92J1y5rVZMxmH3KM7ClxO9vSRmO54K7Mnmjoy7yX5//tpzT5sZs
         rZS5ofbk+bLmA==
Date:   Wed, 25 Oct 2023 08:27:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH fstests] xfs: test refilling AGFL after lots of btree
 splits
Message-ID: <20231025152702.GE3195650@frogsfrogsfrogs>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
 <c7be2fe66a297316b934ddd3a1368b14f39a9f22.1698190540.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7be2fe66a297316b934ddd3a1368b14f39a9f22.1698190540.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 04:37:42PM -0700, Omar Sandoval wrote:
> This is a regression test for patch "xfs: fix internal error from AGFL
> exhaustion"), which is not yet merged. Without the fix, it will fail
> with a "Structure needs cleaning" error.

Will look at the actual code patch next...

> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>  tests/xfs/601     | 62 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/601.out |  2 ++
>  2 files changed, 64 insertions(+)
>  create mode 100755 tests/xfs/601
>  create mode 100644 tests/xfs/601.out
> 
> diff --git a/tests/xfs/601 b/tests/xfs/601
> new file mode 100755
> index 00000000..bbc5b443
> --- /dev/null
> +++ b/tests/xfs/601
> @@ -0,0 +1,62 @@
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
> +_scratch_mkfs -m rmapbt=0 | _filter_mkfs > /dev/null 2> "$tmp.mkfs"

Need to probe if mkfs.xfs actually supports rmapbt options first, since
this bug applies to old fses from before rmap even existed, right?

(Or: What changes are needed to make the reproducer work with rmapbt
enabled?)

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

What happens if the allocations are all in some other AG?  The scratch
device could be 100TB.

> +# Fill in any small free extents in AG 0. After this, there should be only one,
> +# large free extent.
> +_scratch_unmount
> +mapfile -t gaps < <($XFS_DB_PROG -c 'agf 0' -c 'addr cntroot' -c 'p recs' "$SCRATCH_DEV" |
> +	$SED_PROG -rn 's/^[0-9]+:\[[0-9]+,([0-9]+)\].*/\1/p' |
> +	tac | tail -n +2)

_scratch_xfs_db -c 'agf 0' -c 'addr cntroot' -c 'btdump' ?

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
> +# leaf and fails because the free list is empty.
> +$XFS_IO_PROG -c "fpunch 0 $dbsize" "$SCRATCH_MNT/big"
> +
> +echo "Silence is golden"

Without the fix applied, what happens now?  Does fpunch fail with EIO
to taint the golden output?

--D

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
> 2.42.0
> 
