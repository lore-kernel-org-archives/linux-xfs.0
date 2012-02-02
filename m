Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12MsKMH078578 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 16:54:20 -0600
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	ulZzpyTl5EA9wWs2 for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 14:54:16 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4EEB647400D51A13 for xfs@oss.sgi.com; Thu, 2 Feb 2012 22:54:14 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1Rt5Xd-00024s-7v
	for <xfs@oss.sgi.com>; Thu, 02 Feb 2012 22:54:09 +0000
MIME-Version: 1.0
Message-ID: <20267.5137.85650.499331@tree.ty.sabi.co.UK>
Date: Thu, 2 Feb 2012 22:54:09 +0000
Subject: Re: File system remain unresponsive until the system is rebooted.
In-Reply-To: <20265.9379.139218.148520@tree.ty.sabi.co.UK>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
	<4F27AE92.9060003@hardwarefreak.com>
	<20120131205014.GM9090@dastard>
	<4F288561.5040803@hardwarefreak.com>
	<20265.9379.139218.148520@tree.ty.sabi.co.UK>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

>>>>> We are using Amazon EC2 instances.

>>>>> [ ... ]  one of the the worst possible platforms for XFS.

>>>> I don't agree with you there. If the workload works best on
>>>> XFs, it doesn't matter what the underlying storage device
>>>> is.  e.g. if it's a fsync heavy workload, it will still
>>>> perform better on XFS on EC2 than btrfs on EC2...

>> There are special cases, but =ABfsync heavy=BB is a bit of bad
>> example.

> It's actually a really good example of where XFS will be
> better than other filesystems.

But this is better at being less bad. Because we are talking here
about =ABfsync heavy=BB workloads on a VM, and these should not be
run on a VM if performance matters. That's why I wrote about a
=ABbad example=BB on which to discuss XFS for a VM.

But even with =ABfsync heavy=BB workloads in general your argument is
not exactly appropriate:

> Why? Because XFS does less log IO due to aggregation of log
> writes during concurrent fsyncs.

But =ABfsync heavy=BB does not necessarily means =ABconcurrent fsyncs=BB,
for me it typically means logging or database apps where every
'write' is 'fsync'ed, even if there is a single thread. But let's
imagine for a moment we were talking about the special case where
=ABfsync heavy=BB involves a high degree of concurrency.

> The more latency there is on a log write, the more aggregation
> that occurs.

This seems to describe hardcoding in XFS a decision to trade
worse latency for better throughput, understandable as XFS was
after all quite clearly aimed at high throughput (or isochronous
throughput), rather than low latency (except for metadata, and
that has been "fixed" with 'delaylog').

Unless you mean that if the latency is low, then aggregation does
not take place, but then it is hard for me to see how that can be
*predicted*. I am assuming that in the above you refer to:

https://lwn.net/Articles/476267/
  the XFS transaction subsystem is that most transactions are
  asynchronous. That is, they don't commit to disk until either a
  log buffer is filled (a log buffer can hold multiple transactions)
  or a synchronous operation forces the log buffers holding the
  transactions to disk. This means that XFS is doing aggregation of
  transactions in memory - batching them, if you like - to minimise
  the impact of the log IO on transaction throughput.
http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Performan=
ce_Tuning_Guide/ch07s04s02.html
  The delaylog mount option also improves sustained metadata
  modification performance by reducing the number of changes to the
  log. It achieves this by aggregating individual changes in memory
  before writing them to the log: frequently modified metadata is
  written to the log periodically instead of on every modification.
  This option increases the memory usage of tracking dirty metadata
  and increases the potential lost operations when a crash occurs,
  but can improve metadata modification speed and scalability by an
  order of magnitude or more. Use of this option does not reduce
  data or metadata integrity when fsync, fdatasync or sync are used
  to ensure data and metadata is written to disk.

BTW curious note in the latter:

  However, under fsync-heavy workloads, small log buffers can be
  noticeably faster than large buffers with a large stripe unit
  alignment.

> On a platform where the IO subsystem is going to give you
> unpredictable IO latencies, that's exactly what want.

This then the argument that on platforms with bad latency that
decision works still works well because then you might as well go
for throughput.

But if someone really aims to run some kind of =ABfsync heavy=BB
workload on a high-latency and highly-variable latency VM,
usually their aim is to *minimize* the additional latency the
filesystem imposes, because =ABfsync heavy=BB workloads tend to be
transactional, and persisting data without delay is part of their
goal.

> Sure, it was designed to optimise spinning rust performance,
> but that same design is also optimal for virtual devices with
> unpredictable IO latency...

Ahhhh, now the =ABbad example=BB has become a worse one :-).

The argument you are making here is one for crass layering
violation: that the filesystem code should embed storage-layer
specific optimizations within it, and then one might get lucky
with other storage layers of similar profile. Tsk tsk :-). At
least it is not as breathtakingly inane as putting plug/unplug
block io subsystem.

But even on spinning rust, and on real host, and even forgiving
the layering violation, I question the aim to get better
throughput at the expense of worse latency for =ABfsync heavy=BB
loads, and even for the type of workloads for which this tradeoff
is good.

Because *my* argument is that how often 'fsync' "happens" should
be a decision by the application programmer; if they want higher
throughput at the cost of higher latency, they should issue it
less frequently, as 'fsync' should be executed with as low a
latency as possible.

Your underlying argument for XFS and its handling of =ABfsync
heavy=BB workloads (and it is the same argument for 'delaylog' I
guess) seems to me that applications issue 'fsync' too often, and
thus we can briefly hold them back to bunch them up, and people
like the extra throughput more than they dislike the extra latency.

Which reminds me of a discussions I had some time ago with some
misguided person who argued that 'fsync' and Linux barriers only
require ordering constraints, and don't imply any actual writing
to persistent storage, or within any specific timeframe, where
instead I was persuaded that their main purpose (no matter what
POSIX says :->) is to commit to persistent storage as quickly as
possible.

It looks like that XFS has gone more the way of something like
his position, because admittedly in practice keeping commits a
bit looser does deliver better throughput (hints of O_PONIES
here).

But again, that's not what should be happening. Perhaps POSIX
should have provided :-) two barrier operations, a purely
ordering one, and a commit-now one. And application writers would
use them at the right times. And ponies for everybody :-).

>> In general file system designs are not at all independent of
>> the expected storage platform, and some designs are far better
>> than others for specific storage platforms, and viceversa.

> Sure, but filesystems also have inherent capabilities that are
> independent of the underlying storage.

But the example you make is not a =ABcapability=BB, it is the
hardcoded assumption that it is better to trade worse latency for
better throughput, which only makes sense for workloads that
don't want tight latency, or else storage layers that don't
support it.

> In these cases, the underlying storage really doesn't matter if
> the filesystem can't do what the application needs.  Allocation
> parallelism, CPU parallelism, minimal concurrent fsync latency,

But you seemed to be describing above that XFS good at "maximal
concurrent fsync throughput" by disregarding =ABminimal concurrent
fsync latency=BB (as in =ABless log IO due to aggregation of log
writes during concurrent fsyncs. The more latency there is on a
log write, the more aggregation=BB).

> etc are all characteristics of filesystems that are independent
> of the underlying storage.

Ahhhh, but this is a totally different argument from embedding
specific latency/throughput tradeoffs in the storage layer.

This is an argument that a well designed filesystem that does
have bottlenecks on any aspect of the performance envelope is a
good general purpose one. Well, you can try to design one :-).

XFS comes close, like JFS and OCFS2, but it does have, as you
have pointed out above, workload-specific (which can turn into
storage-friendly) tradeoffs. And since Red Hat's acquisition of
GlusterFS I guess (or at least I hope) that XFS will be even more
central to their strategy.

BTW as to that, did a brief search and found this amusing
article, yet another proof that reality surpasses imagination:

  http://bioteam.net/2010/07/playing-with-nfs-glusterfs-on-amazon-cc1-4xlar=
ge-ec2-instance-types/

Ah I was totally unaware of the AWS Compute Cluster service.

> If you need those characteristics in your remotely hosted VMs,
> then XFS is what you want regardless of how much storage
> capability you buy for those VMs....

Possibly, but from also a practical viewpoint that is again a
moderately bizarre argument, because workloads requiring high
levels of =ABAllocation parallelism, CPU parallelism, minimal
concurrent fsync latency=BB beg to be run on an Altix, or similar,
not on a bunch of random EC2 shared hosts running Xen VMs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
