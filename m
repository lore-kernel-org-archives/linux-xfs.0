Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730714AbeG0PqB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jul 2018 11:46:01 -0400
Date: Fri, 27 Jul 2018 10:23:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/16] xfs: repair the AGF
Message-ID: <20180727142348.GE22227@bfoster>
References: <153256436688.29021.4638459579042241728.stgit@magnolia>
 <153256439500.29021.5265670898665301362.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153256439500.29021.5265670898665301362.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Wed, Jul 25, 2018 at 05:19:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Regenerate the AGF from the rmap data.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Mostly seems sane to me. I still need to come up to speed on the broader
xfs_scrub context. A few comments in the meantime..

>  fs/xfs/scrub/agheader_repair.c |  366 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.c          |   27 ++-
>  fs/xfs/scrub/repair.h          |    4 
>  fs/xfs/scrub/scrub.c           |    2 
>  4 files changed, 389 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 1e96621ece3a..938af216cb1c 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
...
> @@ -54,3 +61,362 @@ xrep_superblock(
>  	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
>  	return error;
>  }
...
> +/* Update all AGF fields which derive from btree contents. */
> +STATIC int
> +xrep_agf_calc_from_btrees(
> +	struct xfs_scrub	*sc,
> +	struct xfs_buf		*agf_bp)
> +{
> +	struct xrep_agf_allocbt	raa = { .sc = sc };
> +	struct xfs_btree_cur	*cur = NULL;
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agf_bp);
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_agblock_t		btreeblks;
> +	xfs_agblock_t		blocks;
> +	int			error;
> +
> +	/* Update the AGF counters from the bnobt. */
> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> +			XFS_BTNUM_BNO);
> +	error = xfs_alloc_query_all(cur, xrep_agf_walk_allocbt, &raa);
> +	if (error)
> +		goto err;
> +	error = xfs_btree_count_blocks(cur, &blocks);
> +	if (error)
> +		goto err;
> +	xfs_btree_del_cursor(cur, error);
> +	btreeblks = blocks - 1;

Why the -1? We don't count the root or something?

> +	agf->agf_freeblks = cpu_to_be32(raa.freeblks);
> +	agf->agf_longest = cpu_to_be32(raa.longest);
> +
> +	/* Update the AGF counters from the cntbt. */
> +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> +			XFS_BTNUM_CNT);
> +	error = xfs_btree_count_blocks(cur, &blocks);
> +	if (error)
> +		goto err;
> +	xfs_btree_del_cursor(cur, error);
> +	btreeblks += blocks - 1;
> +
> +	/* Update the AGF counters from the rmapbt. */
> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> +	error = xfs_btree_count_blocks(cur, &blocks);
> +	if (error)
> +		goto err;
> +	xfs_btree_del_cursor(cur, error);
> +	agf->agf_rmap_blocks = cpu_to_be32(blocks);
> +	btreeblks += blocks - 1;
> +
> +	agf->agf_btreeblks = cpu_to_be32(btreeblks);
> +
> +	/* Update the AGF counters from the refcountbt. */
> +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		cur = xfs_refcountbt_init_cursor(mp, sc->tp, agf_bp,
> +				sc->sa.agno, NULL);

FYI this fails to compile on for-next (dfops param has been removed).

> +		error = xfs_btree_count_blocks(cur, &blocks);
> +		if (error)
> +			goto err;
> +		xfs_btree_del_cursor(cur, error);
> +		agf->agf_refcount_blocks = cpu_to_be32(blocks);
> +	}
> +
> +	return 0;
> +err:
> +	xfs_btree_del_cursor(cur, error);
> +	return error;
> +}
> +
> +/* Commit the new AGF and reinitialize the incore state. */
> +STATIC int
> +xrep_agf_commit_new(
> +	struct xfs_scrub	*sc,
> +	struct xfs_buf		*agf_bp)
> +{
> +	struct xfs_perag	*pag;
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agf_bp);
> +
> +	/* Trigger fdblocks recalculation */
> +	xfs_force_summary_recalc(sc->mp);
> +
> +	/* Write this to disk. */
> +	xfs_trans_buf_set_type(sc->tp, agf_bp, XFS_BLFT_AGF_BUF);
> +	xfs_trans_log_buf(sc->tp, agf_bp, 0, BBTOB(agf_bp->b_length) - 1);
> +
> +	/* Now reinitialize the in-core counters we changed. */
> +	pag = sc->sa.pag;
> +	sc->sa.pag->pagf_init = 1;

Nit: can probably do 'pag->pagf_init = 1' here since we just initialized
pag on the line above.

That aside, is ordering important at all here? I'm wondering if somebody
can grab the pag right after we set this and see pagf_init == 1 before
we've updated the values below. Perhaps it doesn't really matter since
we have the agf buffer.

> +	pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
> +	pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
> +	pag->pagf_longest = be32_to_cpu(agf->agf_longest);
> +	pag->pagf_levels[XFS_BTNUM_BNOi] =
> +			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
> +	pag->pagf_levels[XFS_BTNUM_CNTi] =
> +			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
> +	pag->pagf_levels[XFS_BTNUM_RMAPi] =
> +			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
> +	pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
> +
> +	return 0;
> +}
> +
> +/* Repair the AGF. v5 filesystems only. */
> +int
> +xrep_agf(
> +	struct xfs_scrub		*sc)
> +{
> +	struct xrep_find_ag_btree	fab[XREP_AGF_MAX] = {
> +		[XREP_AGF_BNOBT] = {
> +			.rmap_owner = XFS_RMAP_OWN_AG,
> +			.buf_ops = &xfs_allocbt_buf_ops,
> +			.magic = XFS_ABTB_CRC_MAGIC,
> +		},
> +		[XREP_AGF_CNTBT] = {
> +			.rmap_owner = XFS_RMAP_OWN_AG,
> +			.buf_ops = &xfs_allocbt_buf_ops,
> +			.magic = XFS_ABTC_CRC_MAGIC,
> +		},
> +		[XREP_AGF_RMAPBT] = {
> +			.rmap_owner = XFS_RMAP_OWN_AG,
> +			.buf_ops = &xfs_rmapbt_buf_ops,
> +			.magic = XFS_RMAP_CRC_MAGIC,
> +		},
> +		[XREP_AGF_REFCOUNTBT] = {
> +			.rmap_owner = XFS_RMAP_OWN_REFC,
> +			.buf_ops = &xfs_refcountbt_buf_ops,
> +			.magic = XFS_REFC_CRC_MAGIC,
> +		},
> +		[XREP_AGF_END] = {
> +			.buf_ops = NULL,
> +		},
> +	};
> +	struct xfs_agf			old_agf;
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_buf			*agf_bp;
> +	struct xfs_buf			*agfl_bp;
> +	struct xfs_agf			*agf;
> +	int				error;
> +
> +	/* We require the rmapbt to rebuild anything. */
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		return -EOPNOTSUPP;
> +
> +	xchk_perag_get(sc->mp, &sc->sa);
> +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGF_DADDR(mp)),
> +			XFS_FSS_TO_BB(mp, 1), 0, &agf_bp, NULL);
> +	if (error)
> +		return error;
> +	agf_bp->b_ops = &xfs_agf_buf_ops;

Any reason we don't call xfs_read_agf() here? It looks like we use the
similar helper for the agfl below.

> +	agf = XFS_BUF_TO_AGF(agf_bp);
> +
> +	/*
> +	 * Load the AGFL so that we can screen out OWN_AG blocks that are on
> +	 * the AGFL now; these blocks might have once been part of the
> +	 * bno/cnt/rmap btrees but are not now.  This is a chicken and egg
> +	 * problem: the AGF is corrupt, so we have to trust the AGFL contents
> +	 * because we can't do any serious cross-referencing with any of the
> +	 * btrees rooted in the AGF.  If the AGFL contents are obviously bad
> +	 * then we'll bail out.
> +	 */
> +	error = xfs_alloc_read_agfl(mp, sc->tp, sc->sa.agno, &agfl_bp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Spot-check the AGFL blocks; if they're obviously corrupt then
> +	 * there's nothing we can do but bail out.
> +	 */

Why? Can't we reset the agfl, or is that handled elsewhere?

Brian

> +	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(agf_bp), agfl_bp,
> +			xrep_agf_check_agfl_block, sc);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Find the AGF btree roots.  This is also a chicken-and-egg situation;
> +	 * see the function for more details.
> +	 */
> +	error = xrep_agf_find_btrees(sc, agf_bp, fab, agfl_bp);
> +	if (error)
> +		return error;
> +
> +	/* Start rewriting the header and implant the btrees we found. */
> +	xrep_agf_init_header(sc, agf_bp, &old_agf);
> +	xrep_agf_set_roots(sc, agf, fab);
> +	error = xrep_agf_calc_from_btrees(sc, agf_bp);
> +	if (error)
> +		goto out_revert;
> +
> +	/* Commit the changes and reinitialize incore state. */
> +	return xrep_agf_commit_new(sc, agf_bp);
> +
> +out_revert:
> +	/* Mark the incore AGF state stale and revert the AGF. */
> +	sc->sa.pag->pagf_init = 0;
> +	memcpy(agf, &old_agf, sizeof(old_agf));
> +	return error;
> +}
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 85b048b341a0..17cf48564390 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -128,9 +128,12 @@ xrep_roll_ag_trans(
>  	int			error;
>  
>  	/* Keep the AG header buffers locked so we can keep going. */
> -	xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
> -	xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
> -	xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
> +	if (sc->sa.agi_bp)
> +		xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
> +	if (sc->sa.agf_bp)
> +		xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
> +	if (sc->sa.agfl_bp)
> +		xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
>  
>  	/* Roll the transaction. */
>  	error = xfs_trans_roll(&sc->tp);
> @@ -138,9 +141,12 @@ xrep_roll_ag_trans(
>  		goto out_release;
>  
>  	/* Join AG headers to the new transaction. */
> -	xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
> -	xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
> -	xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
> +	if (sc->sa.agi_bp)
> +		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
> +	if (sc->sa.agf_bp)
> +		xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
> +	if (sc->sa.agfl_bp)
> +		xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
>  
>  	return 0;
>  
> @@ -150,9 +156,12 @@ xrep_roll_ag_trans(
>  	 * buffers will be released during teardown on our way out
>  	 * of the kernel.
>  	 */
> -	xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
> -	xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
> -	xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
> +	if (sc->sa.agi_bp)
> +		xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
> +	if (sc->sa.agf_bp)
> +		xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
> +	if (sc->sa.agfl_bp)
> +		xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 5a4e92221916..1d283360b5ab 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -58,6 +58,8 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
>  
>  int xrep_probe(struct xfs_scrub *sc);
>  int xrep_superblock(struct xfs_scrub *sc);
> +int xrep_agf(struct xfs_scrub *sc);
> +int xrep_agfl(struct xfs_scrub *sc);
>  
>  #else
>  
> @@ -81,6 +83,8 @@ xrep_calc_ag_resblks(
>  
>  #define xrep_probe			xrep_notsupported
>  #define xrep_superblock			xrep_notsupported
> +#define xrep_agf			xrep_notsupported
> +#define xrep_agfl			xrep_notsupported
>  
>  #endif /* CONFIG_XFS_ONLINE_REPAIR */
>  
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 6efb926f3cf8..1e8a17c8e2b9 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -214,7 +214,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_fs,
>  		.scrub	= xchk_agf,
> -		.repair	= xrep_notsupported,
> +		.repair	= xrep_agf,
>  	},
>  	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
>  		.type	= ST_PERAG,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
