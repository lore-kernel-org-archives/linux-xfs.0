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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60157C8300A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 366D920757
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+IaaySk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3LEM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:04:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33970 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726309AbgD3LEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2SKRq3xkM72hg+ktxcPNVfbS142TGO7RZe3uAu9IK8E=;
        b=G+IaaySkLmsxr1HBclWiHW82a74ZFTTADcnTTm77PI+sngFcMs+IWZ09/aXSzmpZ/HIAGw
        lq1V1NlsHRI2pdVlljGaJbIsNopyzi8JqodUMx4AYxrb365k/bFzQucgH1VnErnyY/lwzN
        /MkbIqJLcpT1bkrXwfkBi1lVKv6BslM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-nTc6eAs7MXOw6Kz22nQRcw-1; Thu, 30 Apr 2020 07:04:04 -0400
X-MC-Unique: nTc6eAs7MXOw6Kz22nQRcw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00239107ACF3;
        Thu, 30 Apr 2020 11:04:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C4C35C1B0;
        Thu, 30 Apr 2020 11:04:03 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:04:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: merge the ->log_item defer op into
 ->create_intent
Message-ID: <20200430110402.GE5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:05PM +0200, Christoph Hellwig wrote:
> These are aways called together, and my merging them we reduce the amount
> of indirect calls, improve type safety and in general clean up the code
> a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |  6 ++---
>  fs/xfs/libxfs/xfs_defer.h  |  4 ++--
>  fs/xfs/xfs_bmap_item.c     | 47 +++++++++++++++---------------------
>  fs/xfs/xfs_extfree_item.c  | 49 ++++++++++++++++----------------------
>  fs/xfs/xfs_refcount_item.c | 48 ++++++++++++++++---------------------
>  fs/xfs/xfs_rmap_item.c     | 48 ++++++++++++++++---------------------
>  6 files changed, 83 insertions(+), 119 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ee6f4229cebc4..dea97956d78d6 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
...
> @@ -355,6 +330,23 @@ xfs_bmap_update_log_item(
>  			bmap->bi_bmap.br_state);
>  }
>  
> +STATIC void *
> +xfs_bmap_update_create_intent(
> +	struct xfs_trans		*tp,
> +	struct list_head		*items,
> +	unsigned int			count)
> +{
> +	struct xfs_bui_log_item		*buip = xfs_bui_init(tp->t_mountp);

I'd prefer to see these _init() calls separate from the variable
declarations, but otherwise nice cleanup:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	struct xfs_bmap_intent		*bmap;
> +
> +	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
> +
> +	xfs_trans_add_item(tp, &buip->bui_item);
> +	list_for_each_entry(bmap, items, bi_list)
> +		xfs_bmap_update_log_item(tp, buip, bmap);
> +	return buip;
> +}
> +
>  /* Get an BUD so we can process all the deferred rmap updates. */
>  STATIC void *
>  xfs_bmap_update_create_done(
> @@ -419,7 +411,6 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
>  	.diff_items	= xfs_bmap_update_diff_items,
>  	.create_intent	= xfs_bmap_update_create_intent,
>  	.abort_intent	= xfs_bmap_update_abort_intent,
> -	.log_item	= xfs_bmap_update_log_item,
>  	.create_done	= xfs_bmap_update_create_done,
>  	.finish_item	= xfs_bmap_update_finish_item,
>  	.cancel_item	= xfs_bmap_update_cancel_item,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 00309b81607cd..cb22c7ad31817 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -412,41 +412,16 @@ xfs_extent_free_diff_items(
>  		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
>  }
>  
> -/* Get an EFI. */
> -STATIC void *
> -xfs_extent_free_create_intent(
> -	struct xfs_trans		*tp,
> -	unsigned int			count)
> -{
> -	struct xfs_efi_log_item		*efip;
> -
> -	ASSERT(tp != NULL);
> -	ASSERT(count > 0);
> -
> -	efip = xfs_efi_init(tp->t_mountp, count);
> -	ASSERT(efip != NULL);
> -
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> -	xfs_trans_add_item(tp, &efip->efi_item);
> -	return efip;
> -}
> -
>  /* Log a free extent to the intent item. */
>  STATIC void
>  xfs_extent_free_log_item(
>  	struct xfs_trans		*tp,
> -	void				*intent,
> -	struct list_head		*item)
> +	struct xfs_efi_log_item		*efip,
> +	struct xfs_extent_free_item	*free)
>  {
> -	struct xfs_efi_log_item		*efip = intent;
> -	struct xfs_extent_free_item	*free;
>  	uint				next_extent;
>  	struct xfs_extent		*extp;
>  
> -	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> -
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
>  
> @@ -462,6 +437,24 @@ xfs_extent_free_log_item(
>  	extp->ext_len = free->xefi_blockcount;
>  }
>  
> +STATIC void *
> +xfs_extent_free_create_intent(
> +	struct xfs_trans		*tp,
> +	struct list_head		*items,
> +	unsigned int			count)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
> +	struct xfs_extent_free_item	*free;
> +
> +	ASSERT(count > 0);
> +
> +	xfs_trans_add_item(tp, &efip->efi_item);
> +	list_for_each_entry(free, items, xefi_list)
> +		xfs_extent_free_log_item(tp, efip, free);
> +	return efip;
> +}
> +
>  /* Get an EFD so we can process all the free extents. */
>  STATIC void *
>  xfs_extent_free_create_done(
> @@ -516,7 +509,6 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
>  	.diff_items	= xfs_extent_free_diff_items,
>  	.create_intent	= xfs_extent_free_create_intent,
>  	.abort_intent	= xfs_extent_free_abort_intent,
> -	.log_item	= xfs_extent_free_log_item,
>  	.create_done	= xfs_extent_free_create_done,
>  	.finish_item	= xfs_extent_free_finish_item,
>  	.cancel_item	= xfs_extent_free_cancel_item,
> @@ -582,7 +574,6 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
>  	.diff_items	= xfs_extent_free_diff_items,
>  	.create_intent	= xfs_extent_free_create_intent,
>  	.abort_intent	= xfs_extent_free_abort_intent,
> -	.log_item	= xfs_extent_free_log_item,
>  	.create_done	= xfs_extent_free_create_done,
>  	.finish_item	= xfs_agfl_free_finish_item,
>  	.cancel_item	= xfs_extent_free_cancel_item,
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 8eeed73928cdf..325d49fc0406c 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -284,27 +284,6 @@ xfs_refcount_update_diff_items(
>  		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
>  }
>  
> -/* Get an CUI. */
> -STATIC void *
> -xfs_refcount_update_create_intent(
> -	struct xfs_trans		*tp,
> -	unsigned int			count)
> -{
> -	struct xfs_cui_log_item		*cuip;
> -
> -	ASSERT(tp != NULL);
> -	ASSERT(count > 0);
> -
> -	cuip = xfs_cui_init(tp->t_mountp, count);
> -	ASSERT(cuip != NULL);
> -
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> -	xfs_trans_add_item(tp, &cuip->cui_item);
> -	return cuip;
> -}
> -
>  /* Set the phys extent flags for this reverse mapping. */
>  static void
>  xfs_trans_set_refcount_flags(
> @@ -328,16 +307,12 @@ xfs_trans_set_refcount_flags(
>  STATIC void
>  xfs_refcount_update_log_item(
>  	struct xfs_trans		*tp,
> -	void				*intent,
> -	struct list_head		*item)
> +	struct xfs_cui_log_item		*cuip,
> +	struct xfs_refcount_intent	*refc)
>  {
> -	struct xfs_cui_log_item		*cuip = intent;
> -	struct xfs_refcount_intent	*refc;
>  	uint				next_extent;
>  	struct xfs_phys_extent		*ext;
>  
> -	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> -
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
>  
> @@ -354,6 +329,24 @@ xfs_refcount_update_log_item(
>  	xfs_trans_set_refcount_flags(ext, refc->ri_type);
>  }
>  
> +STATIC void *
> +xfs_refcount_update_create_intent(
> +	struct xfs_trans		*tp,
> +	struct list_head		*items,
> +	unsigned int			count)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
> +	struct xfs_refcount_intent	*refc;
> +
> +	ASSERT(count > 0);
> +
> +	xfs_trans_add_item(tp, &cuip->cui_item);
> +	list_for_each_entry(refc, items, ri_list)
> +		xfs_refcount_update_log_item(tp, cuip, refc);
> +	return cuip;
> +}
> +
>  /* Get an CUD so we can process all the deferred refcount updates. */
>  STATIC void *
>  xfs_refcount_update_create_done(
> @@ -432,7 +425,6 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
>  	.diff_items	= xfs_refcount_update_diff_items,
>  	.create_intent	= xfs_refcount_update_create_intent,
>  	.abort_intent	= xfs_refcount_update_abort_intent,
> -	.log_item	= xfs_refcount_update_log_item,
>  	.create_done	= xfs_refcount_update_create_done,
>  	.finish_item	= xfs_refcount_update_finish_item,
>  	.finish_cleanup = xfs_refcount_update_finish_cleanup,
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 4911b68f95dda..842d817f5168c 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -352,41 +352,16 @@ xfs_rmap_update_diff_items(
>  		XFS_FSB_TO_AGNO(mp, rb->ri_bmap.br_startblock);
>  }
>  
> -/* Get an RUI. */
> -STATIC void *
> -xfs_rmap_update_create_intent(
> -	struct xfs_trans		*tp,
> -	unsigned int			count)
> -{
> -	struct xfs_rui_log_item		*ruip;
> -
> -	ASSERT(tp != NULL);
> -	ASSERT(count > 0);
> -
> -	ruip = xfs_rui_init(tp->t_mountp, count);
> -	ASSERT(ruip != NULL);
> -
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> -	xfs_trans_add_item(tp, &ruip->rui_item);
> -	return ruip;
> -}
> -
>  /* Log rmap updates in the intent item. */
>  STATIC void
>  xfs_rmap_update_log_item(
>  	struct xfs_trans		*tp,
> -	void				*intent,
> -	struct list_head		*item)
> +	struct xfs_rui_log_item		*ruip,
> +	struct xfs_rmap_intent		*rmap)
>  {
> -	struct xfs_rui_log_item		*ruip = intent;
> -	struct xfs_rmap_intent		*rmap;
>  	uint				next_extent;
>  	struct xfs_map_extent		*map;
>  
> -	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
> -
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
>  
> @@ -406,6 +381,24 @@ xfs_rmap_update_log_item(
>  			rmap->ri_bmap.br_state);
>  }
>  
> +STATIC void *
> +xfs_rmap_update_create_intent(
> +	struct xfs_trans		*tp,
> +	struct list_head		*items,
> +	unsigned int			count)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
> +	struct xfs_rmap_intent		*rmap;
> +
> +	ASSERT(count > 0);
> +
> +	xfs_trans_add_item(tp, &ruip->rui_item);
> +	list_for_each_entry(rmap, items, ri_list)
> +		xfs_rmap_update_log_item(tp, ruip, rmap);
> +	return ruip;
> +}
> +
>  /* Get an RUD so we can process all the deferred rmap updates. */
>  STATIC void *
>  xfs_rmap_update_create_done(
> @@ -476,7 +469,6 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
>  	.diff_items	= xfs_rmap_update_diff_items,
>  	.create_intent	= xfs_rmap_update_create_intent,
>  	.abort_intent	= xfs_rmap_update_abort_intent,
> -	.log_item	= xfs_rmap_update_log_item,
>  	.create_done	= xfs_rmap_update_create_done,
>  	.finish_item	= xfs_rmap_update_finish_item,
>  	.finish_cleanup = xfs_rmap_update_finish_cleanup,
> -- 
> 2.26.2
> 

