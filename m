Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C7F17555
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737992731; cv=none; b=iD/+ncteEy0royqD0jNPqASrNvcQXQ59tkHRn1xB5jWoDjA9+lvA6AKMIKtTPHz5mmaTaKlmQb88qko4gEBgQiBxyIl0ScyDoCBAD5ZwcWjjrYlsm5bHMNSTqR4aqF1HzETfrQO3cni/oMPZ/mJv/vJzFRL2ccIZl8Bw4+NX0Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737992731; c=relaxed/simple;
	bh=I2rLjB6FNq4iYcZkveY5ra29+2oLVJaQ3OLvYzMCb9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cbr9ukBMmFRMaKC2vII8yH3LKtaua8YCg+jFcho/9ghDaQk+G5VA35gMUYwT4PQK1wz7UA5QXymSOL0pXChCCdnzKYwm/o6ijk/SQwM0t0BWF/aeqlRljpvy2GJzus95PCGSM15WY6pKipb5Zv4gVGcUXbMtJclU4QSUf2AW2ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOPvBsAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOPvBsAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BC2C4CED2;
	Mon, 27 Jan 2025 15:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737992731;
	bh=I2rLjB6FNq4iYcZkveY5ra29+2oLVJaQ3OLvYzMCb9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jOPvBsAYZ/oWakXpfizmqhl5YXsDwdW3wlvIcaV4MYTTVZ+n1++wUYKzT3RjFHSa+
	 5O8oblkw30n+Qmbhnf5sBRdcYaTKyanlVi5InSXOeTx25X4TdskzhxcfqWx/HoJ481
	 jMXnB8Ghh3sP3MFdlrs3WVNRUsQPCUwpMweIpe16QWGeXzV5LP+lU84AE3G6TYMzHY
	 +guCU9wzkXKqakpmKPBh8u/kR1cQyw1U2sGqpZvDAaaQMw/D2FDnfhVpp1cOQu4FpY
	 73Sg192+yc9FpYPcHTG7sypV5YxcQxxILH5OOBs/0SWlvD/cDcKwqS+xD2rD8tTdXJ
	 d5SMHcH3wUHKQ==
Date: Mon, 27 Jan 2025 16:45:22 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org, 
	"Lai, Yi" <yi1.lai@linux.intel.com>
Subject: Re: [PATCH] xfs: remove xfs_buf_cache.bc_lock
Message-ID: <alyr6fevykbdnplwe2h2xt2yrjamec6aofkhoejjewvvzhwyc5@2ohn26zhas6a>
References: <F1frw9ISF6ezkoa1AYYRx2dhdiUS2CrMsKS_bCvbipw2Fm0rtSrrDZ3FBIeNcdwJN328johEKEeARThjO_0-JQ==@protonmail.internalid>
 <20250127150539.601009-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127150539.601009-1-hch@lst.de>

On Mon, Jan 27, 2025 at 04:05:39PM +0100, Christoph Hellwig wrote:
> xfs_buf_cache.bc_lock serializes adding buffers to and removing them from
> the hashtable.  But as the rhashtable code already uses fine grained
> internal locking for inserts and removals the extra protection isn't
> actually required.
> 
> It also happens to fix a lock order inversion vs b_lock added by the
> recent lookup race fix.
> 
> Fixes: ee10f6fcdb96 ("xfs: fix buffer lookup vs release race")
> Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf.c | 20 ++++++++------------
>  fs/xfs/xfs_buf.h |  1 -
>  2 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d1d4a0a22e13..1fffa2990bd9 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -41,8 +41,7 @@ struct kmem_cache *xfs_buf_cache;
>   *
>   * xfs_buf_rele:
>   *	b_lock
> - *	  pag_buf_lock
> - *	    lru_lock
> + *	  lru_lock
>   *
>   * xfs_buftarg_drain_rele
>   *	lru_lock
> @@ -502,7 +501,6 @@ int
>  xfs_buf_cache_init(
>  	struct xfs_buf_cache	*bch)
>  {
> -	spin_lock_init(&bch->bc_lock);
>  	return rhashtable_init(&bch->bc_hash, &xfs_buf_hash_params);
>  }
> 
> @@ -652,17 +650,20 @@ xfs_buf_find_insert(
>  	if (error)
>  		goto out_free_buf;
> 
> -	spin_lock(&bch->bc_lock);
> +	/* The new buffer keeps the perag reference until it is freed. */
> +	new_bp->b_pag = pag;
> +
> +	rcu_read_lock();
>  	bp = rhashtable_lookup_get_insert_fast(&bch->bc_hash,
>  			&new_bp->b_rhash_head, xfs_buf_hash_params);
>  	if (IS_ERR(bp)) {
> +		rcu_read_unlock();
>  		error = PTR_ERR(bp);
> -		spin_unlock(&bch->bc_lock);
>  		goto out_free_buf;
>  	}
>  	if (bp && xfs_buf_try_hold(bp)) {
>  		/* found an existing buffer */
> -		spin_unlock(&bch->bc_lock);
> +		rcu_read_unlock();
>  		error = xfs_buf_find_lock(bp, flags);
>  		if (error)
>  			xfs_buf_rele(bp);
> @@ -670,10 +671,8 @@ xfs_buf_find_insert(
>  			*bpp = bp;
>  		goto out_free_buf;
>  	}
> +	rcu_read_unlock();
> 
> -	/* The new buffer keeps the perag reference until it is freed. */
> -	new_bp->b_pag = pag;
> -	spin_unlock(&bch->bc_lock);
>  	*bpp = new_bp;
>  	return 0;
> 
> @@ -1090,7 +1089,6 @@ xfs_buf_rele_cached(
>  	}
> 
>  	/* we are asked to drop the last reference */
> -	spin_lock(&bch->bc_lock);
>  	__xfs_buf_ioacct_dec(bp);
>  	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
>  		/*
> @@ -1102,7 +1100,6 @@ xfs_buf_rele_cached(
>  			bp->b_state &= ~XFS_BSTATE_DISPOSE;
>  		else
>  			bp->b_hold--;
> -		spin_unlock(&bch->bc_lock);
>  	} else {
>  		bp->b_hold--;
>  		/*
> @@ -1120,7 +1117,6 @@ xfs_buf_rele_cached(
>  		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  		rhashtable_remove_fast(&bch->bc_hash, &bp->b_rhash_head,
>  				xfs_buf_hash_params);
> -		spin_unlock(&bch->bc_lock);
>  		if (pag)
>  			xfs_perag_put(pag);
>  		freebuf = true;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 7e73663c5d4a..3b4ed42e11c0 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -80,7 +80,6 @@ typedef unsigned int xfs_buf_flags_t;
>  #define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
> 
>  struct xfs_buf_cache {
> -	spinlock_t		bc_lock;
>  	struct rhashtable	bc_hash;
>  };
> 
> --
> 2.45.2
> 
