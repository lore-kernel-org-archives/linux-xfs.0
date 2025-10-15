Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB75F2C187
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760562331; cv=none; b=Y/8rvdS8Z2Ru1qceA0xFLK3C6eDJ5gwrdHSScqGaKmzNuVsCdmZoz4+1kUbQb8dgj9hy6+RlUzL3h+E0a38koa8ZN5qtNKtkXQUiCuwn2qG0K+qczknfDGszte0WRjbwSMPt4WHeNXvER9n+EkDye0DaBM0SjJBHh3O0sP6HoBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760562331; c=relaxed/simple;
	bh=OyjU9wnCK42mI5ol0ZzyciW9Wti/1s6eTieMDtx5k3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJnKsNklhHDCZhgQmfeQQq0KoY7URXQhm8X3RJ/uH0cd6qJwIWg2RBOeS0lvmWsF/1sZE14PAg0zwlA52tJZZFixd+y7MQ0ZQQ+CidJ6z78kwW2lhHOfHA1xW4UwLs1YT7d3ynbo/rGj9zyYGKO1ZfhPZjwuRwSz2ArJtx6CoK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LT1+8q83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LT1+8q83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718B3C4CEF8;
	Wed, 15 Oct 2025 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760562331;
	bh=OyjU9wnCK42mI5ol0ZzyciW9Wti/1s6eTieMDtx5k3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LT1+8q83BM3DuReRG/we0DeSKyU05Ez/RmXRinAKqHZGRHNM42uqlGM0SSTy+aMqC
	 wpLI/eT5JZgQY9PIgKkqTl8FUnlrE9IY4TeL6p8xEAeBOT5NwysJ7gXHpIBsh/Fl8B
	 OTxupcxgv0uYCs5Foz75+RASOeIuFZVlCG2S/BDq0C2QaXv7U4RkMccV/0UzWfrOJh
	 x5+I3qV8ES+fS3KEmSGthXJaYjG6W5IGJM+WnRs6uR5SfDQigsm9X1t6hUcdHcdTTr
	 glpegljCKSGCDNOhUCXjtEMJeCik8juc+U6AjL/WTqKJPF5GxigLsymJnEWPohW1+A
	 n5gFqGvhCZiSA==
Date: Wed, 15 Oct 2025 14:05:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/17] xfs: consolidate q_qlock locking in xfs_qm_dqget
 and xfs_qm_dqget_inode
Message-ID: <20251015210530.GC2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-8-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:08AM +0900, Christoph Hellwig wrote:
> Move taking q_qlock from the cache lookup / insert helpers into the
> main functions and do it just before returning to the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense that dqget returns a qlock'd dquot no matter where it came
from
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index ceddbbb41999..a6030c53a1f9 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -826,15 +826,13 @@ xfs_qm_dqget_cache_lookup(
>  
>  	trace_xfs_dqget_hit(dqp);
>  	XFS_STATS_INC(mp, xs_qm_dqcachehits);
> -	mutex_lock(&dqp->q_qlock);
>  	return dqp;
>  }
>  
>  /*
>   * Try to insert a new dquot into the in-core cache.  If an error occurs the
>   * caller should throw away the dquot and start over.  Otherwise, the dquot
> - * is returned locked (and held by the cache) as if there had been a cache
> - * hit.
> + * is returned (and held by the cache) as if there had been a cache hit.
>   *
>   * The insert needs to be done under memalloc_nofs context because the radix
>   * tree can do memory allocation during insert. The qi->qi_tree_lock is taken in
> @@ -862,8 +860,6 @@ xfs_qm_dqget_cache_insert(
>  		goto out_unlock;
>  	}
>  
> -	/* Return a locked dquot to the caller, with a reference taken. */
> -	mutex_lock(&dqp->q_qlock);
>  	lockref_init(&dqp->q_lockref);
>  	qi->qi_dquots++;
>  
> @@ -921,10 +917,8 @@ xfs_qm_dqget(
>  
>  restart:
>  	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
> -	if (dqp) {
> -		*O_dqpp = dqp;
> -		return 0;
> -	}
> +	if (dqp)
> +		goto found;
>  
>  	error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
>  	if (error)
> @@ -942,7 +936,9 @@ xfs_qm_dqget(
>  	}
>  
>  	trace_xfs_dqget_miss(dqp);
> +found:
>  	*O_dqpp = dqp;
> +	mutex_lock(&dqp->q_qlock);
>  	return 0;
>  }
>  
> @@ -1017,10 +1013,8 @@ xfs_qm_dqget_inode(
>  
>  restart:
>  	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
> -	if (dqp) {
> -		*O_dqpp = dqp;
> -		return 0;
> -	}
> +	if (dqp)
> +		goto found;
>  
>  	/*
>  	 * Dquot cache miss. We don't want to keep the inode lock across
> @@ -1046,7 +1040,6 @@ xfs_qm_dqget_inode(
>  		if (dqp1) {
>  			xfs_qm_dqdestroy(dqp);
>  			dqp = dqp1;
> -			mutex_lock(&dqp->q_qlock);
>  			goto dqret;
>  		}
>  	} else {
> @@ -1069,7 +1062,9 @@ xfs_qm_dqget_inode(
>  dqret:
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
>  	trace_xfs_dqget_miss(dqp);
> +found:
>  	*O_dqpp = dqp;
> +	mutex_lock(&dqp->q_qlock);
>  	return 0;
>  }
>  
> -- 
> 2.47.3
> 
> 
