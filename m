Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F03386AFA
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 04:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724215468; cv=none; b=lpsQKyon8aA31RxNAe1uT2hoDZRkHNIQ5ZTmoM+FMtpLIGRhSqR0xMw+jo+8fnxxapAOQU0MmEWZxDBpPW6VXwoOMAxcQ9ipVgUrSMP5VleiauyKT/elg5lGX8F/i/GEaIsTrUl6pRvMcaN958g6/GRrU8xjG/Aw+CqxNMsS6Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724215468; c=relaxed/simple;
	bh=30t7et8bwW2smsKV9Y984p0oN2YbH0p8ZdfMG0wN4pI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f11a3iahXU/dfmgeWPZrEvTqHsUmsFwAl96PWi0kyxquSH6rrrQ1huU0gWDEsjSKG7Z8Ynu9pK9c7D3ZqgekwsiDZmK1dKWC7a/C4sj463i8ursEFs8/mC+Qi0iBRkZhFKPt96H8LzIzlKHLWeU4+pDJq4tJAHEMaLR1RnzA+RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e+CpWkSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+CpWkSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEF6C32782;
	Wed, 21 Aug 2024 04:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724215467;
	bh=30t7et8bwW2smsKV9Y984p0oN2YbH0p8ZdfMG0wN4pI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e+CpWkSkmg8nMg11V0Xx7Gm8VvNKftZxX1TcuvVHIZuzg+doUgWVUr96hyjZD2jsS
	 4jdUWClnttzzDQEiZkt2nLohPi1AQ/0+SAAQ5+J2rhYvLoRUKH38hoc0owGbFyww3d
	 Sv23dGAKygUjzfoDgQO/J0PRAmR7Z5e0ZBvUn5SeVh/j/BOY8ps/2NTChrMu7nOS6Y
	 P5oiH6Hp3pRmjJDy4EOSX6ojwLAmjP4i0zMzQ0deyIKEcaaUmpBmAFm3ICP0h3ifEP
	 5x6foO48doKfdK6D8PAIQs7OpKkcH4CUGf2rdNAaliNeANKbcUEah8jiD+4BKlFKhQ
	 dw5luFVr30tug==
Date: Tue, 20 Aug 2024 21:44:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: ensure st_blocks never goes to zero during COW
 writes
Message-ID: <20240821044427.GU865349@frogsfrogsfrogs>
References: <20240820163000.525121-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820163000.525121-1-hch@lst.de>

On Tue, Aug 20, 2024 at 06:29:59PM +0200, Christoph Hellwig wrote:
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

How hard is it to hit this race?a  I guess all you have to do is statx
in a loop while doing a bunch of cow writeback?

> ---
>  fs/xfs/libxfs/xfs_bmap.c |  1 +
>  fs/xfs/xfs_bmap_item.c   | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7df74c35d9f900..a63be14a9873e8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4847,6 +4847,7 @@ xfs_bmapi_remap(
>  	}
>  
>  	ip->i_nblocks += len;
> +	ip->i_delayed_blks -= len;

This proabably ought to have a comment to reference xfs_bmap_defer_add.

>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	if (ifp->if_format == XFS_DINODE_FMT_BTREE)
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e224b49b7cff6d..fc5da2dc7c1c66 100644
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
> +	/* see __xfs_bmap_add for details */

xfs_bmap_defer_add?

--D

> +	if (bi->bi_type == XFS_BMAP_MAP)
> +		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
>  	xfs_defer_add_item(dfp, &bi->bi_list);
>  	return bi;
>  }
> -- 
> 2.43.0
> 
> 
