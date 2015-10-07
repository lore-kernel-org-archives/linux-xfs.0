Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CBD97F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 18:05:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9CCE5AC008
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 16:05:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wL6scdMO777xdZBH for <xfs@oss.sgi.com>;
	Wed, 07 Oct 2015 16:05:33 -0700 (PDT)
Date: Thu, 8 Oct 2015 10:04:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <20151007230441.GG32150@dastard>
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
	<20151002221649.GL27164@dastard> <5613017D.7080909@hpe.com>
	<20151006002538.GO27164@dastard> <561405E1.8020008@hpe.com>
	<20151006213023.GP27164@dastard> <561579EA.60507@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561579EA.60507@hpe.com>
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

On Wed, Oct 07, 2015 at 04:00:42PM -0400, Waiman Long wrote:
> On 10/06/2015 05:30 PM, Dave Chinner wrote:
> >>>/*
> >>>  * Aggregate the per-cpu counter magazines back into the global
> >>>  * counter. This avoids the need for repeated compare operations to
> >>>  * run the slow path when the majority of the counter value is held
> >>>  * in the per-cpu magazines. Folding them back into the global
> >>>  * counter means we will continue to hit the fast
> >>>  * percpu_counter_read() path until the counter value falls
> >>>  * completely within the comparison limit passed to
> >>>  * __percpu_counter_compare().
> >>>  */
> >>>static s64 percpu_counter_aggregate(struct percpu_counter *fbc)
> >>>{
> >>>	s64 ret;
> >>>	int cpu;
> >>>	unsigned long flags;
> >>>
> >>>	raw_spin_lock_irqsave(&fbc->lock, flags);
> >>>	ret = fbc->count;
> >>>	for_each_online_cpu(cpu) {
> >>>		s32 count = __this_cpu_read(*fbc->counters);
> >>>                 ret += count;
> >>>		__this_cpu_sub(*fbc->counters, count)
> >>>	}
> >>>	fbc->count = ret;
> >>>	raw_spin_unlock_irqrestore(&fbc->lock, flags);
> >>>	return ret;
> >>>}
> >>I don't think that will work as some other CPUs may change the
> >>percpu counters values between percpu_counter_aggregate() and
> >>__percpu_counter_compare().  To be safe, the precise counter has to
> >>be compted whenever the comparison value difference is less than
> >>nr_cpus * batch size.
> >Well, yes. Why do you think the above function does the same
> >function as percpu_counter_sum()? So that the percpu_counter_sum()
> >call *inside* __percpu_counter_compare() can be replaced by this
> >call. i.e.
> >
> >			return -1;
> >	}
> >	/* Need to use precise count */
> >-	count = percpu_counter_sum(fbc);
> >+	count = percpu_counter_aggregate(fbc);
> >	if (count>  rhs)
> >		return 1;
> >	else if (count<  rhs)
> >
> >Please think about what I'm saying rather than dismissing it without
> >first understanding my suggestions.
> 
> I understood what you were saying. However, the per-cpu counter
> isn't protected by the spinlock. Reading it is OK, but writing may
> cause race if that counter is modified by a CPU other than its
> owning CPU.

<sigh>

You're still trying to pick apart the code without considering what
we need to acheive.  We don't need to the code to be bullet proof to
test whether this hypothesis is correct or not - we just need
something that is "near-enough" to give us the data point to tell us
where we should focus our efforts. If optimising the counter like
above does not reduce the overhead, then we may have to change XFS.
If it does reduce the overhead, then the XFS code remains unchanged
and we focus on optimising the counter code.

But we *need to test the hypothesis first*.

As it is, the update race you pointed out is easy to solve with
__this_cpu_cmpxchg rather than _this_cpu_sub (similar to mod_state()
in the MM percpu counter stats code, perhaps).

So please test the above change and stop quibbling over details
that just don't matter until we know which way we need to go.

> The slow performance of percpu_counter_sum() is due to its need to
> access n different (likely cold) cachelines where n is the number of
> CPUs in the system. So the larger the system, the more problematic
> it will be.

Welcome to today's lecture titled "Per-cpu Counters 101". :/

Have a think about who you are lecturing(*).  Please don't treat me
as you would university intern who's just learning about
multithreaded programming, because a) it's disrepectful, and b)
you'll jump to the wrong conclusions because you may not immediately
understand what I'm saying or why I'm asking you to do something.

I always start by assuming participants understand the topic being
discussed.  I can quickly tell if a person has deep knowledge of the
topic from their responses and the above "explain the basics"
response is a key indicator.  If you assume that the other person
understands the topic as well or better than you do then you won't
make this mistake and, better yet, we might all learn something in
the ensuing discussion.

Cheers,

Dave.

(*) XFS had custom per-cpu counters because there was no generic
infrastructure in linux for this ten years ago:

commit 8d280b98cfe3c0b69c37d355218975c1c0279bb0
Author: David Chinner <dgc@sgi.com>
Date:   Tue Mar 14 13:13:09 2006 +1100

    [XFS] On machines with more than 8 cpus, when running parallel I/O
    threads, the incore superblock lock becomes the limiting factor for
    buffered write throughput. Make the contended fields in the incore
    superblock use per-cpu counters so that there is no global lock to limit
    scalability.
    
    SGI-PV: 946630
    SGI-Modid: xfs-linux-melb:xfs-kern:25106a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Nathan Scott <nathans@sgi.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
