Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1024C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF37205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PJsxmsiQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbgCPM34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 08:29:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54932 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730951AbgCPM34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 08:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584361794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dsc8M45kEuuuGo9r7G2EUrpRqXMGCZD7e7ghtBV1Pmc=;
        b=PJsxmsiQ1F9jmVg6r8ltO4nbcJtDhQs+wu4KJp3WKWpgi4oqPkfmvsfHXBMkmig9/aDVBW
        PNGI6XSb85kd9b4a0VhMtCn0KH4jIax+7Gw2bo1+WXRhyuuaaoFSco4DEIwlszw1QwQqnt
        bmS4sUuVH/Gyb0ODiSZczCpw4m1vwsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-25wZ9ZHqNJmYqi67Duy1pw-1; Mon, 16 Mar 2020 08:29:53 -0400
X-MC-Unique: 25wZ9ZHqNJmYqi67Duy1pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7C7518B642C;
        Mon, 16 Mar 2020 12:29:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CB397A411;
        Mon, 16 Mar 2020 12:29:51 +0000 (UTC)
Date:   Mon, 16 Mar 2020 08:29:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: add support for inode btree staging cursors
Message-ID: <20200316122949.GB12313@bfoster>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
 <158431627281.357791.17656125974474219701.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158431627281.357791.17656125974474219701.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 15, 2020 at 04:51:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add support for btree staging cursors for the inode btrees.  This
> is needed both for online repair and also to convert xfs_repair to use
> btree bulk loading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ialloc_btree.c |   82 ++++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_ialloc_btree.h |    6 +++
>  2 files changed, 76 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index e0e8570af023..b2c122ad8f0e 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -12,6 +12,7 @@
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
> +#include "xfs_btree_staging.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_ialloc_btree.h"
>  #include "xfs_alloc.h"
> @@ -20,7 +21,6 @@
>  #include "xfs_trans.h"
>  #include "xfs_rmap.h"
>  
> -
>  STATIC int
>  xfs_inobt_get_minrecs(
>  	struct xfs_btree_cur	*cur,
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
> -	struct xfs_agi		*agi = agbp->b_addr;
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
> @@ -433,12 +428,75 @@ xfs_inobt_init_cursor(
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
> -	cur->bc_ag.agbp = agbp;
>  	cur->bc_ag.agno = agno;
> +	return cur;
> +}
> +
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
> +	struct xfs_agi		*agi = agbp->b_addr;
> +
> +	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
> +	if (btnum == XFS_BTNUM_INO)
> +		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
> +	else
> +		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
> +	cur->bc_ag.agbp = agbp;
> +	return cur;
> +}
>  
> +/* Create an inode btree cursor with a fake root for staging. */
> +struct xfs_btree_cur *
> +xfs_inobt_stage_cursor(
> +	struct xfs_mount	*mp,
> +	struct xbtree_afakeroot	*afake,
> +	xfs_agnumber_t		agno,
> +	xfs_btnum_t		btnum)
> +{
> +	struct xfs_btree_cur	*cur;
> +
> +	cur = xfs_inobt_init_common(mp, NULL, agno, btnum);
> +	xfs_btree_stage_afakeroot(cur, afake);
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
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp)
> +{
> +	struct xfs_agi		*agi = agbp->b_addr;
> +	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	if (cur->bc_btnum == XFS_BTNUM_INO) {
> +		agi->agi_root = cpu_to_be32(afake->af_root);
> +		agi->agi_level = cpu_to_be32(afake->af_levels);
> +		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
> +		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
> +	} else {
> +		agi->agi_free_root = cpu_to_be32(afake->af_root);
> +		agi->agi_free_level = cpu_to_be32(afake->af_levels);
> +		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREE_ROOT |
> +					     XFS_AGI_FREE_LEVEL);
> +		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
> +	}
> +}
> +
>  /*
>   * Calculate number of records in an inobt btree block.
>   */
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> index 951305ecaae1..35bbd978c272 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> @@ -48,6 +48,9 @@ struct xfs_mount;
>  extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
>  		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
>  		xfs_btnum_t);
> +struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
> +		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
> +		xfs_btnum_t btnum);
>  extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
>  
>  /* ir_holemask to inode allocation bitmap conversion */
> @@ -68,4 +71,7 @@ int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agnumber_t agno, xfs_btnum_t btnum,
>  		struct xfs_btree_cur **curpp, struct xfs_buf **agi_bpp);
>  
> +void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
> +		struct xfs_trans *tp, struct xfs_buf *agbp);
> +
>  #endif	/* __XFS_IALLOC_BTREE_H__ */
> 

