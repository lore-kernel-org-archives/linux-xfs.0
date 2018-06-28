Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbeF1VPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 17:15:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5SLF4gw176695
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:15:41 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2jum583ydd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:15:41 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5SLFeOG020759
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:15:40 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5SLFeMt004581
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 21:15:40 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 05/21] xfs: repair the AGI
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986824119.3155.17444896035154098752.stgit@magnolia>
Message-ID: <145434c6-e71b-f1ab-d4b8-9190528a33a7@oracle.com>
Date: Thu, 28 Jun 2018 14:15:39 -0700
MIME-Version: 1.0
In-Reply-To: <152986824119.3155.17444896035154098752.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 06/24/2018 12:24 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rebuild the AGI header items with some help from the rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/scrub/agheader_repair.c |  211 ++++++++++++++++++++++++++++++++++++++++
>   fs/xfs/scrub/repair.h          |    2
>   fs/xfs/scrub/scrub.c           |    2
>   3 files changed, 214 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 90e5e6cbc911..61e0134f6f9f 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -698,3 +698,214 @@ xfs_repair_agfl(
>   	xfs_repair_cancel_btree_extents(sc, &agfl_extents);
>   	return error;
>   }
> +
> +/* AGI */
> +
> +enum {
> +	REPAIR_AGI_INOBT = 0,
> +	REPAIR_AGI_FINOBT,
> +	REPAIR_AGI_END,
> +	REPAIR_AGI_MAX
> +};
> +
> +static const struct xfs_repair_find_ag_btree repair_agi[] = {
> +	[REPAIR_AGI_INOBT] = {
> +		.rmap_owner = XFS_RMAP_OWN_INOBT,
> +		.buf_ops = &xfs_inobt_buf_ops,
> +		.magic = XFS_IBT_CRC_MAGIC,
> +	},
> +	[REPAIR_AGI_FINOBT] = {
> +		.rmap_owner = XFS_RMAP_OWN_INOBT,
> +		.buf_ops = &xfs_inobt_buf_ops,
> +		.magic = XFS_FIBT_CRC_MAGIC,
> +	},
> +	[REPAIR_AGI_END] = {
> +		.buf_ops = NULL
> +	},
> +};
> +
> +/* Find the inode btree roots from the rmap data. */
> +STATIC int
> +xfs_repair_agi_find_btrees(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_repair_find_ag_btree	*fab)
> +{
> +	struct xfs_buf			*agf_bp;
> +	struct xfs_mount		*mp = sc->mp;
> +	int				error;
> +
> +	memcpy(fab, repair_agi, sizeof(repair_agi));
> +
> +	/* Read the AGF. */
> +	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
> +	if (error)
> +		return error;
> +	if (!agf_bp)
> +		return -ENOMEM;
> +
> +	/* Find the btree roots. */
> +	error = xfs_repair_find_ag_btree_roots(sc, agf_bp, fab, NULL);
> +	if (error)
> +		return error;
> +
> +	/* We must find the inobt root. */
> +	if (fab[REPAIR_AGI_INOBT].root == NULLAGBLOCK ||
> +	    fab[REPAIR_AGI_INOBT].height > XFS_BTREE_MAXLEVELS)
> +		return -EFSCORRUPTED;
> +
> +	/* We must find the finobt root if that feature is enabled. */
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
> +	    (fab[REPAIR_AGI_FINOBT].root == NULLAGBLOCK ||
> +	     fab[REPAIR_AGI_FINOBT].height > XFS_BTREE_MAXLEVELS))
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
> +xfs_repair_agi_init_header(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_buf			*agi_bp,
> +	struct xfs_agi			*old_agi)
> +{
> +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agi_bp);
> +	struct xfs_mount		*mp = sc->mp;
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
> +}
> +
> +/* Set btree root information in an AGI. */
> +STATIC void
> +xfs_repair_agi_set_roots(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_agi			*agi,
> +	struct xfs_repair_find_ag_btree	*fab)
> +{
> +	agi->agi_root = cpu_to_be32(fab[REPAIR_AGI_INOBT].root);
> +	agi->agi_level = cpu_to_be32(fab[REPAIR_AGI_INOBT].height);
> +
> +	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb)) {
> +		agi->agi_free_root = cpu_to_be32(fab[REPAIR_AGI_FINOBT].root);
> +		agi->agi_free_level =
> +				cpu_to_be32(fab[REPAIR_AGI_FINOBT].height);
> +	}
> +}
> +
> +/* Update the AGI counters. */
> +STATIC int
> +xfs_repair_agi_update_btree_counters(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_buf			*agi_bp)
> +{
> +	struct xfs_btree_cur		*cur;
> +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agi_bp);
> +	struct xfs_mount		*mp = sc->mp;
> +	xfs_agino_t			count;
> +	xfs_agino_t			freecount;
> +	int				error;
> +
> +	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> +			XFS_BTNUM_INO);
> +	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
> +	if (error)
> +		goto err;
> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +
> +	agi->agi_count = cpu_to_be32(count);
> +	agi->agi_freecount = cpu_to_be32(freecount);
> +	return 0;
> +err:
> +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> +	return error;
> +}
> +
> +/* Trigger reinitialization of the in-core data. */
> +STATIC int
> +xfs_repair_agi_reinit_incore(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_agi			*agi,
> +	const struct xfs_agi		*old_agi)
> +{
> +	struct xfs_perag		*pag;
> +
> +	/* XXX: trigger inode count recalculation */
> +
> +	/* Now reinitialize the in-core counters if necessary. */
> +	pag = sc->sa.pag;
> +	if (!pag->pagf_init)
> +		return 0;
> +
> +	sc->sa.pag->pagi_count = be32_to_cpu(agi->agi_count);
> +	sc->sa.pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
> +
> +	return 0;
> +}
> +
> +/* Repair the AGI. */
> +int
> +xfs_repair_agi(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_repair_find_ag_btree	fab[REPAIR_AGI_MAX];
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
> +	xfs_scrub_perag_get(sc->mp, &sc->sa);
> +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGI_DADDR(mp)),
> +			XFS_FSS_TO_BB(mp, 1), 0, &agi_bp, NULL);
> +	if (error)
> +		return error;
> +	agi_bp->b_ops = &xfs_agi_buf_ops;
> +	agi = XFS_BUF_TO_AGI(agi_bp);
> +
> +	/* Find the AGI btree roots. */
> +	error = xfs_repair_agi_find_btrees(sc, fab);
> +	if (error)
> +		return error;
> +
> +	/* Start rewriting the header and implant the btrees we found. */
> +	xfs_repair_agi_init_header(sc, agi_bp, &old_agi);
> +	xfs_repair_agi_set_roots(sc, agi, fab);
> +	error = xfs_repair_agi_update_btree_counters(sc, agi_bp);
> +	if (error)
> +		goto out_revert;
> +
> +	/* Reinitialize in-core state. */
> +	error = xfs_repair_agi_reinit_incore(sc, agi, &old_agi);
> +	if (error)
> +		goto out_revert;
> +
> +	/* Write this to disk. */
> +	xfs_trans_buf_set_type(sc->tp, agi_bp, XFS_BLFT_AGI_BUF);
> +	xfs_trans_log_buf(sc->tp, agi_bp, 0, BBTOB(agi_bp->b_length) - 1);
> +	return error;
> +
> +out_revert:
> +	memcpy(agi, &old_agi, sizeof(old_agi));
> +	return error;
> +}
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index f2af5923aa75..d541c1586d0a 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -102,6 +102,7 @@ int xfs_repair_probe(struct xfs_scrub_context *sc);
>   int xfs_repair_superblock(struct xfs_scrub_context *sc);
>   int xfs_repair_agf(struct xfs_scrub_context *sc);
>   int xfs_repair_agfl(struct xfs_scrub_context *sc);
> +int xfs_repair_agi(struct xfs_scrub_context *sc);
>   
>   #else
>   
> @@ -127,6 +128,7 @@ xfs_repair_calc_ag_resblks(
>   #define xfs_repair_superblock		xfs_repair_notsupported
>   #define xfs_repair_agf			xfs_repair_notsupported
>   #define xfs_repair_agfl			xfs_repair_notsupported
> +#define xfs_repair_agi			xfs_repair_notsupported
>   
>   #endif /* CONFIG_XFS_ONLINE_REPAIR */
>   
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 8e11c3c699fb..0f036aab2551 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -220,7 +220,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
>   		.type	= ST_PERAG,
>   		.setup	= xfs_scrub_setup_fs,
>   		.scrub	= xfs_scrub_agi,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xfs_repair_agi,
>   	},
>   	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
>   		.type	= ST_PERAG,
> 

It looks ok in terms of aligning with the infrastructure in the last 
patch. It does look pretty similar to the xfs_repair_ag* routines, so if 
there's common code that can be factored out, that would be great. 
Realistically though in studying what that solution might look like, I 
think the AGF/AGFL/AGI code paths have just enough differences such that 
trying to push it all through a common code path may end up generating a 
lot of switch like statements, so it may not be worth it.  Just a 
suggestion to consider.

Allison

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=vvDQam1-gFYigwUy0mxQkiHsCjC2HRjT0eB_fDn9esQ&s=H326jzffjTika3ys5iwsQGiICINSSbtbj3LaL2VbjJY&e=
> 
