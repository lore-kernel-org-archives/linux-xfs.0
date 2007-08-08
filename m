Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 06:14:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l78DE7bm008349
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 06:14:09 -0700
Date: Wed, 8 Aug 2007 23:14:04 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS thread inflation in 2.6.23rc
Message-ID: <20070808131404.GQ52011508@sgi.com>
References: <200708081240.21548.ak@suse.de> <20070808121359.GP52011508@sgi.com> <200708081422.10373.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708081422.10373.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: xfs@oss.sgi.com

On Wed, Aug 08, 2007 at 02:22:10PM +0200, Andi Kleen wrote:
> On Wednesday 08 August 2007 14:13:59 David Chinner wrote:
> > On Wed, Aug 08, 2007 at 12:40:21PM +0200, Andi Kleen wrote:
> > > 
> > > In 2.6.23rc I have a new kernel thread running from XFS:
> > > 
> > > 30137 ?        S<     0:00 [xfs_mru_cache]
> > > 
> > > Is that one really needed? Can it be started only on demand when that MRU
> > > feature is used? 
> > 
> > It uses a single threaded workqueue for reaping objects and the thread comes
> > along with that. Creating the workqueue on demand would require creating a
> > kernel thread inside a transaction and that's not some thing we want to do.
> 
> Why not? I can't think of any possible problem except memory allocation
> recursion, but even that should be handled.

Memory allocation failure + dirty transaction == filesystem shutdown.

Bad, bad, bad, bad.

> > Besides, what's the point of having nice constructs like dedicated
> > workqueues
> 
> It's a resource that shouldn't be overused.

A workqueue + thread uses, what, 10-15k of memory? That's the cost of about
10 cached inodes. It is insignificant...

> Especially for such a obscure feature -- i remember reviewing your
> rationale for the MRU cache and the probability of this applying
> to 99.9+% of users ever is pretty small. If you insist adding such
> things make them as least as unobtrusive as possible.

Sure, it was written for a small market, but it's useful for other
workloads. e.g. got a heavy tmp file load? Mark /tmp as a filestream
directory and all your temp files end up in one location on disk
and don't pollute and fragment everything else. Got a PVR that
records multiple streams at once? I wouldn't reject this out
of hand as not useful. It was created for the specific purpose
of workload isolation and that can be used in many different
ways....

> > if people complain when they get used to solve problems? 
> 
> Does XFS really need that many threads? Seems doubtful to me.

XFS is much more threaded than any other linux filesystem.
It does lots of stuff asynchronously and that's where the
threads and workqueues come in. They fit in very closely with
the nature of XFS which is to do as much stuff concurrently as
possible on as many CPUs as possible.

Hmmm. I guess you are really not going to like the patch I
have that moves the AIL pushing to a new thread to solve
some of scalability issues in the transaction subsystem......

> Ok part of the problem is that the workqueues are a little dumb.
> e.g. it's highly doubtful per SMT thread workqueues really make
> any sense.  It would be probably enough to have one per socket or
> one per node.

Agreed, but that is a workqueue implementation detail, not a reason
for preventing ppl from using workqueues.

> But that's a separate issue from just gratuitously adding new ones.

Call it what you will. Threads and workqueues are there to be used
and they cost very little for the flexibility and concurrency they
provide us.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
