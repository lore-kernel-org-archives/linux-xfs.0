Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983E3C8300A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DBA72078D
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DDenvkTU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgD3LEl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:04:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49525 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726636AbgD3LEk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iWdZgv2vKl9A66JRer2a2Ol/2gwN/3LsRzDAj0td9H8=;
        b=DDenvkTUdz7V3c8ZnLpP3AuB8lDV1bAGUkQtMclfNghN1a/Txph1TcnE64eySg37BBpfBw
        PlgSeiiy9zR29v7U4qI5iUKUyb0MBQgic3MLDgW6Xjv4Z7H60KuId268Vrum9k7xl+UjVK
        2Y9Tyvf4FPdFnq8xrXk1Q0U7Y6j+7yI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-Gc-fD1AOMLy7ovPn6bkVeA-1; Thu, 30 Apr 2020 07:04:36 -0400
X-MC-Unique: Gc-fD1AOMLy7ovPn6bkVeA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C4A81005510;
        Thu, 30 Apr 2020 11:04:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 951FC1001920;
        Thu, 30 Apr 2020 11:04:34 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:04:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: turn dfp_done into a xfs_log_item
Message-ID: <20200430110432.GI5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-10-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:09PM +0200, Christoph Hellwig wrote:
> All defer op instance place their own extension of the log item into
> the dfp_done field.  Replace that with a xfs_log_item to improve type
> safety and make the code easier to follow.
> 
> Also use the opportunity to improve the ->finish_item calling conventions
> to place the done log item as the higher level structure before the
> list_entry used for the individual items.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.c  |  2 +-
>  fs/xfs/libxfs/xfs_defer.h  | 10 +++++-----
>  fs/xfs/xfs_bmap_item.c     |  8 ++++----
>  fs/xfs/xfs_extfree_item.c  | 12 ++++++------
>  fs/xfs/xfs_refcount_item.c |  8 ++++----
>  fs/xfs/xfs_rmap_item.c     |  8 ++++----
>  6 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 20950b56cdd07..5f37f42cda67b 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -371,7 +371,7 @@ xfs_defer_finish_one(
>  	list_for_each_safe(li, n, &dfp->dfp_work) {
>  		list_del(li);
>  		dfp->dfp_count--;
> -		error = ops->finish_item(tp, li, dfp->dfp_done, &state);
> +		error = ops->finish_item(tp, dfp->dfp_done, li, &state);
>  		if (error == -EAGAIN) {
>  			/*
>  			 * Caller wants a fresh transaction; put the work item
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 7b6cc3808a91b..a86c890e63d20 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -29,7 +29,7 @@ struct xfs_defer_pending {
>  	struct list_head		dfp_list;	/* pending items */
>  	struct list_head		dfp_work;	/* work items */
>  	struct xfs_log_item		*dfp_intent;	/* log intent item */
> -	void				*dfp_done;	/* log done item */
> +	struct xfs_log_item		*dfp_done;	/* log done item */
>  	unsigned int			dfp_count;	/* # extent items */
>  	enum xfs_defer_ops_type		dfp_type;
>  };
> @@ -46,10 +46,10 @@ struct xfs_defer_op_type {
>  	struct xfs_log_item *(*create_intent)(struct xfs_trans *tp,
>  			struct list_head *items, unsigned int count, bool sort);
>  	void (*abort_intent)(struct xfs_log_item *intent);
> -	void *(*create_done)(struct xfs_trans *tp, struct xfs_log_item *intent,
> -			unsigned int count);
> -	int (*finish_item)(struct xfs_trans *, struct list_head *, void *,
> -			void **);
> +	struct xfs_log_item *(*create_done)(struct xfs_trans *tp,
> +			struct xfs_log_item *intent, unsigned int count);
> +	int (*finish_item)(struct xfs_trans *tp, struct xfs_log_item *done,
> +			struct list_head *item, void **state);
>  	void (*finish_cleanup)(struct xfs_trans *, void *, int);
>  	void (*cancel_item)(struct list_head *);
>  	unsigned int		max_items;
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 7b2153fca2d9e..feadd44a67e4b 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -352,21 +352,21 @@ xfs_bmap_update_create_intent(
>  }
>  
>  /* Get an BUD so we can process all the deferred rmap updates. */
> -STATIC void *
> +static struct xfs_log_item *
>  xfs_bmap_update_create_done(
>  	struct xfs_trans		*tp,
>  	struct xfs_log_item		*intent,
>  	unsigned int			count)
>  {
> -	return xfs_trans_get_bud(tp, BUI_ITEM(intent));
> +	return &xfs_trans_get_bud(tp, BUI_ITEM(intent))->bud_item;
>  }
>  
>  /* Process a deferred rmap update. */
>  STATIC int
>  xfs_bmap_update_finish_item(
>  	struct xfs_trans		*tp,
> +	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				*done_item,
>  	void				**state)
>  {
>  	struct xfs_bmap_intent		*bmap;
> @@ -375,7 +375,7 @@ xfs_bmap_update_finish_item(
>  
>  	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
>  	count = bmap->bi_bmap.br_blockcount;
> -	error = xfs_trans_log_finish_bmap_update(tp, done_item,
> +	error = xfs_trans_log_finish_bmap_update(tp, BUD_ITEM(done),
>  			bmap->bi_type,
>  			bmap->bi_owner, bmap->bi_whichfork,
>  			bmap->bi_bmap.br_startoff,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 0453b6f2b1d69..633628f70e128 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -459,28 +459,28 @@ xfs_extent_free_create_intent(
>  }
>  
>  /* Get an EFD so we can process all the free extents. */
> -STATIC void *
> +static struct xfs_log_item *
>  xfs_extent_free_create_done(
>  	struct xfs_trans		*tp,
>  	struct xfs_log_item		*intent,
>  	unsigned int			count)
>  {
> -	return xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
> +	return &xfs_trans_get_efd(tp, EFI_ITEM(intent), count)->efd_item;
>  }
>  
>  /* Process a free extent. */
>  STATIC int
>  xfs_extent_free_finish_item(
>  	struct xfs_trans		*tp,
> +	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				*done_item,
>  	void				**state)
>  {
>  	struct xfs_extent_free_item	*free;
>  	int				error;
>  
>  	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> -	error = xfs_trans_free_extent(tp, done_item,
> +	error = xfs_trans_free_extent(tp, EFD_ITEM(done),
>  			free->xefi_startblock,
>  			free->xefi_blockcount,
>  			&free->xefi_oinfo, free->xefi_skip_discard);
> @@ -523,12 +523,12 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
>  STATIC int
>  xfs_agfl_free_finish_item(
>  	struct xfs_trans		*tp,
> +	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				*done_item,
>  	void				**state)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
> -	struct xfs_efd_log_item		*efdp = done_item;
> +	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
>  	struct xfs_extent_free_item	*free;
>  	struct xfs_extent		*extp;
>  	struct xfs_buf			*agbp;
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index e8d3278e066e3..f1c2e559a7ae7 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -351,21 +351,21 @@ xfs_refcount_update_create_intent(
>  }
>  
>  /* Get an CUD so we can process all the deferred refcount updates. */
> -STATIC void *
> +static struct xfs_log_item *
>  xfs_refcount_update_create_done(
>  	struct xfs_trans		*tp,
>  	struct xfs_log_item		*intent,
>  	unsigned int			count)
>  {
> -	return xfs_trans_get_cud(tp, CUI_ITEM(intent));
> +	return &xfs_trans_get_cud(tp, CUI_ITEM(intent))->cud_item;
>  }
>  
>  /* Process a deferred refcount update. */
>  STATIC int
>  xfs_refcount_update_finish_item(
>  	struct xfs_trans		*tp,
> +	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				*done_item,
>  	void				**state)
>  {
>  	struct xfs_refcount_intent	*refc;
> @@ -374,7 +374,7 @@ xfs_refcount_update_finish_item(
>  	int				error;
>  
>  	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> -	error = xfs_trans_log_finish_refcount_update(tp, done_item,
> +	error = xfs_trans_log_finish_refcount_update(tp, CUD_ITEM(done),
>  			refc->ri_type,
>  			refc->ri_startblock,
>  			refc->ri_blockcount,
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index a417e15fd0ce4..f6a2a388e5ac9 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -403,28 +403,28 @@ xfs_rmap_update_create_intent(
>  }
>  
>  /* Get an RUD so we can process all the deferred rmap updates. */
> -STATIC void *
> +static struct xfs_log_item *
>  xfs_rmap_update_create_done(
>  	struct xfs_trans		*tp,
>  	struct xfs_log_item		*intent,
>  	unsigned int			count)
>  {
> -	return xfs_trans_get_rud(tp, RUI_ITEM(intent));
> +	return &xfs_trans_get_rud(tp, RUI_ITEM(intent))->rud_item;
>  }
>  
>  /* Process a deferred rmap update. */
>  STATIC int
>  xfs_rmap_update_finish_item(
>  	struct xfs_trans		*tp,
> +	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				*done_item,
>  	void				**state)
>  {
>  	struct xfs_rmap_intent		*rmap;
>  	int				error;
>  
>  	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
> -	error = xfs_trans_log_finish_rmap_update(tp, done_item,
> +	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done),
>  			rmap->ri_type,
>  			rmap->ri_owner, rmap->ri_whichfork,
>  			rmap->ri_bmap.br_startoff,
> -- 
> 2.26.2
> 

