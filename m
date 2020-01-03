Return-Path: <SRS0=vgQ5=2Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61222C2D0C2
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jan 2020 21:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14AF821835
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jan 2020 21:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ji2qIjT+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgACV2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jan 2020 16:28:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56064 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbgACV2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jan 2020 16:28:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003LO8NA106744;
        Fri, 3 Jan 2020 21:28:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vcBMKfVRJjXbSkmSHi2dGVUWucnbaodtrsYomV3m/Kc=;
 b=ji2qIjT+PBSxDwSQ2ofdTEdQmLOkFZtyOpr5Ce/OomA3Q5Pug2bJNh6IrtarDVO+aRJ2
 6MQpOmoB8qNs/RfDCVUTtHdWh8QqJBrMN73meGaChCTicYx3H3dqaMG7SIFvG4gwitTI
 ng3UAew2K2Xy27hYocMy1oAEiLTVgwLRnvG4Tt4bpIiY9pXUXPyhX1KwU3NxOBDJdRNq
 KXBrDGWnCsrocabsiZL2OfyALtMVaGDIu2Pmm8qMzpTzczO0vfQAy8P24PddU1VlrngF
 KvL3XocvVfUTctR4Ba6s8ye1qKTeLuonnesAfmNlo62GM4HyF0VBhTwmo3aLuYhhNsvi xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqx8v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 21:28:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003LS4BG068138;
        Fri, 3 Jan 2020 21:28:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xa5fh051n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 21:28:07 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 003LS63E024494;
        Fri, 3 Jan 2020 21:28:06 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 13:28:06 -0800
Subject: Re: [PATCH 2/2] xfs_repair: rebuild block mappings from rmapbt data
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <157784174393.1372355.6666502611131426530.stgit@magnolia>
 <157784175624.1372355.14905443087406979099.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b106a8fb-c30d-7dd5-771f-8074d0f4bcdf@oracle.com>
Date:   Fri, 3 Jan 2020 14:28:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <157784175624.1372355.14905443087406979099.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030195
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030194
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/31/19 6:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use rmap records to rebuild corrupt inode forks instead of zapping
> the whole inode if we think the rmap data is reasonably sane.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   include/xfs_trans.h      |    3
>   libxfs/libxfs_api_defs.h |   15 +
>   libxfs/trans.c           |   48 ++++
>   repair/Makefile          |    5
>   repair/bload.c           |   36 +++
>   repair/bload.h           |    3
>   repair/bmap_repair.c     |  585 ++++++++++++++++++++++++++++++++++++++++++++++
>   repair/bmap_repair.h     |   13 +
>   repair/dinode.c          |   46 ++++
>   repair/rmap.c            |    2
>   repair/rmap.h            |    1
>   11 files changed, 753 insertions(+), 4 deletions(-)
>   create mode 100644 repair/bmap_repair.c
>   create mode 100644 repair/bmap_repair.h
> 
> 
> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index cff27546..0011cc93 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -142,4 +142,7 @@ libxfs_trans_read_buf(
>   	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
>   }
>   
> +int libxfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
> +			uint rtextents);
> +
>   #endif	/* __XFS_TRANS_H__ */
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 72605d4d..a9e00e97 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -151,6 +151,10 @@
>   #define xfs_init_local_fork		libxfs_init_local_fork
>   #define xfs_dir2_namecheck		libxfs_dir2_namecheck
>   #define xfs_attr_namecheck		libxfs_attr_namecheck
> +#define xfs_bmbt_calc_size		libxfs_bmbt_calc_size
> +#define xfs_rmap_query_all		libxfs_rmap_query_all
> +#define xfs_bmapi_remap			libxfs_bmapi_remap
> +#define xfs_imap_to_bp			libxfs_imap_to_bp
>   
>   #define LIBXFS_ATTR_ROOT		ATTR_ROOT
>   #define LIBXFS_ATTR_SECURE		ATTR_SECURE
> @@ -185,4 +189,15 @@
>   #define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
>   #define xfs_refcountbt_stage_cursor	libxfs_refcountbt_stage_cursor
>   
> +#define xfs_bmbt_disk_set_all		libxfs_bmbt_disk_set_all
> +#define xfs_bmbt_disk_get_startoff	libxfs_bmbt_disk_get_startoff
> +#define xfs_iext_first			libxfs_iext_first
> +#define xfs_iext_insert_raw		libxfs_iext_insert_raw
> +#define xfs_iext_next			libxfs_iext_next
> +#define xfs_btree_bload_compute_geometry	libxfs_btree_bload_compute_geometry
> +#define xfs_bmbt_stage_cursor		libxfs_bmbt_stage_cursor
> +#define xfs_btree_bload			libxfs_btree_bload
> +#define xfs_rmap_ino_bmbt_owner		libxfs_rmap_ino_bmbt_owner
> +#define xfs_bmbt_commit_staged_btree	libxfs_bmbt_commit_staged_btree
> +
>   #endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 18b87d70..12863c9e 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -999,3 +999,51 @@ libxfs_trans_commit(
>   {
>   	return __xfs_trans_commit(tp, false);
>   }
> +
> +/*
> + * Try to reserve more blocks for a transaction.  The single use case we
> + * support is for offline repair -- use a transaction to gather data without
> + * fear of btree cycle deadlocks; calculate how many blocks we really need
> + * from that data; and only then start modifying data.  This can fail due to
> + * ENOSPC, so we have to be able to cancel the transaction.
> + */
> +int
> +libxfs_trans_reserve_more(
> +	struct xfs_trans	*tp,
> +	uint			blocks,
> +	uint			rtextents)
> +{
> +	int			error = 0;
> +
> +	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
> +
> +	/*
> +	 * Attempt to reserve the needed disk blocks by decrementing
> +	 * the number needed from the number available.  This will
> +	 * fail if the count would go below zero.
> +	 */
> +	if (blocks > 0) {
> +		if (tp->t_mountp->m_sb.sb_fdblocks < blocks)
> +			return -ENOSPC;
> +		tp->t_blk_res += blocks;
> +	}
> +
> +	/*
> +	 * Attempt to reserve the needed realtime extents by decrementing
> +	 * the number needed from the number available.  This will
> +	 * fail if the count would go below zero.
> +	 */
> +	if (rtextents > 0) {
> +		if (tp->t_mountp->m_sb.sb_rextents < rtextents) {
> +			error = -ENOSPC;
> +			goto out_blocks;
> +		}
> +	}
I dont think sb_rextents can be negative here, so I think the greater 
than 0 check can come out?  Also, the goto doesnt seem to advance very 
far or be used else where.  Wouldn't it be simpler if it just went like 
this?



if (tp->t_mountp->m_sb.sb_rextents < rtextents) {
	if (blocks > 0)
		tp->t_blk_res -= blocks;
	return -ENOSPC;
}

return 0;




That looks logically equivalent.  Though it is unclear to me why we 
continue to modify the transaction if we already know we're on an error 
path.  Is that something that you meant to do?

Allison

> +
> +	return 0;
> +out_blocks:
> +	if (blocks > 0)
> +		tp->t_blk_res -= blocks;
> +
> +	return error;
> +}
> diff --git a/repair/Makefile b/repair/Makefile
> index 8cc1ee68..fbda679c 100644
> --- a/repair/Makefile
> +++ b/repair/Makefile
> @@ -11,14 +11,15 @@ LTCOMMAND = xfs_repair
>   
>   HFILES = agheader.h attr_repair.h avl.h bload.h bmap.h btree.h \
>   	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
> -	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
> +	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h \
> +	bmap_repair.h
>   
>   CFILES = agheader.c attr_repair.c avl.c bload.c bmap.c btree.c \
>   	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
>   	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
>   	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
>   	progress.c prefetch.c rmap.c rt.c sb.c scan.c slab.c threads.c \
> -	versions.c xfs_repair.c
> +	versions.c bmap_repair.c xfs_repair.c
>   
>   LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
>   	$(LIBPTHREAD) $(LIBBLKID)
> diff --git a/repair/bload.c b/repair/bload.c
> index 896e2ae6..5bfbf676 100644
> --- a/repair/bload.c
> +++ b/repair/bload.c
> @@ -274,3 +274,39 @@ xrep_newbt_alloc_block(
>   		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
>   	return 0;
>   }
> +
> +/*
> + * Estimate proper slack values for a btree that's being reloaded.
> + *
> + * Under most circumstances, we'll take whatever default loading value the
> + * btree bulk loading code calculates for us.  However, there are some
> + * exceptions to this rule:
> + *
> + * (1) If someone turned one of the debug knobs.
> + * (2) The FS has less than ~9% space free.
> + *
> + * Note that we actually use 3/32 for the comparison to avoid division.
> + */
> +void
> +estimate_inode_bload_slack(
> +	struct xfs_mount	*mp,
> +	struct xfs_btree_bload	*bload)
> +{
> +	/*
> +	 * The global values are set to -1 (i.e. take the bload defaults)
> +	 * unless someone has set them otherwise, so we just pull the values
> +	 * here.
> +	 */
> +	bload->leaf_slack = bload_leaf_slack;
> +	bload->node_slack = bload_node_slack;
> +
> +	/* No further changes if there's more than 3/32ths space left. */
> +	if (mp->m_sb.sb_fdblocks >= ((mp->m_sb.sb_dblocks * 3) >> 5))
> +		return;
> +
> +	/* We're low on space; load the btrees as tightly as possible. */
> +	if (bload->leaf_slack < 0)
> +		bload->leaf_slack = 0;
> +	if (bload->node_slack < 0)
> +		bload->node_slack = 0;
> +}
> diff --git a/repair/bload.h b/repair/bload.h
> index 8f890157..5458c3b0 100644
> --- a/repair/bload.h
> +++ b/repair/bload.h
> @@ -76,4 +76,7 @@ void xrep_newbt_destroy(struct xrep_newbt *xba, int error);
>   int xrep_newbt_alloc_block(struct xfs_btree_cur *cur, struct xrep_newbt *xba,
>   		union xfs_btree_ptr *ptr);
>   
> +void estimate_inode_bload_slack(struct xfs_mount *mp,
> +		struct xfs_btree_bload *bload);
> +
>   #endif /* __XFS_REPAIR_BLOAD_H__ */
> diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
> new file mode 100644
> index 00000000..0d52f681
> --- /dev/null
> +++ b/repair/bmap_repair.c
> @@ -0,0 +1,585 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include <libxfs.h>
> +#include "btree.h"
> +#include "err_protos.h"
> +#include "libxlog.h"
> +#include "incore.h"
> +#include "globals.h"
> +#include "dinode.h"
> +#include "slab.h"
> +#include "rmap.h"
> +#include "bload.h"
> +#include "bmap_repair.h"
> +
> +#define trace_xrep_bmap_found(...)	((void) 0)
> +#define min_t(type, x, y) ( ((type)(x)) > ((type)(y)) ? ((type)(y)) : ((type)(x)) )
> +
> +/* Ported routines from fs/xfs/scrub/bmap_repair.c */
> +
> +/*
> + * Inode Fork Block Mapping (BMBT) Repair
> + * ======================================
> + *
> + * Gather all the rmap records for the inode and fork we're fixing, reset the
> + * incore fork, then recreate the btree.
> + */
> +struct xrep_bmap {
> +	/* List of new bmap records. */
> +	struct xfs_slab		*bmap_records;
> +	struct xfs_slab_cursor	*bmap_cursor;
> +
> +	/* New fork. */
> +	struct xrep_newbt	new_fork_info;
> +
> +	struct repair_ctx	*sc;
> +
> +	/* How many blocks did we find allocated to this file? */
> +	xfs_rfsblock_t		nblocks;
> +
> +	/* How many bmbt blocks did we find for this fork? */
> +	xfs_rfsblock_t		old_bmbt_block_count;
> +
> +	/* Which fork are we fixing? */
> +	int			whichfork;
> +};
> +
> +/* Record extents that belong to this inode's fork. */
> +STATIC int
> +xrep_bmap_walk_rmap(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_rmap_irec	*rec,
> +	void			*priv)
> +{
> +	struct xrep_bmap	*rb = priv;
> +	struct xfs_bmbt_rec	rbe;
> +	struct xfs_bmbt_irec	irec;
> +	struct xfs_mount	*mp = cur->bc_mp;
> +	int			error = 0;
> +
> +	/* Skip extents which are not owned by this inode and fork. */
> +	if (rec->rm_owner != rb->sc->ip->i_ino)
> +		return 0;
> +
> +	rb->nblocks += rec->rm_blockcount;
> +
> +	/* If this rmap isn't for the fork we want, we're done. */
> +	if (rb->whichfork == XFS_DATA_FORK &&
> +	    (rec->rm_flags & XFS_RMAP_ATTR_FORK))
> +		return 0;
> +	if (rb->whichfork == XFS_ATTR_FORK &&
> +	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
> +		return 0;
> +
> +	/* Remember any old bmbt blocks we find so we can delete them later. */
> +	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
> +		rb->old_bmbt_block_count += rec->rm_blockcount;
> +		return 0;
> +	}
> +
> +	/* Remember this rmap as a series of bmap records. */
> +	irec.br_startoff = rec->rm_offset;
> +	irec.br_startblock = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
> +					rec->rm_startblock);
> +	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
> +		irec.br_state = XFS_EXT_UNWRITTEN;
> +	else
> +		irec.br_state = XFS_EXT_NORM;
> +
> +	do {
> +		xfs_extlen_t len = min_t(xfs_filblks_t, rec->rm_blockcount,
> +					 MAXEXTLEN);
> +
> +		irec.br_blockcount = len;
> +		libxfs_bmbt_disk_set_all(&rbe, &irec);
> +
> +		trace_xrep_bmap_found(rb->sc->ip, rb->whichfork, &irec);
> +
> +		error = slab_add(rb->bmap_records, &rbe);
> +
> +		irec.br_startblock += len;
> +		irec.br_startoff += len;
> +		rec->rm_blockcount -= len;
> +	} while (error == 0 && rec->rm_blockcount > 0);
> +
> +	return error;
> +}
> +
> +/* Compare two bmap extents. */
> +static int
> +xrep_bmap_extent_cmp(
> +	const void			*a,
> +	const void			*b)
> +{
> +	xfs_fileoff_t			ao;
> +	xfs_fileoff_t			bo;
> +
> +	ao = libxfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)a);
> +	bo = libxfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)b);
> +
> +	if (ao > bo)
> +		return 1;
> +	else if (ao < bo)
> +		return -1;
> +	return 0;
> +}
> +
> +/* Scan one AG for reverse mappings that we can turn into extent maps. */
> +STATIC int
> +xrep_bmap_scan_ag(
> +	struct xrep_bmap	*rb,
> +	xfs_agnumber_t		agno)
> +{
> +	struct repair_ctx	*sc = rb->sc;
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_buf		*agf_bp = NULL;
> +	struct xfs_btree_cur	*cur;
> +	int			error;
> +
> +	error = -libxfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
> +	if (error)
> +		return error;
> +	if (!agf_bp)
> +		return ENOMEM;
> +	cur = libxfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, agno);
> +	error = -libxfs_rmap_query_all(cur, xrep_bmap_walk_rmap, rb);
> +	libxfs_btree_del_cursor(cur, error);
> +	libxfs_trans_brelse(sc->tp, agf_bp);
> +	return error;
> +}
> +
> +/* Check for garbage inputs. */
> +STATIC int
> +xrep_bmap_check_inputs(
> +	struct repair_ctx	*sc,
> +	int			whichfork)
> +{
> +	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
> +
> +	/* Don't know how to repair the other fork formats. */
> +	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> +	    XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE)
> +		return EOPNOTSUPP;
> +
> +	/*
> +	 * If there's no attr fork area in the inode, there's no attr fork to
> +	 * rebuild.
> +	 */
> +	if (whichfork == XFS_ATTR_FORK) {
> +		if (!XFS_IFORK_Q(sc->ip))
> +			return ENOENT;
> +		return 0;
> +	}
> +
> +	/* Only files, symlinks, and directories get to have data forks. */
> +	switch (VFS_I(sc->ip)->i_mode & S_IFMT) {
> +	case S_IFREG:
> +	case S_IFDIR:
> +	case S_IFLNK:
> +		/* ok */
> +		break;
> +	default:
> +		return EINVAL;
> +	}
> +
> +	/* If we somehow have delalloc extents, forget it. */
> +	if (sc->ip->i_delayed_blks)
> +		return EBUSY;
> +
> +	/* Don't know how to rebuild realtime data forks. */
> +	if (XFS_IS_REALTIME_INODE(sc->ip))
> +		return EOPNOTSUPP;
> +
> +	return 0;
> +}
> +
> +/*
> + * Collect block mappings for this fork of this inode and decide if we have
> + * enough space to rebuild.  Caller is responsible for cleaning up the list if
> + * anything goes wrong.
> + */
> +STATIC int
> +xrep_bmap_find_mappings(
> +	struct xrep_bmap	*rb)
> +{
> +	struct repair_ctx	*sc = rb->sc;
> +	xfs_agnumber_t		agno;
> +	int			error = 0;
> +
> +	/* Iterate the rmaps for extents. */
> +	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> +		error = xrep_bmap_scan_ag(rb, agno);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Retrieve bmap data for bulk load. */
> +STATIC int
> +xrep_bmap_get_data(
> +	struct xfs_btree_cur	*cur,
> +	void			*priv)
> +{
> +	struct xfs_bmbt_rec	*rec;
> +	struct xfs_bmbt_irec	*irec = &cur->bc_rec.b;
> +	struct xrep_bmap	*rb = priv;
> +
> +	rec = pop_slab_cursor(rb->bmap_cursor);
> +	libxfs_bmbt_disk_get_all(rec, irec);
> +	return 0;
> +}
> +
> +/* Feed one of the new btree blocks to the bulk loader. */
> +STATIC int
> +xrep_bmap_alloc_block(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr,
> +	void			*priv)
> +{
> +	struct xrep_bmap        *rb = priv;
> +
> +	return xrep_newbt_alloc_block(cur, &rb->new_fork_info, ptr);
> +}
> +
> +/* Figure out how much space we need to create the incore btree root block. */
> +STATIC size_t
> +xrep_bmap_iroot_size(
> +	struct xfs_btree_cur	*cur,
> +	unsigned int		nr_this_level,
> +	void			*priv)
> +{
> +	return XFS_BMAP_BROOT_SPACE_CALC(cur->bc_mp, nr_this_level);
> +}
> +
> +/* Update the inode counters. */
> +STATIC int
> +xrep_bmap_reset_counters(
> +	struct xrep_bmap	*rb)
> +{
> +	struct repair_ctx	*sc = rb->sc;
> +	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
> +	int64_t			delta;
> +
> +	/*
> +	 * Update the inode block counts to reflect the extents we found in the
> +	 * rmapbt.
> +	 */
> +	delta = ifake->if_blocks - rb->old_bmbt_block_count;
> +	sc->ip->i_d.di_nblocks = rb->nblocks + delta;
> +	libxfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
> +
> +	/* Quotas don't exist so we're done. */
> +	return 0;
> +}
> +
> +/* Create a new iext tree and load it with block mappings. */
> +STATIC int
> +xrep_bmap_extents_load(
> +	struct xrep_bmap	*rb,
> +	struct xfs_btree_cur	*bmap_cur)
> +{
> +	struct xfs_iext_cursor	icur;
> +	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
> +	struct xfs_ifork	*ifp = ifake->if_fork;
> +	unsigned int		i;
> +	int			error;
> +
> +	ASSERT(ifp->if_bytes == 0);
> +
> +	error = init_slab_cursor(rb->bmap_records, xrep_bmap_extent_cmp,
> +			&rb->bmap_cursor);
> +	if (error)
> +		return error;
> +
> +	/* Add all the records to the incore extent tree. */
> +	libxfs_iext_first(ifp, &icur);
> +	for (i = 0; i < ifake->if_extents; i++) {
> +		error = xrep_bmap_get_data(bmap_cur, rb);
> +		if (error)
> +			return error;
> +		libxfs_iext_insert_raw(ifp, &icur, &bmap_cur->bc_rec.b);
> +		libxfs_iext_next(ifp, &icur);
> +	}
> +	ifp->if_flags = XFS_IFEXTENTS;
> +	free_slab_cursor(&rb->bmap_cursor);
> +
> +	return 0;
> +}
> +
> +/* Reserve new btree blocks and bulk load all the bmap records. */
> +STATIC int
> +xrep_bmap_btree_load(
> +	struct xrep_bmap	*rb,
> +	struct xfs_btree_cur	**bmap_curp)
> +{
> +	struct xfs_btree_bload	bmap_bload = {
> +		.get_data	= xrep_bmap_get_data,
> +		.alloc_block	= xrep_bmap_alloc_block,
> +		.iroot_size	= xrep_bmap_iroot_size,
> +	};
> +	struct repair_ctx	*sc = rb->sc;
> +	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
> +	int			error;
> +
> +	estimate_inode_bload_slack(sc->mp, &bmap_bload);
> +
> +	/* Compute how many blocks we'll need. */
> +	error = -libxfs_btree_bload_compute_geometry(*bmap_curp, &bmap_bload,
> +			ifake->if_extents);
> +	if (error)
> +		return error;
> +	libxfs_btree_del_cursor(*bmap_curp, error);
> +	*bmap_curp = NULL;
> +
> +	/*
> +	 * Guess how many blocks we're going to need to rebuild an entire bmap
> +	 * from the number of extents we found, and pump up our transaction to
> +	 * have sufficient block reservation.
> +	 */
> +	error = -libxfs_trans_reserve_more(sc->tp, bmap_bload.nr_blocks, 0);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Reserve the space we'll need for the new btree.  Drop the cursor
> +	 * while we do this because that can roll the transaction and cursors
> +	 * can't handle that.
> +	 */
> +	error = xrep_newbt_reserve_space(&rb->new_fork_info,
> +			bmap_bload.nr_blocks);
> +	if (error)
> +		return error;
> +
> +	/* Add all observed bmap records. */
> +	error = init_slab_cursor(rb->bmap_records, xrep_bmap_extent_cmp,
> +			&rb->bmap_cursor);
> +	if (error)
> +		return error;
> +	*bmap_curp = libxfs_bmbt_stage_cursor(sc->mp, sc->tp, sc->ip, ifake);
> +	error = -libxfs_btree_bload(*bmap_curp, &bmap_bload, rb);
> +	free_slab_cursor(&rb->bmap_cursor);
> +	return error;
> +}
> +
> +/*
> + * Use the collected bmap information to stage a new bmap fork.  If this is
> + * successful we'll return with the new fork information logged to the repair
> + * transaction but not yet committed.
> + */
> +STATIC int
> +xrep_bmap_build_new_fork(
> +	struct xrep_bmap	*rb)
> +{
> +	struct xfs_owner_info	oinfo;
> +	struct repair_ctx	*sc = rb->sc;
> +	struct xfs_btree_cur	*bmap_cur;
> +	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
> +	int			error;
> +
> +	/*
> +	 * Sort the bmap extents by startblock to avoid btree splits when we
> +	 * rebuild the bmbt btree.
> +	 */
> +	qsort_slab(rb->bmap_records, xrep_bmap_extent_cmp);
> +
> +	/*
> +	 * Prepare to construct the new fork by initializing the new btree
> +	 * structure and creating a fake ifork in the ifakeroot structure.
> +	 */
> +	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
> +	xrep_newbt_init_inode(&rb->new_fork_info, sc, rb->whichfork, &oinfo);
> +	bmap_cur = libxfs_bmbt_stage_cursor(sc->mp, sc->tp, sc->ip, ifake);
> +
> +	/*
> +	 * Figure out the size and format of the new fork, then fill it with
> +	 * all the bmap records we've found.  Join the inode to the transaction
> +	 * so that we can roll the transaction while holding the inode locked.
> +	 */
> +	libxfs_trans_ijoin(sc->tp, sc->ip, 0);
> +	ifake->if_extents = slab_count(rb->bmap_records);
> +	if (XFS_BMDR_SPACE_CALC(ifake->if_extents) <=
> +	    XFS_DFORK_SIZE(&sc->ip->i_d, sc->mp, rb->whichfork)) {
> +		ifake->if_format = XFS_DINODE_FMT_EXTENTS;
> +		error = xrep_bmap_extents_load(rb, bmap_cur);
> +	} else {
> +		ifake->if_format = XFS_DINODE_FMT_BTREE;
> +		error = xrep_bmap_btree_load(rb, &bmap_cur);
> +	}
> +	if (error)
> +		goto err_cur;
> +
> +	/*
> +	 * Install the new fork in the inode.  After this point the old mapping
> +	 * data are no longer accessible and the new tree is live.  We delete
> +	 * the cursor immediately after committing the staged root because the
> +	 * staged fork might be in extents format.
> +	 */
> +	libxfs_bmbt_commit_staged_btree(bmap_cur, rb->whichfork);
> +	libxfs_btree_del_cursor(bmap_cur, 0);
> +
> +	/* Reset the inode counters now that we've changed the fork. */
> +	error = xrep_bmap_reset_counters(rb);
> +	if (error)
> +		goto err_newbt;
> +
> +	/* Dispose of any unused blocks and the accounting infomation. */
> +	xrep_newbt_destroy(&rb->new_fork_info, error);
> +
> +	return -libxfs_trans_roll_inode(&sc->tp, sc->ip);
> +err_cur:
> +	if (bmap_cur)
> +		libxfs_btree_del_cursor(bmap_cur, error);
> +err_newbt:
> +	xrep_newbt_destroy(&rb->new_fork_info, error);
> +	return error;
> +}
> +
> +/* Repair an inode fork. */
> +STATIC int
> +xrep_bmap(
> +	struct repair_ctx	*sc,
> +	int			whichfork)
> +{
> +	struct xrep_bmap	*rb;
> +	int			error = 0;
> +
> +	error = xrep_bmap_check_inputs(sc, whichfork);
> +	if (error)
> +		return error;
> +
> +	rb = kmem_zalloc(sizeof(struct xrep_bmap), KM_NOFS | KM_MAYFAIL);
> +	if (!rb)
> +		return ENOMEM;
> +	rb->sc = sc;
> +	rb->whichfork = whichfork;
> +
> +	/* Set up some storage */
> +	error = init_slab(&rb->bmap_records, sizeof(struct xfs_bmbt_rec));
> +	if (error)
> +		goto out_rb;
> +
> +	/* Collect all reverse mappings for this fork's extents. */
> +	error = xrep_bmap_find_mappings(rb);
> +	if (error)
> +		goto out_bitmap;
> +
> +	/* Rebuild the bmap information. */
> +	error = xrep_bmap_build_new_fork(rb);
> +
> +	/*
> +	 * We don't need to free the old bmbt blocks because we're rebuilding
> +	 * all the space metadata later.
> +	 */
> +
> +out_bitmap:
> +	free_slab(&rb->bmap_records);
> +out_rb:
> +	kmem_free(rb);
> +	return error;
> +}
> +
> +/* Rebuild some inode's bmap. */
> +int
> +rebuild_bmap(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	int			whichfork,
> +	unsigned long		nr_extents,
> +	struct xfs_buf		**ino_bpp,
> +	struct xfs_dinode	**dinop,
> +	int			*dirty)
> +{
> +	struct repair_ctx	sc = {
> +		.mp		= mp,
> +	};
> +	struct xfs_buf		*bp;
> +	unsigned long long	resblks;
> +	xfs_daddr_t		bp_bn;
> +	int			bp_length;
> +	int			error;
> +
> +	bp_bn = (*ino_bpp)->b_bn;
> +	bp_length = (*ino_bpp)->b_length;
> +
> +	/*
> +	 * Bail out if the inode didn't think it had extents.  Otherwise, zap
> +	 * it back to a zero-extents fork so that we can rebuild it.
> +	 */
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +		if ((*dinop)->di_nextents == 0)
> +			return 0;
> +		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
> +		(*dinop)->di_nextents = 0;
> +		libxfs_dinode_calc_crc(mp, *dinop);
> +		*dirty = 1;
> +		break;
> +	case XFS_ATTR_FORK:
> +		if ((*dinop)->di_anextents == 0)
> +			return 0;
> +		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
> +		(*dinop)->di_anextents = 0;
> +		libxfs_dinode_calc_crc(mp, *dinop);
> +		*dirty = 1;
> +		break;
> +	default:
> +		return EINVAL;
> +	}
> +
> +	resblks = libxfs_bmbt_calc_size(mp, nr_extents);
> +	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks, 0,
> +			0, &sc.tp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Repair magic: the caller thinks it owns the buffer that backs
> +	 * the inode.  The _iget call will want to grab the buffer to
> +	 * load the inode, so the buffer must be attached to the
> +	 * transaction.  Furthermore, the _iget call drops the buffer
> +	 * once the inode is loaded, so if we've made any changes we
> +	 * have to log those to the transaction so they get written...
> +	 */
> +	libxfs_trans_bjoin(sc.tp, *ino_bpp);
> +	if (*dirty) {
> +		libxfs_trans_log_buf(sc.tp, *ino_bpp, 0,
> +				XFS_BUF_SIZE(*ino_bpp));
> +		*dirty = 0;
> +	}
> +
> +	/* ...then rebuild the bmbt... */
> +	error = -libxfs_iget(mp, sc.tp, ino, 0, &sc.ip, &xfs_default_ifork_ops);
> +	if (error)
> +		goto out_trans;
> +	error = xrep_bmap(&sc, whichfork);
> +	if (error)
> +		goto out_trans;
> +
> +	/*
> +	 * ...and then regrab the same inode buffer so that we return to
> +	 * the caller with the inode buffer locked and the dino pointer
> +	 * up to date.  We bhold the buffer so that it doesn't get
> +	 * released during the transaction commit.
> +	 */
> +	error = -libxfs_imap_to_bp(mp, sc.tp, &sc.ip->i_imap, dinop, ino_bpp,
> +			0, 0);
> +	if (error)
> +		goto out_trans;
> +	libxfs_trans_bhold(sc.tp, *ino_bpp);
> +	error = -libxfs_trans_commit(sc.tp);
> +	libxfs_irele(sc.ip);
> +	return error;
> +out_trans:
> +	libxfs_trans_cancel(sc.tp);
> +	libxfs_irele(sc.ip);
> +	/* Try to regrab the old buffer so we don't lose it... */
> +	if (!libxfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, bp_bn, bp_length,
> +			0, &bp, NULL))
> +		*ino_bpp = bp;
> +	return error;
> +}
> diff --git a/repair/bmap_repair.h b/repair/bmap_repair.h
> new file mode 100644
> index 00000000..a92a8045
> --- /dev/null
> +++ b/repair/bmap_repair.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef REBUILD_H_
> +#define REBUILD_H_
> +
> +int rebuild_bmap(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
> +		 unsigned long nr_extents, struct xfs_buf **ino_bpp,
> +		 struct xfs_dinode **dinop, int *dirty);
> +
> +#endif /* REBUILD_H_ */
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8141b4ad..7731bd41 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -20,6 +20,7 @@
>   #include "threads.h"
>   #include "slab.h"
>   #include "rmap.h"
> +#include "bmap_repair.h"
>   
>   /*
>    * gettext lookups for translations of strings use mutexes internally to
> @@ -1938,7 +1939,9 @@ process_inode_data_fork(
>   	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
>   	int			err = 0;
>   	int			nex;
> +	bool			try_rebuild = !rmapbt_suspect;
>   
> +retry:
>   	/*
>   	 * extent count on disk is only valid for positive values. The kernel
>   	 * uses negative values in memory. hence if we see negative numbers
> @@ -1984,8 +1987,28 @@ process_inode_data_fork(
>   	if (err)  {
>   		do_warn(_("bad data fork in inode %" PRIu64 "\n"), lino);
>   		if (!no_modify)  {
> +			if (try_rebuild) {
> +				do_warn(
> +_("rebuilding inode %"PRIu64" data fork\n"),
> +					lino);
> +				try_rebuild = false;
> +				err = rebuild_bmap(mp, lino, XFS_DATA_FORK,
> +						be32_to_cpu(dino->di_nextents),
> +						ino_bpp, dinop, dirty);
> +				dino = *dinop;
> +				if (!err)
> +					goto retry;
> +				do_warn(
> +_("inode %"PRIu64" data fork rebuild failed, error %d, clearing\n"),
> +					lino, err);
> +			}
>   			clear_dinode(mp, dino, lino);
>   			*dirty += 1;
> +			ASSERT(*dirty > 0);
> +		} else if (try_rebuild) {
> +			do_warn(
> +_("would have tried to rebuild inode %"PRIu64" data fork\n"),
> +					lino);
>   		}
>   		return 1;
>   	}
> @@ -2051,7 +2074,9 @@ process_inode_attr_fork(
>   	struct blkmap		*ablkmap = NULL;
>   	int			repair = 0;
>   	int			err;
> +	bool			try_rebuild = !rmapbt_suspect;
>   
> +retry:
>   	if (!XFS_DFORK_Q(dino)) {
>   		*anextents = 0;
>   		if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS) {
> @@ -2110,11 +2135,30 @@ process_inode_attr_fork(
>   		do_warn(_("bad attribute fork in inode %" PRIu64 "\n"), lino);
>   
>   		if (!no_modify)  {
> +			if (try_rebuild) {
> +				try_rebuild = false;
> +				do_warn(
> +_("rebuilding inode %"PRIu64" attr fork\n"),
> +					lino);
> +				err = rebuild_bmap(mp, lino, XFS_ATTR_FORK,
> +						be32_to_cpu(dino->di_anextents),
> +						ino_bpp, dinop, dirty);
> +				dino = *dinop;
> +				if (!err)
> +					goto retry;
> +				do_warn(
> +_("inode %"PRIu64" attr fork rebuild failed, error %d"),
> +					lino, err);
> +			}
>   			do_warn(_(", clearing attr fork\n"));
>   			*dirty += clear_dinode_attr(mp, dino, lino);
>   			dino->di_aformat = XFS_DINODE_FMT_LOCAL;
>   			ASSERT(*dirty > 0);
> -		} else  {
> +		} else if (try_rebuild) {
> +			do_warn(
> +_("would have tried to rebuild inode %"PRIu64" attr fork or cleared it\n"),
> +					lino);
> +		} else {
>   			do_warn(_(", would clear attr fork\n"));
>   		}
>   
> diff --git a/repair/rmap.c b/repair/rmap.c
> index c4c99131..fcd28cce 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -33,7 +33,7 @@ struct xfs_ag_rmap {
>   };
>   
>   static struct xfs_ag_rmap *ag_rmaps;
> -static bool rmapbt_suspect;
> +bool rmapbt_suspect;
>   static bool refcbt_suspect;
>   
>   static inline int rmap_compare(const void *a, const void *b)
> diff --git a/repair/rmap.h b/repair/rmap.h
> index e5a6a3b4..e579e403 100644
> --- a/repair/rmap.h
> +++ b/repair/rmap.h
> @@ -7,6 +7,7 @@
>   #define RMAP_H_
>   
>   extern bool collect_rmaps;
> +extern bool rmapbt_suspect;
>   
>   extern bool rmap_needs_work(struct xfs_mount *);
>   
> 
