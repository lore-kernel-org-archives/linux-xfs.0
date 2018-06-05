Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932105AbeFEXTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 19:19:01 -0400
Date: Tue, 5 Jun 2018 16:18:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/14] xfs: repair the AGF and AGFL
Message-ID: <20180605231856.GO9437@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
 <152770864591.11611.5564813732568495676.stgit@magnolia>
 <20180604015255.GJ10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180604015255.GJ10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 11:52:55AM +1000, Dave Chinner wrote:
> On Wed, May 30, 2018 at 12:30:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Regenerate the AGF and AGFL from the rmap data.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> [...]
> 
> > +/* Repair the AGF. */
> > +int
> > +xfs_repair_agf(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_repair_find_ag_btree	fab[] = {
> > +		{
> > +			.rmap_owner = XFS_RMAP_OWN_AG,
> > +			.buf_ops = &xfs_allocbt_buf_ops,
> > +			.magic = XFS_ABTB_CRC_MAGIC,
> > +		},
> > +		{
> > +			.rmap_owner = XFS_RMAP_OWN_AG,
> > +			.buf_ops = &xfs_allocbt_buf_ops,
> > +			.magic = XFS_ABTC_CRC_MAGIC,
> > +		},
> > +		{
> > +			.rmap_owner = XFS_RMAP_OWN_AG,
> > +			.buf_ops = &xfs_rmapbt_buf_ops,
> > +			.magic = XFS_RMAP_CRC_MAGIC,
> > +		},
> > +		{
> > +			.rmap_owner = XFS_RMAP_OWN_REFC,
> > +			.buf_ops = &xfs_refcountbt_buf_ops,
> > +			.magic = XFS_REFC_CRC_MAGIC,
> > +		},
> > +		{
> > +			.buf_ops = NULL,
> > +		},
> > +	};
> > +	struct xfs_repair_agf_allocbt	raa;
> > +	struct xfs_agf			old_agf;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_buf			*agf_bp;
> > +	struct xfs_buf			*agfl_bp;
> > +	struct xfs_agf			*agf;
> > +	struct xfs_btree_cur		*cur = NULL;
> > +	struct xfs_perag		*pag;
> > +	xfs_agblock_t			blocks;
> > +	xfs_agblock_t			freesp_blocks;
> > +	int64_t				delta_fdblocks = 0;
> > +	int				error;
> > +
> > +	/* We require the rmapbt to rebuild anything. */
> > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > +		return -EOPNOTSUPP;
> > +
> > +	xfs_scrub_perag_get(sc->mp, &sc->sa);
> > +	pag = sc->sa.pag;
> > +	memset(&raa, 0, sizeof(raa));
> > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGF_DADDR(mp)),
> > +			XFS_FSS_TO_BB(mp, 1), 0, &agf_bp, NULL);
> > +	if (error)
> > +		return error;
> > +	agf_bp->b_ops = &xfs_agf_buf_ops;
> > +
> > +	/*
> > +	 * Load the AGFL so that we can screen out OWN_AG blocks that
> > +	 * are on the AGFL now; these blocks might have once been part
> > +	 * of the bno/cnt/rmap btrees but are not now.
> > +	 */
> > +	error = xfs_alloc_read_agfl(mp, sc->tp, sc->sa.agno, &agfl_bp);
> > +	if (error)
> > +		return error;
> > +	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(agf_bp), agfl_bp,
> > +			xfs_repair_agf_check_agfl_block, sc);
> > +	if (error)
> > +		return error;
> 
> THis is a bit of a chicken/egg situation, isn't it? We haven't
> repaired the AGFL yet, so how do we know what is valid here?

Yep.  The AGF is corrupt, so we have to trust the AGFL contents because
we can't do any serious cross-referencing with any of the btrees rooted
in the AGF.  If the AGFL contents are obviously bad then we'll bail out.

> > +	/* Find the btree roots. */
> > +	error = xfs_repair_find_ag_btree_roots(sc, agf_bp, fab, agfl_bp);
> > +	if (error)
> > +		return error;
> > +	if (fab[0].root == NULLAGBLOCK || fab[0].height > XFS_BTREE_MAXLEVELS ||
> > +	    fab[1].root == NULLAGBLOCK || fab[1].height > XFS_BTREE_MAXLEVELS ||
> > +	    fab[2].root == NULLAGBLOCK || fab[2].height > XFS_BTREE_MAXLEVELS)
> > +		return -EFSCORRUPTED;
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
> > +	    (fab[3].root == NULLAGBLOCK || fab[3].height > XFS_BTREE_MAXLEVELS))
> > +		return -EFSCORRUPTED;
> > +
> > +	/* Start rewriting the header. */
> > +	agf = XFS_BUF_TO_AGF(agf_bp);
> > +	memcpy(&old_agf, agf, sizeof(old_agf));
> > +
> > +	/*
> > +	 * We relied on the rmapbt to reconstruct the AGF.  If we get a
> > +	 * different root then something's seriously wrong.
> > +	 */
> > +	if (be32_to_cpu(old_agf.agf_roots[XFS_BTNUM_RMAPi]) != fab[2].root)
> > +		return -EFSCORRUPTED;
> > +	memset(agf, 0, mp->m_sb.sb_sectsize);
> > +	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
> > +	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
> > +	agf->agf_seqno = cpu_to_be32(sc->sa.agno);
> > +	agf->agf_length = cpu_to_be32(xfs_ag_block_count(mp, sc->sa.agno));
> > +	agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(fab[0].root);
> > +	agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(fab[1].root);
> > +	agf->agf_roots[XFS_BTNUM_RMAPi] = cpu_to_be32(fab[2].root);
> > +	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(fab[0].height);
> > +	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(fab[1].height);
> > +	agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(fab[2].height);
> > +	agf->agf_flfirst = old_agf.agf_flfirst;
> > +	agf->agf_fllast = old_agf.agf_fllast;
> > +	agf->agf_flcount = old_agf.agf_flcount;
> > +	if (xfs_sb_version_hascrc(&mp->m_sb))
> > +		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > +		agf->agf_refcount_root = cpu_to_be32(fab[3].root);
> > +		agf->agf_refcount_level = cpu_to_be32(fab[3].height);
> > +	}
> 
> Can we factor this function allow rebuild operation lines?

Yes...

> That will help document all the different pieces it is putting
> together. E.g move the AGF header init to before
> xfs_repair_find_ag_btree_roots(), and then pass it into
> xfs_repair_agf_rebuild_roots() which contains the above fab specific
> code.

...however, that's the second (and admittedly not well documented)
second chicken-egg -- we find the agf btree roots by probing the rmapbt,
which is rooted in the agf.  So xfs_repair_find_ag_btree_roots has to be
fed the old agf_bp buffer, and if that blows up then we bail out without
changing anything.

> 
> > +
> > +	/* Update the AGF counters from the bnobt. */
> > +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> > +			XFS_BTNUM_BNO);
> > +	raa.sc = sc;
> > +	error = xfs_alloc_query_all(cur, xfs_repair_agf_walk_allocbt, &raa);
> > +	if (error)
> > +		goto err;
> > +	error = xfs_btree_count_blocks(cur, &blocks);
> > +	if (error)
> > +		goto err;
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +	freesp_blocks = blocks - 1;
> > +	agf->agf_freeblks = cpu_to_be32(raa.freeblks);
> > +	agf->agf_longest = cpu_to_be32(raa.longest);
> > +
> > +	/* Update the AGF counters from the cntbt. */
> > +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> > +			XFS_BTNUM_CNT);
> > +	error = xfs_btree_count_blocks(cur, &blocks);
> > +	if (error)
> > +		goto err;
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +	freesp_blocks += blocks - 1;
> > +
> > +	/* Update the AGF counters from the rmapbt. */
> > +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> > +	error = xfs_btree_count_blocks(cur, &blocks);
> > +	if (error)
> > +		goto err;
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +	agf->agf_rmap_blocks = cpu_to_be32(blocks);
> > +	freesp_blocks += blocks - 1;
> > +
> > +	/* Update the AGF counters from the refcountbt. */
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > +		cur = xfs_refcountbt_init_cursor(mp, sc->tp, agf_bp,
> > +				sc->sa.agno, NULL);
> > +		error = xfs_btree_count_blocks(cur, &blocks);
> > +		if (error)
> > +			goto err;
> > +		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +		agf->agf_refcount_blocks = cpu_to_be32(blocks);
> > +	}
> > +	agf->agf_btreeblks = cpu_to_be32(freesp_blocks);
> > +	cur = NULL;
> 
> Then this is xfs_repair_agf_rebuild_counters()

Ok.

> > +
> > +	/* Trigger reinitialization of the in-core data. */
> > +	if (raa.freeblks != be32_to_cpu(old_agf.agf_freeblks)) {
> > +		delta_fdblocks += (int64_t)raa.freeblks -
> > +				be32_to_cpu(old_agf.agf_freeblks);
> > +		if (pag->pagf_init)
> > +			pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
> > +	}
> > +
> > +	if (freesp_blocks != be32_to_cpu(old_agf.agf_btreeblks)) {
> > +		delta_fdblocks += (int64_t)freesp_blocks -
> > +				be32_to_cpu(old_agf.agf_btreeblks);
> > +		if (pag->pagf_init)
> > +			pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
> > +	}
> > +
> > +	if (pag->pagf_init &&
> > +	    (raa.longest != be32_to_cpu(old_agf.agf_longest) ||
> > +	     fab[0].height != be32_to_cpu(old_agf.agf_levels[XFS_BTNUM_BNOi]) ||
> > +	     fab[1].height != be32_to_cpu(old_agf.agf_levels[XFS_BTNUM_CNTi]) ||
> > +	     fab[2].height != be32_to_cpu(old_agf.agf_levels[XFS_BTNUM_RMAPi]) ||
> > +	     fab[3].height != be32_to_cpu(old_agf.agf_refcount_level))) {
> > +		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
> > +		pag->pagf_levels[XFS_BTNUM_BNOi] =
> > +				be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
> > +		pag->pagf_levels[XFS_BTNUM_CNTi] =
> > +				be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
> > +		pag->pagf_levels[XFS_BTNUM_RMAPi] =
> > +				be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
> > +		pag->pagf_refcount_level =
> > +				be32_to_cpu(agf->agf_refcount_level);
> > +	}
> > +
> > +	error = xfs_repair_mod_fdblocks(sc, delta_fdblocks);
> > +	if (error)
> > +		goto err;
> 
> And xfs_repair_agf_update_pag().

Ok.

> > +
> > +	/* Write this to disk. */
> > +	xfs_trans_buf_set_type(sc->tp, agf_bp, XFS_BLFT_AGF_BUF);
> > +	xfs_trans_log_buf(sc->tp, agf_bp, 0, BBTOB(agf_bp->b_length) - 1);
> > +	return error;
> > +
> > +err:
> > +	if (cur)
> > +		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
> > +				XFS_BTREE_NOERROR);
> > +	memcpy(agf, &old_agf, sizeof(old_agf));
> > +	return error;
> > +}
> > +
> > +/* AGFL */
> > +
> > +struct xfs_repair_agfl {
> > +	struct xfs_repair_extent_list	freesp_list;
> > +	struct xfs_repair_extent_list	agmeta_list;
> > +	struct xfs_scrub_context	*sc;
> > +};
> > +
> > +/* Record all freespace information. */
> > +STATIC int
> > +xfs_repair_agfl_rmap_fn(
> > +	struct xfs_btree_cur		*cur,
> > +	struct xfs_rmap_irec		*rec,
> > +	void				*priv)
> > +{
> > +	struct xfs_repair_agfl		*ra = priv;
> > +	struct xfs_buf			*bp;
> > +	xfs_fsblock_t			fsb;
> > +	int				i;
> > +	int				error = 0;
> > +
> > +	if (xfs_scrub_should_terminate(ra->sc, &error))
> > +		return error;
> > +
> > +	/* Record all the OWN_AG blocks... */
> > +	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
> > +		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> > +				rec->rm_startblock);
> > +		error = xfs_repair_collect_btree_extent(ra->sc,
> > +				&ra->freesp_list, fsb, rec->rm_blockcount);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	/* ...and all the rmapbt blocks... */
> > +	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
> 
> What is the significance of "cur->bc_ptrs[i] == 1"?
> 
> This loop looks like it is walking the btree path to this leaf, but
> bc_ptrs[] will only have a "1" in it if we are at the left-most edge
> of the tree, right? so what about all the other btree blocks?

Close.  We're walking up the tree from the leaf towards the root.  For
each level, we assume that if bc_ptrs[level] == 1, then this is the
first time we've seen the block at that level, so we remember that we
saw this rmapbt block.  bc_ptrs is the offset within a block, not the
offset for the entire level.

So if our rmapbt tree is:

   4
 / | \
1  2  3

Pretend for this example that each leaf block has 100 rmap records.  For
the first rmap record, we'll observe that bc_ptrs[0] == 1, so we record
that we saw block 1.  Then we observe that bc_ptrs[1] == 1, so we record
block 4.  agmeta_list is [1, 4].

For the second rmap record, we see that bc_ptrs[0] == 2, so we exit the
loop.  agmeta_list remains [1, 4].

For the 101st rmap record, we've moved onto leaf block 2.  Now
bc_ptrs[0] == 1 again, so we record that we saw block 2.  We see that
bc_ptrs[1] == 2, so we exit the loop.  agmeta_list = [1, 4, 2].

For the 102nd rmap, bc_ptrs[0] == 2, so we exit.

For the 201st rmap record, we've moved on to leaf block 3.  bc_ptrs[0]
== 1, so we add 3 to agmeta_list.  [1, 4, 2, 3].

> > +		xfs_btree_get_block(cur, i, &bp);
> > +		if (!bp)
> > +			continue;
> > +		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> > +		error = xfs_repair_collect_btree_extent(ra->sc,
> > +				&ra->agmeta_list, fsb, 1);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/* Add a btree block to the agmeta list. */
> > +STATIC int
> > +xfs_repair_agfl_visit_btblock(
> > +	struct xfs_btree_cur		*cur,
> > +	int				level,
> > +	void				*priv)
> > +{
> > +	struct xfs_repair_agfl		*ra = priv;
> > +	struct xfs_buf			*bp;
> > +	xfs_fsblock_t			fsb;
> > +	int				error = 0;
> > +
> > +	if (xfs_scrub_should_terminate(ra->sc, &error))
> > +		return error;
> > +
> > +	xfs_btree_get_block(cur, level, &bp);
> > +	if (!bp)
> > +		return 0;
> > +
> > +	fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> > +	return xfs_repair_collect_btree_extent(ra->sc, &ra->agmeta_list,
> > +			fsb, 1);
> > +}
> > +
> > +/* Repair the AGFL. */
> > +int
> > +xfs_repair_agfl(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_repair_agfl		ra;
> > +	struct xfs_owner_info		oinfo;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_buf			*agf_bp;
> > +	struct xfs_buf			*agfl_bp;
> > +	struct xfs_agf			*agf;
> > +	struct xfs_agfl			*agfl;
> > +	struct xfs_btree_cur		*cur = NULL;
> > +	__be32				*agfl_bno;
> > +	struct xfs_repair_extent	*rae;
> > +	struct xfs_repair_extent	*n;
> > +	xfs_agblock_t			flcount;
> > +	xfs_agblock_t			agbno;
> > +	xfs_agblock_t			bno;
> > +	xfs_agblock_t			old_flcount;
> > +	int				error;
> 
> Can we factor this function a little?

Or a lot. :)

> > +
> > +	/* We require the rmapbt to rebuild anything. */
> > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > +		return -EOPNOTSUPP;
> > +
> > +	xfs_scrub_perag_get(sc->mp, &sc->sa);
> > +	xfs_repair_init_extent_list(&ra.freesp_list);
> > +	xfs_repair_init_extent_list(&ra.agmeta_list);
> > +	ra.sc = sc;
> > +
> > +	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
> > +	if (error)
> > +		return error;
> > +	if (!agf_bp)
> > +		return -ENOMEM;
> > +
> > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGFL_DADDR(mp)),
> > +			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
> > +	if (error)
> > +		return error;
> > +	agfl_bp->b_ops = &xfs_agfl_buf_ops;
> 
> Be nice to have a __xfs_alloc_read_agfl() function that didn't set
> the ops, and have this and xfs_alloc_read_agfl() both call it.

Huh?  xfs_alloc_read_agfl always reads the agfl buffer with
&xfs_agfl_buf_ops, why would we want to call it without the verifier?

It's only scrub that gets to do screwy things like read buffers with no
verifier.  libxfs functions should never do that.

<confused>

> From here:
> > +
> > +	/* Find all space used by the free space btrees & rmapbt. */
> > +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> > +	error = xfs_rmap_query_all(cur, xfs_repair_agfl_rmap_fn, &ra);
> > +	if (error)
> > +		goto err;
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +
> > +	/* Find all space used by bnobt. */
> > +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> > +			XFS_BTNUM_BNO);
> > +	error = xfs_btree_visit_blocks(cur, xfs_repair_agfl_visit_btblock,
> > +			&ra);
> > +	if (error)
> > +		goto err;
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +
> > +	/* Find all space used by cntbt. */
> > +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> > +			XFS_BTNUM_CNT);
> > +	error = xfs_btree_visit_blocks(cur, xfs_repair_agfl_visit_btblock,
> > +			&ra);
> > +	if (error)
> > +		goto err;
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +	cur = NULL;
> > +
> > +	/*
> > +	 * Drop the freesp meta blocks that are in use by btrees.
> > +	 * The remaining blocks /should/ be AGFL blocks.
> > +	 */
> > +	error = xfs_repair_subtract_extents(sc, &ra.freesp_list,
> > +			&ra.agmeta_list);
> > +	if (error)
> > +		goto err;
> > +	xfs_repair_cancel_btree_extents(sc, &ra.agmeta_list);
> 
> This whole section could go into a separate function, say
> xfs_repair_agfl_find_extents()?

Ok.

> > +
> > +	/* Calculate the new AGFL size. */
> > +	flcount = 0;
> > +	for_each_xfs_repair_extent_safe(rae, n, &ra.freesp_list) {
> 
> Why "safe" - we're not removing anything from the list here.

There's no for_each_xfs_repair_extent().  I'll make one.

> > +		for (bno = 0; bno < rae->len; bno++) {
> > +			if (flcount >= xfs_agfl_size(mp) - 1)
> 
> What's the reason for the magic "- 1" there?

I'm not sure I remember anymore, and my notes offer nothing.

> > +				break;
> > +			flcount++;
> > +		}
> > +	}
> 
> This seems like a complex way of doing:
> 
> 	for_each_xfs_repair_extent(rae, n, &ra.freesp_list) {
> 		flcount += rae->len;
> 		if (flcount >= xfs_agfl_size(mp) - 1) {
> 			flcount = xfs_agfl_size(mp) - 1;
> 			break;
> 		}
> 	}

Fixed.

> 
> > +	/* Update fdblocks if flcount changed. */
> > +	agf = XFS_BUF_TO_AGF(agf_bp);
> > +	old_flcount = be32_to_cpu(agf->agf_flcount);
> > +	if (flcount != old_flcount) {
> > +		int64_t	delta_fdblocks = (int64_t)flcount - old_flcount;
> > +
> > +		error = xfs_repair_mod_fdblocks(sc, delta_fdblocks);
> > +		if (error)
> > +			goto err;
> > +		if (sc->sa.pag->pagf_init)
> > +			sc->sa.pag->pagf_flcount = flcount;
> 
> No need to check pagf_init here - we've had a successful call to
> xfs_alloc_read_agf() earlier and that means pagf has been
> initialised.

Ok.

> > +	}
> > +
> > +	/* Update the AGF pointers. */
> > +	agf->agf_flfirst = cpu_to_be32(1);
> 
> Why index 1? What is in index 0? (see earlier questions about magic
> numbers :)

Don't remember.  Will set the new list to start at 0 and end at
flcount-1.

> > +	agf->agf_flcount = cpu_to_be32(flcount);
> > +	agf->agf_fllast = cpu_to_be32(flcount);
> > +
> > +	/* Start rewriting the header. */
> > +	agfl = XFS_BUF_TO_AGFL(agfl_bp);
> > +	memset(agfl, 0xFF, mp->m_sb.sb_sectsize);
> > +	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
> > +	agfl->agfl_seqno = cpu_to_be32(sc->sa.agno);
> > +	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
> > +
> > +	/* Fill the AGFL with the remaining blocks. */
> > +	flcount = 0;
> > +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
> > +	for_each_xfs_repair_extent_safe(rae, n, &ra.freesp_list) {
> > +		agbno = XFS_FSB_TO_AGBNO(mp, rae->fsbno);
> > +
> > +		trace_xfs_repair_agfl_insert(mp, sc->sa.agno, agbno, rae->len);
> > +
> > +		for (bno = 0; bno < rae->len; bno++) {
> > +			if (flcount >= xfs_agfl_size(mp) - 1)
> > +				break;
> > +			agfl_bno[flcount + 1] = cpu_to_be32(agbno + bno);
> > +			flcount++;
> > +		}
> > +		rae->fsbno += bno;
> > +		rae->len -= bno;
> 
> This is a bit weird, using "bno" as an offset. But, also, there's
> that magic "don't use index 0 thing again :P

Ok.

> > +		if (rae->len)
> > +			break;
> > +		list_del(&rae->list);
> > +		kmem_free(rae);
> > +	}
> > +
> > +	/* Write AGF and AGFL to disk. */
> > +	xfs_alloc_log_agf(sc->tp, agf_bp,
> > +			XFS_AGF_FLFIRST | XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
> > +	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
> > +	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
> > +
> > +	/* Dump any AGFL overflow. */
> > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > +	return xfs_repair_reap_btree_extents(sc, &ra.freesp_list, &oinfo,
> > +			XFS_AG_RESV_AGFL);
> > +err:
> > +	xfs_repair_cancel_btree_extents(sc, &ra.agmeta_list);
> > +	xfs_repair_cancel_btree_extents(sc, &ra.freesp_list);
> > +	if (cur)
> > +		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
> > +				XFS_BTREE_NOERROR);
> > +	return error;
> > +}
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index e3e8fba1c99c..5f31dc8af505 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> > @@ -1087,3 +1087,33 @@ xfs_repair_ino_dqattach(
> >  
> >  	return error;
> >  }
> > +
> > +/*
> > + * We changed this AGF's free block count, so now we need to reset the global
> > + * counters.  We use the transaction to update the global counters, so if the
> > + * AG free counts were low we have to ask the transaction for more block
> > + * reservation before decreasing fdblocks.
> > + *
> > + * XXX: We ought to have some mechanism for checking and fixing the superblock
> > + * counters (particularly if we're close to ENOSPC) but that's left as an open
> > + * research question for now.
> > + */
> > +int
> > +xfs_repair_mod_fdblocks(
> > +	struct xfs_scrub_context	*sc,
> > +	int64_t				delta_fdblocks)
> > +{
> > +	int				error;
> > +
> > +	if (delta_fdblocks == 0)
> > +		return 0;
> > +
> > +	if (delta_fdblocks < 0) {
> > +		error = xfs_trans_reserve_more(sc->tp, -delta_fdblocks, 0);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	xfs_trans_mod_sb(sc->tp, XFS_TRANS_SB_FDBLOCKS, delta_fdblocks);
> 
> This seems a little hacky - it's working around a transaction
> reservation overflow warning, right?

More than that -- we're trying to avoid the situation where the incore
free block counter goes negative.  Things go south pretty quickly when
that happens because transaction reservations succeed when there's not
enough free space to accomodate them.  We'd rather error out to
userspace and have the admin unmount and xfs_repair than risk letting
the fs really blow up.

Note that this function has to be called before repair dirties anything
in the repair transaction so we're still at a place where we could back
out with no harm done.

> Would it simply be better to
> have a different type for xfs_trans_mod_sb() that didn't shut down
> the filesystem on transaction reservation overflows here? e.g
> XFS_TRANS_SB_FDBLOCKS_REPAIR? That would get rid of the need for
> xfs_trans_reserve_more() code, right?
> 
> [...]
> > +/*
> > + * Try to reserve more blocks for a transaction.  The single use case we
> > + * support is for online repair -- use a transaction to gather data without
> > + * fear of btree cycle deadlocks; calculate how many blocks we really need
> > + * from that data; and only then start modifying data.  This can fail due to
> > + * ENOSPC, so we have to be able to cancel the transaction.
> > + */
> > +int
> > +xfs_trans_reserve_more(
> > +	struct xfs_trans	*tp,
> > +	uint			blocks,
> > +	uint			rtextents)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
> > +	int			error = 0;
> > +
> > +	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
> > +
> > +	/*
> > +	 * Attempt to reserve the needed disk blocks by decrementing
> > +	 * the number needed from the number available.  This will
> > +	 * fail if the count would go below zero.
> > +	 */
> > +	if (blocks > 0) {
> > +		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
> > +		if (error != 0)
> > +			return -ENOSPC;
> 
> 		if (error)

Ok.

--D

> > +		tp->t_blk_res += blocks;
> > +	}
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
