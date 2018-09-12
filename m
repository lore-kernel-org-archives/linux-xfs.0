Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41218 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725738AbeILFo5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 01:44:57 -0400
Date: Wed, 12 Sep 2018 10:42:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Strange behavior with log IO fake-completions
Message-ID: <20180912004259.GJ5631@dastard>
References: <CA+1E3r+crZ6suDtTheOysm_dzZ2FeU=z4R-aQQw7etk1yuxOLQ@mail.gmail.com>
 <20180910235827.GD5631@dastard>
 <CA+1E3r+Lggw9JJymdhoyzkqQfqGETZE=R=WG09s7FOhY3Snb5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3r+Lggw9JJymdhoyzkqQfqGETZE=R=WG09s7FOhY3Snb5g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joshi <joshiiitr@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 11, 2018 at 09:40:59AM +0530, Joshi wrote:
> > > Test: iozone, single-thread, 1GiB file, 4K record, sync for each 4K (
> > > '-eo' option).
> > > Disk: 800GB NVMe disk. XFS based on 4.15, default options except log size = 184M
> > > Machine: Intel Xeon E5-2690 @2.6 GHz, 2 NUMA nodes, 24 cpus each
> > >
> > > And results are :
> > > ------------------------------------------------
> > > baseline                log fake-completion
> > > 109,845                 45,538
> > > ------------------------------------------------
> > > I wondered why fake-completion turned out to be ~50% slower!
> > > May I know if anyone encountered this before, or knows why this can happen?
> >
> > You made all log IO submission/completion synchronous.
> >
> > https://marc.info/?l=linux-xfs&m=153532933529663&w=2
> >
> > > For fake-completion, I just tag all log IOs bufer-pointers (in
> > > xlog_sync). And later in xfs_buf_submit, I just complete those tagged
> > > log IOs without any real bio-formation (comment call to
> > > _xfs_bio_ioapply). Hope this is correct/enough to do nothing!
> >
> > It'll work, but it's a pretty silly thing to do. See above.
> 
> Thank you very much, Dave. I feel things are somewhat different here
> than other email-thread you pointed.
> Only log IO was fake-completed, not that entire XFS volume was on
> ramdisk.

The "fake completion" forces log IO to be completed synchronously,
just like a ramdisk does. It's exactly the same behaviour.

> Underlying disk was NVMe, and I checked that no
> merging/batching happened for log IO submissions in base case.
> Completion count were same (as many as submitted) too.

Of course. async or sync, the amount of IO work an isolated single
threaded, synchronous write workload does is the same because there
is no other IO that can be aggregated for either the data or journal
writes....

> Call that I disabled in base code (in xfs_buf_submit, for log IOs) is
> _xfs_buf_ioapply.

Yes, I assumed you were doing something like that. The problem is,
you're not looking at what the journal is doing as a whole when
xfs_log_force_lsn() is called from fsync.

In this case, the initial log state is that the current iclogbuf is
ACTIVE because we have no journal writes in progress. The typical,
full IO path through this code is as follows:

fsync() process			CIL workqueue		log workqueue

xfs_log_force_lsn()
  xlog_cil_force_lsn()
    xlog_cil_push_now(seq)
    	<flushes pending push work>
	<queues required push work>
    xlog_wait(xc_commit_wait);
        <blocks waiting for CIL push>

				<walks items in CIL>
				<formats into log buffer>
				xlog_write()
				  .....
				  iclogbuf goes to SYNCING
				  xfs_buf_submit(iclogbuf)
				    __xfs_buf_submit()
					submit_bio()
				<push work complete>
				<wakes push waiters>

<wakes, returns to __xfs_log_force_lsn()>
  __xfs_log_force_lsn()
    <iclogbuf in SYNCING>
    xlog_wait(ic_force_wait)
      <blocks waiting for IO completion>

				<IO completion on some CPU>
				   xfs_buf_endio_async()
				     queue_work(log-wq)
							<wakes>
							xlog_iodone
							  xlog_state_do_callback
							    wake_up_all(ic_force_wait)
							<work complete>
<wakes, returns to __xfs_log_force_lsn()>
<log force done>
<returns to fsync context>

In normal cases, the overhead of IO completion queuing the
xlog_iodone completion work to the log wq can be mostly ignored -
it's just part of the IO completion delay time. What's important to
realise is that it runs some time after the CIL push waiters were
woken and then go back to sleep waiting for the log IO to complete,
so the processing is completely separated and there's no contention
between submission and completion.

> So only thing happened differently for log IO
> submitter thread is that it executed bp-completion-handling-code
> (xfs_buf_ioend_async). And that anyway pushes the processing to
> worker. It still remains mostly async, I suppose.

Well, when andhow the completion runs depends on a *lot* of things.
Let's simplify - the above case is:

fsync proc		CIL		IO-complete	log
xfs_log_force_lsn
  <wait for CIL>
			xlog_write()
			wake CIL waiters
  <wait for iclogbuf>
					<queue to log>
							xlog_iodone()
							wake iclogbug waiters
log force done.

Essentially, there are 7 context switches in that, but we just don't
see that overhead because it's tiny compared to the IO time. There's
also no contention between the fsync proc waiting on iclogbuf io
completion and iclogbuf completion processing, so that runs as fast
as possible.

> In original form, it
> would have executed extra code to form/sent bio (possibility of
> submission/completion merging, but that did not happen for this
> workload), and completion would have come after some time say T.
> I wondered about impact on XFS if this time T can be made very low by
> underlying storage for certain IOs.

Even when IO times are short as a few tens of microseconds, this is
sufficient to avoid contention between submission and completion
processing and turn the context switches into noise. And even with
shorter IO delays, the async processing still allows the log state
machine to aggregate concurrent fsyncs - see the recent
work with AIO fsync to scale out to concurrently writing and
fsyncing tens of thousands of files per second on high speed nvme
SSDs.

So, why don't fake completions work well? It's because the IO delay
goes away completely and that causes submission/completion
processing contention in the log code. If we have lots of idle CPUs
sitting around with a synchronous log IO completion, we get this
fsync behaviour:

fsync proc		CIL		IO-complete	log
xfs_log_force_lsn
  <wait for CIL>
			xlog_write()
			  <queue to log-wq>
			wake CIL waiters		xlog_iodone()
  <wait for iclogbuf>					wake iclogbug waiters
							
log force done.

IOWs, we now have the iclogbuf IO completion work racing with the
completion of the CIL push, finalising the log state after the
writes, waking CIL waiters and going to sleep waiting for log IO
completion and state machine transitions.

Basically, it causes cross-CPU contention for the same log cachelines
and locks because we've triggered a synchronous IO completion of the
iclogbuf. That contention kills CPU performance because it's now
having to wait for the cache coherency protocol to fetch data from
other CPU caches and/or memory. This can easily slow critical code
down by a factor of 3-4 orders of magnitude. Racing/spurious
sleep/wakeup events have a fair bit of overhead, too. 

Now, your other "unexpected" result - lets use affinity to confine
everything to one CPU:

fsync proc		CIL		IO-complete	log
xfs_log_force_lsn
  <wait for CIL>
			xlog_write()
			<queue to log>
			wake CIL waiters
							xlog_iodone()
							wake iclogbug waiters
log force done

Note the difference? The log work can't start until the CIL work has
completed because it's constrained to the same CPU, so it doesn't
cause any contention with the finalising of the CIL push and waking
waiters.

Further, because the log workqueue is a high priority workqueue and
we're confined to a single CPU, it gets processed by the workqueue
infrastructure before it releases the CPU to schedule other tasks.
This changes the order of operations in the code.

And because it's all on the one CPU, this is effectively a CPU bound
operation and the cachelines stay hot in the CPU and there's no lock
contention to invalidate them. The code runs as fast as it is
possible to run as a result.

Combine those things and the result is that we do less work and the
CPU executes it faster. Not to mention that only running on one CPU
core allows modern CPUs to maximise the clock frequency on that one
core, making the affinity constrained workload look even faster than
one that is spread across multiple cores. (Reliable performance
benchmarking is hard!)

> If underlying device/layers provide some sort of differentiated I/O
> service enabling ultra-low-latency completion for certain IOs (flagged
> as urgent), and one chooses log IO to take that low-latency path  -
> won't we see same problem as shown by fake-completion?

Maybe, maybe not. It really depends on what is happening system
wide, not what is happening to any single thread or IO....

IOWs, I wouldn't be trying to extrapolate how a filesystem
will react to a specific type of storage from a single threaded,
synchronous write workload. All you'll succeed in doing is
micro-optimising behaviour for single threaded, synchronous
writes on that specific storage device.

Perhaps it would be better for you to describe what you are trying
to acheive first so we can point you in the right direction rather
than playing "20 Questions" and still not understanding of why the
filesystem isn't doing what you expect it to be doing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
