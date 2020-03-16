Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC63FC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0FDE205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:30:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5KlmEGg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbgCPMaM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 08:30:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55567 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730919AbgCPMaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 08:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584361810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ftJjO3UGMAbAkOIm165nDChgT2RButMPeOxYwsykH7A=;
        b=M5KlmEGgCYghGFT7C4pe/dp4pxZH+nKvfpSd+aWjCvNtbFqgUj6xGD1KsSeZGihTEnwSb/
        eb0OjH9Xlsy25KUdtr+oo3AmzPvANKW8DjCX4AnrO9lh4ox1SXZYmZB60GrQDIVSXygNJF
        WNAFqHYSkpRXQWb2FRhlN+X81K/KGP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-9ZaU-3JAPsm7lGpLNPfNlw-1; Mon, 16 Mar 2020 08:30:06 -0400
X-MC-Unique: 9ZaU-3JAPsm7lGpLNPfNlw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9DF0107ACCC;
        Mon, 16 Mar 2020 12:30:05 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 78EB460C05;
        Mon, 16 Mar 2020 12:30:05 +0000 (UTC)
Date:   Mon, 16 Mar 2020 08:30:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: add support for rmap btree staging cursors
Message-ID: <20200316123003.GD12313@bfoster>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
 <158431628657.357791.17569681185422084457.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158431628657.357791.17569681185422084457.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 15, 2020 at 04:51:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add support for btree staging cursors for the rmap btrees.  This is
> needed both for online repair and also to convert xfs_repair to use
> btree bulk loading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_rmap_btree.c |   67 ++++++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_rmap_btree.h |    5 +++
>  2 files changed, 62 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index af7e4966416f..b7c05314d07c 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -14,6 +14,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_alloc.h"
>  #include "xfs_btree.h"
> +#include "xfs_btree_staging.h"
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_trace.h"
> @@ -448,17 +449,12 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
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
> -	struct xfs_agf		*agf = agbp->b_addr;
>  	struct xfs_btree_cur	*cur;
>  
>  	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> @@ -468,16 +464,67 @@ xfs_rmapbt_init_cursor(
>  	cur->bc_btnum = XFS_BTNUM_RMAP;
>  	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> -	cur->bc_ops = &xfs_rmapbt_ops;
> -	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
> +	cur->bc_ag.agno = agno;
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
> +	struct xfs_agf		*agf = agbp->b_addr;
> +	struct xfs_btree_cur	*cur;
> +
> +	cur = xfs_rmapbt_init_common(mp, tp, agno);
> +	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
>  	cur->bc_ag.agbp = agbp;
> -	cur->bc_ag.agno = agno;
> +	return cur;
> +}
> +
> +/* Create a new reverse mapping btree cursor with a fake root for staging. */
> +struct xfs_btree_cur *
> +xfs_rmapbt_stage_cursor(
> +	struct xfs_mount	*mp,
> +	struct xbtree_afakeroot	*afake,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_btree_cur	*cur;
>  
> +	cur = xfs_rmapbt_init_common(mp, NULL, agno);
> +	xfs_btree_stage_afakeroot(cur, afake);
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
> +	agf->agf_rmap_blocks = cpu_to_be32(afake->af_blocks);
> +	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS |
> +				    XFS_AGF_RMAP_BLOCKS);
> +	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_rmapbt_ops);
> +}
> +
>  /*
>   * Calculate number of records in an rmap btree block.
>   */
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index 820d668b063d..115c3455a734 100644
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
> @@ -43,6 +44,10 @@ struct xfs_mount;
>  struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
>  				struct xfs_trans *tp, struct xfs_buf *bp,
>  				xfs_agnumber_t agno);
> +struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
> +		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
> +void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
> +		struct xfs_trans *tp, struct xfs_buf *agbp);
>  int xfs_rmapbt_maxrecs(int blocklen, int leaf);
>  extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
>  
> 

