Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35629 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387705AbfEWXEv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 19:04:51 -0400
Date: Fri, 24 May 2019 09:04:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/20] xfs: factor out log buffer writing from xlog_sync
Message-ID: <20190523230445.GT29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:29PM +0200, Christoph Hellwig wrote:
> Replace the not very useful xlog_bdstrat wrapper with a new version that
> that takes care of all the common logic for writing log buffers.  Use
> the opportunity to avoid overloading the buffer address with the log
> relative address, and to shed the unused return value.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Some minor things

> @@ -1765,28 +1761,34 @@ xlog_cksum(
>  	return xfs_end_cksum(crc);
>  }
>  
> -/*
> - * The bdstrat callback function for log bufs. This gives us a central
> - * place to trap bufs in case we get hit by a log I/O error and need to
> - * shutdown. Actually, in practice, even when we didn't get a log error,
> - * we transition the iclogs to IOERROR state *after* flushing all existing
> - * iclogs to disk. This is because we don't want anymore new transactions to be
> - * started or completed afterwards.
> - *
> - * We lock the iclogbufs here so that we can serialise against IO completion
> - * during unmount. We might be processing a shutdown triggered during unmount,
> - * and that can occur asynchronously to the unmount thread, and hence we need to
> - * ensure that completes before tearing down the iclogbufs. Hence we need to
> - * hold the buffer lock across the log IO to acheive that.
> - */
> -STATIC int
> -xlog_bdstrat(
> -	struct xfs_buf		*bp)
> +STATIC void
> +xlog_write_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog,
> +	struct xfs_buf		*bp,
> +	uint64_t		bno,
> +	bool			flush)

Can you rename this to need_flush here and in xlog_sync()? I kept
having to check whether it meant "we need a flush" or "we've
already done a flush" while reading the patch.

>  {
> -	struct xlog_in_core	*iclog = bp->b_log_item;
> +	ASSERT(bno < log->l_logBBsize);
> +	ASSERT(bno + bp->b_io_length <= log->l_logBBsize);
>  
> +	bp->b_maps[0].bm_bn = log->l_logBBstart + bno;
> +	bp->b_log_item = iclog;
> +	bp->b_flags &= ~XBF_FLUSH;
> +	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
> +	if (flush)
> +		bp->b_flags |= XBF_FLUSH;
> +
> +	/*
> +	 * We lock the iclogbufs here so that we can serialise against I/O
> +	 * completion during unmount.  We might be processing a shutdown
> +	 * triggered during unmount, and that can occur asynchronously to the
> +	 * unmount thread, and hence we need to ensure that completes before
> +	 * tearing down the iclogbufs.  Hence we need to hold the buffer lock
> +	 * across the log IO to archive that.
				^^^^^^^ achieve 
> +	 */

....

> -	ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
> +	iclog->ic_bp->b_io_length = BTOBB(count);
>  
>  	xlog_verify_iclog(log, iclog, count, true);
> +	xlog_write_iclog(log, iclog, iclog->ic_bp, bno, flush);

Ok, so we set the io length of the buffer before we call
xlog_write_iclog(), avoiding needing to pass the size into it.

> -	/* account for log which doesn't start at block #0 */
> -	XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
> -
> -	/*
> -	 * Don't call xfs_bwrite here. We do log-syncs even when the filesystem
> -	 * is shutting down.
> -	 */
> -	error = xlog_bdstrat(bp);
> -	if (error) {
> -		xfs_buf_ioerror_alert(bp, "xlog_sync");
> -		return error;
> -	}
>  	if (split) {
> -		bp = iclog->ic_log->l_xbuf;
> -		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
> -		xfs_buf_associate_memory(bp,
> +		xfs_buf_associate_memory(iclog->ic_log->l_xbuf,
>  				(char *)&iclog->ic_header + count, split);
> -		bp->b_log_item = iclog;
> -		bp->b_flags &= ~XBF_FLUSH;
> -		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
> -
> -		ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
> -		ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
> -
> -		/* account for internal log which doesn't start at block #0 */
> -		XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
> -		error = xlog_bdstrat(bp);
> -		if (error) {
> -			xfs_buf_ioerror_alert(bp, "xlog_sync (split)");
> -			return error;
> -		}
> +		xlog_write_iclog(log, iclog, iclog->ic_log->l_xbuf, 0, false);

But on the extra buffer, we don't set it's I/O length at all....

Oh, the setting of the IO length is hidden inside
xfs_buf_associate_memory(). Can you add a comment indicating that
this is why we omit the setting of the io length for the extra
buffer?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
