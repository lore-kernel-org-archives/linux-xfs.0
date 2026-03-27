Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FF02C032E;
	Fri, 27 Mar 2026 06:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774591292; cv=none; b=f1rSOqdQMrffPLnI0TPIZ0c8/ihrskkHuGqsw0E8HTuZxNfV4oeKPyfr1S+NPRW0eTxK/TuoX+vme86apBGRlx0FlibRqTIM6/h6/EC4dHWMghDMnc3GGaSIR6dbdkF8u1pMs3s4WNHk1hVF/w3HDBW06k328D7cPdObmhbQpn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774591292; c=relaxed/simple;
	bh=kAoBU9a18y+tXAeXe8CSWjyw+Qmd3mLGnVAELTrstg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GfP1fsX4eCUAu3oWeW6u8WQJdZpJqIIjsBTvG9oiJPM9NHGbx7wcIU7RIAkJh8EC6IuZGv3cP27CgsNpZ3MxnR0+IvR8TI54HhzpxnM0P24W5PiPY0JJwOIAFzmV09VtK47EfCoB7SkW2BcW/ftFNOzgsuekABJ54FflLs6D1No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gv0tKMSx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gv0tKMSx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZiR2I8sUxZ8yfDLJLzYQlzBVwCrZzKrXAduqCfpJ0ms=; b=Gv0tKMSxUjyVhdxob889CYtLIC
	F1PlKPVaDqHDZmXCEPT6cdBFQxa8xJadENkhnrMzOaLQRQwIVcnW3bZIKGFNpWhrUp13cEFpceEsp
	Dq/l0msSvVZ+JtdJBCK+CHes78MKj6YEf1wLxe6dsFDll3tYJ9lZAaFGcBEYS5UR/Bz+WXgjF6//A
	wZndvR73vmqGGrGpkh8ojVuO9rUm/e9jPM94wTRC2QIIc18fSk7vBHZ9MFdj9mvCFwvoTWlkzoGkn
	SWn/9XWy0l87nYejZfww4Oz3Bi/weU+Yzf3Bra1iCsBhQYGgOUozY/vAun5MyjvwWLdgdZ7D5NptO
	uFAhwOvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60G8-00000006jdX-4BfV;
	Fri, 27 Mar 2026 06:01:29 +0000
Date: Thu, 26 Mar 2026 23:01:28 -0700
From: Christoph Hellwig <hch@infradead.org>
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
Message-ID: <acYdOOpo51xrzNBg@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

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
> +
> +	while (!bio_list_empty(&list)) {
> +		struct bio *bio = bio_list_pop(&list);
> +		bio->bi_end_io(bio);
> +	}

bio_list_pop already does a NULL check, so this could be:

	while ((bio = bio_list_pop(&batch->list)))
		bio->bi_end_io(bio);

In fact that same pattern is repeated later, so maybe just add a helper
for it?  But I think Dave's idea of just using a llist (and adding a
new llist member to the bio for this) seems sensible.  Just don't forget
the llist_reverse_order call to avoid reordering.

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
> +		return;
> +	}
> +	local_unlock_irq(&bio_complete_batch.lock);

I don't really understand this requeue logic.  Can you explain it?

> +	schedule_work_on(smp_processor_id(), &batch->work);

We'll probably want a dedicated workqueue here to avoid deadlocks
vs other system wq uses.

> +static int bio_complete_batch_cpu_dead(unsigned int cpu)
> +{
> +	struct bio_complete_batch *batch = per_cpu_ptr(&bio_complete_batch, cpu);

Overly long line.

