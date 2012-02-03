Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q131WxL4088299 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 19:33:00 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1qQECYJP7HNms3zH for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 17:32:56 -0800 (PST)
Date: Fri, 3 Feb 2012 12:32:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system remain unresponsive until the system is rebooted.
Message-ID: <20120203013253.GB9090@dastard>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
	<4F27AE92.9060003@hardwarefreak.com>
	<20120131205014.GM9090@dastard>
	<4F288561.5040803@hardwarefreak.com>
	<20265.9379.139218.148520@tree.ty.sabi.co.UK>
	<20267.5137.85650.499331@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20267.5137.85650.499331@tree.ty.sabi.co.UK>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Thu, Feb 02, 2012 at 10:54:09PM +0000, Peter Grandi wrote:
> [ ... ]
> =

> >>>>> We are using Amazon EC2 instances.
> =

> >>>>> [ ... ]  one of the the worst possible platforms for XFS.
> =

> >>>> I don't agree with you there. If the workload works best on
> >>>> XFs, it doesn't matter what the underlying storage device
> >>>> is.  e.g. if it's a fsync heavy workload, it will still
> >>>> perform better on XFS on EC2 than btrfs on EC2...
> =

> >> There are special cases, but =ABfsync heavy=BB is a bit of bad
> >> example.
> =

> > It's actually a really good example of where XFS will be
> > better than other filesystems.
> =

> But this is better at being less bad. Because we are talking here
> about =ABfsync heavy=BB workloads on a VM, and these should not be
> run on a VM if performance matters. That's why I wrote about a
> =ABbad example=BB on which to discuss XFS for a VM.

Whether or not you should put a workload that does fsyncs in a VM is
a completely different argument altogether. It's not a meaningful
argument to make when we are talking about how filesystems deal with
unpredictable storage latencies or what filesystem to use in a
virtualised environment.

> But even with =ABfsync heavy=BB workloads in general your argument is
> not exactly appropriate:
> =

> > Why? Because XFS does less log IO due to aggregation of log
> > writes during concurrent fsyncs.
> =

> But =ABfsync heavy=BB does not necessarily means =ABconcurrent fsyncs=BB,
> for me it typically means logging or database apps where every
> 'write' is 'fsync'ed, even if there is a single thread.

Doesn't matter if there's concurrent fsyncs - XFS will aggregreate all
transactions while there is one fsync or anything else that triggers
log forces in progress. It's a generic solution to the "we're doing
too many synchronous transactions really close together" problem.

> But let's
> imagine for a moment we were talking about the special case where
> =ABfsync heavy=BB involves a high degree of concurrency.
> =

> > The more latency there is on a log write, the more aggregation
> > that occurs.
> =

> This seems to describe hardcoding in XFS a decision to trade
> worse latency for better throughput,

Except it doesn't. XFS's mechanism is well known to -minimise-
journal latency without increasing individual or maximum latencies
as load increases. This then translates directly into higher
sustained throughputs because less time is spent by applications
waiting for IO completions because there is less IO being done.

Yes, you can trade off latency for throughput - that's easy to do -
but a well designed system acheives high throughput by minimising
the impact unavoidable latencies. That's what the XFS journal does.
And quite frankly, it does't matter what the source of the latency
is or whether it is unpredictable. If you can't avoid it, you have
to design to minimise the impact.

> understandable as XFS was
> after all quite clearly aimed at high throughput (or isochronous
> throughput), rather than low latency (except for metadata, and
> that has been "fixed" with 'delaylog').

I like how you say "fixed" in a way that implies you don't beleive
that it is fixed...

> Unless you mean that if the latency is low, then aggregation does
> not take place,

That's exactly what I'm saying.

> but then it is hard for me to see how that can be
> *predicted*.

That's because it doesn't need to be predicted.  We *know* if a
journal write is currently in progress or not and we can wait on it
to complete. It doesn't matter how long it takes to complete - if it
is instantenous, then aggregation does not occur simply due to the
very short wait time.  If the IO takes a long time to complete, then
lots of aggregation of transaction commits will occur before we
submit the next IO.

Smarter people than me designed this stuff - I've just learnt from
what they've done and built on top of it....

> I am assuming that in the above you refer to:
> =

> https://lwn.net/Articles/476267/

Documentation/filesystems/xfs-delayed-logging-design.txt is a better
reference to use.

> the XFS transaction subsystem is
> that most transactions are asynchronous. That is, they don't
> commit to disk until either a log buffer is filled (a log buffer
> can hold multiple transactions) or a synchronous operation forces
> the log buffers holding the transactions to disk. This means that
> XFS is doing aggregation of transactions in memory - batching
> them, if you like - to minimise the impact of the log IO on
> transaction throughput.

That's part of it. This describes the pre-delaylog method of
aggregation, but even delaylog relies on this mechanism because
checkpoints are a journalled transaction just like all transactions
were pre-delaylog.

The point about fsync is that it is just an asynchronous transaction
as well. It is made synchronous by then pushing the log buffer to
disk. But it will only do that immeidately if the previous log
buffer is idle. If the previous log buffer is under IO, then it will
wait to start the IO on the current log buffer, allowing further
aggregation to occur.

> BTW curious note in the latter:
> =

>   However, under fsync-heavy workloads, small log buffers can be
>   noticeably faster than large buffers with a large stripe unit
>   alignment.

Because setting a log stripe unit (LSU) mean the size of the log IO is
padded. A 32k LSU means the minimum log IO size is 32k, while an
fsync transaciton is usually only a couple of hundred bytes. Without
an LSU, than means a solitary fsync transaction being written to disk
will be 512 bytes vs 32kB with a LSU and that means the non LSU-log will
complete IO faster. Same goes for LSU=3D32k vs LSU=3D256k.

> > On a platform where the IO subsystem is going to give you
> > unpredictable IO latencies, that's exactly what want.
> =

> This then the argument that on platforms with bad latency that
> decision works still works well because then you might as well go
> for throughput.

If one fsync takes X, and you can make 10 concurrent fsyncs take X,
why wouldn't you optimise to enable the latter case? It doesn't
matter if X is 10us, 1ms or even 1s - having an algorithm that works
independently of the magnitude of the storage latency will result in
good throughput no matter the storage characteristics. That's what
users want - something that just works without needing to tweak it
differently to perform optimally on all their different systems...

> But if someone really aims to run some kind of =ABfsync heavy=BB
> workload on a high-latency and highly-variable latency VM, usually
> their aim is to *minimize* the additional latency the filesystem
> imposes, because =ABfsync heavy=BB workloads tend to be transactional,
> and persisting data without delay is part of their goal.

I still don't understand what part of "use XFS for this workload"
you are saying is wrong?

> > Sure, it was designed to optimise spinning rust performance, but
> > that same design is also optimal for virtual devices with
> > unpredictable IO latency...
> =

> Ahhhh, now the =ABbad example=BB has become a worse one :-).
> =

> The argument you are making here is one for crass layering
> violation: that the filesystem code should embed storage-layer
> specific optimizations within it, and then one might get lucky
> with other storage layers of similar profile. Tsk tsk :-). At
> least it is not as breathtakingly inane as putting plug/unplug
> block io subsystem.

Filesystems are nothing but a dense concentration algorithms that
are optimal for as wide a range of known storage behaviours as
possible.

> XFS comes close, like JFS and OCFS2, but it does have, as you have
> pointed out above, workload-specific (which can turn into
> storage-friendly) tradeoffs. And since Red Hat's acquisition of
> GlusterFS I guess (or at least I hope) that XFS will be even more
> central to their strategy.

http://docs.redhat.com/docs/en-US/Red_Hat_Storage_Software_Appliance/3.2/ht=
ml-single/User_Guide/index.html#sect-User_Guide-gssa_prepare-chec_min_req

"File System Requirements

Red Hat recommends XFS when formatting the disk sub-system. ..."


-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
