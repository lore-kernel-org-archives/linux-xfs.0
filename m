Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 662567CA1
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 18:58:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38BA8304032
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 16:58:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4OzrsASn514jhZtm for <xfs@oss.sgi.com>;
	Tue, 12 Jul 2016 16:57:55 -0700 (PDT)
Date: Wed, 13 Jul 2016 09:57:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add readahead bufs to lru early to prevent
	post-unmount panic
Message-ID: <20160712235752.GL1922@dastard>
References: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
	<20160630224457.GT12670@dastard>
	<20160701223011.GA28130@bfoster.bfoster>
	<20160705164552.GA6317@bfoster.bfoster>
	<20160711052057.GE1922@dastard>
	<20160711135251.GA32896@bfoster.bfoster>
	<20160711152921.GB32896@bfoster.bfoster>
	<20160711224451.GF1922@dastard>
	<20160712120315.GA4311@bfoster.bfoster>
	<20160712172259.GA22757@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160712172259.GA22757@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 12, 2016 at 01:22:59PM -0400, Brian Foster wrote:
> On Tue, Jul 12, 2016 at 08:03:15AM -0400, Brian Foster wrote:
> > On Tue, Jul 12, 2016 at 08:44:51AM +1000, Dave Chinner wrote:
> > > On Mon, Jul 11, 2016 at 11:29:22AM -0400, Brian Foster wrote:
> > > > On Mon, Jul 11, 2016 at 09:52:52AM -0400, Brian Foster wrote:
> > > > ...
> > > > > So what is your preference out of the possible approaches here? AFAICS,
> > > > > we have the following options:
> > > > > 
> > > > > 1.) The original "add readahead to LRU early" approach.
> > > > > 	Pros: simple one-liner
> > > > > 	Cons: bit of a hack, only covers readahead scenario
> > > > > 2.) Defer I/O count decrement to buffer release (this patch).
> > > > > 	Pros: should cover all cases (reads/writes)
> > > > > 	Cons: more complex (requires per-buffer accounting, etc.)
> > > > > 3.) Raw (buffer or bio?) I/O count (no defer to buffer release)
> > > > > 	Pros: eliminates some complexity from #2
> > > > > 	Cons: still more complex than #1, racy in that decrement does
> > > > > 	not serialize against LRU addition (requires drain_workqueue(),
> > > > > 	which still doesn't cover error conditions)
> > > > > 
> > > > > As noted above, option #3 also allows for either a buffer based count or
> > > > > bio based count, the latter of which might simplify things a bit further
> > > > > (TBD). Thoughts?
> > > 
> > > Pretty good summary :P
> > > 
> > > > FWIW, the following is a slightly cleaned up version of my initial
> > > > approach (option #3 above). Note that the flag is used to help deal with
> > > > varying ioend behavior. E.g., xfs_buf_ioend() is called once for some
> > > > buffers, multiple times for others with an iodone callback, that
> > > > behavior changes in some cases when an error is set, etc. (I'll add
> > > > comments before an official post.)
> > > 
> > > The approach looks good - I think there's a couple of things we can
> > > do to clean it up and make it robust. Comments inline.
> > > 
> > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > index 4665ff6..45d3ddd 100644
> > > > --- a/fs/xfs/xfs_buf.c
> > > > +++ b/fs/xfs/xfs_buf.c
> > > > @@ -1018,7 +1018,10 @@ xfs_buf_ioend(
> > > >  
> > > >  	trace_xfs_buf_iodone(bp, _RET_IP_);
> > > >  
> > > > -	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> > > > +	if (bp->b_flags & XBF_IN_FLIGHT)
> > > > +		percpu_counter_dec(&bp->b_target->bt_io_count);
> > > > +
> > > > +	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD | XBF_IN_FLIGHT);
> > > >  
> > > >  	/*
> > > >  	 * Pull in IO completion errors now. We are guaranteed to be running
> > > 
> > > I think the XBF_IN_FLIGHT can be moved to the final xfs_buf_rele()
> > > processing if:
> > > 
> > > > @@ -1341,6 +1344,11 @@ xfs_buf_submit(
> > > >  	 * xfs_buf_ioend too early.
> > > >  	 */
> > > >  	atomic_set(&bp->b_io_remaining, 1);
> > > > +	if (bp->b_flags & XBF_ASYNC) {
> > > > +		percpu_counter_inc(&bp->b_target->bt_io_count);
> > > > +		bp->b_flags |= XBF_IN_FLIGHT;
> > > > +	}
> > > 
> > > You change this to:
> > > 
> > > 	if (!(bp->b_flags & XBF_IN_FLIGHT)) {
> > > 		percpu_counter_inc(&bp->b_target->bt_io_count);
> > > 		bp->b_flags |= XBF_IN_FLIGHT;
> > > 	}
> > > 
> > 
> > Ok, so use the flag to cap the I/O count and defer the decrement to
> > release. I think that should work and addresses the raciness issue. I'll
> > give it a try.
> > 
> 
> This appears to be doable, but it reintroduces some ugliness from the
> previous approach.

Ah, so it does. Bugger.

> For example, we have to start filtering out uncached
> buffers again (if we defer the decrement to release, we must handle
> never-released buffers one way or another).

So the problem is limited to the superblock buffer and the iclog
buffers, right? How about making that special case explicit via a
flag set on the buffer? e.g. XBF_NO_IOCOUNT. THat way the exceptions
are clearly spelt out, rather than avoiding all uncached buffers?

> Also, given the feedback on
> the previous patch with regard to filtering out non-new buffers from the
> I/O count, I've dropped that and replaced it with updates to
> xfs_buf_rele() to decrement when the buffer is returned to the LRU (we
> either have to filter out buffers already on the LRU at submit time or
> make sure that they are decremented when released back to the LRU).
> 
> Code follows...
> 
> Brian
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 4665ff6..b7afbac 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -80,6 +80,25 @@ xfs_buf_vmap_len(
>  }
>  
>  /*
> + * Clear the in-flight state on a buffer about to be released to the LRU or
> + * freed and unaccount from the buftarg. The buftarg I/O count maintains a count
> + * of held buffers that have undergone at least one I/O in the current hold
> + * cycle (e.g., not a total I/O count). This provides protection against unmount
> + * for buffer I/O completion (see xfs_wait_buftarg()) processing.
> + */
> +static inline void
> +xfs_buf_rele_in_flight(
> +	struct xfs_buf	*bp)

Not sure about the name: xfs_buf_ioacct_dec()?

> +{
> +	if (!(bp->b_flags & _XBF_IN_FLIGHT))
> +		return;
> +
> +	ASSERT(bp->b_flags & XBF_ASYNC);
> +	bp->b_flags &= ~_XBF_IN_FLIGHT;
> +	percpu_counter_dec(&bp->b_target->bt_io_count);
> +}
> +
> +/*
>   * When we mark a buffer stale, we remove the buffer from the LRU and clear the
>   * b_lru_ref count so that the buffer is freed immediately when the buffer
>   * reference count falls to zero. If the buffer is already on the LRU, we need
> @@ -866,30 +885,37 @@ xfs_buf_hold(
>  }
>  
>  /*
> - *	Releases a hold on the specified buffer.  If the
> - *	the hold count is 1, calls xfs_buf_free.
> + * Release a hold on the specified buffer. If the hold count is 1, the buffer is
> + * placed on LRU or freed (depending on b_lru_ref).
>   */
>  void
>  xfs_buf_rele(
>  	xfs_buf_t		*bp)
>  {
>  	struct xfs_perag	*pag = bp->b_pag;
> +	bool			release;
> +	bool			freebuf = false;
>  
>  	trace_xfs_buf_rele(bp, _RET_IP_);
>  
>  	if (!pag) {
>  		ASSERT(list_empty(&bp->b_lru));
>  		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
> -		if (atomic_dec_and_test(&bp->b_hold))
> +		if (atomic_dec_and_test(&bp->b_hold)) {
> +			xfs_buf_rele_in_flight(bp);
>  			xfs_buf_free(bp);
> +		}
>  		return;
>  	}
>  
>  	ASSERT(!RB_EMPTY_NODE(&bp->b_rbnode));
>  
>  	ASSERT(atomic_read(&bp->b_hold) > 0);
> -	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
> -		spin_lock(&bp->b_lock);
> +
> +	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
> +	spin_lock(&bp->b_lock);
> +	if (release) {
> +		xfs_buf_rele_in_flight(bp);
>  		if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
>  			/*
>  			 * If the buffer is added to the LRU take a new
> @@ -900,7 +926,6 @@ xfs_buf_rele(
>  				bp->b_state &= ~XFS_BSTATE_DISPOSE;
>  				atomic_inc(&bp->b_hold);
>  			}
> -			spin_unlock(&bp->b_lock);
>  			spin_unlock(&pag->pag_buf_lock);
>  		} else {
>  			/*
> @@ -914,15 +939,24 @@ xfs_buf_rele(
>  			} else {
>  				ASSERT(list_empty(&bp->b_lru));
>  			}
> -			spin_unlock(&bp->b_lock);
>  
>  			ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  			rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
>  			spin_unlock(&pag->pag_buf_lock);
>  			xfs_perag_put(pag);
> -			xfs_buf_free(bp);
> +			freebuf = true;
>  		}
> +	} else if ((atomic_read(&bp->b_hold) == 1) && !list_empty(&bp->b_lru)) {
> +		/*
> +		 * The buffer is already on the LRU and it holds the only
> +		 * reference. Drop the in flight state.
> +		 */
> +		xfs_buf_rele_in_flight(bp);
>  	}

This b_hold check is racy - bp->b_lock is not enough to stabilise
the b_hold count. Because we don't hold the buffer semaphore any
more, another buffer reference holder can successfully run the above
atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock). New references
can be taken in xfs_buf_find() so the count could go up, but I
think that's fine given the eventual case we care about here is
draining references on unmount.

I think this is still ok for draining references, too, because of
the flag check inside xfs_buf_rele_in_flight(). If we race on a
transition a value of 1, then we end running the branch in each
caller. If we race on transition to zero, then the caller that is
releasing the buffer will execute xfs_buf_rele_in_flight() and all
will be well.

Needs comments, and maybe restructing the code to handle the
xfs_buf_rele_in_flight() call up front so it's clear that io
accounting is clearly a separate case from the rest of release
handling. e.g.

	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
	spin_lock(&bp->b_lock);
	if (!release) {
		if (!(atomic_read(&bp->b_hold) == 1) && !list_empty(&bp->b_lru))
			xfs_buf_ioacct_dec(bp);
		goto out_unlock;
	}
	xfs_buf_ioacct_dec(bp);

	/* rest of release code, one level of indentation removed */

out_unlock:
	spin_unlock(&bp->b_lock);

	if (freebuf)
		xfs_buf_free(bp);



> @@ -1341,6 +1375,18 @@ xfs_buf_submit(
>  	 * xfs_buf_ioend too early.
>  	 */
>  	atomic_set(&bp->b_io_remaining, 1);
> +
> +	/*
> +	 * Bump the I/O in flight count on the buftarg if we haven't yet done
> +	 * so for this buffer. Skip uncached buffers because many of those
> +	 * (e.g., superblock, log buffers) are never released.
> +	 */
> +	if ((bp->b_bn != XFS_BUF_DADDR_NULL) &&
> +	    !(bp->b_flags & _XBF_IN_FLIGHT)) {
> +		bp->b_flags |= _XBF_IN_FLIGHT;
> +		percpu_counter_inc(&bp->b_target->bt_io_count);
> +	}

xfs_buf_ioacct_inc()
{
	if (bp->b_flags & (XBF_NO_IOACCT | _XBF_IN_FLIGHT))
		return;
	percpu_counter_inc(&bp->b_target->bt_io_count);
	bp->b_flags |= _XBF_IN_FLIGHT;
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
