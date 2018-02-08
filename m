Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51314 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbeBHCUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 21:20:44 -0500
Date: Wed, 7 Feb 2018 18:20:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs: account only rmapbt-used blocks against rmapbt
 perag res
Message-ID: <20180208022037.GF5433@magnolia>
References: <20180205174601.51574-1-bfoster@redhat.com>
 <20180205174601.51574-5-bfoster@redhat.com>
 <20180207000350.GO4849@magnolia>
 <20180207144934.GB9789@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180207144934.GB9789@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 07, 2018 at 09:49:35AM -0500, Brian Foster wrote:
> On Tue, Feb 06, 2018 at 04:03:50PM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 05, 2018 at 12:46:01PM -0500, Brian Foster wrote:
> > > The rmapbt perag metadata reservation reserves blocks for the
> > > reverse mapping btree (rmapbt). Since the rmapbt uses blocks from
> > > the agfl and perag accounting is updated as blocks are allocated
> > > from the allocation btrees, the reservation actually accounts blocks
> > > as they are allocated to (or freed from) the agfl rather than the
> > > rmapbt itself.
> > > 
> > > While this works for blocks that are eventually used for the rmapbt,
> > > not all agfl blocks are destined for the rmapbt. Blocks that are
> > > allocated to the agfl (and thus "reserved" for the rmapbt) but then
> > > used by another structure leads to a growing inconsistency over time
> > > between the runtime tracking of rmapbt usage vs. actual rmapbt
> > > usage. Since the runtime tracking thinks all agfl blocks are rmapbt
> > > blocks, it essentially believes that less future reservation is
> > > required to satisfy the rmapbt than what is actually necessary.
> > > 
> > > The inconsistency is rectified across mount cycles because the perag
> > > reservation is initialized based on the actual rmapbt usage at mount
> > > time. The problem, however, is that the excessive drain of the
> > > reservation at runtime opens a window to allocate blocks for other
> > > purposes that might be required for the rmapbt on a subsequent
> > > mount. This problem can be demonstrated by a simple test that runs
> > > an allocation workload to consume agfl blocks over time and then
> > > observe the difference in the agfl reservation requirement across an
> > > unmount/mount cycle:
> > > 
> > >   mount ...: xfs_ag_resv_init: ... resv 3193 ask 3194 len 3194
> > >   ...
> > >   ...      : xfs_ag_resv_alloc_extent: ... resv 2957 ask 3194 len 1
> > >   umount...: xfs_ag_resv_free: ... resv 2956 ask 3194 len 0
> > >   mount ...: xfs_ag_resv_init: ... resv 3052 ask 3194 len 3194
> > > 
> > > As the above tracepoints show, the reservation requirement reduces
> > > from 3194 blocks to 2956 blocks as the workload runs.  Without any
> > > other changes in the filesystem, the same reservation requirement
> > > jumps from 2956 to 3052 blocks over a umount/mount cycle.
> > > 
> > > To address this divergence, update the RMAPBT reservation to account
> > > blocks used for the rmapbt only rather than all blocks filled into
> > > the agfl. This patch makes several high-level changes toward that
> > > end:
> > > 
> > > 1.) Reintroduce an AGFL reservation type to serve as an accounting
> > >     no-op for blocks allocated to (or freed from) the AGFL.
> > > 2.) Invoke RMAPBT usage accounting from the actual rmapbt block
> > >     allocation path rather than the AGFL allocation path.
> > > 
> > > The first change is required because agfl blocks are considered free
> > > blocks throughout their lifetime. The perag reservation subsystem is
> > > invoked unconditionally by the allocation subsystem, so we need a
> > > way to tell the perag subsystem (via the allocation subsystem) to
> > > not make any accounting changes for blocks filled into the AGFL.
> > > 
> > > The second change causes the in-core RMAPBT reservation usage
> > > accounting to remain consistent with the on-disk state at all times
> > > and eliminates the risk of leaving the rmapbt reservation
> > > underfilled.
> > 
> > Sorry I haven't gotten to this in a couple of days.  This looks like a
> > reasonable enough fix to the complex perag machinery, though Dave and I
> > were batting around an idea last week -- what if instead of all these
> > reservation types and tracking we simply maintained a per-ag free space
> > reservation of a couple megabytes, handed out blocks if we got
> > desperate, and replenished that res when we had a good opportunity?
> > 
> 
> Firstly, I essentially view this patch as a bug fix vs. some kind of
> larger rework. I'm hoping the split of the rename bits helps emphasize
> that... It's really just a change to accurately account rmapbt block
> consumption at runtime.
> 
> I don't have much context on the broader question you've called out...
> I assume there was a larger requirement (associated with
> reflink+rmapbt?) that necessitated this kind of worst case reservation
> in the first place..?

Without reflink, we protect fs writes from hitting ENOSPC midway through
a transaction by reserving all the blocks we think we might need ahead
of time.  Making the reservation at the fs level works because any
blocks we might have to allocate to handle the write can be in any AG,
so if a given AG is out of space we just move on to the next one.

However, once copy-on-write enters the picture, that last assumption
is no longer valid because we have to decrease the reference count in
the specific AG that has the shared blocks.  We now have a requirement
that said AG also has enough space to handle any refcountbt splits that
might happen in the process of decreasing the refcount, and that's where
we get into trouble.  The FS may have plenty of space (so the
reservation goes thorugh) but the AG may be out of space, in which case
the refcount update fails and the fs shuts down.

Therefore, we reserve some free space (by hiding it from the incore
metadata) and every time we need a block for the refcountbt we get one
from the reservation, hence we can never run out.

> We've since applied it to things like the finobt (which I'm still not
> totally convinced was the right thing to do based on the vague
> justification for it), which kind of blurs the line between where it's
> a requirement vs. nice-to-have/band-aid for me.

I think the finobt reservation is required: Suppose you have a
filesystem with a lot of empty files, a lot of single-block files, and a
lot of big files such that there's no free space anywhere.  Suppose
further that there's an AG where every finobt block is exactly full,
there's an inode chunk with exactly 64 inodes in use, and every block in
that AG is in use (meaning zero AGFL blocks).  Now find one of the empty
inodes in that totally-full chunk and try to free it.  Truncation
doesn't free up any blocks, but we have to expand the finobt to add the
record for the chunk.  We can't find any blocks in that AG so we shut
down.

> > I /think/ the answer to that question is that we need to try to reserve
> > enough blocks to satisfy the maximum size of the btree (if there is
> > one), not just a fixed-size delayed free space.  We already hand out
> > blocks if we get desperate, and we replenish the reservation when we
> > can.  Lastly, we need the reservation type tracking so that we avoid
> > things like the refcount btree stealing blocks from the agfl in
> > desperation.  I've also been wondering if each reservation should get
> > its own type so that we track refcountbt and finobt blocks separately.
> > 
> 
> In principle, I'm not really for or against the existing mechanism,
> further granularizing it or changing it out for something else entirely.
> I'm confused about what exactly we're trying to fix in the first place,
> though. Is there a larger fundamental problem at play here? Is the
> reservation (or complexity of the mechanism) simply overkill? Something
> else..?

Mostly my insecurity over "Was this the right thing for the job?  What
even /was/ the job?" :)

--D

> > Otherwise I think this series looks ok, but I'll go over it in more
> > detail tomorrow.
> > 
> 
> Thanks. No rush..
> 
> Brian
> 
> > --D
> > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ag_resv.c    |  4 ++++
> > >  fs/xfs/libxfs/xfs_ag_resv.h    | 31 +++++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_alloc.c      | 18 ++++++------------
> > >  fs/xfs/libxfs/xfs_rmap_btree.c |  4 ++++
> > >  fs/xfs/xfs_mount.h             |  1 +
> > >  5 files changed, 46 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> > > index 0ca2e680034a..03885a968de8 100644
> > > --- a/fs/xfs/libxfs/xfs_ag_resv.c
> > > +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> > > @@ -326,6 +326,8 @@ xfs_ag_resv_alloc_extent(
> > >  	trace_xfs_ag_resv_alloc_extent(pag, type, args->len);
> > >  
> > >  	switch (type) {
> > > +	case XFS_AG_RESV_AGFL:
> > > +		return;
> > >  	case XFS_AG_RESV_METADATA:
> > >  	case XFS_AG_RESV_RMAPBT:
> > >  		resv = xfs_perag_resv(pag, type);
> > > @@ -366,6 +368,8 @@ xfs_ag_resv_free_extent(
> > >  	trace_xfs_ag_resv_free_extent(pag, type, len);
> > >  
> > >  	switch (type) {
> > > +	case XFS_AG_RESV_AGFL:
> > > +		return;
> > >  	case XFS_AG_RESV_METADATA:
> > >  	case XFS_AG_RESV_RMAPBT:
> > >  		resv = xfs_perag_resv(pag, type);
> > > diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> > > index 8d6c687deef3..938f2f96c5e8 100644
> > > --- a/fs/xfs/libxfs/xfs_ag_resv.h
> > > +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> > > @@ -32,4 +32,35 @@ void xfs_ag_resv_alloc_extent(struct xfs_perag *pag, enum xfs_ag_resv_type type,
> > >  void xfs_ag_resv_free_extent(struct xfs_perag *pag, enum xfs_ag_resv_type type,
> > >  		struct xfs_trans *tp, xfs_extlen_t len);
> > >  
> > > +/*
> > > + * RMAPBT reservation accounting wrappers. Since rmapbt blocks are sourced from
> > > + * the AGFL, they are allocated one at a time and the reservation updates don't
> > > + * require a transaction.
> > > + */
> > > +static inline void
> > > +xfs_ag_resv_rmapbt_alloc(
> > > +	struct xfs_mount	*mp,
> > > +	xfs_agnumber_t		agno)
> > > +{
> > > +	struct xfs_alloc_arg	args = {0};
> > > +	struct xfs_perag	*pag;
> > > +
> > > +	args.len = 1;
> > > +	pag = xfs_perag_get(mp, agno);
> > > +	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
> > > +	xfs_perag_put(pag);
> > > +}
> > > +
> > > +static inline void
> > > +xfs_ag_resv_rmapbt_free(
> > > +	struct xfs_mount	*mp,
> > > +	xfs_agnumber_t		agno)
> > > +{
> > > +	struct xfs_perag	*pag;
> > > +
> > > +	pag = xfs_perag_get(mp, agno);
> > > +	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
> > > +	xfs_perag_put(pag);
> > > +}
> > > +
> > >  #endif	/* __XFS_AG_RESV_H__ */
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index e53d55453dc5..8c401efb2d74 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -711,7 +711,7 @@ xfs_alloc_ag_vextent(
> > >  
> > >  	ASSERT(args->len >= args->minlen);
> > >  	ASSERT(args->len <= args->maxlen);
> > > -	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_RMAPBT);
> > > +	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
> > >  	ASSERT(args->agbno % args->alignment == 0);
> > >  
> > >  	/* if not file data, insert new block into the reverse map btree */
> > > @@ -1564,7 +1564,6 @@ xfs_alloc_ag_vextent_small(
> > >  	int		*stat)	/* status: 0-freelist, 1-normal/none */
> > >  {
> > >  	struct xfs_owner_info	oinfo;
> > > -	struct xfs_perag	*pag;
> > >  	int		error;
> > >  	xfs_agblock_t	fbno;
> > >  	xfs_extlen_t	flen;
> > > @@ -1583,7 +1582,7 @@ xfs_alloc_ag_vextent_small(
> > >  	 * freelist.
> > >  	 */
> > >  	else if (args->minlen == 1 && args->alignment == 1 &&
> > > -		 args->resv != XFS_AG_RESV_RMAPBT &&
> > > +		 args->resv != XFS_AG_RESV_AGFL &&
> > >  		 (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount)
> > >  		  > args->minleft)) {
> > >  		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
> > > @@ -1616,18 +1615,13 @@ xfs_alloc_ag_vextent_small(
> > >  			/*
> > >  			 * If we're feeding an AGFL block to something that
> > >  			 * doesn't live in the free space, we need to clear
> > > -			 * out the OWN_AG rmap and add the block back to
> > > -			 * the RMAPBT per-AG reservation.
> > > +			 * out the OWN_AG rmap.
> > >  			 */
> > >  			xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > >  			error = xfs_rmap_free(args->tp, args->agbp, args->agno,
> > >  					fbno, 1, &oinfo);
> > >  			if (error)
> > >  				goto error0;
> > > -			pag = xfs_perag_get(args->mp, args->agno);
> > > -			xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT,
> > > -					args->tp, 1);
> > > -			xfs_perag_put(pag);
> > >  
> > >  			*stat = 0;
> > >  			return 0;
> > > @@ -2153,7 +2147,7 @@ xfs_alloc_fix_freelist(
> > >  		if (error)
> > >  			goto out_agbp_relse;
> > >  		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
> > > -					   &targs.oinfo, XFS_AG_RESV_RMAPBT);
> > > +					   &targs.oinfo, XFS_AG_RESV_AGFL);
> > >  		if (error)
> > >  			goto out_agbp_relse;
> > >  		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
> > > @@ -2179,7 +2173,7 @@ xfs_alloc_fix_freelist(
> > >  	while (pag->pagf_flcount < need) {
> > >  		targs.agbno = 0;
> > >  		targs.maxlen = need - pag->pagf_flcount;
> > > -		targs.resv = XFS_AG_RESV_RMAPBT;
> > > +		targs.resv = XFS_AG_RESV_AGFL;
> > >  
> > >  		/* Allocate as many blocks as possible at once. */
> > >  		error = xfs_alloc_ag_vextent(&targs);
> > > @@ -2860,7 +2854,7 @@ xfs_free_extent(
> > >  	int			error;
> > >  
> > >  	ASSERT(len != 0);
> > > -	ASSERT(type != XFS_AG_RESV_RMAPBT);
> > > +	ASSERT(type != XFS_AG_RESV_AGFL);
> > >  
> > >  	if (XFS_TEST_ERROR(false, mp,
> > >  			XFS_ERRTAG_FREE_EXTENT))
> > > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> > > index e829c3e489ea..8560091554e0 100644
> > > --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> > > @@ -130,6 +130,8 @@ xfs_rmapbt_alloc_block(
> > >  	be32_add_cpu(&agf->agf_rmap_blocks, 1);
> > >  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
> > >  
> > > +	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, cur->bc_private.a.agno);
> > > +
> > >  	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> > >  	*stat = 1;
> > >  	return 0;
> > > @@ -158,6 +160,8 @@ xfs_rmapbt_free_block(
> > >  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
> > >  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> > >  
> > > +	xfs_ag_resv_rmapbt_free(cur->bc_mp, cur->bc_private.a.agno);
> > > +
> > >  	return 0;
> > >  }
> > >  
> > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > index cf84288b65ca..7aae5af71aba 100644
> > > --- a/fs/xfs/xfs_mount.h
> > > +++ b/fs/xfs/xfs_mount.h
> > > @@ -326,6 +326,7 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
> > >  /* per-AG block reservation data structures*/
> > >  enum xfs_ag_resv_type {
> > >  	XFS_AG_RESV_NONE = 0,
> > > +	XFS_AG_RESV_AGFL,
> > >  	XFS_AG_RESV_METADATA,
> > >  	XFS_AG_RESV_RMAPBT,
> > >  };
> > > -- 
> > > 2.13.6
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
