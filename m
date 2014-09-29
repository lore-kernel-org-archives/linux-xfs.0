Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 58F1C8007
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 14:09:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 390EE304051
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 12:09:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FKoKSHXDek1xWC9w (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 12:09:28 -0700 (PDT)
Date: Mon, 29 Sep 2014 15:09:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/11] xfs: kill xfs_bioerror_relse
Message-ID: <20140929190921.GB35666@bfoster.bfoster>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
	<1411648461-29003-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411648461-29003-9-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 25, 2014 at 10:34:18PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is only one caller now - xfs_trans_read_buf_map() - and it has
> very well defined call semantics - read, synchronous, and b_iodone
> is NULL. Hence it's pretty clear what error handling is necessary
> for this case. The bigger problem of untangling
> xfs_trans_read_buf_map error handling is left to a future patch.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c       | 39 ---------------------------------------
>  fs/xfs/xfs_buf.h       |  2 --
>  fs/xfs/xfs_trans_buf.c |  9 ++++++---
>  3 files changed, 6 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index cc6a558..4696ff5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1074,45 +1074,6 @@ xfs_buf_ioerror_alert(
>  		(__uint64_t)XFS_BUF_ADDR(bp), func, -bp->b_error, bp->b_length);
>  }
>  
> -/*
> - * Same as xfs_bioerror, except that we are releasing the buffer
> - * here ourselves, and avoiding the xfs_buf_ioend call.
> - * This is meant for userdata errors; metadata bufs come with
> - * iodone functions attached, so that we can track down errors.
> - */
> -int
> -xfs_bioerror_relse(
> -	struct xfs_buf	*bp)
> -{
> -	int64_t		fl = bp->b_flags;
> -	/*
> -	 * No need to wait until the buffer is unpinned.
> -	 * We aren't flushing it.
> -	 *
> -	 * chunkhold expects B_DONE to be set, whether
> -	 * we actually finish the I/O or not. We don't want to
> -	 * change that interface.
> -	 */
> -	XFS_BUF_UNREAD(bp);
> -	XFS_BUF_DONE(bp);
> -	xfs_buf_stale(bp);
> -	bp->b_iodone = NULL;
> -	if (!(fl & XBF_ASYNC)) {
> -		/*
> -		 * Mark b_error and B_ERROR _both_.
> -		 * Lot's of chunkcache code assumes that.
> -		 * There's no reason to mark error for
> -		 * ASYNC buffers.
> -		 */
> -		xfs_buf_ioerror(bp, -EIO);
> -		complete(&bp->b_iowait);
> -	} else {
> -		xfs_buf_relse(bp);
> -	}
> -
> -	return -EIO;
> -}
> -
>  int
>  xfs_bwrite(
>  	struct xfs_buf		*bp)
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 44db8cd..d8f57f6 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -297,8 +297,6 @@ extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
>  #define xfs_buf_zero(bp, off, len) \
>  	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
>  
> -extern int xfs_bioerror_relse(struct xfs_buf *);
> -
>  /* Buffer Utility Routines */
>  extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
>  
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 96c898e..db4be5b 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -324,11 +324,14 @@ xfs_trans_read_buf_map(
>  			 */
>  			if (XFS_FORCED_SHUTDOWN(mp)) {
>  				trace_xfs_bdstrat_shut(bp, _RET_IP_);
> -				xfs_bioerror_relse(bp);
> -			} else {
> -				xfs_buf_iorequest(bp);
> +				bp->b_flags &= ~(XBF_READ | XBF_DONE);
> +				xfs_buf_ioerror(bp, -EIO);
> +				xfs_buf_stale(bp);
> +				xfs_buf_relse(bp);

Where does the xfs_buf_relse() come from in this particular scenario?
Shouldn't the bp still remain locked/reffed against the transaction?

Brian

P.S., I realized it doesn't matter too much because this whole block
goes away in the subsequent patch.

> +				return -EIO;
>  			}
>  
> +			xfs_buf_iorequest(bp);
>  			error = xfs_buf_iowait(bp);
>  			if (error) {
>  				xfs_buf_ioerror_alert(bp, __func__);
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
