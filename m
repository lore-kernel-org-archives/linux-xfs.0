Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7F4C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928922072F
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:45:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aBfvuRTV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgFBQpo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:45:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22512 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726894AbgFBQpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 12:45:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591116340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=71sPvvyeWFrWcCj6mtogC7pjaqxhlm0Qs18vyI7soWE=;
        b=aBfvuRTV7BLXpLQj6UsJ4KyHqOKPNEl72MKC/OGDWX32MypyPaYf0qcPY76TRi3f4XYhrg
        GrhU3Yy4XtgQdDCsQ12ulSjmJ4tBzf2HDQpb2AgiLH3I7/K5k9qIWqQHfNcPQkcKE8woNd
        EqSNmRmSWtMRQlYIjGPsM0QUT1jXobM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-vPjzrh_1PwOquzmL4fW5fg-1; Tue, 02 Jun 2020 12:45:38 -0400
X-MC-Unique: vPjzrh_1PwOquzmL4fW5fg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4674100CCC1;
        Tue,  2 Jun 2020 16:45:37 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EAA078EF6;
        Tue,  2 Jun 2020 16:45:37 +0000 (UTC)
Date:   Tue, 2 Jun 2020 12:45:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/30] xfs: mark inode buffers in cache
Message-ID: <20200602164535.GD7967@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-5-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:25AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode buffers always have write IO callbacks, so by marking them
> directly we can avoid needing to attach ->b_iodone functions to
> them. This avoids an indirect call, and makes future modifications
> much simpler.
> 
> This is largely a rearrangement of the code at this point - no IO
> completion functionality changes at this point, just how the
> code is run is modified.
> 

Ok, I was initially thinking this patch looked incomplete in that we
continue to set ->b_iodone() on inode buffers even though we'd never
call it. Looking ahead, I see that the next few patches continue to
clean that up to eventually remove ->b_iodone(), so that addresses that.

My only other curiosity is that while there may not be any functional
difference, this technically changes callback behavior in that we set
the new flag in some contexts that don't currently attach anything to
the buffer, right? E.g., xfs_trans_inode_alloc_buf() sets the flag on
inode chunk init, which means we can write out an inode buffer without
any attached/flushed inodes. Is the intent of that to support future
changes? If so, a note about that in the commit log would be helpful.

Brian

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c       | 21 ++++++++++++++++-----
>  fs/xfs/xfs_buf.h       | 38 +++++++++++++++++++++++++-------------
>  fs/xfs/xfs_buf_item.c  | 42 +++++++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_buf_item.h  |  1 +
>  fs/xfs/xfs_inode.c     |  2 +-
>  fs/xfs/xfs_trans_buf.c |  3 +++
>  6 files changed, 77 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9c2fbb6bbf89d..fcf650575be61 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -14,6 +14,8 @@
>  #include "xfs_mount.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_trans.h"
> +#include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  
> @@ -1202,12 +1204,21 @@ xfs_buf_ioend(
>  		bp->b_flags |= XBF_DONE;
>  	}
>  
> -	if (bp->b_iodone)
> +	if (read)
> +		goto out_finish;
> +
> +	if (bp->b_flags & _XBF_INODES) {
> +		xfs_buf_inode_iodone(bp);
> +		return;
> +	}
> +
> +	if (bp->b_iodone) {
>  		(*(bp->b_iodone))(bp);
> -	else if (bp->b_flags & XBF_ASYNC)
> -		xfs_buf_relse(bp);
> -	else
> -		complete(&bp->b_iowait);
> +		return;
> +	}
> +
> +out_finish:
> +	xfs_buf_ioend_finish(bp);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 050c53b739e24..2400cb90a04c6 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -30,15 +30,18 @@
>  #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
>  #define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
>  
> -/* flags used only as arguments to access routines */
> -#define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
> -#define XBF_UNMAPPED	 (1 << 17)/* do not map the buffer */
> +/* buffer type flags for write callbacks */
> +#define _XBF_INODES	 (1 << 16)/* inode buffer */
>  
>  /* flags used only internally */
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
>  #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
>  
> +/* flags used only as arguments to access routines */
> +#define XBF_TRYLOCK	 (1 << 30)/* lock requested, but do not wait */
> +#define XBF_UNMAPPED	 (1 << 31)/* do not map the buffer */
> +
>  typedef unsigned int xfs_buf_flags_t;
>  
>  #define XFS_BUF_FLAGS \
> @@ -50,12 +53,13 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_DONE,		"DONE" }, \
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
> -	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
> -	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
> +	{ _XBF_INODES,		"INODES" }, \
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
> -	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
> -
> +	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> +	/* The following interface flags should never be set */ \
> +	{ XBF_TRYLOCK,		"TRYLOCK" }, \
> +	{ XBF_UNMAPPED,		"UNMAPPED" }
>  
>  /*
>   * Internal state flags.
> @@ -257,9 +261,23 @@ extern void xfs_buf_unlock(xfs_buf_t *);
>  #define xfs_buf_islocked(bp) \
>  	((bp)->b_sema.count <= 0)
>  
> +static inline void xfs_buf_relse(xfs_buf_t *bp)
> +{
> +	xfs_buf_unlock(bp);
> +	xfs_buf_rele(bp);
> +}
> +
>  /* Buffer Read and Write Routines */
>  extern int xfs_bwrite(struct xfs_buf *bp);
>  extern void xfs_buf_ioend(struct xfs_buf *bp);
> +static inline void xfs_buf_ioend_finish(struct xfs_buf *bp)
> +{
> +	if (bp->b_flags & XBF_ASYNC)
> +		xfs_buf_relse(bp);
> +	else
> +		complete(&bp->b_iowait);
> +}
> +
>  extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
>  		xfs_failaddr_t failaddr);
>  #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
> @@ -324,12 +342,6 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
>  	return atomic_read(&bp->b_pin_count);
>  }
>  
> -static inline void xfs_buf_relse(xfs_buf_t *bp)
> -{
> -	xfs_buf_unlock(bp);
> -	xfs_buf_rele(bp);
> -}
> -
>  static inline int
>  xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  {
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 9e75e8d6042ec..8659cf4282a64 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1158,20 +1158,15 @@ xfs_buf_iodone_callback_error(
>  	return false;
>  }
>  
> -/*
> - * This is the iodone() function for buffers which have had callbacks attached
> - * to them by xfs_buf_attach_iodone(). We need to iterate the items on the
> - * callback list, mark the buffer as having no more callbacks and then push the
> - * buffer through IO completion processing.
> - */
> -void
> -xfs_buf_iodone_callbacks(
> +static void
> +xfs_buf_run_callbacks(
>  	struct xfs_buf		*bp)
>  {
> +
>  	/*
> -	 * If there is an error, process it. Some errors require us
> -	 * to run callbacks after failure processing is done so we
> -	 * detect that and take appropriate action.
> +	 * If there is an error, process it. Some errors require us to run
> +	 * callbacks after failure processing is done so we detect that and take
> +	 * appropriate action.
>  	 */
>  	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
>  		return;
> @@ -1188,9 +1183,34 @@ xfs_buf_iodone_callbacks(
>  	bp->b_log_item = NULL;
>  	list_del_init(&bp->b_li_list);
>  	bp->b_iodone = NULL;
> +}
> +
> +/*
> + * This is the iodone() function for buffers which have had callbacks attached
> + * to them by xfs_buf_attach_iodone(). We need to iterate the items on the
> + * callback list, mark the buffer as having no more callbacks and then push the
> + * buffer through IO completion processing.
> + */
> +void
> +xfs_buf_iodone_callbacks(
> +	struct xfs_buf		*bp)
> +{
> +	xfs_buf_run_callbacks(bp);
>  	xfs_buf_ioend(bp);
>  }
>  
> +/*
> + * Inode buffer iodone callback function.
> + */
> +void
> +xfs_buf_inode_iodone(
> +	struct xfs_buf		*bp)
> +{
> +	xfs_buf_run_callbacks(bp);
> +	xfs_buf_ioend_finish(bp);
> +}
> +
> +
>  /*
>   * This is the iodone() function for buffers which have been
>   * logged.  It is called when they are eventually flushed out.
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index c9c57e2da9327..a342933ad9b8d 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -59,6 +59,7 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
>  			      struct xfs_log_item *);
>  void	xfs_buf_iodone_callbacks(struct xfs_buf *);
>  void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
> +void	xfs_buf_inode_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
>  
>  extern kmem_zone_t	*xfs_buf_item_zone;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ac3c8af8c9a14..d5dee57f914a9 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3860,13 +3860,13 @@ xfs_iflush_int(
>  	 * completion on the buffer to remove the inode from the AIL and release
>  	 * the flush lock.
>  	 */
> +	bp->b_flags |= _XBF_INODES;
>  	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
>  
>  	/* generate the checksum. */
>  	xfs_dinode_calc_crc(mp, dip);
>  
>  	ASSERT(!list_empty(&bp->b_li_list));
> -	ASSERT(bp->b_iodone != NULL);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 08174ffa21189..552d0869aa0fe 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -626,6 +626,7 @@ xfs_trans_inode_buf(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
>  	bip->bli_flags |= XFS_BLI_INODE_BUF;
> +	bp->b_flags |= _XBF_INODES;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> @@ -651,6 +652,7 @@ xfs_trans_stale_inode_buf(
>  
>  	bip->bli_flags |= XFS_BLI_STALE_INODE;
>  	bip->bli_item.li_cb = xfs_buf_iodone;
> +	bp->b_flags |= _XBF_INODES;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> @@ -675,6 +677,7 @@ xfs_trans_inode_alloc_buf(
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  
>  	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
> +	bp->b_flags |= _XBF_INODES;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
>  
> -- 
> 2.26.2.761.g0e0b3e54be
> 

