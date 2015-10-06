Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 43BB429DF5
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 16:31:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31DFB304048
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 14:31:22 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	n6VxYGVBxRu3HG8p for <xfs@oss.sgi.com>;
	Tue, 06 Oct 2015 14:31:19 -0700 (PDT)
Date: Wed, 7 Oct 2015 08:30:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <20151006213023.GP27164@dastard>
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
	<20151002221649.GL27164@dastard> <5613017D.7080909@hpe.com>
	<20151006002538.GO27164@dastard> <561405E1.8020008@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561405E1.8020008@hpe.com>
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
To: Waiman Long <waiman.long@hpe.com>
Cc: Scott J Norton <scott.norton@hpe.com>, Christoph Lameter <cl@linux-foundation.org>, Douglas Hatch <doug.hatch@hpe.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Tejun Heo <tj@kernel.org>

On Tue, Oct 06, 2015 at 01:33:21PM -0400, Waiman Long wrote:
> On 10/05/2015 08:25 PM, Dave Chinner wrote:
> >On Mon, Oct 05, 2015 at 07:02:21PM -0400, Waiman Long wrote:
> >....
> >>>Having less than 1GB of free space in an XFS filesystem is
> >>>considered to be "almost ENOSPC" - when you have TB to PB of space,
> >>>less than 1GB really "moments before ENOSPC".
> >>We have systems with more than 500 CPUs (HT on). I think SGI has
> >>systems with thousands of CPUs. For those large system, the slowpath
> >>will be triggered if there is less than 4G or 10G for those thousand
> >>CPUs systems.
> >yes, I'm well aware of this. But systems with hundreds to thousands
> >of CPUs simply do not operate their storage at this capacity.
> >They'll have hundreds of TB or PBs of storage attached, so if we
> >trigger the slow path at 10GB of free space, we are talking about
> >having already used>  99.9% of that capacity.
> >
> >In which case, they are already in a world of pain because
> >filesystem allocation performance starts to degrade at>90%
> >capacity, and we start cutting back preallocations at>95% capacity,
> >and we really start to throttle ispace allocations to their
> >minimum possible sizes at>99% capacity. IOWs, hitting this slow
> >path at>99.9% capacity is really irrelevant....
> >
> 
> In the production environment, we do expect to see large storage
> attached to those big machines. However, in the testing environment,
> we may have such large pool of disks to be used. Alternatively, a
> user may create a small filesystem partition for certain specific
> use. Under those circumstances, the slowpath may be triggered.

Yes, it may be, but that does not mean we should optimise for it.
If you are doing filesystem scalability testing on small filesystems
near capacity, then your testing methodology is needs fixing. Not
the code.

> >>>XFS trades off low overhead for fast path allocation  with slowdowns
> >>>as we near ENOSPC in allocation routines. It gets harder to find
> >>>contiguous free space, files get more fragmented, IO takes longer
> >>>because we seek more, etc. Hence we accept that performance slows
> >>>down as as the need for precision increases as we near ENOSPC.
> >>>
> >>>I'd suggest you retry your benchmark with larger filesystems, and
> >>>see what happens...
> >>I don't think I am going to see the slowdown that I observed on
> >>larger filesystems with more free space.
> >So there is no problem that needs fixing.... ;)
> 
> Well, I am still worrying that corner cases when the slowpath is
> triggered. I would like to make it perform better in those cases.

It's a pretty damn small slowdown in your somewhat extreme,
artificial test. Show me a real world production system that runs
small fileystems permanently at >99% filesystem capacity, and them
maybe vwe've got something that needs changing.

> >>gauge how far it is from ENOSPC.  So we don't really need to get
> >>the precise count as long as number of CPUs are taken into
> >>consideration in the comparison.
> >I think you are looking in the wrong place. There is nothing
> >wrong with XFS doing two compares here. If we are hitting the
> >__percpu_counter_compare() slow path too much, then we should be
> >understanding exactly why that slow path is being hit so hard so
> >often. I don't see any analysis of the actual per-cpu counter
> >behaviour and why the slow path is being taken so often....
> 
> I am thinking of making the following changes:

No. Please test the change to the per-cpu counters that I suggested:

> >/*
> >  * Aggregate the per-cpu counter magazines back into the global
> >  * counter. This avoids the need for repeated compare operations to
> >  * run the slow path when the majority of the counter value is held
> >  * in the per-cpu magazines. Folding them back into the global
> >  * counter means we will continue to hit the fast
> >  * percpu_counter_read() path until the counter value falls
> >  * completely within the comparison limit passed to
> >  * __percpu_counter_compare().
> >  */
> >static s64 percpu_counter_aggregate(struct percpu_counter *fbc)
> >{
> >	s64 ret;
> >	int cpu;
> >	unsigned long flags;
> >
> >	raw_spin_lock_irqsave(&fbc->lock, flags);
> >	ret = fbc->count;
> >	for_each_online_cpu(cpu) {
> >		s32 count = __this_cpu_read(*fbc->counters);
> >                 ret += count;
> >		__this_cpu_sub(*fbc->counters, count)
> >	}
> >	fbc->count = ret;
> >	raw_spin_unlock_irqrestore(&fbc->lock, flags);
> >	return ret;
> >}
> 
> I don't think that will work as some other CPUs may change the
> percpu counters values between percpu_counter_aggregate() and
> __percpu_counter_compare().  To be safe, the precise counter has to
> be compted whenever the comparison value difference is less than
> nr_cpus * batch size.

Well, yes. Why do you think the above function does the same
function as percpu_counter_sum()? So that the percpu_counter_sum()
call *inside* __percpu_counter_compare() can be replaced by this
call. i.e.

			return -1;
	}
	/* Need to use precise count */
-	count = percpu_counter_sum(fbc);
+	count = percpu_counter_aggregate(fbc);
	if (count > rhs)
		return 1;
	else if (count < rhs)

Please think about what I'm saying rather than dismissing it without
first understanding my suggestions.

> I have some thoughts on how to reduce precise comparison overhead,
> but I need more time to work out the details.

We don't need something "smart" that only 2 people understand
properly that turns the per-cpu counters into a regression-prone,
unmaintainable mess like all the locking code has become.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
