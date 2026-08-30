Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A059633030F;
	Sun, 30 Aug 2026 21:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788126998; cv=none; b=cG42SYMs6HIMBnFUNovZ8HMyePQRR2JQ6rHJbnKXDGFXzTY5uVedepLgiLH2y4Ws3rKq+b+ir5vgdtDqbE5eW+0Nb2KBXvjA+tJtDZpf4u9VsAI1B/ezQ7Y1+HRoVPP8b9iUego92CA0rK5q2SUevU7U9ce6I1NQu9aCOOjs+6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788126998; c=relaxed/simple;
	bh=qZlU+p7lXLrxefMKn0dslIY2Q0FciDavNpjIr64YDXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOgRvT+lxO4vd9xoEexa1kdreOqbe1AmRt/YvN1z97lwD7sSSX2Duq98BDfRVtcRRx7i/3faJlD9dKB3K98UPHEOM/HoHM1xe0M6IGcyv4FH+SVGtthMvA00+mswVIu4xfttBTq0FI37OSKv2i7UPctuvyi1PTxghv1k40z3kjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Agm9kTOT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Agm9kTOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0825F1F000E9;
	Sun, 30 Aug 2026 21:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788126997;
	bh=KlTkAZ8T94kU0R76bTccWD/gpwVYPP6lAGYFIXUHTkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Agm9kTOTMArPZEjG63aXM9nP0taYHpezD93f9wxLAlMVG0arRDlnQJzU9955orkK0
	 5ewehOeablm9xUlMT7eoqVk23RbpsBV6G/c2iCSWpPLe9Aefa9hfV/OV7VAWCG1Lie
	 R4l5uxU6JGm9yBbZStZI/CrFWmJeWpno0JJenTGUHRQoKpG9KD1G+vRlHgfJhOVM76
	 7zoJBRDE6WC4pnKi4AqDVfzAtFQQYAwXt5Tv/cxtefTIn6NoJveH4ouYItYBX7IyRL
	 DGVjaSp/7X/6n4EZk+KcgIquFgG0+OjH9Dzsrp+hKbw9NzmqiQkpNMIJB5K61cKd+b
	 hhU9AWZKAqIqg==
Date: Mon, 31 Aug 2026 07:56:27 +1000
From: Dave Chinner <dgc@kernel.org>
To: Ran Hongyun <ranhongyun1@huawei.com>
Cc: catherine.hoang@oracle.com, chandan.babu@oracle.com, djwong@kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com
Subject: Re: [QUESTION] xfs: Can we remove flush_workqueue from
 xlog_cil_push_now?
Message-ID: <apSnC9p0X04cKxDj@dread>
References: <20260827033654.1172495-1-ranhongyun1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260827033654.1172495-1-ranhongyun1@huawei.com>

On Thu, Aug 27, 2026 at 11:36:52AM +0800, Ran Hongyun wrote:
> In xlog_cil_push_now(), we call flush_workqueue(cil->xc_push_wq) before
> queuing a new work item in sync mode. The intention is to start any
> pending background push and reduce the wait time for the new sync work.
> However, after commit 636b927eba5b ("workqueue: Make unbound workqueues
> to use per-cpu pool_workqueues"), flush_workqueue() iterates over all
> nr_cpus pool_workqueue entries, instead of per-NUMA nodes. On large SMP
> systems (e.g. 128 CPUs, 4 NUMA nodes), this adds significant overhead.
> Even after 85f0d8e39aff ("workqueue: Reduce expensive locks for unbound
> workqueue") reduced lock cost, the per-CPU iteration remains costly.
> This seems contrary to the original performance intent of the flush.
> 
> Below is a bpftrace test result on a 128-CPU system with 4 NUMA nodes,
> 16 threads doing sequential writes with fsync per write.
> 
> Function                    remove flush          with flush
>                             per-CPU pwqs     per-CPU      per-NUMA
> -------------------------  --------------   ----------   -----------
> xfs_fsync_flush_log          32-256 us      256-1000 us    32-256 us
> flush_workqueue_prep_pwqs      N/A           2-64 us        2-8 us
> 
> With flush_workqueue() removed, xfs_fsync_flush_log latency drops
> back to the per‑NUMA range (32‑256 us).

Ok, but how does the IO performance change? Does this result in a
measurable increase in RWF_OSYNC write throughput? (write + fsync ==
pwritev2(RWF_OSYNC)).

However, behavioural changes like this seem like an infrastructure
regression, and trying to modify callers to hide that regression is
a bandaid. This affects all UNBOUND workqueues, not just this one,
and we do not need per-cpu scheduling for workqueues with such low
work and concurrency counts - there can only be 4 pushs scheduled
and running concurrently at any time on this work queue. Hence we
don't even need NUMA queuing - a single global queue would work just
fine...

Hence it seems to me that this overhead problem should be fixed at
the WQ infra level, not worked around in the caller context...

> The removal relies on the assumption that flush_workqueue is just a
> performance optimization, not a correctness requirement. Without it,
> xlog_cil_force_seq already provides a reliable completion guarantee via
> xlog_wait(&cil->xc_commit_wait), which blocks until the target sequence
> has been committed. The caller will eventually observe the completion
> regardless of whether flush_workqueue was called. In addition, ordering
> is enforced by xlog_cil_order_write, which ensures all records are
> written in strict sequence order. Therefore, removing flush_workqueue
> does not weaken any ordering or completion semantics.

And wait latency goes up because now there is nothing to expedidite
the scheduling of the work we are waiting to complete.

i.e. you might see a drop in CPU time in flush heavy workloads by
removing it, but the trade off is an increase in wait time variance
and long tail latencies, especially under light load.

> If this analysis is correct, the change can be applied broadly to all
> sync force callers through xlog_cil_push_now(), as they all share the
> same completion and ordering guarantees provided by the existing CIL
> infrastructure. The per-CPU iteration overhead would be eliminated on
> every sync log force without affecting correctness.
> 
> But there are several concerns I'd like to confirm:
> 
> Is flush_workqueue just about performance, or does it hide any
> correctness dependency I'm missing?

It may well hide implicit correctness bugs.

> Without it, the "if (!ctx->commit_lsn) { goto restart; }" loop in
> xlog_cil_force_seq may be triggered more often. Is that acceptable,
> or is it a concern?

That's additional context switches and latency. i.e. CPU overhead
that we are trying to avoid...

> Are there any ordering guarantees provided by flush_workqueue that
> xc_push_lock + waitqueues don't already provide?

Removing the flush will change the order in which concurrent push
pipelines order in the journal. This could change the inherent order
of checkpoints in the journal, so there could be visible artifacts
during crash recovery compared to an flushing implementaiton. None
of that would be a correctness issue, but from an application POV it
would be like the concurrent fsync operations completing in a
different order across different kernel versions.

A lakc of flushing could also simply move the ordering latency
bottleneck to journal IO completion where checkpoints have to be
completed in ascending LSN order. Whether that causes a problem or
not is a complete unknown, but it could increase overall wait times
as waiting seqeunces always get woken in ascending order, and hence
everything will wait if a low sequeunce flush submission gets held
up because the kworker isn't scheduled immediately...

> I'd appreciate any thoughts on whether this change is safe.

Probably safe, but there is lots of potential for performance
regressions by removing it. Better would be to provide a low
overhead work queue implementation for callers that don't need
scale-out performance from their unbound workqueues....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
