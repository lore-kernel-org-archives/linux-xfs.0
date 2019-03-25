Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32545 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbfCYXnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 19:43:14 -0400
Date: Tue, 26 Mar 2019 10:43:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Message-ID: <20190325234309.GB23020@dastard>
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard>
 <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhu=Qtme9RJ7uZXYXt0UE+=xD+OC4gQ9EYkDC1ap8Hizg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 25, 2019 at 09:49:33AM +0200, Amir Goldstein wrote:
> On Mon, Mar 25, 2019 at 2:10 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Sun, Mar 24, 2019 at 08:18:10PM +0200, Amir Goldstein wrote:
> > > Hi All,
> > >
> > > Christoph's re-factoring to xfs_ilock() brought up this question,
> > > but AFAICS, current behavior seems to have always been that
> > > way for xfs (?).
> > >
> > > Since commit 6552321831dc ("xfs: remove i_iolock and use
> > > i_rwsem in the VFS inode instead"), xfs_file_buffered_aio_read()
> > > is the only call sites I know of to call generic_file_read_iter() with
> > > i_rwsem read side held.
> >
> > That did not change the locking behaviour of XFS at all.
> 
> I know. Said so above.

Followed by a (?), which seems to indicate you were unsure and
seeking clarification.

> > I'm guessing what we are seeing here is a rwsem starvation problem.
> > The only reason a read would get delayed for mor ethan a few hundred
> > microseconds is ifthere are a continual stream of write holders
> > starving pending reads.
> >
> 
> Yes. That seems to be the case.

And both your fio testing and the testing I've done locally seems to
indicate that this is the case - a constant stream of writers will
block readers for very long periods of time.

> > I don't recall it being this bad historically but rwsems have been
> > severely performance optimised for various corner cases over the
> > past few years and it is extremely likely that behaviour has
> > changed.  Definitely needs looking at, but rwsems are so fragile
> > these days (highly dependent on memory ordering that nobody seems to
> > be able to get right) and impossible to validate as correct that we
> > might just end up having to live with it.
> >
> > FWIW, What kernel did you test this on?
> 
> The results above are from kernel 4.20.7-1.el7.elrepo.x86_64.
> Your assumption about change of behavior of rwsem over the
> years seems to be correct.
> The original report we got from customer was with kernel 4.9.134
> In the original report, long latencies were on writes rather than on reads.
> The following output of filebench randomrw workload summarizes the results:

To summarise: "behaviour used to be constant stream of readers block
writers".

Yay us!

> rand-write1          1128ops       19ops/s   0.1mb/s    340.3ms/op
> [0.03ms - 7933.27ms]
> rand-read1           2954684ops    49238ops/s 384.7mb/s      0.2ms/op
> [0.02ms - 5873.27ms]
> 61.026: IO Summary: 2955812 ops 49257.253 ops/s 49238/19 rd/wr
> 384.8mb/s   0.3ms/op
> 
> With more recent kernel (4.20), the latencies have shifted to the read ops:
> 
> rand-write1          467706ops     7794ops/s  60.9mb/s    0.733ms/op
> [0.004ms - 3899.167ms]
> rand-read1           1970ops       33ops/s   0.3mb/s  164.277ms/op
> [0.017ms - 3905.929ms]
> 61.032: IO Summary: 469676 ops 7826.760 ops/s 33/7794 rd/wr  61.1mb/s 1.419ms/op
> 
> In a workload of 100% reads or 100% writes, there are no extreme
> latencies or neither
> old nor new kernel.

Yup, because there's no reader/writer contention on the lock. The
change of behaviour here is due to the rwsem implementation lacking
proper barrier semantics, and so the imlpementation changes
behaviour according to what microbenchmark goes faster this week.

We never had these problems with Irix rwsems, because:

commit a7724543560e9b6434710abcd5528234f108e204
Author: Doug Doucette <doucette@engr.sgi.com>
Date:   Sat Jun 14 01:44:30 1997 +0000

    Make the iolock be a BARRIER mrlock instead of the default.
    This makes it force new readers to wait if there's a writer
    waiting, insuring some fairness.

Almost all XFS rwsems were configured as MRLOCK_BARRIER rwsems,
which had mostly fair queuing behaviour.

	- if held by read, other readers can grab until pending
	  writer.
	- if held by read and pending writer, reads queue behind
	  writer.
	- if held by read, no pending reads and pending writer, writers get batched
	  with pending writer
	- if held by writer and no pending reader, new writer is
	  queued to run after writer and before any new pending
	  readers.
	- if held by writer and pending reader, new writers get queued
	  behind reads
	- if held by writer and pending reader, readers get batched
	  with pending reader

basically, these barrier semantics prevented new readers from
starving waiting writers, and prevented new writers from starving
pending readers.

/me wonders if he should just implement this as a new type of lock
so that we don't end up having read/write balance change whenever
somebody modifies rwsem behaviour to make some microbenchmark go
faster....



> > I'd be interested in seeing if a fio workload using 16 randrw
> > threads demonstrate the same latency profile (i.e. threads aren't
> > exclusively read- or write- only), or is profile coming about
> > specifically because you have dedicated write-only threads that will
> > continually bash on the IO locks and hence starve readers?
> 
> I guess it depends on the rw mix. With 50% r/w mix run on kernel
> 4.20.7-1.el7, long latencies are mostly on the write ops.

Worst case latencies are roughly equal at ~500ms, distribution is
almost identical - ~50% of writes are not blocking at all, the rest
are waiting behind reads and so showing >=50th percentile latencies
largely similar to the read side.

fio displays this behaviour because it bounds the run length of the
pending write or read IO stream as each thread selects read or write
randomly. Hence each thread will soon issue an IO that will get
blocked and so the exclusion stream is essentially bound in depth by
the random number generator. 

> > > My question is, is the purpose of this lock syncing
> > > dio/buffered io?
> >
> > That's one part of it. The other is POSIX atomic write semantics.
> >
> > https://pubs.opengroup.org/onlinepubs/009695399/functions/read.html
> >
> > "I/O is intended to be atomic to ordinary files and pipes and FIFOs.
> > Atomic means that all the bytes from a single operation that started
> > out together end up together, without interleaving from other I/O
> > operations."
> 
> I see... Are you aware of any applications that depend on this POSIX
> atomic write behavior? It would seem very unlikely that such applications
> exist, if only xfs provides this guaranty on Linux...

Databases like this behaviour very much....

> IMO, it would be best if applications that desire atomic writes semantics
> would opt for it using a preadv2 flag. Or, for backward compat, we can allow
> applications to opt out of atomic write semantics. [CC fsdevel]

You seem to have already decided that it is going to be optional
behaviour in XFS. perhaps you should wait for people to decide
whether we want to do that or not....

> All right. I am reading the above as no prior objection to adding
> an XFS mount option and/or preadv2() flag to opt out of this
> behavior and align with the reckless behavior of the other local
> filesystems on Linux.
> Please correct me if I am wrong and I would like to hear what
> other people thing w.r.t mount option vs. preadv2() flag.
> It could also be an open flag, but I prefer not to go down that road...

"No prior objection" doesn't mean "yes, we are going to do this".

Indeed, if you are doing high performance, concurrent mixed
read/write IO to the same file, then we've already got a solution
for this problem. i.e. using AIO+DIO on XFS will allow
both reads and writes to be issued concurrently and not block the
main thread of execution. That solves all the problems in one go...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
