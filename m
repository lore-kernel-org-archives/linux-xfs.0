Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB25C25B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 22:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjJYWFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 18:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjJYWFp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 18:05:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27269137;
        Wed, 25 Oct 2023 15:05:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEB5C433C8;
        Wed, 25 Oct 2023 22:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698271542;
        bh=sXgCZDGvHjX5ThjhyGj/jyEl+TF9e+Epo8eZ2CaHRjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YBLYuxak40DkVG6Nzny/S8oiHzZMKK6NzhdYr08HtKT62+cBPdhhbhu3+pjR2J1/q
         SNxpu24YfOVeaz+oYDL0/W7HCQzjF7kNfdekTJjW77wnpTMQdusST8kADahaEbqs1Y
         PzPU4OWcrIfWvih6K+eey6fW4pG1FD74mjiEZYSIikJUhpfHkl+tqmOLJpY2F/vQVB
         vtr5bMDuD6+PK2KIcEXzFfb7Pk68gd9rmZdOL5Du1ibCJ7c/IPPXkzzfDOJ8pgLP04
         Q0zwcvXrB/N+H7A23QJ43F1hmBwPLzshyO7LSjV5BqI8lqitLBIWMR6vsc17ZN/G8j
         kHqHzEcyu5MYA==
Date:   Wed, 25 Oct 2023 15:05:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH fstests] xfs: test refilling AGFL after lots of btree
 splits
Message-ID: <20231025220542.GL11391@frogsfrogsfrogs>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
 <c7be2fe66a297316b934ddd3a1368b14f39a9f22.1698190540.git.osandov@osandov.com>
 <20231025152702.GE3195650@frogsfrogsfrogs>
 <ZTl3b3dqgEHUZ+w/@telecaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTl3b3dqgEHUZ+w/@telecaster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2023 at 01:15:43PM -0700, Omar Sandoval wrote:
> On Wed, Oct 25, 2023 at 08:27:02AM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 24, 2023 at 04:37:42PM -0700, Omar Sandoval wrote:
> > > This is a regression test for patch "xfs: fix internal error from AGFL
> > > exhaustion"), which is not yet merged. Without the fix, it will fail
> > > with a "Structure needs cleaning" error.
> > 
> > Will look at the actual code patch next...
> > 
> > > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > > ---
> > >  tests/xfs/601     | 62 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/601.out |  2 ++
> > >  2 files changed, 64 insertions(+)
> > >  create mode 100755 tests/xfs/601
> > >  create mode 100644 tests/xfs/601.out
> > > 
> > > diff --git a/tests/xfs/601 b/tests/xfs/601
> > > new file mode 100755
> > > index 00000000..bbc5b443
> > > --- /dev/null
> > > +++ b/tests/xfs/601
> > > @@ -0,0 +1,62 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) Meta Platforms, Inc. and affiliates.
> > > +#
> > > +# FS QA Test 601
> > > +#
> > > +# Regression test for patch "xfs: fix internal error from AGFL exhaustion".
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto prealloc punch
> > > +
> > > +. ./common/filter
> > > +
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_test_program punch-alternating
> > > +_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: fix internal error from AGFL exhaustion"
> > > +
> > > +_scratch_mkfs -m rmapbt=0 | _filter_mkfs > /dev/null 2> "$tmp.mkfs"
> > 
> > Need to probe if mkfs.xfs actually supports rmapbt options first, since
> > this bug applies to old fses from before rmap even existed, right?
> 
> Good point. Something like:
> 
> opts=
> if $MKFS_XFS_PROG |& grep rmapbt; then
> 	opts="-m rmapbt=0"
> fi
> _scratch_mkfs $opts | _filter_mkfs > /dev/null 2> "$tmp.mkfs"

Yep, that works.

> > (Or: What changes are needed to make the reproducer work with rmapbt
> > enabled?)
> 
> We'd need to craft the filesystem in a way that a single operation
> splits and adds a new level to the bnobt, cntbt, and rmapbt all at the
> same time. It can probably be done, but I suspect it'd be much more
> complicated :(
> 
> > > +. "$tmp.mkfs"
> > > +_scratch_mount
> > > +
> > > +alloc_block_len=$((_fs_has_crcs ? 56 : 16))
> > > +allocbt_leaf_maxrecs=$(((dbsize - alloc_block_len) / 8))
> > > +allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
> > > +
> > > +# Create a big file with a size such that the punches below create the exact
> > > +# free extents we want.
> > > +num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
> > > +$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
> > 
> > What happens if the allocations are all in some other AG?  The scratch
> > device could be 100TB.
> 
> Yeah, this relies on all of the allocations going to AG 0, and the big
> fallocate getting one contiguous extent. That always happened for me on
> a few different sized filesystems, but I understand it's not guaranteed.
> Maybe I should create the filesystem with -d agcount=1?

Hmm.  xfs_repair is likely to get cranky about single-AG filesystems...

> > > +# Fill in any small free extents in AG 0. After this, there should be only one,
> > > +# large free extent.
> > > +_scratch_unmount
> > > +mapfile -t gaps < <($XFS_DB_PROG -c 'agf 0' -c 'addr cntroot' -c 'p recs' "$SCRATCH_DEV" |
> > > +	$SED_PROG -rn 's/^[0-9]+:\[[0-9]+,([0-9]+)\].*/\1/p' |
> > > +	tac | tail -n +2)
> > 
> > _scratch_xfs_db -c 'agf 0' -c 'addr cntroot' -c 'btdump' ?
> 
> Will fix.

> > > +_scratch_mount
> > > +for gap_i in "${!gaps[@]}"; do
> > > +	gap=${gaps[$gap_i]}
> > > +	$XFS_IO_PROG -c "falloc 0 $((gap * dbsize))" -f "$SCRATCH_MNT/gap$gap_i"
> > > +done

...but you could check that the AG 0 cntbt actually has one large free
extent, as the comment says should be the case.

> > > +
> > > +# Create enough free space records to make the bnobt and cntbt both full,
> > > +# 2-level trees, plus one more record to make them split all the way to the
> > > +# root and become 3-level trees. After this, there is a 7-block free extent in
> > > +# the rightmost leaf of the cntbt, and all of the leaves of the cntbt other
> > > +# than the rightmost two are full. Without the fix, the free list is also
> > > +# empty.
> > > +$XFS_IO_PROG -c "fpunch $dbsize $((7 * dbsize))" "$SCRATCH_MNT/big"
> > > +"$here/src/punch-alternating" -o 9 "$SCRATCH_MNT/big"
> > > +
> > > +# Do an arbitrary operation that refills the free list. Without the fix, this
> > > +# will allocate 6 blocks from the 7-block free extent in the rightmost leaf of
> > > +# the cntbt, then try to insert the remaining 1 block free extent in the
> > > +# leftmost leaf of the cntbt. But that leaf is full, so this tries to split the
> > > +# leaf and fails because the free list is empty.
> > > +$XFS_IO_PROG -c "fpunch 0 $dbsize" "$SCRATCH_MNT/big"
> > > +
> > > +echo "Silence is golden"
> > 
> > Without the fix applied, what happens now?  Does fpunch fail with EIO
> > to taint the golden output?
> 
> It fails with EFSCORRUPTED/EUCLEAN and prints an error message as noted
> in my commit message, yeah.

Cool!  Looking forward to the next revision. :)

--D

> 
> Thanks!
> 
> Omar
