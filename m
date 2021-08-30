Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B837C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 17:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 152C160F91
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 17:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhH3RpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 13:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234054AbhH3RpB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Aug 2021 13:45:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8D9D60F3A;
        Mon, 30 Aug 2021 17:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630345448;
        bh=+1oZb2nEPUaXTPghKrza1wP685nHWaQssEycIiJF2mA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TzaWxJUswfsoGpLWxCAKeol0w/quPpY95IUQIAoJT462ASFrNk33II+ALKCulTYo/
         ercsWGNnlmyTL/NRSOSIk4fKKOVXoKMJoKFt7IVpbg23IY1B8Rw0cdnieegAmH8e6W
         7dx93bDfXbTe2PPAHbmh0KKGhDauH20rtGDWz4J4kkdsIwlJw0F7amfvKg+WwGTpR3
         ju08FMcwwk8rmko/YSC996x0MULrPbDOu/xF6LnAkzFKA7ayYw5dFS2EpQWSjfjyNb
         P+jswCm9dXN+YqHW02RPYxzkVIIHOYPqfTOq4HRd1OPT+SfqRcyS5Oe2Dmel3Ns0QA
         sFn2MVKg2c8PQ==
Date:   Mon, 30 Aug 2021 10:44:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 02/11] xfs: Capture buffers for delayed ops
Message-ID: <20210830174407.GA9942@magnolia>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824224434.968720-3-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 24, 2021 at 03:44:25PM -0700, Allison Henderson wrote:
> This patch enables delayed operations to capture held buffers with in
> the xfs_defer_capture. Buffers are then rejoined to the new
> transaction in xlog_finish_defer_ops
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  | 7 ++++++-
>  fs/xfs/libxfs/xfs_defer.h  | 4 +++-
>  fs/xfs/xfs_bmap_item.c     | 2 +-
>  fs/xfs/xfs_buf.c           | 1 +
>  fs/xfs/xfs_buf.h           | 1 +
>  fs/xfs/xfs_extfree_item.c  | 2 +-
>  fs/xfs/xfs_log_recover.c   | 7 +++++++
>  fs/xfs/xfs_refcount_item.c | 2 +-
>  fs/xfs/xfs_rmap_item.c     | 2 +-
>  9 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index eff4a127188e..d1d09b6aca55 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -639,6 +639,7 @@ xfs_defer_ops_capture(
>  	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
>  	INIT_LIST_HEAD(&dfc->dfc_list);
>  	INIT_LIST_HEAD(&dfc->dfc_dfops);
> +	INIT_LIST_HEAD(&dfc->dfc_buffers);
>  
>  	xfs_defer_create_intents(tp);
>  
> @@ -690,7 +691,8 @@ int
>  xfs_defer_ops_capture_and_commit(
>  	struct xfs_trans		*tp,
>  	struct xfs_inode		*capture_ip,
> -	struct list_head		*capture_list)
> +	struct list_head		*capture_list,
> +	struct xfs_buf			*bp)

I wonder if xfs_defer_ops_capture should learn to pick up the inodes and
buffers to hold automatically from the transaction that's being
committed?  Seeing as xfs_defer_trans_roll already knows how to do that
across transaction rolls, and that's more or less the same thing we're
doing here, but in a much more roundabout way.

>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_defer_capture	*dfc;
> @@ -703,6 +705,9 @@ xfs_defer_ops_capture_and_commit(
>  	if (!dfc)
>  		return xfs_trans_commit(tp);
>  
> +	if (bp && bp->b_transp == tp)
> +		list_add_tail(&bp->b_delay, &dfc->dfc_buffers);
> +
>  	/* Commit the transaction and add the capture structure to the list. */
>  	error = xfs_trans_commit(tp);
>  	if (error) {
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 05472f71fffe..739f70d72fd5 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -74,6 +74,7 @@ struct xfs_defer_capture {
>  
>  	/* Deferred ops state saved from the transaction. */
>  	struct list_head	dfc_dfops;
> +	struct list_head	dfc_buffers;
>  	unsigned int		dfc_tpflags;
>  
>  	/* Block reservations for the data and rt devices. */
> @@ -95,7 +96,8 @@ struct xfs_defer_capture {
>   * This doesn't normally happen except log recovery.
>   */
>  int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
> -		struct xfs_inode *capture_ip, struct list_head *capture_list);
> +		struct xfs_inode *capture_ip, struct list_head *capture_list,
> +		struct xfs_buf *bp);
>  void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
>  		struct xfs_inode **captured_ipp);
>  void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 03159970133f..51ba8ee368ca 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -532,7 +532,7 @@ xfs_bui_item_recover(
>  	 * Commit transaction, which frees the transaction and saves the inode
>  	 * for later replay activities.
>  	 */
> -	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
> +	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list, NULL);
>  	if (error)
>  		goto err_unlock;
>  
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 047bd6e3f389..29b4655a0a65 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -233,6 +233,7 @@ _xfs_buf_alloc(
>  	init_completion(&bp->b_iowait);
>  	INIT_LIST_HEAD(&bp->b_lru);
>  	INIT_LIST_HEAD(&bp->b_list);
> +	INIT_LIST_HEAD(&bp->b_delay);
>  	INIT_LIST_HEAD(&bp->b_li_list);
>  	sema_init(&bp->b_sema, 0); /* held, no waiters */
>  	spin_lock_init(&bp->b_lock);
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 6b0200b8007d..c51445705dc6 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -151,6 +151,7 @@ struct xfs_buf {
>  	int			b_io_error;	/* internal IO error state */
>  	wait_queue_head_t	b_waiters;	/* unpin waiters */
>  	struct list_head	b_list;
> +	struct list_head	b_delay;	/* delayed operations list */
>  	struct xfs_perag	*b_pag;		/* contains rbtree root */
>  	struct xfs_mount	*b_mount;
>  	struct xfs_buftarg	*b_target;	/* buffer target (device) */

The bare list-conveyance machinery looks fine to me, but adding 16 bytes
to struct xfs_buf for something that only happens during log recovery is
rather expensive.  Can you reuse b_list for this purpose?  I think the
only user of b_list are the buffer delwri functions, which shouldn't be
active here since the xattr recovery mechanism (a) holds the buffer lock
and (b) doesn't itself use delwri buffer lists for xattr leaf blocks.

(The AIL uses delwri lists, but it won't touch a locked buffer.)

> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 3f8a0713573a..046f21338c48 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -637,7 +637,7 @@ xfs_efi_item_recover(
>  
>  	}
>  
> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
>  
>  abort_error:
>  	xfs_trans_cancel(tp);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 10562ecbd9ea..6a3c0bb16b69 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2465,6 +2465,7 @@ xlog_finish_defer_ops(
>  	struct list_head	*capture_list)
>  {
>  	struct xfs_defer_capture *dfc, *next;
> +	struct xfs_buf		*bp, *bnext;
>  	struct xfs_trans	*tp;
>  	struct xfs_inode	*ip;
>  	int			error = 0;
> @@ -2489,6 +2490,12 @@ xlog_finish_defer_ops(
>  			return error;
>  		}
>  
> +		list_for_each_entry_safe(bp, bnext, &dfc->dfc_buffers, b_delay) {
> +			xfs_trans_bjoin(tp, bp);
> +			xfs_trans_bhold(tp, bp);
> +			list_del_init(&bp->b_delay);
> +		}

Why isn't this in xfs_defer_ops_continue, like the code that extracts
the inodes from the capture struct and hands them back to the caller?

> +
>  		/*
>  		 * Transfer to this new transaction all the dfops we captured
>  		 * from recovering a single intent item.
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 46904b793bd4..a6e7351ca4f9 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -557,7 +557,7 @@ xfs_cui_item_recover(
>  	}
>  
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
>  
>  abort_error:
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 5f0695980467..8c70a4af80a9 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -587,7 +587,7 @@ xfs_rui_item_recover(
>  	}
>  
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
>  
>  abort_error:
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> -- 
> 2.25.1
> 
