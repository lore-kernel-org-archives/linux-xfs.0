Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D70372
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 07:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719906549; cv=none; b=FeimSjM2eAchuqr5BVDe0sG9eOstFXxahxUWpHqdv6/r4209HPAo8LoQdoCgxwIUudy8gi+/M0WPlCBNipodjceg9jv/qiVk2UEHaF1abSGlGCk7BdKzEC4f0rQM8VK4LXVOXqRLGtlEeRZpop6ZV4dzzsmVO9RAU0tSa0cbLOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719906549; c=relaxed/simple;
	bh=qBPWd1AnEa/9hxw1AukoIVsnR7PMALxEPGdATAOlDgw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMpLIDoNCTlrkthayxMtbuSkJENbaIEi3VtHbdapOxOUtfT0EBK+7hBNhQnjubMVyOvjD34oibKc4QzLWl9keohl9+S1GsLagvS5wyFwFcvcwKCnueezBkG11Xu7yeNCcjcAUBVlSvo6YW2KUQGEfFUPaWq5l4SPAcjR4p1+lHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WCw1S4g0QzQjxl;
	Tue,  2 Jul 2024 15:45:16 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 8ACAB18007E;
	Tue,  2 Jul 2024 15:49:03 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 2 Jul
 2024 15:49:03 +0800
Date: Tue, 2 Jul 2024 16:00:21 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>
CC: <willy@infradead.org>, <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 07/12] xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS
Message-ID: <20240702080021.GA794461@ceph-admin>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-8-david@fromorbit.com>
 <20240622094411.GA830005@ceph-admin>
 <ZoOWPj2ICDIjCA80@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZoOWPj2ICDIjCA80@dread.disaster.area>
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Tue, Jul 02, 2024 at 03:55:10PM +1000, Dave Chinner wrote:
> On Sat, Jun 22, 2024 at 05:44:11PM +0800, Long Li wrote:
> > On Tue, Jan 16, 2024 at 09:59:45AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > In the past we've had problems with lockdep false positives stemming
> > > from inode locking occurring in memory reclaim contexts (e.g. from
> > > superblock shrinkers). Lockdep doesn't know that inodes access from
> > > above memory reclaim cannot be accessed from below memory reclaim
> > > (and vice versa) but there has never been a good solution to solving
> > > this problem with lockdep annotations.
> > > 
> > > This situation isn't unique to inode locks - buffers are also locked
> > > above and below memory reclaim, and we have to maintain lock
> > > ordering for them - and against inodes - appropriately. IOWs, the
> > > same code paths and locks are taken both above and below memory
> > > reclaim and so we always need to make sure the lock orders are
> > > consistent. We are spared the lockdep problems this might cause
> > > by the fact that semaphores and bit locks aren't covered by lockdep.
> > > 
> > > In general, this sort of lockdep false positive detection is cause
> > > by code that runs GFP_KERNEL memory allocation with an actively
> > > referenced inode locked. When it is run from a transaction, memory
> > > allocation is automatically GFP_NOFS, so we don't have reclaim
> > > recursion issues. So in the places where we do memory allocation
> > > with inodes locked outside of a transaction, we have explicitly set
> > > them to use GFP_NOFS allocations to prevent lockdep false positives
> > > from being reported if the allocation dips into direct memory
> > > reclaim.
> > > 
> > > More recently, __GFP_NOLOCKDEP was added to the memory allocation
> > > flags to tell lockdep not to track that particular allocation for
> > > the purposes of reclaim recursion detection. This is a much better
> > > way of preventing false positives - it allows us to use GFP_KERNEL
> > > context outside of transactions, and allows direct memory reclaim to
> > > proceed normally without throwing out false positive deadlock
> > > warnings.
> > 
> > Hi Dave,
> > 
> > I recently encountered the following AA deadlock lockdep warning
> > in Linux-6.9.0. This version of the kernel has currently merged
> > your patch set. I believe this is a lockdep false positive warning.
> 
> Yes, it is.
> 
> > The xfs_dir_lookup_args() function is in a non-transactional context
> > and allocates memory with the __GFP_NOLOCKDEP flag in xfs_buf_alloc_pages().
> > Even though __GFP_NOLOCKDEP can tell lockdep not to track that particular
> > allocation for the purposes of reclaim recursion detection, it cannot
> > completely replace __GFP_NOFS.
> 
> We are not trying to replace GFP_NOFS with __GFP_NOLOCKDEP. What we
> are trying to do is annotate the allocation sites where lockdep
> false positives will occur. That way if we get a lockdep report from
> a location that uses __GFP_NOLOCKDEP, we know that it is either a
> false positive or there is some nested allocation that did not honor
> __GFP_NOLOCKDEP.
> 
> We've already fixed a bunch of nested allocations (e.g. kasan,
> kmemleak, etc) to propagate the __GFP_NOLOCKDEP flag so they don't
> generate false positives, either. So the amount of noise has already
> been reduced.
> 
> > Getting trapped in direct memory reclaim
> > maybe trigger the AA deadlock warning as shown below.
> 
> No, it can't. xfs_dir_lookup() can only lock referenced inodes.
> xfs_reclaim_inodes_nr() can only lock unreferenced inodes. It is not
> possible for the same inode to be both referenced and unreferenced
> at the same time, therefore memory reclaim cannot self deadlock
> through this path.

Yes, I know. An AA deadlock couldn't happen in this situation because
it's not the same inode, so it's just a lockdep false positive warning.

> 
> I expected to see some situations like this when getting rid of
> GFP_NOFS (because now memory reclaim runs in places it never used
> to). Once I have an idea of the sorts of false positives that are
> still being tripped over, I can formulate a plan to eradicate them,
> too.

Ok, memory reclaim may run in those places where GFP_NOFS is removed.
Some new lockdep false positive warnings may appear. I hope this report
can help you eradicate them in the future.

Thanks for your reply. :)

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
