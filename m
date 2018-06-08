Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:42228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752665AbeFHMHL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:07:11 -0400
Date: Fri, 8 Jun 2018 08:07:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: allow delwri requeue of wait listed buffers
Message-ID: <20180608120709.GA23628@bfoster>
References: <20180607124125.38700-1-bfoster@redhat.com>
 <20180607124125.38700-3-bfoster@redhat.com>
 <20180607232713.GV10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607232713.GV10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 08, 2018 at 09:27:13AM +1000, Dave Chinner wrote:
> On Thu, Jun 07, 2018 at 08:41:25AM -0400, Brian Foster wrote:
> > If a delwri queue occurs of a buffer that was previously submitted
> > from a delwri queue but has not yet been removed from a wait list,
> > the queue sets _XBF_DELWRI_Q without changing the state of ->b_list.
> > This occurs, for example, if another thread beats the submitter
> > thread to the buffer lock after I/O completion. Once the submitter
> > acquires the lock, it removes the buffer from the wait list and
> > leaves a buffer with _XBF_DELWRI_Q set but not populated on a list.
> > This results in a lost buffer submission and in turn can result in
> > assert failures due to _XBF_DELWRI_Q being set on buffer reclaim or
> > filesystem lockups if the buffer happens to cover an item in the
> > AIL.
> 
> I just so happened to have this ASSERT happen over night on
> generic/232 testing some code I wrote yesterday. It never ceases to
> amaze me how bugs that have been around for ages always seem to be
> hit at the same time by different people in completely different
> contexts....
> 

Interesting, out of curiosity was this in a memory limited environment?

> > This problem has been reproduced by repeated iterations of xfs/305
> > on high CPU count (28xcpu) systems with limited memory (~1GB). Dirty
> > dquot reclaim races with an xfsaild push of a separate dquot backed
> > by the same buffer such that the buffer sits on the reclaim wait
> > list at the time xfsaild attempts to queue it. Since the latter
> > dquot has been flush locked but the underlying buffer not submitted
> > for I/O, the dquot pins the AIL and causes the filesystem to
> > livelock.
> > 
> > To address this problem, allow a delwri queue of a wait listed
> > buffer to steal the buffer from the wait list and add it to the
> > associated delwri queue. This is fundamentally safe because the
> > purpose of the wait list is to provide synchronous I/O. The buffer
> > lock of each wait listed buffer is cycled to ensure that I/O has
> > completed. If another thread acquires the buffer lock first, then
> > the I/O has completed and the submitter lock cycle is a formality.
> > 
> > The tradeoff to this approach is that the submitter loses the
> > ability to check error state of stolen buffers. This is technically
> > already possible as once the lock is released there is no guarantee
> > another thread has not interfered with the buffer error state by the
> > time the submitter reacquires the lock. Further, most critical error
> > handling occurs in the iodone callbacks in completion context of the
> > specific buffer since the delwri submitter has no idea which buffer
> > failed in the first place. Finally, the stolen buffer case should be
> > relatively rare and limited to races when under the highly parallel
> > and low memory conditions described above.
> 
> This seems all a bit broken.
> 

Yes, the premise of this was to do something that didn't break it
further. ;) I figured using sync I/O would also address the problem, but
would introduce terrible submission->completion serialization...

> The fundamental problem is that we are waiting on buffer locks for
> completion, assuming that nobody else can get the lock before we do
> to tell us that completion has occured. IMO, it's the way we are
> doing the bulk buffer IO submission and waiting that is broken, not
> the wait the delwri queues are handled.
> 
> i.e. we need to take ownership of the buffer lock across
> xfs_buf_delwri_submit_buffers() and the wait loop in
> xfs_buf_delwri_submit() because we assume that the delwri code is
> the only context with access to the buffer while it is under IO. We
> already have an IO waiting mechanism that does this - it's used by
> xfs_buf_submit_wait().
> 
> So what I think we really need to do is split xfs_buf_submit_wait()
> into two halves so we can separate the submission and waiting. TO
> save trying to explain it in great detail, I just wrote some
> (untested!) code below that makes delwri submission hold the lock
> itself until the IO has completed.
> 

So essentially take apart sync buffer I/O so we can do batched
submission/completion. That sounds like a nice idea to me.

Feedback on the code to follow. That aside, are you planning to turn
this into a real patch submission or would you like me to do it?

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: fix races waiting for delwri buffers
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> ---
>  fs/xfs/xfs_buf.c | 147 +++++++++++++++++++++++++++----------------------------
>  1 file changed, 71 insertions(+), 76 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a9678c2f3810..40f441e96dc5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1453,27 +1453,20 @@ _xfs_buf_ioapply(
>  }
>  
>  /*
> - * Asynchronous IO submission path. This transfers the buffer lock ownership and
> - * the current reference to the IO. It is not safe to reference the buffer after
> - * a call to this function unless the caller holds an additional reference
> - * itself.
> + * Internal I/O submission helpers for split submission and waiting actions.
>   */
> -void
> -xfs_buf_submit(
> +static int
> +__xfs_buf_submit(

It looks like the buffer submission refactoring could be a separate
patch from the delwri queue race fix.

>  	struct xfs_buf	*bp)
>  {
> -	trace_xfs_buf_submit(bp, _RET_IP_);
> -
>  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
> -	ASSERT(bp->b_flags & XBF_ASYNC);
>  
>  	/* on shutdown we stale and complete the buffer immediately */
>  	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
>  		xfs_buf_ioerror(bp, -EIO);
>  		bp->b_flags &= ~XBF_DONE;
>  		xfs_buf_stale(bp);
> -		xfs_buf_ioend(bp);
> -		return;
> +		return -EIO;
>  	}
>  
>  	if (bp->b_flags & XBF_WRITE)
> @@ -1483,12 +1476,8 @@ xfs_buf_submit(
>  	bp->b_io_error = 0;
>  
>  	/*
> -	 * The caller's reference is released during I/O completion.
> -	 * This occurs some time after the last b_io_remaining reference is
> -	 * released, so after we drop our Io reference we have to have some
> -	 * other reference to ensure the buffer doesn't go away from underneath
> -	 * us. Take a direct reference to ensure we have safe access to the
> -	 * buffer until we are finished with it.
> +	 * I/O needs a reference, because the caller may go away before we are
> +	 * done with the IO. Completion will deal with it.
>  	 */
>  	xfs_buf_hold(bp);

I think this should be lifted in the callers. For one, it's confusing to
follow. Second, it looks like xfs_buf_submit() unconditionally drops a
reference whereas __xfs_buf_submit() may not acquire one (i.e. when we
return an error).

ISTM that the buffer reference calls could be balanced in the top-level
submit functions rather than split between the common submission path
and unique sync completion path.

>  
> @@ -1498,21 +1487,66 @@ xfs_buf_submit(
>  	 * xfs_buf_ioend too early.
>  	 */
>  	atomic_set(&bp->b_io_remaining, 1);
> -	xfs_buf_ioacct_inc(bp);
> +	if (bp->b_flags & XBF_ASYNC)
> +		xfs_buf_ioacct_inc(bp);
>  	_xfs_buf_ioapply(bp);
> +	return 0;
> +}
> +
> +static int
> +__xfs_buf_iowait(
> +	struct xfs_buf	*bp)
> +{
> +	int		error;
> +
> +	/*
> +	 * make sure we run completion synchronously if it raced with us and is
> +	 * already complete.
> +	 */
> +	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
> +		xfs_buf_ioend(bp);
> +
> +	/* wait for completion before gathering the error from the buffer */
> +	trace_xfs_buf_iowait(bp, _RET_IP_);
> +	wait_for_completion(&bp->b_iowait);
> +	trace_xfs_buf_iowait_done(bp, _RET_IP_);
> +	error = bp->b_error;
> +
> +	/*
> +	 * all done now, we can release the hold that keeps the buffer
> +	 * referenced for the entire IO.
> +	 */
> +	xfs_buf_rele(bp);
> +	return error;
> +}
> +
> +/*
> + * Asynchronous IO submission path. This transfers the buffer lock ownership and
> + * the current reference to the IO. It is not safe to reference the buffer after
> + * a call to this function unless the caller holds an additional reference
> + * itself.
> + */
> +void
> +xfs_buf_submit(
> +	struct xfs_buf	*bp)
> +{
> +	int		error;
> +
> +	trace_xfs_buf_submit(bp, _RET_IP_);
> +
> +	error = __xfs_buf_submit(bp);
>  
>  	/*
>  	 * If _xfs_buf_ioapply failed, we can get back here with only the IO
>  	 * reference we took above. If we drop it to zero, run completion so
>  	 * that we don't return to the caller with completion still pending.
>  	 */
> -	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
> +	if (error || atomic_dec_and_test(&bp->b_io_remaining) == 1) {
>  		if (bp->b_error)
>  			xfs_buf_ioend(bp);
>  		else
>  			xfs_buf_ioend_async(bp);
>  	}
> -
>  	xfs_buf_rele(bp);
>  	/* Note: it is not safe to reference bp now we've dropped our ref */
>  }
> @@ -1527,57 +1561,13 @@ xfs_buf_submit_wait(
>  	int		error;
>  
>  	trace_xfs_buf_submit_wait(bp, _RET_IP_);
> +	ASSERT(!(bp->b_flags & XBF_ASYNC));
>  
> -	ASSERT(!(bp->b_flags & (_XBF_DELWRI_Q | XBF_ASYNC)));
> -
> -	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> -		xfs_buf_ioerror(bp, -EIO);
> -		xfs_buf_stale(bp);
> -		bp->b_flags &= ~XBF_DONE;
> -		return -EIO;
> -	}
> -
> -	if (bp->b_flags & XBF_WRITE)
> -		xfs_buf_wait_unpin(bp);
> -
> -	/* clear the internal error state to avoid spurious errors */
> -	bp->b_io_error = 0;
> -
> -	/*
> -	 * For synchronous IO, the IO does not inherit the submitters reference
> -	 * count, nor the buffer lock. Hence we cannot release the reference we
> -	 * are about to take until we've waited for all IO completion to occur,
> -	 * including any xfs_buf_ioend_async() work that may be pending.
> -	 */
> -	xfs_buf_hold(bp);
> -
> -	/*
> -	 * Set the count to 1 initially, this will stop an I/O completion
> -	 * callout which happens before we have started all the I/O from calling
> -	 * xfs_buf_ioend too early.
> -	 */
> -	atomic_set(&bp->b_io_remaining, 1);
> -	_xfs_buf_ioapply(bp);
> -
> -	/*
> -	 * make sure we run completion synchronously if it raced with us and is
> -	 * already complete.
> -	 */
> -	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
> -		xfs_buf_ioend(bp);
> -
> -	/* wait for completion before gathering the error from the buffer */
> -	trace_xfs_buf_iowait(bp, _RET_IP_);
> -	wait_for_completion(&bp->b_iowait);
> -	trace_xfs_buf_iowait_done(bp, _RET_IP_);
> -	error = bp->b_error;
> +	error =  __xfs_buf_submit(bp);
> +	if (error)
> +		return error;
>  
> -	/*
> -	 * all done now, we can release the hold that keeps the buffer
> -	 * referenced for the entire IO.
> -	 */
> -	xfs_buf_rele(bp);
> -	return error;
> +	return  __xfs_buf_iowait(bp);
>  }
>  
>  void *
> @@ -2045,14 +2035,21 @@ xfs_buf_delwri_submit_buffers(
>  		 * at this point so the caller can still access it.
>  		 */
>  		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
> -		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
> +		bp->b_flags |= XBF_WRITE;

We set XBF_ASYNC below in the specific case, but this doesn't tell us
anything about whether it might have already been set on the buffer. Is
it not the responsibility of this function to set/clear XBF_ASYNC
appropriately?

>  		if (wait_list) {
> +			/*
> +			 * Split synchronous IO - we wait later, so we need ai
> +			 * reference until we run completion processing and drop
> +			 * the buffer lock ourselves
> +			 */

Might as well merge this with the comment above, which needs fixing
anyways since we no longer "do all IO submission async."

>  			xfs_buf_hold(bp);

I think the buffer reference counting is now broken here. We currently
transfer the existing hold (when the buffer was queued) to the async
buffer submission. The wait list case acquires the new hold above and
drops it after cycling the buffer lock and dropping it from the wait
list. Async I/O completion will have dropped the queue hold so when the
whole thing returns the buffer is essentially free.

The async/nowait case still looks Ok. The sync I/O case continues to
grab the wait list reference above, but now sends the buffer through the
sync submission path which will not release the original hold acquired
for the queue upon I/O completion. Unless I'm missing something, it
looks to me that we now return with an elevated hold count. Instead, I
think we should "transfer" the pre-existing queue hold to the wait list
(and document this mess in the comment).

>  			list_move_tail(&bp->b_list, wait_list);
> -		} else
> +			__xfs_buf_submit(bp);

I suspect we need to handle submission errors here, otherwise we wait on
a buffer that was never submitted.

One final thought.. ISTM that the nature of batched sync buffer
submission means that once we wait on one or two of those buffers,
there's a good chance many of the remaining buffer physical I/Os will
have completed by the time we get to the associated iowait. That means
that the current behavior of large (sync) delwri buffer completions
running in the async completion workqueue most likely changes to running
from __xfs_buf_iowait()->xfs_buf_ioend() context. I'm not sure that
really matters, but just something to note. It does make me wonder
whether the extra b_io_remaining submission reference could/should be
decremented in the submission path for both I/O types (which also seems
cleaner from a code perspective).

Brian

> +		} else {
>  			list_del_init(&bp->b_list);
> -
> -		xfs_buf_submit(bp);
> +			bp->b_flags |= XBF_ASYNC;
> +			xfs_buf_submit(bp);
> +		}
>  	}
>  	blk_finish_plug(&plug);
>  
> @@ -2099,9 +2096,7 @@ xfs_buf_delwri_submit(
>  
>  		list_del_init(&bp->b_list);
>  
> -		/* locking the buffer will wait for async IO completion. */
> -		xfs_buf_lock(bp);
> -		error2 = bp->b_error;
> +		error2 = __xfs_buf_iowait(bp);
>  		xfs_buf_relse(bp);
>  		if (!error)
>  			error = error2;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
