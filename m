Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAA6C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 032AC20738
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5015dOo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgFCO6w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 10:58:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50819 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725954AbgFCO6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 10:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591196330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QXLwRCw7dKkGBnKM9RLHwB4ioeL4iBMCy1MI/wGyxzY=;
        b=I5015dOo48eP4DLpUZuUNNAJ6J9TyioQt+Q3OPzaZwlPeqqvwDv69NO7I39df+lDvjcYEH
        +y3DwMcfD5ekj0RRWupR8VzuZrGJtdGYPtVSiGwnVmuYL1wPM27uSl5We4ifyqoRtz6Ppp
        5ZG3Po9jSdq7YddmN+zuXTm3H2djUWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-SP51ociIPTW5ro90hxhWNg-1; Wed, 03 Jun 2020 10:58:46 -0400
X-MC-Unique: SP51ociIPTW5ro90hxhWNg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A788C91135;
        Wed,  3 Jun 2020 14:58:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20F4410013D5;
        Wed,  3 Jun 2020 14:58:45 +0000 (UTC)
Date:   Wed, 3 Jun 2020 10:58:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/30] xfs: clean up the buffer iodone callback functions
Message-ID: <20200603145843.GE12332@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-12-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:32AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we've sorted inode and dquot buffers, we can apply the same
> cleanups to dirty buffers with buffer log items. They only have one
> callback, too, so we don't need the log item callback. Collapse the
> iodone functions and remove all the now unnecessary infrastructure
> around callback processing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item.c  | 140 +++++++++--------------------------------
>  fs/xfs/xfs_buf_item.h  |   1 -
>  fs/xfs/xfs_trans_buf.c |   2 -
>  3 files changed, 29 insertions(+), 114 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index f46e5ec28111c..0ece5de9dd711 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -30,7 +30,7 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
>  	return container_of(lip, struct xfs_buf_log_item, bli_item);
>  }
>  
> -STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
> +static void xfs_buf_item_done(struct xfs_buf *bp);
>  
>  /* Is this log iovec plausibly large enough to contain the buffer log format? */
>  bool
> @@ -462,9 +462,8 @@ xfs_buf_item_unpin(
>  		 * the AIL lock.
>  		 */
>  		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
> -			lip->li_cb(bp, lip);
> +			xfs_buf_item_done(bp);
>  			xfs_iflush_done(bp);
> -			bp->b_log_item = NULL;
>  		} else {
>  			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
>  			xfs_buf_item_relse(bp);
> @@ -973,46 +972,6 @@ xfs_buf_attach_iodone(
>  	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
>  }
>  
> -/*
> - * We can have many callbacks on a buffer. Running the callbacks individually
> - * can cause a lot of contention on the AIL lock, so we allow for a single
> - * callback to be able to scan the remaining items in bp->b_li_list for other
> - * items of the same type and callback to be processed in the first call.
> - *
> - * As a result, the loop walking the callback list below will also modify the
> - * list. it removes the first item from the list and then runs the callback.
> - * The loop then restarts from the new first item int the list. This allows the
> - * callback to scan and modify the list attached to the buffer and we don't
> - * have to care about maintaining a next item pointer.
> - */
> -STATIC void
> -xfs_buf_do_callbacks(
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_buf_log_item *blip = bp->b_log_item;
> -	struct xfs_log_item	*lip;
> -
> -	/* If there is a buf_log_item attached, run its callback */
> -	if (blip) {
> -		lip = &blip->bli_item;
> -		lip->li_cb(bp, lip);
> -	}
> -
> -	while (!list_empty(&bp->b_li_list)) {
> -		lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
> -				       li_bio_list);
> -
> -		/*
> -		 * Remove the item from the list, so we don't have any
> -		 * confusion if the item is added to another buf.
> -		 * Don't touch the log item after calling its
> -		 * callback, because it could have freed itself.
> -		 */
> -		list_del_init(&lip->li_bio_list);
> -		lip->li_cb(bp, lip);
> -	}
> -}
> -
>  /*
>   * Invoke the error state callback for each log item affected by the failed I/O.
>   *
> @@ -1025,8 +984,8 @@ STATIC void
>  xfs_buf_do_callbacks_fail(
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_ail		*ailp = bp->b_mount->m_ail;
>  	struct xfs_log_item	*lip;
> -	struct xfs_ail		*ailp;
>  
>  	/*
>  	 * Buffer log item errors are handled directly by xfs_buf_item_push()
> @@ -1036,9 +995,6 @@ xfs_buf_do_callbacks_fail(
>  	if (list_empty(&bp->b_li_list))
>  		return;
>  
> -	lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
> -			li_bio_list);
> -	ailp = lip->li_ailp;
>  	spin_lock(&ailp->ail_lock);
>  	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
>  		if (lip->li_ops->iop_error)
> @@ -1051,22 +1007,11 @@ static bool
>  xfs_buf_iodone_callback_error(
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf_log_item	*bip = bp->b_log_item;
> -	struct xfs_log_item	*lip;
> -	struct xfs_mount	*mp;
> +	struct xfs_mount	*mp = bp->b_mount;
>  	static ulong		lasttime;
>  	static xfs_buftarg_t	*lasttarg;
>  	struct xfs_error_cfg	*cfg;
>  
> -	/*
> -	 * The failed buffer might not have a buf_log_item attached or the
> -	 * log_item list might be empty. Get the mp from the available
> -	 * xfs_log_item
> -	 */
> -	lip = list_first_entry_or_null(&bp->b_li_list, struct xfs_log_item,
> -				       li_bio_list);
> -	mp = lip ? lip->li_mountp : bip->bli_item.li_mountp;
> -
>  	/*
>  	 * If we've already decided to shutdown the filesystem because of
>  	 * I/O errors, there's no point in giving this a retry.
> @@ -1171,14 +1116,27 @@ xfs_buf_had_callback_errors(
>  }
>  
>  static void
> -xfs_buf_run_callbacks(
> +xfs_buf_item_done(
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (!bip)
>  		return;
> -	xfs_buf_do_callbacks(bp);
> +
> +	/*
> +	 * If we are forcibly shutting down, this may well be off the AIL
> +	 * already. That's because we simulate the log-committed callbacks to
> +	 * unpin these buffers. Or we may never have put this item on AIL
> +	 * because of the transaction was aborted forcibly.
> +	 * xfs_trans_ail_delete() takes care of these.
> +	 *
> +	 * Either way, AIL is useless if we're forcing a shutdown.
> +	 */
> +	xfs_trans_ail_delete(&bip->bli_item, SHUTDOWN_CORRUPT_INCORE);
>  	bp->b_log_item = NULL;
> +	xfs_buf_item_free(bip);
> +	xfs_buf_rele(bp);
>  }
>  
>  /*
> @@ -1188,19 +1146,10 @@ void
>  xfs_buf_inode_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf_log_item *blip = bp->b_log_item;
> -	struct xfs_log_item	*lip;
> -
>  	if (xfs_buf_had_callback_errors(bp))
>  		return;
>  
> -	/* If there is a buf_log_item attached, run its callback */
> -	if (blip) {
> -		lip = &blip->bli_item;
> -		lip->li_cb(bp, lip);
> -		bp->b_log_item = NULL;
> -	}
> -
> +	xfs_buf_item_done(bp);
>  	xfs_iflush_done(bp);
>  	xfs_buf_ioend_finish(bp);
>  }
> @@ -1212,59 +1161,28 @@ void
>  xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf_log_item *blip = bp->b_log_item;
> -	struct xfs_log_item	*lip;
> -
>  	if (xfs_buf_had_callback_errors(bp))
>  		return;
>  
>  	/* a newly allocated dquot buffer might have a log item attached */
> -	if (blip) {
> -		lip = &blip->bli_item;
> -		lip->li_cb(bp, lip);
> -		bp->b_log_item = NULL;
> -	}
> -
> +	xfs_buf_item_done(bp);
>  	xfs_dquot_done(bp);
>  	xfs_buf_ioend_finish(bp);
>  }
>  
>  /*
>   * Dirty buffer iodone callback function.
> + *
> + * Note that for things like remote attribute buffers, there may not be a buffer
> + * log item here, so processing the buffer log item must remain be optional.
>   */
>  void
>  xfs_buf_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	xfs_buf_run_callbacks(bp);
> -	xfs_buf_ioend_finish(bp);
> -}
> -
> -/*
> - * This is the iodone() function for buffers which have been
> - * logged.  It is called when they are eventually flushed out.
> - * It should remove the buf item from the AIL, and free the buf item.
> - * It is called by xfs_buf_iodone_callbacks() above which will take
> - * care of cleaning up the buffer itself.
> - */
> -void
> -xfs_buf_item_iodone(
> -	struct xfs_buf		*bp,
> -	struct xfs_log_item	*lip)
> -{
> -	ASSERT(BUF_ITEM(lip)->bli_buf == bp);
> -
> -	xfs_buf_rele(bp);
> +	if (xfs_buf_had_callback_errors(bp))
> +		return;
>  
> -	/*
> -	 * If we are forcibly shutting down, this may well be off the AIL
> -	 * already. That's because we simulate the log-committed callbacks to
> -	 * unpin these buffers. Or we may never have put this item on AIL
> -	 * because of the transaction was aborted forcibly.
> -	 * xfs_trans_ail_delete() takes care of these.
> -	 *
> -	 * Either way, AIL is useless if we're forcing a shutdown.
> -	 */
> -	xfs_trans_ail_delete(lip, SHUTDOWN_CORRUPT_INCORE);
> -	xfs_buf_item_free(BUF_ITEM(lip));
> +	xfs_buf_item_done(bp);
> +	xfs_buf_ioend_finish(bp);
>  }
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 610cd00193289..7c0bd2a210aff 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -57,7 +57,6 @@ bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
>  void	xfs_buf_attach_iodone(struct xfs_buf *,
>  			      void(*)(struct xfs_buf *, struct xfs_log_item *),
>  			      struct xfs_log_item *);
> -void	xfs_buf_item_iodone(struct xfs_buf *, struct xfs_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
>  void	xfs_buf_dquot_iodone(struct xfs_buf *);
>  void	xfs_buf_iodone(struct xfs_buf *);
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 6752676b94fe7..11cd666cd99a6 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -475,7 +475,6 @@ xfs_trans_dirty_buf(
>  	bp->b_flags |= XBF_DONE;
>  
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
> -	bip->bli_item.li_cb = xfs_buf_item_iodone;
>  
>  	/*
>  	 * If we invalidated the buffer within this transaction, then
> @@ -644,7 +643,6 @@ xfs_trans_stale_inode_buf(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
>  	bip->bli_flags |= XFS_BLI_STALE_INODE;
> -	bip->bli_item.li_cb = xfs_buf_item_iodone;
>  	bp->b_flags |= _XBF_INODES;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 

