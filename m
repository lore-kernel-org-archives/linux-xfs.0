Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3D0C18E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 11:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EC802051A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 11:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ctuOEi2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgCQLhi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 07:37:38 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:27991 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgCQLhi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 07:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584445056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x1oQdEvJpe3rbu4wvvU4aq0EZ7uSZKo1a6a6Qh4T4g4=;
        b=ctuOEi2rDU7fxmh6GYUh4LxMh8fHXh5N7wH0cug7hxnt1QczsRLVXd7KblkRclSP3aDeBC
        zb/RhDICv/8+l40yfR/jCOxXyc2CUb5+wD1k+775SwegIy0sooFceME+DJcgTAAtfEds1c
        rHvS0f9lZ/d795Qu0/9uqLv+VLseu78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-i4PrfKbvPc21oFsFB4bcyQ-1; Tue, 17 Mar 2020 07:37:34 -0400
X-MC-Unique: i4PrfKbvPc21oFsFB4bcyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E93A801FA7;
        Tue, 17 Mar 2020 11:37:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A58AD60BF3;
        Tue, 17 Mar 2020 11:37:23 +0000 (UTC)
Date:   Tue, 17 Mar 2020 07:37:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/7] xfs: add support for free space btree staging
 cursors
Message-ID: <20200317113721.GA22894@bfoster>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
 <158431626637.357791.7694218797816175496.stgit@magnolia>
 <20200316193541.GF256767@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316193541.GF256767@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 12:35:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add support for btree staging cursors for the free space btrees.  This
> is needed both for online repair and also to convert xfs_repair to use
> btree bulk loading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: leave the LASTREC_UPDATE flag setting alone
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc_btree.c |   93 ++++++++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_alloc_btree.h |    7 +++
>  2 files changed, 84 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index a28041fdf4c0..60c453cb3ee3 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -12,6 +12,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
> +#include "xfs_btree_staging.h"
>  #include "xfs_alloc_btree.h"
>  #include "xfs_alloc.h"
>  #include "xfs_extent_busy.h"
> @@ -471,18 +472,14 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
>  	.recs_inorder		= xfs_cntbt_recs_inorder,
>  };
>  
> -/*
> - * Allocate a new allocation btree cursor.
> - */
> -struct xfs_btree_cur *			/* new alloc btree cursor */
> -xfs_allocbt_init_cursor(
> -	struct xfs_mount	*mp,		/* file system mount point */
> -	struct xfs_trans	*tp,		/* transaction pointer */
> -	struct xfs_buf		*agbp,		/* buffer for agf structure */
> -	xfs_agnumber_t		agno,		/* allocation group number */
> -	xfs_btnum_t		btnum)		/* btree identifier */
> +/* Allocate most of a new allocation btree cursor. */
> +STATIC struct xfs_btree_cur *
> +xfs_allocbt_init_common(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	xfs_btnum_t		btnum)
>  {
> -	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_btree_cur	*cur;
>  
>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
> @@ -495,17 +492,14 @@ xfs_allocbt_init_cursor(
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
>  
>  	if (btnum == XFS_BTNUM_CNT) {
> -		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
>  		cur->bc_ops = &xfs_cntbt_ops;
> -		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
> +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
>  		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
>  	} else {
> -		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
>  		cur->bc_ops = &xfs_bnobt_ops;
> -		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
> +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
>  	}
>  
> -	cur->bc_ag.agbp = agbp;
>  	cur->bc_ag.agno = agno;
>  	cur->bc_ag.abt.active = false;
>  
> @@ -515,6 +509,73 @@ xfs_allocbt_init_cursor(
>  	return cur;
>  }
>  
> +/*
> + * Allocate a new allocation btree cursor.
> + */
> +struct xfs_btree_cur *			/* new alloc btree cursor */
> +xfs_allocbt_init_cursor(
> +	struct xfs_mount	*mp,		/* file system mount point */
> +	struct xfs_trans	*tp,		/* transaction pointer */
> +	struct xfs_buf		*agbp,		/* buffer for agf structure */
> +	xfs_agnumber_t		agno,		/* allocation group number */
> +	xfs_btnum_t		btnum)		/* btree identifier */
> +{
> +	struct xfs_agf		*agf = agbp->b_addr;
> +	struct xfs_btree_cur	*cur;
> +
> +	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
> +	if (btnum == XFS_BTNUM_CNT)
> +		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
> +	else
> +		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
> +
> +	cur->bc_ag.agbp = agbp;
> +
> +	return cur;
> +}
> +
> +/* Create a free space btree cursor with a fake root for staging. */
> +struct xfs_btree_cur *
> +xfs_allocbt_stage_cursor(
> +	struct xfs_mount	*mp,
> +	struct xbtree_afakeroot	*afake,
> +	xfs_agnumber_t		agno,
> +	xfs_btnum_t		btnum)
> +{
> +	struct xfs_btree_cur	*cur;
> +
> +	cur = xfs_allocbt_init_common(mp, NULL, agno, btnum);
> +	xfs_btree_stage_afakeroot(cur, afake);
> +	return cur;
> +}
> +
> +/*
> + * Install a new free space btree root.  Caller is responsible for invalidating
> + * and freeing the old btree blocks.
> + */
> +void
> +xfs_allocbt_commit_staged_btree(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp)
> +{
> +	struct xfs_agf		*agf = agbp->b_addr;
> +	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
> +	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
> +	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
> +
> +	if (cur->bc_btnum == XFS_BTNUM_BNO) {
> +		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_bnobt_ops);
> +	} else {
> +		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
> +		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_cntbt_ops);
> +	}
> +}
> +
>  /*
>   * Calculate number of records in an alloc btree block.
>   */
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
> index c9305ebb69f6..047f09f0be3c 100644
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
> +		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
> +		xfs_btnum_t btnum);
>  extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
>  extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
>  		unsigned long long len);
>  
> +void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
> +		struct xfs_trans *tp, struct xfs_buf *agbp);
> +
>  #endif	/* __XFS_ALLOC_BTREE_H__ */
> 

