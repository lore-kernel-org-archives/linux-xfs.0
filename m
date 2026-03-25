Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED23372683;
	Wed, 25 Mar 2026 20:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774470398; cv=none; b=gZ9Zz2Aev0S+fEtD+vFOckKildk4Z1CNdJZ2F+QUskjlFG1kzPyqvHNtKC4193g8U7ezAyc5Poh6buNPsXfJMVP9Faa2KurrdKTOakxrfwrKv7XxZRfbE95nifJXcfyEvK3LuvWXhHqnB8b75MMLxnABu1ha8Kr/fUDOMmMIPYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774470398; c=relaxed/simple;
	bh=9288nGTYu2PySycaWl6yYADhv0GQ8SwE+yNWJslpqHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLO0oJG+JQJjdPx/BqyqdSDPNInSUiM6/NthJlmUt/g4DYznKP+Pn/1/gQyk/bqSKPhZWWPFjSY3tElkkf2t00A5yditUxxt6+UcELAeUtqZK+CGfVz3uDmzi89x0x1vgVTJ1/ZO1NvUhWF2O0U204/sYa5mk4YoCff3nIVP1qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uD5iE6Sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uD5iE6Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A580C4CEF7;
	Wed, 25 Mar 2026 20:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774470397;
	bh=9288nGTYu2PySycaWl6yYADhv0GQ8SwE+yNWJslpqHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uD5iE6SjH9WPG+cYdKim6O8OR5sTVTPtHq+SWQB0fE4gy6fDWyg5VERw0RBdt39LV
	 feFpMZN1GedzzBxHW87hlZwsy58LhN9KHpA7Hi/redu99FWpLsM8Qz0G8n7RoUxtJy
	 rvE05dlBbG52qcahxGlHOP2GbjiPMYmYtSO5mjD+9M+LCiWmI40IaZTFIwkz2n0STL
	 oTdKL6dI8ne31KxPI53rWozgN7njx3Fyl29r6+ZDEwUXQ01S4y+HaaQb1ArdGSUB1K
	 dsf23HhFH2v+p1HleKK4oWqgDxumGfqfutXLzuzwOQmmIuZTa7igIt6uOpGTY9th0v
	 lHK4BJH35ihKw==
Date: Thu, 26 Mar 2026 07:26:26 +1100
From: Dave Chinner <dgc@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acRE8pp6HxjK7Z74@dread>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>

On Wed, Mar 25, 2026 at 02:43:00PM -0400, Tal Zussman wrote:
> Some bio completion handlers need to run in task context but bio_endio()
> can be called from IRQ context (e.g. buffer_head writeback). Add a
> BIO_COMPLETE_IN_TASK flag that bio submitters can set to request
> task-context completion of their bi_end_io callback.
> 
> When bio_endio() sees this flag and is running in non-task context, it
> queues the bio to a per-cpu list and schedules a work item to call
> bi_end_io() from task context. A CPU hotplug dead callback drains any
> remaining bios from the departing CPU's batch.
> 
> This will be used to enable RWF_DONTCACHE for block devices, and could
> be used for other subsystems like fscrypt that need task-context bio
> completion.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  block/bio.c               | 84 ++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/blk_types.h |  1 +
>  2 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 8203bb7455a9..69ee0d93041f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -18,6 +18,7 @@
>  #include <linux/highmem.h>
>  #include <linux/blk-crypto.h>
>  #include <linux/xarray.h>
> +#include <linux/local_lock.h>
>  
>  #include <trace/events/block.h>
>  #include "blk.h"
> @@ -1714,6 +1715,60 @@ void bio_check_pages_dirty(struct bio *bio)
>  }
>  EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
>  
> +struct bio_complete_batch {
> +	local_lock_t lock;
> +	struct bio_list list;
> +	struct work_struct work;
> +};
> +
> +static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch) = {
> +	.lock = INIT_LOCAL_LOCK(lock),
> +};
> +
> +static void bio_complete_work_fn(struct work_struct *w)
> +{
> +	struct bio_complete_batch *batch;
> +	struct bio_list list;
> +
> +again:
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	list = batch->list;
> +	bio_list_init(&batch->list);
> +	local_unlock_irq(&bio_complete_batch.lock);

This is just a FIFO processing queue, and it is so wanting to be a
struct llist for lockless queuing and dequeueing.

We do this lockless per-cpu queue + per-cpu workqueue in XFS for
background inode GC processing. See struct xfs_inodegc and all the
xfs_inodegc_*() functions - it may be useful to have a generic
lockless per-cpu queue processing so we don't keep open coding this
repeating pattern everywhere.

> +
> +	while (!bio_list_empty(&list)) {
> +		struct bio *bio = bio_list_pop(&list);
> +		bio->bi_end_io(bio);
> +	}
> +
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	if (!bio_list_empty(&batch->list)) {
> +		local_unlock_irq(&bio_complete_batch.lock);
> +
> +		if (!need_resched())
> +			goto again;
> +
> +		schedule_work_on(smp_processor_id(), &batch->work);

We've learnt that immediately scheduling per-cpu batch
processing work can cause context switch storms as the queue/dequeue
steps one work item at a time.

Hence we use a delayed work with a scheduling delay of a singel
jiffie to allow batches of queue work from a single context to
complete before (potentially) being pre-empted by the per-cpu
kworker task that will process the queue...

> +		return;
> +	}
> +	local_unlock_irq(&bio_complete_batch.lock);
> +}
> +
> +static void bio_queue_completion(struct bio *bio)
> +{
> +	struct bio_complete_batch *batch;
> +	unsigned long flags;
> +
> +	local_lock_irqsave(&bio_complete_batch.lock, flags);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	bio_list_add(&batch->list, bio);
> +	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
> +
> +	schedule_work_on(smp_processor_id(), &batch->work);
> +}

Yeah, we definitely want to queue all the pending bio completions
the interrupt is delivering before we run the batch processing...

> +
>  static inline bool bio_remaining_done(struct bio *bio)
>  {
>  	/*
> @@ -1788,7 +1843,9 @@ void bio_endio(struct bio *bio)
>  	}
>  #endif
>  
> -	if (bio->bi_end_io)
> +	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> +		bio_queue_completion(bio);
> +	else if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
>  }
>  EXPORT_SYMBOL(bio_endio);
> @@ -1974,6 +2031,21 @@ int bioset_init(struct bio_set *bs,
>  }
>  EXPORT_SYMBOL(bioset_init);
>  
> +/*
> + * Drain a dead CPU's deferred bio completions. The CPU is dead so no locking
> + * is needed -- no new bios will be queued to it.
> + */
> +static int bio_complete_batch_cpu_dead(unsigned int cpu)
> +{
> +	struct bio_complete_batch *batch = per_cpu_ptr(&bio_complete_batch, cpu);
> +	struct bio *bio;
> +
> +	while ((bio = bio_list_pop(&batch->list)))
> +		bio->bi_end_io(bio);
> +
> +	return 0;
> +}

If you use a llist for the queue, this code is no different to the
normal processing work.

> +
>  static int __init init_bio(void)
>  {
>  	int i;
> @@ -1988,6 +2060,16 @@ static int __init init_bio(void)
>  				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
>  	}
>  
> +	for_each_possible_cpu(i) {
> +		struct bio_complete_batch *batch =
> +			per_cpu_ptr(&bio_complete_batch, i);
> +
> +		bio_list_init(&batch->list);
> +		INIT_WORK(&batch->work, bio_complete_work_fn);
> +	}
> +
> +	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
> +				NULL, bio_complete_batch_cpu_dead);

XFS inodegc tracks the CPUs with work queued via a cpumask and
iterates the CPU mask for "all CPU" iteration scans. This avoids the
need for CPU hotplug integration...

>  	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
>  					bio_cpu_dead);
>  
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 8808ee76e73c..d49d97a050d0 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -322,6 +322,7 @@ enum {
>  	BIO_REMAPPED,
>  	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
>  	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
> +	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */

Can anyone set this on a bio they submit? i.e. This needs a better
description. Who can use it, constraints, guarantees, etc.

I ask, because the higher filesystem layers often know at submission
time that we need task based IO completion. If we can tell the bio
we are submitting that it needs task completion and have the block
layer guarantee that the ->end_io completion only ever runs in task
context, then we can get rid of mulitple instances of IO completion
deferal to task context in filesystem code (e.g. iomap - for both
buffered and direct IO, xfs buffer cache write completions, etc).

-Dave.
-- 
Dave Chinner
dgc@kernel.org
