Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33F737F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 15:01:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22FFB30408E
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 13:00:59 -0700 (PDT)
Received: from g1t6213.austin.hp.com (g1t6213.austin.hp.com [15.73.96.121]) by
	cuda.sgi.com with ESMTP id f7r5X1OhSv7T8Hl6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 13:00:46 -0700 (PDT)
Message-ID: <561579EA.60507@hpe.com>
Date: Wed, 07 Oct 2015 16:00:42 -0400
From: Waiman Long <waiman.long@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
	<20151002221649.GL27164@dastard> <5613017D.7080909@hpe.com>
	<20151006002538.GO27164@dastard> <561405E1.8020008@hpe.com>
	<20151006213023.GP27164@dastard>
In-Reply-To: <20151006213023.GP27164@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Scott J Norton <scott.norton@hpe.com>, Christoph Lameter <cl@linux-foundation.org>, Douglas Hatch <doug.hatch@hpe.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Tejun Heo <tj@kernel.org>

On 10/06/2015 05:30 PM, Dave Chinner wrote:
> On Tue, Oct 06, 2015 at 01:33:21PM -0400, Waiman Long wrote:
> Yes, it may be, but that does not mean we should optimise for it.
> If you are doing filesystem scalability testing on small filesystems
> near capacity, then your testing methodology is needs fixing. Not
> the code.
>
>>>>> XFS trades off low overhead for fast path allocation  with slowdowns
>>>>> as we near ENOSPC in allocation routines. It gets harder to find
>>>>> contiguous free space, files get more fragmented, IO takes longer
>>>>> because we seek more, etc. Hence we accept that performance slows
>>>>> down as as the need for precision increases as we near ENOSPC.
>>>>>
>>>>> I'd suggest you retry your benchmark with larger filesystems, and
>>>>> see what happens...
>>>> I don't think I am going to see the slowdown that I observed on
>>>> larger filesystems with more free space.
>>> So there is no problem that needs fixing.... ;)
>> Well, I am still worrying that corner cases when the slowpath is
>> triggered. I would like to make it perform better in those cases.
> It's a pretty damn small slowdown in your somewhat extreme,
> artificial test. Show me a real world production system that runs
> small fileystems permanently at>99% filesystem capacity, and them
> maybe vwe've got something that needs changing.
>
>>>> gauge how far it is from ENOSPC.  So we don't really need to get
>>>> the precise count as long as number of CPUs are taken into
>>>> consideration in the comparison.
>>> I think you are looking in the wrong place. There is nothing
>>> wrong with XFS doing two compares here. If we are hitting the
>>> __percpu_counter_compare() slow path too much, then we should be
>>> understanding exactly why that slow path is being hit so hard so
>>> often. I don't see any analysis of the actual per-cpu counter
>>> behaviour and why the slow path is being taken so often....
>> I am thinking of making the following changes:
> No. Please test the change to the per-cpu counters that I suggested:
>
>>> /*
>>>   * Aggregate the per-cpu counter magazines back into the global
>>>   * counter. This avoids the need for repeated compare operations to
>>>   * run the slow path when the majority of the counter value is held
>>>   * in the per-cpu magazines. Folding them back into the global
>>>   * counter means we will continue to hit the fast
>>>   * percpu_counter_read() path until the counter value falls
>>>   * completely within the comparison limit passed to
>>>   * __percpu_counter_compare().
>>>   */
>>> static s64 percpu_counter_aggregate(struct percpu_counter *fbc)
>>> {
>>> 	s64 ret;
>>> 	int cpu;
>>> 	unsigned long flags;
>>>
>>> 	raw_spin_lock_irqsave(&fbc->lock, flags);
>>> 	ret = fbc->count;
>>> 	for_each_online_cpu(cpu) {
>>> 		s32 count = __this_cpu_read(*fbc->counters);
>>>                  ret += count;
>>> 		__this_cpu_sub(*fbc->counters, count)
>>> 	}
>>> 	fbc->count = ret;
>>> 	raw_spin_unlock_irqrestore(&fbc->lock, flags);
>>> 	return ret;
>>> }
>> I don't think that will work as some other CPUs may change the
>> percpu counters values between percpu_counter_aggregate() and
>> __percpu_counter_compare().  To be safe, the precise counter has to
>> be compted whenever the comparison value difference is less than
>> nr_cpus * batch size.
> Well, yes. Why do you think the above function does the same
> function as percpu_counter_sum()? So that the percpu_counter_sum()
> call *inside* __percpu_counter_compare() can be replaced by this
> call. i.e.
>
> 			return -1;
> 	}
> 	/* Need to use precise count */
> -	count = percpu_counter_sum(fbc);
> +	count = percpu_counter_aggregate(fbc);
> 	if (count>  rhs)
> 		return 1;
> 	else if (count<  rhs)
>
> Please think about what I'm saying rather than dismissing it without
> first understanding my suggestions.

I understood what you were saying. However, the per-cpu counter isn't 
protected by the spinlock. Reading it is OK, but writing may cause race 
if that counter is modified by a CPU other than its owning CPU.

The slow performance of percpu_counter_sum() is due to its need to 
access n different (likely cold) cachelines where n is the number of 
CPUs in the system. So the larger the system, the more problematic it 
will be. My main concern about xfs_mod_fdblocks() is that it can 
potentially call percpu_counter_sum() twice which is what I want to 
prevent. It is OK if you don't think that change is necessary. However, 
I will come back if I find more evidence that this can be an issue.

Cheers,
Longman



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
