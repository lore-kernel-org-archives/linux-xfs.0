Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC23A7F3F
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 14:05:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C542C304032
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 12:05:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kN11EPzZBM7X0ctl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 12:05:26 -0700 (PDT)
Date: Thu, 14 Aug 2014 15:05:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140814190521.GA51682@bfoster.bfoster>
References: <CAOcd+r3bC59m7Rh-3tmjrnWnF5XoPQfE=U+=hz78NcAGu+Ou1g@mail.gmail.com>
	<20140811132057.GA1186@bfoster.bfoster>
	<20140811215207.GS20518@dastard>
	<20140812120341.GA46654@bfoster.bfoster>
	<DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
	<20140812235615.GB20518@dastard>
	<20140813125932.GA4605@bfoster.bfoster>
	<20140813205929.GE20518@dastard>
	<20140813232135.GB8456@laptop.bfoster>
	<20140814061444.GH20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140814061444.GH20518@dastard>
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
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Thu, Aug 14, 2014 at 04:14:44PM +1000, Dave Chinner wrote:
> On Wed, Aug 13, 2014 at 07:21:35PM -0400, Brian Foster wrote:
> > On Thu, Aug 14, 2014 at 06:59:29AM +1000, Dave Chinner wrote:
> > > On Wed, Aug 13, 2014 at 08:59:32AM -0400, Brian Foster wrote:
> > > > Perhaps I'm missing some context... I don't follow how removing the
> > > > error check doesn't solve the problem. It clearly closes the race and
> > > > perhaps there are other means of doing the same thing, but what part of
> > > > the problem does that leave unresolved?
> > > 
> > > Anything that does:
> > > 
> > > 	xfs_buf_iorequest(bp);
> > > 	if (bp->b_error)
> > > 		xfs_buf_relse(bp);
> > > 
> > > is susceptible to the same race condition. based on bp->b_error
> > > being set asynchronously and before the buffer IO completion
> > > processing is complete.
> > > 
> > 
> > Understood, by why would anything do that (as opposed to
> > xfs_buf_iowait())? I don't see that we do that anywhere today
> > (the check buried within xfs_buf_iowait() notwithstanding of course).
> 
> "Why" is not important - the fact is the caller *owns* the buffer
> and so the above fragment of code is valid behaviour. If there is
> an error on the buffer after xfs_buf_iorequest() request returns on
> a synchronous IO, then it's a bug if there is still IO in progress
> on that buffer.
> 

A buffer can consist of multiple I/Os, yes? If so, then it seems quite
possible for one I/O to fail and set an error on the buffer while
another might still be in progress. I don't see how that can be
considered a bug in general.

Even if not, I'd expect to see a comment explaining why any code
fragment such as the above is not broken because that's not
deterministic at all, even with a single I/O. E.g., the error could very
well have been set by the callback where we clearly continue I/O
processing so-to-speak (though we could consider where we currently set
the error in the callback sequence a bug as well).

> We can't run IO completion synchronously from xfs_buf_bio_end_io in
> this async dispatch error case - we cannot detect it as any
> different from IO completion in interrupt context - and so we need
> to have some kind of reference protecting the buffer from being
> freed from under the completion.
> 

Indeed.

> i.e. the bug is that a synchronous buffer has no active reference
> while it is sitting on the completion workqueue - it's references
> are owned by other contexts that can drop them without regard to
> the completion status of the buffer.
> 
> For async IO we transfer a reference and the lock to the IO context,
> which gets dropped in xfs_buf_iodone_work when all the IO is
> complete. Synchronous IO needs this protection, too.
> 
> As a proof of concept, adding this to the start of
> xfs_buf_iorequest():
> 
> +	/*
> +	 * synchronous IO needs it's own reference count. async IO
> +	 * inherits the submitter's reference count.
> +	 */
> +	if (!(bp->b_flags & XBF_ASYNC))
> +		xfs_buf_hold(bp);
> 
> And this to the synchronous IO completion case for
> xfs_buf_iodone_work():
> 
> 	else {
> 		ASSERT(read && bp->b_ops);
> 		complete(&bp->b_iowait);
> +		xfs_buf_rele(bp);
> 	}
> 
> Should ensure that all IO carries a reference count and the buffer
> cannot be freed until all IO processing has been completed.
> 
> This means it does not matter what the buffer owner does after
> xfs_buf_iorequest() - even unconditionally calling xfs_buf_relse()
> will not result in use-after-free as the b_hold count will not go to
> zero until the IO completion processing has been finalised.
> 

Makes sense, assuming we handle the possible error cases and whatnot
therein. Thinking some more, suppose we take this ref, submit one I/O
successfully and a subsequent fails. Then who is responsible for
releasing the reference?

> Fixing the rest of the mess (i.e. determining how to deal with
> submission/completion races) is going to require more effort and
> thought. For the moment, though, correctly reference counting
> buffers will solve the use-after-free without changing any
> other behaviour.
> 
> > From what I can see, all it really guarantees is that the submission has
> > either passed/failed the write verifier, yes?
> 
> No.  It can also mean it wasn't rejected by the lower layersi as
> they process the bio passed by submit_bio(). e.g.  ENODEV, because
> the underlying device has been hot-unplugged, EIO because the
> buffer is beyond the end of the device, etc.
> 

Those are the errors that happen to be synchronously processed today.
That's an implementation detail. submit_bio() is an asynchronous
interface so I don't see any guarantee that will always be the case.
E.g., that's easily broken should somebody decide to defer early end_io
processing to a workqueue. We do a similar thing ourselves for the
reasons you've stated above.

I don't see anything in or around submit_bio() or generic_make_request()
that suggest the interface is anything but async. From
generic_make_request():

/**
 ...
 * generic_make_request() does not return any status.  The
 * success/failure status of the request, along with notification of
 * completion, is delivered asynchronously through the bio->bi_end_io
 * function described (one day) else where.
 *
 ...
 */

> > > > It looks like submit_bio() manages this by providing the error through
> > > > the callback (always). It also doesn't look like submission path is
> > > > guaranteed to be synchronous either (consider md, which appears to use
> > > > workqueues and kernel threads)), so I'm not sure that '...;
> > > > xfs_buf_iorequest(bp); if (bp->b_error)' is really safe anywhere unless
> > > > you're explicitly looking for a write verifier error or something and
> > > > do nothing further on the buf contingent on completion (e.g., freeing it
> > > > or something it depends on).
> > > 
> > > My point remains that it *should be safe*, and the intent is that
> > > the caller should be able to check for submission errors without
> > > being exposed to a use after free situation. That's the bug we need
> > > to fix, not say "you can't check for submission errors on
> > > synchronous IO" to avoid the race condition.....
> > > 
> > 
> > Well, technically you can check for submission errors on sync I/O, just
> > use the code you posted above. :) What we can't currently do is find out
> > when the I/O subsystem is done with the buffer.
> 
> By definition, a buffer marked with an error after submission
> processing is complete. It should not need to be waited on, and
> there-in lies the bug.
> 

I suppose that implicates the error processing on the callback side. We
set the error and continue processing on the buffer. Another option
could be to shuffle that around on the callback side, but to me _that_
is an approach that narrowly avoids the race rather than closing it via
use of synchronization.

> > Perhaps the point here is around the semantics of xfs_buf_iowait(). With
> > a mechanism that is fundamentally async, the sync variant obviously
> > becomes the async mechanism + some kind of synchronization. I'd expect
> > that synchronization to not necessarily just tell me whether an error
> > occurred, but also tell me when the I/O subsystem is done with the
> > object I've passed (e.g., so I'm free to chuck it, scribble over it, put
> > it back where I got it, whatever).
> >
> > My impression is that's the purpose of the b_iowait mechanism.
> > Otherwise, what's the point of the whole
> > bio_end_io->buf_ioend->b_iodone->buf_ioend round trip dance?
> 
> Yes, that's exactly what xfs_buf_iorequest/xfs_buf_iowait() provides
> and the b_error indication is an integral part of that
> synchronisation mechanism.  Unfortunately, that is also the part of
> the mechanism that is racy and causing problems.
> 

I don't see how b_iowait itself is racy. It completes when the I/O
completes. The problem is that we've overloaded these mechanisms to
where we attempt to use them for multiple things. b_error can be a
submission error or a deeper I/O error. Adding the b_error check to
xfs_buf_iowait() converts it to the same "has a submission error
occurred? or has any error occurred yet? or wait until all buffer
I/O is complete" non-deterministic semantics.

I agree that the reference count protection for sync I/O sounds useful
and closes a gap (need to think about that some more), but to check for
an error as part of the synchronization mechanism means that the
mechanism simply isn't synchronous.

I don't see any paths outside of I/O submission itself that care
significantly about one general form of error (submission) vs. another
(async I/O error) as opposed to simply whether an error has occurred or
not. The fact that an error _can_ occur at any time until all of the
outstanding bios are completed overrides the fact that some might occur
by the time submission completes, meaning we have to handle the former
for any callers that care about errors in general. Waiting on b_iowait
before checking b_error is an always-safe way to do that.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
