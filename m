Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB61C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 14:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DEF9205C9
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 14:31:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XLUnGw5K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgCEObC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 09:31:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52959 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbgCEObC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 09:31:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583418660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D2zu0OniNaK6nTp38M5m4BZEA3SHd5nOosXuWVdgdb8=;
        b=XLUnGw5Kdc3Rsem9jSHnROnDZhmRy7WMWq3+YK+OMmdTW5Pr3Wda9QNbjUVtZ57Su/Fb3w
        ZncifyhGb3HQilIbXmVdv1CJe252QC2O0mgdxIqkgdlF6bgXFaQmxS86iZmRji+2rMZt1I
        0vzIJO+D3gLgBmTYRFIinrBzFYR1p/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-pc2mK0CtNx-hyOBMkm8Lmw-1; Thu, 05 Mar 2020 09:30:57 -0500
X-MC-Unique: pc2mK0CtNx-hyOBMkm8Lmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06817190D343;
        Thu,  5 Mar 2020 14:30:57 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91BCE8F349;
        Thu,  5 Mar 2020 14:30:56 +0000 (UTC)
Date:   Thu, 5 Mar 2020 09:30:54 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: support staging cursors for per-AG btree types
Message-ID: <20200305143054.GC27418@bfoster>
References: <158329250190.2423432.16958662769192587982.stgit@magnolia>
 <158329252761.2423432.14412438594059561686.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158329252761.2423432.14412438594059561686.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 07:28:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add support for btree staging cursors for the per-AG btree types.  This
> is needed both for online repair and also to convert xfs_repair to use
> btree bulk loading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   99 +++++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_alloc_btree.h    |    7 +++
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   84 +++++++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_ialloc_btree.h   |    6 ++
>  fs/xfs/libxfs/xfs_refcount_btree.c |   69 +++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_refcount_btree.h |    7 +++
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   66 ++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_rmap_btree.h     |    6 ++
>  8 files changed, 295 insertions(+), 49 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 279694d73e4e..94dc18c8f9bc 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -471,6 +471,41 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
>  	.recs_inorder		= xfs_cntbt_recs_inorder,
>  };
>  
> +/* Allocate most of a new allocation btree cursor. */
> +STATIC struct xfs_btree_cur *
> +xfs_allocbt_init_common(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	xfs_btnum_t		btnum)
> +{

Separate refactoring patches please.

> +	struct xfs_btree_cur	*cur;
> +
> +	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
> +
> +	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +
> +	cur->bc_tp = tp;
> +	cur->bc_mp = mp;
> +	cur->bc_btnum = btnum;
> +	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> +	cur->bc_private.a.agno = agno;
> +	cur->bc_private.a.priv.abt.active = false;
> +
> +	if (btnum == XFS_BTNUM_CNT) {
> +		cur->bc_ops = &xfs_cntbt_ops;
> +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
> +	} else {
> +		cur->bc_ops = &xfs_bnobt_ops;
> +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
> +	}
> +
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> +
> +	return cur;
> +}
> +
>  /*
>   * Allocate a new allocation btree cursor.
>   */
> @@ -485,36 +520,64 @@ xfs_allocbt_init_cursor(
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	struct xfs_btree_cur	*cur;
>  
> -	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
> -
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> -
> -	cur->bc_tp = tp;
> -	cur->bc_mp = mp;
> -	cur->bc_btnum = btnum;
> -	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> -
> +	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
>  	if (btnum == XFS_BTNUM_CNT) {
> -		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
> -		cur->bc_ops = &xfs_cntbt_ops;
>  		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
> -		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
> +		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
>  	} else {
> -		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
> -		cur->bc_ops = &xfs_bnobt_ops;
>  		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
>  	}
>  
>  	cur->bc_private.a.agbp = agbp;
> -	cur->bc_private.a.agno = agno;
> -	cur->bc_private.a.priv.abt.active = false;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> +	return cur;
> +}
>  
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
> +
> +	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
> +	if (btnum == XFS_BTNUM_BNO)
> +		xfs_btree_stage_afakeroot(cur, afake, NULL);
> +	else
> +		xfs_btree_stage_afakeroot(cur, afake, NULL);

Looks like the same function call in either case..? I think I saw that
in one or two other spots glancing through the rest as well, btw.

Otherwise the rest looks mostly boilerplate. I'd just repeat the same
comment as above with regard to separating out refactoring. I also think
an enablement patch per btree implementation might be preferable to
enabling a bunch of trees in one patch.

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
> index b82992f795aa..15d8ec692a6e 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -400,32 +400,27 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
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
>  	if (btnum == XFS_BTNUM_INO) {
> -		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
> -		cur->bc_ops = &xfs_inobt_ops;
>  		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
> +		cur->bc_ops = &xfs_inobt_ops;
>  	} else {
> -		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
> -		cur->bc_ops = &xfs_finobt_ops;
>  		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
> +		cur->bc_ops = &xfs_finobt_ops;
>  	}
>  
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> @@ -433,12 +428,79 @@ xfs_inobt_init_cursor(
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
> +	if (btnum == XFS_BTNUM_INO)
> +		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
> +	else
> +		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
> +	cur->bc_private.a.agbp = agbp;
>  	return cur;
>  }
>  
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
> +
> +	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
> +	if (btnum == XFS_BTNUM_INO)
> +		xfs_btree_stage_afakeroot(cur, afake, NULL);
> +	else
> +		xfs_btree_stage_afakeroot(cur, afake, NULL);
> +	return cur;
> +}
> +
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
> index 38529dbacd55..9034b40bd5cf 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -311,41 +311,90 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
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
> +	cur->bc_ops = &xfs_refcountbt_ops;
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
> +
> +	cur = xfs_refcountbt_init_common(mp, tp, agno);
> +	xfs_btree_stage_afakeroot(cur, afake, NULL);
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
> index fc78efa52c94..062aeaaa7a8c 100644
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
> @@ -468,16 +463,67 @@ xfs_rmapbt_init_cursor(
>  	cur->bc_btnum = XFS_BTNUM_RMAP;
>  	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> -	cur->bc_ops = &xfs_rmapbt_ops;
> -	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
> +	cur->bc_private.a.agno = agno;
> +	cur->bc_ops = &xfs_rmapbt_ops;
>  
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
> +
> +	cur = xfs_rmapbt_init_common(mp, tp, agno);
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
>  
> +	cur = xfs_rmapbt_init_common(mp, tp, agno);
> +	xfs_btree_stage_afakeroot(cur, afake, NULL);
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

