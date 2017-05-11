Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757847AbdEKQva (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 12:51:30 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A226E7F6AC
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 16:51:29 +0000 (UTC)
Date: Thu, 11 May 2017 12:51:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: Add infrastructure needed for error propagation
 during buffer IO failure
Message-ID: <20170511165124.GA14148@localhost.localdomain>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170511135733.21765-2-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 11, 2017 at 03:57:32PM +0200, Carlos Maiolino wrote:
> To be able to resubmit an log item for IO, we need a way to mark an item
> as failed, if, for any reason the buffer which the item belonged to
> failed during writeback.
> 
> Add a new log item callback to be used after an IO completion failure
> and make the needed clean ups.
> 

I think the commit log description should call out the problem with
flush locked items (i.e., that we will currently never resubmit their
buffers) as the motiviation for the patch.

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 27 ++++++++++++++++++++++++++-
>  fs/xfs/xfs_trans.h    |  5 ++++-
>  2 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 0306168..026aed4 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1051,6 +1051,24 @@ xfs_buf_do_callbacks(
>  	}
>  }
>  
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
> +		if (lip->li_ops->iop_error)
> +			lip->li_ops->iop_error(lip, bflags);

I still don't see why we need the iop callback here. This type of
callback is typically required when an operation requires some action on
the specific subtype (e.g., _inode_item_error() does one particular
thing to an inode, buf_item_error() might do something different to an
xfs_buf, etc.), but that doesn't appear to be the case here. Indeed, the
next patch shows that the inode item error handler does:

	lip->li_flags |= XFS_LI_FAILED;

... which doesn't even require to dereference the inode_log_item type.

So can we just set the flag directly from xfs_buf_do_callbacks_fail()
and kill of ->iop_error() until/unless we come to a point where it is
actually needed?

> +
> +		lip = next;
> +	}
> +}
> +
>  static bool
>  xfs_buf_iodone_callback_error(
>  	struct xfs_buf		*bp)
> @@ -1153,8 +1171,15 @@ xfs_buf_iodone_callbacks(
>  	 * to run callbacks after failure processing is done so we
>  	 * detect that and take appropriate action.
>  	 */
> -	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
> +	if (bp->b_error && xfs_buf_iodone_callback_error(bp)) {
> +
> +		/*
> +		 * We've got an error during buffer writeback, we need to notify
> +		 * the items in the buffer
> +		 */
> +		xfs_buf_do_callbacks_fail(bp);

xfs_buf_iodone_callback_error() returns true when the I/O has failed. It
also returns true when it has submitted the internal retry[1], however,
so I don't think this is quite correct. We should only mark items as
failed once this internal sequence has completed and the buffer is no
longer under I/O. As it is, this looks like it would mark the items as
failed while they are still under the internal retry I/O (and possibly
leave them marked as such if this retry actually succeeds..?).

Side note: I really dislike the semantics of
xfs_buf_iodone_callback_error() in that I have to read it and the only
call site to re-understand what the return value means every time I look
at it. Could we add a comment above that function that explains the
return value dictates whether to run callbacks while we're working in
this area?

Brian

[1] Recall that every buffer submitted through xfsaild() is quietly
retried one time in the event of I/O error (via XBF_WRITE_FAIL) before
the buffer is unlocked and effectively released back to the AIL. This is
presumably to help deal with transient errors. It is only when this
second I/O fails that the buffer is unlocked and it is up to the AIL to
resubmit the buffer on a subsequent push.

>  		return;
> +	}
>  
>  	/*
>  	 * Successful IO or permanent error. Either way, we can clear the
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index a07acbf..c57181a 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -65,10 +65,12 @@ typedef struct xfs_log_item {
>  
>  #define	XFS_LI_IN_AIL	0x1
>  #define XFS_LI_ABORTED	0x2
> +#define XFS_LI_FAILED	0x3
>  
>  #define XFS_LI_FLAGS \
>  	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
> -	{ XFS_LI_ABORTED,	"ABORTED" }
> +	{ XFS_LI_ABORTED,	"ABORTED" }, \
> +	{ XFS_LI_FAILED,	"FAILED" }
>  
>  struct xfs_item_ops {
>  	void (*iop_size)(xfs_log_item_t *, int *, int *);
> @@ -79,6 +81,7 @@ struct xfs_item_ops {
>  	void (*iop_unlock)(xfs_log_item_t *);
>  	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
>  	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
> +	void (*iop_error)(xfs_log_item_t *, unsigned int bflags);
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
