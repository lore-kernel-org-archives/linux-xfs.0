Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D9317F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 11:01:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0FC67304039
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 09:01:21 -0700 (PDT)
Received: from g2t4622.austin.hp.com (g2t4622.austin.hp.com [15.73.212.79]) by
	cuda.sgi.com with ESMTP id v6x6BPxQ0zj2yrny (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Oct 2015 09:01:19 -0700 (PDT)
Message-ID: <5616934C.5000206@hpe.com>
Date: Thu, 08 Oct 2015 12:01:16 -0400
From: Waiman Long <waiman.long@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
	<20151002221649.GL27164@dastard> <5613017D.7080909@hpe.com>
	<20151006002538.GO27164@dastard> <561405E1.8020008@hpe.com>
	<20151006213023.GP27164@dastard> <561579EA.60507@hpe.com>
	<20151007230441.GG32150@dastard>
In-Reply-To: <20151007230441.GG32150@dastard>
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

On 10/07/2015 07:04 PM, Dave Chinner wrote:
> On Wed, Oct 07, 2015 at 04:00:42PM -0400, Waiman Long wrote:
>> On 10/06/2015 05:30 PM, Dave Chinner wrote:
>>>>> /*
>>>>>   * Aggregate the per-cpu counter magazines back into the global
>>>>>   * counter. This avoids the need for repeated compare operations to
>>>>>   * run the slow path when the majority of the counter value is held
>>>>>   * in the per-cpu magazines. Folding them back into the global
>>>>>   * counter means we will continue to hit the fast
>>>>>   * percpu_counter_read() path until the counter value falls
>>>>>   * completely within the comparison limit passed to
>>>>>   * __percpu_counter_compare().
>>>>>   */
>>>>> static s64 percpu_counter_aggregate(struct percpu_counter *fbc)
>>>>> {
>>>>> 	s64 ret;
>>>>> 	int cpu;
>>>>> 	unsigned long flags;
>>>>>
>>>>> 	raw_spin_lock_irqsave(&fbc->lock, flags);
>>>>> 	ret = fbc->count;
>>>>> 	for_each_online_cpu(cpu) {
>>>>> 		s32 count = __this_cpu_read(*fbc->counters);
>>>>>                  ret += count;
>>>>> 		__this_cpu_sub(*fbc->counters, count)
>>>>> 	}
>>>>> 	fbc->count = ret;
>>>>> 	raw_spin_unlock_irqrestore(&fbc->lock, flags);
>>>>> 	return ret;
>>>>> }
>>>> I don't think that will work as some other CPUs may change the
>>>> percpu counters values between percpu_counter_aggregate() and
>>>> __percpu_counter_compare().  To be safe, the precise counter has to
>>>> be compted whenever the comparison value difference is less than
>>>> nr_cpus * batch size.
>>> Well, yes. Why do you think the above function does the same
>>> function as percpu_counter_sum()? So that the percpu_counter_sum()
>>> call *inside* __percpu_counter_compare() can be replaced by this
>>> call. i.e.
>>>
>>> 			return -1;
>>> 	}
>>> 	/* Need to use precise count */
>>> -	count = percpu_counter_sum(fbc);
>>> +	count = percpu_counter_aggregate(fbc);
>>> 	if (count>   rhs)
>>> 		return 1;
>>> 	else if (count<   rhs)
>>>
>>> Please think about what I'm saying rather than dismissing it without
>>> first understanding my suggestions.
>> I understood what you were saying. However, the per-cpu counter
>> isn't protected by the spinlock. Reading it is OK, but writing may
>> cause race if that counter is modified by a CPU other than its
>> owning CPU.
> <sigh>
>
> You're still trying to pick apart the code without considering what
> we need to acheive.  We don't need to the code to be bullet proof to
> test whether this hypothesis is correct or not - we just need
> something that is "near-enough" to give us the data point to tell us
> where we should focus our efforts. If optimising the counter like
> above does not reduce the overhead, then we may have to change XFS.
> If it does reduce the overhead, then the XFS code remains unchanged
> and we focus on optimising the counter code.

What determine if a precise sum is to be computed is the following code:

         if (abs(count - rhs) > (batch * num_online_cpus())) {

So even if we make the global count more accurate using 
percpu_counter_aggregate(), it won't have too much effect in reducing 
the chance where the precise count needs to be calculated. That is why I 
don't bother testing it with the modified code.

Cheers,
Longman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
