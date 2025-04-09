Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6436266B4D
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744213386; cv=none; b=jwe7rzJj5zPw6N29z8glt+Rxy0r1NRtfZa9UAzsVcKwML1iuEBkm4AOzbhhTl+kL3bzuNdnl4gCRJuv4I+VSS0qwNp56cmrquyCKjt2D+LP3J7pPzYnrECNv0+eIWYD0xoIhmyD95PIomhFx227qcSnKOtTadizeAuuQW7VQ9vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744213386; c=relaxed/simple;
	bh=vjdmB9Y5VsQxeHArm37Cqgv6aWmU0eIHf+jdbdD94Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsXh2PKh9X52kH9IMPgi5w497LW/d3xnIRZXFrzJY4sPosiDTD1j/knYmzZZ/hZbtgzH+DPMljjnPaKNXH2rylZrrA92i6u1hHsVMaH3+ePOg+NS10Tib/t4kF+Fp0rZqVumUDFJe6s85git7tk+A02BTCWZwh3BW6vdqRgWJAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZ3rDvBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZ3rDvBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B74FC4CEE2;
	Wed,  9 Apr 2025 15:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744213384;
	bh=vjdmB9Y5VsQxeHArm37Cqgv6aWmU0eIHf+jdbdD94Jg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DZ3rDvBC0xi0/WDg1pMm3Q5MuK+Z6Phj1SWAHYdOavVji9vPcCu2hCgVfd5GikCWg
	 3dfCWvNb2mIGptmCBhbaCAJwACe00Ina09k0Butj/PB1lU4UyucVV22DCCS4jrGsAM
	 pq7cxtw8SbTvCubsbO1cmBablX+XPSD5yfi67UsNOj2c7iddlYd2oiS4fep8/p1MsK
	 BkMTy9Eba4FasxnOge+BjcVKyeYFMd7r7SZ5McGWnjuF3lSNH35jUTQuETvO7oGdtI
	 pUhiYOQjP0YQ0ZzX6k4bubhFhNXUa+y7H5NY1Bk8fcP6DPv3v9ibTdnp3SWDjWENEE
	 SoMfYTjor5mxQ==
Date: Wed, 9 Apr 2025 08:43:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/45] FIXUP: xfs: make metabtree reservations global
Message-ID: <20250409154303.GT6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-5-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:07AM +0200, Christoph Hellwig wrote:
> ---
>  include/spinlock.h   |  5 +++++
>  include/xfs_mount.h  |  4 ++++
>  libxfs/libxfs_priv.h |  1 +
>  mkfs/xfs_mkfs.c      | 25 ++++---------------------
>  4 files changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/include/spinlock.h b/include/spinlock.h
> index 82973726b101..73bd8c078fea 100644
> --- a/include/spinlock.h
> +++ b/include/spinlock.h
> @@ -22,4 +22,9 @@ typedef pthread_mutex_t	spinlock_t;
>  #define spin_trylock(l)		(pthread_mutex_trylock(l) != EBUSY)
>  #define spin_unlock(l)		pthread_mutex_unlock(l)
>  
> +#define mutex_init(l)		pthread_mutex_init(l, NULL)
> +#define mutex_lock(l)		pthread_mutex_lock(l)
> +#define mutex_trylock(l)	(pthread_mutex_trylock(l) != EBUSY)
> +#define mutex_unlock(l)		pthread_mutex_unlock(l)
> +
>  #endif /* __LIBXFS_SPINLOCK_H__ */
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index e0f72fc32b25..0acf952eb9d7 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -164,6 +164,10 @@ typedef struct xfs_mount {
>  	atomic64_t		m_allocbt_blks;
>  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
>  
> +	pthread_mutex_t		m_metafile_resv_lock;
> +	uint64_t		m_metafile_resv_target;
> +	uint64_t		m_metafile_resv_used;
> +	uint64_t		m_metafile_resv_avail;
>  } xfs_mount_t;
>  
>  #define M_IGEO(mp)		(&(mp)->m_ino_geo)
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index cb4800de0b11..82952b0db629 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -151,6 +151,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
>  
>  #define xfs_force_shutdown(d,n)		((void) 0)
>  #define xfs_mod_delalloc(a,b,c)		((void) 0)
> +#define xfs_mod_sb_delalloc(sb, d)	((void) 0)
>  
>  /* stop unused var warnings by assigning mp to itself */
>  
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3f4455d46383..39e3349205fb 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -5102,8 +5102,6 @@ check_rt_meta_prealloc(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_perag	*pag = NULL;
> -	struct xfs_rtgroup	*rtg = NULL;
> -	xfs_filblks_t		ask;
>  	int			error;
>  
>  	/*
> @@ -5123,27 +5121,12 @@ check_rt_meta_prealloc(
>  		}
>  	}
>  
> -	/* Realtime metadata btree inode */
> -	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> -		ask = libxfs_rtrmapbt_calc_reserves(mp);
> -		error = -libxfs_metafile_resv_init(rtg_rmap(rtg), ask);
> -		if (error)
> -			prealloc_fail(mp, error, ask, _("realtime rmap btree"));
> -
> -		ask = libxfs_rtrefcountbt_calc_reserves(mp);
> -		error = -libxfs_metafile_resv_init(rtg_refcount(rtg), ask);
> -		if (error)
> -			prealloc_fail(mp, error, ask,
> -					_("realtime refcount btree"));
> -	}
> +	error = -libxfs_metafile_resv_init(mp);
> +	if (error)
> +		prealloc_fail(mp, error, 0, _("metafile"));

Could this be _("metadata files") so that the error message becomes:

mkfs.xfs: cannot handle expansion of metadata files; need 55 free blocks, have 7

With that changed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  
> -	/* Unreserve the realtime metadata reservations. */
> -	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> -		libxfs_metafile_resv_free(rtg_rmap(rtg));
> -		libxfs_metafile_resv_free(rtg_refcount(rtg));
> -	}
> +	libxfs_metafile_resv_free(mp);
>  
> -	/* Unreserve the per-AG reservations. */
>  	while ((pag = xfs_perag_next(mp, pag)))
>  		libxfs_ag_resv_free(pag);
>  
> -- 
> 2.47.2
> 
> 
