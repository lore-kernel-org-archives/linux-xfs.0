Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 091827F3F
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 09:35:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D06FB304043
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 07:35:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Y04sZoE659CcZnAj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 07:35:46 -0700 (PDT)
Date: Fri, 15 Aug 2014 10:35:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: xfs_bioerror can die.
Message-ID: <20140815143540.GD4096@laptop.bfoster>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408084747-4540-6-git-send-email-david@fromorbit.com>
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

On Fri, Aug 15, 2014 at 04:39:03PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Internal buffer write error handling is a mess due to the unnatural
> split between xfs_bioerror and xfs_bioerror_relse(). The buffer
> reference counting is also wrong for the xfs_bioerror path for
> xfs_bwrite - it uses sync IO and so xfs_buf_ioend will release a
> hold count that was never taken.
> 
> Further, xfs_bwrite only does sync IO and determines the handler to
> call based on b_iodone, so for this caller the only difference
> between xfs_bioerror() and xfs_bioerror_release() is the XBF_DONE
> flag. We don't care what the XBF_DONE flag state is because we stale
> the buffer in both paths - the next buffer lookup will clear
> XBF_DONE anyway because XBF_STALE is set. Hence we can use common
> error handling for xfs_bwrite().
> 
> __xfs_buf_delwri_submit() is a similar - it's only ever called
> on writes - all sync or async - and again there's no reason to
> handle them any differently at all.
> 
> Clean up the nasty error handling and remove xfs_bioerror().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 67 +++++++++++++++++---------------------------------------
>  1 file changed, 20 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 98fcf5a..f444285 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1072,36 +1072,6 @@ xfs_buf_ioerror_alert(
>  }
>  
>  /*
> - * Called when we want to stop a buffer from getting written or read.
> - * We attach the EIO error, muck with its flags, and call xfs_buf_ioend
> - * so that the proper iodone callbacks get called.
> - */
> -STATIC int
> -xfs_bioerror(
> -	xfs_buf_t *bp)
> -{
> -#ifdef XFSERRORDEBUG
> -	ASSERT(XFS_BUF_ISREAD(bp) || bp->b_iodone);
> -#endif
> -
> -	/*
> -	 * No need to wait until the buffer is unpinned, we aren't flushing it.
> -	 */
> -	xfs_buf_ioerror(bp, -EIO);
> -
> -	/*
> -	 * We're calling xfs_buf_ioend, so delete XBF_DONE flag.
> -	 */
> -	XFS_BUF_UNREAD(bp);
> -	XFS_BUF_UNDONE(bp);
> -	xfs_buf_stale(bp);
> -
> -	xfs_buf_ioend(bp);
> -
> -	return -EIO;
> -}
> -
> -/*
>   * Same as xfs_bioerror, except that we are releasing the buffer
>   * here ourselves, and avoiding the xfs_buf_ioend call.
>   * This is meant for userdata errors; metadata bufs come with
> @@ -1149,19 +1119,19 @@ xfs_bwrite(
>  	ASSERT(xfs_buf_islocked(bp));
>  
>  	bp->b_flags |= XBF_WRITE;
> -	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q | XBF_WRITE_FAIL);
> +	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
> +			 XBF_WRITE_FAIL | XBF_DONE);
>  
>  	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
>  		trace_xfs_bdstrat_shut(bp, _RET_IP_);
>  
> -		/*
> -		 * Metadata write that didn't get logged but written anyway.
> -		 * These aren't associated with a transaction, and can be
> -		 * ignored.
> -		 */
> -		if (!bp->b_iodone)
> -			return xfs_bioerror_relse(bp);
> -		return xfs_bioerror(bp);
> +		xfs_buf_ioerror(bp, -EIO);
> +		xfs_buf_stale(bp);
> +
> +		/* sync IO, xfs_buf_ioend is going to remove a ref here */
> +		xfs_buf_hold(bp);

Looks correct, but that's kind of ugly. The reference serves no purpose
except to appease the error sequence. It gives the impression that the
reference management should be handled at a higher level (and with truly
synchronous I/O primitives/mechanisms, it is ;).

At the very least, can we reorganize the ioend side of things to handle
this? We already have the duplicate execution issue previously mentioned
that has to get resolved. Some duplicate code is fine if it improves
clarity, imo.

Brian

> +		xfs_buf_ioend(bp);
> +		return -EIO;
>  	}
>  
>  	xfs_buf_iorequest(bp);
> @@ -1848,16 +1818,19 @@ __xfs_buf_delwri_submit(
>  		if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
>  			trace_xfs_bdstrat_shut(bp, _RET_IP_);
>  
> +			xfs_buf_ioerror(bp, -EIO);
> +			xfs_buf_stale(bp);
> +
>  			/*
> -			 * Metadata write that didn't get logged but written anyway.
> -			 * These aren't associated with a transaction, and can be
> -			 * ignored.
> +			 * if sync IO, xfs_buf_ioend is going to remove a
> +			 * ref here. We need to add that so we can collect
> +			 * all the buffer errors in the wait loop.
>  			 */
> -			if (!bp->b_iodone)
> -				return xfs_bioerror_relse(bp);
> -			return xfs_bioerror(bp);
> -		}
> -		xfs_buf_iorequest(bp);
> +			if (wait)
> +				xfs_buf_hold(bp);
> +			xfs_buf_ioend(bp);
> +		} else
> +			xfs_buf_iorequest(bp);
>  	}
>  	blk_finish_plug(&plug);
>  
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
