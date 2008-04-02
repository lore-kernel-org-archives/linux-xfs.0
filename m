Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 21:26:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m324PnuU021284
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 21:25:51 -0700
Message-ID: <47F3150B.6000106@sgi.com>
Date: Wed, 02 Apr 2008 15:09:31 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [Patch] Per iclog callback chain lock
References: <20080401231348.GT103491721@sgi.com>
In-Reply-To: <20080401231348.GT103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Looks fine to me - just one small comment.

David Chinner wrote:
> Introduce an iclog callback chain lock.
> 
> Rather than use the icloglock for protecting the iclog completion
> callback chain, use a new per-iclog lock so that walking the
> callback chain doesn't require holding a global lock.
> 
> This reduces contention on the icloglock during log buffer I/O
> completion as the callback chain lock is take for every callback
> that is issued. On large log buffers, this can number in the
> hundreds to thousands per iclog so isolating the lock to the
> iclog makes a lot of sense.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_log.c      |   35 +++++++++++++++++++----------------
>  fs/xfs/xfs_log_priv.h |   33 ++++++++++++++++++++++++++-------
>  2 files changed, 45 insertions(+), 23 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2008-03-13 13:10:23.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2008-03-13 19:35:51.251913648 +1100
> @@ -397,12 +397,10 @@ xfs_log_notify(xfs_mount_t	  *mp,		/* mo
>  	       void		  *iclog_hndl,	/* iclog to hang callback off */
>  	       xfs_log_callback_t *cb)
>  {
> -	xlog_t *log = mp->m_log;
>  	xlog_in_core_t	  *iclog = (xlog_in_core_t *)iclog_hndl;
>  	int	abortflg;
>  
> -	cb->cb_next = NULL;
> -	spin_lock(&log->l_icloglock);
> +	spin_lock(&iclog->ic_callback_lock);
>  	abortflg = (iclog->ic_state & XLOG_STATE_IOERROR);
>  	if (!abortflg) {
>  		ASSERT_ALWAYS((iclog->ic_state == XLOG_STATE_ACTIVE) ||
> @@ -411,7 +409,7 @@ xfs_log_notify(xfs_mount_t	  *mp,		/* mo
>  		*(iclog->ic_callback_tail) = cb;
>  		iclog->ic_callback_tail = &(cb->cb_next);
>  	}
> -	spin_unlock(&log->l_icloglock);
> +	spin_unlock(&iclog->ic_callback_lock);
>  	return abortflg;
>  }	/* xfs_log_notify */
>  
> @@ -1257,6 +1255,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  		iclog->ic_size = XFS_BUF_SIZE(bp) - log->l_iclog_hsize;
>  		iclog->ic_state = XLOG_STATE_ACTIVE;
>  		iclog->ic_log = log;
> +		atomic_set(&iclog->ic_refcnt, 0);
Not related to this change but looks like we need it anyway.
Did you mean to include it in this change?

> +		spin_lock_init(&iclog->ic_callback_lock);
>  		iclog->ic_callback_tail = &(iclog->ic_callback);
>  		iclog->ic_datap = (char *)iclog->hic_data + log->l_iclog_hsize;
>  
> @@ -1990,7 +1990,7 @@ xlog_state_clean_log(xlog_t *log)
>  		if (iclog->ic_state == XLOG_STATE_DIRTY) {
>  			iclog->ic_state	= XLOG_STATE_ACTIVE;
>  			iclog->ic_offset       = 0;
> -			iclog->ic_callback	= NULL;   /* don't need to free */
> +			ASSERT(iclog->ic_callback == NULL);
>  			/*
>  			 * If the number of ops in this iclog indicate it just
>  			 * contains the dummy transaction, we can
> @@ -2193,37 +2193,40 @@ xlog_state_do_callback(
>  					be64_to_cpu(iclog->ic_header.h_lsn);
>  				spin_unlock(&log->l_grant_lock);
>  
> -				/*
> -				 * Keep processing entries in the callback list
> -				 * until we come around and it is empty.  We
> -				 * need to atomically see that the list is
> -				 * empty and change the state to DIRTY so that
> -				 * we don't miss any more callbacks being added.
> -				 */
> -				spin_lock(&log->l_icloglock);
>  			} else {
> +				spin_unlock(&log->l_icloglock);
>  				ioerrors++;
>  			}
> -			cb = iclog->ic_callback;
>  
> +			/*
> +			 * Keep processing entries in the callback list until
> +			 * we come around and it is empty.  We need to
> +			 * atomically see that the list is empty and change the
> +			 * state to DIRTY so that we don't miss any more
> +			 * callbacks being added.
> +			 */
> +			spin_lock(&iclog->ic_callback_lock);
> +			cb = iclog->ic_callback;
>  			while (cb) {
>  				iclog->ic_callback_tail = &(iclog->ic_callback);
>  				iclog->ic_callback = NULL;
> -				spin_unlock(&log->l_icloglock);
> +				spin_unlock(&iclog->ic_callback_lock);
>  
>  				/* perform callbacks in the order given */
>  				for (; cb; cb = cb_next) {
>  					cb_next = cb->cb_next;
>  					cb->cb_func(cb->cb_arg, aborted);
>  				}
> -				spin_lock(&log->l_icloglock);
> +				spin_lock(&iclog->ic_callback_lock);
>  				cb = iclog->ic_callback;
>  			}
>  
>  			loopdidcallbacks++;
>  			funcdidcallbacks++;
>  
> +			spin_lock(&log->l_icloglock);
>  			ASSERT(iclog->ic_callback == NULL);
> +			spin_unlock(&iclog->ic_callback_lock);
Okay so we can acquire the l_icloglock while holding ic_callback_lock.

>  			if (!(iclog->ic_state & XLOG_STATE_IOERROR))
>  				iclog->ic_state = XLOG_STATE_DIRTY;
>  
> Index: 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_priv.h	2008-02-22 13:48:25.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h	2008-03-13 19:34:57.430809151 +1100
> @@ -324,6 +324,19 @@ typedef struct xlog_rec_ext_header {
>   * - ic_offset is the current number of bytes written to in this iclog.
>   * - ic_refcnt is bumped when someone is writing to the log.
>   * - ic_state is the state of the iclog.
> + *
> + * Because of cacheline contention on large machines, we need to separate
> + * various resources onto different cachelines. To start with, make the
> + * structure cacheline aligned. The following fields can be contended on
> + * by independent processes:
> + *
> + *	- ic_callback_*
> + *	- ic_refcnt
> + *	- fields protected by the global l_icloglock
> + *
> + * so we need to ensure that these fields are located in separate cachelines.
> + * We'll put all the read-only and l_icloglock fields in the first cacheline,
> + * and move everything else out to subsequent cachelines.
>   */
>  typedef struct xlog_iclog_fields {
>  	sv_t			ic_forcesema;
> @@ -332,18 +345,23 @@ typedef struct xlog_iclog_fields {
>  	struct xlog_in_core	*ic_prev;
>  	struct xfs_buf		*ic_bp;
>  	struct log		*ic_log;
> -	xfs_log_callback_t	*ic_callback;
> -	xfs_log_callback_t	**ic_callback_tail;
> -#ifdef XFS_LOG_TRACE
> -	struct ktrace		*ic_trace;
> -#endif
>  	int			ic_size;
>  	int			ic_offset;
> -	atomic_t		ic_refcnt;
>  	int			ic_bwritecnt;
>  	ushort_t		ic_state;
>  	char			*ic_datap;	/* pointer to iclog data */
> -} xlog_iclog_fields_t;
> +#ifdef XFS_LOG_TRACE
> +	struct ktrace		*ic_trace;
> +#endif
> +
> +	/* Callback structures need their own cacheline */
> +	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
> +	xfs_log_callback_t	*ic_callback;
> +	xfs_log_callback_t	**ic_callback_tail;
> +
> +	/* reference counts need their own cacheline */
> +	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
> +} xlog_iclog_fields_t ____cacheline_aligned_in_smp;
>  
>  typedef union xlog_in_core2 {
>  	xlog_rec_header_t	hic_header;
> @@ -366,6 +384,7 @@ typedef struct xlog_in_core {
>  #define	ic_bp		hic_fields.ic_bp
>  #define	ic_log		hic_fields.ic_log
>  #define	ic_callback	hic_fields.ic_callback
> +#define	ic_callback_lock hic_fields.ic_callback_lock
>  #define	ic_callback_tail hic_fields.ic_callback_tail
>  #define	ic_trace	hic_fields.ic_trace
>  #define	ic_size		hic_fields.ic_size
> 
