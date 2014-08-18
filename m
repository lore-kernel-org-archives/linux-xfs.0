Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50CCB7F3F
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 09:26:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6733AC003
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 07:26:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jgJulr0AmfXNmKB5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 07:26:50 -0700 (PDT)
Date: Mon, 18 Aug 2014 10:26:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] xfs: introduce xfs_buf_submit[_wait]
Message-ID: <20140818142644.GD30093@bfoster.bfoster>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-9-git-send-email-david@fromorbit.com>
	<20140815161319.GF4096@laptop.bfoster>
	<20140815235804.GZ26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815235804.GZ26465@dastard>
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

On Sat, Aug 16, 2014 at 09:58:04AM +1000, Dave Chinner wrote:
> On Fri, Aug 15, 2014 at 12:13:20PM -0400, Brian Foster wrote:
> > On Fri, Aug 15, 2014 at 04:39:06PM +1000, Dave Chinner wrote:
> > > +	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> > > +		xfs_buf_ioerror(bp, -EIO);
> > > +		bp->b_flags &= ~XBF_DONE;
> > > +		xfs_buf_stale(bp);
> > > +		xfs_buf_ioend(bp);
> > > +		return;
> > > +	}
> > >  
> > >  	if (bp->b_flags & XBF_WRITE)
> > >  		xfs_buf_wait_unpin(bp);
> > > @@ -1311,25 +1307,10 @@ xfs_buf_iorequest(
> > >  	bp->b_io_error = 0;
> > >  
> > 
> > I know this is from the previous patch, but I wonder if it's cleaner to
> > reset b_io_error when the error is transferred to b_error. That seems
> > slightly more future proof at least.
> 
> I much prefer zeroing just before the variable is needed to be zero,
> simply to indicate the context in which we care that the value is
> correct. Outside of actively submitted IO, the value of b_io_error
> is irrelevant, so it's value really doesn't matter. The other
> advantage of leaving it untocuhed is for debug purposes - the caller
> might clear b_error, but we still know what the state of the last IO
> that was completed in the buffer was...
> 

Sounds good, I don't really have a strong preference.

> > 
> > >  	/*
> > > -	 * Take references to the buffer. For XBF_ASYNC buffers, holding a
> > > -	 * reference for as long as submission takes is all that is necessary
> > > -	 * here. The IO inherits the lock and hold count from the submitter,
> > > -	 * and these are release during IO completion processing. Taking a hold
> > > -	 * over submission ensures that the buffer is not freed until we have
> > > -	 * completed all processing, regardless of when IO errors occur or are
> > > -	 * reported.
> > > -	 *
> > > -	 * However, for synchronous IO, the IO does not inherit the submitters
> > > -	 * reference count, nor the buffer lock. Hence we need to take an extra
> > > -	 * reference to the buffer for the for the IO context so that we can
> > > -	 * guarantee the buffer is not freed until all IO completion processing
> > > -	 * is done. Otherwise the caller can drop their reference while the IO
> > > -	 * is still in progress and hence trigger a use-after-free situation.
> > > +	 * Take an extra reference so that we don't have to guess when it's no
> > > +	 * longer safe to reference the buffer that was passed to us.
> > >  	 */
> > 
> > Assuming my understanding is correct:
> > 
> > /*
> >  * The caller's reference is released by buffer I/O completion.  Technically
> >  * this should not occur until we release the last b_io_remaining reference.
> 
> That's not quite right. The caller's reference is released some time
> *after* b_io_remaining goes to zero. That's the reason we need to
> hold a reference - after we drop our b_io_remaining count, we have
> to have some other method of ensuring the buffer doesn't go away
> until we have finished with the buffer.
> 

Right, that's what I meant by the fact that we have to release the last
b_io_remaining ref one way or another first...

> I'll rewrite the comment.
> 

Ok, the rest of the comment I wrote isn't really clear when I re-read it
back either.

> > > +xfs_buf_submit_wait(
> > > +	struct xfs_buf	*bp)
> > >  {
> > > -	trace_xfs_buf_iowait(bp, _RET_IP_);
> > > +	int		error;
> > > +
> > > +	trace_xfs_buf_iorequest(bp, _RET_IP_);
> > >  
> > > -	if (!bp->b_error)
> > > -		wait_for_completion(&bp->b_iowait);
> > > +	ASSERT(!(bp->b_flags & (_XBF_DELWRI_Q | XBF_ASYNC)));
> > > +
> > > +	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> > > +		xfs_buf_ioerror(bp, -EIO);
> > > +		xfs_buf_stale(bp);
> > > +		bp->b_flags &= ~XBF_DONE;
> > > +		return -EIO;
> > > +	}
> > >  
> > > +	if (bp->b_flags & XBF_WRITE)
> > > +		xfs_buf_wait_unpin(bp);
> > > +
> > > +	/* clear the internal error state to avoid spurious errors */
> > > +	bp->b_io_error = 0;
> > > +
> > > +	/*
> > > +	 * For synchronous IO, the IO does not inherit the submitters reference
> > > +	 * count, nor the buffer lock. Hence we cannot release the reference we
> > > +	 * are about to take until we've waited for all IO completion to occur,
> > > +	 * including any xfs_buf_ioend_async() work that may be pending.
> > > +	 */
> > > +	xfs_buf_hold(bp);
> > > +
> > 
> > Harmless, but why is this necessary? The caller should have the
> > reference, the I/O completion won't release it and we wait on b_iowait
> > before we return. Isn't the caller's reference sufficient?
> 
> Consistency - I'd prefer that all IO has the same reference counting
> behaviour. i.e. that the IO holds it's own reference to ensure,
> regardless of anything else that happens, that the buffer has a
> valid reference count the entire time the IO subsystem processing
> the buffer.
> 

Sounds good.

> > > @@ -1838,7 +1853,10 @@ xfs_buf_delwri_submit(
> > >  		bp = list_first_entry(&io_list, struct xfs_buf, b_list);
> > >  
> > >  		list_del_init(&bp->b_list);
> > > -		error2 = xfs_buf_iowait(bp);
> > > +
> > > +		/* locking the buffer will wait for async IO completion. */
> > > +		xfs_buf_lock(bp);
> > > +		error2 = bp->b_error;
> > 
> > Interesting delwri cleanup overall. The lock here works for
> > synchronization (blocking), but it doesn't look safe for error
> > processing.  Once the buffer lock is dropped, who says b_error is from
> > our write (and not a subsequent, for example) and thus this caller's
> > responsibility to handle the error? I suspect this is a reason the lock
> > is typically held across a sync I/O, so the error is valid after the
> > I/O.
> 
> It's fine because there is only a limited set of blocking callers,
> all of which are special cases. The only callers that use this
> blocking xfs_buf_delwri_submit() interface are:
> 
> 	1. log recovery: running single threaded, so isn't going
> 	   to be racing with anything else that can modify the error
> 
> 	2. quotacheck: also running single threaded
> 
> 	3. quota shrinker, which has nowhere to report an error to,
> 	   so the error status simply doesn't matter.
> 

Sure, to be honest I wasn't really expecting there to be a scenario
where this is currently possible. I figured the log recovery context was
obviously not a concern because that occurs on mount. I hadn't gone to
look at the other contexts where we use delwri. quotacheck makes sense
for the same reason. We also use delwri for AIL pushing, but not the
synchronous version.

My comment was more from the perspective of this code will be around for
a long time and this little characteristic of the mechanism is not at
all explicit or obvious. So it won't ever be a problem until somebody
uses sync delwri in a context where racing is possible. Then it won't
ever reproduce until some user drives said mechanism and hits an error
in just the right manner to lead to some undefined error recovery
behavior. Maybe that doesn't happen for 20 years, but whenever it does,
it's guaranteed to not be fun to debug. ;) So my point is not to suggest
there's a race somewhere. It's just that the mechanism is racy and I'd
prefer we eliminate the possibility of having to debug the flaw that
this leaves behind. :) Another way to look at it is that we can't ever
use this delwri mechanism from anywhere but such special, isolated
contexts going forward. If we ever find that we want to, that punts the
problem to a prereq for whatever work that happens to be.

It's not clear to me if there's a way to deal with that without
fundamentally changing this mechanism. Anything explicit probably just
adds ugliness that's dedicated specifically to the fact that this is
racy (e.g., delwri specific lock/counter), so I don't think we want to
go there.

It seems like the more general problem is that we have two I/O models
(sync and async) that are fundamentally incompatible, but here we try to
build a batch sync I/O mechanism on top of the async submission
mechanism. So the definition of the async model is no longer sufficient
for our use, since we clearly have a use case to wait on an async I/O.
Perhaps we should think more about making the async/sync mechanisms more
generic/compatible..? Thinking out loud, making the lock context
dynamically transferrable to the I/O might be an interesting experiment
to start to decouple things (much like we do for joining items to
transactions, for example).

FWIW, I'm Ok with deferring that or adding it to my own todo list based
on the fact that there are currently no racing contexts, so long as the
async is a subset of sync I/O model is generally acceptable.

> > Also, it looks like blocking on async I/O as such opens up the
> > possibility of blocking indefinitely on failing writes if the right
> > combination of delwri and b_iodone handler is used (see
> > xfs_buf_iodone_callbacks()). I'm not sure if that's a real problem
> > today, though.
> 
> I don't think it is - we don't permanently rewrite metadata writes
> from IO completion anymore. We retry once, but then require higher
> layers to restart the IO again (e.g. the xfsaild). Hence we can't
> get stuck forever on async write errors.
> 

Ok, we have the XBF_WRITE_FAIL thing now. Forgot about that.

Brian

> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index 4ba19bf..1e14452 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -193,12 +193,8 @@ xlog_bread_noalign(
> > >  	bp->b_io_length = nbblks;
> > >  	bp->b_error = 0;
> > >  
> > > -	if (XFS_FORCED_SHUTDOWN(log->l_mp))
> > > -		return -EIO;
> > > -
> > > -	xfs_buf_iorequest(bp);
> > > -	error = xfs_buf_iowait(bp);
> > > -	if (error)
> > > +	error = xfs_buf_submit_wait(bp);
> > > +	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp))
> > >  		xfs_buf_ioerror_alert(bp, __func__);
> > >  	return error;
> > >  }
> > > @@ -4427,16 +4423,12 @@ xlog_do_recover(
> > >  	XFS_BUF_UNASYNC(bp);
> > >  	bp->b_ops = &xfs_sb_buf_ops;
> > >  
> > > -	if (XFS_FORCED_SHUTDOWN(log->l_mp)) {
> > > -		xfs_buf_relse(bp);
> > > -		return -EIO;
> > > -	}
> > > -
> > > -	xfs_buf_iorequest(bp);
> > > -	error = xfs_buf_iowait(bp);
> > > +	error = xfs_buf_submit_wait(bp);
> > >  	if (error) {
> > > -		xfs_buf_ioerror_alert(bp, __func__);
> > > -		ASSERT(0);
> > > +		if (XFS_FORCED_SHUTDOWN(log->l_mp)) {
> > 
> > Should this be !XFS_FORCED_SHUTDOWN()?
> 
> Right, good catch, especially after reading all that code ;)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
