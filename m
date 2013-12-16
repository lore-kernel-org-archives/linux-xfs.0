Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65E297F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 16:44:33 -0600 (CST)
Date: Mon, 16 Dec 2013 16:44:32 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/6] xfs: don't try to mark uncached buffers stale on
	error.
Message-ID: <20131216224432.GP1935@sgi.com>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-2-git-send-email-david@fromorbit.com>
	<20131213130230.GA22594@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213130230.GA22594@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 05:02:30AM -0800, Christoph Hellwig wrote:
> I think the real problem here is not nessecarily marking uncached
> buffers as stale, but marking unlocked buffers as stale.  This kinda
> overlaps because we only really ever do I/O on unlocked buffers if they
> are uncached too as it would be safe otherwise.
> 
> I think this is easily fixable by never calling xfsbdstrat on unlocked
> buffers, and as an extension simply killing xfsbdstrat as it's already
> fairly useless.  The patch below replaces all calls of xfsbdstrat with
> trivial error handling for the callers that have local uncached buffers,
> and opencodes it in the one remaining other caller.  There's a lot left
> to be cleaned up in this area, but this seems like the least invasive
> patch that doesn't cause more of a mess.
> 
> ---
> From: Christoph Hellwig <hch@infradead.org>
> Subject: [PATCH] xfs: remove xfsbdstrat
> 
> The xfsbdstrat helper is a small but useless wrapper for xfs_buf_iorequest that
> handles the case of a shut down filesystem.  Most of the users have private,
> uncached buffers that can just be freed in this case, but the complex error
> handling in xfs_bioerror_relse messes up the case when it's called without
> a locked buffer.
> 
> Remove xfsbdstrat and opencode the error handling in the callers.  All but
> one can simply return an error and don't need to deal with buffer state,
> and the one caller that cares about the buffer state could do with a major
> cleanup as well, but we'll defer that to later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 5887e41..1394106 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1187,7 +1187,12 @@ xfs_zero_remaining_bytes(
>  		XFS_BUF_UNWRITE(bp);
>  		XFS_BUF_READ(bp);
>  		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
> -		xfsbdstrat(mp, bp);
> +
> +		if (XFS_FORCED_SHUTDOWN(mp)) {
> +			error = XFS_ERROR(EIO);
> +			break;
> +		}
> +		xfs_buf_iorequest(bp);
>  		error = xfs_buf_iowait(bp);
>  		if (error) {
>  			xfs_buf_ioerror_alert(bp,
> @@ -1200,7 +1205,12 @@ xfs_zero_remaining_bytes(
>  		XFS_BUF_UNDONE(bp);
>  		XFS_BUF_UNREAD(bp);
>  		XFS_BUF_WRITE(bp);
> -		xfsbdstrat(mp, bp);
> +
> +		if (XFS_FORCED_SHUTDOWN(mp)) {
> +			error = XFS_ERROR(EIO);
> +			break;
> +		}
> +		xfs_buf_iorequest(bp);
>  		error = xfs_buf_iowait(bp);
>  		if (error) {
>  			xfs_buf_ioerror_alert(bp,
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ce01c1a..544315e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -698,7 +698,11 @@ xfs_buf_read_uncached(
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = ops;
>  
> -	xfsbdstrat(target->bt_mount, bp);
> +	if (XFS_FORCED_SHUTDOWN(target->bt_mount)) {
> +		xfs_buf_relse(bp);
> +		return NULL;
> +	}
> +	xfs_buf_iorequest(bp);
>  	xfs_buf_iowait(bp);
>  	return bp;
>  }
> @@ -1089,7 +1093,7 @@ xfs_bioerror(
>   * This is meant for userdata errors; metadata bufs come with
>   * iodone functions attached, so that we can track down errors.
>   */
> -STATIC int
> +int
>  xfs_bioerror_relse(
>  	struct xfs_buf	*bp)
>  {
> @@ -1164,25 +1168,6 @@ xfs_bwrite(
>  	return error;
>  }
>  
> -/*
> - * Wrapper around bdstrat so that we can stop data from going to disk in case
> - * we are shutting down the filesystem.  Typically user data goes thru this
> - * path; one of the exceptions is the superblock.
> - */
> -void
> -xfsbdstrat(
> -	struct xfs_mount	*mp,
> -	struct xfs_buf		*bp)
> -{
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> -		trace_xfs_bdstrat_shut(bp, _RET_IP_);
> -		xfs_bioerror_relse(bp);
> -		return;
> -	}
> -
> -	xfs_buf_iorequest(bp);
> -}
> -
>  STATIC void
>  _xfs_buf_ioend(
>  	xfs_buf_t		*bp,
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index e656833..7e41b08 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -269,9 +269,6 @@ extern void xfs_buf_unlock(xfs_buf_t *);
>  
>  /* Buffer Read and Write Routines */
>  extern int xfs_bwrite(struct xfs_buf *bp);
> -
> -extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
> -
>  extern void xfs_buf_ioend(xfs_buf_t *,	int);
>  extern void xfs_buf_ioerror(xfs_buf_t *, int);
>  extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
> @@ -282,6 +279,8 @@ extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
>  #define xfs_buf_zero(bp, off, len) \
>  	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
>  
> +extern int xfs_bioerror_relse(struct xfs_buf *);
> +
>  static inline int xfs_buf_geterror(xfs_buf_t *bp)
>  {
>  	return bp ? bp->b_error : ENOMEM;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 07ab52c..73c1493 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -193,7 +193,10 @@ xlog_bread_noalign(
>  	bp->b_io_length = nbblks;
>  	bp->b_error = 0;
>  
> -	xfsbdstrat(log->l_mp, bp);
> +	if (XFS_FORCED_SHUTDOWN(log->l_mp))
> +		return XFS_ERROR(EIO);
> +
> +	xfs_buf_iorequest(bp);
>  	error = xfs_buf_iowait(bp);
>  	if (error)
>  		xfs_buf_ioerror_alert(bp, __func__);
> @@ -4408,7 +4411,11 @@ xlog_do_recover(
>  	XFS_BUF_READ(bp);
>  	XFS_BUF_UNASYNC(bp);
>  	bp->b_ops = &xfs_sb_buf_ops;
> -	xfsbdstrat(log->l_mp, bp);
> +
> +	if (XFS_FORCED_SHUTDOWN(log->l_mp))
> +		return XFS_ERROR(EIO);
> +

I think we need a

xfs_buf_relse(bp);

before returning.  Looks good otherwise.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
