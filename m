Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762142AbdAEPBX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Jan 2017 10:01:23 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 556A061B91
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jan 2017 15:01:15 +0000 (UTC)
Date: Thu, 5 Jan 2017 10:01:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] [RFC] Propagate error state from buffers to the objects
 attached
Message-ID: <20170105150113.GB3345@bfoster.bfoster>
References: <20170104184609.1102-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170104184609.1102-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 04, 2017 at 07:46:09PM +0100, Carlos Maiolino wrote:
> Hi folks,
> 
> I've been working on a problem regarding buffers that failed to be written back
> not being retried as they should, because the items attached to it were flush
> locked.
> 
> Discussing the problem previously with Dave and Brian, Dave suggested that first
> we create an error propagation model, so notify items in case of a failure with
> the buffer.
> 

Hi Carlos,

Firstly, it's probably a good idea to reference the previous discussion
for context. That is available here:

  http://www.spinics.net/lists/linux-xfs/msg01018.html

There is some noise due to confusion between Dave and I, but the last
couple messages or so describe the design required to resolve the
problem.

> Based on that discussion, I've been playing with a prototype for this, and I
> thought about sending it here so I can get some extra input about the model and
> if I'm on the right direction (or not :)
> 
> The basic idea is to modify xfs_buf_iodone_callbacks() to trigger the iodone
> callbacks of the items attached to the buffer, or, in case of failure, trigger a
> callback to notify the items about the error, where, we can propagate the buffer
> error flags to the items attached to it.
> 
> Currently, we only run the callbacks in case of success or a permanent error,
> items are not aware of any temporary error, since no callbacks are triggered,
> which (in my specific case), can lead to an item to be flush locked forever.
> 

Right.. so the core issue is that log item retry (after non-permanent
metadata I/O failure) for flush locked items is broken. This is because
1.) the first item push flush locks the object and it must remain flush
locked until the associated buffer makes it to disk and 2.) a subsequent
AIL push skips any object that is already flush locked. The example
we're running into is for inodes, but IIRC this problem applies to
xfs_dquot's as well, so we'll want to cover that with this work as well.

(It's good to provide such a problem summary in a cover letter and/or
commit log description for follow on posts. Feel free to steal from the
example I wrote up in the old thread..).

> I though that xfs_item_ops structure fits well for an error notification
> callback.
> 
> xfs_inode_item_push() is a place where we keep spinning in the items deadly
> flush locked, so I've added some code there just for my testing here.
> 
> Does this notification model makes sense? Anything that I am missing? This is
> the first time I'm working into buffer code, so I'm not much sure if what I'm
> doing is right or not, so any comments are much appreciated.
> 
> I expect to send a 'final version' of this patch together with the fix for the
> flush deadlocked items, but I want to make sure that I'm following the right
> direction with this error propagation model.
> 
> Cheers
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c   | 27 ++++++++++++++++++++++++++-
>  fs/xfs/xfs_inode.h      |  2 ++
>  fs/xfs/xfs_inode_item.c | 24 +++++++++++++++++++++++-
>  fs/xfs/xfs_trans.h      |  1 +
>  4 files changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 2975cb2..14355ea 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1051,6 +1051,28 @@ xfs_buf_do_callbacks(
>  	}
>  }
>  
> +/*
> + * We can't modify the list buffer item list here, it is supposed to be called
> + * on temporary I/O errors only, such buffer list can be used again
> + */
> +STATIC void
> +xfs_buf_do_callbacks_fail(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip, *next;
> +	unsigned int		bflags = bp->b_flags;
> +
> +	lip = bp->b_fspriv;
> +	while (lip != NULL) {
> +		next = lip->li_bio_list;
> +
> +		if(lip->li_ops->iop_error)
> +			lip->li_ops->iop_error(lip, bflags);
> +
> +		lip = next;
> +	}
> +}

Do we really need a new iop callback for this? Could we define a new
xfs_log_item->li_flags flag (XFS_LI_FAILED) that we can set directly
from the iodone path instead?

> +
>  static bool
>  xfs_buf_iodone_callback_error(
>  	struct xfs_buf		*bp)
> @@ -1148,13 +1170,16 @@ void
>  xfs_buf_iodone_callbacks(
>  	struct xfs_buf		*bp)
>  {
> +
>  	/*
>  	 * If there is an error, process it. Some errors require us
>  	 * to run callbacks after failure processing is done so we
>  	 * detect that and take appropriate action.
>  	 */
> -	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
> +	if (bp->b_error && xfs_buf_iodone_callback_error(bp)) {
> +		xfs_buf_do_callbacks_fail(bp);

However we set the failed state on the log item, we probably want to
invoke it from inside of xfs_buf_iodone_callback_error() (in particular,
in the case where we've already done the single retry and failed).

With the current logic, it looks like we'd actually mark the items as
failed after the latter function has also issued the single automatic
retry before the AIL becomes responsible for further retries. A generic
flag would also result in less code for each item (as previously noted,
we also need to deal with xfs_dquot).

>  		return;
> +	}
>  
>  	/*
>  	 * Successful IO or permanent error. Either way, we can clear the
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 10dcf27..f98b0c6 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -232,6 +232,8 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
>   */
>  #define XFS_IRECOVERY		(1 << 11)
>  
> +#define XFS_IBFAIL		(1 << 12) /* Failed to flush buffer */
> +
>  /*
>   * Per-lifetime flags need to be reset when re-using a reclaimable inode during
>   * inode lookup. This prevents unintended behaviour on the new inode from
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index d90e781..70206c61 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -475,6 +475,17 @@ xfs_inode_item_unpin(
>  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
>  }
>  
> +STATIC void
> +xfs_inode_item_error(
> +	struct xfs_log_item	*lip,
> +	unsigned int		bflags)
> +{
> +	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
> +
> +	if (bflags & XBF_WRITE_FAIL)
> +		ip->i_flags |= XFS_IBFAIL;
> +}
> +
>  STATIC uint
>  xfs_inode_item_push(
>  	struct xfs_log_item	*lip,
> @@ -512,6 +523,16 @@ xfs_inode_item_push(
>  	}
>  
>  	/*
> +	 * EXAMPLE:
> +	 *	Have we already tried to submit the buffer attached to this
> +	 *	inode, and has it failed?
> +	 */
> +	if (ip->i_flags & XFS_IBFAIL) {
> +		printk("XFS: %s: inode buffer already submitted. ino: %llu\n",
> +		       __func__, ip->i_ino);
> +	}

I think we only care about the new failure case when the flush lock is
not acquired. At that point we have to continue on and verify that the
buffer was marked as failed as well and then resubmit the buffer.

FWIW, I think it might be a good idea to break this down into at least a
few patches. One to add generic error propagation infrastructure and
subsequent to process the error state in the appropriate log item
handlers.

Brian

> +
> +	/*
>  	 * Someone else is already flushing the inode.  Nothing we can do
>  	 * here but wait for the flush to finish and remove the item from
>  	 * the AIL.
> @@ -622,7 +643,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
>  	.iop_unlock	= xfs_inode_item_unlock,
>  	.iop_committed	= xfs_inode_item_committed,
>  	.iop_push	= xfs_inode_item_push,
> -	.iop_committing = xfs_inode_item_committing
> +	.iop_committing = xfs_inode_item_committing,
> +	.iop_error	= xfs_inode_item_error
>  };
>  
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 61b7fbd..e620e6a 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -80,6 +80,7 @@ struct xfs_item_ops {
>  	void (*iop_unlock)(xfs_log_item_t *);
>  	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
>  	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
> +	void (*iop_error)(struct xfs_log_item *, unsigned int bflags);
>  };
>  
>  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
