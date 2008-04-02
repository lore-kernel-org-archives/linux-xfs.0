Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 22:37:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m325bNsj031692
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 22:37:26 -0700
Message-ID: <47F3293C.6090708@sgi.com>
Date: Wed, 02 Apr 2008 16:35:40 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [Patch] Cacheline align xlog_t
References: <20080401231552.GV103491721@sgi.com>
In-Reply-To: <20080401231552.GV103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Looks good - just one comment.

David Chinner wrote:
> Reorganise xlog_t for better cacheline isolation of contention
> 
> To reduce contention on the log in large CPU count, separate
> out different parts of the xlog_t structure onto different cachelines.
> Move each lock onto a different cacheline along with all the members
> that are accessed/modified while that lock is held.
> 
> Also, move the debugging code into debug code.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_log.c      |    5 +---
>  fs/xfs/xfs_log_priv.h |   55 +++++++++++++++++++++++++++-----------------------
>  2 files changed, 32 insertions(+), 28 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2008-03-13 14:03:38.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2008-03-13 14:20:21.803846380 +1100
> @@ -1237,9 +1237,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
>  		iclog->ic_bp = bp;
>  		iclog->hic_data = bp->b_addr;
> -
> +#ifdef DEBUG
>  		log->l_iclog_bak[i] = (xfs_caddr_t)&(iclog->ic_header);
> -
> +#endif
>  		head = &iclog->ic_header;
>  		memset(head, 0, sizeof(xlog_rec_header_t));
>  		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
> @@ -1250,7 +1250,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  		head->h_fmt = cpu_to_be32(XLOG_FMT);
>  		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
>  
> -
>  		iclog->ic_size = XFS_BUF_SIZE(bp) - log->l_iclog_hsize;
>  		iclog->ic_state = XLOG_STATE_ACTIVE;
>  		iclog->ic_log = log;
> Index: 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_priv.h	2008-03-13 14:06:58.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h	2008-03-13 14:20:31.478596832 +1100
> @@ -402,8 +402,29 @@ typedef struct xlog_in_core {
>   * that round off problems won't occur when releasing partial reservations.
>   */
>  typedef struct log {
> +	/* The following fields don't need locking */
> +	struct xfs_mount	*l_mp;	        /* mount point */
> +	struct xfs_buf		*l_xbuf;        /* extra buffer for log
> +						 * wrapping */
> +	struct xfs_buftarg	*l_targ;        /* buftarg of log */
> +	uint			l_flags;
> +	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
> +	struct xfs_buf_cancel	**l_buf_cancel_table;
> +	int			l_iclog_hsize;  /* size of iclog header */
> +	int			l_iclog_heads;  /* # of iclog header sectors */
> +	uint			l_sectbb_log;   /* log2 of sector size in BBs */
> +	uint			l_sectbb_mask;  /* sector size (in BBs)
> +						 * alignment mask */
> +	int			l_iclog_size;	/* size of log in bytes */
> +	int			l_iclog_size_log; /* log power size of log */
> +	int			l_iclog_bufs;	/* number of iclog buffers */
> +	xfs_daddr_t		l_logBBstart;   /* start block of log */
> +	int			l_logsize;      /* size of log in bytes */
> +	int			l_logBBsize;    /* size of log in BB chunks */
> +
>  	/* The following block of fields are changed while holding icloglock */
> -	sema_t			l_flushsema;    /* iclog flushing semaphore */
> +	sema_t			l_flushsema ____cacheline_aligned_in_smp;
> +						/* iclog flushing semaphore */
>  	int			l_flushcnt;	/* # of procs waiting on this
>  						 * sema */
>  	int			l_covered_state;/* state of "covering disk
> @@ -413,27 +434,14 @@ typedef struct log {
>  	xfs_lsn_t		l_tail_lsn;     /* lsn of 1st LR with unflushed
>  						 * buffers */
>  	xfs_lsn_t		l_last_sync_lsn;/* lsn of last LR on disk */
> -	struct xfs_mount	*l_mp;	        /* mount point */
> -	struct xfs_buf		*l_xbuf;        /* extra buffer for log
> -						 * wrapping */
> -	struct xfs_buftarg	*l_targ;        /* buftarg of log */
> -	xfs_daddr_t		l_logBBstart;   /* start block of log */
> -	int			l_logsize;      /* size of log in bytes */
> -	int			l_logBBsize;    /* size of log in BB chunks */
>  	int			l_curr_cycle;   /* Cycle number of log writes */
>  	int			l_prev_cycle;   /* Cycle number before last
>  						 * block increment */
>  	int			l_curr_block;   /* current logical log block */
>  	int			l_prev_block;   /* previous logical log block */
> -	int			l_iclog_size;	/* size of log in bytes */
> -	int			l_iclog_size_log; /* log power size of log */
> -	int			l_iclog_bufs;	/* number of iclog buffers */
> -
> -	/* The following field are used for debugging; need to hold icloglock */
> -	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
>  
>  	/* The following block of fields are changed while holding grant_lock */
> -	spinlock_t		l_grant_lock;
> +	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
>  	xlog_ticket_t		*l_reserve_headq;
>  	xlog_ticket_t		*l_write_headq;
>  	int			l_grant_reserve_cycle;
> @@ -441,20 +449,17 @@ typedef struct log {
>  	int			l_grant_write_cycle;
>  	int			l_grant_write_bytes;
>  
> -	/* The following fields don't need locking */
>  #ifdef XFS_LOG_TRACE
>  	struct ktrace		*l_trace;
>  	struct ktrace		*l_grant_trace;
>  #endif
> -	uint			l_flags;
> -	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
> -	struct xfs_buf_cancel	**l_buf_cancel_table;
> -	int			l_iclog_hsize;  /* size of iclog header */
> -	int			l_iclog_heads;  /* # of iclog header sectors */
> -	uint			l_sectbb_log;   /* log2 of sector size in BBs */
> -	uint			l_sectbb_mask;  /* sector size (in BBs)
> -						 * alignment mask */
> -} xlog_t;
> +
> +	/* The following field are used for debugging; need to hold icloglock */
> +#ifdef DEBUG
> +	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
> +#endif
> +
> +} xlog_t ____cacheline_aligned_in_smp;
Is it necessary to add a ____cacheline_aligned_in_smp tag here?  The important
sections of the xlog_t structure are already tagged.

>  
>  #define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
>  
> 
