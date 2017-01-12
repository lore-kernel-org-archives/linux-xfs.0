Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750731AbdALPix (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jan 2017 10:38:53 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E20721722
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2017 15:38:54 +0000 (UTC)
Date: Thu, 12 Jan 2017 10:38:52 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] [WIP] Propagate error state from buffers to the objects
 attached
Message-ID: <20170112153852.GF14085@bfoster.bfoster>
References: <20170112142209.23458-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170112142209.23458-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 12, 2017 at 03:22:09PM +0100, Carlos Maiolino wrote:
> Hi folks,
> 
> this is a new version of my possible fix to the error propagation model plus the
> fix to the locked AIL items, both things are merged together since I'm using the
> fix to the locked items to test the error propagation model, I'll split them
> between different patches and also include dquot fixes when we agree that I'm on
> the right path.
> 
> This new version adds Brian's suggestion to use a new flag for the xfs_log_item
> instead of a callback. and uses the flag into xfs_inode_item_push, to resubmit
> the buffer or not.
> 
> Also, the logic about when to set the flag has been moved into
> xfs_buf_iodone_callback_error, so we only check that after the last buffer
> resubmission.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c   |  6 ++++++
>  fs/xfs/xfs_inode_item.c | 33 +++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_trans.h      |  4 +++-
>  3 files changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 2975cb2..16896d5 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1123,6 +1123,12 @@ xfs_buf_iodone_callback_error(
>  	/* still a transient error, higher layers will retry */
>  	xfs_buf_ioerror(bp, 0);
>  	xfs_buf_relse(bp);
> +
> +	/*
> +	 * Notify log item that the buffer has been failed so it can be retried
> +	 * later if needed
> +	 */
> +	lip->li_flags |= XFS_LI_FAILED;

Looks like the right idea to me. We might want to set this before we
release the buffer though. Perhaps move it a few lines up and combine
this comment with the "transient error" comment above..?

>  	return true;
>  
>  	/*
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index d90e781..308aa27 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -517,8 +517,37 @@ xfs_inode_item_push(
>  	 * the AIL.
>  	 */
>  	if (!xfs_iflock_nowait(ip)) {
> -		rval = XFS_ITEM_FLUSHING;
> -		goto out_unlock;
> +		int error;
> +		struct xfs_dinode *dip;
> +
> +		/* Buffer carrying this item has been failed, we must resubmit
> +		 * the buffer or the item will be locked forever
> +		 */

I'd suggest to reference the flush lock specifically, in particular how
it's locked once and remains so until the flushed content makes it to
disk (across I/O failures and retries if necessary).

Note that the comment above the 'if (!xfs_iflock_nowait())' above will
probably need an update as well.

> +		if (lip->li_flags & XFS_LI_FAILED) {
> +			printk("#### ITEM BUFFER FAILED PREVIOUSLY, inode: %llu\n",
> +			       ip->i_ino);
> +			error = xfs_imap_to_bp(ip->i_mount, NULL, &ip->i_imap,
> +					       &dip, &bp, XBF_TRYLOCK, 0);
> +
> +			if (error) {
> +				rval = XFS_ITEM_FLUSHING;
> +				goto out_unlock;
> +			}
> +
> +			if (!(bp->b_flags & XBF_WRITE_FAIL)) {
> +				rval = XFS_ITEM_FLUSHING;
> +				xfs_buf_relse(bp);
> +				goto out_unlock;
> +			}
> +
> +			if (!xfs_buf_delwri_queue(bp, buffer_list)) {
> +				printk("#### QUEUEING AGAIN\n");
> +				rval = XFS_ITEM_FLUSHING;
> +			}
> +

We need to clear the LI_FAILED state once we've queued it for retry. We
may also want to do the same for all other LI_FAILED log items attached
to the buffer so we don't lock the buffer a bunch of times. For
example, add a helper to walk the log items and clear the failure flag.
(That could be a separate patch in the series though).

Those things aside this looks like it's on the right track to me. Thanks
Carlos.

Brian

> +			xfs_buf_relse(bp);
> +			goto out_unlock;
> +		}
>  	}
>  
>  	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 61b7fbd..d62d174 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -66,10 +66,12 @@ typedef struct xfs_log_item {
>  
>  #define	XFS_LI_IN_AIL	0x1
>  #define XFS_LI_ABORTED	0x2
> +#define	XFS_LI_FAILED	0x3
>  
>  #define XFS_LI_FLAGS \
>  	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
> -	{ XFS_LI_ABORTED,	"ABORTED" }
> +	{ XFS_LI_ABORTED,	"ABORTED"}, \
> +	{ XFS_LI_FAILED,	"FAILED" }
>  
>  struct xfs_item_ops {
>  	void (*iop_size)(xfs_log_item_t *, int *, int *);
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
