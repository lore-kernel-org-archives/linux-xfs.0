Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD5FC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 23:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D43C761427
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 23:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbhDUXlK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 19:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232353AbhDUXlK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 19:41:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 240BF613D7;
        Wed, 21 Apr 2021 23:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619048436;
        bh=5IEB0UZfNM2194SQvRO/uCSs1yQyjcarb0HfGpPkYCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z1D8tFtQzCZ/raB6gJRnvOM8TDiAvb0wHLxTZqOiiNttCnCfIJZAfid1mA4jCdeSc
         FRJYXx3nZ5u/RGK0DOKjcW4ZGcQdiy65kHsrOB+2kLtGJgrvgKo3CGOyvi798hP80T
         FlMEX/Hx4LV/m6lGGE024juy7+Pq4ONYLBTu/gqRB7Jx9lD344cnHuK2ulDLkO7Ep+
         GYRGyNlyTL2R3jTlJLfVmbKnNFuVgedjPzNt5SRePtYNUliVZe1I9KZ9l/a8XjkOqk
         qhnZ5Sfwpio1vIDpdZgqG80v6vGFDwirwgWwzU8op/fefS2zCbBx3gTbjR+e4Nz9+J
         GW9/iC1GjDMnQ==
Date:   Wed, 21 Apr 2021 16:40:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <20210421234031.GT3122264@magnolia>
References: <20210412133059.1186634-1-bfoster@redhat.com>
 <20210412133059.1186634-3-bfoster@redhat.com>
 <20210414010018.GX3957620@magnolia>
 <YH8AREVEgNThztFf@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH8AREVEgNThztFf@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 12:24:36PM -0400, Brian Foster wrote:
> On Tue, Apr 13, 2021 at 06:00:18PM -0700, Darrick J. Wong wrote:
> > On Mon, Apr 12, 2021 at 09:30:59AM -0400, Brian Foster wrote:
> > > The blocks used for allocation btrees (bnobt and countbt) are
> > > technically considered free space. This is because as free space is
> > > used, allocbt blocks are removed and naturally become available for
> > > traditional allocation. However, this means that a significant
> > > portion of free space may consist of in-use btree blocks if free
> > > space is severely fragmented.
> > > 
> > > On large filesystems with large perag reservations, this can lead to
> > > a rare but nasty condition where a significant amount of physical
> > > free space is available, but the majority of actual usable blocks
> > > consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> > > AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> > > blocks tracked across ~300 total allocbt blocks, but effectively at
> > > 100% full because the the free space is entirely consumed by
> > > refcountbt perag reservation.
> > > 
> > > Such a large perag reservation is by design on large filesystems.
> > > The problem is that because the free space is so fragmented, this AG
> > > contributes the 300 or so allocbt blocks to the global counters as
> > > free space. If this pattern repeats across enough AGs, the
> > > filesystem lands in a state where global block reservation can
> > > outrun physical block availability. For example, a streaming
> > > buffered write on the affected filesystem continues to allow delayed
> > > allocation beyond the point where writeback starts to fail due to
> > > physical block allocation failures. The expected behavior is for the
> > > delalloc block reservation to fail gracefully with -ENOSPC before
> > > physical block allocation failure is a possibility.
> > > 
> > > To address this problem, introduce an in-core counter to track the
> > > sum of all allocbt blocks in use by the filesystem. Use the new
> > > counter to set these blocks aside at reservation time and thus
> > > ensure they cannot be reserved until truly available. Since this is
> > > only necessary when perag reservations are active and the counter
> > > requires a read of each AGF to fully populate, only enforce on perag
> > > res enabled filesystems. This allows initialization of the counter
> > > at ->pagf_init time because the perag reservation init code reads
> > > each AGF at mount time.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
> > >  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
> > >  fs/xfs/xfs_mount.c              | 18 +++++++++++++++++-
> > >  fs/xfs/xfs_mount.h              |  6 ++++++
> > >  4 files changed, 37 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index aaa19101bb2a..144e2d68245c 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
> > >  	struct xfs_agf		*agf;		/* ag freelist header */
> > >  	struct xfs_perag	*pag;		/* per allocation group data */
> > >  	int			error;
> > > +	uint32_t		allocbt_blks;
> > >  
> > >  	trace_xfs_alloc_read_agf(mp, agno);
> > >  
> > > @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
> > >  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
> > >  		pag->pagf_init = 1;
> > >  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> > > +
> > > +		/*
> > > +		 * Update the global in-core allocbt block counter. Filter
> > > +		 * rmapbt blocks from the on-disk counter because those are
> > > +		 * managed by perag reservation.
> > > +		 */
> > > +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {
> > > +			allocbt_blks = pag->pagf_btreeblks -
> > > +					be32_to_cpu(agf->agf_rmap_blocks);
> > > +			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
> > 
> > This part is still bothering me.  The bug you're trying to fix is an
> > oversight in the per-AG reservation code where I forgot to account for
> > the fact that freespace btree blocks referencing reserved free space are
> > themselves not available for allocation, and are thus reserved.
> > 
> 
> Sort of. These blocks are not available for allocation, but they are
> actually in use while still being accounted as free space. They are not
> held as "reserved" at any point in the manner a perag reservation (or
> delalloc extent) is.
> 
> FWIW, I don't necessarily consider this an oversight of perag
> reservation as much as that the perag reservation can expose a problem
> with in-use allocbt blocks being accounted as free blocks. It allows the
> user to create conditions where the majority of unreserved && free
> fdblocks are actually in-use allocbt blocks. The allocbt block
> accounting is by design, however, because these blocks naturally become
> available as extents are freed. This is essentially the gap that this
> patch tries to close.. to preserve the higher level allocbt block
> accounting (i.e.  remaining as free from the user perspective) without
> allowing them to be incorrectly reserved.

<nod> That part I agree with...

> > xfs_ag_resv_init already has all the data it needs to know if we
> > actually made a reservation, and xfs_ag_resv.c is where we put all the
> > knowledge around how incore space reservations work.  This code adjusts
> > an incore space reservation count, so why isn't it in xfs_ag_resv_init?
> > 
> 
> ->m_allocbt_blks is just a straight counter for in-use allocbt blocks.
> It's not a reservation of any kind. The code above simply adjusts the
> counter based on allocbt modifications. The policy side of things is the
> change to xfs_mod_fdblocks() that factors the allocbt count into the
> blocks actually available for a given block reservation attempt. Based
> on that, I'm not sure why the code would live in xfs_ag_resv_init()..?
> I'm also not totally clear on whether you're asking about physical code
> location vs. about a potential alternative implementation.

Just physical code location; see below.

> FWIW, I did think a little bit about using a perag reservation for
> allocbt blocks earlier on, but IIRC it looked overcomplicated and I
> didn't want to get into potentially changing how allocbt blocks are
> accounted for what amounts to a corner case. If you had something else
> in mind, can you please elaborate?

...I really only meant to suggest moving the part that reads the AGF and
adds (btreeblks - rmapblocks) to mp->m_alloc_blks to xfs_ag_resv_init,
not a total redesign of the whole patch.

> > I also think that not giving back the m_allocbt_blks diversion when we
> > tear down the incore reservation is leaving a logic bomb for someone to
> > trip over in the future.  I can't tell if omitting that actually results
> > in a difference in behavior, but it still doesn't smell right...
> > 
> 
> As above, ->m_allocbt_blks is just a counter. That's why it is modified
> unconditionally. It just represents an in-core sum of what is tracked in
> the AGF headers. The flag from patch 1 primarily exists to indicate that
> the counter has been fully initialized by virtue of reading in all AGF
> headers at mount time (which in turn only happens when we have a perag
> res). I'm not sure it makes sense to artificially reset either (though
> I think it's debatable whether the mp flag is required).
> 
> Brian

Something like this, maybe?

--D

 fs/xfs/libxfs/xfs_ag_resv.c     |   50 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_alloc_btree.c |    2 ++
 fs/xfs/xfs_mount.c              |   18 +++++++++++++-
 fs/xfs/xfs_mount.h              |    6 +++++
 4 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 2bb1fdf9b349..8aa6b3d3276f 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -159,6 +159,41 @@ __xfs_ag_resv_free(
 	return error;
 }
 
+/* Hide freespace btree blocks that might be used to hold reserved blocks. */
+static inline int
+xfs_ag_resv_hide_allocbt_blocks(
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	bool			setup)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	xfs_agnumber_t		agno = pag->pag_agno;
+	struct xfs_buf		*agf_bp;
+	struct xfs_agf		*agf;
+	s64			delta;
+	unsigned int		rmap_blocks;
+	int			error;
+
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
+	if (error)
+		return error;
+
+	agf = agf_bp->b_addr;
+	rmap_blocks = be32_to_cpu(agf->agf_rmap_blocks);
+
+	/*
+	 * Update the global in-core allocbt block counter.  Filter rmapbt
+	 * blocks from the on-disk counter because those are managed by perag
+	 * reservation.
+	 */
+	delta = (s64)pag->pagf_btreeblks - rmap_blocks;
+	if (delta > 0)
+		atomic64_add(setup ? delta : -delta, &mp->m_allocbt_blks);
+
+	xfs_trans_brelse(tp, agf_bp);
+	return 0;
+}
+
 /* Free a per-AG reservation. */
 int
 xfs_ag_resv_free(
@@ -167,6 +202,13 @@ xfs_ag_resv_free(
 	int				error;
 	int				err2;
 
+	if (xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_asked ||
+	    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_asked) {
+		error = xfs_ag_resv_hide_allocbt_blocks(pag, NULL, false);
+		if (error)
+			return error;
+	}
+
 	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
 	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
 	if (err2 && !error)
@@ -322,8 +364,14 @@ xfs_ag_resv_init(
 	       pag->pagf_freeblks + pag->pagf_flcount);
 #endif
 out:
-	if (has_resv)
+	if (has_resv) {
 		mp->m_has_agresv = true;
+		/* XXX probably shouldn't clobber error here */
+		error = xfs_ag_resv_hide_allocbt_blocks(pag, tp, true);
+		if (error)
+			return error;
+	}
+
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 8e01231b308e..9f5a45f7baed 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -71,6 +71,7 @@ xfs_allocbt_alloc_block(
 		return 0;
 	}
 
+	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
 	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
 
 	xfs_trans_agbtree_delta(cur->bc_tp, 1);
@@ -95,6 +96,7 @@ xfs_allocbt_free_block(
 	if (error)
 		return error;
 
+	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
 	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index cb1e2c4702c3..1f835c375a89 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1188,6 +1188,7 @@ xfs_mod_fdblocks(
 	int64_t			lcounter;
 	long long		res_used;
 	s32			batch;
+	uint64_t		set_aside;
 
 	if (delta > 0) {
 		/*
@@ -1227,8 +1228,23 @@ xfs_mod_fdblocks(
 	else
 		batch = XFS_FDBLOCKS_BATCH;
 
+	/*
+	 * Set aside allocbt blocks because these blocks are tracked as free
+	 * space but not available for allocation. Technically this means that a
+	 * single reservation cannot consume all remaining free space, but the
+	 * ratio of allocbt blocks to usable free blocks should be rather small.
+	 * The tradeoff without this is that filesystems that maintain high
+	 * perag block reservations can over reserve physical block availability
+	 * and fail physical allocation, which leads to much more serious
+	 * problems (i.e. transaction abort, pagecache discards, etc.) than
+	 * slightly premature -ENOSPC.
+	 */
+	set_aside = mp->m_alloc_set_aside;
+	if (mp->m_has_agresv)
+		set_aside += atomic64_read(&mp->m_allocbt_blks);
+
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
-	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
+	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
 		/* we had space! */
 		return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8847ffd29777..80b9f37f65e6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -171,6 +171,12 @@ typedef struct xfs_mount {
 	 * extents or anything related to the rt device.
 	 */
 	struct percpu_counter	m_delalloc_blks;
+	/*
+	 * Global count of allocation btree blocks in use across all AGs. Only
+	 * used when perag reservation is enabled. Helps prevent block
+	 * reservation from attempting to reserve allocation btree blocks.
+	 */
+	atomic64_t		m_allocbt_blks;
 
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
