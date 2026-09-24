Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2613047C105;
	Thu, 24 Sep 2026 21:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790286581; cv=none; b=dEcM6eBgRzxVbfouG4mAbtihCmUKBeAZUHyOGruf59owwmSO5GfnvZtYUY0FMOCY3Z/pMmnCBjqXbTWuM+EQ9cBgDJQFowCS0JLDyq61UFOzG7Qt3s3+ki+zlI9qdcdMYRHBKxWGrP7yp9JeDqhMZE6EknAMK/ccxCW2p6sLC9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790286581; c=relaxed/simple;
	bh=bMLUTJJ9Z3Y5XUpuz2O8lNmV8HBHXY3WbA561zMz0nM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgy5Tc9sLP/RScsGUAYninkmaRTYhiCngjZy4+7CdRQfGkFyu+I8oIkM7dqS8hxqqri+iNnnseHpQbxQEcxeupQdrPmUIdXdf+Lk4COGzHg2bpbicQxKqHrCWGN5xMlUhsIIHWRrbiW/v0cTjHht532yWvc32gSwD3JnRB/ipVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AkdfJpmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AkdfJpmk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A27FE1F000FF;
	Thu, 24 Sep 2026 21:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790286579;
	bh=JVK6XBRugLPNgtxhYwLPulF9yZFmI1NNgSmCabGL0Z0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AkdfJpmk6g4WxeoreHVNp2hX3szPWsMITjt8JIdWHkKrH2UzNR4EEdRoTwIfi/MPU
	 hsd75UvfmC+uvc3N0cEVivOQz9njhqCqaqwOn2vMZ6SB0EsZGZgAVhUUvDVBI+ywYr
	 imGvGN+bTLvFY/75PZcY3mKBSDYap6ACSpclGCRlaURap/c2i06uReqDo/pjReSZHT
	 zm82bWwZCvvb2dsuZ3UhvkZ986BV/B5eVDLPjBTcsszf6151mDfQ1xGOOD3dRSQ5+w
	 1LczqkGo5CICM+EtwfjEf0CXmXwVICp4CgFbjk/EmwbudLQoGmwqpW4SpFfuS+NEsE
	 qD1cV7tfJG25A==
Date: Thu, 24 Sep 2026 14:49:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/21] xfs: introduce XFS_BLI_PREALLOC
Message-ID: <20260924214939.GG2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-6-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:37AM +0200, Christoph Hellwig wrote:
> Add a flag so that the shadow CIL buffer for a buffer log item is always
> sizes to the maximum to prevent reallocations.  This will be used for the

  sized

> RT checksum item, where we know that we are going to fill it up very soon,
> and (almost) sequentially, so there is no point in doing a constant
> realloc cycle when more data is added to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
>  fs/xfs/libxfs/xfs_trans_resv.h |  1 +
>  fs/xfs/xfs_buf_item.c          | 10 ++++++++++
>  fs/xfs/xfs_buf_item.h          |  4 +++-
>  4 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 3151e97ca8ff..5382ece51812 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -53,7 +53,7 @@ xfs_buf_log_overhead(void)
>   * will be changed in a transaction.  size is used to tell how many
>   * bytes should be reserved per item.
>   */
> -STATIC uint
> +uint
>  xfs_calc_buf_res(
>  	uint		nbufs,
>  	uint		size)
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 336279e0fc61..1804e821f382 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -96,6 +96,7 @@ struct xfs_trans_resv {
>  #define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
>  #define	XFS_WRITE_LOG_COUNT_REFLINK	8
>  
> +uint xfs_calc_buf_res(uint nbufs, uint size);
>  void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
>  uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1a4ef34af8d5..644c3fb18310 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -252,6 +252,16 @@ xfs_buf_item_size(
>  		offset += BBTOB(bp->b_maps[i].bm_len);
>  	}
>  
> +	/*
> +	 * For buffers with the prealloc flag, always size the allocation size
> +	 * to the maximum as per the log reservation.  This avoids constant
> +	 * realloc cycles for buffers that are filled sequentially in rapid
> +	 * pace.  Note that the nvecs calaculation is kept from the regular

	                              calculation

> +	 * look as the buffer item formatting expects it.

"...is kept from the regular look as the buffer item formatting expects
it" ?

I don't understand that.  Is the nvecs calculation kept as the buffer
item formatting code expects it, even though we're allocating more
shadow buffer space?

--D

> +	 */
> +	if (bip->bli_flags & XFS_BLI_PREALLOC)
> +		*nbytes = xfs_calc_buf_res(bip->bli_format_count, bp->b_length);
> +
>  	/*
>  	 * Round up the buffer size required to minimise the number of memory
>  	 * allocations that need to be done as this item grows when relogged by
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 3159325dd17b..ddc8ecc4683e 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -20,6 +20,7 @@ struct xfs_mount;
>  #define XFS_BLI_STALE_INODE	(1u << 5)
>  #define	XFS_BLI_INODE_BUF	(1u << 6)
>  #define	XFS_BLI_ORDERED		(1u << 7)
> +#define	XFS_BLI_PREALLOC	(1u << 8)
>  
>  #define XFS_BLI_FLAGS \
>  	{ XFS_BLI_HOLD,		"HOLD" }, \
> @@ -29,7 +30,8 @@ struct xfs_mount;
>  	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
>  	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }, \
>  	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }, \
> -	{ XFS_BLI_ORDERED,	"ORDERED" }
> +	{ XFS_BLI_ORDERED,	"ORDERED" }, \
> +	{ XFS_BLI_PREALLOC,	"PREALLOC" }
>  
>  /*
>   * This is the in core log item structure used to track information
> -- 
> 2.53.0
> 
> 
