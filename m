Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42306 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbeCNSfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 14:35:45 -0400
Date: Wed, 14 Mar 2018 11:35:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/8] xfs: refactor xfs_log_force_lsn
Message-ID: <20180314183540.GT4865@magnolia>
References: <20180313104927.12926-1-hch@lst.de>
 <20180313104927.12926-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313104927.12926-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 11:49:26AM +0100, Christoph Hellwig wrote:
> Use the the smallest possible loop as preable to find the correct iclog
> buffer, and then use gotos for unwinding to straighten the code.

"Use the smallest possible loop to find the correct iclog..." ?

> 
> Also fix the top of function comment while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 142 ++++++++++++++++++++++++-------------------------------
>  1 file changed, 62 insertions(+), 80 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a37a8defcd39..b6c6f227b2d7 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3404,11 +3404,10 @@ xfs_log_force(
>   *		state and go to sleep or return.
>   *	If it is in any other state, go to sleep or return.
>   *
> - * Synchronous forces are implemented with a signal variable. All callers
> - * to force a given lsn to disk will wait on a the sv attached to the
> - * specific in-core log.  When given in-core log finally completes its
> - * write to disk, that thread will wake up all threads waiting on the
> - * sv.
> + * Synchronous forces are implemented with a wait queue.  All callers to force a
> + * given lsn to disk will wait on a the queue attached to the specific in-core

"All callers trying to force a given lsn to disk must wait on the queue
attached to the specific in-core log."... I think?

--D

> + * log.  When given in-core log finally completes its write to disk, that thread
> + * will wake up all threads waiting on the queue.
>   */
>  int
>  xfs_log_force_lsn(
> @@ -3433,92 +3432,75 @@ xfs_log_force_lsn(
>  try_again:
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> -	if (iclog->ic_state & XLOG_STATE_IOERROR) {
> -		spin_unlock(&log->l_icloglock);
> -		return -EIO;
> -	}
> +	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +		goto out_error;
>  
> -	do {
> -		if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
> -			iclog = iclog->ic_next;
> -			continue;
> -		}
> +	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
> +		iclog = iclog->ic_next;
> +		if (iclog == log->l_iclog)
> +			goto out_unlock;
> +	}
>  
> -		if (iclog->ic_state == XLOG_STATE_DIRTY) {
> -			spin_unlock(&log->l_icloglock);
> -			return 0;
> -		}
> +	if (iclog->ic_state == XLOG_STATE_DIRTY)
> +		goto out_unlock;
>  
> -		if (iclog->ic_state == XLOG_STATE_ACTIVE) {
> -			/*
> -			 * We sleep here if we haven't already slept (e.g.
> -			 * this is the first time we've looked at the correct
> -			 * iclog buf) and the buffer before us is going to
> -			 * be sync'ed. The reason for this is that if we
> -			 * are doing sync transactions here, by waiting for
> -			 * the previous I/O to complete, we can allow a few
> -			 * more transactions into this iclog before we close
> -			 * it down.
> -			 *
> -			 * Otherwise, we mark the buffer WANT_SYNC, and bump
> -			 * up the refcnt so we can release the log (which
> -			 * drops the ref count).  The state switch keeps new
> -			 * transaction commits from using this buffer.  When
> -			 * the current commits finish writing into the buffer,
> -			 * the refcount will drop to zero and the buffer will
> -			 * go out then.
> -			 */
> -			if (!already_slept &&
> -			    (iclog->ic_prev->ic_state &
> -			     (XLOG_STATE_WANT_SYNC | XLOG_STATE_SYNCING))) {
> -				ASSERT(!(iclog->ic_state & XLOG_STATE_IOERROR));
> +	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
> +		/*
> +		 * We sleep here if we haven't already slept (e.g. this is the
> +		 * first time we've looked at the correct iclog buf) and the
> +		 * buffer before us is going to be sync'ed.  The reason for this
> +		 * is that if we are doing sync transactions here, by waiting
> +		 * for the previous I/O to complete, we can allow a few more
> +		 * transactions into this iclog before we close it down.
> +		 *
> +		 * Otherwise, we mark the buffer WANT_SYNC, and bump up the
> +		 * refcnt so we can release the log (which drops the ref count).
> +		 * The state switch keeps new transaction commits from using
> +		 * this buffer.  When the current commits finish writing into
> +		 * the buffer, the refcount will drop to zero and the buffer
> +		 * will go out then.
> +		 */
> +		if (!already_slept &&
> +		    (iclog->ic_prev->ic_state &
> +		     (XLOG_STATE_WANT_SYNC | XLOG_STATE_SYNCING))) {
> +			ASSERT(!(iclog->ic_state & XLOG_STATE_IOERROR));
>  
> -				XFS_STATS_INC(mp, xs_log_force_sleep);
> +			XFS_STATS_INC(mp, xs_log_force_sleep);
>  
> -				xlog_wait(&iclog->ic_prev->ic_write_wait,
> -							&log->l_icloglock);
> -				already_slept = 1;
> -				goto try_again;
> -			}
> -			atomic_inc(&iclog->ic_refcnt);
> -			xlog_state_switch_iclogs(log, iclog, 0);
> -			spin_unlock(&log->l_icloglock);
> -			if (xlog_state_release_iclog(log, iclog))
> -				return -EIO;
> -			if (log_flushed)
> -				*log_flushed = 1;
> -			spin_lock(&log->l_icloglock);
> +			xlog_wait(&iclog->ic_prev->ic_write_wait,
> +					&log->l_icloglock);
> +			already_slept = 1;
> +			goto try_again;
>  		}
> +		atomic_inc(&iclog->ic_refcnt);
> +		xlog_state_switch_iclogs(log, iclog, 0);
> +		spin_unlock(&log->l_icloglock);
> +		if (xlog_state_release_iclog(log, iclog))
> +			return -EIO;
> +		if (log_flushed)
> +			*log_flushed = 1;
> +		spin_lock(&log->l_icloglock);
> +	}
>  
> -		if ((flags & XFS_LOG_SYNC) && /* sleep */
> -		    !(iclog->ic_state &
> -		      (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))) {
> -			/*
> -			 * Don't wait on completion if we know that we've
> -			 * gotten a log write error.
> -			 */
> -			if (iclog->ic_state & XLOG_STATE_IOERROR) {
> -				spin_unlock(&log->l_icloglock);
> -				return -EIO;
> -			}
> -			XFS_STATS_INC(mp, xs_log_force_sleep);
> -			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -			/*
> -			 * No need to grab the log lock here since we're
> -			 * only deciding whether or not to return EIO
> -			 * and the memory read should be atomic.
> -			 */
> -			if (iclog->ic_state & XLOG_STATE_IOERROR)
> -				return -EIO;
> -		} else {		/* just return */
> -			spin_unlock(&log->l_icloglock);
> -		}
> +	if (!(flags & XFS_LOG_SYNC) ||
> +	    (iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY)))
> +		goto out_unlock;
>  
> -		return 0;
> -	} while (iclog != log->l_iclog);
> +	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +		goto out_error;
> +
> +	XFS_STATS_INC(mp, xs_log_force_sleep);
> +	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> +	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +		return -EIO;
> +	return 0;
>  
> +out_unlock:
>  	spin_unlock(&log->l_icloglock);
>  	return 0;
> +out_error:
> +	spin_unlock(&log->l_icloglock);
> +	return -EIO;
>  }
>  
>  /*
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
