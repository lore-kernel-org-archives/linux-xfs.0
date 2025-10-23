Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F2521348
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 06:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761200183; cv=none; b=UNkLvusQg+EsN67GUl/ojGGHWy4x8JC654EbDUn7+dgAeyrnBjYdkE+5TxsJem9c4zUatTQ29i5xRv7/oVgtIT/gEMo/i49L1Np5EZbi1hYbkBEZFspkIZlYkHlCBvle9tZOAFCggq6kdOxSE+QvPXk0/bMwQRKc+8kqazCBfjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761200183; c=relaxed/simple;
	bh=9v4iZoQdCksbbXKLU5RVEJesTrR8JRUsvmWhpizbhIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qbs+3kNh84D4BRubAfBYASon3l4leYjwKF6So7NtnE14OlfFyFgsuRWzT4zp+j12NY50BLX5wrREiJDjgrF1o6JoxE603/z69K9mQhREE9JnK+N4PWdXJeQFqWLWZE803qjVy4o7zJGo8yA83tLsStPeVZIiQ2r5a3Frlvn2YH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kEuNd9Kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kEuNd9Kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F01CC4CEE7;
	Thu, 23 Oct 2025 06:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761200183;
	bh=9v4iZoQdCksbbXKLU5RVEJesTrR8JRUsvmWhpizbhIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kEuNd9KdGy8erRnW4Y0mf8k3ZFgxzjdf5PRzeEerDiUaaieGVc+iEwuan9iLQBc4f
	 veAYjJ4ywbBHlDMTjMN0HjV+4mxEOyn2fl52qQdF3bPyoxq3Gd/PwTZgGmgSHjwSqG
	 iEy6uvIvJ3n0GlQqIWI9DK8NVQ2vcf6JwcQsWehInNQg9khW8WZr+9RNRp4MXbHkpg
	 UiHM9KCxLYveUSkurWSOqqSKZEAmnd2ydy7+20631OluR4sQBUBCQnbpnreSpsk8yy
	 w4TLuThc1ZOLfYMpYQp7ccSw5Xa0UFo4h5wErUyqAAlcHScQxu6jfIrai2rDC0vj4u
	 YmHLVsn5+cX2A==
Date: Wed, 22 Oct 2025 23:16:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
Message-ID: <20251023061622.GP3356773@frogsfrogsfrogs>
References: <20251017060710.696868-1-hch@lst.de>
 <20251017060710.696868-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017060710.696868-2-hch@lst.de>

On Fri, Oct 17, 2025 at 08:07:02AM +0200, Christoph Hellwig wrote:
> When we are picking a zone for gc it might already be in the pipeline
> which can lead to us moving the same data twice resulting in in write
> amplification and a very unfortunate case where keep on garbage
> collecting the zone we just filled with migrated data stopping all
> forward progress.
> 
> Fix this by introducing a count of on-going GC operations on a zone, so
> and skip any zone with ongoing GC when picking a new victim.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_rtgroup.h |  6 ++++++
>  fs/xfs/xfs_zone_gc.c        | 27 +++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index d36a6ae0abe5..d4fcf591e63d 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -50,6 +50,12 @@ struct xfs_rtgroup {
>  		uint8_t			*rtg_rsum_cache;
>  		struct xfs_open_zone	*rtg_open_zone;
>  	};
> +
> +	/*
> +	 * Count of outstanding GC operations for zoned XFS.  Any RTG with a
> +	 * non-zero rtg_gccount will not be picked as new GC victim.
> +	 */
> +	atomic_t		rtg_gccount;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 109877d9a6bf..efcb52796d05 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -114,6 +114,8 @@ struct xfs_gc_bio {
>  	/* Open Zone being written to */
>  	struct xfs_open_zone		*oz;
>  
> +	struct xfs_rtgroup		*victim_rtg;
> +
>  	/* Bio used for reads and writes, including the bvec used by it */
>  	struct bio_vec			bv;
>  	struct bio			bio;	/* must be last */
> @@ -264,6 +266,7 @@ xfs_zone_gc_iter_init(
>  	iter->rec_count = 0;
>  	iter->rec_idx = 0;
>  	iter->victim_rtg = victim_rtg;
> +	atomic_inc(&victim_rtg->rtg_gccount);
>  }
>  
>  /*
> @@ -362,6 +365,7 @@ xfs_zone_gc_query(
>  
>  	return 0;
>  done:
> +	atomic_dec(&iter->victim_rtg->rtg_gccount);
>  	xfs_rtgroup_rele(iter->victim_rtg);
>  	iter->victim_rtg = NULL;
>  	return 0;
> @@ -451,6 +455,20 @@ xfs_zone_gc_pick_victim_from(
>  		if (!rtg)
>  			continue;
>  
> +		/*
> +		 * If the zone is already undergoing GC, don't pick it again.
> +		 *
> +		 * This prevents us from picking one of the zones for which we
> +		 * already submitted GC I/O, but for which the remapping hasn't
> +		 * concluded again.  This won't cause data corruption, but

"...but that I/O hasn't yet finished."

With that and the other comments corrected and a Fixes tag applied,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		 * increases write amplification and slows down GC, so this is
> +		 * a bad thing.
> +		 */
> +		if (atomic_read(&rtg->rtg_gccount)) {
> +			xfs_rtgroup_rele(rtg);
> +			continue;
> +		}
> +
>  		/* skip zones that are just waiting for a reset */
>  		if (rtg_rmap(rtg)->i_used_blocks == 0 ||
>  		    rtg_rmap(rtg)->i_used_blocks >= victim_used) {
> @@ -688,6 +706,9 @@ xfs_zone_gc_start_chunk(
>  	chunk->scratch = &data->scratch[data->scratch_idx];
>  	chunk->data = data;
>  	chunk->oz = oz;
> +	chunk->victim_rtg = iter->victim_rtg;
> +	atomic_inc(&chunk->victim_rtg->rtg_group.xg_active_ref);
> +	atomic_inc(&chunk->victim_rtg->rtg_gccount);
>  
>  	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
>  	bio->bi_end_io = xfs_zone_gc_end_io;
> @@ -710,6 +731,8 @@ static void
>  xfs_zone_gc_free_chunk(
>  	struct xfs_gc_bio	*chunk)
>  {
> +	atomic_dec(&chunk->victim_rtg->rtg_gccount);
> +	xfs_rtgroup_rele(chunk->victim_rtg);
>  	list_del(&chunk->entry);
>  	xfs_open_zone_put(chunk->oz);
>  	xfs_irele(chunk->ip);
> @@ -770,6 +793,10 @@ xfs_zone_gc_split_write(
>  	split_chunk->oz = chunk->oz;
>  	atomic_inc(&chunk->oz->oz_ref);
>  
> +	split_chunk->victim_rtg = chunk->victim_rtg;
> +	atomic_inc(&chunk->victim_rtg->rtg_group.xg_active_ref);
> +	atomic_inc(&chunk->victim_rtg->rtg_gccount);
> +
>  	chunk->offset += split_len;
>  	chunk->len -= split_len;
>  	chunk->old_startblock += XFS_B_TO_FSB(data->mp, split_len);
> -- 
> 2.47.3
> 
> 
