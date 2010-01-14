Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EJSn5k029000 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 13:28:49 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 3/3] xfs: clean up xfs_bwrite
Date: Thu, 14 Jan 2010 13:29:43 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6972@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100113221812.879733544@bombadil.infradead.org>
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
> Fold XFS_bwrite into it's only caller, xfs_bwrite and move it into
> xfs_buf.c instead of leaving it as a fairly large inline function.

Looks good.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-01-13 14:56:29.241004610 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-01-13 14:58:43.278256022 +0100
> @@ -980,6 +980,33 @@ xfs_buf_ioerror(
>  }
> 
>  int
> +xfs_bwrite(
> +	struct xfs_mount	*mp,
> +	struct xfs_buf		*bp)
> +{
> +	int			iowait = (bp->b_flags & XBF_ASYNC) == 0;
> +	int			error = 0;
> +
> +	bp->b_strat = xfs_bdstrat_cb;
> +	bp->b_mount = mp;
> +	bp->b_flags |= XBF_WRITE;
> +	if (!iowait)
> +		bp->b_flags |= _XBF_RUN_QUEUES;
> +
> +	xfs_buf_delwri_dequeue(bp);
> +	xfs_buf_iostrategy(bp);
> +
> +	if (iowait) {
> +		error = xfs_buf_iowait(bp);
> +		if (error)
> +			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +		xfs_buf_relse(bp);
> +	}
> +
> +	return error;
> +}
> +
> +int
>  xfs_bawrite(
>  	void			*mp,
>  	struct xfs_buf		*bp)
> Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2010-01-13 14:56:29.253027581 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2010-01-13 14:59:45.854006783 +0100
> @@ -232,6 +232,7 @@ extern void xfs_buf_lock(xfs_buf_t *);
>  extern void xfs_buf_unlock(xfs_buf_t *);
> 
>  /* Buffer Read and Write Routines */
> +extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
>  extern int xfs_bawrite(void *mp, xfs_buf_t *bp);
>  extern void xfs_bdwrite(void *mp, xfs_buf_t *bp);
>  extern void xfs_buf_ioend(xfs_buf_t *,	int);
> @@ -390,24 +391,6 @@ static inline void xfs_buf_relse(xfs_buf
>  #define xfs_biozero(bp, off, len) \
>  	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
> 
> -
> -static inline int XFS_bwrite(xfs_buf_t *bp)
> -{
> -	int	iowait = (bp->b_flags & XBF_ASYNC) == 0;
> -	int	error = 0;
> -
> -	if (!iowait)
> -		bp->b_flags |= _XBF_RUN_QUEUES;
> -
> -	xfs_buf_delwri_dequeue(bp);
> -	xfs_buf_iostrategy(bp);
> -	if (iowait) {
> -		error = xfs_buf_iowait(bp);
> -		xfs_buf_relse(bp);
> -	}
> -	return error;
> -}
> -
>  #define xfs_iowait(bp)	xfs_buf_iowait(bp)
> 
>  #define xfs_baread(target, rablkno, ralen)  \
> Index: xfs/fs/xfs/xfs_rw.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_rw.c	2010-01-13 14:56:29.229003918 +0100
> +++ xfs/fs/xfs/xfs_rw.c	2010-01-13 14:56:43.546029660 +0100
> @@ -306,37 +306,6 @@ xfs_read_buf(
>  }
> 
>  /*
> - * Wrapper around bwrite() so that we can trap
> - * write errors, and act accordingly.
> - */
> -int
> -xfs_bwrite(
> -	struct xfs_mount *mp,
> -	struct xfs_buf	 *bp)
> -{
> -	int	error;
> -
> -	/*
> -	 * XXXsup how does this work for quotas.
> -	 */
> -	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
> -	bp->b_mount = mp;
> -	XFS_BUF_WRITE(bp);
> -
> -	if ((error = XFS_bwrite(bp))) {
> -		ASSERT(mp);
> -		/*
> -		 * Cannot put a buftrace here since if the buffer is not
> -		 * B_HOLD then we will brelse() the buffer before returning
> -		 * from bwrite and we could be tracing a buffer that has
> -		 * been reused.
> -		 */
> -		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> -	}
> -	return (error);
> -}
> -
> -/*
>   * helper function to extract extent size hint from inode
>   */
>  xfs_extlen_t
> Index: xfs/fs/xfs/xfs_rw.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_rw.h	2010-01-13 14:58:48.628253849 +0100
> +++ xfs/fs/xfs/xfs_rw.h	2010-01-13 14:59:00.915005960 +0100
> @@ -40,7 +40,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
>   * Prototypes for functions in xfs_rw.c.
>   */
>  extern int xfs_write_clear_setuid(struct xfs_inode *ip);
> -extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
>  extern int xfs_bioerror(struct xfs_buf *bp);
>  extern int xfs_bioerror_relse(struct xfs_buf *bp);
>  extern int xfs_read_buf(struct xfs_mount *mp, xfs_buftarg_t *btp,
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
