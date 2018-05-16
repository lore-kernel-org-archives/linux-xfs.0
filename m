Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55956 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeEPTed (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 15:34:33 -0400
Date: Wed, 16 May 2018 12:34:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/22] xfs: add helpers to dispose of old btree blocks
 after a repair
Message-ID: <20180516193425.GM23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642364418.1556.17533271717583168316.stgit@magnolia>
 <20180516083232.GS23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516083232.GS23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 06:32:32PM +1000, Dave Chinner wrote:
> On Tue, May 15, 2018 at 03:34:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we've plumbed in the ability to construct a list of dead btree
> > blocks following a repair, add more helpers to dispose of them.  This is
> > done by examining the rmapbt -- if the btree was the only owner we can
> > free the block, otherwise it's crosslinked and we can only remove the
> > rmapbt record.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/repair.c |  200 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/repair.h |    3 +
> >  2 files changed, 202 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index 8e8ecddd7537..d820e01d1146 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> > @@ -362,6 +362,173 @@ xfs_repair_init_btblock(
> >  	return 0;
> >  }
> >  
> > +/* Ensure the freelist is the correct size. */
> > +int
> > +xfs_repair_fix_freelist(
> > +	struct xfs_scrub_context	*sc,
> > +	bool				can_shrink)
> > +{
> > +	struct xfs_alloc_arg		args = {0};
> > +	int				error;
> > +
> > +	args.mp = sc->mp;
> > +	args.tp = sc->tp;
> > +	args.agno = sc->sa.agno;
> > +	args.alignment = 1;
> > +	args.pag = xfs_perag_get(args.mp, sc->sa.agno);
> > +
> > +	error = xfs_alloc_fix_freelist(&args,
> > +			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
> > +	xfs_perag_put(args.pag);
> 
> with all these pag lookups, I'm starting to wonder if you should
> just add a lookup and store the pag in the scrub context? That'd
> save a lot of lookups - the pag structures never go away and i never
> really intended them to be used like this in single, very short use
> contexts. Grab once per operation, hold the reference across the
> entire operation context, then release it....

Ok, I'll change xfs_scrub_ag_{init,free} to get / put the perag
structure so we don't have to do this repeatedly.

> > +	return error;
> > +}
> > +
> > +/*
> > + * Put a block back on the AGFL.
> > + */
> > +STATIC int
> > +xfs_repair_put_freelist(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_agblock_t			agbno)
> > +{
> > +	struct xfs_owner_info		oinfo;
> > +	struct xfs_perag		*pag;
> > +	int				error;
> > +
> > +	/* Make sure there's space on the freelist. */
> > +	error = xfs_repair_fix_freelist(sc, true);
> > +	if (error)
> > +		return error;
> > +	pag = xfs_perag_get(sc->mp, sc->sa.agno);
> 
> Because this is how it quickly gets it gets to silly numbers of
> lookups. That's two now in this function.
> 
> > +	if (pag->pagf_flcount == 0) {
> > +		xfs_perag_put(pag);
> > +		return -EFSCORRUPTED;
> 
> Why is having an empty freelist a problem here? It's an AG thatis
> completely out of space, but it isn't corruption? And I don't see
> why an empty freelist prevents us from adding a backs back onto the
> AGFL?
> 
> > +	}
> > +	xfs_perag_put(pag);
> > +
> > +	/*
> > +	 * Since we're "freeing" a lost block onto the AGFL, we have to
> > +	 * create an rmap for the block prior to merging it or else other
> > +	 * parts will break.
> > +	 */
> > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > +	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
> > +			&oinfo);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Put the block on the AGFL. */
> > +	error = xfs_alloc_put_freelist(sc->tp, sc->sa.agf_bp, sc->sa.agfl_bp,
> > +			agbno, 0);
> 
> There's another pag lookup in here.
> 
> > +	if (error)
> > +		return error;
> > +	xfs_extent_busy_insert(sc->tp, sc->sa.agno, agbno, 1,
> > +			XFS_EXTENT_BUSY_SKIP_DISCARD);
> 
> And another in here, so 4 perag lookups for the same structure in
> one simple operation. The code here in the function is fine, but I
> really think we need to rethink how we use the perag in our
> allocation code...

Yeah.  If we ever introduce the ability to lock an AG for the duration
of a transaction then we might consider linking the perag structures
through the transaction at the same time so that these library functions
can skip the _perag_get.

> > +
> > +	return 0;
> > +}
> > +
> > +/* Dispose of a single metadata block. */
> > +STATIC int
> > +xfs_repair_dispose_btree_block(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_fsblock_t			fsbno,
> > +	struct xfs_owner_info		*oinfo,
> > +	enum xfs_ag_resv_type		resv)
> > +{
> > +	struct xfs_btree_cur		*cur;
> > +	struct xfs_buf			*agf_bp = NULL;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			agbno;
> > +	bool				has_other_rmap;
> > +	int				error;
> > +
> > +	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
> > +	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
> > +
> > +	if (sc->ip) {
> > +		/* Repairing per-inode metadata, read in the AGF. */
> 
> This would be better with a comment above saying:
> 
> 	/*
> 	 * If we are repairing per-inode metadata, we need to read
> 	 * in the AGF buffer. Otherwise we can re-use the existing
> 	 * AGF buffer we set up for repairing the per-AG btrees.
> 	 */

Ok.

> > +		error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf_bp);
> > +		if (error)
> > +			return error;
> > +		if (!agf_bp)
> > +			return -ENOMEM;
> > +	} else {
> > +		/* Repairing per-AG btree, reuse existing AGF buffer. */
> > +		agf_bp = sc->sa.agf_bp;
> > +	}
> > +	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno);
> > +
> > +	/* Can we find any other rmappings? */
> > +	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
> > +	if (error)
> > +		goto out_cur;
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +
> > +	/*
> > +	 * If there are other rmappings, this block is cross linked and must
> > +	 * not be freed.  Remove the reverse mapping and move on.  Otherwise,
> 
> Why do we just remove the reverse mapping if the block cannot be
> freed? I have my suspicions that this is removing cross-links one by
> one until there's only one reference left to the extent, but then I
> ask "how do we know which one is the correct mapping"?

Right.  Prior to calling this function we built a totally new btree with
blocks from the freespace, so now we need to remove the rmaps that
covered the old btree and/or free the block.  The goal is to rebuild
/all/ the trees that think they own this block so that we can free the
block and not have to care which one is correct.

> i.e. this comment raised more questions about the algorithm for
> dealing with cross-linked blocks - which doesn't appear to be
> explained anywhere - than it answers....
> 
> > +	 * we were the only owner of the block, so free the extent, which will
> > +	 * also remove the rmap.
> > +	 */
> > +	if (has_other_rmap)
> > +		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
> > +	else if (resv == XFS_AG_RESV_AGFL)
> > +		error = xfs_repair_put_freelist(sc, agbno);
> > +	else
> > +		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
> > +	if (agf_bp != sc->sa.agf_bp)
> > +		xfs_trans_brelse(sc->tp, agf_bp);
> > +	if (error)
> > +		return error;
> > +
> > +	if (sc->ip)
> > +		return xfs_trans_roll_inode(&sc->tp, sc->ip);
> > +	return xfs_repair_roll_ag_trans(sc);
> > +
> > +out_cur:
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> > +	if (agf_bp != sc->sa.agf_bp)
> > +		xfs_trans_brelse(sc->tp, agf_bp);
> > +	return error;
> > +}
> > +
> > +/*
> > + * Dispose of a given metadata extent.
> > + *
> > + * If the rmapbt says the extent has multiple owners, we simply remove the
> > + * rmap associated with this owner hoping that we'll eventually disentangle
> > + * the crosslinked metadata.  Otherwise, there's one owner, so call the
> > + * regular free code to remove the rmap and free the extent.  Any existing
> > + * buffers for the blocks in the extent must have been _binval'd previously.
> 
> Ok, so there's a little more detail about cross-linked files. Seems
> my suspicions of "remove and hope" were close to the mark :P
> 
> Perhaps we need a document that describes the various algorithms we
> use for resolving these problems, so they can be discussed and
> improved without having to troll through the code to understand?

Yeah.  I'll work on consolidating the crosslink functions after lunch
and documenting how the tree rebuilder interacts with fixing crosslinks.

> > + */
> > +STATIC int
> > +xfs_repair_dispose_btree_extent(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_fsblock_t			fsbno,
> > +	xfs_extlen_t			len,
> > +	struct xfs_owner_info		*oinfo,
> > +	enum xfs_ag_resv_type		resv)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	int				error = 0;
> > +
> > +	ASSERT(xfs_sb_version_hasrmapbt(&mp->m_sb));
> > +	ASSERT(sc->ip != NULL || XFS_FSB_TO_AGNO(mp, fsbno) == sc->sa.agno);
> > +
> > +	trace_xfs_repair_dispose_btree_extent(mp, XFS_FSB_TO_AGNO(mp, fsbno),
> > +			XFS_FSB_TO_AGBNO(mp, fsbno), len);
> > +
> > +	for (; len > 0; len--, fsbno++) {
> > +		error = xfs_repair_dispose_btree_block(sc, fsbno, oinfo, resv);
> > +		if (error)
> > +			return error;
> 
> So why do we do this one block at a time, rather than freeing it
> as an entire extent in one go?

At the moment the xfs_rmap_has_other_keys helper can only tell you if
there are multiple rmap owners for any part of a given extent.  For
example, if the rmap records were:

(start = 35, len = 3, owner = rmap)
(start = 35, len = 1, owner = refcount)
(start = 37, len = 1, owner = inobt)

Notice how block 35 and 37 are crosslinked, but 36 isn't.  A call to
xfs_rmap_has_other_keys(35, 3) will say "yes" but doesn't have a way to
signal back that the yes applies to 35 but that the caller should try
again with block 36.  Doing so would require _has_other_keys to maintain
a refcount and to return to the caller any time the refcount changed,
and the caller would still have to loop the extent.  It's easier to have
a dumb loop for the initial implementation and optimize it if we start
taking more heat than we'd like on crosslinked filesystems.

> And if there is only a single caller, why not just open code the loop
> in the caller?

I certainly could do that.

> 
> > +/*
> > + * Invalidate buffers for per-AG btree blocks we're dumping.  We assume that
> > + * exlist points only to metadata blocks.
> > + */
> > +int
> > +xfs_repair_invalidate_blocks(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_repair_extent_list	*exlist)
> > +{
> > +	struct xfs_repair_extent	*rex;
> > +	struct xfs_repair_extent	*n;
> > +	struct xfs_buf			*bp;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			agbno;
> > +	xfs_agblock_t			i;
> > +
> > +	for_each_xfs_repair_extent_safe(rex, n, exlist) {
> > +		agno = XFS_FSB_TO_AGNO(sc->mp, rex->fsbno);
> > +		agbno = XFS_FSB_TO_AGBNO(sc->mp, rex->fsbno);
> > +		for (i = 0; i < rex->len; i++) {
> > +			bp = xfs_btree_get_bufs(sc->mp, sc->tp, agno,
> > +					agbno + i, 0);
> > +			xfs_trans_binval(sc->tp, bp);
> > +		}
> 
> Again, this is doing things by single blocks. We do have multi-block
> metadata (inodes, directory blocks, remote attrs) that, if it
> is already in memory, needs to be treated as multi-block extents. If
> we don't do that, we'll cause aliasing problems in the buffer cache
> (see _xfs_buf_obj_cmp()) and it's all downhill from there.

I only recently started testing with filesystems containing multiblock
dir/rmt metadata, and this is an unsolved problem. :(

I /think/ the solution is that we need to query the buffer cache to see
if it has a buffer for the given disk blocks, and if it matches the
btree we're discarding (correct magic/uuid/b_length) then we invalidate
it, otherwise we assume that something else owns it and move on.  I
think that we have to do this on a block-by-block basis since we have
no idea what else could be crosslinked with the old btree.

for_each_xfs_repair_extent_safe(rex, n, exlist) {
	agno = ...;
	agbno = ...;
	for (i = 0; i < rex->len, i++) {
		/* don't touch ag headers or post-eofs blocks */
		if (!xfs_verify_agbno(sc->mp, agno, agbno))
			continue;
		bp = xfs_buf_get_anything_caching_this_block(...);
		if (!bp)
			continue;
		if (bp does not belong to this tree) {
			xfs_trans_brelse(sc->tp, bp);
			continue;
		}
		xfs_trans_binval(sc->tp, bp);
	}
}

> That's why I get worried when I see assumptions that we can process
> contiguous metadata ranges in single block buffers....

:/

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
