Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6552A2F5489
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681051; cv=none; b=BGd0qNUTH0mQExNJppx8yrE7Ryc/Fhqf9yqnQkMy8yCfxQi8GrALpjz4b/9TBp6ddRgWjB989r338PKnUnaTb7KV9fKB/j9SOp97ImebCV6EPtn0m4i+lV07+ladMhIPp5DcXumLa3ZMT5dftQ+8X6iswCggOUXoFDASDvCrKUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681051; c=relaxed/simple;
	bh=LIQP3cOp66BC2+/dgQkvdO4IC8KgHUx4PxVZbqMt6ZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpRxIwGfvcTSAz1/uVsupxiDL3r7QzqsA4y6WBLLF5te8kpZDaj0A/U4hydEgqrN8iMZnWuvkaf4tJLfP7tl4ZqZvJXB1Kn6OFWd6l2n/35bX0Sj0vk9umA08wSCs1baU+nQPm8IVpWpC1pyTOzfEqvD0ZgypnfJmRpTJ5KwEp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYqAaikd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYqAaikd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CACC4CEF0;
	Wed, 16 Jul 2025 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752681051;
	bh=LIQP3cOp66BC2+/dgQkvdO4IC8KgHUx4PxVZbqMt6ZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eYqAaikd4MfJgFYZ/Awc0CAQF+FUX06vdHAX4P6gLfys86dThR6GRvPIyNgYG8PYW
	 Oeq7GtxUfU2Duw4X71R3DCw/D6IK+h7723dh9G64Pl8TTX9zjop2LuF+YVE5BIQbzZ
	 rul4cTzT0IpDTg+ANzUzdNKzYkkfNjc9bS+PD4AIniXYEsSa9zLE03R+ueEsk9wi2a
	 +5GPM8kAQcVv87VuvB7HfGmnbW/tiGda4ns6Bz+ukGxupUE98NrMnXjdGIJVifJQh7
	 JCmBmsVYcfQa2VW2JKMTPobal3raYqFJh+QmAP1KsjlUvsq58rvsWEi4iKpdD9Vf5z
	 YdEA9zLHnqqkA==
Date: Wed, 16 Jul 2025 08:50:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: don't allocate the xfs_extent_busy structure
 for zoned RTGs
Message-ID: <20250716155049.GH2672049@frogsfrogsfrogs>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716125413.2148420-2-hch@lst.de>

On Wed, Jul 16, 2025 at 02:54:01PM +0200, Christoph Hellwig wrote:
> Busy extent tracking is primarily used to ensure that freed blocks are
> not reused for data allocations before the transaction that deleted them
> has been committed to stable storage, and secondarily to drive online
> discard.  None of the use cases applies to zoned RTGs, as the zoned
> allocator can't overwrite blocks before resetting the zone, which already
> flushes out all transactions touching the RTGs.
> 
> So the busy extent tracking is not needed for zoned RTGs, and also not
> called for zoned RTGs.  But somehow the code to skip allocating and
> freeing the structure got lost during the zoned XFS upstreaming process.
> This not only causes these structures to unessecarily allocated, but can

nit: unnecessarily

> also lead to memory leaks as the xg_busy_extents pointer in the
> xfs_group structure is overlayed with the pointer for the linked list
> of to be reset zones.
> 
> Stop allocating and freeing the structure to not pointlessly allocate
> memory which is then leaked when the zone is reset.

Yikes!

Cc: <stable@vger.kernel.org> # v6.15

> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With those added,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_group.c | 14 +++++++++-----
>  fs/xfs/xfs_extent_busy.h  |  8 ++++++++
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
> index e9d76bcdc820..20ad7c309489 100644
> --- a/fs/xfs/libxfs/xfs_group.c
> +++ b/fs/xfs/libxfs/xfs_group.c
> @@ -163,7 +163,8 @@ xfs_group_free(
>  
>  	xfs_defer_drain_free(&xg->xg_intents_drain);
>  #ifdef __KERNEL__
> -	kfree(xg->xg_busy_extents);
> +	if (xfs_group_has_extent_busy(xg->xg_mount, xg->xg_type))
> +		kfree(xg->xg_busy_extents);
>  #endif
>  
>  	if (uninit)
> @@ -189,9 +190,11 @@ xfs_group_insert(
>  	xg->xg_type = type;
>  
>  #ifdef __KERNEL__
> -	xg->xg_busy_extents = xfs_extent_busy_alloc();
> -	if (!xg->xg_busy_extents)
> -		return -ENOMEM;
> +	if (xfs_group_has_extent_busy(mp, type)) {
> +		xg->xg_busy_extents = xfs_extent_busy_alloc();
> +		if (!xg->xg_busy_extents)
> +			return -ENOMEM;
> +	}
>  	spin_lock_init(&xg->xg_state_lock);
>  	xfs_hooks_init(&xg->xg_rmap_update_hooks);
>  #endif
> @@ -210,7 +213,8 @@ xfs_group_insert(
>  out_drain:
>  	xfs_defer_drain_free(&xg->xg_intents_drain);
>  #ifdef __KERNEL__
> -	kfree(xg->xg_busy_extents);
> +	if (xfs_group_has_extent_busy(xg->xg_mount, xg->xg_type))
> +		kfree(xg->xg_busy_extents);
>  #endif
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index f069b04e8ea1..3e6e019b6146 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -68,4 +68,12 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
>  	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
>  }
>  
> +/*
> + * Zoned RTGs don't need to track busy extents, as the actual block freeing only
> + * happens by a zone reset, which forces out all transactions that touched the
> + * to be reset zone first.
> + */
> +#define xfs_group_has_extent_busy(mp, type) \
> +	((type) == XG_TYPE_AG || !xfs_has_zoned((mp)))
> +
>  #endif /* __XFS_EXTENT_BUSY_H__ */
> -- 
> 2.47.2
> 
> 
