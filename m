Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793706045;
	b=iVmXuzTyiRfPjYav64ER66cOMBLXLz8ciI8fMMeROpvtXCNvHFYHX7lmqAf/EFgim42Z
	 Vk1Pst3N2fDTMgjWJJ/N01XrGqWox7wsGgwQag8Sj+dgyaOPN5mtF84tBXGv6fRab9dIm
	 agnKVGP2nI5WoH+hyTXJ5VuF/rItolNGmOBWplHlYyTjAdJWFBewl1OBUjg9Uxmm90osJ
	 8z+EJgkXgHKEeRZ8puOzmlll+/6T8A6PfuGGmKLtzopR88GtQZlbO4NIGIFZzH6t/Axq/
	 8+WpotunMRTTal4IFtohcIi+oJN4aGL+69FdVKQ2fpH4lQLJtpUeun5MW2qqrAM0Y6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793706045;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IINUZmOxxNtRYbOOKUQPqhWjv4spbL2rGVJAkJAqqQc=;
	b=0AlQrtIBupJiAboqck2AGGhtXGDgq0uPQWf72+9LvbLwhDfsSU1rx5zXzs7uNRM8GuPb
	 t2nvngQ+7tLVWHJtRKlt5ixUXty53jVj/Tbz1zFMCXJf8elPTy6qL/b/6eWM8OGQcECnK
	 O+2a60GihZtmUdKyJEW2nWeKmsDLby6gOIiARc0Zzjijp1H/4lsksUyfSxXrhRYFMj3IZ
	 vMwOYpfaQVKpPAaGaH98mResxYBXBA9otVwWqE6lfRm+FOsXlU1R9+KFkGVAqCuO+0Giz
	 G8STBGJ79SZDDtuy9JSDbAgEZKB2gLUoGhQXoTbGgXejAtmFgwbfUZU7q/jWICjWktw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gKJMC5wx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB2E606A32E
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gKJMC5wx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7351F00A02;
	Tue,  3 Nov 2026 11:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793706044;
	bh=IINUZmOxxNtRYbOOKUQPqhWjv4spbL2rGVJAkJAqqQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gKJMC5wxrSvmXfRZWCogdFmHS7rUjPlm9SBhe+D2lEOAFkOsxGDiXVisEBmKlZ4ZG
	 8DTxyBZEGlcAPH+zo70hixLBgyr47mjlzNpd/XqPJb5hrSUcsv3GvZzW13m8uXXDfc
	 UHeWic4sV1jVshhrYt5BknG2b+IlyrG/fCrs3ulCEQr0recwhxaPTpMM+yXraAz4G9
	 OUKhd6PAubbXqpEXf41r+uCYVu3uAH0p0QQCCWIoHnH1U4cMhoN7mMzsTKWQAZptep
	 KEnR5J0n7trGPpYclRXbdZREfB7AfTVupzyOBqq7qPyRzL6//maVmHtYPv/8co3J68
	 +5Y5DOTJ/Uh4w==
Date: Tue, 3 Nov 2026 12:40:40 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, 
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2] xfs: kill xfs_trans_set/clear_context() helpers
Message-ID: <aunIHggW0GncHU7M@nidhogg.toxiclabs.cc>
References: <20261103105654.3129688-1-wangkefeng.wang@huawei.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103105654.3129688-1-wangkefeng.wang@huawei.com>

On Tue, Nov 03, 2026 at 06:56:54PM +0800, Kefeng Wang wrote:
> Open code the helpers so that tp->t_pflags access is explicit, reducing
> the risk of misusing them outside the transaction owner thread as seen
> in xfs_btree_split_worker().
> 
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> v2:
> - Since the previous patches have already been merged[1],
>   rebased on v7.4-rc1 and collect RB
> 
> [1] https://lore.kernel.org/linux-xfs/aqOp035i41XIrDXg@infradead.org/
> 
>  fs/xfs/libxfs/xfs_btree.c |  4 ----
>  fs/xfs/libxfs/xfs_trans.h | 14 --------------
>  fs/xfs/xfs_trans.c        | 10 +++++++---
>  3 files changed, 7 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2434c54a3570..4faab8cd3a52 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -3009,10 +3009,6 @@ xfs_btree_split_worker(
>  						struct xfs_btree_split_args, work);
>  	unsigned int		nofs_flags;
>  
> -	/*
> -	 * Don't use xfs_trans_set_context() here: it would overwrite the
> -	 * caller's saved NOFS state in tp->t_pflags. Use a local scope.
> -	 */
>  	nofs_flags = memalloc_nofs_save();
>  
>  	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
> diff --git a/fs/xfs/libxfs/xfs_trans.h b/fs/xfs/libxfs/xfs_trans.h
> index 05b3cc19a311..b0c7724d0619 100644
> --- a/fs/xfs/libxfs/xfs_trans.h
> +++ b/fs/xfs/libxfs/xfs_trans.h
> @@ -264,20 +264,6 @@ int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
>  		struct xfs_inode *ip, unsigned int *dblocks,
>  		struct xfs_trans **tpp, int *nospace_error);
>  
> -static inline void
> -xfs_trans_set_context(
> -	struct xfs_trans	*tp)
> -{
> -	tp->t_pflags = memalloc_nofs_save();
> -}
> -
> -static inline void
> -xfs_trans_clear_context(
> -	struct xfs_trans	*tp)
> -{
> -	memalloc_nofs_restore(tp->t_pflags);
> -}
> -
>  static inline void
>  xfs_trans_cancel(
>  	struct xfs_trans	*tp)
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8f0c308f312f..973e82e1e323 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -72,7 +72,7 @@ xfs_trans_free(
>  	xfs_extent_busy_clear(&tp->t_busy, false);
>  
>  	trace_xfs_trans_free(tp, _RET_IP_);
> -	xfs_trans_clear_context(tp);
> +	memalloc_nofs_restore(tp->t_pflags);
>  	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_end_intwrite(tp->t_mountp->m_super);
>  	xfs_trans_free_dqinfo(tp);
> @@ -220,7 +220,11 @@ __xfs_trans_alloc(
>  	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_start_intwrite(mp->m_super);
> -	xfs_trans_set_context(tp);
> +	/*
> +	 * Save NOFS state for xfs_trans_free() to restore. Only the
> +	 * transaction owner thread may touch tp->t_pflags.
> +	 */
> +	tp->t_pflags = memalloc_nofs_save();
>  	tp->t_flags = flags;
>  	tp->t_mountp = mp;
>  	INIT_LIST_HEAD(&tp->t_items);
> @@ -1038,7 +1042,7 @@ xfs_trans_roll(
>  	 * xfs_trans_free.  Set it again here before doing memory
>  	 * allocations.
>  	 */
> -	xfs_trans_set_context(tp);
> +	tp->t_pflags = memalloc_nofs_save();
>  
>  	if (error)
>  		return error;
> -- 
> 2.55.0
> 
> 
