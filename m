Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C55827FB38
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 16:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751388313; cv=none; b=ApaKlkBbb5ieZJtDdGZxSJZAWpBKqZqwkWOVssmKUbZEHzcTRfqGs4YgwunMKghUAoiOJAU2eoQW0WMILj4BgY7Ay+rGEqqfzm6IQ/X+zGV3G1aJgoGe4+p1DQW1OuPEZE84PdbfVQxHMIa2hFNcIAOGqHQZZzRwmqvM6qQxTow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751388313; c=relaxed/simple;
	bh=tGFppUuqDEeHQS4v64sOlOdo2J4qVdNZqVWerDQTXNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSHy7mM7BeMNV1TMWAybGRqk7l2WMUaUxC138LO14kTyASPfEUUIxolBHs+GBOt7jhdPPdmunEbEzLtaqMokPA5PSt3ZHeQ1FI7VyZfrUbQE/Fhx8noKETlNy2/qHk5sXy6Askgl/GlqN603M4lVdsHXcEP0FRYxrABQ61AxCgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hKyxUXmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hKyxUXmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81325C4CEF4;
	Tue,  1 Jul 2025 16:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751388312;
	bh=tGFppUuqDEeHQS4v64sOlOdo2J4qVdNZqVWerDQTXNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hKyxUXmRoLy8tS+9yEOvTPAkDD2CMh+hsnMStB0NMZJccFy6wisjrMXXLI6nbH5Zd
	 QSSRwxjLkkeRgMIiRRhOEF21VFLhfd2izs+FEUiOgtemwSJV4vI0LmQ8I8zVICkwUn
	 W/aX5gSn9V4EyoXshgPJXKcOjXB3R2Zx6fdEUC2hBZRqg0maT8CynuxQacYjWt6Hmt
	 T4wPFAX9QO9TKhYxR/r40Nl2XPbTaMlPI73V8u2CcBx+KQ3tUiDvwBtJ6tD4RCEtEK
	 gpPChG7+d1J1rFD1IlV3RrUax1qqOnWP0mPqdPzGYmTBzYXXsCcYqLQ9W5zpZoljDZ
	 1zIi10Hv7rXgA==
Date: Tue, 1 Jul 2025 09:45:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: rename the bt_bdev_* buftarg fields
Message-ID: <20250701164511.GH10009@frogsfrogsfrogs>
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701104125.1681798-6-hch@lst.de>

On Tue, Jul 01, 2025 at 12:40:39PM +0200, Christoph Hellwig wrote:
> The extra bdev_ is weird, so drop it.  Also improve the comment to make
> it clear these are the hardware limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine, thanks for the clarification in the xfs_buftarg definition

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c   | 4 ++--
>  fs/xfs/xfs_buf.h   | 6 +++---
>  fs/xfs/xfs_file.c  | 2 +-
>  fs/xfs/xfs_inode.h | 2 +-
>  fs/xfs/xfs_iomap.c | 2 +-
>  fs/xfs/xfs_iops.c  | 2 +-
>  fs/xfs/xfs_mount.c | 2 +-
>  7 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7a05310da895..661f6c70e9d0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1712,8 +1712,8 @@ xfs_configure_buftarg_atomic_writes(
>  		max_bytes = 0;
>  	}
>  
> -	btp->bt_bdev_awu_min = min_bytes;
> -	btp->bt_bdev_awu_max = max_bytes;
> +	btp->bt_awu_min = min_bytes;
> +	btp->bt_awu_max = max_bytes;
>  }
>  
>  /* Configure a buffer target that abstracts a block device. */
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 73a9686110e8..7987a6d64874 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -112,9 +112,9 @@ struct xfs_buftarg {
>  	struct percpu_counter	bt_readahead_count;
>  	struct ratelimit_state	bt_ioerror_rl;
>  
> -	/* Atomic write unit values, bytes */
> -	unsigned int		bt_bdev_awu_min;
> -	unsigned int		bt_bdev_awu_max;
> +	/* Hardware atomic write unit values, bytes */
> +	unsigned int		bt_awu_min;
> +	unsigned int		bt_awu_max;
>  
>  	/* built-in cache, if we're not using the perag one */
>  	struct xfs_buf_cache	bt_cache[];
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 48254a72071b..377fc9077781 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -752,7 +752,7 @@ xfs_file_dio_write_atomic(
>  	 * HW offload should be faster, so try that first if it is already
>  	 * known that the write length is not too large.
>  	 */
> -	if (ocount > xfs_inode_buftarg(ip)->bt_bdev_awu_max)
> +	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
>  		dops = &xfs_atomic_write_cow_iomap_ops;
>  	else
>  		dops = &xfs_direct_write_iomap_ops;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index d7e2b902ef5c..07fbdcc4cbf5 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -358,7 +358,7 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
>  
>  static inline bool xfs_inode_can_hw_atomic_write(const struct xfs_inode *ip)
>  {
> -	return xfs_inode_buftarg(ip)->bt_bdev_awu_max > 0;
> +	return xfs_inode_buftarg(ip)->bt_awu_max > 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index ff05e6b1b0bb..ec30b78bf5c4 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -827,7 +827,7 @@ xfs_bmap_hw_atomic_write_possible(
>  	/*
>  	 * The ->iomap_begin caller should ensure this, but check anyway.
>  	 */
> -	return len <= xfs_inode_buftarg(ip)->bt_bdev_awu_max;
> +	return len <= xfs_inode_buftarg(ip)->bt_awu_max;
>  }
>  
>  static int
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 8cddbb7c149b..01e597290eb5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -665,7 +665,7 @@ xfs_get_atomic_write_max_opt(
>  	 * less than our out of place write limit, but we don't want to exceed
>  	 * the awu_max.
>  	 */
> -	return min(awu_max, xfs_inode_buftarg(ip)->bt_bdev_awu_max);
> +	return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 99fbb22bad4c..0b690bc119d7 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -699,7 +699,7 @@ xfs_calc_group_awu_max(
>  
>  	if (g->blocks == 0)
>  		return 0;
> -	if (btp && btp->bt_bdev_awu_min > 0)
> +	if (btp && btp->bt_awu_min > 0)
>  		return max_pow_of_two_factor(g->blocks);
>  	return rounddown_pow_of_two(g->blocks);
>  }
> -- 
> 2.47.2
> 
> 
