Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BF221E091
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 12:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874743; cv=none; b=nEETQXVEbmsnNaUNticSBfnTTBk6DS2ADB9GZTy2j4553LkBaLHft4XkWfUFRv8vlpVXWZJbNWucHeVCgd65K409h1hCSCN1leyj0/RYPHaFKDjCFzFtNx/XGDk6H8Ktz6qz/eGwbzS1aQrkY6Z9fTcdQk9sIPMKywa45NcvZ4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874743; c=relaxed/simple;
	bh=weGESU4AiDEG6wSRTEqpEi0Ya0b+pPsuabbSeZJek4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BddZNKdLT386MBzwy5xVnKa+4AsIuYVUoXxYCntlAGWrCD2VYnzhJwBF6qV7v/iQpfLqdRU0fLAG9mRHWg1JvEInRgcFxo1w7Xm6GBg+yp/JHThivni2xm4y+jH7Z80YpRklreda5RCwfzEe1twWkQFDDEzqMcZUzMc/0tNY8js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAy/TPpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAy/TPpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7644C4CEF7;
	Mon, 30 Mar 2026 12:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874743;
	bh=weGESU4AiDEG6wSRTEqpEi0Ya0b+pPsuabbSeZJek4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QAy/TPpkwUkxUcoN3Pf4Amg3Qjd6xjwM9rk/zUtnGb92el4gXYpurVSf2K5nmWO33
	 90b3DSqw6AhphrU+0BPQbgviQJO/xgkpgUUIc4D4+2sb6/oQvIMF1aEONBw0S38XV9
	 UCoE2DVD1kc6SiwoAy+scPYcpft3LdY4TTd4c1zZVxfNojY2NevTg7tbXfdcoNodMr
	 JHeccj9hZHRVdw/MsQ8fAG0FD6Pc1yGQt+tD+hC9fnmVSbv9i1Lc+s/R/lOxXGrxey
	 TOvUziC0V42jpwUcuCxNP8NmESUSjMLTADhkMNT68bILaYj9CZltvYUYZ0XB+JDLB2
	 m4ndL61YBYInA==
Date: Mon, 30 Mar 2026 14:45:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: streamline GC zone selection
Message-ID: <acpvUjs4nGXCllRR@nidhogg.toxiclabs.cc>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054533.3856339-7-hch@lst.de>

On Mon, Mar 30, 2026 at 07:44:16AM +0200, Christoph Hellwig wrote:
> Currently picking of the GC target zone is done a bit odd, both in the
> main "can we start new GC cycles" routine and in the low-level block
> allocator for GC.  This was mostly done to work around the rules for
> when code in a waitqueue wait loop can sleep.
> 
> But there is a trick to check if the process state has been set to
> running to discover if the wait loop has to be retried all this becomes
> much simpler.

The final part of the sentence looks odd. But I'm no English native
either.

Otherwise...
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> So we can just select a GC zone just before writing,
> and bail out of starting new work if we can't find usable zone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_gc.c | 95 +++++++++++++++++++-------------------------
>  1 file changed, 40 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 6ce5a0708a9b..24f20f99ae1a 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -383,9 +383,6 @@ xfs_zone_gc_iter_irec(
>  	struct xfs_rmap_irec	*irec;
>  	int			error;
>  
> -	if (!iter->victim_rtg)
> -		return false;
> -
>  retry:
>  	if (iter->rec_idx == iter->rec_count) {
>  		error = xfs_zone_gc_query(mp, iter);
> @@ -555,7 +552,7 @@ xfs_zone_gc_steal_open(
>  /*
>   * Ensure we have a valid open zone to write to.
>   */
> -static struct xfs_open_zone *
> +static bool
>  xfs_zone_gc_select_target(
>  	struct xfs_mount	*mp)
>  {
> @@ -568,14 +565,14 @@ xfs_zone_gc_select_target(
>  		 * zone.
>  		 */
>  		if (oz->oz_allocated < rtg_blocks(oz->oz_rtg))
> -			return oz;
> +			return true;
>  
>  		/*
>  		 * Wait for all writes to the current zone to finish before
>  		 * picking a new one.
>  		 */
>  		if (oz->oz_written < rtg_blocks(oz->oz_rtg))
> -			return NULL;
> +			return false;
>  	}
>  
>  	/*
> @@ -589,7 +586,7 @@ xfs_zone_gc_select_target(
>  	spin_lock(&zi->zi_open_zones_lock);
>  	zi->zi_open_gc_zone = oz;
>  	spin_unlock(&zi->zi_open_zones_lock);
> -	return oz;
> +	return !!oz;
>  }
>  
>  static void
> @@ -604,7 +601,7 @@ xfs_zone_gc_end_io(
>  	wake_up_process(data->mp->m_zone_info->zi_gc_thread);
>  }
>  
> -static struct xfs_open_zone *
> +static bool
>  xfs_zone_gc_alloc_blocks(
>  	struct xfs_zone_gc_data	*data,
>  	xfs_extlen_t		*count_fsb,
> @@ -612,11 +609,7 @@ xfs_zone_gc_alloc_blocks(
>  	bool			*is_seq)
>  {
>  	struct xfs_mount	*mp = data->mp;
> -	struct xfs_open_zone	*oz;
> -
> -	oz = xfs_zone_gc_select_target(mp);
> -	if (!oz)
> -		return NULL;
> +	struct xfs_open_zone	*oz = mp->m_zone_info->zi_open_gc_zone;
>  
>  	*count_fsb = min(*count_fsb, XFS_B_TO_FSB(mp, data->scratch_available));
>  
> @@ -638,7 +631,7 @@ xfs_zone_gc_alloc_blocks(
>  	spin_unlock(&mp->m_sb_lock);
>  
>  	if (!*count_fsb)
> -		return NULL;
> +		return false;
>  
>  	*daddr = xfs_gbno_to_daddr(rtg_group(oz->oz_rtg), 0);
>  	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *daddr);
> @@ -646,7 +639,7 @@ xfs_zone_gc_alloc_blocks(
>  		*daddr += XFS_FSB_TO_BB(mp, oz->oz_allocated);
>  	oz->oz_allocated += *count_fsb;
>  	atomic_inc(&oz->oz_ref);
> -	return oz;
> +	return true;
>  }
>  
>  static void
> @@ -671,6 +664,28 @@ xfs_zone_gc_add_data(
>  	} while (len);
>  }
>  
> +static bool
> +xfs_zone_gc_can_start_chunk(
> +	struct xfs_zone_gc_data	*data)
> +{
> +
> +	if (xfs_is_shutdown(data->mp))
> +		return false;
> +	if (!data->scratch_available)
> +		return false;
> +
> +	if (!data->iter.victim_rtg) {
> +		if (kthread_should_stop() || kthread_should_park())
> +			return false;
> +		if (!xfs_zoned_need_gc(data->mp))
> +			return false;
> +		if (!xfs_zone_gc_select_victim(data))
> +			return false;
> +	}
> +
> +	return xfs_zone_gc_select_target(data->mp);
> +}
> +
>  static bool
>  xfs_zone_gc_start_chunk(
>  	struct xfs_zone_gc_data	*data)
> @@ -678,7 +693,6 @@ xfs_zone_gc_start_chunk(
>  	struct xfs_zone_gc_iter	*iter = &data->iter;
>  	struct xfs_mount	*mp = data->mp;
>  	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
> -	struct xfs_open_zone	*oz;
>  	struct xfs_rmap_irec	irec;
>  	struct xfs_gc_bio	*chunk;
>  	struct xfs_inode	*ip;
> @@ -687,14 +701,15 @@ xfs_zone_gc_start_chunk(
>  	unsigned int		len;
>  	bool			is_seq;
>  
> -	if (xfs_is_shutdown(mp))
> +	if (!xfs_zone_gc_can_start_chunk(data))
>  		return false;
>  
> +	set_current_state(TASK_RUNNING);
>  	if (!xfs_zone_gc_iter_irec(mp, iter, &irec, &ip))
>  		return false;
> -	oz = xfs_zone_gc_alloc_blocks(data, &irec.rm_blockcount, &daddr,
> -			&is_seq);
> -	if (!oz) {
> +
> +	if (!xfs_zone_gc_alloc_blocks(data, &irec.rm_blockcount, &daddr,
> +			&is_seq)) {
>  		xfs_irele(ip);
>  		return false;
>  	}
> @@ -713,7 +728,7 @@ xfs_zone_gc_start_chunk(
>  	chunk->new_daddr = daddr;
>  	chunk->is_seq = is_seq;
>  	chunk->data = data;
> -	chunk->oz = oz;
> +	chunk->oz = mp->m_zone_info->zi_open_gc_zone;
>  	chunk->victim_rtg = iter->victim_rtg;
>  	atomic_inc(&rtg_group(chunk->victim_rtg)->xg_active_ref);
>  	atomic_inc(&chunk->victim_rtg->rtg_gccount);
> @@ -1007,33 +1022,6 @@ xfs_zone_gc_reset_zones(
>  	} while (next);
>  }
>  
> -static bool
> -xfs_zone_gc_should_start_new_work(
> -	struct xfs_zone_gc_data	*data)
> -{
> -	struct xfs_open_zone	*oz;
> -
> -	if (xfs_is_shutdown(data->mp))
> -		return false;
> -	if (!data->scratch_available)
> -		return false;
> -
> -	oz = xfs_zone_gc_select_target(data->mp);
> -	if (!oz || oz->oz_allocated == rtg_blocks(oz->oz_rtg))
> -		return false;
> -
> -	if (!data->iter.victim_rtg) {
> -		if (kthread_should_stop() || kthread_should_park())
> -			return false;
> -		if (!xfs_zoned_need_gc(data->mp))
> -			return false;
> -		if (!xfs_zone_gc_select_victim(data))
> -			return false;
> -	}
> -
> -	return true;
> -}
> -
>  /*
>   * Handle the work to read and write data for GC and to reset the zones,
>   * including handling all completions.
> @@ -1083,13 +1071,10 @@ xfs_zone_gc_handle_work(
>  	}
>  	blk_finish_plug(&plug);
>  
> -	if (xfs_zone_gc_should_start_new_work(data)) {
> -		set_current_state(TASK_RUNNING);
> -		blk_start_plug(&plug);
> -		while (xfs_zone_gc_start_chunk(data))
> -			;
> -		blk_finish_plug(&plug);
> -	}
> +	blk_start_plug(&plug);
> +	while (xfs_zone_gc_start_chunk(data))
> +		;
> +	blk_finish_plug(&plug);
>  }
>  
>  /*
> -- 
> 2.47.3
> 
> 
