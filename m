Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727786AbeHIPdn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Aug 2018 11:33:43 -0400
Date: Thu, 9 Aug 2018 09:08:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: repair the AGF
Message-ID: <20180809130851.GC21639@bfoster>
References: <153370061966.25077.161884080659267764.stgit@magnolia>
 <153370063246.25077.17913136325250909167.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153370063246.25077.17913136325250909167.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Tue, Aug 07, 2018 at 08:57:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Regenerate the AGF from the rmap data.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/agheader_repair.c |  370 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.c          |   27 ++-
>  fs/xfs/scrub/repair.h          |    2 
>  fs/xfs/scrub/scrub.c           |    2 
>  4 files changed, 391 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 1e96621ece3a..4842fc598c9b 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
...
> @@ -54,3 +61,366 @@ xrep_superblock(
...
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
> +	pag->pagf_init = 1;

I still think the above could be factored into a helper since it looks
like a copy of the associated xfs_alloc_read_agf() code. That aside,
this looks fine now that the ->pagf_init thing is fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
> +	/*
> +	 * Make sure we have the AGF buffer, as scrub might have decided it
> +	 * was corrupt after xfs_alloc_read_agf failed with -EFSCORRUPTED.
> +	 */
> +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGF_DADDR(mp)),
> +			XFS_FSS_TO_BB(mp, 1), 0, &agf_bp, NULL);
> +	if (error)
> +		return error;
> +	agf_bp->b_ops = &xfs_agf_buf_ops;
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
> index 6c199e2ebb81..183d9e84c7e5 100644
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
> index 5a4e92221916..6f0903c51a47 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -58,6 +58,7 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
>  
>  int xrep_probe(struct xfs_scrub *sc);
>  int xrep_superblock(struct xfs_scrub *sc);
> +int xrep_agf(struct xfs_scrub *sc);
>  
>  #else
>  
> @@ -81,6 +82,7 @@ xrep_calc_ag_resblks(
>  
>  #define xrep_probe			xrep_notsupported
>  #define xrep_superblock			xrep_notsupported
> +#define xrep_agf			xrep_notsupported
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
