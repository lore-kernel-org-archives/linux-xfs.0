Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C426FA372A
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 15:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 479B62067D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 15:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404922AbfJPP2Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389169AbfJPP2Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Oct 2019 11:28:16 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 059EF89B003;
        Wed, 16 Oct 2019 15:28:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E0355D6A9;
        Wed, 16 Oct 2019 15:28:15 +0000 (UTC)
Date:   Wed, 16 Oct 2019 11:28:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: support staging cursors for per-AG btree types
Message-ID: <20191016152813.GD41077@bfoster>
References: <157063967800.2912204.4012307770844087647.stgit@magnolia>
 <157063970787.2912204.1368617790977060209.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157063970787.2912204.1368617790977060209.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Wed, 16 Oct 2019 15:28:16 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:48:27AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add support for btree staging cursors for the per-AG btree types.  This
> is needed both for online repair and also to convert xfs_repair to use
> btree bulk loading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   93 ++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_alloc_btree.h    |    7 +++
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   91 ++++++++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_ialloc_btree.h   |    6 ++
>  fs/xfs/libxfs/xfs_refcount_btree.c |   70 +++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_refcount_btree.h |    7 +++
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   67 ++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_rmap_btree.h     |    6 ++
>  8 files changed, 298 insertions(+), 49 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 2a94543857a1..c1b03f67afa0 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
...
> @@ -485,35 +516,67 @@ xfs_allocbt_init_cursor(
...
> +/* Create a free space btree cursor with a fake root for staging. */
> +struct xfs_btree_cur *
> +xfs_allocbt_stage_cursor(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xbtree_afakeroot	*afake,
> +	xfs_agnumber_t		agno,
> +	xfs_btnum_t		btnum)
> +{
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_btree_ops	*ops;
>  
> +	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
> +	if (btnum == XFS_BTNUM_BNO)
> +		xfs_btree_stage_afakeroot(cur, afake, &xfs_bnobt_ops, &ops);
> +	else
> +		xfs_btree_stage_afakeroot(cur, afake, &xfs_cntbt_ops, &ops);

FWIW, to this point it doesn't look like any caller of the above
function uses the ops output.

Also, any reason the original ->bc_ops can't be assigned by the common
init function and just copied/replaced by the staging helper (similar to
how the commit path frees and replaces the staging ops)?

Brian

>  	return cur;
>  }
>  
> +/*
> + * Install a new free space btree root.  Caller is responsible for invalidating
> + * and freeing the old btree blocks.
> + */
> +void
> +xfs_allocbt_commit_staged_btree(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_buf		*agbp)
> +{
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> +	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
> +	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
> +	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
> +
> +	if (cur->bc_btnum == XFS_BTNUM_BNO) {
> +		xfs_btree_commit_afakeroot(cur, agbp, &xfs_bnobt_ops);
> +	} else {
> +		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
> +		xfs_btree_commit_afakeroot(cur, agbp, &xfs_cntbt_ops);
> +	}
> +}
> +
>  /*
>   * Calculate number of records in an alloc btree block.
>   */
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
> index c9305ebb69f6..dde324609a89 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.h
> @@ -13,6 +13,7 @@
>  struct xfs_buf;
>  struct xfs_btree_cur;
>  struct xfs_mount;
> +struct xbtree_afakeroot;
>  
>  /*
>   * Btree block header size depends on a superblock flag.
> @@ -48,8 +49,14 @@ struct xfs_mount;
>  extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
>  		struct xfs_trans *, struct xfs_buf *,
>  		xfs_agnumber_t, xfs_btnum_t);
> +struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
> +		struct xfs_trans *tp, struct xbtree_afakeroot *afake,
> +		xfs_agnumber_t agno, xfs_btnum_t btnum);
>  extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
>  extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
>  		unsigned long long len);
>  
> +void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
> +		struct xfs_buf *agbp);
> +
>  #endif	/* __XFS_ALLOC_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index b82992f795aa..f61d94daa0a1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -400,45 +400,108 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
>  };
>  
>  /*
> - * Allocate a new inode btree cursor.
> + * Initialize a new inode btree cursor.
>   */
> -struct xfs_btree_cur *				/* new inode btree cursor */
> -xfs_inobt_init_cursor(
> +static struct xfs_btree_cur *
> +xfs_inobt_init_common(
>  	struct xfs_mount	*mp,		/* file system mount point */
>  	struct xfs_trans	*tp,		/* transaction pointer */
> -	struct xfs_buf		*agbp,		/* buffer for agi structure */
>  	xfs_agnumber_t		agno,		/* allocation group number */
>  	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
>  {
> -	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
>  	struct xfs_btree_cur	*cur;
>  
>  	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> -
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = btnum;
> -	if (btnum == XFS_BTNUM_INO) {
> -		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
> -		cur->bc_ops = &xfs_inobt_ops;
> +	if (btnum == XFS_BTNUM_INO)
>  		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
> -	} else {
> -		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
> -		cur->bc_ops = &xfs_finobt_ops;
> +	else
>  		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
> -	}
>  
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
> -	cur->bc_private.a.agbp = agbp;
>  	cur->bc_private.a.agno = agno;
> +	return cur;
> +}
>  
> +/* Create an inode btree cursor. */
> +struct xfs_btree_cur *
> +xfs_inobt_init_cursor(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agnumber_t		agno,
> +	xfs_btnum_t		btnum)
> +{
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> +
> +	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
> +	if (btnum == XFS_BTNUM_INO) {
> +		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
> +		cur->bc_ops = &xfs_inobt_ops;
> +	} else {
> +		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
> +		cur->bc_ops = &xfs_finobt_ops;
> +	}
> +	cur->bc_private.a.agbp = agbp;
> +	return cur;
> +}
> +
> +/* Create an inode btree cursor with a fake root for staging. */
> +struct xfs_btree_cur *
> +xfs_inobt_stage_cursor(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xbtree_afakeroot	*afake,
> +	xfs_agnumber_t		agno,
> +	xfs_btnum_t		btnum)
> +{
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_btree_ops	*ops;
> +
> +	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
> +	if (btnum == XFS_BTNUM_INO)
> +		xfs_btree_stage_afakeroot(cur, afake, &xfs_inobt_ops, &ops);
> +	else
> +		xfs_btree_stage_afakeroot(cur, afake, &xfs_finobt_ops, &ops);
>  	return cur;
>  }
>  
> +/*
> + * Install a new inobt btree root.  Caller is responsible for invalidating
> + * and freeing the old btree blocks.
> + */
> +void
> +xfs_inobt_commit_staged_btree(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_buf		*agbp)
> +{
> +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> +	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	if (cur->bc_btnum == XFS_BTNUM_INO) {
> +		agi->agi_root = cpu_to_be32(afake->af_root);
> +		agi->agi_level = cpu_to_be32(afake->af_levels);
> +		xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT |
> +						     XFS_AGI_LEVEL);
> +		xfs_btree_commit_afakeroot(cur, agbp, &xfs_inobt_ops);
> +	} else {
> +		agi->agi_free_root = cpu_to_be32(afake->af_root);
> +		agi->agi_free_level = cpu_to_be32(afake->af_levels);
> +		xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_FREE_ROOT |
> +						     XFS_AGI_FREE_LEVEL);
> +		xfs_btree_commit_afakeroot(cur, agbp, &xfs_finobt_ops);
> +	}
> +}
> +
>  /*
>   * Calculate number of records in an inobt btree block.
>   */
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> index 951305ecaae1..9265b3e08c69 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> @@ -48,6 +48,9 @@ struct xfs_mount;
>  extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
>  		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
>  		xfs_btnum_t);
> +struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
> +		struct xfs_trans *tp, struct xbtree_afakeroot *afake,
> +		xfs_agnumber_t agno, xfs_btnum_t btnum);
>  extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
>  
>  /* ir_holemask to inode allocation bitmap conversion */
> @@ -68,4 +71,7 @@ int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agnumber_t agno, xfs_btnum_t btnum,
>  		struct xfs_btree_cur **curpp, struct xfs_buf **agi_bpp);
>  
> +void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
> +		struct xfs_buf *agbp);
> +
>  #endif	/* __XFS_IALLOC_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 38529dbacd55..8bf6aeee8f92 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -311,41 +311,91 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
>  };
>  
>  /*
> - * Allocate a new refcount btree cursor.
> + * Initialize a new refcount btree cursor.
>   */
> -struct xfs_btree_cur *
> -xfs_refcountbt_init_cursor(
> +static struct xfs_btree_cur *
> +xfs_refcountbt_init_common(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	struct xfs_buf		*agbp,
>  	xfs_agnumber_t		agno)
>  {
> -	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	struct xfs_btree_cur	*cur;
>  
>  	ASSERT(agno != NULLAGNUMBER);
>  	ASSERT(agno < mp->m_sb.sb_agcount);
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
>  
> +	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = XFS_BTNUM_REFC;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> -	cur->bc_ops = &xfs_refcountbt_ops;
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
>  
> -	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
> -
> -	cur->bc_private.a.agbp = agbp;
>  	cur->bc_private.a.agno = agno;
>  	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
>  	cur->bc_private.a.priv.refc.nr_ops = 0;
>  	cur->bc_private.a.priv.refc.shape_changes = 0;
> +	return cur;
> +}
> +
> +/* Create a btree cursor. */
> +struct xfs_btree_cur *
> +xfs_refcountbt_init_cursor(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> +	struct xfs_btree_cur	*cur;
>  
> +	cur = xfs_refcountbt_init_common(mp, tp, agno);
> +	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
> +	cur->bc_private.a.agbp = agbp;
> +	cur->bc_ops = &xfs_refcountbt_ops;
>  	return cur;
>  }
>  
> +/* Create a btree cursor with a fake root for staging. */
> +struct xfs_btree_cur *
> +xfs_refcountbt_stage_cursor(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xbtree_afakeroot	*afake,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_btree_ops	*ops;
> +
> +	cur = xfs_refcountbt_init_common(mp, tp, agno);
> +	xfs_btree_stage_afakeroot(cur, afake, &xfs_refcountbt_ops, &ops);
> +	return cur;
> +}
> +
> +/*
> + * Swap in the new btree root.  Once we pass this point the newly rebuilt btree
> + * is in place and we have to kill off all the old btree blocks.
> + */
> +void
> +xfs_refcountbt_commit_staged_btree(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_buf		*agbp)
> +{
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> +	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	agf->agf_refcount_root = cpu_to_be32(afake->af_root);
> +	agf->agf_refcount_level = cpu_to_be32(afake->af_levels);
> +	agf->agf_refcount_blocks = cpu_to_be32(afake->af_blocks);
> +	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS |
> +					    XFS_AGF_REFCOUNT_ROOT |
> +					    XFS_AGF_REFCOUNT_LEVEL);
> +	xfs_btree_commit_afakeroot(cur, agbp, &xfs_refcountbt_ops);
> +}
> +
>  /*
>   * Calculate the number of records in a refcount btree block.
>   */
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index ba416f71c824..978b714be9f4 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> @@ -13,6 +13,7 @@
>  struct xfs_buf;
>  struct xfs_btree_cur;
>  struct xfs_mount;
> +struct xbtree_afakeroot;
>  
>  /*
>   * Btree block header size
> @@ -46,6 +47,9 @@ struct xfs_mount;
>  extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
>  		struct xfs_trans *tp, struct xfs_buf *agbp,
>  		xfs_agnumber_t agno);
> +struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
> +		struct xfs_trans *tp, struct xbtree_afakeroot *afake,
> +		xfs_agnumber_t agno);
>  extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
>  extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
>  
> @@ -58,4 +62,7 @@ extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
>  		struct xfs_trans *tp, xfs_agnumber_t agno, xfs_extlen_t *ask,
>  		xfs_extlen_t *used);
>  
> +void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
> +		struct xfs_buf *agbp);
> +
>  #endif	/* __XFS_REFCOUNT_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index fc78efa52c94..8e05576dcaa1 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -448,17 +448,12 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
>  	.recs_inorder		= xfs_rmapbt_recs_inorder,
>  };
>  
> -/*
> - * Allocate a new allocation btree cursor.
> - */
> -struct xfs_btree_cur *
> -xfs_rmapbt_init_cursor(
> +static struct xfs_btree_cur *
> +xfs_rmapbt_init_common(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	struct xfs_buf		*agbp,
>  	xfs_agnumber_t		agno)
>  {
> -	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	struct xfs_btree_cur	*cur;
>  
>  	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> @@ -468,16 +463,68 @@ xfs_rmapbt_init_cursor(
>  	cur->bc_btnum = XFS_BTNUM_RMAP;
>  	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> -	cur->bc_ops = &xfs_rmapbt_ops;
> -	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
> +	cur->bc_private.a.agno = agno;
> +
> +	return cur;
> +}
> +
> +/* Create a new reverse mapping btree cursor. */
> +struct xfs_btree_cur *
> +xfs_rmapbt_init_cursor(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> +	struct xfs_btree_cur	*cur;
>  
> +	cur = xfs_rmapbt_init_common(mp, tp, agno);
> +	cur->bc_ops = &xfs_rmapbt_ops;
> +	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
>  	cur->bc_private.a.agbp = agbp;
> -	cur->bc_private.a.agno = agno;
> +	return cur;
> +}
> +
> +/* Create a new reverse mapping btree cursor with a fake root for staging. */
> +struct xfs_btree_cur *
> +xfs_rmapbt_stage_cursor(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xbtree_afakeroot	*afake,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_btree_ops	*ops;
>  
> +	cur = xfs_rmapbt_init_common(mp, tp, agno);
> +	xfs_btree_stage_afakeroot(cur, afake, &xfs_rmapbt_ops, &ops);
>  	return cur;
>  }
>  
> +/*
> + * Install a new reverse mapping btree root.  Caller is responsible for
> + * invalidating and freeing the old btree blocks.
> + */
> +void
> +xfs_rmapbt_commit_staged_btree(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_buf		*agbp)
> +{
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> +	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
> +	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
> +	agf->agf_rmap_blocks = cpu_to_be32(afake->af_blocks);
> +	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS |
> +					    XFS_AGF_RMAP_BLOCKS);
> +	xfs_btree_commit_afakeroot(cur, agbp, &xfs_rmapbt_ops);
> +}
> +
>  /*
>   * Calculate number of records in an rmap btree block.
>   */
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index 820d668b063d..c6785c7851a8 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -9,6 +9,7 @@
>  struct xfs_buf;
>  struct xfs_btree_cur;
>  struct xfs_mount;
> +struct xbtree_afakeroot;
>  
>  /* rmaps only exist on crc enabled filesystems */
>  #define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
> @@ -43,6 +44,11 @@ struct xfs_mount;
>  struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
>  				struct xfs_trans *tp, struct xfs_buf *bp,
>  				xfs_agnumber_t agno);
> +struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
> +		struct xfs_trans *tp, struct xbtree_afakeroot *afake,
> +		xfs_agnumber_t agno);
> +void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
> +		struct xfs_buf *agbp);
>  int xfs_rmapbt_maxrecs(int blocklen, int leaf);
>  extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
>  
> 
