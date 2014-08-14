Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4DAFC7F3F
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 17:28:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB239AC001
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 15:28:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	W4YXFJDFPeYHKsCI for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 15:28:11 -0700 (PDT)
Date: Fri, 15 Aug 2014 08:27:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140814222756.GR26465@dastard>
References: <20140811132057.GA1186@bfoster.bfoster>
	<20140811215207.GS20518@dastard>
	<20140812120341.GA46654@bfoster.bfoster>
	<DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
	<20140812235615.GB20518@dastard>
	<20140813125932.GA4605@bfoster.bfoster>
	<20140813205929.GE20518@dastard>
	<20140813232135.GB8456@laptop.bfoster>
	<20140814061444.GH20518@dastard>
	<20140814190521.GA51682@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140814190521.GA51682@bfoster.bfoster>
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
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Thu, Aug 14, 2014 at 03:05:22PM -0400, Brian Foster wrote:
> On Thu, Aug 14, 2014 at 04:14:44PM +1000, Dave Chinner wrote:
> > On Wed, Aug 13, 2014 at 07:21:35PM -0400, Brian Foster wrote:
> > > On Thu, Aug 14, 2014 at 06:59:29AM +1000, Dave Chinner wrote:
> > > > On Wed, Aug 13, 2014 at 08:59:32AM -0400, Brian Foster wrote:
> > > > > Perhaps I'm missing some context... I don't follow how removing the
> > > > > error check doesn't solve the problem. It clearly closes the race and
> > > > > perhaps there are other means of doing the same thing, but what part of
> > > > > the problem does that leave unresolved?
> > > > 
> > > > Anything that does:
> > > > 
> > > > 	xfs_buf_iorequest(bp);
> > > > 	if (bp->b_error)
> > > > 		xfs_buf_relse(bp);
> > > > 
> > > > is susceptible to the same race condition. based on bp->b_error
> > > > being set asynchronously and before the buffer IO completion
> > > > processing is complete.
> > > > 
> > > 
> > > Understood, by why would anything do that (as opposed to
> > > xfs_buf_iowait())? I don't see that we do that anywhere today
> > > (the check buried within xfs_buf_iowait() notwithstanding of course).
> > 
> > "Why" is not important - the fact is the caller *owns* the buffer
> > and so the above fragment of code is valid behaviour. If there is
> > an error on the buffer after xfs_buf_iorequest() request returns on
> > a synchronous IO, then it's a bug if there is still IO in progress
> > on that buffer.
> > 
> 
> A buffer can consist of multiple I/Os, yes? If so, then it seems quite
> possible for one I/O to fail and set an error on the buffer while
> another might still be in progress. I don't see how that can be
> considered a bug in general.

You miss my point. We have to mark the buffer with an error, but it
should not be visible to the submitter until all IO on the buffer
is done. i.e. setting bp->b_error from the completion path
needs to be deferred until xfs_buf_iodone_work() is run after all
submitted IOs on the buffer have completed.

> Even if not, I'd expect to see a comment explaining why any code
> fragment such as the above is not broken because that's not
> deterministic at all, even with a single I/O. E.g., the error could very
> well have been set by the callback where we clearly continue I/O
> processing so-to-speak (though we could consider where we currently set
> the error in the callback sequence a bug as well).

Chicken, meet Egg.

There's no comment saying the above code is OK or not because we
assume that if we hold the buffer lock it is safe to look at any
state on the buffer at any time. What this thread points out is that
synchronous IO changes the state of the buffer in a context that
does not hold the buffer lock, and so violates that assumption.

> > This means it does not matter what the buffer owner does after
> > xfs_buf_iorequest() - even unconditionally calling xfs_buf_relse()
> > will not result in use-after-free as the b_hold count will not go to
> > zero until the IO completion processing has been finalised.
> > 
> 
> Makes sense, assuming we handle the possible error cases and whatnot
> therein. Thinking some more, suppose we take this ref, submit one I/O
> successfully and a subsequent fails. Then who is responsible for
> releasing the reference?

xfs_buf_iodone_work() doesn't run until b_io_remaining goes to zero.
That's the context that releases the ref. It doesn't matter how many
are submitted, complete successfully or fail.

> > Fixing the rest of the mess (i.e. determining how to deal with
> > submission/completion races) is going to require more effort and
> > thought. For the moment, though, correctly reference counting
> > buffers will solve the use-after-free without changing any
> > other behaviour.
> > 
> > > From what I can see, all it really guarantees is that the submission has
> > > either passed/failed the write verifier, yes?
> > 
> > No.  It can also mean it wasn't rejected by the lower layersi as
> > they process the bio passed by submit_bio(). e.g.  ENODEV, because
> > the underlying device has been hot-unplugged, EIO because the
> > buffer is beyond the end of the device, etc.
> > 
> 
> Those are the errors that happen to be synchronously processed today.
> That's an implementation detail. submit_bio() is an asynchronous
> interface so I don't see any guarantee that will always be the case.
> E.g., that's easily broken should somebody decide to defer early end_io
> processing to a workqueue. We do a similar thing ourselves for the
> reasons you've stated above.
>
> I don't see anything in or around submit_bio() or generic_make_request()
> that suggest the interface is anything but async. From
> generic_make_request():
> 
> /**
>  ...
>  * generic_make_request() does not return any status.  The
>  * success/failure status of the request, along with notification of
>  * completion, is delivered asynchronously through the bio->bi_end_io
>  * function described (one day) else where.
>  *
>  ...
>  */

Delivery of the error is through bio->bi_end_io, but that is not
necessarily from an asynchronous context. e.g. the first thing that
generic_make_request() does is run generic_make_request_checks(),
where a failure runs bio_endio() and therefore bio->bi_end_io()
in the submitter's context. i.e. *synchronously*. This is exactly
what the b_io_remaining reference owned by xfs_buf_iorequest() is
being taken for - to prevent the *XFS endio processing* from being
run asynchronously.

> > > > > It looks like submit_bio() manages this by providing the error through
> > > > > the callback (always). It also doesn't look like submission path is
> > > > > guaranteed to be synchronous either (consider md, which appears to use
> > > > > workqueues and kernel threads)), so I'm not sure that '...;
> > > > > xfs_buf_iorequest(bp); if (bp->b_error)' is really safe anywhere unless
> > > > > you're explicitly looking for a write verifier error or something and
> > > > > do nothing further on the buf contingent on completion (e.g., freeing it
> > > > > or something it depends on).
> > > > 
> > > > My point remains that it *should be safe*, and the intent is that
> > > > the caller should be able to check for submission errors without
> > > > being exposed to a use after free situation. That's the bug we need
> > > > to fix, not say "you can't check for submission errors on
> > > > synchronous IO" to avoid the race condition.....
> > > > 
> > > 
> > > Well, technically you can check for submission errors on sync I/O, just
> > > use the code you posted above. :) What we can't currently do is find out
> > > when the I/O subsystem is done with the buffer.
> > 
> > By definition, a buffer marked with an error after submission
> > processing is complete. It should not need to be waited on, and
> > there-in lies the bug.
> 
> I suppose that implicates the error processing on the callback side. We
> set the error and continue processing on the buffer. Another option
> could be to shuffle that around on the callback side, but to me _that_
> is an approach that narrowly avoids the race rather than closing it via
> use of synchronization.

We need to store the error from the callback somewhere, until
b_io_remaining falls to zero. Right now we are putting it in
b_error, which makes it immediately visible to the submitter without
any synchronisation. Basically, we can't put state into anything
that the submitter is expected to check. We have internal state
fields that are not to be used externally:

        spinlock_t              b_lock;         /* internal state lock */
        unsigned int            b_state;        /* internal state flags */

So what we probably need to do is add an internal:

        int			b_io_error;	/* internal error state */

serialised by b_lock, where we stuff errors from xfs_buf_bio_end_io
and then propagate them to b_error in xfs_buf_iodone_work() when all
the IO is complete....

And with the extra reference count on the buffer, it doesn't matter
if the submitter detects a submission error and releases it's
reference to the buffer while there is still other IO in progress.
Hence we solve all the issues without changing the current
submit/wait semantics, or needing to remove the submission error
check from xfs_buf_iowait.


> I don't see any paths outside of I/O submission itself that care
> significantly about one general form of error (submission) vs. another
> (async I/O error) as opposed to simply whether an error has occurred or
> not. The fact that an error _can_ occur at any time until all of the
> outstanding bios are completed overrides the fact that some might occur
> by the time submission completes, meaning we have to handle the former
> for any callers that care about errors in general. Waiting on b_iowait
> before checking b_error is an always-safe way to do that.

Assuming there are no other bugs, it's "always safe". And that's the
key thing - the fact that we actually have a check for an error
before waiting indicates that it hasn't always been safe to wait on
a buffer marked with a submission error.

This code is full of cruft and mess. It's fully of history,
band-aids upon band-aids, partially completed cleanups, left over
complexity from times gone past and new complexity layered over the
top of structures not originally designed to support those uses.
Let's fix the use after free bug right away, and then clean up the
cruft and fix the underlying problems so we can guarantee that
"always-safe" behaviour an not have it blow up in our faces in
future....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
