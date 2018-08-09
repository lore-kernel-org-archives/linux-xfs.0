Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730419AbeHIPeC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Aug 2018 11:34:02 -0400
Date: Thu, 9 Aug 2018 09:09:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: repair the AGI
Message-ID: <20180809130909.GE21639@bfoster>
References: <153370061966.25077.161884080659267764.stgit@magnolia>
 <153370064560.25077.4297214180664675165.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153370064560.25077.4297214180664675165.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Tue, Aug 07, 2018 at 08:57:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rebuild the AGI header items with some help from the rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/agheader_repair.c |  219 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.h          |    2 
>  fs/xfs/scrub/scrub.c           |    2 
>  3 files changed, 222 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 0decf711b3c7..df8657a5d475 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -708,3 +708,222 @@ xrep_agfl(
>  	xfs_bitmap_destroy(&agfl_extents);
>  	return error;
>  }
> +
> +/* AGI */
> +
> +/*
> + * Offset within the xrep_find_ag_btree array for each btree type.  Avoid the
> + * XFS_BTNUM_ names here to avoid creating a sparse array.
> + */
> +enum {
> +	XREP_AGI_INOBT = 0,
> +	XREP_AGI_FINOBT,
> +	XREP_AGI_END,
> +	XREP_AGI_MAX
> +};
> +
> +/*
> + * Given the inode btree roots described by *fab, find the roots, check them
> + * for sanity, and pass the root data back out via *fab.
> + */
> +STATIC int
> +xrep_agi_find_btrees(
> +	struct xfs_scrub		*sc,
> +	struct xrep_find_ag_btree	*fab)
> +{
> +	struct xfs_buf			*agf_bp;
> +	struct xfs_mount		*mp = sc->mp;
> +	int				error;
> +
> +	/* Read the AGF. */
> +	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
> +	if (error)
> +		return error;
> +	if (!agf_bp)
> +		return -ENOMEM;
> +
> +	/* Find the btree roots. */
> +	error = xrep_find_ag_btree_roots(sc, agf_bp, fab, NULL);
> +	if (error)
> +		return error;
> +
> +	/* We must find the inobt root. */
> +	if (fab[XREP_AGI_INOBT].root == NULLAGBLOCK ||
> +	    fab[XREP_AGI_INOBT].height > XFS_BTREE_MAXLEVELS)
> +		return -EFSCORRUPTED;
> +
> +	/* We must find the finobt root if that feature is enabled. */
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
> +	    (fab[XREP_AGI_FINOBT].root == NULLAGBLOCK ||
> +	     fab[XREP_AGI_FINOBT].height > XFS_BTREE_MAXLEVELS))
> +		return -EFSCORRUPTED;
> +
> +	return 0;
> +}
> +
> +/*
> + * Reinitialize the AGI header, making an in-core copy of the old contents so
> + * that we know which in-core state needs to be reinitialized.
> + */
> +STATIC void
> +xrep_agi_init_header(
> +	struct xfs_scrub	*sc,
> +	struct xfs_buf		*agi_bp,
> +	struct xfs_agi		*old_agi)
> +{
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agi_bp);
> +	struct xfs_mount	*mp = sc->mp;
> +
> +	memcpy(old_agi, agi, sizeof(*old_agi));
> +	memset(agi, 0, BBTOB(agi_bp->b_length));
> +	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
> +	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
> +	agi->agi_seqno = cpu_to_be32(sc->sa.agno);
> +	agi->agi_length = cpu_to_be32(xfs_ag_block_count(mp, sc->sa.agno));
> +	agi->agi_newino = cpu_to_be32(NULLAGINO);
> +	agi->agi_dirino = cpu_to_be32(NULLAGINO);
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
> +
> +	/* We don't know how to fix the unlinked list yet. */
> +	memcpy(&agi->agi_unlinked, &old_agi->agi_unlinked,
> +			sizeof(agi->agi_unlinked));
> +
> +	/* Mark the incore AGF data stale until we're done fixing things. */
> +	ASSERT(sc->sa.pag->pagi_init);
> +	sc->sa.pag->pagi_init = 0;
> +}
> +
> +/* Set btree root information in an AGI. */
> +STATIC void
> +xrep_agi_set_roots(
> +	struct xfs_scrub		*sc,
> +	struct xfs_agi			*agi,
> +	struct xrep_find_ag_btree	*fab)
> +{
> +	agi->agi_root = cpu_to_be32(fab[XREP_AGI_INOBT].root);
> +	agi->agi_level = cpu_to_be32(fab[XREP_AGI_INOBT].height);
> +
> +	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb)) {
> +		agi->agi_free_root = cpu_to_be32(fab[XREP_AGI_FINOBT].root);
> +		agi->agi_free_level = cpu_to_be32(fab[XREP_AGI_FINOBT].height);
> +	}
> +}
> +
> +/* Update the AGI counters. */
> +STATIC int
> +xrep_agi_calc_from_btrees(
> +	struct xfs_scrub	*sc,
> +	struct xfs_buf		*agi_bp)
> +{
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agi_bp);
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_agino_t		count;
> +	xfs_agino_t		freecount;
> +	int			error;
> +
> +	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> +			XFS_BTNUM_INO);
> +	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
> +	if (error)
> +		goto err;
> +	xfs_btree_del_cursor(cur, error);
> +
> +	agi->agi_count = cpu_to_be32(count);
> +	agi->agi_freecount = cpu_to_be32(freecount);
> +	return 0;
> +err:
> +	xfs_btree_del_cursor(cur, error);
> +	return error;
> +}
> +
> +/* Trigger reinitialization of the in-core data. */
> +STATIC int
> +xrep_agi_commit_new(
> +	struct xfs_scrub	*sc,
> +	struct xfs_buf		*agi_bp)
> +{
> +	struct xfs_perag	*pag;
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agi_bp);
> +
> +	/* Trigger inode count recalculation */
> +	xfs_force_summary_recalc(sc->mp);
> +
> +	/* Write this to disk. */
> +	xfs_trans_buf_set_type(sc->tp, agi_bp, XFS_BLFT_AGI_BUF);
> +	xfs_trans_log_buf(sc->tp, agi_bp, 0, BBTOB(agi_bp->b_length) - 1);
> +
> +	/* Now reinitialize the in-core counters if necessary. */
> +	pag = sc->sa.pag;
> +	pag->pagi_count = be32_to_cpu(agi->agi_count);
> +	pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
> +	pag->pagi_init = 1;
> +
> +	return 0;
> +}
> +
> +/* Repair the AGI. */
> +int
> +xrep_agi(
> +	struct xfs_scrub		*sc)
> +{
> +	struct xrep_find_ag_btree	fab[XREP_AGI_MAX] = {
> +		[XREP_AGI_INOBT] = {
> +			.rmap_owner = XFS_RMAP_OWN_INOBT,
> +			.buf_ops = &xfs_inobt_buf_ops,
> +			.magic = XFS_IBT_CRC_MAGIC,
> +		},
> +		[XREP_AGI_FINOBT] = {
> +			.rmap_owner = XFS_RMAP_OWN_INOBT,
> +			.buf_ops = &xfs_inobt_buf_ops,
> +			.magic = XFS_FIBT_CRC_MAGIC,
> +		},
> +		[XREP_AGI_END] = {
> +			.buf_ops = NULL
> +		},
> +	};
> +	struct xfs_agi			old_agi;
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_buf			*agi_bp;
> +	struct xfs_agi			*agi;
> +	int				error;
> +
> +	/* We require the rmapbt to rebuild anything. */
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		return -EOPNOTSUPP;
> +
> +	xchk_perag_get(sc->mp, &sc->sa);
> +	/*
> +	 * Make sure we have the AGI buffer, as scrub might have decided it
> +	 * was corrupt after xfs_ialloc_read_agi failed with -EFSCORRUPTED.
> +	 */
> +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGI_DADDR(mp)),
> +			XFS_FSS_TO_BB(mp, 1), 0, &agi_bp, NULL);
> +	if (error)
> +		return error;
> +	agi_bp->b_ops = &xfs_agi_buf_ops;
> +	agi = XFS_BUF_TO_AGI(agi_bp);
> +
> +	/* Find the AGI btree roots. */
> +	error = xrep_agi_find_btrees(sc, fab);
> +	if (error)
> +		return error;
> +
> +	/* Start rewriting the header and implant the btrees we found. */
> +	xrep_agi_init_header(sc, agi_bp, &old_agi);
> +	xrep_agi_set_roots(sc, agi, fab);
> +	error = xrep_agi_calc_from_btrees(sc, agi_bp);
> +	if (error)
> +		goto out_revert;
> +
> +	/* Reinitialize in-core state. */
> +	return xrep_agi_commit_new(sc, agi_bp);
> +
> +out_revert:
> +	/* Mark the incore AGI state stale and revert the AGI. */
> +	sc->sa.pag->pagi_init = 0;
> +	memcpy(agi, &old_agi, sizeof(old_agi));
> +	return error;
> +}
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 1d283360b5ab..9de321eee4ab 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -60,6 +60,7 @@ int xrep_probe(struct xfs_scrub *sc);
>  int xrep_superblock(struct xfs_scrub *sc);
>  int xrep_agf(struct xfs_scrub *sc);
>  int xrep_agfl(struct xfs_scrub *sc);
> +int xrep_agi(struct xfs_scrub *sc);
>  
>  #else
>  
> @@ -85,6 +86,7 @@ xrep_calc_ag_resblks(
>  #define xrep_superblock			xrep_notsupported
>  #define xrep_agf			xrep_notsupported
>  #define xrep_agfl			xrep_notsupported
> +#define xrep_agi			xrep_notsupported
>  
>  #endif /* CONFIG_XFS_ONLINE_REPAIR */
>  
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 2670f4cf62f4..4bfae1e61d30 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -226,7 +226,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_fs,
>  		.scrub	= xchk_agi,
> -		.repair	= xrep_notsupported,
> +		.repair	= xrep_agi,
>  	},
>  	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
>  		.type	= ST_PERAG,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
