Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40459 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727816AbeKHKLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 05:11:01 -0500
Date: Thu, 8 Nov 2018 11:38:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
Message-ID: <20181108003806.GA19305@dastard>
References: <20181105181021.8174-1-bfoster@redhat.com>
 <20181105215139.GA3160@infradead.org>
 <20181106142310.GA2773@bfoster>
 <20181106211802.GN19305@dastard>
 <20181107134223.GA50224@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107134223.GA50224@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, Nov 07, 2018 at 08:42:24AM -0500, Brian Foster wrote:
> On Wed, Nov 07, 2018 at 08:18:02AM +1100, Dave Chinner wrote:
> > On Tue, Nov 06, 2018 at 09:23:11AM -0500, Brian Foster wrote:
> > > On Mon, Nov 05, 2018 at 01:51:39PM -0800, Christoph Hellwig wrote:
> > > > On Mon, Nov 05, 2018 at 01:10:21PM -0500, Brian Foster wrote:
> > > > > When online discard is enabled, discards of busy extents are
> > > > > submitted asynchronously as a bio chain. bio completion and
> > > > > resulting busy extent cleanup is deferred to a workqueue. Async
> > > > > discard submission is intended to avoid blocking log forces on a
> > > > > full discard sequence which can take a noticeable amount of time in
> > > > > some cases.
> > > > > 
> > > > > We've had reports of this still producing log force stalls with XFS
> > > > > on VDO,
> > > > 
> > > > Please fix this in VDO instead.  We should not work around out of
> > > > tree code making stupid decisions.
> > > 
> > > I assume the "stupid decision" refers to sync discard execution. I'm not
> > > familiar with the internals of VDO, this is just what I was told.
> > 
> > IMO, what VDO does is irrelevant - any call to submit_bio() can
> > block if the request queue is full. Hence if we've drowned the queue
> > in discards and the device is slow at discards, then we are going to
> > block submitting discards.
> > 
> > > My
> > > understanding is that these discards can stack up and take enough time
> > > that a limit on outstanding discards is required, which now that I think
> > > of it makes me somewhat skeptical of the whole serial execution thing.
> > > Hitting that outstanding discard request limit is what bubbles up the
> > > stack and affects XFS by holding up log forces, since new discard
> > > submissions are presumably blocked on completion of the oldest
> > > outstanding request.
> > 
> > Exactly.
> > 
> > > I'm not quite sure what happens in the block layer if that limit were
> > > lifted. Perhaps it assumes throttling responsibility directly via
> > > queues/plugs? I'd guess that at minimum we'd end up blocking indirectly
> > > somewhere (via memory allocation pressure?) anyways, so ISTM that some
> > > kind of throttling is inevitable in this situation. What am I missing?
> > 
> > We still need to throttle discards - they have to play nice with all
> > the other IO we need to dispatch concurrently.
> > 
> > I have two issues with the proposed patch:
> > 
> > 1. it puts both discard dispatch and completion processing on the
> > one work qeueue, so if the queue is filled with dispatch requests,
> > IO completion queuing gets blocked. That's not the best thing to be
> > doing.
> > 
> 
> This is an unbound workqueue with max_active == 0. AIUI, that means we
> can have something like 256 execution contexts (worker threads?) per
> cpu.

.....
        WQ_MAX_ACTIVE           = 512,    /* I like 512, better ideas? */
        WQ_MAX_UNBOUND_PER_CPU  = 4,      /* 4 * #cpus for unbound wq */
        WQ_DFL_ACTIVE           = WQ_MAX_ACTIVE / 2,
};

/* unbound wq's aren't per-cpu, scale max_active according to #cpus */
#define WQ_UNBOUND_MAX_ACTIVE   \
        max_t(int, WQ_MAX_ACTIVE, num_possible_cpus() * WQ_MAX_UNBOUND_PER_CPU)


IOWs, unbound queues are not per-cpu and they are execution limited
to max(512, NR_CPUS * 4) kworker threads.

The default (for max_active = 0), however, is still WQ_DFL_ACTIVE so
the total number of active workers for the unbound xfs_discard_wq
is 256.


> Given that, plus the batching that occurs in XFS due to delayed
> logging and discard bio chaining, that seems rather unlikely. Unless I'm
> misunderstanding the mechanism, I think that means filling the queue as
> such and blocking discard submission basically consumes one of those
> contexts.

Yes, but consider the situation where we've got a slow discard
device and we're removing a file with millions of extents. We've got
to issue millions of discard ops in this case. because dispatch
queueing is not bound, we're easily going to overflow the discard
workqueue because the freeing transactions will run far ahead of the
discard operations. Sooner or later we consume all 256 discard_wq
worker threads with blocked discard submission.  Then both log IO
completion and discard I ocompletion will block on workqueue
submission and we deadlock because discard completion can't
run....

> 
> Of course, the CIL context structure appears to be technically unbound

I'm missing something here - What bit of that structure is unbound?

> as well and it's trivial to just add a separate submission workqueue,
> but I'd like to at least make sure we're on the same page as to the need
> (so it can be documented clearly as well).

A separate submission queue doesn't really solve log Io completion
blocking problem. Yes, it solves the discard completion deadlock,
but we eventually end up in the same place on sustained discard
workloads with submission queuing blocking on a full work queue.

Workqueues are no the way to solve unbound queue depth problems.
That's what Kernel threads are for. e.g. this is the reason the
xfsaild is a kernel thread, not a work queue. The amount of
writeback work queued on the AIL can be hundreds of thousands of
objects, way more than a workqueue can handle. This discard problem
is no different - concurrent dispatch through kworker threads buys
us nothing - we just fill the request queue from hundreds of threads
instead of filling it from just one.

The workqueue approach has other problems, too, like dispatch across
worker threads means discard is not FIFO scheduled - it's completely
random as to the order in which discards get fed to the device
request queue. Hence discards can be starved because whenever the
worker thread runs to process it's queue it finds the device request
queue already full and blocks again.

Having a single kernel thread that walks the discard queue on each
context and then each context in sequence order gives us FIFO
dispatch of discard requests. It would block only on full request
queues giving us a much more predictable log-force-to-completion
latency. It allows for the possiblity of merging discards across
multiple CIL contexts, to directly control the rate of discard, and
to skip small discards or even -turn off discard- when the backlog
gets too great.

The workqueue approach just doesn't allow anything like this to be
done because every discard context is kept separate from every other
context and there is no coordination at all between them.

> > 2. log forces no longer wait for discards to be dispatched - they
> > just queue them. This means the mechanism xfs_extent_busy_flush()
> > uses to dispatch pending discards (synchrnous log force) can return
> > before discards have even been dispatched to disk. Hence we can
> > expect to see longer wait and tail latencies when busy extents are
> > encountered by the allocator. Whether this is a problem or not needs
> > further investigation.
> > 
> 
> Firstly, I think latency is kind of moot in the problematic case. The
> queue is already drowning in requests that presumably are going to take
> minutes to complete. In that case, the overhead of kicking a workqueue
> to do the submission is probably negligible.

Yes, the overhead of kicking the queue is negliable. That's not the
problem though. By queuing discards rather than submitting them we
go from a single FIFO dispatch model (by in-order iclog IO
completion) to a concurrent, uncoordinated dispatch model.  It's the
loss of FIFO behaviour because the synchrnous log force no longer
controls dispatch order that leads to unpredictable and long tail
latencies in dispatch completion, hence causing the problems for the
proceeses now waiting on specific extent discard completion rather
than just the log force.

In some cases they'll get woken faster (don't ahve to wait for
discards to be dispatched), but it is equally likely they'll have to
wait for much, much longer. In essence, the async dispatch by
workqueue model removes all assumptions we've made about the
predictablility of discard completion latency. FIFO is predictable,
concurrent async dispatch by workqueue is completely unpredictable.

If we really want to do fully async dispatch of discards, I think we
need to use a controllable "single dispatch by kernel thread" model
like the AIL, not use workqueues and spray the dispatch in an
uncoordinated, uncontrollable manner across hundreds of kernel
threads....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
