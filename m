Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4970F35977;
	Thu, 19 Feb 2026 01:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771464293; cv=none; b=dOOP/OixjBc9sI8XsrZ1PMCMnE1oHIPX1KeOObKR+SjQdD0M/diuO2jOdonmDRWjjUHySQ+WUlujMESFmorD8DisJGY/ApErcZiGJcul7RI7ZMNQFf2GdO5kUmriQEPzQsWF9EMox5yDNNpXGxFJwJnw3NvYiT0cXhPSqRXwpqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771464293; c=relaxed/simple;
	bh=zZgoZ3GRBWiFvtQ2DTXYkJKtUZ+SGft7qtG0Bv0ERPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHAIpkFtkqu+tTRXc+iH2u7xiWJu4MoD3/4IUPmYZVED2mQMU9jFizud3UcGDuBLtN0XGhA8tr4p4P8bmJLD3rzxG34YUuI1q1hpsARhsGCEsy9OPbfj2ykA84g9tSBd42Fqx7cfUyb/QFrjUDNxrKkobps5geFIAhNNlgr8c7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LarXpUxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LarXpUxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A39DC116D0;
	Thu, 19 Feb 2026 01:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771464292;
	bh=zZgoZ3GRBWiFvtQ2DTXYkJKtUZ+SGft7qtG0Bv0ERPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LarXpUxP+n2BSxxaJtdqRI8QhYB9ND8ji/hfAOl0lUbSm9CYYyvJ+WSleCZzp1N6d
	 5uA7rUsC+sPIUU5Sp/xHLL+LK3QXxWbvJJ7dtxozHB9Z7UD2445X57HJ4mtKqR16UF
	 AQ6y78YAVa8R9j9hdkIIU3l3nMgnSGTPhQt4h78RNgCGdakJAHH33vb+paeoidQddH
	 aw1XrmZQCxtDbpmbzkPXimr8pkFt70wBPixXBIFwAL3yHRlzI1TNQfddXhbVk3YxTy
	 quC1gdoIv05bUyqtgVX5VOLWIG9UOX/0n0Sy+JKlC8pOQtagsNzitpdLUvbXfEkwmS
	 uKjNu3T8eqxdg==
Date: Thu, 19 Feb 2026 12:24:38 +1100
From: Dave Chinner <dgc@kernel.org>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Hocko <mhocko@suse.com>,
	Anthony Iliopoulos <ailiopoulos@suse.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: convert alloc_workqueue users to WQ_UNBOUND
Message-ID: <aZZmVuY6C8PJMh_F@dread>
References: <20260218165609.378983-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218165609.378983-1-marco.crivellari@suse.com>

On Wed, Feb 18, 2026 at 05:56:09PM +0100, Marco Crivellari wrote:
> Recently, as part of a workqueue refactor, WQ_PERCPU has been added to
> alloc_workqueue() users that didn't specify WQ_UNBOUND.
> The change has been introduced by:
> 
>   69635d7f4b344 ("fs: WQ_PERCPU added to alloc_workqueue users")
> 
> These specific workqueues don't use per-cpu data, so change the behavior
> removing WQ_PERCPU and adding WQ_UNBOUND.

Your definition for "doesn't need per-cpu workqueues" is sadly
deficient.

> Even if these workqueue are
> marked unbound, the workqueue subsystem maintains cache locality by
> default via affinity scopes.
> 
> The changes from per-cpu to unbound will help to improve situations where
> CPU isolation is used, because unbound work can be moved away from
> isolated CPUs.

If you are running operations through the XFS filesystem on isolated
CPUs, then you absolutely need some of these the per-cpu workqueues
running on those isolated CPUs too.

Also, these workqueues are typically implemented these ways to meet
performancei targets, concurrency constraints or algorithm
requirements. Changes like this need a bunch of XFS metadata
scalability benchmarks on high end server systems under a variety of
conditions to at least show there aren't any obvious any behavioural
or performance regressions that result from the change.

> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
> ---
>  fs/xfs/xfs_log.c   |  2 +-
>  fs/xfs/xfs_super.c | 12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a26378ca247d..82f6b12efe22 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1441,7 +1441,7 @@ xlog_alloc_log(
>  	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
>  
>  	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
> -			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_PERCPU),
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_UNBOUND),
>  			0, mp->m_super->s_id);

We want to process IO completions on the same CPU that the
completion was delivered for performance reasons. If you've
configured storage interrupts to be delivered to an isolated CPU,
then you're doing CPU isolation wrong.

>  	if (!log->l_ioend_workqueue)
>  		goto out_free_iclog;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8586f044a14b..072381c6f137 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -592,19 +592,19 @@ xfs_init_mount_workqueues(
>  	struct xfs_mount	*mp)
>  {
>  	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
> -			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU),
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
>  			1, mp->m_super->s_id);

Same here - these are IO completion processing workers.

However, we also want to limit IO completion processing work
depth to a single worker thread per CPU because these completions
rarely block and we can have thousands of them delivered in very
short periods of time.

Hence we do not want thundering storms of kworkers being spawned to
process a single IO completion each; it is far more efficient for a
single kworker to loop processing the incoming queue of IO
completions on a given CPU in a serial manner.

i.e. we use the concurrency control of per-cpu workqueues provide us
with concurrent completion processing based on storage defined
completion delivery, but we also constrain the the concurrency of
work processing to the most efficient method possible.


>  	if (!mp->m_buf_workqueue)
>  		goto out;
>  
>  	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
> -			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU),
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
>  			0, mp->m_super->s_id);

Similar to above - this is data IO completion processing rather than
metadata. However, in this case individual unwritten extent
conversion works can block for long periods (e.g. might need to read
metadata from disk) so we allow lots of unwritten conversions to be
run concurrently per CPU so when one conversion blocks another
kworker can start working. It is not uncommon to see thousands (even
tens of thousands) of unwritten extent kworkers on systems running
heavy IO workloads..

>  	if (!mp->m_unwritten_workqueue)
>  		goto out_destroy_buf;
>  
>  	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
> -			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU),
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
>  			0, mp->m_super->s_id);

This one might be able to be unbound, but the behaviour of this
workqueue has significant impact on memory reclaim performance. i.e
we use per-cpu work here because want it to irun immediately and
hold off other work on the CPU once it has been scheduled because it
is directly responsible for freeing memory. And when we are under
heavy memory pressure, this is kinda important.

>  	if (!mp->m_reclaim_workqueue)
>  		goto out_destroy_unwritten;
> @@ -616,13 +616,13 @@ xfs_init_mount_workqueues(
>  		goto out_destroy_reclaim;
>  
>  	mp->m_inodegc_wq = alloc_workqueue("xfs-inodegc/%s",
> -			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU),
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
>  			1, mp->m_super->s_id);

This is part of a per-cpu work deferring algorithm. It has hard
requirements on per-cpu work scheduling because it uses lockless
per-cpu queues.

This inodegc stuff is required to run on isolated CPUs if the tasks
on isolated CPUs are accessing anything from an XFS filesystem (even
if it is just running binaries from XFS filesystems).

Go look at xfs_inodegc_queue()...


>  	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
> -			XFS_WQFLAGS(WQ_FREEZABLE | WQ_PERCPU), 0,
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_UNBOUND), 0,
>  			mp->m_super->s_id);

That can probably be unbound.

>  	if (!mp->m_sync_workqueue)
>  		goto out_destroy_inodegc;
> @@ -2564,7 +2564,7 @@ xfs_init_workqueues(void)
>  	 * AGs in all the filesystems mounted. Hence use the default large
>  	 * max_active value for this workqueue.
>  	 */
> -	xfs_alloc_wq = alloc_workqueue("xfsalloc", XFS_WQFLAGS(WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_PERCPU),
> +	xfs_alloc_wq = alloc_workqueue("xfsalloc", XFS_WQFLAGS(WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND),
>  			0);

Not sure about this one. It might be ok, but if it runs out of
concurrency then there is potential for memory reclaim/dirty page
cleaning stalls (and maybe deadlocks).

-Dave.

-- 
Dave Chinner
dgc@kernel.org
