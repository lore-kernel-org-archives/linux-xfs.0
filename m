Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393A4EE49A0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 00:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbjHYANU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 20:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjHYAM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 20:12:57 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A3A1BC8
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 17:12:53 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-68bed286169so386942b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 17:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692922373; x=1693527173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mzrXrogJitv6BDVLYlIt7ZKBxh9g6mnWAg1Uiv9yGnQ=;
        b=Fa8Gv/4YlHiLWkQhyboVoiLvjCELusG2gToebaaaYWzT2DT2bm2zH219jEtNbieaCh
         1LOnnn66c4E00QJqoRPYoJLPt4HlIq9ULk1HmV8XRaAAIuCwwPaOP1kR3MyvnIcB8jON
         q4osCknqz42OhiPuw6aisvsLfbBmashSmMBy/GlD6Dwg4hZ3fTa7K7OTmJmc6qawqbxR
         YGwZGgQf7UFvCeJHyek1cDLD5vbJyfU5fxCcAsgIAb8J5wo0fo5+JFHfmZkoD8hVyQzX
         pQBKPzwTWVlHZZP1SarASL+QYto5yArx0KGK/cLKy3Zs74lgYNAymhDY4z2GRaLBAFzS
         mzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692922373; x=1693527173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzrXrogJitv6BDVLYlIt7ZKBxh9g6mnWAg1Uiv9yGnQ=;
        b=lgM0+YOTRC1A45rN6yADoch6bYO3IWYXLkDPBCljTG9+MaHn+RSfVsAn34UOUFc4nb
         iu1XSgaJdgsWsqr4hfuc4++5o/MgBXgjktWIKG98gMDa1KrZr8M+u41pdaiH8L5WwuKC
         DLGWLGfIWtJ008qP6zxzsF4kBAxVJc0sr9/IAIZrZ15EarrI8FnmDEJcGCnDZbadPqXE
         eXe83YTjyH0JnBfuFKH9nYlMqmeLd/rVO4sT7UZarAwFhZfvtBhOJFen0GZ8RMyiDlHc
         eKDvbCR2rEiIWB6/v5fcgsdYYSFTHFoaSw6lCjR2CryAbPpXquVhhJ9w75RGS6fwdJgs
         RqRA==
X-Gm-Message-State: AOJu0Yx9HPW/Gk4lNitoCv7XSSeatxQL6YwKEVgJLHiF7Hbex0k7q46M
        g0p82olIjgqgjfa0rxjJGKJNGA==
X-Google-Smtp-Source: AGHT+IFeSRJUjnEf1ABs7Fx5BgYPjug2NKDOp7UsOC6sIg7l53b0VKxRqeftg/3k5cE+cT0EqserrQ==
X-Received: by 2002:a05:6a20:7353:b0:140:6d68:ce07 with SMTP id v19-20020a056a20735300b001406d68ce07mr21725776pzc.52.1692922372943;
        Thu, 24 Aug 2023 17:12:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id n3-20020a62e503000000b006877a2e6285sm292300pff.128.2023.08.24.17.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 17:12:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZKRV-0066cA-1K;
        Fri, 25 Aug 2023 10:12:49 +1000
Date:   Fri, 25 Aug 2023 10:12:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        ritesh.list@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 2/3] xfs: use per-mount cpumask to track nonempty percpu
 inodegc lists
Message-ID: <ZOfyASUg/A+GWE37@dread.disaster.area>
References: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
 <169291928586.219974.10915745531517859853.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169291928586.219974.10915745531517859853.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 04:21:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Directly track which CPUs have contributed to the inodegc percpu lists
> instead of trusting the cpu online mask.  This eliminates a theoretical
> problem where the inodegc flush functions might fail to flush a CPU's
> inodes if that CPU happened to be dying at exactly the same time.  Most
> likely nobody's noticed this because the CPU dead hook moves the percpu
> inodegc list to another CPU and schedules that worker immediately.  But
> it's quite possible that this is a subtle race leading to UAF if the
> inodegc flush were part of an unmount.
> 
> Further benefits: This reduces the overhead of the inodegc flush code
> slightly by allowing us to ignore CPUs that have empty lists.  Better
> yet, it reduces our dependence on the cpu online masks, which have been
> the cause of confusion and drama lately.
> 
> Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   60 +++++++++++----------------------------------------
>  fs/xfs/xfs_icache.h |    1 -
>  fs/xfs/xfs_mount.h  |    6 +++--
>  fs/xfs/xfs_super.c  |    4 +--
>  4 files changed, 18 insertions(+), 53 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e541f5c0bc25..7fd876e94ecb 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -443,7 +443,7 @@ xfs_inodegc_queue_all(
>  	int			cpu;
>  	bool			ret = false;
>  
> -	for_each_online_cpu(cpu) {
> +	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
>  		gc = per_cpu_ptr(mp->m_inodegc, cpu);
>  		if (!llist_empty(&gc->list)) {
>  			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
> @@ -463,7 +463,7 @@ xfs_inodegc_wait_all(
>  	int			error = 0;
>  
>  	flush_workqueue(mp->m_inodegc_wq);
> -	for_each_online_cpu(cpu) {
> +	for_each_cpu(cpu, &mp->m_inodegc_cpumask) {
>  		struct xfs_inodegc	*gc;
>  
>  		gc = per_cpu_ptr(mp->m_inodegc, cpu);
> @@ -1845,10 +1845,12 @@ xfs_inodegc_worker(
>  						struct xfs_inodegc, work);
>  	struct llist_node	*node = llist_del_all(&gc->list);
>  	struct xfs_inode	*ip, *n;
> +	struct xfs_mount	*mp = gc->mp;
>  	unsigned int		nofs_flag;
>  
>  	ASSERT(gc->cpu == smp_processor_id());
>  
> +	cpumask_test_and_clear_cpu(gc->cpu, &mp->m_inodegc_cpumask);

Why does this need to be a test-and-clear operation? If it is set,
we clear it. If it is not set, clearing it is a no-op. Hence we
don't need to test whether the bit is set first. Also,
cpumask_clear_cpu() uses clear_bit(), which is an atomic operation,
so clearing the bit isn't going to race with any other updates.

As it is, we probably want acquire semantics for the gc structure
here (see below), so I think this likely should be:

	/*
	 * Clear the cpu mask bit and ensure that we have seen the
	 * latest update of the gc structure associated with this
	 * CPU. This matches with the release semantics used when
	 * setting the cpumask bit in xfs_inodegc_queue.
	 */
	cpumask_clear_cpu(gc->cpu, &mp->m_inodegc_cpumask);
	smp_mb__after_atomic();

>  	WRITE_ONCE(gc->items, 0);
>  
>  	if (!node)
> @@ -1862,7 +1864,7 @@ xfs_inodegc_worker(
>  	nofs_flag = memalloc_nofs_save();
>  
>  	ip = llist_entry(node, struct xfs_inode, i_gclist);
> -	trace_xfs_inodegc_worker(ip->i_mount, READ_ONCE(gc->shrinker_hits));
> +	trace_xfs_inodegc_worker(mp, READ_ONCE(gc->shrinker_hits));
>  
>  	WRITE_ONCE(gc->shrinker_hits, 0);
>  	llist_for_each_entry_safe(ip, n, node, i_gclist) {
> @@ -2057,6 +2059,7 @@ xfs_inodegc_queue(
>  	struct xfs_inodegc	*gc;
>  	int			items;
>  	unsigned int		shrinker_hits;
> +	unsigned int		cpu_nr;
>  	unsigned long		queue_delay = 1;
>  
>  	trace_xfs_inode_set_need_inactive(ip);
> @@ -2064,12 +2067,16 @@ xfs_inodegc_queue(
>  	ip->i_flags |= XFS_NEED_INACTIVE;
>  	spin_unlock(&ip->i_flags_lock);
>  
> -	gc = get_cpu_ptr(mp->m_inodegc);
> +	cpu_nr = get_cpu();
> +	gc = this_cpu_ptr(mp->m_inodegc);
>  	llist_add(&ip->i_gclist, &gc->list);
>  	items = READ_ONCE(gc->items);
>  	WRITE_ONCE(gc->items, items + 1);
>  	shrinker_hits = READ_ONCE(gc->shrinker_hits);
>  
> +	if (!cpumask_test_cpu(cpu_nr, &mp->m_inodegc_cpumask))
> +		cpumask_test_and_set_cpu(cpu_nr, &mp->m_inodegc_cpumask);
> +
>  	/*
>  	 * We queue the work while holding the current CPU so that the work
>  	 * is scheduled to run on this CPU.

I think we need release/acquire memory ordering on this atomic bit
set now. i.e. to guarantee that if the worker sees the cpumask bit
set (with acquire semantics), it will always see the latest item
added to the list. i.e.

	/*
	 * Ensure the list add is always seen by anyone that
	 * find the cpumask bit set. This effectively gives
	 * the cpumask bit set operation release ordering semantics.
	 */
	smp_mb__before_atomic();
	if (!cpumask_test_cpu(cpu_nr, &mp->m_inodegc_cpumask))
		cpumask_test_and_set_cpu(cpu_nr, &mp->m_inodegc_cpumask);

Also, same comment about put_cpu() vs put_cpu_var() as the last patch.

Otherwise this seems sane.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
