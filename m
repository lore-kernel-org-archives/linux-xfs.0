Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B2C1DE2C9
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563035; cv=none; b=b1ISYnVKjJunP+AHKSdg94741uz+PUJIEe++r6xO+9lhZyYPYChsptT9q05OqDoDQO1RhTD7EAsFwVKgxhnatZkgAyhlJTYDT2Larbpp2ZkivPsjwDM5j9ZnNWtgsCwTK6kjanhCWwAdR2ks3JXjWUqRlTdT6sJW5KSNf6Ax5Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563035; c=relaxed/simple;
	bh=edddhfTLODv8eSDds0+vY7SS867vAgyx3YJYbtz+dvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFDmXMitXl3/zGNsgeWdcDwBfXP3bMFaPR4wW2dfnNfG3kFQ5GVQx6NYVck0zfDs9tYkOb5w4vQRqHdQ2uQQzKSX2CIc+kIolhGJxe1BPYRClYcFLW1sHYIHYCGR0RtIWegypKflzNBaf8KxStPqtCcSVwifDzENr7450lO4lr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jk9LSgPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jk9LSgPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA15C4CEF8;
	Wed, 15 Oct 2025 21:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760563034;
	bh=edddhfTLODv8eSDds0+vY7SS867vAgyx3YJYbtz+dvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jk9LSgPs9y92Fk5gwIZ+X2XyPsZUfTaSBthlfyDc+3RtJvBmR8FHIGDuvW2iFXQOa
	 b4azFiE1i2XUNcYqbNIlQkFyOqRu6FV2NiYx+4GpGeVjduLuSqPHJSdZSjTL0EZhOF
	 Wz3yx3FtOxUwLEq6GiLsr4Vjb/64t90fN6rwJFStejzfmK4DdRPa9Pc78hsNYFqS6X
	 UD7hWDasnbkvAUjXU5MRNxiiEylpO2KirK8ebgGxSx8Sp3aDwp4QpfhB1FpUq79jWt
	 Ep+ltv6wzd8tjcIPYxkh7HOxFAohgxcydB+x5qi6XwzUsF6PvJw/BTto5AOlaU1Qq2
	 TZf5f+PEekNPQ==
Date: Wed, 15 Oct 2025 14:17:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/17] xfs: return the dquot unlocked from xfs_qm_dqget
Message-ID: <20251015211714.GE2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-11-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:11AM +0900, Christoph Hellwig wrote:
> There is no reason to lock the dquot in xfs_qm_dqget, which just acquires
> a reference.  Move the locking to the callers, or remove it in cases where
> the caller instantly unlocks the dquot.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/dqiterate.c         | 1 +
>  fs/xfs/scrub/quotacheck.c        | 1 +
>  fs/xfs/scrub/quotacheck_repair.c | 1 +
>  fs/xfs/xfs_dquot.c               | 4 ++--
>  fs/xfs/xfs_qm.c                  | 4 +---
>  fs/xfs/xfs_qm_bhv.c              | 1 +
>  fs/xfs/xfs_qm_syscalls.c         | 2 ++
>  7 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
> index 20c4daedd48d..6f1185afbf39 100644
> --- a/fs/xfs/scrub/dqiterate.c
> +++ b/fs/xfs/scrub/dqiterate.c
> @@ -205,6 +205,7 @@ xchk_dquot_iter(
>  	if (error)
>  		return error;
>  
> +	mutex_lock(&dq->q_qlock);
>  	cursor->id = dq->q_id + 1;
>  	*dqpp = dq;
>  	return 1;
> diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
> index 180449f654f6..bef63f19cd87 100644
> --- a/fs/xfs/scrub/quotacheck.c
> +++ b/fs/xfs/scrub/quotacheck.c
> @@ -635,6 +635,7 @@ xqcheck_walk_observations(
>  		if (error)
>  			return error;
>  
> +		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_compare_dquot(xqc, dqtype, dq);
>  		mutex_unlock(&dq->q_qlock);
>  		xfs_qm_dqrele(dq);
> diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
> index 67bdc872996a..f7b1add43a2c 100644
> --- a/fs/xfs/scrub/quotacheck_repair.c
> +++ b/fs/xfs/scrub/quotacheck_repair.c
> @@ -181,6 +181,7 @@ xqcheck_commit_dqtype(
>  		if (error)
>  			return error;
>  
> +		mutex_lock(&dq->q_qlock);
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
>  		xfs_qm_dqrele(dq);

Hmm.  No mutex_unlock() ?

Oh, because @dq gets added to the scrub transaction and the
commit/cancel and unlocks it, right?

(Maybe the mutex_lock should go in xqcheck_commit_dquot to avoid the
unbalanced lock state before after the function call?)

--D

>  		if (error)
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index fa493520bea6..98593b380e94 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -896,7 +896,7 @@ xfs_qm_dqget_checks(
>  
>  /*
>   * Given the file system, id, and type (UDQUOT/GDQUOT/PDQUOT), return a
> - * locked dquot, doing an allocation (if requested) as needed.
> + * dquot, doing an allocation (if requested) as needed.
>   */
>  int
>  xfs_qm_dqget(
> @@ -938,7 +938,6 @@ xfs_qm_dqget(
>  	trace_xfs_dqget_miss(dqp);
>  found:
>  	*O_dqpp = dqp;
> -	mutex_lock(&dqp->q_qlock);
>  	return 0;
>  }
>  
> @@ -1093,6 +1092,7 @@ xfs_qm_dqget_next(
>  		else if (error != 0)
>  			break;
>  
> +		mutex_lock(&dqp->q_qlock);
>  		if (!XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
>  			*dqpp = dqp;
>  			return 0;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 9e173a4b18eb..7fbb89fcdeb9 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1268,6 +1268,7 @@ xfs_qm_quotacheck_dqadjust(
>  		return error;
>  	}
>  
> +	mutex_lock(&dqp->q_qlock);
>  	error = xfs_dquot_attach_buf(NULL, dqp);
>  	if (error)
>  		return error;
> @@ -1907,7 +1908,6 @@ xfs_qm_vop_dqalloc(
>  			/*
>  			 * Get the ilock in the right order.
>  			 */
> -			mutex_unlock(&uq->q_qlock);
>  			lockflags = XFS_ILOCK_SHARED;
>  			xfs_ilock(ip, lockflags);
>  		} else {
> @@ -1929,7 +1929,6 @@ xfs_qm_vop_dqalloc(
>  				ASSERT(error != -ENOENT);
>  				goto error_rele;
>  			}
> -			mutex_unlock(&gq->q_qlock);
>  			lockflags = XFS_ILOCK_SHARED;
>  			xfs_ilock(ip, lockflags);
>  		} else {
> @@ -1947,7 +1946,6 @@ xfs_qm_vop_dqalloc(
>  				ASSERT(error != -ENOENT);
>  				goto error_rele;
>  			}
> -			mutex_unlock(&pq->q_qlock);
>  			lockflags = XFS_ILOCK_SHARED;
>  			xfs_ilock(ip, lockflags);
>  		} else {
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index e5a30b12253c..edc0aef3cf34 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -73,6 +73,7 @@ xfs_qm_statvfs(
>  	struct xfs_dquot	*dqp;
>  
>  	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
> +		mutex_lock(&dqp->q_qlock);
>  		xfs_fill_statvfs_from_dquot(statp, ip, dqp);
>  		mutex_unlock(&dqp->q_qlock);
>  		xfs_qm_dqrele(dqp);
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 441f9806cddb..6c8924780d7a 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -302,6 +302,7 @@ xfs_qm_scall_setqlim(
>  		return error;
>  	}
>  
> +	mutex_lock(&dqp->q_qlock);
>  	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
>  	mutex_unlock(&dqp->q_qlock);
>  
> @@ -459,6 +460,7 @@ xfs_qm_scall_getquota(
>  	 * If everything's NULL, this dquot doesn't quite exist as far as
>  	 * our utility programs are concerned.
>  	 */
> +	mutex_lock(&dqp->q_qlock);
>  	if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
>  		error = -ENOENT;
>  		goto out_put;
> -- 
> 2.47.3
> 
> 
