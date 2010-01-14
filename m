Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EJOJY0028702 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 13:24:19 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 2/3] xfs: clean up log buffer writes
Date: Thu, 14 Jan 2010 13:25:13 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6971@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100113221812.467038685@bombadil.infradead.org>
From: "Alex Elder" <aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Don't bother using XFS_bwrite as it doesn't provide much code for our
> use case.  Instead opencode it and fold xlog_bdstrat_cb into the new
> xlog_bdstrat helper.

Cool.  Simpler.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2010-01-02 13:39:48.476003952 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2010-01-02 13:43:39.250005833 +0100
> @@ -408,8 +408,6 @@ static inline int XFS_bwrite(xfs_buf_t *
>  	return error;
>  }
> 
> -#define XFS_bdstrat(bp) xfs_buf_iorequest(bp)
> -
>  #define xfs_iowait(bp)	xfs_buf_iowait(bp)
> 
>  #define xfs_baread(target, rablkno, ralen)  \
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2010-01-02 13:39:48.493261945 +0100
> +++ xfs/fs/xfs/xfs_log.c	2010-01-02 13:45:36.221004745 +0100
> @@ -50,7 +50,6 @@ kmem_zone_t	*xfs_log_ticket_zone;
>  	  (off) += (bytes);}
> 
>  /* Local miscellaneous function prototypes */
> -STATIC int	 xlog_bdstrat_cb(struct xfs_buf *);
>  STATIC int	 xlog_commit_record(xfs_mount_t *mp, xlog_ticket_t *ticket,
>  				    xlog_in_core_t **, xfs_lsn_t *);
>  STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
> @@ -988,35 +987,6 @@ xlog_iodone(xfs_buf_t *bp)
>  }	/* xlog_iodone */
> 
>  /*
> - * The bdstrat callback function for log bufs. This gives us a central
> - * place to trap bufs in case we get hit by a log I/O error and need to
> - * shutdown. Actually, in practice, even when we didn't get a log error,
> - * we transition the iclogs to IOERROR state *after* flushing all existing
> - * iclogs to disk. This is because we don't want anymore new transactions to be
> - * started or completed afterwards.
> - */
> -STATIC int
> -xlog_bdstrat_cb(struct xfs_buf *bp)
> -{
> -	xlog_in_core_t *iclog;
> -
> -	iclog = XFS_BUF_FSPRIVATE(bp, xlog_in_core_t *);
> -
> -	if ((iclog->ic_state & XLOG_STATE_IOERROR) == 0) {
> -	  /* note for irix bstrat will need  struct bdevsw passed
> -	   * Fix the following macro if the code ever is merged
> -	   */
> -	    XFS_bdstrat(bp);
> -		return 0;
> -	}
> -
> -	XFS_BUF_ERROR(bp, EIO);
> -	XFS_BUF_STALE(bp);
> -	xfs_biodone(bp);
> -	return XFS_ERROR(EIO);
> -}
> -
> -/*
>   * Return size of each in-core log record buffer.
>   *
>   * All machines get 8 x 32kB buffers by default, unless tuned otherwise.
> @@ -1158,7 +1128,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  	if (!bp)
>  		goto out_free_log;
>  	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
> -	XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
>  	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
>  	ASSERT(XFS_BUF_ISBUSY(bp));
>  	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
> @@ -1196,7 +1165,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  		if (!XFS_BUF_CPSEMA(bp))
>  			ASSERT(0);
>  		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
> -		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
>  		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
>  		iclog->ic_bp = bp;
>  		iclog->ic_data = bp->b_addr;
> @@ -1343,6 +1311,37 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
>  	    xfs_trans_ail_push(log->l_ailp, threshold_lsn);
>  }	/* xlog_grant_push_ail */
> 
> +/*
> + * The bdstrat callback function for log bufs. This gives us a central
> + * place to trap bufs in case we get hit by a log I/O error and need to
> + * shutdown. Actually, in practice, even when we didn't get a log error,
> + * we transition the iclogs to IOERROR state *after* flushing all existing
> + * iclogs to disk. This is because we don't want anymore new transactions to be
> + * started or completed afterwards.
> + */
> +STATIC int
> +xlog_bdstrat(
> +	struct xfs_buf		*bp)
> +{
> +	struct xlog_in_core	*iclog;
> +
> +	iclog = XFS_BUF_FSPRIVATE(bp, xlog_in_core_t *);
> +	if (iclog->ic_state & XLOG_STATE_IOERROR) {
> +		XFS_BUF_ERROR(bp, EIO);
> +		XFS_BUF_STALE(bp);
> +		xfs_biodone(bp);
> +		/*
> +		 * It would seem logical to return EIO here, but we rely on
> +		 * the log state machine to propagate I/O errors instead of
> +		 * doing it here.
> +		 */
> +		return 0;
> +	}
> +
> +	bp->b_flags |= _XBF_RUN_QUEUES;
> +	xfs_buf_iorequest(bp);
> +	return 0;
> +}
> 
>  /*
>   * Flush out the in-core log (iclog) to the on-disk log in an asynchronous
> @@ -1462,7 +1461,7 @@ xlog_sync(xlog_t		*log,
>  	 */
>  	XFS_BUF_WRITE(bp);
> 
> -	if ((error = XFS_bwrite(bp))) {
> +	if ((error = xlog_bdstrat(bp))) {
>  		xfs_ioerror_alert("xlog_sync", log->l_mp, bp,
>  				  XFS_BUF_ADDR(bp));
>  		return error;
> @@ -1502,7 +1501,7 @@ xlog_sync(xlog_t		*log,
>  		/* account for internal log which doesn't start at block #0 */
>  		XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
>  		XFS_BUF_WRITE(bp);
> -		if ((error = XFS_bwrite(bp))) {
> +		if ((error = xlog_bdstrat(bp))) {
>  			xfs_ioerror_alert("xlog_sync (split)", log->l_mp,
>  					  bp, XFS_BUF_ADDR(bp));
>  			return error;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
