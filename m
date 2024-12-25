Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594E3146000
	for <linux-xfs@vger.kernel.org>; Wed, 25 Dec 2024 12:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735130703; cv=none; b=g3D82yDz7oS5TgSZ7Ns2CWwkY/C1zEDdavUmcS18W8NonXJCtInWTjl8PVuFZNLG0Ji8vC+4MoXOx+LgVfVyCMDNyRq9e24NYxjb9FjtYhvB/+agBnlDrDkVAQbpzAisN9EJOK7Yxwm4jzp62x3x4QBwOSTIcL+ikAhgG6jvT60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735130703; c=relaxed/simple;
	bh=eBcQWH7JvkSVat9RbGeTSaPguT6hAblF+sc31njhLr8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOzJqSKR2SBMissyRPnUMoiDgykk2X8tCVCQGNphBAoMP9ahWC+cLZmDJDK7SjQRrVqj28tOBWkDtzvYLyobKiDY0fYlHS84EOtyi3swCgAvWsVP/fJ1wKwd7pEYuze9pVrH/oGXJX11idgOOqevDrVL/Zwlog1qdqP2l1TwV0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YJBGn3Kwdz1kwwX;
	Wed, 25 Dec 2024 20:42:09 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id F41621402DE;
	Wed, 25 Dec 2024 20:44:52 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 25 Dec
 2024 20:44:52 +0800
Date: Wed, 25 Dec 2024 20:41:18 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>
CC: <djwong@kernel.org>, <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH] xfs: fix race condition in inodegc list and cpumask
 handling
Message-ID: <Z2v9bgo7cGXFnR8w@localhost.localdomain>
References: <20241125015258.2652325-1-leo.lilong@huawei.com>
 <Z0TmLzSmLr78T8Im@dread.disaster.area>
 <Z1FPRKXZrsAxsoZ5@localhost.localdomain>
 <Z1fdw1odL7B8kIj-@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Z1fdw1odL7B8kIj-@dread.disaster.area>
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Tue, Dec 10, 2024 at 05:20:51PM +1100, Dave Chinner wrote:
> On Thu, Dec 05, 2024 at 02:59:16PM +0800, Long Li wrote:
> > On Tue, Nov 26, 2024 at 08:03:43AM +1100, Dave Chinner wrote:
> > 
> > Sorry for reply so late, because I want to make the problem as clear
> > as possible, but there are still some doubts.
> > 
> > > On Mon, Nov 25, 2024 at 09:52:58AM +0800, Long Li wrote:
> > > > There is a race condition between inodegc queue and inodegc worker where
> > > > the cpumask bit may not be set when concurrent operations occur.
> > > 
> > > What problems does this cause? i.e. how do we identify systems
> > > hitting this issue?
> > > 
> > 
> > I haven't encountered any actual issues, but while reviewing 62334fab4762
> > ("xfs: use per-mount cpumask to track nonempty percpu inodegc lists"), I
> > noticed there is a potential problem.
> > 
> > When the gc worker runs on a CPU other than the specified one due to
> > loadbalancing,
> 
> How? inodegc is using get_cpu() to pin the task to the cpu while it
> processes the queue and then queues the work to be run on that CPU.
> The per-PCU inodegc queue is then processed using a single CPU
> affine worker thread. The whole point of this setup is that
> scheduler load balancing, etc, cannot disturb the cpu affinity of
> the queues and the worker threads that service them.
> 
> How does load balancing break explicit CPU affine kernel task
> scheduling?

Sorry, I misunderstood earlier. The load balancing mechanisms cannot
interfere with the CPU affinity of the queues. The inodegc workqueue
is not of WQ_UNBOUND type, so work items typically execute on their
designated CPUs.

However, in CPU hotplug scenarios, the CPU offline process will unbind
workers, causing work items to execute on other CPUs. If we queue an
inode on a CPU that's about to go offline after workqueue_offline_cpu()
but before the CPU is actually marked offline, the following concurrent
sequence might occur (though I haven't been able to reproduce this scenario
in practice).

From another perspective, with kernel preemption enabled, I think it's
possible for xfs_inodegc_queue() and xfs_inodegc_worker() to race on the
same CPU and process the same gc, potentially leading to the sequence
mentioned below, since kernel preemption is enabled in the xfs_inodegc_worker
context.

> 
> > it could race with xfs_inodegc_queue() processing the
> > same struct xfs_inodegc. If xfs_inodegc_queue() adds the last inode
> > to the gc list during this race, that inode might never be processed
> > and reclaimed due to cpumask not set. This maybe lead to memory leaks
> > after filesystem unmount, I'm unsure if there are other more serious
> > implications.
> 
> xfs_inodegc_stop() should handle this all just fine. It removes
> the enabled flag, then moves into a loop that should catch list adds
> that were in progress when the enabled flag was cleared.
> 

I don't think xfs_inodegc_stop() adequately handles this scenario. 
xfs_inodegc_queue_all() only processes the CPUs that are set in
mp->m_inodegc_cpumask. If a CPU's corresponding bit is not set in
the cpumask, then any inodes waiting for gc on that CPU won't have
a chance to be processed.

Thanks,
Long Li

> > > > Current problematic sequence:
> > > > 
> > > >   CPU0                             CPU1
> > > >   --------------------             ---------------------
> > > >   xfs_inodegc_queue()              xfs_inodegc_worker()
> > > >                                      llist_del_all(&gc->list)
> > > >     llist_add(&ip->i_gclist, &gc->list)
> > > >     cpumask_test_and_set_cpu()
> > > >                                      cpumask_clear_cpu()
> > > >                   < cpumask not set >
> > > > 
> > > > Fix this by moving llist_del_all() after cpumask_clear_cpu() to ensure
> > > > proper ordering. This change ensures that when the worker thread clears
> > > > the cpumask, any concurrent queue operations will either properly set
> > > > the cpumask bit or have already emptied the list.
> > > > 
> > > > Also remove unnecessary smp_mb__{before/after}_atomic() barriers since
> > > > the llist_* operations already provide required ordering semantics. it
> > > > make the code cleaner.
> > > 
> > > IIRC, the barriers were for ordering the cpumask bitmap ops against
> > > llist operations. There are calls elsewhere to for_each_cpu() that
> > > then use llist_empty() checks (e.g xfs_inodegc_queue_all/wait_all),
> > > so on relaxed architectures (like alpha) I think we have to ensure
> > > the bitmask ops carried full ordering against the independent llist
> > > ops themselves. i.e. llist_empty() just uses READ_ONCE, so it only
> > > orders against other llist ops and won't guarantee any specific
> > > ordering against against cpumask modifications.
> > > 
> > > I could be remembering incorrectly, but I think that was the
> > > original reason for the barriers. Can you please confirm that the
> > > cpumask iteration/llist_empty checks do not need these bitmask
> > > barriers anymore? If that's ok, then the change looks fine.
> > > 
> > 
> > Even on architectures with relaxed memory ordering (like alpha), I noticed
> > that llist_add() already has full barrier semantics, so I think the 
> > smp_mb__before_atomic barrier in xfs_inodegc_queue() can be removed.
> 
> Ok. Seems reasonable to remove it if everything uses full memory
> barriers for the llist_add() operation.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
