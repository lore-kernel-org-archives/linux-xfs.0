Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14712 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754878AbeDIAXq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Apr 2018 20:23:46 -0400
Date: Mon, 9 Apr 2018 10:23:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/21] xfs: add helper routines for the repair code
Message-ID: <20180409002342.GS23861@dastard>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269903810.16346.11410639151264264247.stgit@magnolia>
 <20180406005251.GO23861@dastard>
 <20180407175542.GL7500@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180407175542.GL7500@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Apr 07, 2018 at 10:55:42AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 06, 2018 at 10:52:51AM +1000, Dave Chinner wrote:
> > On Mon, Apr 02, 2018 at 12:57:18PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Add some helper functions for repair functions that will help us to
> > > allocate and initialize new metadata blocks for btrees that we're
> > > rebuilding.
> > 
> > This is more than "helper functions" - my replay is almost 700 lines
> > long!
> > 
> > i.e. This is a stack of extent invalidation, freeing and rmap/free
> > space rebuild code. Needs a lot more description and context than
> > "helper functions".
> 
> I agree now; this patch has become overly long and incohesive.  It could
> be broken into the following pieces:
> 
> - modifying transaction allocations to take resblks
> 	or "ensuring sufficient free space to rebuild"
> 
> - rolling transactions
> 
> - allocation and reinit functions
> 
> - fixing/putting on the freelist
> 
> - dealing with leftover blocks after we rebuild a tree
> 
> - finding btree roots
> 
> - resetting superblock counters
> 
> So I'll break this up into seven smaller pieces.

Thanks!

> 
> > .....
> > > @@ -574,7 +575,10 @@ xfs_scrub_setup_fs(
> > >  	struct xfs_scrub_context	*sc,
> > >  	struct xfs_inode		*ip)
> > >  {
> > > -	return xfs_scrub_trans_alloc(sc->sm, sc->mp, &sc->tp);
> > > +	uint				resblks;
> > > +
> > > +	resblks = xfs_repair_calc_ag_resblks(sc);
> > > +	return xfs_scrub_trans_alloc(sc->sm, sc->mp, resblks, &sc->tp);
> > >  }
> > 
> > What's the block reservation for?
> 
> We rebuild a metadata structure by constructing a completely new btree
> with blocks we got from the free space and switching the root when we're
> done.  This isn't treated any differently from any other btree shape
> change, so we need to reserve blocks in the transaction.

Can you put this in a comment?

> > > +	args.tp = sc->tp;
> > > +	args.mp = sc->mp;
> > > +	args.oinfo = *oinfo;
> > > +	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.agno, 0);
> > 
> > So our target BNO is the start of the AG.
> > 
> > > +	args.minlen = 1;
> > > +	args.maxlen = 1;
> > > +	args.prod = 1;
> > > +	args.type = XFS_ALLOCTYPE_NEAR_BNO;
> > 
> > And we do a "near" search" for a single block. i.e. we are looking
> > for a single block near to the start of the AG. Basically, we are
> > looking for the extent at the left edge of the by-bno tree, which
> > may not be a single block.
> > 
> > Would it be better to do a XFS_ALLOCTYPE_THIS_AG allocation here so
> > we look up the by-size btree for a single block extent? The left
> > edge of that tree will always be the smallest free extent closest to
> > the start of the AG, and so using THIS_AG will tend to fill
> > small freespace holes rather than tear up larger free spaces for
> > single block allocations.....
> 
> Makes sense.  Originally I was thinking that we try to put the rebuilt
> btree as close to the start of the AG as possible, but there's little
> point in doing that so long as regular btree block allocation doesn't
> bother.
> 
> TBH I've been wondering on the side if it makes more sense for us to
> detect things like dm-{thinp,cache} which have large(ish) underlying
> blocks and try to consolidate metadata into a smaller number of those
> underlying blocks at the start (or the end) of the AG?  It could be
> useful to pack the metadata into a smaller number of underlying blocks
> so that if one piece of metadata gets hot enough the rest will end up in
> the fast cache as well.

Separate issue, probably can be done with an in-memory threshold
for metadata allocation (e.g. search for BNO < 5% from start of AG).
I've thought about doing somthing like that (reserved area for
metadata) for some time, but I've never really seen signficant
advantages to doing it...

> > > +/* Put a block back on the AGFL. */
> > > +int
> > > +xfs_repair_put_freelist(
> > > +	struct xfs_scrub_context	*sc,
> > > +	xfs_agblock_t			agbno)
> > > +{
> > > +	struct xfs_owner_info		oinfo;
> > > +	int				error;
> > > +
> > > +	/*
> > > +	 * Since we're "freeing" a lost block onto the AGFL, we have to
> > > +	 * create an rmap for the block prior to merging it or else other
> > > +	 * parts will break.
> > > +	 */
> > > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > > +	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
> > > +			&oinfo);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	/* Put the block on the AGFL. */
> > > +	error = xfs_alloc_put_freelist(sc->tp, sc->sa.agf_bp, sc->sa.agfl_bp,
> > > +			agbno, 0);
> > 
> > At what point do we check there's actually room in the AGFL for this
> > block?
> > 
> > > +	if (error)
> > > +		return error;
> > > +	xfs_extent_busy_insert(sc->tp, sc->sa.agno, agbno, 1,
> > > +			XFS_EXTENT_BUSY_SKIP_DISCARD);
> > > +
> > > +	/* Make sure the AGFL doesn't overfill. */
> > > +	return xfs_repair_fix_freelist(sc, true);
> > 
> > i.e. shouldn't this be done first?
> 
> 
>

???

> > > +		else if (resv == XFS_AG_RESV_AGFL)
> > > +			error = xfs_repair_put_freelist(sc, agbno);
> > > +		else
> > > +			error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
> > > +		if (error)
> > > +			break;
> > > +
> > > +		if (sc->ip)
> > > +			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
> > > +		else
> > > +			error = xfs_repair_roll_ag_trans(sc);
> > 
> > why don't we break on error here?
> 
> We do, but it's up in the for loop.

I missed that completely. I'd much prefer we don't hide "break on
error" conditions inside the for loop machinery because it is so
easy to miss...

> > > +
> > > +	trace_xfs_repair_collect_btree_extent(sc->mp,
> > > +			XFS_FSB_TO_AGNO(sc->mp, fsbno),
> > > +			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
> > > +
> > > +	rae = kmem_alloc(sizeof(struct xfs_repair_extent),
> > > +			KM_MAYFAIL | KM_NOFS);
> > 
> > Why KM_NOFS?
> 
> The caller holds a transaction and (potentially) has locked an entire
> AG, so we want to avoid recursing into the filesystem to free up memory.

If we're in transaction context, we are already under a KM_NOFS
allocation contexts. SO it shouldn't be needed here - if we are
called outside transaction context, then we need a comment
explaining it (as opposed to using KM_NOFS to shut up lockdep).

> > > +	for_each_xfs_repair_extent_safe(rae, n, exlist) {
> > > +		agno = XFS_FSB_TO_AGNO(sc->mp, rae->fsbno);
> > > +		agbno = XFS_FSB_TO_AGBNO(sc->mp, rae->fsbno);
> > > +		for (i = 0; i < rae->len; i++) {
> > > +			bp = xfs_btree_get_bufs(sc->mp, sc->tp, agno,
> > > +					agbno + i, 0);
> > > +			xfs_trans_binval(sc->tp, bp);
> > > +		}
> > > +	}
> > 
> > What if they are data blocks we are dumping? xfs_trans_binval is
> > fine for metadata blocks, but creating a stale metadata buffer and
> > logging a buffer cancel for user data blocks doesn't make any sense
> > to me....
> 
> exlist is only supposed to contain references to metadata blocks that we
> collected from the rmapbt.  The current iteration of the repair code
> shouldn't ever dump file data blocks.

That needs explanation, then. I had no idea that exlist was only for
metadata blocks...

> > > +/* Remove all the blocks in sublist from exlist. */
> > > +#define LEFT_CONTIG	(1 << 0)
> > > +#define RIGHT_CONTIG	(1 << 1)
> > 
> > Namespace, please.
> > 
> > > +int
> > > +xfs_repair_subtract_extents(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_repair_extent_list	*exlist,
> > > +	struct xfs_repair_extent_list	*sublist)
> > 
> > What is this function supposed to do? I can't really review the code
> > (looks complex) because I don't know what it's function is supposed
> > to be.
> 
> The intent is that we iterate the rmapbt for all of its records for a
> given owner to generate exlist.  Then we iterate all blocks of metadata
> structures that we are not rebuilding but have the same rmapbt owner to
> generate sublist.  This routine subtracts all the blocks mentioned in
> sublist from all the extents linked in exlist, which leaves exlist as
> the list of all blocks owned by the old version of btree that we're
> rebuilding.  The list is fed into _reap_btree_extents to free the old
> btree blocks (or merely remove the rmap if the block is crosslinked).

Comment, please :)

> > > +
> > > +	if (delta_icount) {
> > > +		error = xfs_mod_icount(mp, delta_icount);
> > > +		if (error)
> > > +			goto out;
> > > +	}
> > > +	if (delta_ifree) {
> > > +		error = xfs_mod_ifree(mp, delta_ifree);
> > > +		if (error)
> > > +			goto out;
> > > +	}
> > > +	if (delta_fdblocks) {
> > > +		error = xfs_mod_fdblocks(mp, delta_fdblocks, false);
> > > +		if (error)
> > > +			goto out;
> > > +	}
> > > +
> > > +out:
> > > +	xfs_trans_cancel(tp);
> > > +	return error;
> > 
> > Ummmm - why do we do all this superblock modification work in a
> > transaction context, and then just cancel it?
> 
> It's an empty transaction, so nothing gets dirty and nothing needs
> committing.  TBH I don't even think this is necessary, since we only use
> it for reading the agi/agf, and for that we can certainly _buf_relse
> instead of letting the _trans_cancel do it.

Yeah, it'd be better to get rid of the transaction context if we
can. It should also explain how it avoids races with ongoing
superblock counter updates...

> > > +		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
> > > +				XFS_INODES_PER_CHUNK);
> > > +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > > +		inobt_sz *= 2;
> > > +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > > +		rmapbt_sz = xfs_rmapbt_calc_size(mp, aglen);
> > > +		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
> > > +	} else {
> > > +		rmapbt_sz = xfs_rmapbt_calc_size(mp, usedlen);
> > > +		refcbt_sz = 0;
> > > +	}
> > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > +		rmapbt_sz = 0;
> > > +
> > > +	trace_xfs_repair_calc_ag_resblks_btsize(mp, sm->sm_agno, bnobt_sz,
> > > +			inobt_sz, rmapbt_sz, refcbt_sz);
> > > +
> > > +	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
> > 
> > Why are we only returning the resblks for a single tree rebuild?
> > Shouldn't it return the total blocks require to rebuild all all the
> > trees?
> 
> A repair call only ever rebuilds one btree in one AG, so I don't see why
> we'd need to reserve space to rebuild all the btrees in the AG (or the
> same btree in all AGs)... though it's possible that I don't understand
> the question?

It's not clear that we are only doing a reservation for a single
tree in an AG. needs a comment to explain the context the
reservation is being made for.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
