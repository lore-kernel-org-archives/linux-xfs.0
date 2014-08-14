Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB5C97F3F
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 01:14:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C596A304032
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 23:14:53 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EL7O8W6p3wFyEuTu for <xfs@oss.sgi.com>;
	Wed, 13 Aug 2014 23:14:48 -0700 (PDT)
Date: Thu, 14 Aug 2014 16:14:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140814061444.GH20518@dastard>
References: <20140806152042.GB39990@bfoster.bfoster>
	<CAOcd+r3bC59m7Rh-3tmjrnWnF5XoPQfE=U+=hz78NcAGu+Ou1g@mail.gmail.com>
	<20140811132057.GA1186@bfoster.bfoster>
	<20140811215207.GS20518@dastard>
	<20140812120341.GA46654@bfoster.bfoster>
	<DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
	<20140812235615.GB20518@dastard>
	<20140813125932.GA4605@bfoster.bfoster>
	<20140813205929.GE20518@dastard>
	<20140813232135.GB8456@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140813232135.GB8456@laptop.bfoster>
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

On Wed, Aug 13, 2014 at 07:21:35PM -0400, Brian Foster wrote:
> On Thu, Aug 14, 2014 at 06:59:29AM +1000, Dave Chinner wrote:
> > On Wed, Aug 13, 2014 at 08:59:32AM -0400, Brian Foster wrote:
> > > Perhaps I'm missing some context... I don't follow how removing the
> > > error check doesn't solve the problem. It clearly closes the race and
> > > perhaps there are other means of doing the same thing, but what part of
> > > the problem does that leave unresolved?
> > 
> > Anything that does:
> > 
> > 	xfs_buf_iorequest(bp);
> > 	if (bp->b_error)
> > 		xfs_buf_relse(bp);
> > 
> > is susceptible to the same race condition. based on bp->b_error
> > being set asynchronously and before the buffer IO completion
> > processing is complete.
> > 
> 
> Understood, by why would anything do that (as opposed to
> xfs_buf_iowait())? I don't see that we do that anywhere today
> (the check buried within xfs_buf_iowait() notwithstanding of course).

"Why" is not important - the fact is the caller *owns* the buffer
and so the above fragment of code is valid behaviour. If there is
an error on the buffer after xfs_buf_iorequest() request returns on
a synchronous IO, then it's a bug if there is still IO in progress
on that buffer.

We can't run IO completion synchronously from xfs_buf_bio_end_io in
this async dispatch error case - we cannot detect it as any
different from IO completion in interrupt context - and so we need
to have some kind of reference protecting the buffer from being
freed from under the completion.

i.e. the bug is that a synchronous buffer has no active reference
while it is sitting on the completion workqueue - it's references
are owned by other contexts that can drop them without regard to
the completion status of the buffer.

For async IO we transfer a reference and the lock to the IO context,
which gets dropped in xfs_buf_iodone_work when all the IO is
complete. Synchronous IO needs this protection, too.

As a proof of concept, adding this to the start of
xfs_buf_iorequest():

+	/*
+	 * synchronous IO needs it's own reference count. async IO
+	 * inherits the submitter's reference count.
+	 */
+	if (!(bp->b_flags & XBF_ASYNC))
+		xfs_buf_hold(bp);

And this to the synchronous IO completion case for
xfs_buf_iodone_work():

	else {
		ASSERT(read && bp->b_ops);
		complete(&bp->b_iowait);
+		xfs_buf_rele(bp);
	}

Should ensure that all IO carries a reference count and the buffer
cannot be freed until all IO processing has been completed.

This means it does not matter what the buffer owner does after
xfs_buf_iorequest() - even unconditionally calling xfs_buf_relse()
will not result in use-after-free as the b_hold count will not go to
zero until the IO completion processing has been finalised.

Fixing the rest of the mess (i.e. determining how to deal with
submission/completion races) is going to require more effort and
thought. For the moment, though, correctly reference counting
buffers will solve the use-after-free without changing any
other behaviour.

> From what I can see, all it really guarantees is that the submission has
> either passed/failed the write verifier, yes?

No.  It can also mean it wasn't rejected by the lower layersi as
they process the bio passed by submit_bio(). e.g.  ENODEV, because
the underlying device has been hot-unplugged, EIO because the
buffer is beyond the end of the device, etc.

> > > It looks like submit_bio() manages this by providing the error through
> > > the callback (always). It also doesn't look like submission path is
> > > guaranteed to be synchronous either (consider md, which appears to use
> > > workqueues and kernel threads)), so I'm not sure that '...;
> > > xfs_buf_iorequest(bp); if (bp->b_error)' is really safe anywhere unless
> > > you're explicitly looking for a write verifier error or something and
> > > do nothing further on the buf contingent on completion (e.g., freeing it
> > > or something it depends on).
> > 
> > My point remains that it *should be safe*, and the intent is that
> > the caller should be able to check for submission errors without
> > being exposed to a use after free situation. That's the bug we need
> > to fix, not say "you can't check for submission errors on
> > synchronous IO" to avoid the race condition.....
> > 
> 
> Well, technically you can check for submission errors on sync I/O, just
> use the code you posted above. :) What we can't currently do is find out
> when the I/O subsystem is done with the buffer.

By definition, a buffer marked with an error after submission
processing is complete. It should not need to be waited on, and
there-in lies the bug.

> Perhaps the point here is around the semantics of xfs_buf_iowait(). With
> a mechanism that is fundamentally async, the sync variant obviously
> becomes the async mechanism + some kind of synchronization. I'd expect
> that synchronization to not necessarily just tell me whether an error
> occurred, but also tell me when the I/O subsystem is done with the
> object I've passed (e.g., so I'm free to chuck it, scribble over it, put
> it back where I got it, whatever).
>
> My impression is that's the purpose of the b_iowait mechanism.
> Otherwise, what's the point of the whole
> bio_end_io->buf_ioend->b_iodone->buf_ioend round trip dance?

Yes, that's exactly what xfs_buf_iorequest/xfs_buf_iowait() provides
and the b_error indication is an integral part of that
synchronisation mechanism.  Unfortunately, that is also the part of
the mechanism that is racy and causing problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
