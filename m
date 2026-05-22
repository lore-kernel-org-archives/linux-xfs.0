Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97AD38E8CD
	for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779491406; cv=none; b=CNeTiPouzmuAk+drklf04dSDw5bE/jQHN0hL8i8t7HccgRes5QMpjdDG/brRgQvksSGk83bUY0JoyfbsfbyFXtQIK5CAC/2/x+wEulT/HoyFlK4nyxc6hEZ/9eAfN21I5RrXjy04q9Ib8ovbnAt61D67aIMC5Tzb2ZZAQth50cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779491406; c=relaxed/simple;
	bh=LnWSpigA9EMyhy65z1pj9AsgB1SEuYNEbe9VSst2mEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rS/9dx4dh7W8JthDGkl7kJgFnbRlpSfp3p8/PjY31oZtAXOxLwSvilT3RtqcT54zandiHnpc9kouawBThvHgNjmm/ZmpNzYOtEIpg5ZQlexpB3Yp5Nc0vuza3pGzLjMcxWDgolfzI63gY58wpydnE6oN1ITVdiDgytMC3BLK59Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ajmjPiss; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ajmjPiss"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MMS9s81915289
	for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 19:10:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=dDWh
	6Dh7CO21d9q3MhBCeH86IkvYOU13lZmvzOI+9/A=; b=ajmjPissWjpyXLr/vZXu
	zq8Z77zJg2cNWNY9gYDMPHcZtBEJwS0mxuEnLvhXReIUVIMYt22PlUWI0bOaGZFB
	+GRLyECvgOEmOvfQPPX9M5sWF6kUyybK/S1CAy9avnLcaVtm11hSGWfSfGTAbq35
	347K0vKIPDvDhrm1oQ/QLHuj0xwxcJEC+1E8T21Uzdc1/n8rlP7t5gczNkdrZtXh
	vuxSd3obWfDn8R9bs7YDAW2BbKqD+mv6B0igUq6e4bXwDInwMg5eMLH5nLH837Zf
	sUxaO/LVeYrURhusIGU/d+2u6Ra7U9BDcFRknpWaEnuod8lROXS2GgfV0z4KxGM5
	IQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4eawwu0uu3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 19:10:02 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-514ae0e3ad6so198309781cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2026 16:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779491402; x=1780096202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dDWh6Dh7CO21d9q3MhBCeH86IkvYOU13lZmvzOI+9/A=;
        b=gyGtIU+5zjLR2yUD9Dzz4dXs3YG4Dd1JWcl5Vi1dIu9PGspc1n7WePY8B7Z9fSxI2a
         Q6n4+Mun9H/UuYXRH9C2b6kFKgzrKCbmGIhRhdnMOd/urcdrvP5LxOod+NYZj2z7zVBl
         bF2mcPYO5FGuMuwwrrDeYThYLkfGbj0kBjJP2C1u8OQSbz8KT9+Um7XI9XmqFaqrlsAr
         MrCyoizQG/Y7dLzeyJ/Q39fk9krQ9LO+MsqzS7fzeM3lwRZaRpCPd2fH1OYISbxj8T/u
         zG/QDrCKSIz8eXsc8+IlQoqcr1ff5FdPcASsuRWwRaAeMaeRTpAQZT0wHAVWuc9gDLtx
         BmAQ==
X-Forwarded-Encrypted: i=1; AFNElJ/pEa0bGyr8LXfnTYcKUEgB8sv4dLdeXIWa+1O28xABnTgODK2cXTU1QuLI9x4qA+QoaCQxqSkMjEg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzys4dypvE5+QLKuzpndB1tn0ezEdyxsiNbFFZi9MFCq7/NB/ZW
	FdmKpWvPeyUtxLN4mHvMEy7moM+2p3bJQ2dDJQ3TgQREBc+YYAEstfO3mIMsZsYUvp0jyDeUH/7
	w2SocN7tw7+1BBjGxcNVrHk4TNgcrACPyflaVcuzXpdIgAmI1juaNCxXvRg==
X-Gm-Gg: Acq92OGb3cMCuuGiCrrz1TYKSZfiYkkvpJ1VGjdhckVNPAQPt/QLGGH9sYix7CedsDS
	LDb/3fF82kXVPMC0FuY9F5NeflGv1HRfZbMla+xJ7OoB1nQSL9EfBxzGl4oXpcbY0oePt+AFv8F
	EmN3va/c9Bh9LCqFwOJsxhgzieesWPROLS8tZEMbn4MqBZUjFEPlP2FaIGE9mg/bjaLU2xw0YDv
	jxOlr9jZwY1K29G3vRsEsC9cyjp+XYfXds3Sbc7di4IPAdCHhayr9Jm+lNb97Ye+OVdZzudhCOf
	E1PQhi5WR7Ff5gurwbmqNUVKnj2s2wyWoSf3INyiu9G376YZCgLZ25w1/ioxPr+MYqDSpgLPL1N
	en2MnUXuSe0PV9LpUi7SIzbnavBfszvik32DcBYZqyrhO/36gRE+c9xbR1idVsQFcPvT7a7NC4L
	Y=
X-Received: by 2002:a05:622a:110f:b0:50e:600a:638c with SMTP id d75a77b69052e-516d573f74fmr62658831cf.17.1779491401779;
        Fri, 22 May 2026 16:10:01 -0700 (PDT)
X-Received: by 2002:a05:622a:110f:b0:50e:600a:638c with SMTP id d75a77b69052e-516d573f74fmr62658321cf.17.1779491401082;
        Fri, 22 May 2026 16:10:01 -0700 (PDT)
Received: from [10.207.65.224] (nat-128-59-177-214.net.columbia.edu. [128.59.177.214])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516d8cc6212sm26448231cf.25.2026.05.22.16.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 16:10:00 -0700 (PDT)
Message-ID: <ea6fc01f-5cb7-4a04-9f92-bbd2791fea51@columbia.edu>
Date: Fri, 22 May 2026 19:09:59 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDIzMSBTYWx0ZWRfXwL28BvMYs6wA
 HGPjZlH3h+izUI0GiTlZLQ/ALI1dRkl77vQcRhoLUlW/Q9yspEtPYVvI8WcXcJ1QYWHPxFDhWuU
 XgBy+J1TRf0sZLO/PyMIJyZmV9fpS9T/N5dqAueh1LEuZCQQDHlWiVZdBGUC+nr3SucFuog+G2h
 WF1VMm7jeoyMbF05HLjqOgofmzArSVvRfiOx2WEoxxxjpWv6EbuTJuY8+193PErNA0vSChcb363
 7LHhdICsKHI/7q4W4YfVi0W5C4h0LdHMJTbK1s7Zh8slkaDq3NON47z3jx0JBwYTHY8hopFsWAy
 xl5/9u+OpGFhu7k/Tbm/REc7dgvDMyEOW6Wagc1/6+quWgsrAFtP4yBE5k+Yp0bB/PD1JCWeB1K
 xyuf93U2X1C/O1z+KBzKG6BSEzDIv2SXHNBLX4WNu/3rRkxNCDo9Hh9Yd+0xcK4KFSyrLYWDvS8
 /m4oV4/j+4KbcXvdW8Q==
X-Authority-Analysis: v=2.4 cv=a40AM0SF c=1 sm=1 tr=0 ts=6a10e24a cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=n4JpGxNP30DHW88kdRRHAg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=c92rfblmAAAA:8 a=iwgvYRDhkiyaR0dmeYsA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: 8L4NLlH2oWtY0luhdQ5YaDFf2RtSo1nb
X-Proofpoint-ORIG-GUID: 8L4NLlH2oWtY0luhdQ5YaDFf2RtSo1nb
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11794
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 clxscore=1015 suspectscore=0
 impostorscore=10 adultscore=0 phishscore=0 bulkscore=10 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220231

On 5/14/26 5:51 PM, Tal Zussman wrote:

Responding to Sashiko review inline:

Link: https://sashiko.dev/#/patchset/20260514-blk-dontcache-v6-0-782e2fa7477b%40columbia.edu

> +static void bio_complete_work_fn(struct work_struct *w)
> +{
> +	struct delayed_work *dw = to_delayed_work(w);
> +	struct bio_complete_batch *batch =
> +		container_of(dw, struct bio_complete_batch, work);
> +
> +	while (1) {
> +		struct bio_list list;
> +		struct bio *bio;
> +
> +		local_lock_irq(&bio_complete_batch.lock);
> +		list = batch->list;
> +		bio_list_init(&batch->list);
> +		local_unlock_irq(&bio_complete_batch.lock);
> +
> +		if (bio_list_empty(&list))
> +			break;
> +
> +		while ((bio = bio_list_pop(&list)))
> +			bio->bi_end_io(bio);

Q: "Does this code handle bios that do not have a completion callback?
If a bio is submitted with the BIO_COMPLETE_IN_TASK flag but has a NULL
bi_end_io pointer (like some flush or discard bios), executing
bio->bi_end_io(bio) directly will cause a NULL pointer dereference.
The synchronous completion path in bio_endio() checks if bio->bi_end_io is
non-NULL before calling it. Should a similar check be added here?"

A: Every bio that reaches this point should have bi_end_io set. There's no
point in deferring a bio without a completion handler.

Q: "Could this loop also monopolize the CPU and cause latency spikes?
Because the work uses a 1-jiffie delay, tens of thousands of bios might
accumulate under heavy I/O load. Processing the entire batch sequentially
without yielding or calling cond_resched() inside the inner loop could
lead to scheduler latency or watchdog warnings on non-preemptible kernels."

A: With PREEMPT_LAZY as the default, the worker is preemptible, as per 
Hillf and Christoph, so this is unnecessary.

> +		if (need_resched()) {
> +			bool is_empty;
> +
> +			local_lock_irq(&bio_complete_batch.lock);
> +			is_empty = bio_list_empty(&batch->list);
> +			local_unlock_irq(&bio_complete_batch.lock);
> +			if (!is_empty)
> +				mod_delayed_work_on(batch->cpu,
> +						    bio_complete_wq,
> +						    &batch->work, 0);
> +			break;
> +		}
> +	}
> +}
> +
> +void __bio_complete_in_task(struct bio *bio)
> +{
> +	struct bio_complete_batch *batch;
> +	unsigned long flags;
> +	bool was_empty;
> +
> +	local_lock_irqsave(&bio_complete_batch.lock, flags);

Q: "Is it safe to use local_lock_irqsave() here when called from an atomic
context?
On CONFIG_PREEMPT_RT kernels, local_lock_t maps to a per-CPU spinlock_t,
which is a sleepable rt_mutex. Since __bio_complete_in_task() is specifically
called when bio_in_atomic() is true (which includes hardware interrupts or
execution under a raw_spinlock_t), attempting to acquire a sleepable lock
here would trigger an "Invalid wait context" lockdep warning.
Would a lockless list (llist) be more appropriate here to avoid sleeping
in atomic contexts?"

A: This seems legit, but I'm not super familiar with PREEMPT_RT. I don't want
to switch to raw_spinlock_t, as it seems like that would add unnecessary
overhead on non-PREEMPT_RT kernels. I think switching to use local_irq_save()
(as is done for the per-CPU bio allocation cache) should work.

> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	was_empty = bio_list_empty(&batch->list);
> +	bio_list_add(&batch->list, bio);
> +	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
> +
> +	if (was_empty)
> +		mod_delayed_work_on(batch->cpu, bio_complete_wq,
> +				    &batch->work, 1);
> +}
> +EXPORT_SYMBOL_GPL(__bio_complete_in_task);
> +
>  static inline bool bio_remaining_done(struct bio *bio)
>  {
>  	/*
> @@ -1791,7 +1865,9 @@ void bio_endio(struct bio *bio)
>  	}
>  #endif
>  
> -	if (bio->bi_end_io)
> +	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
> +		__bio_complete_in_task(bio);
> +	else if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
>  }
>  EXPORT_SYMBOL(bio_endio);
> @@ -1977,6 +2053,51 @@ int bioset_init(struct bio_set *bs,
>  }
>  EXPORT_SYMBOL(bioset_init);
>  
> +static int bio_complete_batch_cpu_online(unsigned int cpu)
> +{
> +	enable_delayed_work(&per_cpu(bio_complete_batch, cpu).work);
> +	return 0;
> +}
> +

Q: "Could a CPU hotplug rollback strand deferred bios indefinitely?
During the early teardown phase (CPUHP_AP_ONLINE_DYN),
bio_complete_batch_cpu_down_prep() disables the delayed work. However, the
CPU remains active and can continue completing bios. When these bios
complete, __bio_complete_in_task() adds them to the list with
was_empty = true, but mod_delayed_work_on() fails to queue the work
because it is disabled.
If the CPU offline operation is aborted, bio_complete_batch_cpu_online()
re-enables the delayed work but does not explicitly queue it. Because the
list is no longer empty, any future bio completions will see
was_empty == false and skip calling mod_delayed_work_on(), permanently
stranding the bios."

A: This is legit. The solution is to requeue the work if the list isn't
empty on CPU online.

> +/*
> + * Disable this CPU's delayed work so that it cannot run on an unbound worker
> + * after the CPU is offlined.
> + */
> +static int bio_complete_batch_cpu_down_prep(unsigned int cpu)
> +{
> +	disable_delayed_work_sync(&per_cpu(bio_complete_batch, cpu).work);
> +	return 0;
> +}
> +
> +/*
> + * Drain a dead CPU's deferred bio completions. The CPU is dead and the worker
> + * is canceled so no locking is needed.
> + */
> +static int bio_complete_batch_cpu_dead(unsigned int cpu)
> +{
> +	struct bio_complete_batch *batch =
> +		per_cpu_ptr(&bio_complete_batch, cpu);
> +	struct bio *bio;
> +
> +	while ((bio = bio_list_pop(&batch->list)))
> +		bio->bi_end_io(bio);
> +

Q: "Is it possible to hit the same NULL pointer dereference issue here if the
bio lacks a bi_end_io callback?"

A: Same as above.

> +	return 0;
> +}
> +
> +static void __init bio_complete_batch_init(int cpu)
> +{
> +	struct bio_complete_batch *batch =
> +		per_cpu_ptr(&bio_complete_batch, cpu);
> +
> +	bio_list_init(&batch->list);
> +	INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
> +	batch->cpu = cpu;
> +
> +	if (!cpu_online(cpu))
> +		disable_delayed_work_sync(&batch->work);
> +}
> +
>  static int __init init_bio(void)
>  {
>  	int i;
> @@ -1991,6 +2112,30 @@ static int __init init_bio(void)
>  				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
>  	}
>  
> +	for_each_possible_cpu(i)
> +		bio_complete_batch_init(i);
> +
> +	bio_complete_wq = alloc_workqueue("bio_complete",
> +					   WQ_MEM_RECLAIM | WQ_PERCPU, 0);

Q: "Does creating this workqueue with WQ_MEM_RECLAIM break the local_lock_irq()
protection in bio_complete_work_fn()?
When a workqueue has WQ_MEM_RECLAIM, it spawns a global rescuer thread that
can execute per-CPU work items during worker pool congestion. This rescuer
thread executes unbound, meaning it could run on CPU B while processing
CPU A's work item.
Since local_lock operates strictly on the currently executing CPU, the
rescuer thread on CPU B would acquire CPU B's lock, while popping elements
from CPU A's list (derived via container_of()).
If an interrupt on CPU A concurrently calls __bio_complete_in_task(),
it will acquire CPU A's lock and modify the same list without mutual
exclusion, potentially causing list corruption."

A: The rescuer should run on the same CPU, not unbound, so this is not an
issue.

> +	if (!bio_complete_wq)
> +		panic("bio: can't allocate bio_complete workqueue\n");
> +
> +	/*
> +	 * bio task-context completion draining on hot-unplugged CPUs:
> +	 *
> +	 *   1. Stop the per-CPU delayed work while the CPU is still online, so
> +	 *      that it cannot run on an unbound worker later.
> +	 *   2. Drain leftover bios added between worker disabling and CPU
> +	 *      offlining.
> +	 */
> +	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
> +				  "block/bio:complete:online",
> +				  bio_complete_batch_cpu_online,
> +				  bio_complete_batch_cpu_down_prep);
> +	cpuhp_setup_state_nocalls(CPUHP_BP_PREPARE_DYN,
> +				  "block/bio:complete:dead",
> +				  NULL, bio_complete_batch_cpu_dead);
> +
>  	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
>  					bio_cpu_dead);
>  
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 97d747320b35..c0214d6c28d6 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -369,6 +369,38 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
>  
>  void submit_bio(struct bio *bio);
>  
> +/**
> + * bio_in_atomic - check if the current context is unsafe for bio completion
> + *
> + * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
> + * %false when a bio can be safely completed in the current context.
> + */
> +static inline bool bio_in_atomic(void)
> +{
> +	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> +		return true;
> +	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> +		return true;

Q: "Will this cause an infinite loop of bio offloading on kernels with
CONFIG_PREEMPT_COUNT disabled?
Because bio_in_atomic() unconditionally returns true without preempt count
support, a dynamic call to bio_complete_in_task() from within a bi_end_io()
callback will always offload the bio to the workqueue.
When the workqueue executes bio->bi_end_io(bio), the callback will evaluate
bio_complete_in_task() again, which will return true again, creating a
permanent offloading loop."

A: Legit issue. This can be solved by changing bio_complete_in_task() to:

static inline bool bio_complete_in_task(struct bio *bio)
{
	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK))
		return false;
	if (!bio_in_atomic())
		return false;
	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
	__bio_complete_in_task(bio);
	return true;
}

We can use the BIO_COMPLETE_IN_TASK flag to indicate that it's already
been deferred to the workqueue as is safe to run.

> +	return !preemptible();
> +}
> +
> +void __bio_complete_in_task(struct bio *bio);
> +
> +/**
> + * bio_complete_in_task - ensure a bio is completed in preemptible task context
> + * @bio: bio to complete
> + *
> + * If called from non-task context, offload the bio completion to a worker
> + * thread and return %true. Else return %false and do nothing.
> + */
> +static inline bool bio_complete_in_task(struct bio *bio)
> +{
> +	if (!bio_in_atomic())
> +		return false;
> +	__bio_complete_in_task(bio);
> +	return true;
> +}
> +
>  extern void bio_endio(struct bio *);
>  
>  static inline void bio_io_error(struct bio *bio)
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 8808ee76e73c..d49d97a050d0 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -322,6 +322,7 @@ enum {
>  	BIO_REMAPPED,
>  	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
>  	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
> +	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
>  	BIO_FLAG_LAST
>  };
>  
> 

