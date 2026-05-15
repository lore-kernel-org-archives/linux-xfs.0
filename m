Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AC5390CB2
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 21:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778882362; cv=none; b=bDst0u2/7SK/zjMZqkmjaXn6OhuMo7TlEfkcAtEPV6aS0vSEGCO/wboD7sDoA2h2RlPORI4ioUGSvbcPcTHgvyHYBZojZeC1PEstGRp/ybFipND6sNQRKM24uajYbmBbrRHtrb5aREosCRXUxuFJsLK7G/4itMe2JZ2F3axXMpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778882362; c=relaxed/simple;
	bh=KM4vYXYo5sQ10N8ZUKPL9WVHvJ1V1B/q0CuVCD2Lapc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCl78BteaEXmCNBJfsE2wG/roC4LyA19MqMvKR6YEhYqTPH+eunLh+nfhdJ+hxy/r1BLPowVMxXboUHyQMui3vMW+Xi9IBo6sTEXD26BgWLl+NWUMK9v6462suEqv3ATfWGWnwvcyb+K+ZfNRZAYfT1gYM/w5QMwmbO2zJ48zn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6oPeLhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6oPeLhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65727C2BCB0;
	Fri, 15 May 2026 21:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778882362;
	bh=KM4vYXYo5sQ10N8ZUKPL9WVHvJ1V1B/q0CuVCD2Lapc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p6oPeLhJkxIa3WxQ8qbpCPoSsflnZiwOhNCFmGtY7yW6rzeCtrElG3oLeEjmvLy+Z
	 SlPmDBsVevY/XsLOMXxd4rDZ2LxKFP28z7f2xv8UYgQYZA17cxPUhJHMNb8px/mYkB
	 8K1mOIAKiIEzpUS8pAT+pBto2SvxueeAjt2HqCYemv7hmDZHsn8TKHtP+fqhqeFeKU
	 TOPwQx4XNTAtjTweUaC5+FKwT12GicRG2ZoGm1K9iDhdVmyo+OoDgbmf61cZGsUo9j
	 8YkWTgCPWGEvMD21WIxNWuWqAWGh9h+HhbBKTMoZ7mjgXSaRyR+kAzHqQD6VhFNj6R
	 gXkidkry/5cUA==
Date: Sat, 16 May 2026 07:59:17 +1000
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a buffer lookup against removal race
Message-ID: <ageXNcsKQinCWyV1@dread>
References: <20260515133212.4039831-1-hch@lst.de>
 <20260515133212.4039831-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515133212.4039831-2-hch@lst.de>

On Fri, May 15, 2026 at 03:31:58PM +0200, Christoph Hellwig wrote:
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
> ---
>  fs/xfs/xfs_buf.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 580d40a5ee57..a095a5c0a01f 100644
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
> @@ -480,8 +481,15 @@ xfs_buf_find_insert(
>  		error = PTR_ERR(bp);
>  		goto out_free_buf;
>  	}
> -	if (bp && lockref_get_not_dead(&bp->b_lockref)) {
> -		/* found an existing buffer */
> +	if (bp) {
> +		/*
> +		 * If there is an existing buffer with a dead lockref, retry
> +		 * until the new buffer is added or usable buffer is found.
> +		 */
> +		if (!lockref_get_not_dead(&bp->b_lockref)) {
> +			rcu_read_unlock();
> +			goto retry;
> +		}

Like the inode cache, there probably should be a delay here rather
than spinning hard. There is no guarantee that the object actually
appears removed from the cache until the RCU grace period expires,
though typically races that find objects being removed are much
shorter duration than that.

Also, is it safe to run lockref_get_not_dead() whilst some other
thread is racing to get lockref.lock and calls lockref_mark_dead()
on it? 


>  		rcu_read_unlock();
>  		error = xfs_buf_find_lock(bp, flags);
>  		if (error)
> @@ -820,15 +828,20 @@ xfs_buf_destroy(
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
>  	if (!xfs_buf_is_uncached(bp)) {
>  		rhashtable_remove_fast(&bp->b_target->bt_hash,
>  				&bp->b_rhash_head, xfs_buf_hash_params);
> -
> -		if (bp->b_pag)
> -			xfs_perag_put(bp->b_pag);
>  	}
> -
> -	xfs_buf_free(bp);
> +	lockref_mark_dead(&bp->b_lockref);
>  }

That'll cause issues. RCU algorithms require the object to be marked
dead before it is removed from the index so that RCU lookup races
that find it after removal (i.e.  during the RCU grace period) see
the object as dead, not as a valid buffer (think RT preemption
between remove and mark dead).

-Dave.
-- 
Dave Chinner
dgc@kernel.org
