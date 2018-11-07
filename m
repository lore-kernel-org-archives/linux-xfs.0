Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbeKGXMw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Nov 2018 18:12:52 -0500
Date: Wed, 7 Nov 2018 08:42:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
Message-ID: <20181107134223.GA50224@bfoster>
References: <20181105181021.8174-1-bfoster@redhat.com>
 <20181105215139.GA3160@infradead.org>
 <20181106142310.GA2773@bfoster>
 <20181106211802.GN19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106211802.GN19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, Nov 07, 2018 at 08:18:02AM +1100, Dave Chinner wrote:
> On Tue, Nov 06, 2018 at 09:23:11AM -0500, Brian Foster wrote:
> > On Mon, Nov 05, 2018 at 01:51:39PM -0800, Christoph Hellwig wrote:
> > > On Mon, Nov 05, 2018 at 01:10:21PM -0500, Brian Foster wrote:
> > > > When online discard is enabled, discards of busy extents are
> > > > submitted asynchronously as a bio chain. bio completion and
> > > > resulting busy extent cleanup is deferred to a workqueue. Async
> > > > discard submission is intended to avoid blocking log forces on a
> > > > full discard sequence which can take a noticeable amount of time in
> > > > some cases.
> > > > 
> > > > We've had reports of this still producing log force stalls with XFS
> > > > on VDO,
> > > 
> > > Please fix this in VDO instead.  We should not work around out of
> > > tree code making stupid decisions.
> > 
> > I assume the "stupid decision" refers to sync discard execution. I'm not
> > familiar with the internals of VDO, this is just what I was told.
> 
> IMO, what VDO does is irrelevant - any call to submit_bio() can
> block if the request queue is full. Hence if we've drowned the queue
> in discards and the device is slow at discards, then we are going to
> block submitting discards.
> 
> > My
> > understanding is that these discards can stack up and take enough time
> > that a limit on outstanding discards is required, which now that I think
> > of it makes me somewhat skeptical of the whole serial execution thing.
> > Hitting that outstanding discard request limit is what bubbles up the
> > stack and affects XFS by holding up log forces, since new discard
> > submissions are presumably blocked on completion of the oldest
> > outstanding request.
> 
> Exactly.
> 
> > I'm not quite sure what happens in the block layer if that limit were
> > lifted. Perhaps it assumes throttling responsibility directly via
> > queues/plugs? I'd guess that at minimum we'd end up blocking indirectly
> > somewhere (via memory allocation pressure?) anyways, so ISTM that some
> > kind of throttling is inevitable in this situation. What am I missing?
> 
> We still need to throttle discards - they have to play nice with all
> the other IO we need to dispatch concurrently.
> 
> I have two issues with the proposed patch:
> 
> 1. it puts both discard dispatch and completion processing on the
> one work qeueue, so if the queue is filled with dispatch requests,
> IO completion queuing gets blocked. That's not the best thing to be
> doing.
> 

This is an unbound workqueue with max_active == 0. AIUI, that means we
can have something like 256 execution contexts (worker threads?) per
cpu. Given that, plus the batching that occurs in XFS due to delayed
logging and discard bio chaining, that seems rather unlikely. Unless I'm
misunderstanding the mechanism, I think that means filling the queue as
such and blocking discard submission basically consumes one of those
contexts.

Of course, the CIL context structure appears to be technically unbound
as well and it's trivial to just add a separate submission workqueue,
but I'd like to at least make sure we're on the same page as to the need
(so it can be documented clearly as well).

> 2. log forces no longer wait for discards to be dispatched - they
> just queue them. This means the mechanism xfs_extent_busy_flush()
> uses to dispatch pending discards (synchrnous log force) can return
> before discards have even been dispatched to disk. Hence we can
> expect to see longer wait and tail latencies when busy extents are
> encountered by the allocator. Whether this is a problem or not needs
> further investigation.
> 

Firstly, I think latency is kind of moot in the problematic case. The
queue is already drowning in requests that presumably are going to take
minutes to complete. In that case, the overhead of kicking a workqueue
to do the submission is probably negligible.

That leaves the normal/active case. I suspect that the overhead here may
still be hard to notice given the broader overhead of online discard in
the first place. The aforementioned batching means we could be sending a
good number of discards all at once that ultimately need to be processed
(with no priority to the particular one an allocator could be waiting
on). The larger the chain, the longer the whole sequence is going to
take to clear a particular busy extent relative to the additional
latency of a workqueue. We could also just be sending one discard,
though waiting on that one particular extent could mean that we're
either not being as smart as we could be in extent selection or that
we're simply running low on free space.

I suppose if this approach is ultimately problemic for whatever reason,
we could look into some kind of heuristic to track outstanding
discards/chains and continue to do direct submission until we cross some
magic threshold. I'm not sure it's worth that complexity given the
limited use cases for online discard unless there's some serious
unforeseen problem, though. IIRC, this was all doing synchronous,
serialized submission not too long ago after all.

Anyways, I'll run some file creation/deletion tests against an SSD
and/or a thin vol and see what falls out..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
