Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24508 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdGWRDE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2017 13:03:04 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6NH33T0012144
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:03:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6NH33vu016114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:03:03 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6NH33J6031483
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:03:03 GMT
Subject: Re: [PATCH 08/22] xfs: scrub the AGI
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061195947.14732.3931480252152137337.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <73d8c0a9-fb63-a14d-2264-a7f56f617307@oracle.com>
Date: Sun, 23 Jul 2017 10:02:59 -0700
MIME-Version: 1.0
In-Reply-To: <150061195947.14732.3931480252152137337.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 7/20/2017 9:39 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Add a forgotten check to the AGI verifier, then wire up the scrub
> infrastructure to check the AGI contents.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h  |    3 +
>  fs/xfs/scrub/agheader.c |   96 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/common.c   |   10 ++++-
>  fs/xfs/scrub/common.h   |    1
>  fs/xfs/xfs_trace.h      |    3 +
>  5 files changed, 109 insertions(+), 4 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index cc35b7d..208cc48 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -486,7 +486,8 @@ struct xfs_scrub_metadata {
>  #define XFS_SCRUB_TYPE_SB	2	/* superblock */
>  #define XFS_SCRUB_TYPE_AGF	3	/* AG free header */
>  #define XFS_SCRUB_TYPE_AGFL	4	/* AG free list */
> -#define XFS_SCRUB_TYPE_MAX	4
> +#define XFS_SCRUB_TYPE_AGI	5	/* AG inode header */
> +#define XFS_SCRUB_TYPE_MAX	5
>
>  /* i: repair this metadata */
>  #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 48e276c..137d2ad 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -422,3 +422,99 @@ xfs_scrub_agfl(
>  }
>  #undef XFS_SCRUB_AGFL_OP_ERROR_GOTO
>  #undef XFS_SCRUB_AGFL_CHECK
> +
> +/* AGI */
> +
> +#define XFS_SCRUB_AGI_CHECK(fs_ok) \
> +	XFS_SCRUB_CHECK(sc, sc->sa.agi_bp, "AGI", fs_ok)
> +#define XFS_SCRUB_AGI_OP_ERROR_GOTO(error, label) \
> +	XFS_SCRUB_OP_ERROR_GOTO(sc, sc->sm->sm_agno, \
> +			XFS_AGI_BLOCK(sc->mp), "AGI", error, label)
> +/* Scrub the AGI. */
> +int
> +xfs_scrub_agi(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_agi			*agi;
> +	xfs_daddr_t			daddr;
> +	xfs_daddr_t			eofs;
> +	xfs_agnumber_t			agno;
> +	xfs_agblock_t			agbno;
> +	xfs_agblock_t			eoag;
> +	xfs_agino_t			agino;
> +	xfs_agino_t			first_agino;
> +	xfs_agino_t			last_agino;
> +	int				i;
> +	int				level;
> +	int				error = 0;
> +
> +	agno = sc->sm->sm_agno;
> +	error = xfs_scrub_load_ag_headers(sc, agno, XFS_SCRUB_TYPE_AGI);
> +	XFS_SCRUB_AGI_OP_ERROR_GOTO(&error, out);
> +
> +	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
> +	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> +
> +	/* Check the AG length */
> +	eoag = be32_to_cpu(agi->agi_length);
> +	XFS_SCRUB_AGI_CHECK(eoag == xfs_scrub_ag_blocks(mp, agno));
> +
> +	/* Check btree roots and levels */
> +	agbno = be32_to_cpu(agi->agi_root);
> +	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
> +	XFS_SCRUB_AGI_CHECK(agbno > XFS_AGI_BLOCK(mp));
> +	XFS_SCRUB_AGI_CHECK(agbno < mp->m_sb.sb_agblocks);
> +	XFS_SCRUB_AGI_CHECK(agbno < eoag);
> +	XFS_SCRUB_AGI_CHECK(daddr < eofs);
> +
> +	level = be32_to_cpu(agi->agi_level);
> +	XFS_SCRUB_AGI_CHECK(level > 0);
> +	XFS_SCRUB_AGI_CHECK(level <= XFS_BTREE_MAXLEVELS);
> +
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> +		agbno = be32_to_cpu(agi->agi_free_root);
> +		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
> +		XFS_SCRUB_AGI_CHECK(agbno > XFS_AGI_BLOCK(mp));
> +		XFS_SCRUB_AGI_CHECK(agbno < mp->m_sb.sb_agblocks);
> +		XFS_SCRUB_AGI_CHECK(agbno < eoag);
> +		XFS_SCRUB_AGI_CHECK(daddr < eofs);
> +
> +		level = be32_to_cpu(agi->agi_free_level);
> +		XFS_SCRUB_AGI_CHECK(level > 0);
> +		XFS_SCRUB_AGI_CHECK(level <= XFS_BTREE_MAXLEVELS);
> +	}
> +
> +	/* Check inode counters */
> +	first_agino = XFS_OFFBNO_TO_AGINO(mp, XFS_AGI_BLOCK(mp) + 1, 0);
> +	last_agino = XFS_OFFBNO_TO_AGINO(mp, eoag + 1, 0) - 1;
> +	agino = be32_to_cpu(agi->agi_count);
> +	XFS_SCRUB_AGI_CHECK(agino <= last_agino - first_agino + 1);
> +	XFS_SCRUB_AGI_CHECK(agino >= be32_to_cpu(agi->agi_freecount));
> +
> +	/* Check inode pointers */
> +	agino = be32_to_cpu(agi->agi_newino);
> +	if (agino != NULLAGINO) {
> +		XFS_SCRUB_AGI_CHECK(agino >= first_agino);
> +		XFS_SCRUB_AGI_CHECK(agino <= last_agino);
> +	}
> +	agino = be32_to_cpu(agi->agi_dirino);
> +	if (agino != NULLAGINO) {
> +		XFS_SCRUB_AGI_CHECK(agino >= first_agino);
> +		XFS_SCRUB_AGI_CHECK(agino <= last_agino);
> +	}
> +
> +	/* Check unlinked inode buckets */
> +	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
> +		agino = be32_to_cpu(agi->agi_unlinked[i]);
> +		if (agino == NULLAGINO)
> +			continue;
> +		XFS_SCRUB_AGI_CHECK(agino >= first_agino);
> +		XFS_SCRUB_AGI_CHECK(agino <= last_agino);
> +	}
> +
> +out:
> +	return error;
> +}
> +#undef XFS_SCRUB_AGI_CHECK
> +#undef XFS_SCRUB_AGI_OP_ERROR_GOTO
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index d1ef722..994c6c8 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -639,12 +639,14 @@ xfs_scrub_load_ag_headers(
>  	struct xfs_mount		*mp = sc->mp;
>  	int				error;
>
> -	ASSERT(type == XFS_SCRUB_TYPE_AGF || type == XFS_SCRUB_TYPE_AGFL);
> +	ASSERT(type == XFS_SCRUB_TYPE_AGF || type == XFS_SCRUB_TYPE_AGFL ||
> +	       type == XFS_SCRUB_TYPE_AGI);
>  	memset(&sc->sa, 0, sizeof(sc->sa));
>  	sc->sa.agno = agno;
>
>  	error = xfs_scrub_load_ag_header(sc, XFS_AGI_DADDR(mp),
> -			&sc->sa.agi_bp, &xfs_agi_buf_ops, false);
> +			&sc->sa.agi_bp, &xfs_agi_buf_ops,
> +			type == XFS_SCRUB_TYPE_AGI);
>  	if (error)
>  		return error;
>
> @@ -686,6 +688,10 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
>  		.setup	= xfs_scrub_setup_ag_header,
>  		.scrub	= xfs_scrub_agfl,
>  	},
> +	{ /* agi */
> +		.setup	= xfs_scrub_setup_ag_header,
> +		.scrub	= xfs_scrub_agi,
> +	},
>  };
>
>  /* Dispatch metadata scrubbing. */
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 5c4893d..952151a 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -216,6 +216,7 @@ SCRUB_FN(xfs_scrub_metabufs);
>  SCRUB_FN(xfs_scrub_superblock);
>  SCRUB_FN(xfs_scrub_agf);
>  SCRUB_FN(xfs_scrub_agfl);
> +SCRUB_FN(xfs_scrub_agi);
>  #undef SCRUB_FN
>
>  #endif	/* __XFS_REPAIR_COMMON_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index ebf6045..24efbff 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3316,7 +3316,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
>  	{ XFS_SCRUB_TYPE_METABUFS,	"metabufs" }, \
>  	{ XFS_SCRUB_TYPE_SB,		"superblock" }, \
>  	{ XFS_SCRUB_TYPE_AGF,		"AGF" }, \
> -	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }
> +	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }, \
> +	{ XFS_SCRUB_TYPE_AGI,		"AGI" }
>  DECLARE_EVENT_CLASS(xfs_scrub_class,
>  	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
>  		 int error),
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
