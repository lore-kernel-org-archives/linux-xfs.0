Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487B0C7EE2C
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 04:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjHYEH4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 00:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbjHYEHe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 00:07:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1131FEB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 21:07:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F5E60A08
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 04:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0744C433C7;
        Fri, 25 Aug 2023 04:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692936450;
        bh=WCB+TdJzIiB8WmL4aASN5hj4LJMf14wvPMDhVqj6niQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d0qZz6cfz4iXwJ1rM/moGkDOD91TqydIEMt+soy5tlxu5m3aFXI54V/Q5YbmiArEu
         ArjYFfcBSrI2Y/A6+VIm6TNzjtSfM1EPSfo5D0AwOS4zUm7Ieds+8VvB0JObbxvdrn
         J8rEGK5YJgqlAQQZE0orFr+/9vojGSVRp7XLmj8i5UfVXRR9aOBhTd4cNkrQeG8OCn
         /kdNb8D5VxwRkjWY3486Ro1Si4yY4XcnYXTxUr6lNFNAWkBG+jcYe6eEsX3HMbbsaS
         dtR36XWGGS8DThUB7IdortJekj53IVC0HmwJMQyVwE4OOjsNVjxSvA9wk3+nQPJ/Ph
         Vl/7LTE3a7DHg==
Date:   Thu, 24 Aug 2023 21:07:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        ritesh.list@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 2/3] xfs: use per-mount cpumask to track nonempty percpu
 inodegc lists
Message-ID: <20230825040730.GG17912@frogsfrogsfrogs>
References: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
 <169291928586.219974.10915745531517859853.stgit@frogsfrogsfrogs>
 <ZOfyASUg/A+GWE37@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOfyASUg/A+GWE37@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 25, 2023 at 10:12:49AM +1000, Dave Chinner wrote:
> On Thu, Aug 24, 2023 at 04:21:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Directly track which CPUs have contributed to the inodegc percpu lists
> > instead of trusting the cpu online mask.  This eliminates a theoretical
> > problem where the inodegc flush functions might fail to flush a CPU's
> > inodes if that CPU happened to be dying at exactly the same time.  Most
> > likely nobody's noticed this because the CPU dead hook moves the percpu
> > inodegc list to another CPU and schedules that worker immediately.  But
> > it's quite possible that this is a subtle race leading to UAF if the
> > inodegc flush were part of an unmount.
> > 
> > Further benefits: This reduces the overhead of the inodegc flush code
> > slightly by allowing us to ignore CPUs that have empty lists.  Better
> > yet, it reduces our dependence on the cpu online masks, which have been
> > the cause of confusion and drama lately.
> > 
> > Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |   60 +++++++++++----------------------------------------
> >  fs/xfs/xfs_icache.h |    1 -
> >  fs/xfs/xfs_mount.h  |    6 +++--
> >  fs/xfs/xfs_super.c  |    4 +--
> >  4 files changed, 18 insertions(+), 53 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index e541f5c0bc25..7fd876e94ecb 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -443,7 +443,7 @@ xfs_inodegc_queue_all(
> >  	int			cpu;
> >  	bool			ret = false;
> >  
> > -	for_each_online_cpu(cpu) {
> > +	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
> >  		gc = per_cpu_ptr(mp->m_inodegc, cpu);
> >  		if (!llist_empty(&gc->list)) {
> >  			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
> > @@ -463,7 +463,7 @@ xfs_inodegc_wait_all(
> >  	int			error = 0;
> >  
> >  	flush_workqueue(mp->m_inodegc_wq);
> > -	for_each_online_cpu(cpu) {
> > +	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
> >  		struct xfs_inodegc	*gc;
> >  
> >  		gc = per_cpu_ptr(mp->m_inodegc, cpu);
> > @@ -1845,10 +1845,12 @@ xfs_inodegc_worker(
> >  						struct xfs_inodegc, work);
> >  	struct llist_node	*node = llist_del_all(&gc->list);
> >  	struct xfs_inode	*ip, *n;
> > +	struct xfs_mount	*mp = gc->mp;
> >  	unsigned int		nofs_flag;
> >  
> >  	ASSERT(gc->cpu == smp_processor_id());
> >  
> > +	cpumask_test_and_clear_cpu(gc->cpu, &mp->m_inodegc_cpumask);
> 
> Why does this need to be a test-and-clear operation? If it is set,
> we clear it. If it is not set, clearing it is a no-op. Hence we
> don't need to test whether the bit is set first. Also,
> cpumask_clear_cpu() uses clear_bit(), which is an atomic operation,
> so clearing the bit isn't going to race with any other updates.

Aha, I didn't realize that clear_bit is atomic.  Oh, I guess
atomic_bitops.txt mentions that an RMW operation is atomic if there's a
separate '__' version.  Subtle. :(

> As it is, we probably want acquire semantics for the gc structure
> here (see below), so I think this likely should be:
> 
> 	/*
> 	 * Clear the cpu mask bit and ensure that we have seen the
> 	 * latest update of the gc structure associated with this
> 	 * CPU. This matches with the release semantics used when
> 	 * setting the cpumask bit in xfs_inodegc_queue.
> 	 */
> 	cpumask_clear_cpu(gc->cpu, &mp->m_inodegc_cpumask);
> 	smp_mb__after_atomic();

<nod>

> >  	WRITE_ONCE(gc->items, 0);
> >  
> >  	if (!node)
> > @@ -1862,7 +1864,7 @@ xfs_inodegc_worker(
> >  	nofs_flag = memalloc_nofs_save();
> >  
> >  	ip = llist_entry(node, struct xfs_inode, i_gclist);
> > -	trace_xfs_inodegc_worker(ip->i_mount, READ_ONCE(gc->shrinker_hits));
> > +	trace_xfs_inodegc_worker(mp, READ_ONCE(gc->shrinker_hits));
> >  
> >  	WRITE_ONCE(gc->shrinker_hits, 0);
> >  	llist_for_each_entry_safe(ip, n, node, i_gclist) {
> > @@ -2057,6 +2059,7 @@ xfs_inodegc_queue(
> >  	struct xfs_inodegc	*gc;
> >  	int			items;
> >  	unsigned int		shrinker_hits;
> > +	unsigned int		cpu_nr;
> >  	unsigned long		queue_delay = 1;
> >  
> >  	trace_xfs_inode_set_need_inactive(ip);
> > @@ -2064,12 +2067,16 @@ xfs_inodegc_queue(
> >  	ip->i_flags |= XFS_NEED_INACTIVE;
> >  	spin_unlock(&ip->i_flags_lock);
> >  
> > -	gc = get_cpu_ptr(mp->m_inodegc);
> > +	cpu_nr = get_cpu();
> > +	gc = this_cpu_ptr(mp->m_inodegc);
> >  	llist_add(&ip->i_gclist, &gc->list);
> >  	items = READ_ONCE(gc->items);
> >  	WRITE_ONCE(gc->items, items + 1);
> >  	shrinker_hits = READ_ONCE(gc->shrinker_hits);
> >  
> > +	if (!cpumask_test_cpu(cpu_nr, &mp->m_inodegc_cpumask))
> > +		cpumask_test_and_set_cpu(cpu_nr, &mp->m_inodegc_cpumask);
> > +
> >  	/*
> >  	 * We queue the work while holding the current CPU so that the work
> >  	 * is scheduled to run on this CPU.
> 
> I think we need release/acquire memory ordering on this atomic bit
> set now. i.e. to guarantee that if the worker sees the cpumask bit
> set (with acquire semantics), it will always see the latest item
> added to the list. i.e.
> 
> 	/*
> 	 * Ensure the list add is always seen by anyone that
> 	 * find the cpumask bit set. This effectively gives
> 	 * the cpumask bit set operation release ordering semantics.
> 	 */
> 	smp_mb__before_atomic();
> 	if (!cpumask_test_cpu(cpu_nr, &mp->m_inodegc_cpumask))
> 		cpumask_test_and_set_cpu(cpu_nr, &mp->m_inodegc_cpumask);

<nod>

> Also, same comment about put_cpu() vs put_cpu_var() as the last patch.

<nod>

> Otherwise this seems sane.

Thanks!
--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
