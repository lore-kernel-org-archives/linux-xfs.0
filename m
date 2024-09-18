Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0712AEEE
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726674040; cv=none; b=Uac+PRBPZ6weuHIg6yMjGcQ1SC83DKvo1jA63yc37snX7/QmJvRfqQpyHMwpCrsOgcEm+8kTYer4XRw5LESsiR42MtMlyOa83jE7vmiF0U1Jh/GO0doGkNUWxF6YY0Imj5ZdRFYow+d8lix+p6GBC9V17XQ9fNdXZLMDbvfJCfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726674040; c=relaxed/simple;
	bh=qiHumHAE/d2awfqwRieXmzE8yzdHNM+gMilTT2kC6r0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/V2ocE0WZr9aoBkyKxrVxqjtLmpJDzMQ8LI8TVVE+AGfb4ke9PVuY4yVxvVtITiZd54vvQ3/sSA9o37PNtN4x9jNA/ov9RXC8iXyxTTQ+/KwmZ79Mwwl84FpSFGfyX9riornqbHvrVxzKGvVHDnxjUmAgTeO5KY2JdB3kve5fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4FnlZzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4FnlZzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A12AC4CEC2;
	Wed, 18 Sep 2024 15:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726674040;
	bh=qiHumHAE/d2awfqwRieXmzE8yzdHNM+gMilTT2kC6r0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i4FnlZzsXRpKTzkUPv8q4OBlokPdx4qLfK5OkIdTP26tx1Bbj4ok8+3peaPBBeDIu
	 DYHxO+/sYlipCEGFnALT3qkDKMSCVgtVG1V4yg+6d94DbRh+lYjfmvd4AhrHw4Z7QV
	 SgOjp8EPphjPeZtArTso+GILCMa085tug93kdJsavPed1SmDmfddGoZeO+6nIdpB1U
	 dJNa736nClqJizRGoIn3VpcqAQreiwz9zBm1FYs5aQdZM6NygFRN11PvGPKq+Bnc9M
	 LevflmFhJAfaEI4gCP1Gq3CnTzx2DT3wtQfNjbSRLUXm9oza1FDbhVQi6CI4mJgYlT
	 jH0au8MSb90rw==
Date: Wed, 18 Sep 2024 08:40:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: don't ifdef around the exact minlen allocations
Message-ID: <20240918154039.GN182194@frogsfrogsfrogs>
References: <20240918053117.774001-1-hch@lst.de>
 <20240918053117.774001-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240918053117.774001-7-hch@lst.de>

On Wed, Sep 18, 2024 at 07:30:08AM +0200, Christoph Hellwig wrote:
> Exact minlen allocations only exist as an error injection tool for debug
> builds.  Currently this is implemented using ifdefs, which means the code
> isn't even compiled for non-XFS_DEBUG builds.  Enhance the compile test
> coverage by always building the code and use the compilers' dead code
> elimination to remove it from the generated binary instead.
> 
> The only downside is that the alloc_minlen_only field is unconditionally
> added to struct xfs_alloc_args now, but by moving it around and packing
> it tightly this doesn't actually increase the size of the structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 7 ++-----
>  fs/xfs/libxfs/xfs_alloc.h | 4 +---
>  fs/xfs/libxfs/xfs_bmap.c  | 6 ------
>  3 files changed, 3 insertions(+), 14 deletions(-)
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
> index fae170825be064..0165452e7cd055 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -53,11 +53,9 @@ typedef struct xfs_alloc_arg {
>  	int		datatype;	/* mask defining data type treatment */
>  	char		wasdel;		/* set if allocation was prev delayed */
>  	char		wasfromfl;	/* set if allocation is from freelist */
> +	bool		alloc_minlen_only; /* allocate exact minlen extent */
>  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> -#ifdef DEBUG
> -	bool		alloc_minlen_only; /* allocate exact minlen extent */
> -#endif
>  } xfs_alloc_arg_t;
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d5a8403b469b9d..5263b66bbd3c60 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3477,7 +3477,6 @@ xfs_bmap_process_allocated_extent(
>  	xfs_bmap_alloc_account(ap);
>  }
>  
> -#ifdef DEBUG
>  static int
>  xfs_bmap_exact_minlen_extent_alloc(
>  	struct xfs_bmalloca	*ap)
> @@ -3539,11 +3538,6 @@ xfs_bmap_exact_minlen_extent_alloc(
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
