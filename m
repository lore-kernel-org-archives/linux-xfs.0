Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5086C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01B420738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:47:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W1vM+jSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgFBQrt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:47:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53089 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgFBQrs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 12:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591116467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ODigNoy1zKPBnNR6J+OOKAY/v57MJSkNlHGa6Pl4bJg=;
        b=W1vM+jSonccPP3xGMZJyycBckO+oNNKXON+RM+8h+ICQ2bjYwcfsVjueIY6FUZe7ODn8JP
        MJoj4P3FQ8fPpKipGbSMLnJYn0IBLTd4oorXiZCHXEp0YicUJR3yy7tpL9f/DFYEbImUfh
        dB392paey9Vb6CVdqNdsrBcro0WerlM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-8MT2ysNwMz-moJx1CSi57A-1; Tue, 02 Jun 2020 12:47:45 -0400
X-MC-Unique: 8MT2ysNwMz-moJx1CSi57A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F5AF805731;
        Tue,  2 Jun 2020 16:47:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15BCF7F4C1;
        Tue,  2 Jun 2020 16:47:44 +0000 (UTC)
Date:   Tue, 2 Jun 2020 12:47:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/30] xfs: call xfs_buf_iodone directly
Message-ID: <20200602164742.GG7967@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-8-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:28AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> All unmarked dirty buffers should be in the AIL and have log items
> attached to them. Hence when they are written, we will run a
> callback to remove the item from the AIL if appropriate. Now that
> we've handled inode and dquot buffers, all remaining calls are to
> xfs_buf_iodone() and so we can hard code this rather than use an
> indirect call.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/xfs_buf.c       | 24 ++++++++----------------
>  fs/xfs/xfs_buf.h       |  6 +-----
>  fs/xfs/xfs_buf_item.c  | 40 ++++++++++------------------------------
>  fs/xfs/xfs_buf_item.h  |  4 ++--
>  fs/xfs/xfs_trans_buf.c | 13 +++----------
>  5 files changed, 24 insertions(+), 63 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 0a69de674af9d..d7695b638e994 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
...
> @@ -1226,14 +1225,7 @@ xfs_buf_ioend(
>  		xfs_buf_dquot_iodone(bp);
>  		return;
>  	}
> -
> -	if (bp->b_iodone) {
> -		(*(bp->b_iodone))(bp);
> -		return;
> -	}
> -
> -out_finish:
> -	xfs_buf_ioend_finish(bp);
> +	xfs_buf_iodone(bp);

The way this function ends up would probably look nicer as an if/else
chain rather than a sequence of internal return statements.

>  }
>  
>  static void
...
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index a42cdf9ccc47d..d87ae6363a130 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
...
> @@ -1182,28 +1166,24 @@ xfs_buf_run_callbacks(
>  	xfs_buf_do_callbacks(bp);
>  	bp->b_log_item = NULL;
>  	list_del_init(&bp->b_li_list);
> -	bp->b_iodone = NULL;
>  }
>  
>  /*
> - * This is the iodone() function for buffers which have had callbacks attached
> - * to them by xfs_buf_attach_iodone(). We need to iterate the items on the
> - * callback list, mark the buffer as having no more callbacks and then push the
> - * buffer through IO completion processing.
> + * Inode buffer iodone callback function.
>   */
>  void
> -xfs_buf_iodone_callbacks(
> +xfs_buf_inode_iodone(
>  	struct xfs_buf		*bp)
>  {
>  	xfs_buf_run_callbacks(bp);
> -	xfs_buf_ioend(bp);
> +	xfs_buf_ioend_finish(bp);
>  }
>  
>  /*
> - * Inode buffer iodone callback function.
> + * Dquot buffer iodone callback function.
>   */
>  void
> -xfs_buf_inode_iodone(
> +xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
>  	xfs_buf_run_callbacks(bp);
> @@ -1211,10 +1191,10 @@ xfs_buf_inode_iodone(
>  }
>  
>  /*
> - * Dquot buffer iodone callback function.
> + * Dirty buffer iodone callback function.
>   */
>  void
> -xfs_buf_dquot_iodone(
> +xfs_buf_iodone(
>  	struct xfs_buf		*bp)
>  {
>  	xfs_buf_run_callbacks(bp);
> @@ -1229,7 +1209,7 @@ xfs_buf_dquot_iodone(
>   * care of cleaning up the buffer itself.
>   */
>  void
> -xfs_buf_iodone(
> +xfs_buf_item_iodone(
>  	struct xfs_buf		*bp,
>  	struct xfs_log_item	*lip)
>  {

Wow, that's a nasty diff. Another recent instance where 'git show
--patience' comes in handy... :)

BTW, is there a longer term need to have three separate iodone functions
here that do the same thing?

Brian

> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 27d13d29b5bbb..610cd00193289 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -57,10 +57,10 @@ bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
>  void	xfs_buf_attach_iodone(struct xfs_buf *,
>  			      void(*)(struct xfs_buf *, struct xfs_log_item *),
>  			      struct xfs_log_item *);
> -void	xfs_buf_iodone_callbacks(struct xfs_buf *);
> -void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
> +void	xfs_buf_item_iodone(struct xfs_buf *, struct xfs_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
>  void	xfs_buf_dquot_iodone(struct xfs_buf *);
> +void	xfs_buf_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
>  
>  extern kmem_zone_t	*xfs_buf_item_zone;
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 93d62cb864c15..6752676b94fe7 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -465,24 +465,17 @@ xfs_trans_dirty_buf(
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> -	ASSERT(bp->b_iodone == NULL ||
> -	       bp->b_iodone == xfs_buf_iodone_callbacks);
>  
>  	/*
>  	 * Mark the buffer as needing to be written out eventually,
>  	 * and set its iodone function to remove the buffer's buf log
>  	 * item from the AIL and free it when the buffer is flushed
> -	 * to disk.  See xfs_buf_attach_iodone() for more details
> -	 * on li_cb and xfs_buf_iodone_callbacks().
> -	 * If we end up aborting this transaction, we trap this buffer
> -	 * inside the b_bdstrat callback so that this won't get written to
> -	 * disk.
> +	 * to disk.
>  	 */
>  	bp->b_flags |= XBF_DONE;
>  
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
> -	bp->b_iodone = xfs_buf_iodone_callbacks;
> -	bip->bli_item.li_cb = xfs_buf_iodone;
> +	bip->bli_item.li_cb = xfs_buf_item_iodone;
>  
>  	/*
>  	 * If we invalidated the buffer within this transaction, then
> @@ -651,7 +644,7 @@ xfs_trans_stale_inode_buf(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
>  	bip->bli_flags |= XFS_BLI_STALE_INODE;
> -	bip->bli_item.li_cb = xfs_buf_iodone;
> +	bip->bli_item.li_cb = xfs_buf_item_iodone;
>  	bp->b_flags |= _XBF_INODES;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 

