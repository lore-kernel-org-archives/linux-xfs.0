Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59670 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932739AbeGDCPK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 22:15:10 -0400
Date: Tue, 3 Jul 2018 19:15:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/21] xfs: repair free space btrees
Message-ID: <20180704021504.GA32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986824747.3155.3861118263934672652.stgit@magnolia>
 <20180627032123.GF19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180627032123.GF19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 27, 2018 at 01:21:23PM +1000, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:24:07PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Rebuild the free space btrees from the gaps in the rmap btree.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> ......
> > +
> > +/* Collect an AGFL block for the not-to-release list. */
> > +static int
> > +xfs_repair_collect_agfl_block(
> > +	struct xfs_mount		*mp,
> > +	xfs_agblock_t			bno,
> > +	void				*priv)

Whoah, I never replied to this.  Oops. :(

> /me now gets confused by agfl code (xfs_repair_agfl_...) collecting btree
> blocks, and now the btree code (xfs_repair_collect_agfl... )
> collecting agfl blocks.
> 
> The naming/namespace collisions is not that nice. I think this needs
> to be xr_allocbt_collect_agfl_blocks().

> /me idly wonders about consistently renaming everything abt, bnbt, cnbt,
> fibt, ibt, rmbt and rcbt...

Hmm, I'll think about a mass rename. :)

xfs_repair_refcountbt_fiddle_faddle(...);

xrep_rcbt_fiddle_faddle(...);

xrpr_rcbt_fiddle_faddle(...);

xrprrcbt_fiddle_faddle(...);

Yeah, maybe that third one.

> 
> > +/*
> > + * Iterate all reverse mappings to find (1) the free extents, (2) the OWN_AG
> > + * extents, (3) the rmapbt blocks, and (4) the AGFL blocks.  The free space is
> > + * (1) + (2) - (3) - (4).  Figure out if we have enough free space to
> > + * reconstruct the free space btrees.  Caller must clean up the input lists
> > + * if something goes wrong.
> > + */
> > +STATIC int
> > +xfs_repair_allocbt_find_freespace(
> > +	struct xfs_scrub_context	*sc,
> > +	struct list_head		*free_extents,
> > +	struct xfs_repair_extent_list	*old_allocbt_blocks)
> > +{
> > +	struct xfs_repair_alloc		ra;
> > +	struct xfs_repair_alloc_extent	*rae;
> > +	struct xfs_btree_cur		*cur;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	xfs_agblock_t			agend;
> > +	xfs_agblock_t			nr_blocks;
> > +	int				error;
> > +
> > +	ra.extlist = free_extents;
> > +	ra.btlist = old_allocbt_blocks;
> > +	xfs_repair_init_extent_list(&ra.nobtlist);
> > +	ra.next_bno = 0;
> > +	ra.nr_records = 0;
> > +	ra.nr_blocks = 0;
> > +	ra.sc = sc;
> > +
> > +	/*
> > +	 * Iterate all the reverse mappings to find gaps in the physical
> > +	 * mappings, all the OWN_AG blocks, and all the rmapbt extents.
> > +	 */
> > +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
> > +	error = xfs_rmap_query_all(cur, xfs_repair_alloc_extent_fn, &ra);
> > +	if (error)
> > +		goto err;
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +	cur = NULL;
> > +
> > +	/* Insert a record for space between the last rmap and EOAG. */
> > +	agend = be32_to_cpu(XFS_BUF_TO_AGF(sc->sa.agf_bp)->agf_length);
> > +	if (ra.next_bno < agend) {
> > +		rae = kmem_alloc(sizeof(struct xfs_repair_alloc_extent),
> > +				KM_MAYFAIL);
> > +		if (!rae) {
> > +			error = -ENOMEM;
> > +			goto err;
> > +		}
> > +		INIT_LIST_HEAD(&rae->list);
> > +		rae->bno = ra.next_bno;
> > +		rae->len = agend - ra.next_bno;
> > +		list_add_tail(&rae->list, free_extents);
> > +		ra.nr_records++;
> > +	}
> > +
> > +	/* Collect all the AGFL blocks. */
> > +	error = xfs_agfl_walk(mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
> > +			sc->sa.agfl_bp, xfs_repair_collect_agfl_block, &ra);
> > +	if (error)
> > +		goto err;
> > +
> > +	/* Do we actually have enough space to do this? */
> > +	nr_blocks = 2 * xfs_allocbt_calc_size(mp, ra.nr_records);
> 
> 	/* Do we have enough space to rebuild both freespace trees? */
> 
> (explains the multiplication by 2)

Yep, will fix.

> > +	if (!xfs_repair_ag_has_space(sc->sa.pag, nr_blocks, XFS_AG_RESV_NONE) ||
> > +	    ra.nr_blocks < nr_blocks) {
> > +		error = -ENOSPC;
> > +		goto err;
> > +	}
> > +
> > +	/* Compute the old bnobt/cntbt blocks. */
> > +	error = xfs_repair_subtract_extents(sc, old_allocbt_blocks,
> > +			&ra.nobtlist);
> > +	if (error)
> > +		goto err;
> > +	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
> > +	return 0;
> > +
> > +err:
> > +	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
> > +	if (cur)
> > +		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> > +	return error;
> 
> Error stacking here can be cleaned up - we don't need an extra stack
> as the cursor is NULL when finished with. Hence it could just be:
> 
> 	/* Compute the old bnobt/cntbt blocks. */
> 	error = xfs_repair_subtract_extents(sc, old_allocbt_blocks,
> 			&ra.nobtlist);
> err:
> 	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
> 	if (cur)
> 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);

TBH I've been tempted for years to refactor this thing to take error
directly rather than require this XFS_BTREE_{NO,}ERROR business.
There's only two choices, and we nearly always decide using error == 0.

> 	return error;
> }
> 
> 
> > +}
> > +
> > +/*
> > + * Reset the global free block counter and the per-AG counters to make it look
> > + * like this AG has no free space.
> > + */
> > +STATIC int
> > +xfs_repair_allocbt_reset_counters(
> > +	struct xfs_scrub_context	*sc,
> > +	int				*log_flags)
> > +{
> > +	struct xfs_perag		*pag = sc->sa.pag;
> > +	struct xfs_agf			*agf;
> > +	xfs_extlen_t			oldf;
> > +	xfs_agblock_t			rmap_blocks;
> > +	int				error;
> > +
> > +	/*
> > +	 * Since we're abandoning the old bnobt/cntbt, we have to
> > +	 * decrease fdblocks by the # of blocks in those trees.
> > +	 * btreeblks counts the non-root blocks of the free space
> > +	 * and rmap btrees.  Do this before resetting the AGF counters.
> 
> Comment can use 80 columns.
> 
> > +	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> > +	rmap_blocks = be32_to_cpu(agf->agf_rmap_blocks) - 1;
> > +	oldf = pag->pagf_btreeblks + 2;
> > +	oldf -= rmap_blocks;
> 
> Convoluted. The comment really didn't help me understand what oldf
> is accounting.
> 
> Ah, rmap_blocks is actually the new btreeblks count. OK.
> 
> 	/*
> 	 * Since we're abandoning the old bnobt/cntbt, we have to decrease
> 	 * fdblocks by the # of blocks in those trees.  btreeblks counts the
> 	 * non-root blocks of the free space and rmap btrees.  Do this before
> 	 * resetting the AGF counters.
> 	 */
> 
> 	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> 
> 	/* rmap_blocks accounts root block, btreeblks doesn't */
> 	new_btblks = be32_to_cpu(agf->agf_rmap_blocks) - 1;
> 
> 	/* btreeblks doesn't account bno/cnt root blocks */
> 	to_free = pag->pagf_btreeblks + 2;
> 
> 	/* and don't account for the blocks we aren't freeing */
> 	to_free -= new_btblks;

Ok, I'll do that.

> 
> > +	error = xfs_mod_fdblocks(sc->mp, -(int64_t)oldf, false);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Reset the per-AG info, both incore and ondisk. */
> > +	pag->pagf_btreeblks = rmap_blocks;
> > +	pag->pagf_freeblks = 0;
> > +	pag->pagf_longest = 0;
> > +
> > +	agf->agf_btreeblks = cpu_to_be32(pag->pagf_btreeblks);
> 
> I'd prefer that you use new_btblks here, too. Easier to see at a
> glance that the on-disk agf is being set to the new value....

Ok.

> 
> 
> > +	agf->agf_freeblks = 0;
> > +	agf->agf_longest = 0;
> > +	*log_flags |= XFS_AGF_BTREEBLKS | XFS_AGF_LONGEST | XFS_AGF_FREEBLKS;
> > +
> > +	return 0;
> > +}
> > +
> > +/* Initialize new bnobt/cntbt roots and implant them into the AGF. */
> > +STATIC int
> > +xfs_repair_allocbt_reset_btrees(
> > +	struct xfs_scrub_context	*sc,
> > +	struct list_head		*free_extents,
> > +	int				*log_flags)
> > +{
> > +	struct xfs_owner_info		oinfo;
> > +	struct xfs_repair_alloc_extent	*cached = NULL;
> > +	struct xfs_buf			*bp;
> > +	struct xfs_perag		*pag = sc->sa.pag;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_agf			*agf;
> > +	xfs_fsblock_t			bnofsb;
> > +	xfs_fsblock_t			cntfsb;
> > +	int				error;
> > +
> > +	/* Allocate new bnobt root. */
> > +	bnofsb = xfs_repair_allocbt_alloc_block(sc, free_extents, &cached);
> > +	if (bnofsb == NULLFSBLOCK)
> > +		return -ENOSPC;
> 
> Does this happen after the free extent list has been sorted by bno
> order? It really should, that way the new root is as close to the
> the AGF as possible, and the new btree blocks will also tend to
> cluster towards the lower AG offsets.

Will do.

> > +	/* Allocate new cntbt root. */
> > +	cntfsb = xfs_repair_allocbt_alloc_block(sc, free_extents, &cached);
> > +	if (cntfsb == NULLFSBLOCK)
> > +		return -ENOSPC;
> > +
> > +	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> > +	/* Initialize new bnobt root. */
> > +	error = xfs_repair_init_btblock(sc, bnofsb, &bp, XFS_BTNUM_BNO,
> > +			&xfs_allocbt_buf_ops);
> > +	if (error)
> > +		return error;
> > +	agf->agf_roots[XFS_BTNUM_BNOi] =
> > +			cpu_to_be32(XFS_FSB_TO_AGBNO(mp, bnofsb));
> > +	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
> > +
> > +	/* Initialize new cntbt root. */
> > +	error = xfs_repair_init_btblock(sc, cntfsb, &bp, XFS_BTNUM_CNT,
> > +			&xfs_allocbt_buf_ops);
> > +	if (error)
> > +		return error;
> > +	agf->agf_roots[XFS_BTNUM_CNTi] =
> > +			cpu_to_be32(XFS_FSB_TO_AGBNO(mp, cntfsb));
> > +	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
> > +
> > +	/* Add rmap records for the btree roots */
> > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > +	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno,
> > +			XFS_FSB_TO_AGBNO(mp, bnofsb), 1, &oinfo);
> > +	if (error)
> > +		return error;
> > +	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno,
> > +			XFS_FSB_TO_AGBNO(mp, cntfsb), 1, &oinfo);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Reset the incore state. */
> > +	pag->pagf_levels[XFS_BTNUM_BNOi] = 1;
> > +	pag->pagf_levels[XFS_BTNUM_CNTi] = 1;
> > +
> > +	*log_flags |=  XFS_AGF_ROOTS | XFS_AGF_LEVELS;
> > +	return 0;
> 
> Rather than duplicating all this init code twice, would factoring it
> make sense? The only difference between the alloc/init of the two
> btrees is the array index that info is stored in....

Yeah, it would.

> > +}
> > +
> > +/* Build new free space btrees and dispose of the old one. */
> > +STATIC int
> > +xfs_repair_allocbt_rebuild_trees(
> > +	struct xfs_scrub_context	*sc,
> > +	struct list_head		*free_extents,
> > +	struct xfs_repair_extent_list	*old_allocbt_blocks)
> > +{
> > +	struct xfs_owner_info		oinfo;
> > +	struct xfs_repair_alloc_extent	*rae;
> > +	struct xfs_repair_alloc_extent	*n;
> > +	struct xfs_repair_alloc_extent	*longest;
> > +	int				error;
> > +
> > +	xfs_rmap_skip_owner_update(&oinfo);
> > +
> > +	/*
> > +	 * Insert the longest free extent in case it's necessary to
> > +	 * refresh the AGFL with multiple blocks.  If there is no longest
> > +	 * extent, we had exactly the free space we needed; we're done.
> > +	 */
> > +	longest = xfs_repair_allocbt_get_longest(free_extents);
> > +	if (!longest)
> > +		goto done;
> > +	error = xfs_repair_allocbt_free_extent(sc,
> > +			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, longest->bno),
> > +			longest->len, &oinfo);
> > +	list_del(&longest->list);
> > +	kmem_free(longest);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Insert records into the new btrees. */
> > +	list_sort(NULL, free_extents, xfs_repair_allocbt_extent_cmp);
> 
> Hmmm. I guess list sorting doesn't occur before allocating new root
> blocks. Can this get moved?

Certainly.

> ....
> 
> > +bool
> > +xfs_extent_busy_list_empty(
> > +	struct xfs_perag	*pag);
> 
> One line form for header prototypes, please.

Ok.

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
