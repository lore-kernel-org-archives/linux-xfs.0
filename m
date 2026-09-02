Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF8A370ACD;
	Wed,  2 Sep 2026 07:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788334565; cv=none; b=BD9MTLhRJu4uwI6I35Dq305aCusVY7cmdkuccwxL278gxwixWPCIHjlSBRrCVSHwhUxmiIqmWZHrVGdtN8fMOhk8vYXp4d9SYZDeqy7CJZHofhcTMYEoNB4Vn4+KbFni1I0tY24HRseAsC275l85VE+5DJzrt9uFl+gaW1wgf7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788334565; c=relaxed/simple;
	bh=K2Pdj40MMClLlgpd7cUZ3Gmz6Ox+gIzS41fDorJtPdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ja1+ZKH4CQkG7GphFdZye2W4HJ36H0hrGmB9rJMZdSjuH/1xfsXjQgHQIbwQCwQEgZvnp3l+7mAOt7+jMbv6hmFs6sMPPG8Tszp7WNRtPh8AZ1EYbmzuSWJakCSAos9fU3LQpylQp688OIr1tW9QOzeNtw+8c9WPwrCnyWjtN/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BD86168BEB; Wed,  2 Sep 2026 09:35:56 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:35:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Ran Hongyun <ranhongyun1@huawei.com>, catherine.hoang@oracle.com,
	chandan.babu@oracle.com, djwong@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
	Wangyang Guo <wangyang.guo@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: Re: [QUESTION] xfs: Can we remove flush_workqueue from
 xlog_cil_push_now?
Message-ID: <20260902073556.GA27223@lst.de>
References: <20260827033654.1172495-1-ranhongyun1@huawei.com> <apSnC9p0X04cKxDj@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apSnC9p0X04cKxDj@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 31, 2026 at 07:56:27AM +1000, Dave Chinner wrote:
> > nr_cpus pool_workqueue entries, instead of per-NUMA nodes. On large SMP
> > systems (e.g. 128 CPUs, 4 NUMA nodes), this adds significant overhead.
> > Even after 85f0d8e39aff ("workqueue: Reduce expensive locks for unbound
> > workqueue") reduced lock cost, the per-CPU iteration remains costly.
> > This seems contrary to the original performance intent of the flush.

Adding the authors/reviwers and maintainers relevant to this commit and
Chuck as he has been looking into different unbound workqueue overhead
lately.

> > 
> > Below is a bpftrace test result on a 128-CPU system with 4 NUMA nodes,
> > 16 threads doing sequential writes with fsync per write.
> > 
> > Function                    remove flush          with flush
> >                             per-CPU pwqs     per-CPU      per-NUMA
> > -------------------------  --------------   ----------   -----------
> > xfs_fsync_flush_log          32-256 us      256-1000 us    32-256 us
> > flush_workqueue_prep_pwqs      N/A           2-64 us        2-8 us
> > 
> > With flush_workqueue() removed, xfs_fsync_flush_log latency drops
> > back to the per‑NUMA range (32‑256 us).
> 
> Ok, but how does the IO performance change? Does this result in a
> measurable increase in RWF_OSYNC write throughput? (write + fsync ==
> pwritev2(RWF_OSYNC)).
> 
> However, behavioural changes like this seem like an infrastructure
> regression, and trying to modify callers to hide that regression is
> a bandaid. This affects all UNBOUND workqueues, not just this one,
> and we do not need per-cpu scheduling for workqueues with such low
> work and concurrency counts - there can only be 4 pushs scheduled
> and running concurrently at any time on this work queue. Hence we
> don't even need NUMA queuing - a single global queue would work just
> fine...

Yeah, a lot of the recent workqueue changes had a lot of adverse effects.
We really need to come up with a way to queue work to task context (or a
different task context) that doesn't require reverse engineering "smart"
behavior in the backend.  This has become a never ending whack-a-mole
unfortunately.

Not sure what we can do here, but a simply "just queue things up on a
fixed queue" interface would be really helpful.  Even better with just a
double or even singly linked list as overhead, as the work_struct is
way to big due to the function pointer not even needed in most cases
as typically every item in the queue uses the same one.

[leaving the rest of the context in place for the new readers]


> Hence it seems to me that this overhead problem should be fixed at
> the WQ infra level, not worked around in the caller context...
> 
> > The removal relies on the assumption that flush_workqueue is just a
> > performance optimization, not a correctness requirement. Without it,
> > xlog_cil_force_seq already provides a reliable completion guarantee via
> > xlog_wait(&cil->xc_commit_wait), which blocks until the target sequence
> > has been committed. The caller will eventually observe the completion
> > regardless of whether flush_workqueue was called. In addition, ordering
> > is enforced by xlog_cil_order_write, which ensures all records are
> > written in strict sequence order. Therefore, removing flush_workqueue
> > does not weaken any ordering or completion semantics.
> 
> And wait latency goes up because now there is nothing to expedidite
> the scheduling of the work we are waiting to complete.
> 
> i.e. you might see a drop in CPU time in flush heavy workloads by
> removing it, but the trade off is an increase in wait time variance
> and long tail latencies, especially under light load.
> 
> > If this analysis is correct, the change can be applied broadly to all
> > sync force callers through xlog_cil_push_now(), as they all share the
> > same completion and ordering guarantees provided by the existing CIL
> > infrastructure. The per-CPU iteration overhead would be eliminated on
> > every sync log force without affecting correctness.
> > 
> > But there are several concerns I'd like to confirm:
> > 
> > Is flush_workqueue just about performance, or does it hide any
> > correctness dependency I'm missing?
> 
> It may well hide implicit correctness bugs.
> 
> > Without it, the "if (!ctx->commit_lsn) { goto restart; }" loop in
> > xlog_cil_force_seq may be triggered more often. Is that acceptable,
> > or is it a concern?
> 
> That's additional context switches and latency. i.e. CPU overhead
> that we are trying to avoid...
> 
> > Are there any ordering guarantees provided by flush_workqueue that
> > xc_push_lock + waitqueues don't already provide?
> 
> Removing the flush will change the order in which concurrent push
> pipelines order in the journal. This could change the inherent order
> of checkpoints in the journal, so there could be visible artifacts
> during crash recovery compared to an flushing implementaiton. None
> of that would be a correctness issue, but from an application POV it
> would be like the concurrent fsync operations completing in a
> different order across different kernel versions.
> 
> A lakc of flushing could also simply move the ordering latency
> bottleneck to journal IO completion where checkpoints have to be
> completed in ascending LSN order. Whether that causes a problem or
> not is a complete unknown, but it could increase overall wait times
> as waiting seqeunces always get woken in ascending order, and hence
> everything will wait if a low sequeunce flush submission gets held
> up because the kworker isn't scheduled immediately...
> 
> > I'd appreciate any thoughts on whether this change is safe.
> 
> Probably safe, but there is lots of potential for performance
> regressions by removing it. Better would be to provide a low
> overhead work queue implementation for callers that don't need
> scale-out performance from their unbound workqueues....
> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
---end quoted text---
