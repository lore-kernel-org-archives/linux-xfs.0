Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0AAC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Nov 2023 15:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjKAP4f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 11:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjKAP4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 11:56:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8499DFD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Nov 2023 08:56:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2134FC433C7;
        Wed,  1 Nov 2023 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698854191;
        bh=c4n/vEZxDQFsSAUHcCGgfZci5Znchi38ghKExBUOwSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BBeiGr8yoNKN7SiiEX7aV/r+UkJJbNH4yrkN4XBV7xq8X2RBtjihfKW4QMQCtJ2w9
         VBpj7E2BZ1ZJrlIvwT882Bf7TYogHYoPYSCkTzB04Gs9PbxzrkPXusfwBhzvkiVS4q
         BFckSXR1bSsraRYIRzDzKB7bim94LxL3bjKayIlvS1Jw0d1hAlwHm6WCsXm0uGNUV1
         epMfzymCp9P1ajDz8XcnmDB8ZX379ytSeYey+mCMOGBJ4a7Daf11T7pxL5OnDxv4k3
         obzoC7ZTbWYqjeUrdZY60Mr9QjEHNQmJCW6AjC8C3/tMtP2zaLQu5X2HPmXZ/mk0Hf
         C8GGYNT9hd8lg==
Date:   Wed, 1 Nov 2023 08:56:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH fstests v2] xfs: test refilling AGFL after lots of btree
 splits
Message-ID: <20231101155630.GA1203404@frogsfrogsfrogs>
References: <68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com>
 <fe622bff22bca23648ed1154faeadce3ed51ad3b.1698699498.git.osandov@osandov.com>
 <20231101064543.uruh3ljicwnedw7x@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101064543.uruh3ljicwnedw7x@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2023 at 02:45:43PM +0800, Zorro Lang wrote:
> On Mon, Oct 30, 2023 at 02:00:15PM -0700, Omar Sandoval wrote:
> > This is a regression test for patch "xfs: fix internal error from AGFL
> > exhaustion"), which is not yet merged. Without the fix, it will fail
> > with a "Structure needs cleaning" error.
> > 
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > ---
> > Changes since v1 [1]:
> > 
> > - Fixed to check whether mkfs.xfs supports -m rmapbt.
> > - Changed bare $XFS_DB calls to _scratch_xfs_db.
> > - Expanded comment about what happens without the fix.
> > 
> > I didn't add a check for whether everything ended up in AG 0, because it
> > wasn't clear to me what to do in that case. We could skip the test, but
> > it also doesn't hurt to run it anyways.
> > 
> > 1: https://lore.kernel.org/linux-xfs/c7be2fe66a297316b934ddd3a1368b14f39a9f22.1698190540.git.osandov@osandov.com/
> > 
> >  tests/xfs/601     | 68 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/601.out |  2 ++
> 
> The xfs/601 has been taken by:
>   39f88c55 ("generic: test FALLOC_FL_UNSHARE when pagecache is not loaded")
> 
> I'll change this case to another number.
> 
> ...
> Hi Darrick, I just noticed that commit has "generic", but that's a case in
> tests/xfs, and there's not "_supported_fs xfs" in xfs/601. Do you want to
> move it to be a generic case?

Yes, the existing xfs/601 regression test (kernel commit 35d30c9cf127)
can become a generic test; and then this one can take its place.

--D

> >  2 files changed, 70 insertions(+)
> >  create mode 100755 tests/xfs/601
> >  create mode 100644 tests/xfs/601.out
> > 
> > diff --git a/tests/xfs/601 b/tests/xfs/601
> > new file mode 100755
> > index 00000000..68df6ac0
> > --- /dev/null
> > +++ b/tests/xfs/601
> > @@ -0,0 +1,68 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) Meta Platforms, Inc. and affiliates.
> > +#
> > +# FS QA Test 601
> > +#
> > +# Regression test for patch "xfs: fix internal error from AGFL exhaustion".
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto prealloc punch
> > +
> > +. ./common/filter
> > +
> > +_supported_fs xfs
> > +_require_scratch
> 
> _require_xfs_io_command "fpunch" ?
> 
> I can help to add that, others look good to me.
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> > +_require_test_program punch-alternating
> > +_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: fix internal error from AGFL exhaustion"
> > +
> > +# Disable the rmapbt so we only need to worry about splitting the bnobt and
> > +# cntbt at the same time.
> > +opts=
> > +if $MKFS_XFS_PROG |& grep -q rmapbt; then
> > +	opts="-m rmapbt=0"
> > +fi
> > +_scratch_mkfs $opts | _filter_mkfs > /dev/null 2> "$tmp.mkfs"
> > +. "$tmp.mkfs"
> > +_scratch_mount
> > +
> > +alloc_block_len=$((_fs_has_crcs ? 56 : 16))
> > +allocbt_leaf_maxrecs=$(((dbsize - alloc_block_len) / 8))
> > +allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
> > +
> > +# Create a big file with a size such that the punches below create the exact
> > +# free extents we want.
> > +num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
> > +$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
> > +
> > +# Fill in any small free extents in AG 0. After this, there should be only one,
> > +# large free extent.
> > +_scratch_unmount
> > +mapfile -t gaps < <(_scratch_xfs_db -c 'agf 0' -c 'addr cntroot' -c btdump |
> > +	$SED_PROG -rn 's/^[0-9]+:\[[0-9]+,([0-9]+)\].*/\1/p' |
> > +	tac | tail -n +2)
> > +_scratch_mount
> > +for gap_i in "${!gaps[@]}"; do
> > +	gap=${gaps[$gap_i]}
> > +	$XFS_IO_PROG -c "falloc 0 $((gap * dbsize))" -f "$SCRATCH_MNT/gap$gap_i"
> > +done
> > +
> > +# Create enough free space records to make the bnobt and cntbt both full,
> > +# 2-level trees, plus one more record to make them split all the way to the
> > +# root and become 3-level trees. After this, there is a 7-block free extent in
> > +# the rightmost leaf of the cntbt, and all of the leaves of the cntbt other
> > +# than the rightmost two are full. Without the fix, the free list is also
> > +# empty.
> > +$XFS_IO_PROG -c "fpunch $dbsize $((7 * dbsize))" "$SCRATCH_MNT/big"
> > +"$here/src/punch-alternating" -o 9 "$SCRATCH_MNT/big"
> > +
> > +# Do an arbitrary operation that refills the free list. Without the fix, this
> > +# will allocate 6 blocks from the 7-block free extent in the rightmost leaf of
> > +# the cntbt, then try to insert the remaining 1 block free extent in the
> > +# leftmost leaf of the cntbt. But that leaf is full, so this tries to split the
> > +# leaf and fails because the free list is empty, returning EFSCORRUPTED.
> > +$XFS_IO_PROG -c "fpunch 0 $dbsize" "$SCRATCH_MNT/big"
> > +
> > +echo "Silence is golden"
> > +status=0
> > +exit
> > diff --git a/tests/xfs/601.out b/tests/xfs/601.out
> > new file mode 100644
> > index 00000000..0d70c3e5
> > --- /dev/null
> > +++ b/tests/xfs/601.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 601
> > +Silence is golden
> > -- 
> > 2.41.0
> > 
> > 
> 
> 
