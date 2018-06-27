Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965473AbeF0Qo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 12:44:58 -0400
Subject: Re: [PATCH 04/21] xfs: repair the AGF and AGFL
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986823481.3155.13034509035761369722.stgit@magnolia>
 <20180627021908.GD19934@dastard>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e2261ffd-1d03-b205-1375-25bef625c3f6@oracle.com>
Date: Wed, 27 Jun 2018 09:44:53 -0700
MIME-Version: 1.0
In-Reply-To: <20180627021908.GD19934@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 06/26/2018 07:19 PM, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:23:54PM -0700, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Regenerate the AGF and AGFL from the rmap data.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> [...]
> 
>> +/* Information for finding AGF-rooted btrees */
>> +enum {
>> +	REPAIR_AGF_BNOBT = 0,
>> +	REPAIR_AGF_CNTBT,
>> +	REPAIR_AGF_RMAPBT,
>> +	REPAIR_AGF_REFCOUNTBT,
>> +	REPAIR_AGF_END,
>> +	REPAIR_AGF_MAX
>> +};
> 
> Why can't you just use XFS_BTNUM_* for these btree type descriptors?
> 
>> +
>> +static const struct xfs_repair_find_ag_btree repair_agf[] = {
>> +	[REPAIR_AGF_BNOBT] = {
>> +		.rmap_owner = XFS_RMAP_OWN_AG,
>> +		.buf_ops = &xfs_allocbt_buf_ops,
>> +		.magic = XFS_ABTB_CRC_MAGIC,
>> +	},
>> +	[REPAIR_AGF_CNTBT] = {
>> +		.rmap_owner = XFS_RMAP_OWN_AG,
>> +		.buf_ops = &xfs_allocbt_buf_ops,
>> +		.magic = XFS_ABTC_CRC_MAGIC,
>> +	},
> 
> I had to stop and think about why this only supports the v5 types.
> i.e. we're rebuilding from rmap info, so this will never run on v4
> filesystems, hence we only care about v5 types (i.e. *CRC_MAGIC).
> Perhaps a one-line comment to remind readers of this?
> 
>> +	[REPAIR_AGF_RMAPBT] = {
>> +		.rmap_owner = XFS_RMAP_OWN_AG,
>> +		.buf_ops = &xfs_rmapbt_buf_ops,
>> +		.magic = XFS_RMAP_CRC_MAGIC,
>> +	},
>> +	[REPAIR_AGF_REFCOUNTBT] = {
>> +		.rmap_owner = XFS_RMAP_OWN_REFC,
>> +		.buf_ops = &xfs_refcountbt_buf_ops,
>> +		.magic = XFS_REFC_CRC_MAGIC,
>> +	},
>> +	[REPAIR_AGF_END] = {
>> +		.buf_ops = NULL,
>> +	},
>> +};
>> +
>> +/*
>> + * Find the btree roots.  This is /also/ a chicken and egg problem because we
>> + * have to use the rmapbt (rooted in the AGF) to find the btrees rooted in the
>> + * AGF.  We also have no idea if the btrees make any sense.  If we hit obvious
>> + * corruptions in those btrees we'll bail out.
>> + */
>> +STATIC int
>> +xfs_repair_agf_find_btrees(
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_buf			*agf_bp,
>> +	struct xfs_repair_find_ag_btree	*fab,
>> +	struct xfs_buf			*agfl_bp)
>> +{
>> +	struct xfs_agf			*old_agf = XFS_BUF_TO_AGF(agf_bp);
>> +	int				error;
>> +
>> +	/* Go find the root data. */
>> +	memcpy(fab, repair_agf, sizeof(repair_agf));
> 
> Why are we initialising fab here, instead of in the caller where it
> is declared and passed to various functions? Given there is only a
> single declaration of this structure, why do we need a global static
> const table initialiser just to copy it here - why isn't it
> initialised at the declaration point?
> 
>> +	error = xfs_repair_find_ag_btree_roots(sc, agf_bp, fab, agfl_bp);
>> +	if (error)
>> +		return error;
>> +
>> +	/* We must find the bnobt, cntbt, and rmapbt roots. */
>> +	if (fab[REPAIR_AGF_BNOBT].root == NULLAGBLOCK ||
>> +	    fab[REPAIR_AGF_BNOBT].height > XFS_BTREE_MAXLEVELS ||
>> +	    fab[REPAIR_AGF_CNTBT].root == NULLAGBLOCK ||
>> +	    fab[REPAIR_AGF_CNTBT].height > XFS_BTREE_MAXLEVELS ||
>> +	    fab[REPAIR_AGF_RMAPBT].root == NULLAGBLOCK ||
>> +	    fab[REPAIR_AGF_RMAPBT].height > XFS_BTREE_MAXLEVELS)
>> +		return -EFSCORRUPTED;
>> +
>> +	/*
>> +	 * We relied on the rmapbt to reconstruct the AGF.  If we get a
>> +	 * different root then something's seriously wrong.
>> +	 */
>> +	if (fab[REPAIR_AGF_RMAPBT].root !=
>> +	    be32_to_cpu(old_agf->agf_roots[XFS_BTNUM_RMAPi]))
>> +		return -EFSCORRUPTED;
>> +
>> +	/* We must find the refcountbt root if that feature is enabled. */
>> +	if (xfs_sb_version_hasreflink(&sc->mp->m_sb) &&
>> +	    (fab[REPAIR_AGF_REFCOUNTBT].root == NULLAGBLOCK ||
>> +	     fab[REPAIR_AGF_REFCOUNTBT].height > XFS_BTREE_MAXLEVELS))
>> +		return -EFSCORRUPTED;
>> +
>> +	return 0;
>> +}
>> +
>> +/* Set btree root information in an AGF. */
>> +STATIC void
>> +xfs_repair_agf_set_roots(
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_agf			*agf,
>> +	struct xfs_repair_find_ag_btree	*fab)
>> +{
>> +	agf->agf_roots[XFS_BTNUM_BNOi] =
>> +			cpu_to_be32(fab[REPAIR_AGF_BNOBT].root);
>> +	agf->agf_levels[XFS_BTNUM_BNOi] =
>> +			cpu_to_be32(fab[REPAIR_AGF_BNOBT].height);
>> +
>> +	agf->agf_roots[XFS_BTNUM_CNTi] =
>> +			cpu_to_be32(fab[REPAIR_AGF_CNTBT].root);
>> +	agf->agf_levels[XFS_BTNUM_CNTi] =
>> +			cpu_to_be32(fab[REPAIR_AGF_CNTBT].height);
>> +
>> +	agf->agf_roots[XFS_BTNUM_RMAPi] =
>> +			cpu_to_be32(fab[REPAIR_AGF_RMAPBT].root);
>> +	agf->agf_levels[XFS_BTNUM_RMAPi] =
>> +			cpu_to_be32(fab[REPAIR_AGF_RMAPBT].height);
>> +
>> +	if (xfs_sb_version_hasreflink(&sc->mp->m_sb)) {
>> +		agf->agf_refcount_root =
>> +				cpu_to_be32(fab[REPAIR_AGF_REFCOUNTBT].root);
>> +		agf->agf_refcount_level =
>> +				cpu_to_be32(fab[REPAIR_AGF_REFCOUNTBT].height);
>> +	}
>> +}
>> +
>> +/*
>> + * Reinitialize the AGF header, making an in-core copy of the old contents so
>> + * that we know which in-core state needs to be reinitialized.
>> + */
>> +STATIC void
>> +xfs_repair_agf_init_header(
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_buf			*agf_bp,
>> +	struct xfs_agf			*old_agf)
>> +{
>> +	struct xfs_mount		*mp = sc->mp;
>> +	struct xfs_agf			*agf = XFS_BUF_TO_AGF(agf_bp);
>> +
>> +	memcpy(old_agf, agf, sizeof(*old_agf));
>> +	memset(agf, 0, BBTOB(agf_bp->b_length));
>> +	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
>> +	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
>> +	agf->agf_seqno = cpu_to_be32(sc->sa.agno);
>> +	agf->agf_length = cpu_to_be32(xfs_ag_block_count(mp, sc->sa.agno));
>> +	agf->agf_flfirst = old_agf->agf_flfirst;
>> +	agf->agf_fllast = old_agf->agf_fllast;
>> +	agf->agf_flcount = old_agf->agf_flcount;
>> +	if (xfs_sb_version_hascrc(&mp->m_sb))
>> +		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
>> +}
> 
> Do we need to clear pag->pagf_init here so that it gets
> re-initialised next time someone reads the AGF?
> 
>> +
>> +/* Update the AGF btree counters by walking the btrees. */
>> +STATIC int
>> +xfs_repair_agf_update_btree_counters(
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_buf			*agf_bp)
>> +{
>> +	struct xfs_repair_agf_allocbt	raa = { .sc = sc };
>> +	struct xfs_btree_cur		*cur = NULL;
>> +	struct xfs_agf			*agf = XFS_BUF_TO_AGF(agf_bp);
>> +	struct xfs_mount		*mp = sc->mp;
>> +	xfs_agblock_t			btreeblks;
>> +	xfs_agblock_t			blocks;
>> +	int				error;
>> +
>> +	/* Update the AGF counters from the bnobt. */
>> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
>> +			XFS_BTNUM_BNO);
>> +	error = xfs_alloc_query_all(cur, xfs_repair_agf_walk_allocbt, &raa);
>> +	if (error)
>> +		goto err;
>> +	error = xfs_btree_count_blocks(cur, &blocks);
>> +	if (error)
>> +		goto err;
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +	btreeblks = blocks - 1;
>> +	agf->agf_freeblks = cpu_to_be32(raa.freeblks);
>> +	agf->agf_longest = cpu_to_be32(raa.longest);
> 
> This function updates more than the AGF btree counters. :P
> 
>> +
>> +	/* Update the AGF counters from the cntbt. */
>> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
>> +			XFS_BTNUM_CNT);
>> +	error = xfs_btree_count_blocks(cur, &blocks);
>> +	if (error)
>> +		goto err;
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +	btreeblks += blocks - 1;
>> +
>> +	/* Update the AGF counters from the rmapbt. */
>> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
>> +	error = xfs_btree_count_blocks(cur, &blocks);
>> +	if (error)
>> +		goto err;
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +	agf->agf_rmap_blocks = cpu_to_be32(blocks);
>> +	btreeblks += blocks - 1;
>> +
>> +	agf->agf_btreeblks = cpu_to_be32(btreeblks);
>> +
>> +	/* Update the AGF counters from the refcountbt. */
>> +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
>> +		cur = xfs_refcountbt_init_cursor(mp, sc->tp, agf_bp,
>> +				sc->sa.agno, NULL);
>> +		error = xfs_btree_count_blocks(cur, &blocks);
>> +		if (error)
>> +			goto err;
>> +		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +		agf->agf_refcount_blocks = cpu_to_be32(blocks);
>> +	}
>> +
>> +	return 0;
>> +err:
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>> +	return error;
>> +}
>> +
>> +/* Trigger reinitialization of the in-core data. */
>> +STATIC int
>> +xfs_repair_agf_reinit_incore(
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_agf			*agf,
>> +	const struct xfs_agf		*old_agf)
>> +{
>> +	struct xfs_perag		*pag;
>> +
>> +	/* XXX: trigger fdblocks recalculation */
>> +
>> +	/* Now reinitialize the in-core counters if necessary. */
>> +	pag = sc->sa.pag;
>> +	if (!pag->pagf_init)
>> +		return 0;
>> +
>> +	pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
>> +	pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
>> +	pag->pagf_longest = be32_to_cpu(agf->agf_longest);
>> +	pag->pagf_levels[XFS_BTNUM_BNOi] =
>> +			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
>> +	pag->pagf_levels[XFS_BTNUM_CNTi] =
>> +			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
>> +	pag->pagf_levels[XFS_BTNUM_RMAPi] =
>> +			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
>> +	pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
> 
> Ok, so we reinit the pagf bits here, but....
> 
>> +
>> +	return 0;
>> +}
>> +
>> +/* Repair the AGF. */
>> +int
>> +xfs_repair_agf(
>> +	struct xfs_scrub_context	*sc)
>> +{
>> +	struct xfs_repair_find_ag_btree	fab[REPAIR_AGF_MAX];
>> +	struct xfs_agf			old_agf;
>> +	struct xfs_mount		*mp = sc->mp;
>> +	struct xfs_buf			*agf_bp;
>> +	struct xfs_buf			*agfl_bp;
>> +	struct xfs_agf			*agf;
>> +	int				error;
>> +
>> +	/* We require the rmapbt to rebuild anything. */
>> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>> +		return -EOPNOTSUPP;
>> +
>> +	xfs_scrub_perag_get(sc->mp, &sc->sa);
>> +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
>> +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGF_DADDR(mp)),
>> +			XFS_FSS_TO_BB(mp, 1), 0, &agf_bp, NULL);
>> +	if (error)
>> +		return error;
>> +	agf_bp->b_ops = &xfs_agf_buf_ops;
>> +	agf = XFS_BUF_TO_AGF(agf_bp);
>> +
>> +	/*
>> +	 * Load the AGFL so that we can screen out OWN_AG blocks that are on
>> +	 * the AGFL now; these blocks might have once been part of the
>> +	 * bno/cnt/rmap btrees but are not now.  This is a chicken and egg
>> +	 * problem: the AGF is corrupt, so we have to trust the AGFL contents
>> +	 * because we can't do any serious cross-referencing with any of the
>> +	 * btrees rooted in the AGF.  If the AGFL contents are obviously bad
>> +	 * then we'll bail out.
>> +	 */
>> +	error = xfs_alloc_read_agfl(mp, sc->tp, sc->sa.agno, &agfl_bp);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Spot-check the AGFL blocks; if they're obviously corrupt then
>> +	 * there's nothing we can do but bail out.
>> +	 */
>> +	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(agf_bp), agfl_bp,
>> +			xfs_repair_agf_check_agfl_block, sc);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Find the AGF btree roots.  See the comment for this function for
>> +	 * more information about the limitations of this repairer; this is
>> +	 * also a chicken-and-egg situation.
>> +	 */
>> +	error = xfs_repair_agf_find_btrees(sc, agf_bp, fab, agfl_bp);
>> +	if (error)
>> +		return error;
> 
> Comment could be better written.
> 
> 	/*
> 	 * Find the AGF btree roots. This is also a chicken-and-egg
> 	 * situation - see xfs_repair_agf_find_btrees() for details.
> 	 */
> 
>> +
>> +	/* Start rewriting the header and implant the btrees we found. */
>> +	xfs_repair_agf_init_header(sc, agf_bp, &old_agf);
>> +	xfs_repair_agf_set_roots(sc, agf, fab);
>> +	error = xfs_repair_agf_update_btree_counters(sc, agf_bp);
>> +	if (error)
>> +		goto out_revert;
> 
> If we fail here, the pagf information is invalid, hence I think we
> really do need to clear pagf_init before we start rebuilding the new
> AGF. Yes, I can see we revert the AGF info, but this seems like a
> landmine waiting to be tripped over.
> 
>> +	/* Reinitialize in-core state. */
>> +	error = xfs_repair_agf_reinit_incore(sc, agf, &old_agf);
>> +	if (error)
>> +		goto out_revert;
>> +
>> +	/* Write this to disk. */
>> +	xfs_trans_buf_set_type(sc->tp, agf_bp, XFS_BLFT_AGF_BUF);
>> +	xfs_trans_log_buf(sc->tp, agf_bp, 0, BBTOB(agf_bp->b_length) - 1);
>> +	return 0;
>> +
>> +out_revert:
>> +	memcpy(agf, &old_agf, sizeof(old_agf));
>> +	return error;
>> +}
>> +
>> +/* AGFL */
>> +
>> +struct xfs_repair_agfl {
>> +	struct xfs_repair_extent_list	agmeta_list;
>> +	struct xfs_repair_extent_list	*freesp_list;
>> +	struct xfs_scrub_context	*sc;
>> +};
>> +
>> +/* Record all freespace information. */
>> +STATIC int
>> +xfs_repair_agfl_rmap_fn(
>> +	struct xfs_btree_cur		*cur,
>> +	struct xfs_rmap_irec		*rec,
>> +	void				*priv)
>> +{
>> +	struct xfs_repair_agfl		*ra = priv;
>> +	xfs_fsblock_t			fsb;
>> +	int				error = 0;
>> +
>> +	if (xfs_scrub_should_terminate(ra->sc, &error))
>> +		return error;
>> +
>> +	/* Record all the OWN_AG blocks. */
>> +	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
>> +		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
>> +				rec->rm_startblock);
>> +		error = xfs_repair_collect_btree_extent(ra->sc,
>> +				ra->freesp_list, fsb, rec->rm_blockcount);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>> +	return xfs_repair_collect_btree_cur_blocks(ra->sc, cur,
>> +			xfs_repair_collect_btree_cur_blocks_in_extent_list,
> 
> Urk. The function name lengths is getting out of hand. I'm very
> tempted to suggest we should shorten the namespace of all this
> like s/xfs_repair_/xr_/ and s/xfs_scrub_/xs_/, etc just to make them
> shorter and easier to read.
> 
> Oh, wait, did I say that out loud? :P
> 
> Something to think about, anyway.
> 
Well they are sort of long, but TBH I think i still kind of appreciate 
the extra verbiage.  I have seen other projects do things like adopt a 
sort of 3 or 4 letter abbreviation (like maybe xfs_scrb or xfs_repr). 
Helps to cut down on the verbosity while still not loosing too much of 
what it is supposed to mean.  Just another idea to consider. :-)

>> +			&ra->agmeta_list);
>> +}
>> +
>> +/* Add a btree block to the agmeta list. */
>> +STATIC int
>> +xfs_repair_agfl_visit_btblock(
> 
> I find the name a bit confusing - AGFLs don't have btree blocks.
> Yes, I know that it's a xfs_btree_visit_blocks() callback but I
> think s/visit/collect/ makes more sense. i.e. it tells us what we
> are doing with the btree block, rather than making it sound like we
> are walking AGFL btree blocks...
> 
>> +/*
>> + * Map out all the non-AGFL OWN_AG space in this AG so that we can deduce
>> + * which blocks belong to the AGFL.
>> + */
>> +STATIC int
>> +xfs_repair_agfl_find_extents(
> 
> Same here - xr_agfl_collect_free_extents()?
> 
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_buf			*agf_bp,
>> +	struct xfs_repair_extent_list	*agfl_extents,
>> +	xfs_agblock_t			*flcount)
>> +{
>> +	struct xfs_repair_agfl		ra;
>> +	struct xfs_mount		*mp = sc->mp;
>> +	struct xfs_btree_cur		*cur;
>> +	struct xfs_repair_extent	*rae;
>> +	int				error;
>> +
>> +	ra.sc = sc;
>> +	ra.freesp_list = agfl_extents;
>> +	xfs_repair_init_extent_list(&ra.agmeta_list);
>> +
>> +	/* Find all space used by the free space btrees & rmapbt. */
>> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
>> +	error = xfs_rmap_query_all(cur, xfs_repair_agfl_rmap_fn, &ra);
>> +	if (error)
>> +		goto err;
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +
>> +	/* Find all space used by bnobt. */
> 
> Needs clarification.
> 
> 	/* Find all the in use bnobt blocks */
> 
>> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
>> +			XFS_BTNUM_BNO);
>> +	error = xfs_btree_visit_blocks(cur, xfs_repair_agfl_visit_btblock, &ra);
>> +	if (error)
>> +		goto err;
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +
>> +	/* Find all space used by cntbt. */
> 
> 	/* Find all the in use cntbt blocks */
> 
>> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
>> +			XFS_BTNUM_CNT);
>> +	error = xfs_btree_visit_blocks(cur, xfs_repair_agfl_visit_btblock, &ra);
>> +	if (error)
>> +		goto err;
>> +
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +
>> +	/*
>> +	 * Drop the freesp meta blocks that are in use by btrees.
>> +	 * The remaining blocks /should/ be AGFL blocks.
>> +	 */
>> +	error = xfs_repair_subtract_extents(sc, agfl_extents, &ra.agmeta_list);
>> +	xfs_repair_cancel_btree_extents(sc, &ra.agmeta_list);
>> +	if (error)
>> +		return error;
>> +
>> +	/* Calculate the new AGFL size. */
>> +	*flcount = 0;
>> +	for_each_xfs_repair_extent(rae, agfl_extents) {
>> +		*flcount += rae->len;
>> +		if (*flcount > xfs_agfl_size(mp))
>> +			break;
>> +	}
>> +	if (*flcount > xfs_agfl_size(mp))
>> +		*flcount = xfs_agfl_size(mp);
> 
> Ok, so flcount is clamped here. What happens to all the remaining
> agfl_extents beyond flcount?
> 
>> +	return 0;
>> +
>> +err:
> 
> Ok, what cleans up all the extents we've recorded in ra on error?
> 
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>> +	return error;
>> +}
>> +
>> +/* Update the AGF and reset the in-core state. */
>> +STATIC int
>> +xfs_repair_agfl_update_agf(
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_buf			*agf_bp,
>> +	xfs_agblock_t			flcount)
>> +{
>> +	struct xfs_agf			*agf = XFS_BUF_TO_AGF(agf_bp);
>> +
> 	ASSERT(*flcount <= xfs_agfl_size(mp));
> 
>> +	/* XXX: trigger fdblocks recalculation */
>> +
>> +	/* Update the AGF counters. */
>> +	if (sc->sa.pag->pagf_init)
>> +		sc->sa.pag->pagf_flcount = flcount;
>> +	agf->agf_flfirst = cpu_to_be32(0);
>> +	agf->agf_flcount = cpu_to_be32(flcount);
>> +	agf->agf_fllast = cpu_to_be32(flcount - 1);
>> +
>> +	xfs_alloc_log_agf(sc->tp, agf_bp,
>> +			XFS_AGF_FLFIRST | XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
>> +	return 0;
>> +}
>> +
>> +/* Write out a totally new AGFL. */
>> +STATIC void
>> +xfs_repair_agfl_init_header(
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_buf			*agfl_bp,
>> +	struct xfs_repair_extent_list	*agfl_extents,
>> +	xfs_agblock_t			flcount)
>> +{
>> +	struct xfs_mount		*mp = sc->mp;
>> +	__be32				*agfl_bno;
>> +	struct xfs_repair_extent	*rae;
>> +	struct xfs_repair_extent	*n;
>> +	struct xfs_agfl			*agfl;
>> +	xfs_agblock_t			agbno;
>> +	unsigned int			fl_off;
>> +
> 	ASSERT(*flcount <= xfs_agfl_size(mp));
> 
>> +	/* Start rewriting the header. */
>> +	agfl = XFS_BUF_TO_AGFL(agfl_bp);
>> +	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
>> +	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
>> +	agfl->agfl_seqno = cpu_to_be32(sc->sa.agno);
>> +	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
>> +
>> +	/* Fill the AGFL with the remaining blocks. */
>> +	fl_off = 0;
>> +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
>> +	for_each_xfs_repair_extent_safe(rae, n, agfl_extents) {
>> +		agbno = XFS_FSB_TO_AGBNO(mp, rae->fsbno);
>> +
>> +		trace_xfs_repair_agfl_insert(mp, sc->sa.agno, agbno, rae->len);
>> +
>> +		while (rae->len > 0 && fl_off < flcount) {
>> +			agfl_bno[fl_off] = cpu_to_be32(agbno);
>> +			fl_off++;
>> +			agbno++;
>> +			rae->fsbno++;
>> +			rae->len--;
>> +		}
> 
> This only works correctly if flcount <= xfs_agfl_size, which is why
> I'm suggesting some asserts.
> 
>> +
>> +		if (rae->len)
>> +			break;
>> +		list_del(&rae->list);
>> +		kmem_free(rae);
>> +	}
>> +
>> +	/* Write AGF and AGFL to disk. */
>> +	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
>> +	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
>> +}
>> +
>> +/* Repair the AGFL. */
>> +int
>> +xfs_repair_agfl(
>> +	struct xfs_scrub_context	*sc)
>> +{
>> +	struct xfs_owner_info		oinfo;
>> +	struct xfs_repair_extent_list	agfl_extents;
>> +	struct xfs_mount		*mp = sc->mp;
>> +	struct xfs_buf			*agf_bp;
>> +	struct xfs_buf			*agfl_bp;
>> +	xfs_agblock_t			flcount;
>> +	int				error;
>> +
>> +	/* We require the rmapbt to rebuild anything. */
>> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>> +		return -EOPNOTSUPP;
>> +
>> +	xfs_scrub_perag_get(sc->mp, &sc->sa);
>> +	xfs_repair_init_extent_list(&agfl_extents);
>> +
>> +	/*
>> +	 * Read the AGF so that we can query the rmapbt.  We hope that there's
>> +	 * nothing wrong with the AGF, but all the AG header repair functions
>> +	 * have this chicken-and-egg problem.
>> +	 */
>> +	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
>> +	if (error)
>> +		return error;
>> +	if (!agf_bp)
>> +		return -ENOMEM;
>> +
>> +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
>> +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGFL_DADDR(mp)),
>> +			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
>> +	if (error)
>> +		return error;
>> +	agfl_bp->b_ops = &xfs_agfl_buf_ops;
>> +
>> +	/*
>> +	 * Compute the set of old AGFL blocks by subtracting from the list of
>> +	 * OWN_AG blocks the list of blocks owned by all other OWN_AG metadata
>> +	 * (bnobt, cntbt, rmapbt).  These are the old AGFL blocks, so return
>> +	 * that list and the number of blocks we're actually going to put back
>> +	 * on the AGFL.
>> +	 */
> 
> That comment belongs on the function, not here. All we need here is
> something like:
> 
> 	/* Gather all the extents we're going to put on the new AGFL. */
> 
>> +	error = xfs_repair_agfl_find_extents(sc, agf_bp, &agfl_extents,
>> +			&flcount);
>> +	if (error)
>> +		goto err;
>> +
>> +	/*
>> +	 * Update AGF and AGFL.  We reset the global free block counter when
>> +	 * we adjust the AGF flcount (which can fail) so avoid updating any
>> +	 * bufers until we know that part works.
> 
> buffers
> 
>> +	 */
>> +	error = xfs_repair_agfl_update_agf(sc, agf_bp, flcount);
>> +	if (error)
>> +		goto err;
>> +	xfs_repair_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount);
>> +
>> +	/*
>> +	 * Ok, the AGFL should be ready to go now.  Roll the transaction so
>> +	 * that we can free any AGFL overflow.
>> +	 */
> 
> Why does rolling the transaction allow us to free the overflow?
> Shouldn't the comment say something like "Roll to the transaction to
> make the new AGFL permanent before we start using it when returning
> the residual AGFL freespace overflow back to the AGF freespace
> btrees."
> 
>> +	sc->sa.agf_bp = agf_bp;
>> +	sc->sa.agfl_bp = agfl_bp;
>> +	error = xfs_repair_roll_ag_trans(sc);
>> +	if (error)
>> +		goto err;
>> +
>> +	/* Dump any AGFL overflow. */
>> +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
>> +	return xfs_repair_reap_btree_extents(sc, &agfl_extents, &oinfo,
>> +			XFS_AG_RESV_AGFL);
>> +err:
>> +	xfs_repair_cancel_btree_extents(sc, &agfl_extents);
>> +	return error;
>> +}
>> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
>> index 326be4e8b71e..bcdaa8df18f6 100644
>> --- a/fs/xfs/scrub/repair.c
>> +++ b/fs/xfs/scrub/repair.c
>> @@ -127,9 +127,12 @@ xfs_repair_roll_ag_trans(
>>   	int				error;
>>   
>>   	/* Keep the AG header buffers locked so we can keep going. */
>> -	xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
>> -	xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
>> -	xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
>> +	if (sc->sa.agi_bp)
>> +		xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
>> +	if (sc->sa.agf_bp)
>> +		xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
>> +	if (sc->sa.agfl_bp)
>> +		xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
>>   
>>   	/* Roll the transaction. */
>>   	error = xfs_trans_roll(&sc->tp);
>> @@ -137,9 +140,12 @@ xfs_repair_roll_ag_trans(
>>   		goto out_release;
>>   
>>   	/* Join AG headers to the new transaction. */
>> -	xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
>> -	xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
>> -	xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
>> +	if (sc->sa.agi_bp)
>> +		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
>> +	if (sc->sa.agf_bp)
>> +		xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
>> +	if (sc->sa.agfl_bp)
>> +		xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
>>   
>>   	return 0;
>>   
>> @@ -149,9 +155,12 @@ xfs_repair_roll_ag_trans(
>>   	 * buffers will be released during teardown on our way out
>>   	 * of the kernel.
>>   	 */
>> -	xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
>> -	xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
>> -	xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
>> +	if (sc->sa.agi_bp)
>> +		xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
>> +	if (sc->sa.agf_bp)
>> +		xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
>> +	if (sc->sa.agfl_bp)
>> +		xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
>>   
>>   	return error;
>>   }
>> @@ -408,6 +417,85 @@ xfs_repair_collect_btree_extent(
>>   	return 0;
>>   }
>>   
>> +/*
>> + * Help record all btree blocks seen while iterating all records of a btree.
>> + *
>> + * We know that the btree query_all function starts at the left edge and walks
>> + * towards the right edge of the tree.  Therefore, we know that we can walk up
>> + * the btree cursor towards the root; if the pointer for a given level points
>> + * to the first record/key in that block, we haven't seen this block before;
>> + * and therefore we need to remember that we saw this block in the btree.
>> + *
>> + * So if our btree is:
>> + *
>> + *    4
>> + *  / | \
>> + * 1  2  3
>> + *
>> + * Pretend for this example that each leaf block has 100 btree records.  For
>> + * the first btree record, we'll observe that bc_ptrs[0] == 1, so we record
>> + * that we saw block 1.  Then we observe that bc_ptrs[1] == 1, so we record
>> + * block 4.  The list is [1, 4].
>> + *
>> + * For the second btree record, we see that bc_ptrs[0] == 2, so we exit the
>> + * loop.  The list remains [1, 4].
>> + *
>> + * For the 101st btree record, we've moved onto leaf block 2.  Now
>> + * bc_ptrs[0] == 1 again, so we record that we saw block 2.  We see that
>> + * bc_ptrs[1] == 2, so we exit the loop.  The list is now [1, 4, 2].
>> + *
>> + * For the 102nd record, bc_ptrs[0] == 2, so we continue.
>> + *
>> + * For the 201st record, we've moved on to leaf block 3.  bc_ptrs[0] == 1, so
>> + * we add 3 to the list.  Now it is [1, 4, 2, 3].
>> + *
>> + * For the 300th record we just exit, with the list being [1, 4, 2, 3].
>> + *
>> + * The *iter_fn can return XFS_BTREE_QUERY_RANGE_ABORT to stop, 0 to keep
>> + * iterating, or the usual negative error code.
>> + */
>> +int
>> +xfs_repair_collect_btree_cur_blocks(
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_btree_cur		*cur,
>> +	int				(*iter_fn)(struct xfs_scrub_context *sc,
>> +						   xfs_fsblock_t fsbno,
>> +						   xfs_fsblock_t len,
>> +						   void *priv),
>> +	void				*priv)
>> +{
>> +	struct xfs_buf			*bp;
>> +	xfs_fsblock_t			fsb;
>> +	int				i;
>> +	int				error;
>> +
>> +	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
>> +		xfs_btree_get_block(cur, i, &bp);
>> +		if (!bp)
>> +			continue;
>> +		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
>> +		error = iter_fn(sc, fsb, 1, priv);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Simple adapter to connect xfs_repair_collect_btree_extent to
>> + * xfs_repair_collect_btree_cur_blocks.
>> + */
>> +int
>> +xfs_repair_collect_btree_cur_blocks_in_extent_list(
>> +	struct xfs_scrub_context	*sc,
>> +	xfs_fsblock_t			fsbno,
>> +	xfs_fsblock_t			len,
>> +	void				*priv)
>> +{
>> +	return xfs_repair_collect_btree_extent(sc, priv, fsbno, len);
>> +}
>> +
>>   /*
>>    * An error happened during the rebuild so the transaction will be cancelled.
>>    * The fs will shut down, and the administrator has to unmount and run repair.
>> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
>> index ef47826b6725..f2af5923aa75 100644
>> --- a/fs/xfs/scrub/repair.h
>> +++ b/fs/xfs/scrub/repair.h
>> @@ -48,9 +48,20 @@ xfs_repair_init_extent_list(
>>   
>>   #define for_each_xfs_repair_extent_safe(rbe, n, exlist) \
>>   	list_for_each_entry_safe((rbe), (n), &(exlist)->list, list)
>> +#define for_each_xfs_repair_extent(rbe, exlist) \
>> +	list_for_each_entry((rbe), &(exlist)->list, list)
>>   int xfs_repair_collect_btree_extent(struct xfs_scrub_context *sc,
>>   		struct xfs_repair_extent_list *btlist, xfs_fsblock_t fsbno,
>>   		xfs_extlen_t len);
>> +int xfs_repair_collect_btree_cur_blocks(struct xfs_scrub_context *sc,
>> +		struct xfs_btree_cur *cur,
>> +		int (*iter_fn)(struct xfs_scrub_context *sc,
>> +			       xfs_fsblock_t fsbno, xfs_fsblock_t len,
>> +			       void *priv),
>> +		void *priv);
>> +int xfs_repair_collect_btree_cur_blocks_in_extent_list(
>> +		struct xfs_scrub_context *sc, xfs_fsblock_t fsbno,
>> +		xfs_fsblock_t len, void *priv);
>>   void xfs_repair_cancel_btree_extents(struct xfs_scrub_context *sc,
>>   		struct xfs_repair_extent_list *btlist);
>>   int xfs_repair_subtract_extents(struct xfs_scrub_context *sc,
>> @@ -89,6 +100,8 @@ int xfs_repair_ino_dqattach(struct xfs_scrub_context *sc);
>>   
>>   int xfs_repair_probe(struct xfs_scrub_context *sc);
>>   int xfs_repair_superblock(struct xfs_scrub_context *sc);
>> +int xfs_repair_agf(struct xfs_scrub_context *sc);
>> +int xfs_repair_agfl(struct xfs_scrub_context *sc);
>>   
>>   #else
>>   
>> @@ -112,6 +125,8 @@ xfs_repair_calc_ag_resblks(
>>   
>>   #define xfs_repair_probe		xfs_repair_notsupported
>>   #define xfs_repair_superblock		xfs_repair_notsupported
>> +#define xfs_repair_agf			xfs_repair_notsupported
>> +#define xfs_repair_agfl			xfs_repair_notsupported
>>   
>>   #endif /* CONFIG_XFS_ONLINE_REPAIR */
>>   
>> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
>> index 58ae76b3a421..8e11c3c699fb 100644
>> --- a/fs/xfs/scrub/scrub.c
>> +++ b/fs/xfs/scrub/scrub.c
>> @@ -208,13 +208,13 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
>>   		.type	= ST_PERAG,
>>   		.setup	= xfs_scrub_setup_fs,
>>   		.scrub	= xfs_scrub_agf,
>> -		.repair	= xfs_repair_notsupported,
>> +		.repair	= xfs_repair_agf,
>>   	},
>>   	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
>>   		.type	= ST_PERAG,
>>   		.setup	= xfs_scrub_setup_fs,
>>   		.scrub	= xfs_scrub_agfl,
>> -		.repair	= xfs_repair_notsupported,
>> +		.repair	= xfs_repair_agfl,
>>   	},
>>   	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
>>   		.type	= ST_PERAG,
>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>> index 524f543c5b82..c08785cf83a9 100644
>> --- a/fs/xfs/xfs_trans.c
>> +++ b/fs/xfs/xfs_trans.c
>> @@ -126,6 +126,60 @@ xfs_trans_dup(
>>   	return ntp;
>>   }
>>   
>> +/*
>> + * Try to reserve more blocks for a transaction.  The single use case we
>> + * support is for online repair -- use a transaction to gather data without
>> + * fear of btree cycle deadlocks; calculate how many blocks we really need
>> + * from that data; and only then start modifying data.  This can fail due to
>> + * ENOSPC, so we have to be able to cancel the transaction.
>> + */
>> +int
>> +xfs_trans_reserve_more(
>> +	struct xfs_trans	*tp,
>> +	uint			blocks,
>> +	uint			rtextents)
> 
> This isn't used in this patch - seems out of place here. Committed
> to the wrong patch?
> 
> Cheers,
> 
> Dave.
> 
