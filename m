Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbeCNSbM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 14:31:12 -0400
Date: Wed, 14 Mar 2018 11:31:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] xfs: refactor xfs_log_force
Message-ID: <20180314183105.GS4865@magnolia>
References: <20180313104927.12926-1-hch@lst.de>
 <20180313104927.12926-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313104927.12926-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 11:49:25AM +0100, Christoph Hellwig wrote:
> Streamline the conditionals so that it is more obvious which specific case
> form the top of the function comments is being handled.  Use gotos only
> for early returns.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Well, that made my brain hurt... :)
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 144 ++++++++++++++++++++++++-------------------------------
>  1 file changed, 63 insertions(+), 81 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 14ab660a0bae..a37a8defcd39 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3318,99 +3318,81 @@ xfs_log_force(
>  	xlog_cil_force(log);
>  
>  	spin_lock(&log->l_icloglock);
> -
>  	iclog = log->l_iclog;
> -	if (iclog->ic_state & XLOG_STATE_IOERROR) {
> -		spin_unlock(&log->l_icloglock);
> -		return -EIO;
> -	}
> +	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +		goto out_error;
>  
> -	/* If the head iclog is not active nor dirty, we just attach
> -	 * ourselves to the head and go to sleep.
> -	 */
> -	if (iclog->ic_state == XLOG_STATE_ACTIVE ||
> -	    iclog->ic_state == XLOG_STATE_DIRTY) {
> +	if (iclog->ic_state == XLOG_STATE_DIRTY ||
> +	    (iclog->ic_state == XLOG_STATE_ACTIVE &&
> +	     atomic_read(&iclog->ic_refcnt) == 0 && iclog->ic_offset == 0)) {
>  		/*
> -		 * If the head is dirty or (active and empty), then
> -		 * we need to look at the previous iclog.  If the previous
> -		 * iclog is active or dirty we are done.  There is nothing
> -		 * to sync out.  Otherwise, we attach ourselves to the
> +		 * If the head is dirty or (active and empty), then we need to
> +		 * look at the previous iclog.
> +		 *
> +		 * If the previous iclog is active or dirty we are done.  There
> +		 * is nothing to sync out. Otherwise, we attach ourselves to the
>  		 * previous iclog and go to sleep.
>  		 */
> -		if (iclog->ic_state == XLOG_STATE_DIRTY ||
> -		    (atomic_read(&iclog->ic_refcnt) == 0
> -		     && iclog->ic_offset == 0)) {
> -			iclog = iclog->ic_prev;
> -			if (iclog->ic_state == XLOG_STATE_ACTIVE ||
> -			    iclog->ic_state == XLOG_STATE_DIRTY)
> -				goto no_sleep;
> -			else
> -				goto maybe_sleep;
> -		} else {
> -			if (atomic_read(&iclog->ic_refcnt) == 0) {
> -				/* We are the only one with access to this
> -				 * iclog.  Flush it out now.  There should
> -				 * be a roundoff of zero to show that someone
> -				 * has already taken care of the roundoff from
> -				 * the previous sync.
> -				 */
> -				atomic_inc(&iclog->ic_refcnt);
> -				lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> -				xlog_state_switch_iclogs(log, iclog, 0);
> -				spin_unlock(&log->l_icloglock);
> -
> -				if (xlog_state_release_iclog(log, iclog))
> -					return -EIO;
> +		iclog = iclog->ic_prev;
> +		if (iclog->ic_state == XLOG_STATE_ACTIVE ||
> +		    iclog->ic_state == XLOG_STATE_DIRTY)
> +			goto out_unlock;
> +	} else if (iclog->ic_state == XLOG_STATE_ACTIVE) {
> +		if (atomic_read(&iclog->ic_refcnt) == 0) {
> +			/*
> +			 * We are the only one with access to this iclog.
> +			 *
> +			 * Flush it out now.  There should be a roundoff of zero
> +			 * to show that someone has already taken care of the
> +			 * roundoff from the previous sync.
> +			 */
> +			atomic_inc(&iclog->ic_refcnt);
> +			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +			xlog_state_switch_iclogs(log, iclog, 0);
> +			spin_unlock(&log->l_icloglock);
>  
> -				spin_lock(&log->l_icloglock);
> -				if (be64_to_cpu(iclog->ic_header.h_lsn) == lsn &&
> -				    iclog->ic_state != XLOG_STATE_DIRTY)
> -					goto maybe_sleep;
> -				else
> -					goto no_sleep;
> -			} else {
> -				/* Someone else is writing to this iclog.
> -				 * Use its call to flush out the data.  However,
> -				 * the other thread may not force out this LR,
> -				 * so we mark it WANT_SYNC.
> -				 */
> -				xlog_state_switch_iclogs(log, iclog, 0);
> -				goto maybe_sleep;
> -			}
> -		}
> -	}
> +			if (xlog_state_release_iclog(log, iclog))
> +				return -EIO;
>  
> -	/* By the time we come around again, the iclog could've been filled
> -	 * which would give it another lsn.  If we have a new lsn, just
> -	 * return because the relevant data has been flushed.
> -	 */
> -maybe_sleep:
> -	if (flags & XFS_LOG_SYNC) {
> -		/*
> -		 * We must check if we're shutting down here, before
> -		 * we wait, while we're holding the l_icloglock.
> -		 * Then we check again after waking up, in case our
> -		 * sleep was disturbed by a bad news.
> -		 */
> -		if (iclog->ic_state & XLOG_STATE_IOERROR) {
> -			spin_unlock(&log->l_icloglock);
> -			return -EIO;
> +			spin_lock(&log->l_icloglock);
> +			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn ||
> +			    iclog->ic_state == XLOG_STATE_DIRTY)
> +				goto out_unlock;
> +		} else {
> +			/*
> +			 * Someone else is writing to this iclog.
> +			 *
> +			 * Use its call to flush out the data.  However, the
> +			 * other thread may not force out this LR, so we mark
> +			 * it WANT_SYNC.
> +			 */
> +			xlog_state_switch_iclogs(log, iclog, 0);
>  		}
> -		XFS_STATS_INC(mp, xs_log_force_sleep);
> -		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> +	} else {
>  		/*
> -		 * No need to grab the log lock here since we're
> -		 * only deciding whether or not to return EIO
> -		 * and the memory read should be atomic.
> +		 * If the head iclog is not active nor dirty, we just attach
> +		 * ourselves to the head and go to sleep if necessary.
>  		 */
> -		if (iclog->ic_state & XLOG_STATE_IOERROR)
> -			return -EIO;
> -	} else {
> -
> -no_sleep:
> -		spin_unlock(&log->l_icloglock);
> +		;
>  	}
> +
> +	if (!(flags & XFS_LOG_SYNC))
> +		goto out_unlock;
> +
> +	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +		goto out_error;
> +	XFS_STATS_INC(mp, xs_log_force_sleep);
> +	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> +	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +		return -EIO;
>  	return 0;
> +
> +out_unlock:
> +	spin_unlock(&log->l_icloglock);
> +	return 0;
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
