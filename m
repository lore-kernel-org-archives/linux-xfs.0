Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44700 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbeCNSjR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 14:39:17 -0400
Date: Wed, 14 Mar 2018 11:39:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/8] xfs: unwind the try_again loop in xfs_log_force
Message-ID: <20180314183912.GU4865@magnolia>
References: <20180313104927.12926-1-hch@lst.de>
 <20180313104927.12926-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313104927.12926-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 11:49:27AM +0100, Christoph Hellwig wrote:
> Instead split out a __xfs_log_fore_lsn helper that gets called again

I assume you meant __xfs_log_force_lsn?

Looks ok modulo fixing the tortured sentence in the comment in the
previous patch that gets moved around in this one,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> with the already_slept flag set to true in case we had to sleep.
> 
> This prepares for aio_fsync support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 72 +++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 42 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b6c6f227b2d7..9a2008646d57 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3395,41 +3395,17 @@ xfs_log_force(
>  	return -EIO;
>  }
>  
> -/*
> - * Force the in-core log to disk for a specific LSN.
> - *
> - * Find in-core log with lsn.
> - *	If it is in the DIRTY state, just return.
> - *	If it is in the ACTIVE state, move the in-core log into the WANT_SYNC
> - *		state and go to sleep or return.
> - *	If it is in any other state, go to sleep or return.
> - *
> - * Synchronous forces are implemented with a wait queue.  All callers to force a
> - * given lsn to disk will wait on a the queue attached to the specific in-core
> - * log.  When given in-core log finally completes its write to disk, that thread
> - * will wake up all threads waiting on the queue.
> - */
> -int
> -xfs_log_force_lsn(
> +static int
> +__xfs_log_force_lsn(
>  	struct xfs_mount	*mp,
>  	xfs_lsn_t		lsn,
>  	uint			flags,
> -	int			*log_flushed)
> +	int			*log_flushed,
> +	bool			already_slept)
>  {
>  	struct xlog		*log = mp->m_log;
>  	struct xlog_in_core	*iclog;
> -	int			already_slept = 0;
> -
> -	ASSERT(lsn != 0);
> -
> -	XFS_STATS_INC(mp, xs_log_force);
> -	trace_xfs_log_force(mp, lsn, _RET_IP_);
> -
> -	lsn = xlog_cil_force_lsn(log, lsn);
> -	if (lsn == NULLCOMMITLSN)
> -		return 0;
>  
> -try_again:
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
>  	if (iclog->ic_state & XLOG_STATE_IOERROR)
> @@ -3469,8 +3445,7 @@ xfs_log_force_lsn(
>  
>  			xlog_wait(&iclog->ic_prev->ic_write_wait,
>  					&log->l_icloglock);
> -			already_slept = 1;
> -			goto try_again;
> +			return -EAGAIN;
>  		}
>  		atomic_inc(&iclog->ic_refcnt);
>  		xlog_state_switch_iclogs(log, iclog, 0);
> @@ -3503,6 +3478,43 @@ xfs_log_force_lsn(
>  	return -EIO;
>  }
>  
> +/*
> + * Force the in-core log to disk for a specific LSN.
> + *
> + * Find in-core log with lsn.
> + *	If it is in the DIRTY state, just return.
> + *	If it is in the ACTIVE state, move the in-core log into the WANT_SYNC
> + *		state and go to sleep or return.
> + *	If it is in any other state, go to sleep or return.
> + *
> + * Synchronous forces are implemented with a wait queue.  All callers to force a
> + * given lsn to disk will wait on a the queue attached to the specific in-core
> + * log.  When given in-core log finally completes its write to disk, that thread
> + * will wake up all threads waiting on the queue.
> + */
> +int
> +xfs_log_force_lsn(
> +	struct xfs_mount	*mp,
> +	xfs_lsn_t		lsn,
> +	uint			flags,
> +	int			*log_flushed)
> +{
> +	int			ret;
> +	ASSERT(lsn != 0);
> +
> +	XFS_STATS_INC(mp, xs_log_force);
> +	trace_xfs_log_force(mp, lsn, _RET_IP_);
> +
> +	lsn = xlog_cil_force_lsn(mp->m_log, lsn);
> +	if (lsn == NULLCOMMITLSN)
> +		return 0;
> +
> +	ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, false);
> +	if (ret == -EAGAIN)
> +		ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, true);
> +	return ret;
> +}
> +
>  /*
>   * Called when we want to mark the current iclog as being ready to sync to
>   * disk.
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
