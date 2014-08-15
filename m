Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D6DF29DF9
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 18:58:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 587133040A4
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 16:58:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CAZyZPL3oz9ZgYHt for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 16:58:18 -0700 (PDT)
Date: Sat, 16 Aug 2014 09:58:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/9] xfs: introduce xfs_buf_submit[_wait]
Message-ID: <20140815235804.GZ26465@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-9-git-send-email-david@fromorbit.com>
	<20140815161319.GF4096@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815161319.GF4096@laptop.bfoster>
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

On Fri, Aug 15, 2014 at 12:13:20PM -0400, Brian Foster wrote:
> On Fri, Aug 15, 2014 at 04:39:06PM +1000, Dave Chinner wrote:
> > +	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> > +		xfs_buf_ioerror(bp, -EIO);
> > +		bp->b_flags &= ~XBF_DONE;
> > +		xfs_buf_stale(bp);
> > +		xfs_buf_ioend(bp);
> > +		return;
> > +	}
> >  
> >  	if (bp->b_flags & XBF_WRITE)
> >  		xfs_buf_wait_unpin(bp);
> > @@ -1311,25 +1307,10 @@ xfs_buf_iorequest(
> >  	bp->b_io_error = 0;
> >  
> 
> I know this is from the previous patch, but I wonder if it's cleaner to
> reset b_io_error when the error is transferred to b_error. That seems
> slightly more future proof at least.

I much prefer zeroing just before the variable is needed to be zero,
simply to indicate the context in which we care that the value is
correct. Outside of actively submitted IO, the value of b_io_error
is irrelevant, so it's value really doesn't matter. The other
advantage of leaving it untocuhed is for debug purposes - the caller
might clear b_error, but we still know what the state of the last IO
that was completed in the buffer was...

> 
> >  	/*
> > -	 * Take references to the buffer. For XBF_ASYNC buffers, holding a
> > -	 * reference for as long as submission takes is all that is necessary
> > -	 * here. The IO inherits the lock and hold count from the submitter,
> > -	 * and these are release during IO completion processing. Taking a hold
> > -	 * over submission ensures that the buffer is not freed until we have
> > -	 * completed all processing, regardless of when IO errors occur or are
> > -	 * reported.
> > -	 *
> > -	 * However, for synchronous IO, the IO does not inherit the submitters
> > -	 * reference count, nor the buffer lock. Hence we need to take an extra
> > -	 * reference to the buffer for the for the IO context so that we can
> > -	 * guarantee the buffer is not freed until all IO completion processing
> > -	 * is done. Otherwise the caller can drop their reference while the IO
> > -	 * is still in progress and hence trigger a use-after-free situation.
> > +	 * Take an extra reference so that we don't have to guess when it's no
> > +	 * longer safe to reference the buffer that was passed to us.
> >  	 */
> 
> Assuming my understanding is correct:
> 
> /*
>  * The caller's reference is released by buffer I/O completion.  Technically
>  * this should not occur until we release the last b_io_remaining reference.

That's not quite right. The caller's reference is released some time
*after* b_io_remaining goes to zero. That's the reason we need to
hold a reference - after we drop our b_io_remaining count, we have
to have some other method of ensuring the buffer doesn't go away
until we have finished with the buffer.

I'll rewrite the comment.

> > +xfs_buf_submit_wait(
> > +	struct xfs_buf	*bp)
> >  {
> > -	trace_xfs_buf_iowait(bp, _RET_IP_);
> > +	int		error;
> > +
> > +	trace_xfs_buf_iorequest(bp, _RET_IP_);
> >  
> > -	if (!bp->b_error)
> > -		wait_for_completion(&bp->b_iowait);
> > +	ASSERT(!(bp->b_flags & (_XBF_DELWRI_Q | XBF_ASYNC)));
> > +
> > +	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> > +		xfs_buf_ioerror(bp, -EIO);
> > +		xfs_buf_stale(bp);
> > +		bp->b_flags &= ~XBF_DONE;
> > +		return -EIO;
> > +	}
> >  
> > +	if (bp->b_flags & XBF_WRITE)
> > +		xfs_buf_wait_unpin(bp);
> > +
> > +	/* clear the internal error state to avoid spurious errors */
> > +	bp->b_io_error = 0;
> > +
> > +	/*
> > +	 * For synchronous IO, the IO does not inherit the submitters reference
> > +	 * count, nor the buffer lock. Hence we cannot release the reference we
> > +	 * are about to take until we've waited for all IO completion to occur,
> > +	 * including any xfs_buf_ioend_async() work that may be pending.
> > +	 */
> > +	xfs_buf_hold(bp);
> > +
> 
> Harmless, but why is this necessary? The caller should have the
> reference, the I/O completion won't release it and we wait on b_iowait
> before we return. Isn't the caller's reference sufficient?

Consistency - I'd prefer that all IO has the same reference counting
behaviour. i.e. that the IO holds it's own reference to ensure,
regardless of anything else that happens, that the buffer has a
valid reference count the entire time the IO subsystem processing
the buffer.

> > @@ -1838,7 +1853,10 @@ xfs_buf_delwri_submit(
> >  		bp = list_first_entry(&io_list, struct xfs_buf, b_list);
> >  
> >  		list_del_init(&bp->b_list);
> > -		error2 = xfs_buf_iowait(bp);
> > +
> > +		/* locking the buffer will wait for async IO completion. */
> > +		xfs_buf_lock(bp);
> > +		error2 = bp->b_error;
> 
> Interesting delwri cleanup overall. The lock here works for
> synchronization (blocking), but it doesn't look safe for error
> processing.  Once the buffer lock is dropped, who says b_error is from
> our write (and not a subsequent, for example) and thus this caller's
> responsibility to handle the error? I suspect this is a reason the lock
> is typically held across a sync I/O, so the error is valid after the
> I/O.

It's fine because there is only a limited set of blocking callers,
all of which are special cases. The only callers that use this
blocking xfs_buf_delwri_submit() interface are:

	1. log recovery: running single threaded, so isn't going
	   to be racing with anything else that can modify the error

	2. quotacheck: also running single threaded

	3. quota shrinker, which has nowhere to report an error to,
	   so the error status simply doesn't matter.

> Also, it looks like blocking on async I/O as such opens up the
> possibility of blocking indefinitely on failing writes if the right
> combination of delwri and b_iodone handler is used (see
> xfs_buf_iodone_callbacks()). I'm not sure if that's a real problem
> today, though.

I don't think it is - we don't permanently rewrite metadata writes
from IO completion anymore. We retry once, but then require higher
layers to restart the IO again (e.g. the xfsaild). Hence we can't
get stuck forever on async write errors.

> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 4ba19bf..1e14452 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -193,12 +193,8 @@ xlog_bread_noalign(
> >  	bp->b_io_length = nbblks;
> >  	bp->b_error = 0;
> >  
> > -	if (XFS_FORCED_SHUTDOWN(log->l_mp))
> > -		return -EIO;
> > -
> > -	xfs_buf_iorequest(bp);
> > -	error = xfs_buf_iowait(bp);
> > -	if (error)
> > +	error = xfs_buf_submit_wait(bp);
> > +	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp))
> >  		xfs_buf_ioerror_alert(bp, __func__);
> >  	return error;
> >  }
> > @@ -4427,16 +4423,12 @@ xlog_do_recover(
> >  	XFS_BUF_UNASYNC(bp);
> >  	bp->b_ops = &xfs_sb_buf_ops;
> >  
> > -	if (XFS_FORCED_SHUTDOWN(log->l_mp)) {
> > -		xfs_buf_relse(bp);
> > -		return -EIO;
> > -	}
> > -
> > -	xfs_buf_iorequest(bp);
> > -	error = xfs_buf_iowait(bp);
> > +	error = xfs_buf_submit_wait(bp);
> >  	if (error) {
> > -		xfs_buf_ioerror_alert(bp, __func__);
> > -		ASSERT(0);
> > +		if (XFS_FORCED_SHUTDOWN(log->l_mp)) {
> 
> Should this be !XFS_FORCED_SHUTDOWN()?

Right, good catch, especially after reading all that code ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
