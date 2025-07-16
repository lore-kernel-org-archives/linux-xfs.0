Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B361D79BE
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 15:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681531; cv=none; b=rJMZG8EoVKRsswUKeYc5D9g06Hu9Gjz6l1W/pPHnlt9ajDjqYjH63pGs+WsWV7llddsOzo9I/FBRi3boSZGAOYy5IEwRQm/bBktnTdW4/cQhygxx1mm3kb/TOPz1OmkhhL6FeH8wmCKkad7/VzNqZB6ylG1rh5nqVXEo3h9lc8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681531; c=relaxed/simple;
	bh=66m1boNLxc8LlpfK7nYxb7EXuVNU54d9mKroXP4GDKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfNxr7u8FDlMvJx65sT+x8qEzqwwvg0YWeGBGQgQoF5SMf3r+s4eEAUz8AG41ZYYTtwDU81vpRFve6vsrCzlfGyJwLvQ9Gy7wO89yyBxnyX66KIV2TTdqVl1ArToJ7VQV2d0Bo8Q92DWDqnuZ6Lu3RPHxNk39GH1siKJN1CsD6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEXE1gI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEXE1gI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E5FC4CEE7;
	Wed, 16 Jul 2025 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752681530;
	bh=66m1boNLxc8LlpfK7nYxb7EXuVNU54d9mKroXP4GDKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OEXE1gI327zIgmpOfS28hkX8RYZQIGB/nXs1LTWO2GaGasCK1/NZodlP3JtBd0LUw
	 aMgwHwXQ+pccMZPtGs/DST/bMX+VhSDS411OyMornTZdESooIurx1WBfRRM/XRAkJD
	 jBhn2eFpxr52W5VroXFMzwcfYcyWl4GNntpSZzIsyGjvLz/DuXv5sjvAvewa4rxJug
	 OASkgF2t7qAqDvvjEM8oeiQakPpaQEYyRx3YZ2nlQKswSf6TOOAcElgRQ9nPingV1a
	 KBma0wRmjq+Fa4/A5SOZi49o1cyAdwNf8ctMvYAOmRyVxLWOnh25olrtIOf2VtLAzn
	 XGk/mcNmF9F0A==
Date: Wed, 16 Jul 2025 08:58:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: rename oz_write_pointer to oz_allocated
Message-ID: <20250716155850.GJ2672049@frogsfrogsfrogs>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716125413.2148420-4-hch@lst.de>

On Wed, Jul 16, 2025 at 02:54:03PM +0200, Christoph Hellwig wrote:
> This member just tracks how much space we handed out for sequential
> write required zones.  Only for conventional space it actually is the
> pointer where thing are written at, otherwise zone append manages
> that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_trace.h      |  8 ++++----
>  fs/xfs/xfs_zone_alloc.c | 18 +++++++++---------
>  fs/xfs/xfs_zone_gc.c    | 13 ++++++-------
>  fs/xfs/xfs_zone_info.c  |  2 +-
>  fs/xfs/xfs_zone_priv.h  | 16 ++++++++--------
>  5 files changed, 28 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 6addebd764b0..10d4fd671dcf 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -425,8 +425,8 @@ DECLARE_EVENT_CLASS(xfs_zone_alloc_class,
>  		__field(dev_t, dev)
>  		__field(xfs_rgnumber_t, rgno)
>  		__field(xfs_rgblock_t, used)
> +		__field(xfs_rgblock_t, allocated)
>  		__field(xfs_rgblock_t, written)
> -		__field(xfs_rgblock_t, write_pointer)
>  		__field(xfs_rgblock_t, rgbno)
>  		__field(xfs_extlen_t, len)
>  	),
> @@ -434,17 +434,17 @@ DECLARE_EVENT_CLASS(xfs_zone_alloc_class,
>  		__entry->dev = rtg_mount(oz->oz_rtg)->m_super->s_dev;
>  		__entry->rgno = rtg_rgno(oz->oz_rtg);
>  		__entry->used = rtg_rmap(oz->oz_rtg)->i_used_blocks;
> +		__entry->allocated = oz->oz_allocated;
>  		__entry->written = oz->oz_written;
> -		__entry->write_pointer = oz->oz_write_pointer;
>  		__entry->rgbno = rgbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d rgno 0x%x used 0x%x written 0x%x wp 0x%x rgbno 0x%x len 0x%x",
> +	TP_printk("dev %d:%d rgno 0x%x used 0x%x alloced 0x%x written 0x%x rgbno 0x%x len 0x%x",

Looks fine though I'd prefer this be the full word ^^^ "allocated"

With that changed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->rgno,
>  		  __entry->used,
> +		  __entry->allocated,
>  		  __entry->written,
> -		  __entry->write_pointer,
>  		  __entry->rgbno,
>  		  __entry->len)
>  );
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 867465b5b5fe..729d80ff52c1 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -434,7 +434,7 @@ xfs_init_open_zone(
>  	spin_lock_init(&oz->oz_alloc_lock);
>  	atomic_set(&oz->oz_ref, 1);
>  	oz->oz_rtg = rtg;
> -	oz->oz_write_pointer = write_pointer;
> +	oz->oz_allocated = write_pointer;
>  	oz->oz_written = write_pointer;
>  	oz->oz_write_hint = write_hint;
>  	oz->oz_is_gc = is_gc;
> @@ -569,7 +569,7 @@ xfs_try_use_zone(
>  	struct xfs_open_zone	*oz,
>  	bool			lowspace)
>  {
> -	if (oz->oz_write_pointer == rtg_blocks(oz->oz_rtg))
> +	if (oz->oz_allocated == rtg_blocks(oz->oz_rtg))
>  		return false;
>  	if (!lowspace && !xfs_good_hint_match(oz, file_hint))
>  		return false;
> @@ -744,25 +744,25 @@ xfs_zone_alloc_blocks(
>  {
>  	struct xfs_rtgroup	*rtg = oz->oz_rtg;
>  	struct xfs_mount	*mp = rtg_mount(rtg);
> -	xfs_rgblock_t		rgbno;
> +	xfs_rgblock_t		allocated;
>  
>  	spin_lock(&oz->oz_alloc_lock);
>  	count_fsb = min3(count_fsb, XFS_MAX_BMBT_EXTLEN,
> -		(xfs_filblks_t)rtg_blocks(rtg) - oz->oz_write_pointer);
> +		(xfs_filblks_t)rtg_blocks(rtg) - oz->oz_allocated);
>  	if (!count_fsb) {
>  		spin_unlock(&oz->oz_alloc_lock);
>  		return 0;
>  	}
> -	rgbno = oz->oz_write_pointer;
> -	oz->oz_write_pointer += count_fsb;
> +	allocated = oz->oz_allocated;
> +	oz->oz_allocated += count_fsb;
>  	spin_unlock(&oz->oz_alloc_lock);
>  
> -	trace_xfs_zone_alloc_blocks(oz, rgbno, count_fsb);
> +	trace_xfs_zone_alloc_blocks(oz, allocated, count_fsb);
>  
>  	*sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
>  	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *sector);
>  	if (!*is_seq)
> -		*sector += XFS_FSB_TO_BB(mp, rgbno);
> +		*sector += XFS_FSB_TO_BB(mp, allocated);
>  	return XFS_FSB_TO_B(mp, count_fsb);
>  }
>  
> @@ -983,7 +983,7 @@ xfs_zone_rgbno_is_valid(
>  	lockdep_assert_held(&rtg_rmap(rtg)->i_lock);
>  
>  	if (rtg->rtg_open_zone)
> -		return rgbno < rtg->rtg_open_zone->oz_write_pointer;
> +		return rgbno < rtg->rtg_open_zone->oz_allocated;
>  	return !xa_get_mark(&rtg_mount(rtg)->m_groups[XG_TYPE_RTG].xa,
>  			rtg_rgno(rtg), XFS_RTG_FREE);
>  }
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 9c00fc5baa30..7ea9fa77b061 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -533,8 +533,7 @@ xfs_zone_gc_steal_open(
>  
>  	spin_lock(&zi->zi_open_zones_lock);
>  	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry) {
> -		if (!found ||
> -		    oz->oz_write_pointer < found->oz_write_pointer)
> +		if (!found || oz->oz_allocated < found->oz_allocated)
>  			found = oz;
>  	}
>  
> @@ -584,7 +583,7 @@ xfs_zone_gc_ensure_target(
>  {
>  	struct xfs_open_zone	*oz = mp->m_zone_info->zi_open_gc_zone;
>  
> -	if (!oz || oz->oz_write_pointer == rtg_blocks(oz->oz_rtg))
> +	if (!oz || oz->oz_allocated == rtg_blocks(oz->oz_rtg))
>  		return xfs_zone_gc_select_target(mp);
>  	return oz;
>  }
> @@ -605,7 +604,7 @@ xfs_zone_gc_space_available(
>  	oz = xfs_zone_gc_ensure_target(data->mp);
>  	if (!oz)
>  		return false;
> -	return oz->oz_write_pointer < rtg_blocks(oz->oz_rtg) &&
> +	return oz->oz_allocated < rtg_blocks(oz->oz_rtg) &&
>  		xfs_zone_gc_scratch_available(data);
>  }
>  
> @@ -647,7 +646,7 @@ xfs_zone_gc_alloc_blocks(
>  	 */
>  	spin_lock(&mp->m_sb_lock);
>  	*count_fsb = min(*count_fsb,
> -			rtg_blocks(oz->oz_rtg) - oz->oz_write_pointer);
> +			rtg_blocks(oz->oz_rtg) - oz->oz_allocated);
>  	*count_fsb = min3(*count_fsb,
>  			mp->m_free[XC_FREE_RTEXTENTS].res_avail,
>  			mp->m_free[XC_FREE_RTAVAILABLE].res_avail);
> @@ -661,8 +660,8 @@ xfs_zone_gc_alloc_blocks(
>  	*daddr = xfs_gbno_to_daddr(&oz->oz_rtg->rtg_group, 0);
>  	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *daddr);
>  	if (!*is_seq)
> -		*daddr += XFS_FSB_TO_BB(mp, oz->oz_write_pointer);
> -	oz->oz_write_pointer += *count_fsb;
> +		*daddr += XFS_FSB_TO_BB(mp, oz->oz_allocated);
> +	oz->oz_allocated += *count_fsb;
>  	atomic_inc(&oz->oz_ref);
>  	return oz;
>  }
> diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
> index 733bcc2f8645..07e30c596975 100644
> --- a/fs/xfs/xfs_zone_info.c
> +++ b/fs/xfs/xfs_zone_info.c
> @@ -32,7 +32,7 @@ xfs_show_open_zone(
>  {
>  	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s\n",
>  		rtg_rgno(oz->oz_rtg),
> -		oz->oz_write_pointer, oz->oz_written,
> +		oz->oz_allocated, oz->oz_written,
>  		rtg_rmap(oz->oz_rtg)->i_used_blocks,
>  		xfs_write_hint_to_str(oz->oz_write_hint));
>  }
> diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
> index ab696975a993..35e6de3d25ed 100644
> --- a/fs/xfs/xfs_zone_priv.h
> +++ b/fs/xfs/xfs_zone_priv.h
> @@ -11,18 +11,18 @@ struct xfs_open_zone {
>  	atomic_t		oz_ref;
>  
>  	/*
> -	 * oz_write_pointer is the write pointer at which space is handed out
> -	 * for conventional zones, or simple the count of blocks handed out
> -	 * so far for sequential write required zones and is protected by
> -	 * oz_alloc_lock/
> +	 * oz_allocated is the amount of space already allocated out of the zone
> +	 * and is protected by oz_alloc_lock.
> +	 *
> +	 * For conventional zones it also is the offset of the next write.
>  	 */
>  	spinlock_t		oz_alloc_lock;
> -	xfs_rgblock_t		oz_write_pointer;
> +	xfs_rgblock_t		oz_allocated;
>  
>  	/*
> -	 * oz_written is the number of blocks for which we've received a
> -	 * write completion.  oz_written must always be <= oz_write_pointer
> -	 * and is protected by the ILOCK of the rmap inode.
> +	 * oz_written is the number of blocks for which we've received a write
> +	 * completion.  oz_written must always be <= oz_allocated and is
> +	 * protected by the ILOCK of the rmap inode.
>  	 */
>  	xfs_rgblock_t		oz_written;
>  
> -- 
> 2.47.2
> 
> 
