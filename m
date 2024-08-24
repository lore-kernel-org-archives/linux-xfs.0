Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4222182B4
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 04:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724474839; cv=none; b=lFfUj4VdMt6h7ZDvvuX3hZcXkaUWZN2s25G+E6chMNsxdxDG0kenuzUU218KwJp17GKqsYea5NXjxZXG04J3sQ5XzPQEvgNtNsGknsS0CFnnEg81uHExoeFZPedj0RYzWdHCheAQaMScpzPIiSbY6h9gsMWinh8A6IeGsgPtR4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724474839; c=relaxed/simple;
	bh=bmVOI0Q//f8tBgg3hFvwsP2dNty7bKcKu54bUp9az70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IlsrKhaON4UMY2tCnCfb1Nk4DlBEDKq+eYo4dAu2evK5GOGyAy6AJaLBxtC6WrbGQgYhdUhYSw4VkD9zKdfU4HHeJICfuthSMUj1Cs7vzDMk40QjqRDgPgti/Q7MIEozZNqZBn/i4yqn5dgOq9jcMwAYETi2GTSzIwSYe7t6NQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjPW1nsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjPW1nsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4843AC4AF0B;
	Sat, 24 Aug 2024 04:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724474839;
	bh=bmVOI0Q//f8tBgg3hFvwsP2dNty7bKcKu54bUp9az70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BjPW1nsmwEsKS2eGbrWTfgWnpkjKdaTONOHqCn+jdDqAafuoYF8B2XfTui99KBkIx
	 YuwvqR3PNNU8qPA9yG2jiULSGwxlsNtx9p5mV35ThpoHfvNnYsn1fXUnHd2KEhjGsQ
	 73m95VS7yh/um4ahbJHOzMFxm7Oxf5u1ihuBrL5Jknjf4blZZcuNTUVHYmV4uyLNhG
	 2aDjaST3PiyeNEgi90GCj0m/yIPZnR9YE5kYWcWhmKrKCCPrGvdhMR1lT8qrk07E9p
	 TA3pein9/j/tybnNR1fOqEs32/K3bJE1ZJjcpRn9hw5HBqXwlSnd8FdD02LH86Of4D
	 oYab+2q09Vmsw==
Date: Fri, 23 Aug 2024 21:47:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: ensure st_blocks never goes to zero during COW
 writes
Message-ID: <20240824044718.GT865349@frogsfrogsfrogs>
References: <20240824033814.1162964-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240824033814.1162964-1-hch@lst.de>

On Sat, Aug 24, 2024 at 05:37:52AM +0200, Christoph Hellwig wrote:
> COW writes remove the amount overwritten either directly for delalloc
> reservations, or in earlier deferred transactions than adding the new
> amount back in the bmap map transaction.  This means st_blocks on an
> inode where all data is overwritten using the COW path can temporarily
> show a 0 st_blocks.  This can easily be reproduced with the pending
> zoned device support where all writes use this path and trips the
> check in generic/615, but could also happen on a reflink file without
> that.
> 
> Fix this by temporarily add the pending blocks to be mapped to
> i_delayed_blks while the item is queued.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Changes since v1:
>  - slightly more and slightly improved comments
> 
>  fs/xfs/libxfs/xfs_bmap.c |  1 +
>  fs/xfs/xfs_bmap_item.c   | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7df74c35d9f900..177735c30d273a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4847,6 +4847,7 @@ xfs_bmapi_remap(
>  	}
>  
>  	ip->i_nblocks += len;
> +	ip->i_delayed_blks -= len; /* see xfs_bmap_defer_add */
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e224b49b7cff6d..4b8838e5b5bebc 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -346,6 +346,18 @@ xfs_bmap_defer_add(
>  	trace_xfs_bmap_defer(bi);
>  
>  	xfs_bmap_update_get_group(tp->t_mountp, bi);
> +
> +	/*
> +	 * Ensure the deferred mapping is pre-recorded in i_delayed_blks.
> +	 *
> +	 * Otherwise stat can report zero blocks for an inode that actually has
> +	 * data when the entire mapping is in the process of being overwritten
> +	 * using the out of place write path. This is undone in after

Nit: "...undone after xfs_bmapi_remap..."

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	 * xfs_bmapi_remap has incremented di_nblocks for a successful
> +	 * operation.
> +	 */
> +	if (bi->bi_type == XFS_BMAP_MAP)
> +		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
>  	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
>  }
>  
> @@ -367,6 +379,9 @@ xfs_bmap_update_cancel_item(
>  {
>  	struct xfs_bmap_intent		*bi = bi_entry(item);
>  
> +	if (bi->bi_type == XFS_BMAP_MAP)
> +		bi->bi_owner->i_delayed_blks -= bi->bi_bmap.br_blockcount;
> +
>  	xfs_bmap_update_put_group(bi);
>  	kmem_cache_free(xfs_bmap_intent_cache, bi);
>  }
> @@ -464,6 +479,9 @@ xfs_bui_recover_work(
>  	bi->bi_owner = *ipp;
>  	xfs_bmap_update_get_group(mp, bi);
>  
> +	/* see xfs_bmap_defer_add for details */
> +	if (bi->bi_type == XFS_BMAP_MAP)
> +		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
>  	xfs_defer_add_item(dfp, &bi->bi_list);
>  	return bi;
>  }
> -- 
> 2.43.0
> 
> 
