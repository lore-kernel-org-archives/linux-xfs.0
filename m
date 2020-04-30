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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77FAC8300A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF1DF207DD
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="anVq+2Ob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgD3LEZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:04:25 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59322 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726636AbgD3LEZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:04:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0++JxMl8VV6lub1LCuTQT+ila4Dc+GXcQajZH19l20M=;
        b=anVq+2Obs4lVk7dpUOzPMxFAmAmFHoDXjVN/Ma/3+X8FrvEcc+it9xcVyNBi3L5sSDJaXl
        nj3SRbhxAJtIluCjpHF4yZdo9ukNpnSiAustliLlvEpWHV4W/vEzoTktfC4C9XfLcxMZ/k
        B6j+M+F1DCEPAp+lx/4/ex9tIy152/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-9-XMGfTLMQG0W88iodbeJw-1; Thu, 30 Apr 2020 07:04:20 -0400
X-MC-Unique: 9-XMGfTLMQG0W88iodbeJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7375800D24;
        Thu, 30 Apr 2020 11:04:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FA12600E5;
        Thu, 30 Apr 2020 11:04:19 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:04:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: turn dfp_intent into a xfs_log_item
Message-ID: <20200430110417.GG5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-8-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:07PM +0200, Christoph Hellwig wrote:
> All defer op instance place their own extension of the log item into
> the dfp_intent field.  Replace that with a xfs_log_item to improve type
> safety and make the code easier to follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.h  | 11 ++++++-----
>  fs/xfs/xfs_bmap_item.c     | 12 ++++++------
>  fs/xfs/xfs_extfree_item.c  | 12 ++++++------
>  fs/xfs/xfs_refcount_item.c | 12 ++++++------
>  fs/xfs/xfs_rmap_item.c     | 12 ++++++------
>  5 files changed, 30 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 660f5c3821d6b..7b6cc3808a91b 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -28,7 +28,7 @@ enum xfs_defer_ops_type {
>  struct xfs_defer_pending {
>  	struct list_head		dfp_list;	/* pending items */
>  	struct list_head		dfp_work;	/* work items */
> -	void				*dfp_intent;	/* log intent item */
> +	struct xfs_log_item		*dfp_intent;	/* log intent item */
>  	void				*dfp_done;	/* log done item */
>  	unsigned int			dfp_count;	/* # extent items */
>  	enum xfs_defer_ops_type		dfp_type;
> @@ -43,14 +43,15 @@ void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
>  
>  /* Description of a deferred type. */
>  struct xfs_defer_op_type {
> -	void (*abort_intent)(void *);
> -	void *(*create_done)(struct xfs_trans *, void *, unsigned int);
> +	struct xfs_log_item *(*create_intent)(struct xfs_trans *tp,
> +			struct list_head *items, unsigned int count, bool sort);
> +	void (*abort_intent)(struct xfs_log_item *intent);
> +	void *(*create_done)(struct xfs_trans *tp, struct xfs_log_item *intent,
> +			unsigned int count);
>  	int (*finish_item)(struct xfs_trans *, struct list_head *, void *,
>  			void **);
>  	void (*finish_cleanup)(struct xfs_trans *, void *, int);
>  	void (*cancel_item)(struct list_head *);
> -	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
> -			unsigned int count, bool sort);
>  	unsigned int		max_items;
>  };
>  
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index f9505c5873bd2..7b2153fca2d9e 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -330,7 +330,7 @@ xfs_bmap_update_log_item(
>  			bmap->bi_bmap.br_state);
>  }
>  
> -STATIC void *
> +static struct xfs_log_item *
>  xfs_bmap_update_create_intent(
>  	struct xfs_trans		*tp,
>  	struct list_head		*items,
> @@ -348,17 +348,17 @@ xfs_bmap_update_create_intent(
>  		list_sort(mp, items, xfs_bmap_update_diff_items);
>  	list_for_each_entry(bmap, items, bi_list)
>  		xfs_bmap_update_log_item(tp, buip, bmap);
> -	return buip;
> +	return &buip->bui_item;
>  }
>  
>  /* Get an BUD so we can process all the deferred rmap updates. */
>  STATIC void *
>  xfs_bmap_update_create_done(
>  	struct xfs_trans		*tp,
> -	void				*intent,
> +	struct xfs_log_item		*intent,
>  	unsigned int			count)
>  {
> -	return xfs_trans_get_bud(tp, intent);
> +	return xfs_trans_get_bud(tp, BUI_ITEM(intent));
>  }
>  
>  /* Process a deferred rmap update. */
> @@ -394,9 +394,9 @@ xfs_bmap_update_finish_item(
>  /* Abort all pending BUIs. */
>  STATIC void
>  xfs_bmap_update_abort_intent(
> -	void				*intent)
> +	struct xfs_log_item		*intent)
>  {
> -	xfs_bui_release(intent);
> +	xfs_bui_release(BUI_ITEM(intent));
>  }
>  
>  /* Cancel a deferred rmap update. */
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 3e10eba9d22bd..0453b6f2b1d69 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -437,7 +437,7 @@ xfs_extent_free_log_item(
>  	extp->ext_len = free->xefi_blockcount;
>  }
>  
> -STATIC void *
> +static struct xfs_log_item *
>  xfs_extent_free_create_intent(
>  	struct xfs_trans		*tp,
>  	struct list_head		*items,
> @@ -455,17 +455,17 @@ xfs_extent_free_create_intent(
>  		list_sort(mp, items, xfs_extent_free_diff_items);
>  	list_for_each_entry(free, items, xefi_list)
>  		xfs_extent_free_log_item(tp, efip, free);
> -	return efip;
> +	return &efip->efi_item;
>  }
>  
>  /* Get an EFD so we can process all the free extents. */
>  STATIC void *
>  xfs_extent_free_create_done(
>  	struct xfs_trans		*tp,
> -	void				*intent,
> +	struct xfs_log_item		*intent,
>  	unsigned int			count)
>  {
> -	return xfs_trans_get_efd(tp, intent, count);
> +	return xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
>  }
>  
>  /* Process a free extent. */
> @@ -491,9 +491,9 @@ xfs_extent_free_finish_item(
>  /* Abort all pending EFIs. */
>  STATIC void
>  xfs_extent_free_abort_intent(
> -	void				*intent)
> +	struct xfs_log_item		*intent)
>  {
> -	xfs_efi_release(intent);
> +	xfs_efi_release(EFI_ITEM(intent));
>  }
>  
>  /* Cancel a free extent. */
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index efc32ec55afdf..e8d3278e066e3 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -329,7 +329,7 @@ xfs_refcount_update_log_item(
>  	xfs_trans_set_refcount_flags(ext, refc->ri_type);
>  }
>  
> -STATIC void *
> +static struct xfs_log_item *
>  xfs_refcount_update_create_intent(
>  	struct xfs_trans		*tp,
>  	struct list_head		*items,
> @@ -347,17 +347,17 @@ xfs_refcount_update_create_intent(
>  		list_sort(mp, items, xfs_refcount_update_diff_items);
>  	list_for_each_entry(refc, items, ri_list)
>  		xfs_refcount_update_log_item(tp, cuip, refc);
> -	return cuip;
> +	return &cuip->cui_item;
>  }
>  
>  /* Get an CUD so we can process all the deferred refcount updates. */
>  STATIC void *
>  xfs_refcount_update_create_done(
>  	struct xfs_trans		*tp,
> -	void				*intent,
> +	struct xfs_log_item		*intent,
>  	unsigned int			count)
>  {
> -	return xfs_trans_get_cud(tp, intent);
> +	return xfs_trans_get_cud(tp, CUI_ITEM(intent));
>  }
>  
>  /* Process a deferred refcount update. */
> @@ -407,9 +407,9 @@ xfs_refcount_update_finish_cleanup(
>  /* Abort all pending CUIs. */
>  STATIC void
>  xfs_refcount_update_abort_intent(
> -	void				*intent)
> +	struct xfs_log_item		*intent)
>  {
> -	xfs_cui_release(intent);
> +	xfs_cui_release(CUI_ITEM(intent));
>  }
>  
>  /* Cancel a deferred refcount update. */
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 40567cf0c216e..a417e15fd0ce4 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -381,7 +381,7 @@ xfs_rmap_update_log_item(
>  			rmap->ri_bmap.br_state);
>  }
>  
> -STATIC void *
> +static struct xfs_log_item *
>  xfs_rmap_update_create_intent(
>  	struct xfs_trans		*tp,
>  	struct list_head		*items,
> @@ -399,17 +399,17 @@ xfs_rmap_update_create_intent(
>  		list_sort(mp, items, xfs_rmap_update_diff_items);
>  	list_for_each_entry(rmap, items, ri_list)
>  		xfs_rmap_update_log_item(tp, ruip, rmap);
> -	return ruip;
> +	return &ruip->rui_item;
>  }
>  
>  /* Get an RUD so we can process all the deferred rmap updates. */
>  STATIC void *
>  xfs_rmap_update_create_done(
>  	struct xfs_trans		*tp,
> -	void				*intent,
> +	struct xfs_log_item		*intent,
>  	unsigned int			count)
>  {
> -	return xfs_trans_get_rud(tp, intent);
> +	return xfs_trans_get_rud(tp, RUI_ITEM(intent));
>  }
>  
>  /* Process a deferred rmap update. */
> @@ -451,9 +451,9 @@ xfs_rmap_update_finish_cleanup(
>  /* Abort all pending RUIs. */
>  STATIC void
>  xfs_rmap_update_abort_intent(
> -	void				*intent)
> +	struct xfs_log_item	*intent)
>  {
> -	xfs_rui_release(intent);
> +	xfs_rui_release(RUI_ITEM(intent));
>  }
>  
>  /* Cancel a deferred rmap update. */
> -- 
> 2.26.2
> 

