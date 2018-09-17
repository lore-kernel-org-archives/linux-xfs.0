Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:61223 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726110AbeIQIVU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 04:21:20 -0400
Date: Mon, 17 Sep 2018 12:56:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Strange behavior with log IO fake-completions
Message-ID: <20180917025601.GE16550@dastard>
References: <CA+1E3r+crZ6suDtTheOysm_dzZ2FeU=z4R-aQQw7etk1yuxOLQ@mail.gmail.com>
 <20180910235827.GD5631@dastard>
 <CA+1E3r+Lggw9JJymdhoyzkqQfqGETZE=R=WG09s7FOhY3Snb5g@mail.gmail.com>
 <20180912004259.GJ5631@dastard>
 <CA+1E3r+gd57nOv=S0gjrbU8df2qXa67njPP=KK1oPqLmsO5thQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3r+gd57nOv=S0gjrbU8df2qXa67njPP=KK1oPqLmsO5thQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joshi <joshiiitr@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 14, 2018 at 05:21:43PM +0530, Joshi wrote:
> Thank you Dave, for sharing the details and putting the pieces together.
> 
> > So, why don't fake completions work well? It's because the IO delay
> > goes away completely and that causes submission/completion
> > processing contention in the log code. If we have lots of idle CPUs
> > sitting around with a synchronous log IO completion, we get this
> > fsync behaviour:
> >
> > fsync proc              CIL             IO-complete     log
> > xfs_log_force_lsn
> >   <wait for CIL>
> >                         xlog_write()
> >                           <queue to log-wq>
> >                         wake CIL waiters                xlog_iodone()
> >   <wait for iclogbuf>                                   wake iclogbug waiters
> >
> > log force done.
> >
> > IOWs, we now have the iclogbuf IO completion work racing with the
> > completion of the CIL push, finalising the log state after the
> > writes, waking CIL waiters and going to sleep waiting for log IO
> > completion and state machine transitions.
> >
> > Basically, it causes cross-CPU contention for the same log cachelines
> > and locks because we've triggered a synchronous IO completion of the
> > iclogbuf. That contention kills CPU performance because it's now
> > having to wait for the cache coherency protocol to fetch data from
> > other CPU caches and/or memory
> 
> Sorry, but the contention that you mentioned seems to be more about
> fast-completion-of-log-IO rather than
> synchronous-completion-of-log-IO. Isn't it?
> The code that gets executed in case of fake-completion would be
> exactly same had storage completed log IO blazing fast.

No, no it isn't. Blazing fast storage is not the same zero-delay, IO
bypass completion like your fake-completion hack. Especially
considering that it avoids sending REQ_FLUSH to the underlying
device on each fsync, which typically has some additional delay for
the IO that it is delivered with.

>From that perspective, fake-completion is actually causing out of
order completion of the journal IO vs the rest of the IO that is in
flight. i.e. because it doesn't go through the IO layer, scheduler,
etc, it's not actually being issued and completed with all the other
IO that is in progress. Hence it's basically skipping the pending IO
completion queue at all layers and jumping straight to the head of
the queue.  IOWs, it's in no way reflective of how the journal
behaves when there there is real IO load present on the underlying
device.

And now that I've mentioned REQ_FLUSH, I have to point out that
fake-completion is breaking the integrity model of the filesystem.
Failing to issue REQ_FLUSH on log IOs means that volatile caches
below the filesystem are not flushed before the journal is written
to. This also changes way the underlying device processes IO, and so
may be operating way faster than it should because it's not getting
regular cache flushes.

But even more important: to provide the correct data integrity
semantics to fsync() callers, we really do need to issue two IOs for
each fsync - both data and log for related metadata need to be
written. So lets go back to looking at where all our time in fsync
is being spent, and why fake-completion is not telling you what you
think it is.

With fast nvme storage (using your numbers of 3uS per IO) and
ignoring all the CPU time between the IOs, we could do ~160k
fsync's per second from a single thread on such a device due to the
6uS per fsync IOWait time constraint.

If we add in 1uS of CPU time to do the data write, and another 1uS
of CPU time for the fsync (i.e. all the journal write code) we're now
at 8uS per fsync and so down to 125k operations per second.

And then we've got application time to set up for the next
write+fsync, which if there's real data to be processed is going to
be a few uS too. But let's conisder that it's IOZone so it's just
feeding the same data in a tight loop which gives us roughly other
1uS per loop.  IOws, we're now at 9uS of CPU+IOwait time per
write/fsync loop, and that puts us at ~111k fsync's per second.

That's right on the number that IOZone is giving you for single
threaded performance. To make it go faster, we have to either reduce
CPU overhead or reduce IO time. We can't reduce IO time - we have to
do two physical IOs. That leaves us with reducing CPU time
processing the IO.

Your fake completion code does not just reduce the CPU time of the
journal processing slightly - it completely omits one of those two
IOs (the journal IO) that are required for fsync. IOWs, instead of
6uS of IOwait time, we now only have 3uS. That means we the
per-fsync time is back down to 6uS, which is somewhere around
160k fsync/s per second - that's roughly 40% faster.

And if we look at your single threaded 16 CPU iozone results we see:

> Threads	Base		Fake-completion	Diff%
> 1		110,804		151,478		36.7%

The change in performance is right on the number I'd expect from
eliding the log IO.  The measured improvement hasn't come from
fake-completion simulating lower CPU usage, it's come directly from
not issuing and waiting for journal IO.

And your high cpu count results confirm the contention problems
between submission and completion I described result in reduced
performance in low thread counts. IOws, your results are confirming
what I've been saying tends to happen with zero-delay IO completion
setups.

IOWs, we already know that removing the journal IO wait time have a
performance improvement, that it is visible even with really fast IO
subsystems, and we know we cannot make optimisations in this manner.
IOWs, your test doesn't tell us that there's a problem with
asynchronous log IO completion algorithms on asynhronous storage,
they just tell us that:

	a) the journal IO is ~only 35% of the fsync overhead on your
	device; and
	b) synchrnous and/or zero delay IO completions are not
	handled well, but that still only extends to ramdisks and
	pmem in practice.

> And I do not see any different/better numbers when I perform
> fake-completion in asynchronous way (i.e. increment b_io_remaining,
> and queue bp in a workqueue).

That's because you're not changing CPU usage in any meaningful way -
the change in performance you've measured is caused by eliding the
journal IO and scheduling immediate IO completion, not by the extra
context switch that queuing the log IO completion causes.

And, FWIW, workqueues can queue work onto other CPUs - if the work
is already running, then it will continue to be run on the CPU it is
running on, not get scheduled on the queuing CPU. When the XFS log
is busy, this happens a *lot*.

[snip]

> > Now, your other "unexpected" result - lets use affinity to confine
> > everything to one CPU:
> >
> > fsync proc              CIL             IO-complete     log
> > xfs_log_force_lsn
> >   <wait for CIL>
> >                         xlog_write()
> >                         <queue to log>
> >                         wake CIL waiters
> >                                                         xlog_iodone()
> >                                                         wake iclogbug waiters
> > log force done
> >
> > Note the difference? The log work can't start until the CIL work has
> > completed because it's constrained to the same CPU, so it doesn't
> > cause any contention with the finalising of the CIL push and waking
> > waiters.
> 
> "Log work can't start" part does not sound very good either. It needed
> to be done anyway before task waiting for fsync is woken.

I'm beginning to think you don't really understand how logging in
XFS works.  If you want to improve the logging subsystem, it would
be a good idea for you to read and understand this document so you
have some idea of how the data that is written to the log gets
there and what happens to it after it's in the log.

Documentation/filesystems/xfs-delayed-logging-design.txt

> > Perhaps it would be better for you to describe what you are trying
> > to acheive first so we can point you in the right direction rather
> > than playing "20 Questions" and still not understanding of why the
> > filesystem isn't doing what you expect it to be doing....
> 
> Single threaded IO is about latency. And storage-systems need to care
> about that apart from multi-threaded, throughput scenarios.

Who does single threaded write IO these days? What real world
application problem are you trying to solve?

IMO, If you care about single operation latency in isolation from
everything else, XFS is not the filesystem to use.  XFS's algorithms
are CPU intensive because they are designed to scale out to large
CPU counts efficiently. e.g. a single write+fsync on ext4 takes less
than 50% of the CPU time to execute and complete than XFS. So for
the sorts of single threaded fsync workloads you are talking about,
ext4 will always have much lower latency for single operations than
XFS because it burns much less CPU between waiting for IOs.

> To rule-out the device peculiarities and to determine where exactly
> problem lies, I chose to try the whole thing with fake completion.
> 
> I'd appreciate if you have suggestions about what could be changed in
> XFS to get advantage of low-latency log IO.

I still don't understand what application you have that requires
optimisation of single threaded fsync latency.  Without some context
of the application level problem you are trying to solve I can't
answer questions like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
