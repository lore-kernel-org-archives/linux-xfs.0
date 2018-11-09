Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3099 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726926AbeKIJ7A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 04:59:00 -0500
Date: Fri, 9 Nov 2018 11:20:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
Message-ID: <20181109002052.GE19305@dastard>
References: <20181105181021.8174-1-bfoster@redhat.com>
 <20181105215139.GA3160@infradead.org>
 <20181106142310.GA2773@bfoster>
 <20181106211802.GN19305@dastard>
 <20181107134223.GA50224@bfoster>
 <20181108003806.GA19305@dastard>
 <20181108135001.GA2796@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108135001.GA2796@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Nov 08, 2018 at 08:50:02AM -0500, Brian Foster wrote:
> On Thu, Nov 08, 2018 at 11:38:06AM +1100, Dave Chinner wrote:
> > On Wed, Nov 07, 2018 at 08:42:24AM -0500, Brian Foster wrote:
> > > On Wed, Nov 07, 2018 at 08:18:02AM +1100, Dave Chinner wrote:
> > Yes, but consider the situation where we've got a slow discard
> > device and we're removing a file with millions of extents. We've got
> > to issue millions of discard ops in this case. because dispatch
> > queueing is not bound, we're easily going to overflow the discard
> > workqueue because the freeing transactions will run far ahead of the
> > discard operations. Sooner or later we consume all 256 discard_wq
> > worker threads with blocked discard submission.  Then both log IO
> > completion and discard I ocompletion will block on workqueue
> > submission and we deadlock because discard completion can't
> > run....
> > 
> > > 
> > > Of course, the CIL context structure appears to be technically unbound
> > 
> > I'm missing something here - What bit of that structure is unbound?
> > 
> 
> I mean to say that the ctx is not a fixed/limited resource in the
> context of a discard submission workqueue. There's no throttling, so we
> can essentially discard as many busy extent lists as the user can
> generate (this is essentially the same point as your million extent file
> example above).

It is bound. It's bound by log size and the number of checkpoints we
can have uncompleted at any point in time. That can be a high bound
on large logs, but it is limited and it is throttled - you can't
create new contexts if there is no log space available, and hence
new contexts are throttled on tail pushing.

> > > as well and it's trivial to just add a separate submission workqueue,
> > > but I'd like to at least make sure we're on the same page as to the need
> > > (so it can be documented clearly as well).
> > 
> > A separate submission queue doesn't really solve log Io completion
> > blocking problem. Yes, it solves the discard completion deadlock,
> > but we eventually end up in the same place on sustained discard
> > workloads with submission queuing blocking on a full work queue.
> > 
> 
> Well, for the purposes of this patch it's fine that we still block on
> discard submission. The point is just that we do so in a separate
> context from log I/O completion and thus avoid associated log force
> stalls.

And, in doing so, remove any bound we have on the number of
outstanding uncompleted discards. You're essentially trading
"slow things progressively as discard load goes up" with "nothing
blocks until we hit a breakdown point and the system stops until the
discard queue drains".

We have a limited queue depth of discard operations right now, and
even that is deep enough to cause problems.  Removing that queue
depth bound won't improve things - it will just allow the pending
discard queue to run deeper and get further and further behind the
extent free operations that are being committed. This will only make
the stalls and problems completely unpredictable and uncontrollable,
and poses a true breakdown possibility where allocation in every AG
is stalled holding AGF locks waiting for a huge queue of discards to
be worked through.

We have to throttle at some point to prevent us from getting to
these severe breakdown conditions. Moving discards out from under
the log force removes the only feedback loop we have to throttle
discards back to a manageable level. What we have is not perfect,
but we can't just remove that feedback loop without providing
something else to replace it.

> > The workqueue approach just doesn't allow anything like this to be
> > done because every discard context is kept separate from every other
> > context and there is no coordination at all between them.
> > 
> 
> The high level kthread approach sounds like a nice idea to me. I'm not
> sure that it's technically necessary to address this specific problem
> though. I.e., it would be nice if we could still separate enhancement
> from bug fix.

Just removing the discards from the log force context is just hiding
a source of latency without addressing the cause of the latency.
i.e. there's a huge amount of discard to be managed, and the only
management we have to constrain them to the rate at which we retire
the extent free transactions.

> > > > 2. log forces no longer wait for discards to be dispatched - they
> > > > just queue them. This means the mechanism xfs_extent_busy_flush()
> > > > uses to dispatch pending discards (synchrnous log force) can return
> > > > before discards have even been dispatched to disk. Hence we can
> > > > expect to see longer wait and tail latencies when busy extents are
> > > > encountered by the allocator. Whether this is a problem or not needs
> > > > further investigation.
> > > > 
> > > 
> > > Firstly, I think latency is kind of moot in the problematic case. The
> > > queue is already drowning in requests that presumably are going to take
> > > minutes to complete. In that case, the overhead of kicking a workqueue
> > > to do the submission is probably negligible.
> > 
> > Yes, the overhead of kicking the queue is negliable. That's not the
> > problem though. By queuing discards rather than submitting them we
> > go from a single FIFO dispatch model (by in-order iclog IO
> > completion) to a concurrent, uncoordinated dispatch model.  It's the
> > loss of FIFO behaviour because the synchrnous log force no longer
> > controls dispatch order that leads to unpredictable and long tail
> > latencies in dispatch completion, hence causing the problems for the
> > proceeses now waiting on specific extent discard completion rather
> > than just the log force.
> > 
> 
> I think I see what you're getting at here: discard submission via log
> completion means that submission is serialized (with respect to other
> iclogs) and in log buf order, since that is enforced by the log callback
> invoking code. Since the callbacks execute one at a time, blocking in
> submission likely means the same, single log I/O completion execution
> context ends up iterating over and processing the other iclogs with
> pending callbacks once the current submit blockage clears. Yes?

Essentially.

> If I'm following that correctly, couldn't we provide very similar
> behavior by using a separate "ordered" workqueue for submission?

Workqueues are not bound depth queues - they are "concurrency
managed" queues. And ordered workqueue is simply a FIFO with a
single processing context. You can queue as much as you like to it,
but it will only process it with a single thread.

> The
> ordered wq sets max_active to 1, which means we still have a single
> submitter,

We have a single /worker/ - we can submit as many independent works
as we want to it and they just stack up on the queue. There is no
throttling or feedback here, it's just a black hole.

> From there, we can still explore additional enhancements incrementally,
> such as pushing some of the busy extent processing/sorting into the
> workqueue, eventually converting the wq-based mechanism into a
> thread-based one, etc. Thoughts?

As I always say: do it once, do it properly, or don't touch it at
all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
