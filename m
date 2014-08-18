Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7384B7F3F
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 09:15:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44E518F8040
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 07:15:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BbssFtF6byBtqJmq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 07:15:38 -0700 (PDT)
Date: Mon, 18 Aug 2014 10:15:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/9] xfs: synchronous buffer IO needs a reference
Message-ID: <20140818141525.GA30093@bfoster.bfoster>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-2-git-send-email-david@fromorbit.com>
	<20140815131804.GA4096@laptop.bfoster>
	<20140815231736.GT26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815231736.GT26465@dastard>
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

On Sat, Aug 16, 2014 at 09:17:36AM +1000, Dave Chinner wrote:
> On Fri, Aug 15, 2014 at 09:18:04AM -0400, Brian Foster wrote:
> > On Fri, Aug 15, 2014 at 04:38:59PM +1000, Dave Chinner wrote:
> ....
> > >  	if (bp->b_flags & XBF_WRITE)
> > >  		xfs_buf_wait_unpin(bp);
> > > +
> > > +	/*
> > > +	 * Take references to the buffer. For XBF_ASYNC buffers, holding a
> > > +	 * reference for as long as submission takes is all that is necessary
> > > +	 * here. The IO inherits the lock and hold count from the submitter,
> > > +	 * and these are release during IO completion processing. Taking a hold
> > > +	 * over submission ensures that the buffer is not freed until we have
> > > +	 * completed all processing, regardless of when IO errors occur or are
> > > +	 * reported.
> > > +	 *
> > > +	 * However, for synchronous IO, the IO does not inherit the submitters
> > > +	 * reference count, nor the buffer lock. Hence we need to take an extra
> > > +	 * reference to the buffer for the for the IO context so that we can
> > > +	 * guarantee the buffer is not freed until all IO completion processing
> > > +	 * is done. Otherwise the caller can drop their reference while the IO
> > > +	 * is still in progress and hence trigger a use-after-free situation.
> > > +	 */
> > >  	xfs_buf_hold(bp);
> > > +	if (!(bp->b_flags & XBF_ASYNC))
> > > +		xfs_buf_hold(bp);
> > > +
> > >  
> > >  	/*
> > > -	 * Set the count to 1 initially, this will stop an I/O
> > > -	 * completion callout which happens before we have started
> > > -	 * all the I/O from calling xfs_buf_ioend too early.
> > > +	 * Set the count to 1 initially, this will stop an I/O completion
> > > +	 * callout which happens before we have started all the I/O from calling
> > > +	 * xfs_buf_ioend too early.
> > >  	 */
> > >  	atomic_set(&bp->b_io_remaining, 1);
> > >  	_xfs_buf_ioapply(bp);
> > > +
> > >  	/*
> > > -	 * If _xfs_buf_ioapply failed, we'll get back here with
> > > -	 * only the reference we took above.  _xfs_buf_ioend will
> > > -	 * drop it to zero, so we'd better not queue it for later,
> > > -	 * or we'll free it before it's done.
> > > +	 * If _xfs_buf_ioapply failed or we are doing synchronous IO that
> > > +	 * completes extremely quickly, we can get back here with only the IO
> > > +	 * reference we took above.  _xfs_buf_ioend will drop it to zero, so
> > > +	 * we'd better run completion processing synchronously so that the we
> > > +	 * don't return to the caller with completion still pending. In the
> > > +	 * error case, this allows the caller to check b_error safely without
> > > +	 * waiting, and in the synchronous IO case it avoids unnecessary context
> > > +	 * switches an latency for high-peformance devices.
> > >  	 */
> > 
> > AFAICT there is no real wait if the buf has completed at this point. The
> > wait just decrements the completion counter.
> 
> If the IO has completed, then we run the completion code.
> 
> > So what's the benefit of
> > "not waiting?" Where is the potential context switch?
> 
> async work for completion processing on synchrnous IO means we queue
> the work, then sleep in xfs_buf_iowait(). Two context switches, plus
> a work queue execution
> 

Right...

> > Are you referring
> > to the case where error is set but I/O is not complete? Are you saying
> > the advantage to the caller is it doesn't have to care about the state
> > of further I/O once it has been determined at least one error has
> > occurred? (If so, who cares about latency given that some operation that
> > depends on this I/O is already doomed to fail?).
> 
> No, you're reading *way* too much into this. For sync IO, it's
> always best to process completion inline. For async, it doesn't
> matter, but if there's a submission error is *more effecient* to
> process it in the current context.
> 

Heh. Sure, that makes sense. Perhaps it's just the way I read it,
implying that how we process I/O completion effects what the calling
code should look like. Simple case of the comment being a bit more
confusing than the code. ;) FWIW, the following is more clear to me:

/*
 * If _xfs_buf_ioapply failed or we are doing synchronous IO that
 * completes extremely quickly, we can get back here with only the IO
 * reference we took above. _xfs_buf_ioend will drop it to zero. Run
 * completion processing synchronously so that we don't return to the
 * caller with completion still pending. This avoids unnecessary context
 * switches associated with the end_io workqueue.
 */

Thanks for the explanation.

Brian

> > The code looks fine, but I'm trying to understand the reasoning better
> > (and I suspect we can clarify the comment).
> > 
> > > -	_xfs_buf_ioend(bp, bp->b_error ? 0 : 1);
> > > +	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> > > +		_xfs_buf_ioend(bp, 0);
> > > +	else
> > > +		_xfs_buf_ioend(bp, 1);
> > 
> > Not related to this patch, but it seems like the problem this code tries
> > to address is still possible.
> 
> The race condition is still possible - it just won't result in a
> use-after-free. The race condition is not fixed until patch 8,
> but as a backportable fix, this patch is much, much simpler.
> 
> > Perhaps this papers over a particular
> > instance. Consider the case where an I/O fails immediately after this
> > call completes, but not before. We have an extra reference now for
> > completion, but we can still return to the caller with completion
> > pending. I suppose its fine if we consider the "problem" to be that the
> > reference goes away underneath the completion, as opposed to the caller
> > caring about the status of completion.
> 
> Precisely.
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
