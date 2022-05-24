Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC1FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 16:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiEXQyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 12:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiEXQyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 12:54:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF28B6D3B5
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 09:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AADE61411
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 16:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB31C34100;
        Tue, 24 May 2022 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653411291;
        bh=ZZNAKINehYd6dNmKwbmM811Vy/ZLSNuS7BMrfbaCWG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=acl0pnBu5sNksWYrvd/cnvmKPbrj43hLCnQiIVMSbNkAF1dcSksuYeWultGZWishu
         FOVD9hZKa1GziSh/6Q59cbqhEoL5ZkTV3cd8sA0sZMKznGyDen2+smFe7qW+6Hg+5V
         k8+1CssJ7c7YvsDBizz7s7k41t6PKtBHYEKPVNj63cltyHjApxK1W8ZjdjsTNMlJfg
         jVUB3sUId8ouGadEe2m4swfSfwBn8Q7/BceUuMWCzHmULuYu0j9qm0mAYx1mBr67/5
         iKlWB24fsoZQ6Pa7D/lJY8bdJDydm/KZKA1V2ROhENltxIEnwYBKeAlISCDGfusxhb
         smBTNRLg+Pf2g==
Date:   Tue, 24 May 2022 09:54:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chris@onthe.net.au
Subject: Re: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Message-ID: <Yo0N234hm98uULNP@magnolia>
References: <20220524063802.1938505-1-david@fromorbit.com>
 <20220524063802.1938505-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524063802.1938505-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 04:38:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently inodegc work can sit queued on the per-cpu queue until
> the workqueue is either flushed of the queue reaches a depth that
> triggers work queuing (and later throttling). This means that we
> could queue work that waits for a long time for some other event to
> trigger flushing.
> 
> Hence instead of just queueing work at a specific depth, use a
> delayed work that queues the work at a bound time. We can still
> schedule the work immediately at a given depth, but we no long need

Nit: "no longer need..."

> to worry about leaving a number of items on the list that won't get
> processed until external events prevail.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
>  fs/xfs/xfs_mount.h  |  2 +-
>  fs/xfs/xfs_super.c  |  2 +-
>  3 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 5269354b1b69..786702273621 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -440,7 +440,7 @@ xfs_inodegc_queue_all(
>  	for_each_online_cpu(cpu) {
>  		gc = per_cpu_ptr(mp->m_inodegc, cpu);
>  		if (!llist_empty(&gc->list))
> -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
>  	}
>  }
>  
> @@ -1841,8 +1841,8 @@ void
>  xfs_inodegc_worker(
>  	struct work_struct	*work)
>  {
> -	struct xfs_inodegc	*gc = container_of(work, struct xfs_inodegc,
> -							work);
> +	struct xfs_inodegc	*gc = container_of(to_delayed_work(work),
> +						struct xfs_inodegc, work);
>  	struct llist_node	*node = llist_del_all(&gc->list);
>  	struct xfs_inode	*ip, *n;
>  
> @@ -2014,6 +2014,7 @@ xfs_inodegc_queue(
>  	struct xfs_inodegc	*gc;
>  	int			items;
>  	unsigned int		shrinker_hits;
> +	unsigned long		queue_delay = 1;

A default delay of one clock tick, correct?

Just out of curiosity, how does this shake out wrt fstests that do a
thing and then measure free space?

I have a dim recollection of a bug that I found in one of the
preproduction iterations of inodegc back when I used delayed_work to
schedule the background gc.  If memory serves, calling mod_delayed_work
on a delayed_work object that is currently running does /not/ cause the
delayed_work object to be requeued, even if delay==0.

Aha, I found a description in my notes.  I've adapted them to the
current patchset, since in those days inodegc used a radix tree tag
and per-AG workers instead of a locklesslist and per-cpu workers.
If the following occurs:

Worker 1			Thread 2

xfs_inodegc_worker
<starts up>
node = llist_del_all()
<start processing inodes>
<block on something, yield>
				xfs_irele
				xfs_inode_mark_reclaimable
				llist_add
				mod_delayed_work()
				<exit>
<process the rest of nodelist>
return

Then at the end of this sequence, we'll end up with thread 2's inode
queued to the gc list but the delayed work is /not/ queued.  That inode
remains on the gc list (and unprocessed) until someone comes along to
push that CPU's gc list, whether it's a statfs, or an unmount, or
someone hitting ENOSPC and triggering blockgc.

I observed this bug while digging into online repair occasionally
stalling for a long time or erroring out during inode scans.  If you'll
recall, earlier inodegc iterations allowed iget to recycle inodes that
were queued for inactivation, but later iterations didn't, so it became
the responsibility of the online repair's inode scanner to push the
inodegc workers when iget found an inode that was queued for
inactivation.

(The current online repair inode scanner is smarter in the sense that it
will try inodegc_flush a few times before backing out to userspace, and
if it does, xfs_scrub will generally requeue the entire scrub
operation.)

--D

>  
>  	trace_xfs_inode_set_need_inactive(ip);
>  	spin_lock(&ip->i_flags_lock);
> @@ -2025,19 +2026,26 @@ xfs_inodegc_queue(
>  	items = READ_ONCE(gc->items);
>  	WRITE_ONCE(gc->items, items + 1);
>  	shrinker_hits = READ_ONCE(gc->shrinker_hits);
> -	put_cpu_ptr(gc);
>  
> -	if (!xfs_is_inodegc_enabled(mp))
> +	/*
> +	 * We queue the work while holding the current CPU so that the work
> +	 * is scheduled to run on this CPU.
> +	 */
> +	if (!xfs_is_inodegc_enabled(mp)) {
> +		put_cpu_ptr(gc);
>  		return;
> -
> -	if (xfs_inodegc_want_queue_work(ip, items)) {
> -		trace_xfs_inodegc_queue(mp, __return_address);
> -		queue_work(mp->m_inodegc_wq, &gc->work);
>  	}
>  
> +	if (xfs_inodegc_want_queue_work(ip, items))
> +		queue_delay = 0;
> +
> +	trace_xfs_inodegc_queue(mp, __return_address);
> +	mod_delayed_work(mp->m_inodegc_wq, &gc->work, queue_delay);
> +	put_cpu_ptr(gc);
> +
>  	if (xfs_inodegc_want_flush_work(ip, items, shrinker_hits)) {
>  		trace_xfs_inodegc_throttle(mp, __return_address);
> -		flush_work(&gc->work);
> +		flush_delayed_work(&gc->work);
>  	}
>  }
>  
> @@ -2054,7 +2062,7 @@ xfs_inodegc_cpu_dead(
>  	unsigned int		count = 0;
>  
>  	dead_gc = per_cpu_ptr(mp->m_inodegc, dead_cpu);
> -	cancel_work_sync(&dead_gc->work);
> +	cancel_delayed_work_sync(&dead_gc->work);
>  
>  	if (llist_empty(&dead_gc->list))
>  		return;
> @@ -2073,12 +2081,12 @@ xfs_inodegc_cpu_dead(
>  	llist_add_batch(first, last, &gc->list);
>  	count += READ_ONCE(gc->items);
>  	WRITE_ONCE(gc->items, count);
> -	put_cpu_ptr(gc);
>  
>  	if (xfs_is_inodegc_enabled(mp)) {
>  		trace_xfs_inodegc_queue(mp, __return_address);
> -		queue_work(mp->m_inodegc_wq, &gc->work);
> +		mod_delayed_work(mp->m_inodegc_wq, &gc->work, 0);
>  	}
> +	put_cpu_ptr(gc);
>  }
>  
>  /*
> @@ -2173,7 +2181,7 @@ xfs_inodegc_shrinker_scan(
>  			unsigned int	h = READ_ONCE(gc->shrinker_hits);
>  
>  			WRITE_ONCE(gc->shrinker_hits, h + 1);
> -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
>  			no_items = false;
>  		}
>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 8c42786e4942..377c5e59f6a0 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -61,7 +61,7 @@ struct xfs_error_cfg {
>   */
>  struct xfs_inodegc {
>  	struct llist_head	list;
> -	struct work_struct	work;
> +	struct delayed_work	work;
>  
>  	/* approximate count of inodes in the list */
>  	unsigned int		items;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 51ce127a0cc6..62f6b97355a2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1073,7 +1073,7 @@ xfs_inodegc_init_percpu(
>  		gc = per_cpu_ptr(mp->m_inodegc, cpu);
>  		init_llist_head(&gc->list);
>  		gc->items = 0;
> -		INIT_WORK(&gc->work, xfs_inodegc_worker);
> +		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
>  	}
>  	return 0;
>  }
> -- 
> 2.35.1
> 
