Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:60301 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751153AbeEPWc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 18:32:28 -0400
Date: Thu, 17 May 2018 08:32:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/22] xfs: add helpers to dispose of old btree blocks
 after a repair
Message-ID: <20180516223225.GX23861@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642364418.1556.17533271717583168316.stgit@magnolia>
 <20180516083232.GS23861@dastard>
 <20180516193425.GM23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516193425.GM23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 12:34:25PM -0700, Darrick J. Wong wrote:
> On Wed, May 16, 2018 at 06:32:32PM +1000, Dave Chinner wrote:
> > On Tue, May 15, 2018 at 03:34:04PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Now that we've plumbed in the ability to construct a list of dead btree
> > > blocks following a repair, add more helpers to dispose of them.  This is
> > > done by examining the rmapbt -- if the btree was the only owner we can
> > > free the block, otherwise it's crosslinked and we can only remove the
> > > rmapbt record.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---

[...]

> > > +	struct xfs_owner_info		oinfo;
> > > +	struct xfs_perag		*pag;
> > > +	int				error;
> > > +
> > > +	/* Make sure there's space on the freelist. */
> > > +	error = xfs_repair_fix_freelist(sc, true);
> > > +	if (error)
> > > +		return error;
> > > +	pag = xfs_perag_get(sc->mp, sc->sa.agno);
> > 
> > Because this is how it quickly gets it gets to silly numbers of
> > lookups. That's two now in this function.
> > 
> > > +	if (pag->pagf_flcount == 0) {
> > > +		xfs_perag_put(pag);
> > > +		return -EFSCORRUPTED;
> > 
> > Why is having an empty freelist a problem here? It's an AG thatis
> > completely out of space, but it isn't corruption? And I don't see
> > why an empty freelist prevents us from adding a backs back onto the
> > AGFL?

I think you missed a question :P

> > > +	/* Can we find any other rmappings? */
> > > +	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
> > > +	if (error)
> > > +		goto out_cur;
> > > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > > +
> > > +	/*
> > > +	 * If there are other rmappings, this block is cross linked and must
> > > +	 * not be freed.  Remove the reverse mapping and move on.  Otherwise,
> > 
> > Why do we just remove the reverse mapping if the block cannot be
> > freed? I have my suspicions that this is removing cross-links one by
> > one until there's only one reference left to the extent, but then I
> > ask "how do we know which one is the correct mapping"?
> 
> Right.  Prior to calling this function we built a totally new btree with
> blocks from the freespace, so now we need to remove the rmaps that
> covered the old btree and/or free the block.  The goal is to rebuild
> /all/ the trees that think they own this block so that we can free the
> block and not have to care which one is correct.

Ok, so  we've already rebuilt the new btree, and this is removing
stale references to cross-linked blocks that have owners different
to the one we are currently scanning.

What happens if the cross-linked block is cross-linked within the
same owner context?

> > > +	struct xfs_scrub_context	*sc,
> > > +	xfs_fsblock_t			fsbno,
> > > +	xfs_extlen_t			len,
> > > +	struct xfs_owner_info		*oinfo,
> > > +	enum xfs_ag_resv_type		resv)
> > > +{
> > > +	struct xfs_mount		*mp = sc->mp;
> > > +	int				error = 0;
> > > +
> > > +	ASSERT(xfs_sb_version_hasrmapbt(&mp->m_sb));
> > > +	ASSERT(sc->ip != NULL || XFS_FSB_TO_AGNO(mp, fsbno) == sc->sa.agno);
> > > +
> > > +	trace_xfs_repair_dispose_btree_extent(mp, XFS_FSB_TO_AGNO(mp, fsbno),
> > > +			XFS_FSB_TO_AGBNO(mp, fsbno), len);
> > > +
> > > +	for (; len > 0; len--, fsbno++) {
> > > +		error = xfs_repair_dispose_btree_block(sc, fsbno, oinfo, resv);
> > > +		if (error)
> > > +			return error;
> > 
> > So why do we do this one block at a time, rather than freeing it
> > as an entire extent in one go?
> 
> At the moment the xfs_rmap_has_other_keys helper can only tell you if
> there are multiple rmap owners for any part of a given extent.  For
> example, if the rmap records were:
> 
> (start = 35, len = 3, owner = rmap)
> (start = 35, len = 1, owner = refcount)
> (start = 37, len = 1, owner = inobt)
> 
> Notice how block 35 and 37 are crosslinked, but 36 isn't.  A call to
> xfs_rmap_has_other_keys(35, 3) will say "yes" but doesn't have a way to
> signal back that the yes applies to 35 but that the caller should try
> again with block 36.  Doing so would require _has_other_keys to maintain
> a refcount and to return to the caller any time the refcount changed,
> and the caller would still have to loop the extent.  It's easier to have
> a dumb loop for the initial implementation and optimize it if we start
> taking more heat than we'd like on crosslinked filesystems.

Well, I can see why you are doing this now, but the problems with
multi-block metadata makes me think that we really need to know more
detail of the owner in the rmap. e.g. that it's directory or
attribute data, not user file data and hence we can infer things
about expected block sizes, do the correct sort of buffer lookups
for invalidation, etc.

I'm tending towards "this needs a design doc to explain all
this stuff" right now. Code is great, but I'm struggling understand
(reverse engineer!) all the algorithms and decisions that have been
made from the code...

> > > +/*
> > > + * Invalidate buffers for per-AG btree blocks we're dumping.  We assume that
> > > + * exlist points only to metadata blocks.
> > > + */
> > > +int
> > > +xfs_repair_invalidate_blocks(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_repair_extent_list	*exlist)
> > > +{
> > > +	struct xfs_repair_extent	*rex;
> > > +	struct xfs_repair_extent	*n;
> > > +	struct xfs_buf			*bp;
> > > +	xfs_agnumber_t			agno;
> > > +	xfs_agblock_t			agbno;
> > > +	xfs_agblock_t			i;
> > > +
> > > +	for_each_xfs_repair_extent_safe(rex, n, exlist) {
> > > +		agno = XFS_FSB_TO_AGNO(sc->mp, rex->fsbno);
> > > +		agbno = XFS_FSB_TO_AGBNO(sc->mp, rex->fsbno);
> > > +		for (i = 0; i < rex->len; i++) {
> > > +			bp = xfs_btree_get_bufs(sc->mp, sc->tp, agno,
> > > +					agbno + i, 0);
> > > +			xfs_trans_binval(sc->tp, bp);
> > > +		}
> > 
> > Again, this is doing things by single blocks. We do have multi-block
> > metadata (inodes, directory blocks, remote attrs) that, if it
> > is already in memory, needs to be treated as multi-block extents. If
> > we don't do that, we'll cause aliasing problems in the buffer cache
> > (see _xfs_buf_obj_cmp()) and it's all downhill from there.
> 
> I only recently started testing with filesystems containing multiblock
> dir/rmt metadata, and this is an unsolved problem. :(

That needs documenting, too. Perhaps explicitly, by rejecting repair
requests on filesystems or types that have multi-block constructs
until we solve these problems.

> I /think/ the solution is that we need to query the buffer cache to see
> if it has a buffer for the given disk blocks, and if it matches the
> btree we're discarding (correct magic/uuid/b_length) then we invalidate
> it,

I don't think that provides any guarantees. Even ignoring all the
problems with invalidation while the buffer is dirty and tracked in
the AIL, there's nothing stopping the other code from attempting to
re-instantiate the buffer due to some other access. And then we
have aliasing problems again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
