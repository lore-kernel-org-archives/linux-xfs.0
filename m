Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C3CC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33CB5205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gxBdtF9o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbgCPM3t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 08:29:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39516 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730634AbgCPM3t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 08:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584361788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yzgP1OKTCOTXdHtWUGCjxsLYlYKQnOL/WhmCX4AgZGs=;
        b=gxBdtF9oBv0QbwKZ/LT7C9pbhh0ENplndyZhbBtOp5bTWMOS5zORZRH/sZrzCt13zk+Bp2
        jiJBzDXsn2WrTT4E2KqkAbXzpOBsI5D3yUL2YU6hLDlCGQ67BdXxS5l1Ue4cN77veEvbl7
        U569gg75j9aVVAXaXEt2vc7wRh1LH9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-JxwbuyJ5O3GshGVwazV_2Q-1; Mon, 16 Mar 2020 08:29:45 -0400
X-MC-Unique: JxwbuyJ5O3GshGVwazV_2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37DF118B642C;
        Mon, 16 Mar 2020 12:29:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE7BA60BE2;
        Mon, 16 Mar 2020 12:29:43 +0000 (UTC)
Date:   Mon, 16 Mar 2020 08:29:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: add support for free space btree staging cursors
Message-ID: <20200316122942.GA12313@bfoster>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
 <158431626637.357791.7694218797816175496.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158431626637.357791.7694218797816175496.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 15, 2020 at 04:51:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add support for btree staging cursors for the free space btrees.  This
> is needed both for online repair and also to convert xfs_repair to use
> btree bulk loading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c |   98 +++++++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_alloc_btree.h |    7 +++
>  2 files changed, 86 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index a28041fdf4c0..93792ee7924e 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
...
> @@ -485,36 +520,61 @@ xfs_allocbt_init_cursor(
...
>  
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

Any reason this is set here and not at init time for the staging cursor?

Brian

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

