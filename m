Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E2A3D16EA
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 13:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774875630; cv=none; b=Cv82M4/9/9BvzjGLFT147qArOkM4d7chbGjqDblev8Hli7SY0XmLfyRvJ5b36CChH54NOEhQA9FSkaKw49T3Phd4qqWor57MDuruWTR7fApL+R1TsrDv3gyndr6UOMlOHGrO/dR32iVosIxaxII/SI+zKyYD+gnYoKARLz0mKuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774875630; c=relaxed/simple;
	bh=Yb0lxeJltzXtteU3S0vr3Xf3B+nKl9SvJnuwhyHGCTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gwSUS4XbQgaNg/S0c1exzcvCGQihtC3+U3p/0VgBkK7iqT24GQ0DjsLDYBup6NvK+tRkdX+/wI2dHrONqgOlmQIGr7dyF/WLnFnXNFbDA7IRuhvlI5GS8uTbLv29rrRCYfbuglNc4mh8XGKrZ1jG07HujqLHZfIJOWzT4ICyDvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGsCPXq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGsCPXq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B873AC4CEF7;
	Mon, 30 Mar 2026 13:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774875629;
	bh=Yb0lxeJltzXtteU3S0vr3Xf3B+nKl9SvJnuwhyHGCTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cGsCPXq8LrdKISOh51XtdTyLZBHDV/RTkjLBIWaHjVSUpXOjgEWhmCkln6pmrWDAW
	 e1Jx8oYhfl1rAAfd0H94gmN31S/NQcvzRpxvJRDEIe1VflfvVr3n1kbnDknSA8/ymG
	 cULhI7VYbvUgDiUVOhIVXFAyd69IYdeZjxGkgZAFQWEcc1+Opu1iWgnfPj645t1QYR
	 g4/AKUQ3sYp9DseYJCvCzK4vpRj5YFHB2QUufdGCCem0MJX+cysgiymmMa+qvwAJ8Y
	 N3Xn+QMxkxSY9iY+3J3QrMdymSA++RfVOL3XuW3hBPIvRNiTUKBlUHqF3HUwGgLZvY
	 PUkOwbvy/8Uuw==
Date: Mon, 30 Mar 2026 15:00:25 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: reduce special casing for the open GC zone
Message-ID: <acpz4NExOQ5_OOmH@nidhogg.toxiclabs.cc>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054533.3856339-8-hch@lst.de>

On Mon, Mar 30, 2026 at 07:44:17AM +0200, Christoph Hellwig wrote:
> Currently the open zone used for garbage collection is a special snow
> flake, and it that has been a bit annoying for some further zoned XFS
> work I've been doing.
> 
> Remove the zi_open_gc_field and instead track the open GC zone in the
> zi_open_zones list together with the normal open zones, and keep an extra
> pointer and a reference of in the GC thread's data structure.  This means
> anything iterating over open zones just has to look at zi_open_zones, and
> the life time rules are consistent.  It also helps to add support for
> multiple open GC zones if we ever need them, and removes a bit of code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_zone_alloc.c | 19 +++++++----
>  fs/xfs/xfs_zone_gc.c    | 71 ++++++++++++++++++++++-------------------
>  fs/xfs/xfs_zone_info.c  | 12 +++----
>  fs/xfs/xfs_zone_priv.h  | 15 ++-------
>  4 files changed, 58 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 297a918bf28e..db27fdb3a7d3 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -174,16 +174,18 @@ xfs_open_zone_mark_full(
>  	WRITE_ONCE(rtg->rtg_open_zone, NULL);
>  
>  	spin_lock(&zi->zi_open_zones_lock);
> -	if (oz->oz_is_gc) {
> -		ASSERT(current == zi->zi_gc_thread);
> -		zi->zi_open_gc_zone = NULL;
> -	} else {
> +	if (oz->oz_is_gc)
> +		zi->zi_nr_open_gc_zones--;
> +	else
>  		zi->zi_nr_open_zones--;
> -		list_del_init(&oz->oz_entry);
> -	}
> +	list_del_init(&oz->oz_entry);
>  	spin_unlock(&zi->zi_open_zones_lock);
>  
> -	wake_up_all(&zi->zi_zone_wait);
> +	if (oz->oz_is_gc)
> +		wake_up_process(zi->zi_gc_thread);
> +	else
> +		wake_up_all(&zi->zi_zone_wait);
> +
>  	if (used < rtg_blocks(rtg))
>  		xfs_zone_account_reclaimable(rtg, rtg_blocks(rtg) - used);
>  	xfs_open_zone_put(oz);
> @@ -557,6 +559,9 @@ xfs_try_use_zone(
>  	struct xfs_open_zone	*oz,
>  	unsigned int		goodness)
>  {
> +	if (oz->oz_is_gc)
> +		return false;
> +
>  	if (oz->oz_allocated == rtg_blocks(oz->oz_rtg))
>  		return false;
>  
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 24f20f99ae1a..8c184127b351 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -125,6 +125,7 @@ struct xfs_zone_gc_iter {
>   */
>  struct xfs_zone_gc_data {
>  	struct xfs_mount		*mp;
> +	struct xfs_open_zone		*oz;
>  
>  	/* bioset used to allocate the gc_bios */
>  	struct bio_set			bio_set;
> @@ -525,9 +526,10 @@ xfs_zone_gc_select_victim(
>  }
>  
>  static int
> -xfs_zone_gc_steal_open(
> -	struct xfs_zone_info	*zi)
> +xfs_zone_gc_steal_open_zone(
> +	struct xfs_zone_gc_data	*data)
>  {
> +	struct xfs_zone_info	*zi = data->mp->m_zone_info;
>  	struct xfs_open_zone	*oz, *found = NULL;
>  
>  	spin_lock(&zi->zi_open_zones_lock);
> @@ -542,10 +544,12 @@ xfs_zone_gc_steal_open(
>  
>  	trace_xfs_zone_gc_target_stolen(found->oz_rtg);
>  	found->oz_is_gc = true;
> -	list_del_init(&found->oz_entry);
>  	zi->zi_nr_open_zones--;
> -	zi->zi_open_gc_zone = found;
> +	zi->zi_nr_open_gc_zones++;
>  	spin_unlock(&zi->zi_open_zones_lock);
> +
> +	atomic_inc(&found->oz_ref);
> +	data->oz = found;
>  	return 0;
>  }
>  
> @@ -554,39 +558,43 @@ xfs_zone_gc_steal_open(
>   */
>  static bool
>  xfs_zone_gc_select_target(
> -	struct xfs_mount	*mp)
> +	struct xfs_zone_gc_data	*data)
>  {
> -	struct xfs_zone_info	*zi = mp->m_zone_info;
> -	struct xfs_open_zone	*oz = zi->zi_open_gc_zone;
> +	struct xfs_zone_info	*zi = data->mp->m_zone_info;
>  
> -	if (oz) {
> +	if (data->oz) {
>  		/*
>  		 * If we have space available, just keep using the existing
>  		 * zone.
>  		 */
> -		if (oz->oz_allocated < rtg_blocks(oz->oz_rtg))
> +		if (data->oz->oz_allocated < rtg_blocks(data->oz->oz_rtg))
>  			return true;
>  
>  		/*
>  		 * Wait for all writes to the current zone to finish before
>  		 * picking a new one.
>  		 */
> -		if (oz->oz_written < rtg_blocks(oz->oz_rtg))
> +		if (data->oz->oz_written < rtg_blocks(data->oz->oz_rtg))
>  			return false;
> +
> +		xfs_open_zone_put(data->oz);
>  	}
>  
>  	/*
>  	 * Open a new zone when there is none currently in use.
>  	 */
>  	ASSERT(zi->zi_nr_open_zones <=
> -		mp->m_max_open_zones - XFS_OPEN_GC_ZONES);
> -	oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
> -	if (oz)
> -		trace_xfs_zone_gc_target_opened(oz->oz_rtg);
> +		data->mp->m_max_open_zones - XFS_OPEN_GC_ZONES);
> +	data->oz = xfs_open_zone(data->mp, WRITE_LIFE_NOT_SET, true);
> +	if (!data->oz)
> +		return false;
> +	trace_xfs_zone_gc_target_opened(data->oz->oz_rtg);
> +	atomic_inc(&data->oz->oz_ref);
>  	spin_lock(&zi->zi_open_zones_lock);
> -	zi->zi_open_gc_zone = oz;
> +	zi->zi_nr_open_gc_zones++;
> +	list_add_tail(&data->oz->oz_entry, &zi->zi_open_zones);
>  	spin_unlock(&zi->zi_open_zones_lock);
> -	return !!oz;
> +	return true;
>  }
>  
>  static void
> @@ -609,7 +617,7 @@ xfs_zone_gc_alloc_blocks(
>  	bool			*is_seq)
>  {
>  	struct xfs_mount	*mp = data->mp;
> -	struct xfs_open_zone	*oz = mp->m_zone_info->zi_open_gc_zone;
> +	struct xfs_open_zone	*oz = data->oz;
>  
>  	*count_fsb = min(*count_fsb, XFS_B_TO_FSB(mp, data->scratch_available));
>  
> @@ -683,7 +691,7 @@ xfs_zone_gc_can_start_chunk(
>  			return false;
>  	}
>  
> -	return xfs_zone_gc_select_target(data->mp);
> +	return xfs_zone_gc_select_target(data);
>  }
>  
>  static bool
> @@ -728,7 +736,7 @@ xfs_zone_gc_start_chunk(
>  	chunk->new_daddr = daddr;
>  	chunk->is_seq = is_seq;
>  	chunk->data = data;
> -	chunk->oz = mp->m_zone_info->zi_open_gc_zone;
> +	chunk->oz = data->oz;
>  	chunk->victim_rtg = iter->victim_rtg;
>  	atomic_inc(&rtg_group(chunk->victim_rtg)->xg_active_ref);
>  	atomic_inc(&chunk->victim_rtg->rtg_gccount);
> @@ -1134,6 +1142,8 @@ xfs_zoned_gcd(
>  	}
>  	xfs_clear_zonegc_running(mp);
>  
> +	if (data->oz)
> +		xfs_open_zone_put(data->oz);
>  	if (data->iter.victim_rtg)
>  		xfs_rtgroup_rele(data->iter.victim_rtg);
>  
> @@ -1166,6 +1176,10 @@ xfs_zone_gc_mount(
>  	struct xfs_zone_gc_data	*data;
>  	int			error;
>  
> +	data = xfs_zone_gc_data_alloc(mp);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	/*
>  	 * If there are no free zones available for GC, or the number of open
>  	 * zones has reached the open zone limit, pick the open zone with
> @@ -1175,35 +1189,30 @@ xfs_zone_gc_mount(
>  	 */
>  	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE) ||
>  	    zi->zi_nr_open_zones >= mp->m_max_open_zones) {
> -		error = xfs_zone_gc_steal_open(zi);
> +		error = xfs_zone_gc_steal_open_zone(data);
>  		if (error) {
>  			xfs_warn(mp, "unable to steal an open zone for gc");
> -			return error;
> +			goto out_free_gc_data;
>  		}
>  	}
>  
> -	data = xfs_zone_gc_data_alloc(mp);
> -	if (!data) {
> -		error = -ENOMEM;
> -		goto out_put_gc_zone;
> -	}
> -
>  	zi->zi_gc_thread = kthread_create(xfs_zoned_gcd, data,
>  			"xfs-zone-gc/%s", mp->m_super->s_id);
>  	if (IS_ERR(zi->zi_gc_thread)) {
>  		xfs_warn(mp, "unable to create zone gc thread");
>  		error = PTR_ERR(zi->zi_gc_thread);
> -		goto out_free_gc_data;
> +		goto out_put_oz;
>  	}
>  
>  	/* xfs_zone_gc_start will unpark for rw mounts */
>  	kthread_park(zi->zi_gc_thread);
>  	return 0;
>  
> +out_put_oz:
> +	if (data->oz)
> +		xfs_open_zone_put(data->oz);
>  out_free_gc_data:
>  	kfree(data);
> -out_put_gc_zone:
> -	xfs_open_zone_put(zi->zi_open_gc_zone);
>  	return error;
>  }
>  
> @@ -1214,6 +1223,4 @@ xfs_zone_gc_unmount(
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
>  
>  	kthread_stop(zi->zi_gc_thread);
> -	if (zi->zi_open_gc_zone)
> -		xfs_open_zone_put(zi->zi_open_gc_zone);
>  }
> diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
> index 8e56181021b3..47b475e21af8 100644
> --- a/fs/xfs/xfs_zone_info.c
> +++ b/fs/xfs/xfs_zone_info.c
> @@ -30,11 +30,12 @@ xfs_show_open_zone(
>  	struct seq_file		*m,
>  	struct xfs_open_zone	*oz)
>  {
> -	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s\n",
> +	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s %s\n",
>  		rtg_rgno(oz->oz_rtg),
>  		oz->oz_allocated, oz->oz_written,
>  		rtg_rmap(oz->oz_rtg)->i_used_blocks,
> -		xfs_write_hint_to_str(oz->oz_write_hint));
> +		xfs_write_hint_to_str(oz->oz_write_hint),
> +		oz->oz_is_gc ? "(GC)" : "");
>  }
>  
>  static void
> @@ -58,9 +59,8 @@ xfs_show_full_zone_used_distribution(
>  	spin_unlock(&zi->zi_used_buckets_lock);
>  
>  	full = mp->m_sb.sb_rgcount;
> -	if (zi->zi_open_gc_zone)
> -		full--;
>  	full -= zi->zi_nr_open_zones;
> +	full -= zi->zi_nr_open_gc_zones;
>  	full -= atomic_read(&zi->zi_nr_free_zones);
>  	full -= reclaimable;
>  
> @@ -104,10 +104,6 @@ xfs_zoned_show_stats(
>  	seq_puts(m, "\topen zones:\n");
>  	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
>  		xfs_show_open_zone(m, oz);
> -	if (zi->zi_open_gc_zone) {
> -		seq_puts(m, "\topen gc zone:\n");
> -		xfs_show_open_zone(m, zi->zi_open_gc_zone);
> -	}
>  	spin_unlock(&zi->zi_open_zones_lock);
>  	seq_puts(m, "\tused blocks distribution (fully written zones):\n");
>  	xfs_show_full_zone_used_distribution(m, mp);
> diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
> index 8fbf9a52964e..fcb57506d8e6 100644
> --- a/fs/xfs/xfs_zone_priv.h
> +++ b/fs/xfs/xfs_zone_priv.h
> @@ -32,11 +32,7 @@ struct xfs_open_zone {
>  	 */
>  	enum rw_hint		oz_write_hint;
>  
> -	/*
> -	 * Is this open zone used for garbage collection?  There can only be a
> -	 * single open GC zone, which is pointed to by zi_open_gc_zone in
> -	 * struct xfs_zone_info.  Constant over the life time of an open zone.
> -	 */
> +	/* Is this open zone used for garbage collection? */
>  	bool			oz_is_gc;
>  
>  	/*
> @@ -68,6 +64,7 @@ struct xfs_zone_info {
>  	spinlock_t		zi_open_zones_lock;
>  	struct list_head	zi_open_zones;
>  	unsigned int		zi_nr_open_zones;
> +	unsigned int		zi_nr_open_gc_zones;
>  
>  	/*
>  	 * Free zone search cursor and number of free zones:
> @@ -81,15 +78,9 @@ struct xfs_zone_info {
>  	wait_queue_head_t	zi_zone_wait;
>  
>  	/*
> -	 * Pointer to the GC thread, and the current open zone used by GC
> -	 * (if any).
> -	 *
> -	 * zi_open_gc_zone is mostly private to the GC thread, but can be read
> -	 * for debugging from other threads, in which case zi_open_zones_lock
> -	 * must be taken to access it.
> +	 * Pointer to the GC thread.
>  	 */
>  	struct task_struct      *zi_gc_thread;
> -	struct xfs_open_zone	*zi_open_gc_zone;
>  
>  	/*
>  	 * List of zones that need a reset:
> -- 
> 2.47.3
> 
> 
