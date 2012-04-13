Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DBbdl9033982 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 06:37:40 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rQmt7D4HaCTaWHHg for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 04:37:37 -0700 (PDT)
Date: Fri, 13 Apr 2012 21:37:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/10] xfs: on-stack delayed write buffer lists
Message-ID: <20120413113734.GM6734@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164646.975031281@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327164646.975031281@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 12:44:09PM -0400, Christoph Hellwig wrote:
> Queue delwri buffers on a local on-stack list instead of a per-buftarg one,
> and write back the buffers per-process instead of by waking up xfsbufd.
> 
> This is now easily doable given that we have very few places left that write
> delwri buffers:
> 
>  - log recovery:
> 	Only done at mount time, and already forcing out the buffers
> 	synchronously using xfs_flush_buftarg
> 
>  - quotacheck:
> 	Same story.
> 
>  - dquot reclaim:
> 	Writes out dirty dquots on the LRU under memory pressure.  We might
> 	want to look into doing more of this via xfsaild, but it's already
> 	more optimal than the synchronous inode reclaim that writes each
> 	buffer synchronously.
> 
>  - xfsaild:
> 	This is the main beneficiary of the change.  By keeping a local list
> 	of buffers to write we reduce latency of writing out buffers, and
> 	more importably we can remove all the delwri list promotions which
> 	were hitting the buffer cache hard under sustained metadata loads.
> 
> The implementation is very straight forward - xfs_buf_delwri_queue now gets
> a new list_head pointer that it adds the delwri buffers to, and all callers
> need to eventually submit the list using xfs_buf_delwi_submit or
> xfs_buf_delwi_submit_nowait.  Buffers that already are on a delwri list are
> skipped in xfs_buf_delwri_queue, assuming they already are on another delwri
> list.  The biggest change to pass down the buffer list was done to the AIL
> pushing. Now that we operate on buffers the trylock, push and pushbuf log
> item methods are merged into a single push routine, which tries to lock the
> item, and if possible add the buffer that needs writeback to the buffer list.
> This leads to much simpler code than the previous split but requires the
> individual IOP_PUSH instances to unlock and reacquire the AIL around calls
> to blocking routines.
> 
> Given that xfsailds now also handles writing out buffers the conditions for
> log forcing and the sleep times needed some small changes.  The most
> important one is that we consider an AIL busy as long we still have buffers
> to push, and the other one is that we do increment the pushed LSN for
> buffers that are under flushing at this moment, but still count them towards
> the stuck items for restart purposes.  Without this we could hammer on stuck
> items without ever forcing the log and not make progress under heavy random
> delete workloads on fast flash storage devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Log recovery changes look OK - makes it quite obvious that the
buffers are all submitted at once. That's probably good - recovery
can do lots of reading to bring objects in, so avoiding writing at
the same time will help speed that up.

> Index: xfs/fs/xfs/xfs_buf.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_buf.c	2012-03-25 16:41:00.144550722 +0200
> +++ xfs/fs/xfs/xfs_buf.c	2012-03-25 17:11:17.154584413 +0200
> @@ -42,7 +42,6 @@
>  #include "xfs_trace.h"
>  
>  static kmem_zone_t *xfs_buf_zone;
> -STATIC int xfsbufd(void *);
>  
>  static struct workqueue_struct *xfslogd_workqueue;
>  
> @@ -144,8 +143,11 @@ void
>  xfs_buf_stale(
>  	struct xfs_buf	*bp)
>  {
> +	ASSERT(xfs_buf_islocked(bp));
> +
>  	bp->b_flags |= XBF_STALE;
> -	xfs_buf_delwri_dequeue(bp);
> +	bp->b_flags &= ~_XBF_DELWRI_Q;
> +

The reason for clearing the DELWRI_Q flag is not obvious here.
Perhaps a comment to say that the delwri list has a reference and
clearing the flag will ensure that it does not write it out?

.....

> -void
> -xfs_buf_delwri_promote(
> -	struct xfs_buf	*bp)
> -{
> -	struct xfs_buftarg *btp = bp->b_target;
> -	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10) + 1;
> -
> -	ASSERT(bp->b_flags & XBF_DELWRI);
> -	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
> +	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
>  
>  	/*
> -	 * Check the buffer age before locking the delayed write queue as we
> -	 * don't need to promote buffers that are already past the flush age.
> +	 * If a buffer gets written out synchronously while it is on a delwri
> +	 * list we lazily remove it, aka only the _XBF_DELWRI_Q flag gets

                                     - the write will clear the _XBF_DELWRI_Q flag

....

> +static int
> +__xfs_buf_delwri_submit(
> +	struct list_head	*submit_list,
> +	struct list_head	*list,
> +	bool			wait)

It might be worth adding a comment describing the way the lists are
used. I was a little confused about the names of them - @submit_list
is the list of buffers that IO was started on, but @list is the list
of buffers that we are submitting for write processing. Perhaps just
naming them better will avoid that confusion in future. e.g. io_list
for the list of buffers we started IO on, buffer_list for the
incoming buffer list that we need to process?

.....
>  /*
> - *	Go through all incore buffers, and release buffers if they belong to
> - *	the given device. This is used in filesystem error handling to
> - *	preserve the consistency of its metadata.
> + * Write out a buffer list asynchronously.
> + *
> + * This will take the buffer list, write all non-locked and non-pinned buffers

And the incoming list is called the buffer list here, so maybe
naming it that is best, and using it consistently for all 3 delwri
submit functions...

....

> @@ -989,20 +938,27 @@ xfs_buf_iodone_callbacks(
>  	 * If the write was asynchronous then no one will be looking for the
>  	 * error.  Clear the error state and write the buffer out again.
>  	 *
> -	 * During sync or umount we'll write all pending buffers again
> -	 * synchronous, which will catch these errors if they keep hanging
> -	 * around.
> +	 * XXX: This helps against transient write errors, but we need to find
> +	 * a way to shut the filesystem down if the writes keep failing.
> +	 *
> +	 * In practice we'll shut the filesystem down soon as non-transient
> +	 * erorrs tend to affect the whole device and a failing log write
> +	 * will make us give up.  But we really ought to do better here.
>  	 */
>  	if (XFS_BUF_ISASYNC(bp)) {
> +		ASSERT(bp->b_iodone != NULL);
> +
> +		trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
> +
>  		xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */
>  
>  		if (!XFS_BUF_ISSTALE(bp)) {
> -			xfs_buf_delwri_queue(bp);
> -			XFS_BUF_DONE(bp);
> +			bp->b_flags |= XBF_WRITE | XBF_ASYNC | XBF_DONE;
> +			xfs_bdstrat_cb(bp);

I don't think this is an equivalent transformation.

This will just resubmit the IO immediately after it is failed, while
previously it will only be pushed again after it ages out (15s
later). Perhaps it can just be left to be pushed by the aild next
time it passes over it?

> + * There isn't much you can do to push on an efd item.  It is simply stuck
> + * waiting for the log to be flushed to disk.
>   */
>  STATIC uint
> -xfs_efd_item_trylock(
> -	struct xfs_log_item	*lip)
> +xfs_efd_item_push(
> +	struct xfs_log_item	*lip,
> +	struct list_head	*buffer_list)
>  {
>  	return XFS_ITEM_LOCKED;

Perhaps that should actually be XFS_ITEM_PINNED, like the efi item.

> Index: xfs/fs/xfs/xfs_trans_ail.c

The aild pushing changes look OK.

> @@ -547,6 +527,8 @@ xfsaild(
>  	struct xfs_ail	*ailp = data;
>  	long		tout = 0;	/* milliseconds */
>  
> +	current->flags |= PF_MEMALLOC;
> +
>  	while (!kthread_should_stop()) {
>  		if (tout && tout <= 20)
>  			__set_current_state(TASK_KILLABLE);

I'm not sure that PF_MEMALLOC is really necessary for the aild. Is
there any particular reason for adding the flag here?

> @@ -183,7 +171,7 @@ xfs_qm_dqpurge(
>  		 * to purge this dquot anyway, so we go ahead regardless.
>  		 */
>  		error = xfs_qm_dqflush(dqp, &bp);
> -		if (error)
> +		if (error) {
>  			xfs_warn(mp, "%s: dquot %p flush failed",
>  				__func__, dqp);
>  		} else {

I think that's fixing a problem from a previous patch that I
missed....

Otherwise it looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
