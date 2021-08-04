Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A1EC4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 16:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14E0D60FC4
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 16:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhHDQTc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 12:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229731AbhHDQTb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 12:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A67D760F94;
        Wed,  4 Aug 2021 16:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628093958;
        bh=bSkvHE4goYtABnjDIdlRxQ9KSCvrkwNYqf8peV5DqAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OM4Us3dogCnWRX6/vSM+P50zn23lLJuH82SdW578qr/jkM26bY8csgrBZOfqk0LKi
         ZMillqTHBflA9Mb4wpdOzmOw9YUy+97nepPcNMmTp1LoNxiGixjaRHnke7BKk890nK
         FdM5hA4n50l1UqjVR3wZ1ECpNlJ2UH898Kw8Tfg1iE+iTcxgR7kwbnXiA3ohQ2vw9U
         4Qge3j7gbxAoOFpB/em+iyyJZz7I2h6fT2fjk6TDG6hjU6AxbFqd1jRmiskJ1HWy/3
         +L+hvSCItJGUoWOt58+TH8T5qF/wtOYtI79j8GMbmRmrm+/ZDqNwAeXYAPT27zrJH4
         dDhBHS0IiolXQ==
Date:   Wed, 4 Aug 2021 09:19:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH, post-03/20 1/1] xfs: hook up inodegc to CPU dead
 notification
Message-ID: <20210804161918.GU3601443@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
 <20210804115225.GP2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804115225.GP2757197@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 09:52:25PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> So we don't leave queued inodes on a CPU we won't ever flush.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_icache.h |  1 +
>  fs/xfs/xfs_super.c  |  2 +-
>  3 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index f772f2a67a8b..9e2c95903c68 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1966,6 +1966,42 @@ xfs_inodegc_start(
>  	}
>  }
>  
> +/*
> + * Fold the dead CPU inodegc queue into the current CPUs queue.
> + */
> +void
> +xfs_inodegc_cpu_dead(
> +	struct xfs_mount	*mp,
> +	int			dead_cpu)

unsigned int, since that's the caller's type.

> +{
> +	struct xfs_inodegc	*dead_gc, *gc;
> +	struct llist_node	*first, *last;
> +	int			count = 0;
> +
> +	dead_gc = per_cpu_ptr(mp->m_inodegc, dead_cpu);
> +	cancel_work_sync(&dead_gc->work);
> +
> +	if (llist_empty(&dead_gc->list))
> +		return;
> +
> +	first = dead_gc->list.first;
> +	last = first;
> +	while (last->next) {
> +		last = last->next;
> +		count++;
> +	}
> +	dead_gc->list.first = NULL;
> +	dead_gc->items = 0;
> +
> +	/* Add pending work to current CPU */
> +	gc = get_cpu_ptr(mp->m_inodegc);
> +	llist_add_batch(first, last, &gc->list);
> +	count += READ_ONCE(gc->items);
> +	WRITE_ONCE(gc->items, count);

I was wondering about the READ/WRITE_ONCE pattern for gc->items: it's
meant to be an accurate count of the list items, right?  But there's no
hard synchronization (e.g. spinlock) around them, which means that the
only CPU that can access that variable at all is the one that the percpu
structure belongs to, right?  And I think that's ok here, because the
only accessors are _queue() and _worker(), which both are supposed to
run on the same CPU since they're percpu lists, right?

In which case: why can't we just say count = dead_gc->items;?  @dead_cpu
is being offlined, which implies that nothing will get scheduled on it,
right?

> +	put_cpu_ptr(gc);
> +	queue_work(mp->m_inodegc_wq, &gc->work);

Should this be thresholded like we do for _inodegc_queue?

In the old days I would have imagined that cpu offlining should be rare
enough <cough> that it probably doesn't make any real difference.  OTOH
my cloudic colleague reminds me that they aggressively offline cpus to
reduce licensing cost(!).

--D

> +}
> +
>  #ifdef CONFIG_XFS_RT
>  static inline bool
>  xfs_inodegc_want_queue_rt_file(
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index bdf2a8d3fdd5..853d5bfc0cfb 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -79,5 +79,6 @@ void xfs_inodegc_worker(struct work_struct *work);
>  void xfs_inodegc_flush(struct xfs_mount *mp);
>  void xfs_inodegc_stop(struct xfs_mount *mp);
>  void xfs_inodegc_start(struct xfs_mount *mp);
> +void xfs_inodegc_cpu_dead(struct xfs_mount *mp, int cpu);
>  
>  #endif
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c251679e8514..f579ec49eb7a 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2187,7 +2187,7 @@ xfs_cpu_dead(
>  	spin_lock(&xfs_mount_list_lock);
>  	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
>  		spin_unlock(&xfs_mount_list_lock);
> -		/* xfs_subsys_dead(mp, cpu); */
> +		xfs_inodegc_cpu_dead(mp, cpu);
>  		spin_lock(&xfs_mount_list_lock);
>  	}
>  	spin_unlock(&xfs_mount_list_lock);
