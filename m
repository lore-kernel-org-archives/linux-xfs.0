Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F29175D5D
	for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 18:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726597364; cv=none; b=MLzZxf/QxmGwtNnQvCJxgABJjfrvUKhkTIF7hK3XsKoNyYusZlVHwium/BJ+Awzk6NMWScEqA2GAKvg7iLUbailptPgf0bLSZ3guUGM/883HglkHrBRclfuz4DwEzyaIOm+GNlUaTbg0D+aMhAbT7/eNJgS1q/M76vxQqj0oggE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726597364; c=relaxed/simple;
	bh=1QxUNHnZpOiMgB60KuPsnkfRjp2u+0Pj9WUKphFOArc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iah8DhQ+IlPU/KNqZHd5H2JHr1lo0ynH9AREg1mO6UJcV7YJgPtL7UN6ivqkxojfGKVR+ETR/4cc2gh8bM7KHV77QnXiTdiHWTQVcvmNcgbp5u4/UxSryZif+KkfNLrAKUN3evnekCqbimnGb0mbilf5L9ioXP2ZA+fx/DUGDgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+1LuVbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+1LuVbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAED4C4CEC5;
	Tue, 17 Sep 2024 18:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726597363;
	bh=1QxUNHnZpOiMgB60KuPsnkfRjp2u+0Pj9WUKphFOArc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i+1LuVbXYyq3fFqw8u4NWMlNV9d1RtJait+kdhPA7HWmPUpv9dYPlDne6GMdLyOj1
	 o03BawnM+XXbQYsspbJmKXfGdZ7cgwbIrmUWX4t7uEkWPxaDN38lU4aNpmFiCkB/X/
	 s2vje6/WNtRyE/eCue5Ijhp45CN0CVWXWtXOYOb3QOO5UJ0W5PMxdJHq8lqeJbNeEb
	 SO+SbMx83qFkdQtIKg9oxphOogMx+Tc/bJa/hJpS72bpFWWPdxENUZIMiUdbDoRb8a
	 PpspFrzsbvkQQtaDzmIV09ijMuqJlxYYIOmXXkrxShlckSaXZNM9Kw1dWUxoA8j440
	 WLehyekGJlWYg==
Date: Tue, 17 Sep 2024 11:22:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: don't ifdef around the exact minlen allocations
Message-ID: <20240917182243.GG182194@frogsfrogsfrogs>
References: <20240904053820.2836285-1-hch@lst.de>
 <20240904053820.2836285-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904053820.2836285-7-hch@lst.de>

On Wed, Sep 04, 2024 at 08:37:57AM +0300, Christoph Hellwig wrote:
> Exact minlen allocations only exist as an error injection tool for debug
> builds.  Currently this is implemented using ifdefs, which means the code
> isn't even compiled for non-XFS_DEBUG builds.  Enhance the compile test
> coverage by always building the code and use the compilers' dead code
> elimination to remove it from the generated binary instead.
> 
> The only downside is that the new bitfield is unconditionally added to
> struct xfs_alloc_args now.

Could you move it to one of the holes in that struct so that we don't
bloat the size of this structure by 4 bytes for everyone?  I think some
light reorganization could shrink it from 136 to 128 bytes.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 7 ++-----
>  fs/xfs/libxfs/xfs_alloc.h | 2 --
>  fs/xfs/libxfs/xfs_bmap.c  | 6 ------
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 59326f84f6a571..04f64cf9777e21 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2766,7 +2766,6 @@ xfs_alloc_commit_autoreap(
>  		xfs_defer_item_unpause(tp, aarp->dfp);
>  }
>  
> -#ifdef DEBUG
>  /*
>   * Check if an AGF has a free extent record whose length is equal to
>   * args->minlen.
> @@ -2806,7 +2805,6 @@ xfs_exact_minlen_extent_available(
>  
>  	return error;
>  }
> -#endif
>  
>  /*
>   * Decide whether to use this allocation group for this allocation.
> @@ -2880,15 +2878,14 @@ xfs_alloc_fix_freelist(
>  	if (!xfs_alloc_space_available(args, need, alloc_flags))
>  		goto out_agbp_relse;
>  
> -#ifdef DEBUG
> -	if (args->alloc_minlen_only) {
> +	if (IS_ENABLED(CONFIG_XFS_DEBUG) && args->alloc_minlen_only) {
>  		int stat;
>  
>  		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
>  		if (error || !stat)
>  			goto out_agbp_relse;
>  	}
> -#endif
> +
>  	/*
>  	 * Make the freelist shorter if it's too long.
>  	 *
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index fae170825be064..3e927e628f4418 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -55,9 +55,7 @@ typedef struct xfs_alloc_arg {
>  	char		wasfromfl;	/* set if allocation is from freelist */
>  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> -#ifdef DEBUG
>  	bool		alloc_minlen_only; /* allocate exact minlen extent */
> -#endif
>  } xfs_alloc_arg_t;
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 36ff4c553ba5f7..2f7cfbacec952b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3468,7 +3468,6 @@ xfs_bmap_process_allocated_extent(
>  	xfs_bmap_alloc_account(ap);
>  }
>  
> -#ifdef DEBUG
>  static int
>  xfs_bmap_exact_minlen_extent_alloc(
>  	struct xfs_bmalloca	*ap)
> @@ -3530,11 +3529,6 @@ xfs_bmap_exact_minlen_extent_alloc(
>  
>  	return 0;
>  }
> -#else
> -
> -#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
> -
> -#endif
>  
>  /*
>   * If we are not low on available data blocks and we are allocating at
> -- 
> 2.45.2
> 
> 
