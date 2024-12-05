Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091372F56
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 07:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733382115; cv=none; b=Fn6KOsnZBcl2IvpdCQsfi+XyZTLLxjz6B8PxxvkGLtr6uXRbI3BumHxYKcQmFPf7eTBEFDewRZUKBBuysUcRzE4VlSf0oDxOGHSZzrRz/ZbmJalWk5uK7DpmTtMy9Q4IIZqDHWc11T+H7agNMPd0BclU3dkudKytmTvFzx5D5YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733382115; c=relaxed/simple;
	bh=8t0Z+TLjUBanxHrvMdIGJEXNCMQuCnluveyl15wszFQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKJ6hPmH1uRptYdkN5x/Ta6v7uD5wDjho2xj+8vhh/IVB8sMt59F2VFB2V7H05+/uTGQahwjsgpT/PP/+WqqKG4A0TfJpsjN+OQ//xxl/ZqP/V28jWcH9f3beOMtcT0sbZINfM6573Se2CTnzVL497X6H2EtMSKw8Z8O49nTR64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Y3lbx415nzPppj;
	Thu,  5 Dec 2024 14:58:53 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id CB677140134;
	Thu,  5 Dec 2024 15:01:43 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 5 Dec
 2024 15:01:43 +0800
Date: Thu, 5 Dec 2024 14:59:16 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>
CC: <djwong@kernel.org>, <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH] xfs: fix race condition in inodegc list and cpumask
 handling
Message-ID: <Z1FPRKXZrsAxsoZ5@localhost.localdomain>
References: <20241125015258.2652325-1-leo.lilong@huawei.com>
 <Z0TmLzSmLr78T8Im@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Z0TmLzSmLr78T8Im@dread.disaster.area>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Tue, Nov 26, 2024 at 08:03:43AM +1100, Dave Chinner wrote:

Sorry for reply so late, because I want to make the problem as clear
as possible, but there are still some doubts.

> On Mon, Nov 25, 2024 at 09:52:58AM +0800, Long Li wrote:
> > There is a race condition between inodegc queue and inodegc worker where
> > the cpumask bit may not be set when concurrent operations occur.
> 
> What problems does this cause? i.e. how do we identify systems
> hitting this issue?
> 

I haven't encountered any actual issues, but while reviewing 62334fab4762
("xfs: use per-mount cpumask to track nonempty percpu inodegc lists"), I
noticed there is a potential problem.

When the gc worker runs on a CPU other than the specified one due to
loadbalancing, it could race with xfs_inodegc_queue() processing the
same struct xfs_inodegc. If xfs_inodegc_queue() adds the last inode
to the gc list during this race, that inode might never be processed
and reclaimed due to cpumask not set. This maybe lead to memory leaks
after filesystem unmount, I'm unsure if there are other more serious
implications.

> > 
> > Current problematic sequence:
> > 
> >   CPU0                             CPU1
> >   --------------------             ---------------------
> >   xfs_inodegc_queue()              xfs_inodegc_worker()
> >                                      llist_del_all(&gc->list)
> >     llist_add(&ip->i_gclist, &gc->list)
> >     cpumask_test_and_set_cpu()
> >                                      cpumask_clear_cpu()
> >                   < cpumask not set >
> > 
> > Fix this by moving llist_del_all() after cpumask_clear_cpu() to ensure
> > proper ordering. This change ensures that when the worker thread clears
> > the cpumask, any concurrent queue operations will either properly set
> > the cpumask bit or have already emptied the list.
> > 
> > Also remove unnecessary smp_mb__{before/after}_atomic() barriers since
> > the llist_* operations already provide required ordering semantics. it
> > make the code cleaner.
> 
> IIRC, the barriers were for ordering the cpumask bitmap ops against
> llist operations. There are calls elsewhere to for_each_cpu() that
> then use llist_empty() checks (e.g xfs_inodegc_queue_all/wait_all),
> so on relaxed architectures (like alpha) I think we have to ensure
> the bitmask ops carried full ordering against the independent llist
> ops themselves. i.e. llist_empty() just uses READ_ONCE, so it only
> orders against other llist ops and won't guarantee any specific
> ordering against against cpumask modifications.
> 
> I could be remembering incorrectly, but I think that was the
> original reason for the barriers. Can you please confirm that the
> cpumask iteration/llist_empty checks do not need these bitmask
> barriers anymore? If that's ok, then the change looks fine.
> 

Even on architectures with relaxed memory ordering (like alpha), I noticed
that llist_add() already has full barrier semantics, so I think the 
smp_mb__before_atomic barrier in xfs_inodegc_queue() can be removed.

  llist_add()
    try_cmpxchg
      raw_try_cmpxchg
        arch_cmpxchg
  
  arch_cmpxchg of alpha in file arch/alpha/include/asm/cmpxchg.h
  
  #define arch_cmpxchg(ptr, o, n)                                         \
  ({                                                                      \
          __typeof__(*(ptr)) __ret;                                       \
          __typeof__(*(ptr)) _o_ = (o);                                   \
          __typeof__(*(ptr)) _n_ = (n);                                   \
          smp_mb();                                                       \
          __ret = (__typeof__(*(ptr))) ____cmpxchg((ptr),                 \
                  (unsigned long)_o_, (unsigned long)_n_, sizeof(*(ptr)));\
          smp_mb();                                                       \
	  ^^^^^^^
          __ret;                                                          \
  })

I'm wondering if we really need to "Ensure the list add is always seen
by xfs_inodegc_queue_all() who finds the cpumask bit set". It seems
harmless even if we don't see the list add completion - it can be
processed in the next round. xfs_inodegc_queue_all() doesn't guarantee
processing all inodes that are being or will be added to the gc llist
anyway.

If we do need that guarantee, should we add a barrier between reading
m_inodegc_cpumask and gc->list in xfs_inodegc_queue_all() to prevent 
load-load reordering?

Maybe I'm misunderstanding something.

Thanks,
Long Li
