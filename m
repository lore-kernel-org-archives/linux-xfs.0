Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E79E7F3F
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 08:18:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CFE130404E
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 06:18:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Q8QZNhcRaDF7CaEQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 06:18:41 -0700 (PDT)
Date: Fri, 15 Aug 2014 09:18:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/9] xfs: rework xfs_buf_bio_endio error handling
Message-ID: <20140815131836.GC4096@laptop.bfoster>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408084747-4540-4-git-send-email-david@fromorbit.com>
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

On Fri, Aug 15, 2014 at 04:39:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently the report of a bio error from completion
> immediately marks the buffer with an error. The issue is that this
> is racy w.r.t. synchronous IO - the submitter can see b_error being
> set before the IO is complete, and hence we cannot differentiate
> between submission failures and completion failures.
> 
> Add an internal b_io_error field protected by the b_lock to catch IO
> completion errors, and only propagate that to the buffer during
> final IO completion handling. Hence we can tell in xfs_buf_iorequest
> if we've had a submission failure bey checking bp->b_error before
> dropping our b_io_remaining reference - that reference will prevent
> b_io_error values from being propagated to b_error in the event that
> completion races with submission.
> 
> In doing so, allow xfs_buf_iorequest to return an error. That way,
> the caller can check for submission errors safely if required, and
> easily distinguish them from completion errors that come from
> xfs_buf_iowait().
> 

I don't see any changes to xfs_buf_iorequest() at all in this one.  That
aside, it looks fine. It's not how I was thinking about it, but a clear
separation of submission error regardless.

Brian

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 18 ++++++++++++++++--
>  fs/xfs/xfs_buf.h |  1 +
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1b7f0bc..58ae34c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1008,6 +1008,13 @@ xfs_buf_ioend(
>  
>  	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
>  
> +	/*
> +	 * Pull in IO completion errors now. We are guaranteed to be running
> +	 * single threaded, so we don't need the lock to read b_io_error.
> +	 */
> +	if (!bp->b_error && bp->b_io_error)
> +		xfs_buf_ioerror(bp, bp->b_io_error);
> +
>  	if (!bp->b_error) {
>  		bp->b_flags |= XBF_DONE;
>  
> @@ -1186,8 +1193,12 @@ xfs_buf_bio_end_io(
>  	 * don't overwrite existing errors - otherwise we can lose errors on
>  	 * buffers that require multiple bios to complete.
>  	 */
> -	if (!bp->b_error)
> -		xfs_buf_ioerror(bp, error);
> +	if (error) {
> +		spin_lock(&bp->b_lock);
> +		if (!bp->b_io_error)
> +			bp->b_io_error = error;
> +		spin_unlock(&bp->b_lock);
> +	}
>  
>  	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
>  		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
> @@ -1373,6 +1384,9 @@ xfs_buf_iorequest(
>  	if (bp->b_flags & XBF_WRITE)
>  		xfs_buf_wait_unpin(bp);
>  
> +	/* clear the internal error state to avoid spurious errors */
> +	bp->b_io_error = 0;
> +
>  	/*
>  	 * Take references to the buffer. For XBF_ASYNC buffers, holding a
>  	 * reference for as long as submission takes is all that is necessary
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 4585c15..44db8cd 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -158,6 +158,7 @@ typedef struct xfs_buf {
>  	struct list_head	b_lru;		/* lru list */
>  	spinlock_t		b_lock;		/* internal state lock */
>  	unsigned int		b_state;	/* internal state flags */
> +	int			b_io_error;	/* internal IO error state */
>  	wait_queue_head_t	b_waiters;	/* unpin waiters */
>  	struct list_head	b_list;
>  	struct xfs_perag	*b_pag;		/* contains rbtree root */
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
