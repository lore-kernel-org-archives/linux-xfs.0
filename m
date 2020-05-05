Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5A7C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 14:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD5132073B
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 14:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XdlMGnT4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgEEOLu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 10:11:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54905 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727857AbgEEOLu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 10:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588687906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ykJo/xcYZHgKYXRosI/v2AxHguK/RFl/7PBSFi2snpg=;
        b=XdlMGnT4Q4X0RzvoeafJA2OlsmLUXQwYr2kgeP1hi+ccbm+XbPvVYJElpDZpQ9lMqBtyS3
        J3hJ99Aj+J/s7H/yK4n5EHJ0IPodYDwXh3sZVJB0zv9E/qhZUJHLkS1PHs7OcCTUDIgyYR
        fZJVnnAcgsWUcqf/7qhcCN0yQKWIzUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-SH76wt4FM4Odbg3CRG7bng-1; Tue, 05 May 2020 10:11:42 -0400
X-MC-Unique: SH76wt4FM4Odbg3CRG7bng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 400C51800D4A;
        Tue,  5 May 2020 14:11:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C297A60BEC;
        Tue,  5 May 2020 14:11:40 +0000 (UTC)
Date:   Tue, 5 May 2020 10:11:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20200505141138.GB61176@bfoster>
References: <158864121286.184729.5959003885146573075.stgit@magnolia>
 <158864123329.184729.14504239314355330619.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864123329.184729.14504239314355330619.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:13:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_bui_item_recover, there exists a use-after-free bug with regards
> to the inode that is involved in the bmap replay operation.  If the
> mapping operation does not complete, we call xfs_bmap_unmap_extent to
> create a deferred op to finish the unmapping work, and we retain a
> pointer to the incore inode.
> 
> Unfortunately, the very next thing we do is commit the transaction and
> drop the inode.  If reclaim tears down the inode before we try to finish
> the defer ops, we dereference garbage and blow up.  Therefore, create a
> way to join inodes to the defer ops freezer so that we can maintain the
> xfs_inode reference until we're done with the inode.
> 
> Note: This imposes the requirement that there be enough memory to keep
> every incore inode in memory throughout recovery.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Maybe I'm missing something, but I thought the discussion on the
previous version[1] landed on an approach where the intent would hold a
reference to the inode. Wouldn't that break the dependency on the dfops
freeze/thaw mechanism?

Brian

[1] https://lore.kernel.org/linux-xfs/20200429235818.GX6742@magnolia/

>  fs/xfs/libxfs/xfs_defer.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_defer.h |   10 +++++++++
>  fs/xfs/xfs_bmap_item.c    |    7 ++++--
>  fs/xfs/xfs_icache.c       |   19 +++++++++++++++++
>  4 files changed, 83 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index ea4d28851bbd..72933fdafcb2 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -16,6 +16,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_trace.h"
> +#include "xfs_icache.h"
>  
>  /*
>   * Deferred Operations in XFS
> @@ -583,8 +584,19 @@ xfs_defer_thaw(
>  	struct xfs_defer_freezer	*dff,
>  	struct xfs_trans		*tp)
>  {
> +	int				i;
> +
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
> +	/* Re-acquire the inode locks. */
> +	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
> +		if (!dff->dff_inodes[i])
> +			break;
> +
> +		dff->dff_ilocks[i] = XFS_ILOCK_EXCL;
> +		xfs_ilock(dff->dff_inodes[i], dff->dff_ilocks[i]);
> +	}
> +
>  	/* Add the dfops items to the transaction. */
>  	list_splice_init(&dff->dff_dfops, &tp->t_dfops);
>  	tp->t_flags |= dff->dff_tpflags;
> @@ -597,5 +609,43 @@ xfs_defer_freeezer_finish(
>  	struct xfs_defer_freezer	*dff)
>  {
>  	xfs_defer_cancel_list(mp, &dff->dff_dfops);
> +	xfs_defer_freezer_irele(dff);
>  	kmem_free(dff);
>  }
> +
> +/*
> + * Attach an inode to this deferred ops freezer.  Callers must hold ILOCK_EXCL,
> + * which will be dropped and reacquired when we're ready to thaw the frozen
> + * deferred ops.
> + */
> +int
> +xfs_defer_freezer_ijoin(
> +	struct xfs_defer_freezer	*dff,
> +	struct xfs_inode		*ip)
> +{
> +	unsigned int			i;
> +
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +
> +	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
> +		if (dff->dff_inodes[i] == ip)
> +			goto out;
> +		if (dff->dff_inodes[i] == NULL)
> +			break;
> +	}
> +
> +	if (i == XFS_DEFER_FREEZER_INODES) {
> +		ASSERT(0);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	/*
> +	 * Attach this inode to the freezer and drop its ILOCK because we
> +	 * assume the caller will need to allocate a transaction.
> +	 */
> +	dff->dff_inodes[i] = ip;
> +	dff->dff_ilocks[i] = 0;
> +out:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 7ae05e10d750..0052a0313283 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -76,6 +76,11 @@ struct xfs_defer_freezer {
>  	/* Deferred ops state saved from the transaction. */
>  	struct list_head	dff_dfops;
>  	unsigned int		dff_tpflags;
> +
> +	/* Inodes to hold when we want to finish the deferred work items. */
> +#define XFS_DEFER_FREEZER_INODES	2
> +	unsigned int		dff_ilocks[XFS_DEFER_FREEZER_INODES];
> +	struct xfs_inode	*dff_inodes[XFS_DEFER_FREEZER_INODES];
>  };
>  
>  /* Functions to freeze a chain of deferred operations for later. */
> @@ -83,5 +88,10 @@ int xfs_defer_freeze(struct xfs_trans *tp, struct xfs_defer_freezer **dffp);
>  void xfs_defer_thaw(struct xfs_defer_freezer *dff, struct xfs_trans *tp);
>  void xfs_defer_freeezer_finish(struct xfs_mount *mp,
>  		struct xfs_defer_freezer *dff);
> +int xfs_defer_freezer_ijoin(struct xfs_defer_freezer *dff,
> +		struct xfs_inode *ip);
> +
> +/* These functions must be provided by the xfs implementation. */
> +void xfs_defer_freezer_irele(struct xfs_defer_freezer *dff);
>  
>  #endif /* __XFS_DEFER_H__ */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index c733bdeeeb9b..bbce191d8fcd 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -530,12 +530,13 @@ xfs_bui_item_recover(
>  	}
>  
>  	error = xlog_recover_trans_commit(tp, dffp);
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	xfs_irele(ip);
> -	return error;
> +	if (error)
> +		goto err_rele;
> +	return xfs_defer_freezer_ijoin(*dffp, ip);
>  
>  err_inode:
>  	xfs_trans_cancel(tp);
> +err_rele:
>  	if (ip) {
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		xfs_irele(ip);
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 17a0b86fe701..b96ddf5ff334 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -12,6 +12,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
> @@ -1847,3 +1848,21 @@ xfs_start_block_reaping(
>  	xfs_queue_eofblocks(mp);
>  	xfs_queue_cowblocks(mp);
>  }
> +
> +/* Release all the inode resources attached to this freezer. */
> +void
> +xfs_defer_freezer_irele(
> +	struct xfs_defer_freezer	*dff)
> +{
> +	unsigned int			i;
> +
> +	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
> +		if (!dff->dff_inodes[i])
> +			break;
> +
> +		if (dff->dff_ilocks[i])
> +			xfs_iunlock(dff->dff_inodes[i], dff->dff_ilocks[i]);
> +		xfs_irele(dff->dff_inodes[i]);
> +		dff->dff_inodes[i] = NULL;
> +	}
> +}
> 

