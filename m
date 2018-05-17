Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57192 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeEQF6J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 01:58:09 -0400
Date: Wed, 16 May 2018 22:58:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/22] xfs: add helpers to dispose of old btree blocks
 after a repair
Message-ID: <20180517055805.GR23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642364418.1556.17533271717583168316.stgit@magnolia>
 <20180516083232.GS23861@dastard>
 <20180516193425.GM23858@magnolia>
 <20180516223225.GX23861@dastard>
 <20180516231820.GO23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516231820.GO23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 04:18:20PM -0700, Darrick J. Wong wrote:
> On Thu, May 17, 2018 at 08:32:25AM +1000, Dave Chinner wrote:
> > On Wed, May 16, 2018 at 12:34:25PM -0700, Darrick J. Wong wrote:
> > > On Wed, May 16, 2018 at 06:32:32PM +1000, Dave Chinner wrote:
> > > > On Tue, May 15, 2018 at 03:34:04PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Now that we've plumbed in the ability to construct a list of dead btree
> > > > > blocks following a repair, add more helpers to dispose of them.  This is
> > > > > done by examining the rmapbt -- if the btree was the only owner we can
> > > > > free the block, otherwise it's crosslinked and we can only remove the
> > > > > rmapbt record.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > 
> > [...]
> > 
> > > > > +	struct xfs_owner_info		oinfo;
> > > > > +	struct xfs_perag		*pag;
> > > > > +	int				error;
> > > > > +
> > > > > +	/* Make sure there's space on the freelist. */
> > > > > +	error = xfs_repair_fix_freelist(sc, true);
> > > > > +	if (error)
> > > > > +		return error;
> > > > > +	pag = xfs_perag_get(sc->mp, sc->sa.agno);
> > > > 
> > > > Because this is how it quickly gets it gets to silly numbers of
> > > > lookups. That's two now in this function.
> > > > 
> > > > > +	if (pag->pagf_flcount == 0) {
> > > > > +		xfs_perag_put(pag);
> > > > > +		return -EFSCORRUPTED;
> > > > 
> > > > Why is having an empty freelist a problem here? It's an AG thatis
> > > > completely out of space, but it isn't corruption? And I don't see
> > > > why an empty freelist prevents us from adding a backs back onto the
> > > > AGFL?
> > 
> > I think you missed a question :P
> 
> Doh, sorry.  I don't remember exactly why I put that in there; judging
> from my notes I think the idea was that if the AG is completely full
> we'd rather shut down with a corruption signal hoping that the admin
> will run xfs_repair.
> 
> I also don't see why it's necessary now, I'll see what happens if I
> remove it.
> 
> > > > > +	/* Can we find any other rmappings? */
> > > > > +	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
> > > > > +	if (error)
> > > > > +		goto out_cur;
> > > > > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > > > > +
> > > > > +	/*
> > > > > +	 * If there are other rmappings, this block is cross linked and must
> > > > > +	 * not be freed.  Remove the reverse mapping and move on.  Otherwise,
> > > > 
> > > > Why do we just remove the reverse mapping if the block cannot be
> > > > freed? I have my suspicions that this is removing cross-links one by
> > > > one until there's only one reference left to the extent, but then I
> > > > ask "how do we know which one is the correct mapping"?
> > > 
> > > Right.  Prior to calling this function we built a totally new btree with
> > > blocks from the freespace, so now we need to remove the rmaps that
> > > covered the old btree and/or free the block.  The goal is to rebuild
> > > /all/ the trees that think they own this block so that we can free the
> > > block and not have to care which one is correct.
> > 
> > Ok, so  we've already rebuilt the new btree, and this is removing
> > stale references to cross-linked blocks that have owners different
> > to the one we are currently scanning.
> > 
> > What happens if the cross-linked block is cross-linked within the
> > same owner context?
> 
> It won't end up on the reap list in first place, because we scan every
> block of every object with the same rmap owner to construct sublist.
> Then we subtract sublist from exlist (which we got from rmap) and only
> reap the difference.
> 
> > > > > +	struct xfs_scrub_context	*sc,
> > > > > +	xfs_fsblock_t			fsbno,
> > > > > +	xfs_extlen_t			len,
> > > > > +	struct xfs_owner_info		*oinfo,
> > > > > +	enum xfs_ag_resv_type		resv)
> > > > > +{
> > > > > +	struct xfs_mount		*mp = sc->mp;
> > > > > +	int				error = 0;
> > > > > +
> > > > > +	ASSERT(xfs_sb_version_hasrmapbt(&mp->m_sb));
> > > > > +	ASSERT(sc->ip != NULL || XFS_FSB_TO_AGNO(mp, fsbno) == sc->sa.agno);
> > > > > +
> > > > > +	trace_xfs_repair_dispose_btree_extent(mp, XFS_FSB_TO_AGNO(mp, fsbno),
> > > > > +			XFS_FSB_TO_AGBNO(mp, fsbno), len);
> > > > > +
> > > > > +	for (; len > 0; len--, fsbno++) {
> > > > > +		error = xfs_repair_dispose_btree_block(sc, fsbno, oinfo, resv);
> > > > > +		if (error)
> > > > > +			return error;
> > > > 
> > > > So why do we do this one block at a time, rather than freeing it
> > > > as an entire extent in one go?
> > > 
> > > At the moment the xfs_rmap_has_other_keys helper can only tell you if
> > > there are multiple rmap owners for any part of a given extent.  For
> > > example, if the rmap records were:
> > > 
> > > (start = 35, len = 3, owner = rmap)
> > > (start = 35, len = 1, owner = refcount)
> > > (start = 37, len = 1, owner = inobt)
> > > 
> > > Notice how block 35 and 37 are crosslinked, but 36 isn't.  A call to
> > > xfs_rmap_has_other_keys(35, 3) will say "yes" but doesn't have a way to
> > > signal back that the yes applies to 35 but that the caller should try
> > > again with block 36.  Doing so would require _has_other_keys to maintain
> > > a refcount and to return to the caller any time the refcount changed,
> > > and the caller would still have to loop the extent.  It's easier to have
> > > a dumb loop for the initial implementation and optimize it if we start
> > > taking more heat than we'd like on crosslinked filesystems.
> > 
> > Well, I can see why you are doing this now, but the problems with
> > multi-block metadata makes me think that we really need to know more
> > detail of the owner in the rmap. e.g. that it's directory or
> > attribute data, not user file data and hence we can infer things
> > about expected block sizes, do the correct sort of buffer lookups
> > for invalidation, etc.
> 
> I'm not sure we can do that without causing a deadlocking problem, since
> we lock all the AG headers to rebuild a btree and in general we can't
> _iget an inode to find out if it's a dir or not.  But I have more to say
> on this in a few paragraphs...
> 
> > I'm tending towards "this needs a design doc to explain all
> > this stuff" right now. Code is great, but I'm struggling understand
> > (reverse engineer!) all the algorithms and decisions that have been
> > made from the code...
> 
> Working on it.

Nearly my bedtime, so here's the current draft:

/*
 * Reconstructing per-AG Btrees
 *
 * When a space btree is corrupt, we don't bother trying to fix it.
 * Instead, we scan secondary space metadata to derive the records that
 * should be in the damaged btree, initialize a fresh btree root, and
 * insert the records.  Note that for rebuilding the rmapbt we scan all
 * the primary data.
 *
 * However, that leaves the matter of removing all the metadata
 * describing the old broken structure.  For primary metadata we use the
 * rmap data to construct a first bitmap of every extent with a matching
 * rmap owner; we then iterate all other metadata structures with the
 * same rmap owner to construct a second bitmap of rmaps that cannot be
 * removed.  We then subtract the second bitmap from the first bitmap
 * (first & ~second) to derive the blocks that were used by the old
 * btree.  These blocks can be reaped.
 *
 * For rmapbt reconstructions we must use different tactics.  First we
 * iterate all primary metadata (this excludes the old rmapbt,
 * obviously) to generate new rmap records.  Then we iterate the new
 * rmap records to find the gaps, which should be encompass the free
 * space and the old rmapbt blocks.  That corresponds to the 'first
 * bitmap' of the previous section.  The bnobt is iterated to generate
 * the second bitmap of the previous section.  We then reap the blocks
 * corresponding to the difference just like we do for primary data.
 *
 * The comment for xfs_repair_reap_btree_extents will describe the block
 * disposal process in more detail.
 */

And later, down by xfs_repair_reap_btree_extents,


/*
 * Dispose of btree blocks from the old per-AG btree.
 *
 * Now that we've constructed a new btree to replace the damaged one, we
 * want to dispose of the blocks that (we think) the old btree was
 * using.  Previously, we used the rmapbt to construct a list of extents
 * (@exlist) with the rmap owner corresponding to the tree we rebuilt,
 * then subtracted out any other blocks with the same rmap owner that
 * are owned by another data structure.  In theory the extents in
 * @exlist are the old btree's blocks.
 *
 * Unfortunately, it's possible that the btree was crosslinked with
 * other blocks on disk.  The rmap data can tell us if there are
 * multiple owners, so if the rmapbt says there is an owner of this
 * block other than @oinfo, then the block is crosslinked.  Remove the
 * reverse mapping and continue.
 *
 * If there is one rmap record, we can free the block, which removes the
 * reverse mapping but doesn't add the block to the free space.  Our
 * repair strategy is to hope the other metadata objects crosslinked on
 * this block will be rebuilt (atop different blocks), thereby removing
 * all the cross links.
 *
 * If there are no rmap records at all, we also free the block.  If the
 * btree being rebuilt lives in the free space (bnobt/cntbt/rmapbt) then
 * there isn't supposed to be a rmap record and everything is ok.  For
 * other btrees there had to have been an rmap entry for the block to
 * have ended up on @exlist, so if it's gone now there's something wrong
 * and the fs will shut down.
 *
 * The caller is responsible for locking the AG headers for the entire
 * rebuild operation so that nothing else can sneak in and change the AG
 * state while we're not looking.  We also assume that the caller
 * already invalidated any buffers associated with @exlist.
 */

Later, for the function that finds AG btree roots for agf/agi
reconstruction:


/*
 * Find the roots of the per-AG btrees described in btree_info.
 *
 * The caller provides information about the btrees to look for by
 * passing in an array (@btree_info) of xfs_repair_find_ag_btree with
 * the (rmap owner, buf_ops, magic) fields set.  The last element of the
 * array should have a NULL buf_ops, and the (root, height) fields will
 * be set on return if anything is found.
 *
 * For every rmapbt record matching any of the rmap owners in
 * @btree_info, read each block referenced by the rmap record.  If the
 * block is a btree block from this filesystem matching any of the magic
 * numbers and has a level higher than what we've already seen, remember
 * the block and the height of the tree required to have such a block.
 * When the call completes, we return the highest block we've found for
 * each btree description; those should be the roots.
 *
 * The caller must lock the applicable per-AG header buffers (AGF, AGI)
 * to prevent other threads from changing the shape of the btrees that
 * we are looking for.  It must maintain those locks until it's safe for
 * other threads to change the btrees' shapes.
 */

--D

> 
> > > > > +/*
> > > > > + * Invalidate buffers for per-AG btree blocks we're dumping.  We assume that
> > > > > + * exlist points only to metadata blocks.
> > > > > + */
> > > > > +int
> > > > > +xfs_repair_invalidate_blocks(
> > > > > +	struct xfs_scrub_context	*sc,
> > > > > +	struct xfs_repair_extent_list	*exlist)
> > > > > +{
> > > > > +	struct xfs_repair_extent	*rex;
> > > > > +	struct xfs_repair_extent	*n;
> > > > > +	struct xfs_buf			*bp;
> > > > > +	xfs_agnumber_t			agno;
> > > > > +	xfs_agblock_t			agbno;
> > > > > +	xfs_agblock_t			i;
> > > > > +
> > > > > +	for_each_xfs_repair_extent_safe(rex, n, exlist) {
> > > > > +		agno = XFS_FSB_TO_AGNO(sc->mp, rex->fsbno);
> > > > > +		agbno = XFS_FSB_TO_AGBNO(sc->mp, rex->fsbno);
> > > > > +		for (i = 0; i < rex->len; i++) {
> > > > > +			bp = xfs_btree_get_bufs(sc->mp, sc->tp, agno,
> > > > > +					agbno + i, 0);
> > > > > +			xfs_trans_binval(sc->tp, bp);
> > > > > +		}
> > > > 
> > > > Again, this is doing things by single blocks. We do have multi-block
> > > > metadata (inodes, directory blocks, remote attrs) that, if it
> > > > is already in memory, needs to be treated as multi-block extents. If
> > > > we don't do that, we'll cause aliasing problems in the buffer cache
> > > > (see _xfs_buf_obj_cmp()) and it's all downhill from there.
> > > 
> > > I only recently started testing with filesystems containing multiblock
> > > dir/rmt metadata, and this is an unsolved problem. :(
> > 
> > That needs documenting, too. Perhaps explicitly, by rejecting repair
> > requests on filesystems or types that have multi-block constructs
> > until we solve these problems.
> 
> Trouble is, remote attr values can have an xfs_buf that spans however
> many blocks you need to store a full 64k value, and what happens if the
> rmapbt collides with that?  It sorta implies that we can't do
> invalidation on /any/ filesystem, which is unfortunate....
> 
> ...unless we have an easy way of finding /any/ buffer that points to a
> given block?  Probably not, since iirc they're indexed by the first disk
> block number.  Hm.  I suppose we could use the rmap data to look for
> anything within 64k of the logical offset of an attr/data rmap
> overlapping the same block...
> 
> ...but on second thought we only care about invalidating the buffer if
> the block belonged to the ag btree we've just killed, right?  If there's
> a multi-block buffer because it's part of a directory or an rmt block
> then the buffer is clearly owned by someone else and we don't even have
> to look for that.  Likewise, if it's a single-block buffer  but the
> block has some other magic then we don't own it and we should leave it
> alone.
> 
> > > I /think/ the solution is that we need to query the buffer cache to see
> > > if it has a buffer for the given disk blocks, and if it matches the
> > > btree we're discarding (correct magic/uuid/b_length) then we invalidate
> > > it,
> > 
> > I don't think that provides any guarantees. Even ignoring all the
> > problems with invalidation while the buffer is dirty and tracked in
> > the AIL, there's nothing stopping the other code from attempting to
> > re-instantiate the buffer due to some other access. And then we
> > have aliasing problems again....
> 
> Well, we /could/ just freeze the fs while we do repairs on any ag btree.
> 
> --D
> 
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
