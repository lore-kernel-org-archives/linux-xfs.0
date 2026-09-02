Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40194A64F3;
	Wed,  2 Sep 2026 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367855; cv=none; b=CfBzYJxkXHihtTw8+OrjFtgWN8Bvb3ZmzGMmmYZ7IOIs8DroezHbN2X0ks/x3zrbdP8AaudSTOJhVD8eviG+nsD5x4TrOdtkmxyFREUZW1ntMeZB5LFKG+bcFI6FUbnMHZ1hHpilIiL+XCrytWBythgERw4iweXo48I6s7+zTZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367855; c=relaxed/simple;
	bh=VDERqC/8E1fr5wLOAz/MQmcomAlN476K9ODA2RkWYnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMl/xlg2EwRD/bS4qu6Q769JU64kdS10RDi0ERDlFN7v0NrlvyLke7Vly3qmvEgy4gHR5byJX6bD+Ep7BMZ6nY6PY6W80L56Wzh+joRpitCGNwIUlnbwRlvbOIg1U0hbft48+Lpzj8dcqsDIOSBbDNbgqBdZhR4ZDfSR6v3aATI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uu8Of3nv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uu8Of3nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F881F000E9;
	Wed,  2 Sep 2026 16:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788367853;
	bh=dk1n0Erkc0W7OsAdxs9vZFLbW6YpiKCTSDoFkUjUt4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uu8Of3nv5/EhKJvFp+Nf+C/I0KTX3sKpymAjpunKGLpoQryDZak+20DW7G9VqX4u1
	 UdvLyLLJewORRON1T8BBTbjLMBYxNoJMjkii57vZkYgpHxyOrMXjtp0pKdLnDIq4s4
	 6YntJPZYs9YDn4JxKyhXjQfNRkt2Yl9m1q+Q29Bjln0cSOW4HQfRXdytj1Y55ZdWP7
	 5S5mI6nzIVSPRXBP8/LCv9n/ruW8TgIsct9Qap0YXdmA5vkBKHzxA6NYm+4y45a523
	 qYH9FqTdAFq1kXW1Ax9pjSfyQ6RfFChSSqWeHzGw3nrPBSd4bAso8mE471RRsABLAq
	 V17/i/vrmB/zw==
Date: Wed, 2 Sep 2026 06:50:52 -1000
From: Tejun Heo <tj@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dgc@kernel.org>,
	Ran Hongyun <ranhongyun1@huawei.com>, catherine.hoang@oracle.com,
	chandan.babu@oracle.com, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	yangerkun <yangerkun@huawei.com>, yi.zhang@huawei.com,
	Wangyang Guo <wangyang.guo@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [QUESTION] xfs: Can we remove flush_workqueue from
 xlog_cil_push_now?
Message-ID: <aphT7DIGHK1Og0jr@slm.duckdns.org>
References: <20260827033654.1172495-1-ranhongyun1@huawei.com>
 <apSnC9p0X04cKxDj@dread>
 <20260902073556.GA27223@lst.de>
 <21557715-124e-40dc-a470-82904374fc44@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21557715-124e-40dc-a470-82904374fc44@app.fastmail.com>

Hello,

On Wed, Sep 02, 2026 at 10:23:14AM -0400, Chuck Lever wrote:
> 
> On Wed, Sep 02, 2026 at 09:35:56AM +0200, Christoph Hellwig wrote:
> > On Mon, Aug 31, 2026 at 07:56:27AM +1000, Dave Chinner wrote:
> > > However, behavioural changes like this seem like an infrastructure
> > > regression, and trying to modify callers to hide that regression is
> > > a bandaid. This affects all UNBOUND workqueues, not just this one,
> > > and we do not need per-cpu scheduling for workqueues with such low
> > > work and concurrency counts - there can only be 4 pushs scheduled
> > > and running concurrently at any time on this work queue. Hence we
> > > don't even need NUMA queuing - a single global queue would work just
> > > fine...
> >
> > Yeah, a lot of the recent workqueue changes had a lot of adverse effects.
> > We really need to come up with a way to queue work to task context (or a
> > different task context) that doesn't require reverse engineering "smart"
> > behavior in the backend.  This has become a never ending whack-a-mole
> > unfortunately.
> 
> Agreed.

Well, the changes aren't gratuituous. They're mostly driven by the
increasing number of cpus in systems. Hardware has been scaling pretty fast
and workqueue needs to keep up. Sure, there may be things that could have
gone smoother but you'd need to solve the same problems no matter what.

> So, I've been chasing the other end of this trade-off. On the NFS client,
> rpciod, nfsiod, and xprtiod see sustained completion traffic from many
> CPUs, and with the default WQ_AFFN_CACHE_SHARD scope they lose a large
> fraction of their cycles to the pool lock on enqueue and dequeue. The
> fix there is a finer affinity scope (WQ_AFFN_SMT), so more pools and
> fewer CPUs per lock:
> 
>   https://lore.kernel.org/linux-nfs/20260831-performance-v1-0-8d9fd9b67f96@kernel.org/

And this was worse before because we had a single pool per node for all
unbound workqueues. You're using exactly the new feature that's made
available to solve scalability problems.

> That is the converse of Ran's problem. flush_workqueue_prep_pwqs()
> walks every pwq and takes the pool lock once per pool change along the
> way, so a finer scope makes each flush take more locks, and a coarser
> scope makes the producers contend more. The pwq walk itself is
> per-CPU at every scope, which is the part no scope setting removes.
> 
> For Ran's immediate purpose, patch 5/8 of that series may be useful:
> 
>   https://lore.kernel.org/linux-nfs/20260831-performance-v1-5-8d9fd9b67f96@kernel.org/
> 
> It exports alloc_workqueue_attrs(), apply_workqueue_attrs(), and
> free_workqueue_attrs(), so a module can set affn_scope on its own
> workqueue after alloc_workqueue().
> 
> With that, xfs_cil could set WQ_AFFN_SYSTEM on xc_push_wq and get the
> single global pool Dave describes, without touching the boot-time
> default or relying on WQ_SYSFS, which XFS_WQFLAGS() adds only in
> DEBUG builds. That would let Ran measure the flush cost against a
> one-pool walk directly rather than through the per-NUMA proxy in the
> table.

Try http://lkml.kernel.org/r/20260901210929.3092513-1-tj@kernel.org first?

Thanks.

-- 
tejun
