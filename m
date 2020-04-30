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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E8AC8300A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8879220774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jq51yDYC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgD3LEs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:04:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28913 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726636AbgD3LEr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RgrcVnqYeiNPX74f2oIybYnhZOjoCCa50KC6TqNv5g4=;
        b=Jq51yDYCqSkCh7kUDdOkYpTjMZz8H0KvwAbDU+1xEw/W8DoBrNOK3L+Naka0GbG+oYYO3o
        BbRcSA8OeEH2bIRz6hMozJIPbd0WZDWQGk9qXuWw9/hs64l75GO8gvZ/nNu7Wpo+n8J9dl
        VhxDN+NxDOEMHplUrEKaeRBkgjYEMR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-Vu4WaaC8PCKK6oHLu8xt4w-1; Thu, 30 Apr 2020 07:04:43 -0400
X-MC-Unique: Vu4WaaC8PCKK6oHLu8xt4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02E541005510;
        Thu, 30 Apr 2020 11:04:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98A281001920;
        Thu, 30 Apr 2020 11:04:42 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:04:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: use a xfs_btree_cur for the ->finish_cleanup
 state
Message-ID: <20200430110440.GJ5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-11-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:10PM +0200, Christoph Hellwig wrote:
> Given how XFS is all based around btrees it doesn't make much sense
> to offer a totally generic state when we can just use the btree cursor.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.c  |  2 +-
>  fs/xfs/libxfs/xfs_defer.h  |  6 ++++--
>  fs/xfs/xfs_bmap_item.c     |  2 +-
>  fs/xfs/xfs_extfree_item.c  |  4 ++--
>  fs/xfs/xfs_refcount_item.c | 24 +++++-------------------
>  fs/xfs/xfs_rmap_item.c     | 27 ++++++---------------------
>  6 files changed, 19 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 5f37f42cda67b..1172fbf072d84 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -361,7 +361,7 @@ xfs_defer_finish_one(
>  	struct xfs_defer_pending	*dfp)
>  {
>  	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
> -	void				*state = NULL;
> +	struct xfs_btree_cur		*state = NULL;
>  	struct list_head		*li, *n;
>  	int				error;
>  
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index a86c890e63d20..f2b65981bace4 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -6,6 +6,7 @@
>  #ifndef __XFS_DEFER_H__
>  #define	__XFS_DEFER_H__
>  
> +struct xfs_btree_cur;
>  struct xfs_defer_op_type;
>  
>  /*
> @@ -49,8 +50,9 @@ struct xfs_defer_op_type {
>  	struct xfs_log_item *(*create_done)(struct xfs_trans *tp,
>  			struct xfs_log_item *intent, unsigned int count);
>  	int (*finish_item)(struct xfs_trans *tp, struct xfs_log_item *done,
> -			struct list_head *item, void **state);
> -	void (*finish_cleanup)(struct xfs_trans *, void *, int);
> +			struct list_head *item, struct xfs_btree_cur **state);
> +	void (*finish_cleanup)(struct xfs_trans *tp,
> +			struct xfs_btree_cur *state, int error);
>  	void (*cancel_item)(struct list_head *);
>  	unsigned int		max_items;
>  };
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index feadd44a67e4b..7768fb2b71357 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -367,7 +367,7 @@ xfs_bmap_update_finish_item(
>  	struct xfs_trans		*tp,
>  	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				**state)
> +	struct xfs_btree_cur		**state)
>  {
>  	struct xfs_bmap_intent		*bmap;
>  	xfs_filblks_t			count;
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 633628f70e128..c8cde4122a0fe 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -474,7 +474,7 @@ xfs_extent_free_finish_item(
>  	struct xfs_trans		*tp,
>  	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				**state)
> +	struct xfs_btree_cur		**state)
>  {
>  	struct xfs_extent_free_item	*free;
>  	int				error;
> @@ -525,7 +525,7 @@ xfs_agfl_free_finish_item(
>  	struct xfs_trans		*tp,
>  	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				**state)
> +	struct xfs_btree_cur		**state)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index f1c2e559a7ae7..0316eab2fc351 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -366,7 +366,7 @@ xfs_refcount_update_finish_item(
>  	struct xfs_trans		*tp,
>  	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				**state)
> +	struct xfs_btree_cur		**state)
>  {
>  	struct xfs_refcount_intent	*refc;
>  	xfs_fsblock_t			new_fsb;
> @@ -375,11 +375,9 @@ xfs_refcount_update_finish_item(
>  
>  	refc = container_of(item, struct xfs_refcount_intent, ri_list);
>  	error = xfs_trans_log_finish_refcount_update(tp, CUD_ITEM(done),
> -			refc->ri_type,
> -			refc->ri_startblock,
> -			refc->ri_blockcount,
> -			&new_fsb, &new_aglen,
> -			(struct xfs_btree_cur **)state);
> +			refc->ri_type, refc->ri_startblock, refc->ri_blockcount,
> +			&new_fsb, &new_aglen, state);
> +
>  	/* Did we run out of reservation?  Requeue what we didn't finish. */
>  	if (!error && new_aglen > 0) {
>  		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
> @@ -392,18 +390,6 @@ xfs_refcount_update_finish_item(
>  	return error;
>  }
>  
> -/* Clean up after processing deferred refcounts. */
> -STATIC void
> -xfs_refcount_update_finish_cleanup(
> -	struct xfs_trans	*tp,
> -	void			*state,
> -	int			error)
> -{
> -	struct xfs_btree_cur	*rcur = state;
> -
> -	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -}
> -
>  /* Abort all pending CUIs. */
>  STATIC void
>  xfs_refcount_update_abort_intent(
> @@ -429,7 +415,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
>  	.abort_intent	= xfs_refcount_update_abort_intent,
>  	.create_done	= xfs_refcount_update_create_done,
>  	.finish_item	= xfs_refcount_update_finish_item,
> -	.finish_cleanup = xfs_refcount_update_finish_cleanup,
> +	.finish_cleanup = xfs_refcount_finish_one_cleanup,
>  	.cancel_item	= xfs_refcount_update_cancel_item,
>  };
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index f6a2a388e5ac9..e3bba2aec8682 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -418,36 +418,21 @@ xfs_rmap_update_finish_item(
>  	struct xfs_trans		*tp,
>  	struct xfs_log_item		*done,
>  	struct list_head		*item,
> -	void				**state)
> +	struct xfs_btree_cur		**state)
>  {
>  	struct xfs_rmap_intent		*rmap;
>  	int				error;
>  
>  	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
>  	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done),
> -			rmap->ri_type,
> -			rmap->ri_owner, rmap->ri_whichfork,
> -			rmap->ri_bmap.br_startoff,
> -			rmap->ri_bmap.br_startblock,
> -			rmap->ri_bmap.br_blockcount,
> -			rmap->ri_bmap.br_state,
> -			(struct xfs_btree_cur **)state);
> +			rmap->ri_type, rmap->ri_owner, rmap->ri_whichfork,
> +			rmap->ri_bmap.br_startoff, rmap->ri_bmap.br_startblock,
> +			rmap->ri_bmap.br_blockcount, rmap->ri_bmap.br_state,
> +			state);
>  	kmem_free(rmap);
>  	return error;
>  }
>  
> -/* Clean up after processing deferred rmaps. */
> -STATIC void
> -xfs_rmap_update_finish_cleanup(
> -	struct xfs_trans	*tp,
> -	void			*state,
> -	int			error)
> -{
> -	struct xfs_btree_cur	*rcur = state;
> -
> -	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> -}
> -
>  /* Abort all pending RUIs. */
>  STATIC void
>  xfs_rmap_update_abort_intent(
> @@ -473,7 +458,7 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
>  	.abort_intent	= xfs_rmap_update_abort_intent,
>  	.create_done	= xfs_rmap_update_create_done,
>  	.finish_item	= xfs_rmap_update_finish_item,
> -	.finish_cleanup = xfs_rmap_update_finish_cleanup,
> +	.finish_cleanup = xfs_rmap_finish_one_cleanup,
>  	.cancel_item	= xfs_rmap_update_cancel_item,
>  };
>  
> -- 
> 2.26.2
> 

