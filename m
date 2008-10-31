Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 21:34:09 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V4Xt0X019408
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 21:33:56 -0700
Message-ID: <490A8AAD.50207@sgi.com>
Date: Fri, 31 Oct 2008 15:33:49 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: handle memory allocation failures during log initialisation
References: <1225416366-3116-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1225416366-3116-1-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

Dave Chinner wrote:
> When there is no memory left in the system, xfs_buf_get_noaddr()
> can fail. If this happens at mount time during xlog_alloc_log()
> we fail to catch the error and oops.
> 
> Catch the error from xfs_buf_get_noaddr(), and allow other memory
> allocations to fail and catch those errors too. Report the error
> to the console and fail the mount with ENOMEM.
> 
> Tested by manually injecting errors into xfs_buf_get_noaddr() and
> xlog_alloc_log().
> 
> Version 2:
> o remove unnecessary casts of the returned pointer from kmem_zalloc()
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_log.c |   39 ++++++++++++++++++++++++++++++++++++---
>  1 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5184017..92c20a8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -563,6 +563,11 @@ xfs_log_mount(
>  	}
>  
>  	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
> +	if (!mp->m_log) {
> +		cmn_err(CE_WARN, "XFS: Log allocation failed: No memory!");
> +		error = ENOMEM;
> +		goto out;
> +	}
>  
>  	/*
>  	 * Initialize the AIL now we have a log.
> @@ -601,6 +606,7 @@ xfs_log_mount(
>  	return 0;
>  error:
>  	xfs_log_unmount_dealloc(mp);
> +out:
>  	return error;
>  }	/* xfs_log_mount */
>  
> @@ -1217,7 +1223,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  	int			i;
>  	int			iclogsize;
>  
> -	log = (xlog_t *)kmem_zalloc(sizeof(xlog_t), KM_SLEEP);
> +	log = kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
> +	if (!log)
> +		return NULL;
>  
>  	log->l_mp	   = mp;
>  	log->l_targ	   = log_target;
> @@ -1249,6 +1257,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  	xlog_get_iclog_buffer_size(mp, log);
>  
>  	bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
> +	if (!bp)
> +		goto out_free_log;
>  	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
>  	XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
>  	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
> @@ -1275,13 +1285,17 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  	iclogsize = log->l_iclog_size;
>  	ASSERT(log->l_iclog_size >= 4096);
>  	for (i=0; i < log->l_iclog_bufs; i++) {
> -		*iclogp = (xlog_in_core_t *)
> -			  kmem_zalloc(sizeof(xlog_in_core_t), KM_SLEEP);
> +		*iclogp = kmem_zalloc(sizeof(xlog_in_core_t), KM_MAYFAIL);
> +		if (!*iclogp)
> +			goto out_free_iclog;
> +
>  		iclog = *iclogp;
>  		iclog->ic_prev = prev_iclog;
>  		prev_iclog = iclog;
>  
>  		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
> +		if (!bp)
> +			goto out_free_iclog;
>  		if (!XFS_BUF_CPSEMA(bp))
>  			ASSERT(0);
>  		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
> @@ -1323,6 +1337,25 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
>  
>  	return log;
> +
> +out_free_iclog:
> +	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
> +		prev_iclog = iclog->ic_next;
> +		if (iclog->ic_bp) {
> +			sv_destroy(&iclog->ic_force_wait);
> +			sv_destroy(&iclog->ic_write_wait);
> +			xfs_buf_free(iclog->ic_bp);
> +			xlog_trace_iclog_dealloc(iclog);
> +		}
> +		kmem_free(iclog);
> +	}
> +	spinlock_destroy(&log->l_icloglock);
> +	spinlock_destroy(&log->l_grant_lock);
> +	xlog_trace_loggrant_dealloc(log);
> +	xfs_buf_free(log->l_xbuf);
> +out_free_log:
> +	kmem_free(log);
> +	return NULL;
>  }	/* xlog_alloc_log */
>  
>  

I would have done s/prev_iclog/next_iclog/
as I'm not sure why you look at it as previous.

However, I think it would be nicer to modify xlog_dealloc_log()
to handle less than l_iclog_bufs.
i.e put the code you have here into xlog_dealloc_log()
and do the deallocation in one place.

--Tim
