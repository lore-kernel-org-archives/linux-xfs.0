Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752718AbdK1Rz6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Nov 2017 12:55:58 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBBAB7EA80
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:55:58 +0000 (UTC)
Date: Tue, 28 Nov 2017 12:55:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: Properly retry failed dquot items in case of
 error during buffer writeback
Message-ID: <20171128175553.GA47056@bfoster.bfoster>
References: <20171128143101.18861-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128143101.18861-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 03:31:01PM +0100, Carlos Maiolino wrote:
> Once the inode item writeback errors is already fixed, it's time to fix the same
> problem in dquot code.
> 
> Although there were no reports of users hitting this bug in dquot code (at least
> none I've seen), the bug is there and I was already planning to fix it when the
> correct approach to fix the inodes part was decided.
> 
> This patch aims to fix the same problem in dquot code, regarding failed buffers
> being unable to be resubmitted once they are flush locked.
> 
> Tested with the recently test-case sent to fstests list by Hou Tao.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> V2:
> 	- in xfs_dquot.c
> 	  ..Add a couple of parentheses around lip->li_flags & XFS_LI_FAILED
> 	- in xfs_dquot_item.c:
> 	  ..Add missing blank line between variable definiton and code
> 	  ..Initialize dqp pointer out of variable definition to shut up
> 	    gcc's 'unused variable' warning
> 
>  fs/xfs/xfs_dquot.c      | 11 ++++++++---
>  fs/xfs/xfs_dquot_item.c | 40 ++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 46 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d57c2db64e59..b2bafa284253 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -970,14 +970,19 @@ xfs_qm_dqflush_done(
>  	 * holding the lock before removing the dquot from the AIL.
>  	 */
>  	if ((lip->li_flags & XFS_LI_IN_AIL) &&
> -	    lip->li_lsn == qip->qli_flush_lsn) {
> +	    ((lip->li_lsn == qip->qli_flush_lsn) ||
> +	     (lip->li_flags & XFS_LI_FAILED))) {
>  
>  		/* xfs_trans_ail_delete() drops the AIL lock. */
>  		spin_lock(&ailp->xa_lock);
> -		if (lip->li_lsn == qip->qli_flush_lsn)
> +		if (lip->li_lsn == qip->qli_flush_lsn) {
>  			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> -		else
> +		} else if (lip->li_flags & XFS_LI_FAILED) {
> +			xfs_clear_li_failed(lip);
>  			spin_unlock(&ailp->xa_lock);
> +		} else {
> +			spin_unlock(&ailp->xa_lock);
> +		}

Nit, but the following looks a bit cleaner to me:

		if ((ip->li_lsn == qip->qli_flush_lsn) {
			xfs_trans_ail_delete(...);
		} else {
			/*
			 * clear the failed state since we're about to drop the
			 * flush lock
			 */
			if (lip->li_flags & XFS_LI_FAILED)
				xfs_clear_li_failed(lip);
			spin_unlock();
		}

Otherwise looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 2c7a1629e064..664dea105e76 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -137,6 +137,26 @@ xfs_qm_dqunpin_wait(
>  	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
>  }
>  
> +/*
> + * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
> + * have been failed during writeback
> + *
> + * this informs the AIL that the dquot is already flush locked on the next push,
> + * and acquires a hold on the buffer to ensure that it isn't reclaimed before
> + * dirty data makes it to disk.
> + */
> +STATIC void
> +xfs_dquot_item_error(
> +	struct xfs_log_item	*lip,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_dquot	*dqp;
> +
> +	dqp = DQUOT_ITEM(lip)->qli_dquot;
> +	ASSERT(!completion_done(&dqp->q_flush));
> +	xfs_set_li_failed(lip, bp);
> +}
> +
>  STATIC uint
>  xfs_qm_dquot_logitem_push(
>  	struct xfs_log_item	*lip,
> @@ -144,13 +164,28 @@ xfs_qm_dquot_logitem_push(
>  					      __acquires(&lip->li_ailp->xa_lock)
>  {
>  	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
> -	struct xfs_buf		*bp = NULL;
> +	struct xfs_buf		*bp = lip->li_buf;
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
>  	if (atomic_read(&dqp->q_pincount) > 0)
>  		return XFS_ITEM_PINNED;
>  
> +	/*
> +	 * The buffer containing this item failed to be written back
> +	 * previously. Resubmit the buffer for IO
> +	 */
> +	if (lip->li_flags & XFS_LI_FAILED) {
> +		if (!xfs_buf_trylock(bp))
> +			return XFS_ITEM_LOCKED;
> +
> +		if (!xfs_buf_resubmit_failed_buffers(bp, lip, buffer_list))
> +			rval = XFS_ITEM_FLUSHING;
> +
> +		xfs_buf_unlock(bp);
> +		return rval;
> +	}
> +
>  	if (!xfs_dqlock_nowait(dqp))
>  		return XFS_ITEM_LOCKED;
>  
> @@ -242,7 +277,8 @@ static const struct xfs_item_ops xfs_dquot_item_ops = {
>  	.iop_unlock	= xfs_qm_dquot_logitem_unlock,
>  	.iop_committed	= xfs_qm_dquot_logitem_committed,
>  	.iop_push	= xfs_qm_dquot_logitem_push,
> -	.iop_committing = xfs_qm_dquot_logitem_committing
> +	.iop_committing = xfs_qm_dquot_logitem_committing,
> +	.iop_error	= xfs_dquot_item_error
>  };
>  
>  /*
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
