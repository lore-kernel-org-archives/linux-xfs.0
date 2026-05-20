Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2243B3886
	for <linux-xfs@vger.kernel.org>; Wed, 20 May 2026 09:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268276; cv=none; b=dTveIUMdmKGZsVdFHMl4S0Z/cYwru99XQKbFIO4D/33Qm0CDmnRvhszCkX+/0wNsiokr5EKuK4at+6zxdQ5HZUDjg6lBUBOjIBXeumPehhHEvUaOep8HjRmMlyqHOsfwmUbv45PEauf8rnDXl31YpwofEW1mMPTkTb4bo9Vz+kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268276; c=relaxed/simple;
	bh=0wAZUInfXNCrCPecNp0jweFphc/WazcmPz5Vi3yZ53s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9b0f1Mg7FEHLrw87aFkuR+S3tSRd/NhxhJtuP+1PWurZSw0qWHCltdEWHux3VkDwwWVVTkjCpbuwPoFSXXGjKMaLlFPcAdR2nhBXiIinef//ASekLVGBaxwux5Air3FQGuCJ+XRztlaSIMaFFkyAIRCVvtLIFUCpf8eclTtPH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llaEQTRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llaEQTRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E03C1F000E9;
	Wed, 20 May 2026 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268274;
	bh=eCn5/jSTBfnZRzCkBoO7Qlf9hdqiuGBek76cnNnFWiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=llaEQTRATZpfBm8qQMrvN2uQ6CC78/9P5awrqIULCb5VkmP3Vy7eR+A8ofoJsZglK
	 kct/2di1vpjx/J1LMdDfEasjOXOcv0W/QOaOCgN2dMIswE05sk7g67rUFZJO9d5KeZ
	 d5DXBb+zuer6kJtISZ7cuyE1LmkUtP5YpiY+h5Sjflwi3NuisE9TIk9YBj0R2T2ydy
	 CImMJ7wJA+8CeC4Dz8F7G7n+Bav4l0gqYrMa6zK2t4HVtPKlw+gcN8hCTg1Bhx22QX
	 CFQs3mlO6Q11VcGC+JAuOnIreVaN8E+ldGgHoEONVL+8ipuQFb4KB4CAGIpK/j8FWm
	 DzmoU4VSdZ6kA==
Date: Wed, 20 May 2026 11:11:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
	Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a buffer lookup against removal race
Message-ID: <ag16OzIySiz-fT5E@nidhogg.toxiclabs.cc>
References: <20260518060209.502179-1-hch@lst.de>
 <20260518060209.502179-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518060209.502179-2-hch@lst.de>

On Mon, May 18, 2026 at 08:02:05AM +0200, Christoph Hellwig wrote:
> When a buffer is freed either by LRU eviction or because it is unset,
> the lockref is marked as dead instantly, which prevents the buffer from
> being used after finding it in the buffer hash in xfs_buf_lookup and
> xfs_buf_find_insert.  But the latter will then not add the new buffer to
> the hash because it already found an existing buffer.
> 
> Fix this using in two places:  Remove the buffer from the hash before
> marking the lockref dead so that that no buffer with a dead lockref can
> be found in the hash, but if we find one in xfs_buf_find_insert due to
> store reordering, handle this case correctly instead of returning an
> unhashed buffer.
> 
> Fixes: 67fe4303972e ("xfs: don't keep a reference for buffers on the LRU")
> Reported-by: Andrey Albershteyn <aalbersh@redhat.com>
> Reported-by: Carlos Maiolino <cem@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 580d40a5ee57..0cea458f1353 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -472,6 +472,7 @@ xfs_buf_find_insert(
>  	/* The new buffer keeps the perag reference until it is freed. */
>  	new_bp->b_pag = pag;
>  
> +retry:
>  	rcu_read_lock();
>  	bp = rhashtable_lookup_get_insert_fast(&btp->bt_hash,
>  			&new_bp->b_rhash_head, xfs_buf_hash_params);
> @@ -480,8 +481,16 @@ xfs_buf_find_insert(
>  		error = PTR_ERR(bp);
>  		goto out_free_buf;
>  	}
> -	if (bp && lockref_get_not_dead(&bp->b_lockref)) {
> -		/* found an existing buffer */
> +	if (bp) {
> +		/*
> +		 * If there is an existing buffer with a dead lockref, retry
> +		 * until the new buffer is added, or a usable buffer is found.
> +		 */
> +		if (!lockref_get_not_dead(&bp->b_lockref)) {
> +			rcu_read_unlock();
> +			cpu_relax();
> +			goto retry;
> +		}
>  		rcu_read_unlock();
>  		error = xfs_buf_find_lock(bp, flags);
>  		if (error)
> @@ -820,15 +829,20 @@ xfs_buf_destroy(
>  	ASSERT(__lockref_is_dead(&bp->b_lockref));
>  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  
> +	if (bp->b_pag)
> +		xfs_perag_put(bp->b_pag);
> +	xfs_buf_free(bp);
> +}
> +
> +static inline void
> +xfs_buf_kill(
> +	struct xfs_buf		*bp)
> +{
> +	lockref_mark_dead(&bp->b_lockref);
>  	if (!xfs_buf_is_uncached(bp)) {
>  		rhashtable_remove_fast(&bp->b_target->bt_hash,
>  				&bp->b_rhash_head, xfs_buf_hash_params);
> -
> -		if (bp->b_pag)
> -			xfs_perag_put(bp->b_pag);
>  	}
> -
> -	xfs_buf_free(bp);
>  }
>  
>  /*
> @@ -851,7 +865,7 @@ xfs_buf_rele(
>  	return;
>  
>  kill:
> -	lockref_mark_dead(&bp->b_lockref);
> +	xfs_buf_kill(bp);
>  	list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
>  	spin_unlock(&bp->b_lockref.lock);
>  
> @@ -1433,7 +1447,7 @@ xfs_buftarg_drain_rele(
>  		return LRU_SKIP;
>  	}
>  
> -	lockref_mark_dead(&bp->b_lockref);
> +	xfs_buf_kill(bp);
>  	list_lru_isolate_move(lru, item, dispose);
>  	spin_unlock(&bp->b_lockref.lock);
>  	return LRU_REMOVED;
> @@ -1545,7 +1559,7 @@ xfs_buftarg_isolate(
>  		return LRU_ROTATE;
>  	}
>  
> -	lockref_mark_dead(&bp->b_lockref);
> +	xfs_buf_kill(bp);
>  	list_lru_isolate_move(lru, item, dispose);
>  	spin_unlock(&bp->b_lockref.lock);
>  	return LRU_REMOVED;
> -- 
> 2.53.0
> 
> 
