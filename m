Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35675C18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 091DA205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MjCeypfE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbgCPMaD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 08:30:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28137 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730949AbgCPMaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 08:30:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584361801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7TymQwUs+pJgLygZSEC99XUvmmzBOEBYZ2Gf+8KbIG4=;
        b=MjCeypfE7wV/rGjlcq57Xnjsfm80ZkftqVx+vStOtJSSq99ufev+oWUn0rAJoORpWZxz/P
        jurJhABzp6qXAzr/XxrKzgCQJ7FNy/i+cAMqnjR36idTBwwGPSEwzDav8Kg1ikAI8xV0Xk
        QOdzLesDKTSoMGoBa8KqBmmvb3je2jo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-BY5sXIVcMAaISqZSWAcPHQ-1; Mon, 16 Mar 2020 08:29:59 -0400
X-MC-Unique: BY5sXIVcMAaISqZSWAcPHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D260618B644C;
        Mon, 16 Mar 2020 12:29:58 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 78BF592D41;
        Mon, 16 Mar 2020 12:29:58 +0000 (UTC)
Date:   Mon, 16 Mar 2020 08:29:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: add support for refcount btree staging cursors
Message-ID: <20200316122956.GC12313@bfoster>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
 <158431627922.357791.17944983780640632760.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158431627922.357791.17944983780640632760.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 15, 2020 at 04:51:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add support for btree staging cursors for the refcount btrees.  This
> is needed both for online repair and also to convert xfs_repair to use
> btree bulk loading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_refcount_btree.c |   70 +++++++++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_refcount_btree.h |    6 +++
>  2 files changed, 66 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index e07a2c45f8ec..7fd6044a4f78 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -12,6 +12,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
> +#include "xfs_btree_staging.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_alloc.h"
>  #include "xfs_error.h"
> @@ -311,41 +312,90 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
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
> -	struct xfs_agf		*agf = agbp->b_addr;
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
> -	cur->bc_ag.agbp = agbp;
>  	cur->bc_ag.agno = agno;
>  	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
>  	cur->bc_ag.refc.nr_ops = 0;
>  	cur->bc_ag.refc.shape_changes = 0;
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
> +	struct xfs_agf		*agf = agbp->b_addr;
> +	struct xfs_btree_cur	*cur;
> +
> +	cur = xfs_refcountbt_init_common(mp, tp, agno);
> +	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
> +	cur->bc_ag.agbp = agbp;
> +	return cur;
> +}
> +
> +/* Create a btree cursor with a fake root for staging. */
> +struct xfs_btree_cur *
> +xfs_refcountbt_stage_cursor(
> +	struct xfs_mount	*mp,
> +	struct xbtree_afakeroot	*afake,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_btree_cur	*cur;
>  
> +	cur = xfs_refcountbt_init_common(mp, NULL, agno);
> +	xfs_btree_stage_afakeroot(cur, afake);
>  	return cur;
>  }
>  
> +/*
> + * Swap in the new btree root.  Once we pass this point the newly rebuilt btree
> + * is in place and we have to kill off all the old btree blocks.
> + */
> +void
> +xfs_refcountbt_commit_staged_btree(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp)
> +{
> +	struct xfs_agf		*agf = agbp->b_addr;
> +	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	agf->agf_refcount_root = cpu_to_be32(afake->af_root);
> +	agf->agf_refcount_level = cpu_to_be32(afake->af_levels);
> +	agf->agf_refcount_blocks = cpu_to_be32(afake->af_blocks);
> +	xfs_alloc_log_agf(tp, agbp, XFS_AGF_REFCOUNT_BLOCKS |
> +				    XFS_AGF_REFCOUNT_ROOT |
> +				    XFS_AGF_REFCOUNT_LEVEL);
> +	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_refcountbt_ops);
> +}
> +
>  /*
>   * Calculate the number of records in a refcount btree block.
>   */
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index ba416f71c824..69dc515db671 100644
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
> @@ -46,6 +47,8 @@ struct xfs_mount;
>  extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
>  		struct xfs_trans *tp, struct xfs_buf *agbp,
>  		xfs_agnumber_t agno);
> +struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
> +		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
>  extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
>  extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
>  
> @@ -58,4 +61,7 @@ extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
>  		struct xfs_trans *tp, xfs_agnumber_t agno, xfs_extlen_t *ask,
>  		xfs_extlen_t *used);
>  
> +void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
> +		struct xfs_trans *tp, struct xfs_buf *agbp);
> +
>  #endif	/* __XFS_REFCOUNT_BTREE_H__ */
> 

