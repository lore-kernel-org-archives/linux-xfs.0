Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A46C8300B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA0A12078D
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U+VpMOyI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgD3LES (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:04:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40765 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726692AbgD3LER (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jgjFCNWUFOPVbnJrHabz4KSDB4lZSR4ZMh9YQI3sjpM=;
        b=U+VpMOyI1sJZhsXv2LUCaBQsNuWYKJM6hbYuiqutupVGvEU+KR7SG5C0mOkfuwD7CvesWP
        mbVgvDKOj5cA4g+HR+WtkqKWEJ8oHYOxgMOpJGiZ00Ek5ZK/93DdkI/Xn796MTgiqrEDxc
        y+N2mOt4dNZoWmUmc0XbBFnjpO3HYYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-Zkjse8LrO7Ce_LzjUq53mw-1; Thu, 30 Apr 2020 07:04:13 -0400
X-MC-Unique: Zkjse8LrO7Ce_LzjUq53mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A76AC835B4F;
        Thu, 30 Apr 2020 11:04:12 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4876A1001920;
        Thu, 30 Apr 2020 11:04:12 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:04:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: merge the ->diff_items defer op into
 ->create_intent
Message-ID: <20200430110410.GF5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:06PM +0200, Christoph Hellwig wrote:
> This avoids a per-item indirect call, and also simplifies the interface
> a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.c  | 5 +----
>  fs/xfs/libxfs/xfs_defer.h  | 3 +--
>  fs/xfs/xfs_bmap_item.c     | 9 ++++++---
>  fs/xfs/xfs_extfree_item.c  | 7 ++++---
>  fs/xfs/xfs_refcount_item.c | 6 ++++--
>  fs/xfs/xfs_rmap_item.c     | 6 ++++--
>  6 files changed, 20 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 56d1357f9d137..5402a7bf31108 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -186,11 +186,8 @@ xfs_defer_create_intent(
>  {
>  	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
>  
> -	if (sort)
> -		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
> -
>  	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
> -			dfp->dfp_count);
> +			dfp->dfp_count, sort);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index d6a4577c25b05..660f5c3821d6b 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -49,9 +49,8 @@ struct xfs_defer_op_type {
>  			void **);
>  	void (*finish_cleanup)(struct xfs_trans *, void *, int);
>  	void (*cancel_item)(struct list_head *);
> -	int (*diff_items)(void *, struct list_head *, struct list_head *);
>  	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
> -			unsigned int count);
> +			unsigned int count, bool sort);
>  	unsigned int		max_items;
>  };
>  
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index dea97956d78d6..f9505c5873bd2 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -334,14 +334,18 @@ STATIC void *
>  xfs_bmap_update_create_intent(
>  	struct xfs_trans		*tp,
>  	struct list_head		*items,
> -	unsigned int			count)
> +	unsigned int			count,
> +	bool				sort)
>  {
> -	struct xfs_bui_log_item		*buip = xfs_bui_init(tp->t_mountp);
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_bui_log_item		*buip = xfs_bui_init(mp);
>  	struct xfs_bmap_intent		*bmap;
>  
>  	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
>  
>  	xfs_trans_add_item(tp, &buip->bui_item);
> +	if (sort)
> +		list_sort(mp, items, xfs_bmap_update_diff_items);
>  	list_for_each_entry(bmap, items, bi_list)
>  		xfs_bmap_update_log_item(tp, buip, bmap);
>  	return buip;
> @@ -408,7 +412,6 @@ xfs_bmap_update_cancel_item(
>  
>  const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
>  	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
> -	.diff_items	= xfs_bmap_update_diff_items,
>  	.create_intent	= xfs_bmap_update_create_intent,
>  	.abort_intent	= xfs_bmap_update_abort_intent,
>  	.create_done	= xfs_bmap_update_create_done,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index cb22c7ad31817..3e10eba9d22bd 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -441,7 +441,8 @@ STATIC void *
>  xfs_extent_free_create_intent(
>  	struct xfs_trans		*tp,
>  	struct list_head		*items,
> -	unsigned int			count)
> +	unsigned int			count,
> +	bool				sort)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
> @@ -450,6 +451,8 @@ xfs_extent_free_create_intent(
>  	ASSERT(count > 0);
>  
>  	xfs_trans_add_item(tp, &efip->efi_item);
> +	if (sort)
> +		list_sort(mp, items, xfs_extent_free_diff_items);
>  	list_for_each_entry(free, items, xefi_list)
>  		xfs_extent_free_log_item(tp, efip, free);
>  	return efip;
> @@ -506,7 +509,6 @@ xfs_extent_free_cancel_item(
>  
>  const struct xfs_defer_op_type xfs_extent_free_defer_type = {
>  	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
> -	.diff_items	= xfs_extent_free_diff_items,
>  	.create_intent	= xfs_extent_free_create_intent,
>  	.abort_intent	= xfs_extent_free_abort_intent,
>  	.create_done	= xfs_extent_free_create_done,
> @@ -571,7 +573,6 @@ xfs_agfl_free_finish_item(
>  /* sub-type with special handling for AGFL deferred frees */
>  const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
>  	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
> -	.diff_items	= xfs_extent_free_diff_items,
>  	.create_intent	= xfs_extent_free_create_intent,
>  	.abort_intent	= xfs_extent_free_abort_intent,
>  	.create_done	= xfs_extent_free_create_done,
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 325d49fc0406c..efc32ec55afdf 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -333,7 +333,8 @@ STATIC void *
>  xfs_refcount_update_create_intent(
>  	struct xfs_trans		*tp,
>  	struct list_head		*items,
> -	unsigned int			count)
> +	unsigned int			count,
> +	bool				sort)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_cui_log_item		*cuip = xfs_cui_init(mp, count);
> @@ -342,6 +343,8 @@ xfs_refcount_update_create_intent(
>  	ASSERT(count > 0);
>  
>  	xfs_trans_add_item(tp, &cuip->cui_item);
> +	if (sort)
> +		list_sort(mp, items, xfs_refcount_update_diff_items);
>  	list_for_each_entry(refc, items, ri_list)
>  		xfs_refcount_update_log_item(tp, cuip, refc);
>  	return cuip;
> @@ -422,7 +425,6 @@ xfs_refcount_update_cancel_item(
>  
>  const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
>  	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
> -	.diff_items	= xfs_refcount_update_diff_items,
>  	.create_intent	= xfs_refcount_update_create_intent,
>  	.abort_intent	= xfs_refcount_update_abort_intent,
>  	.create_done	= xfs_refcount_update_create_done,
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 842d817f5168c..40567cf0c216e 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -385,7 +385,8 @@ STATIC void *
>  xfs_rmap_update_create_intent(
>  	struct xfs_trans		*tp,
>  	struct list_head		*items,
> -	unsigned int			count)
> +	unsigned int			count,
> +	bool				sort)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
> @@ -394,6 +395,8 @@ xfs_rmap_update_create_intent(
>  	ASSERT(count > 0);
>  
>  	xfs_trans_add_item(tp, &ruip->rui_item);
> +	if (sort)
> +		list_sort(mp, items, xfs_rmap_update_diff_items);
>  	list_for_each_entry(rmap, items, ri_list)
>  		xfs_rmap_update_log_item(tp, ruip, rmap);
>  	return ruip;
> @@ -466,7 +469,6 @@ xfs_rmap_update_cancel_item(
>  
>  const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
>  	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
> -	.diff_items	= xfs_rmap_update_diff_items,
>  	.create_intent	= xfs_rmap_update_create_intent,
>  	.abort_intent	= xfs_rmap_update_abort_intent,
>  	.create_done	= xfs_rmap_update_create_done,
> -- 
> 2.26.2
> 

