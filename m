Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4640313265
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 18:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798325; cv=none; b=jJ94nACeKETJlcJTtci72HzYRaC5IqUqJqsbZKasE7s/o9HyfBSTgxccGHSSXl70t2D/bKfAK5s6hHht1hXsw3rEWHS4prM4GBZNf1YADYSGTFjtnHS0PmeOy9IFFq8WJq/pm4L6fBZZnSfPLkFBBCneVrTX8kb3Oddg8AWNo4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798325; c=relaxed/simple;
	bh=M1L0RSYOSxeqAv6MvTMMU/D7MPfCsQAegyyH+x5ltNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gay8s3mjwiUWiTmeGbo/mRnB7XTnNf9pf5mVUEfEMI5i9slwwArKZaCRfGkdNmAxkvPvvdpoXE4zQxEa6cWJtv3ZkCUGAHrGVfcRW+PMttNppUdZa9AL+zl5k0lLXnCk08/Z6lMOUe2RiKDlxuA1LRUTgq89q/3yKWONgoDSDt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OiArNpi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OiArNpi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A22C116D0;
	Mon, 10 Nov 2025 18:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762798324;
	bh=M1L0RSYOSxeqAv6MvTMMU/D7MPfCsQAegyyH+x5ltNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OiArNpi7QrWPudSr9K4e1JGv5pSZVsZhkUvtU7NxrBKoq99ideLlOZO+zQ6LibIMm
	 ij+9wS0QwJj5sU3ma8PdBd0XHHUWWRWtgmrX+xBn48brIPo4E39k+4ePxV7PkT560q
	 qBSDYvJEYphlx2Tu64j2UYCK0jPEOVlyTvZqpMMg/XFjukhz7qZDj9j6BVO1BD1tug
	 72RA1vHxM7RH23yq9xHqTW61+vdaBhYJNQKl+TgpAzOizEpZZGTVPo77W5GwAH5fMB
	 s4GpYTar9/aHn8NZK+QlqpqqfxkZkh93k1cgOfm7IUhrCShclMrYIeODIgDhRozMxS
	 f8kutLrfhwguw==
Date: Mon, 10 Nov 2025 10:12:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/18] xfs: remove xfs_qm_dqput and optimize dropping
 dquot references
Message-ID: <20251110181202.GS196370@frogsfrogsfrogs>
References: <20251110132335.409466-1-hch@lst.de>
 <20251110132335.409466-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110132335.409466-7-hch@lst.de>

On Mon, Nov 10, 2025 at 02:22:58PM +0100, Christoph Hellwig wrote:
> With the new lockref-based dquot reference counting, there is no need to
> hold q_qlock for dropping the reference.  Make xfs_qm_dqrele the main
> function to drop dquot references without taking q_qlock and convert all
> callers of xfs_qm_dqput to unlock q_qlock and call xfs_qm_dqrele instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I like this cleanup -- locking and refcounting are less entangled and
this reduces qlock cycling in the fsck code.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/quota.c             |  3 ++-
>  fs/xfs/scrub/quota_repair.c      |  3 ++-
>  fs/xfs/scrub/quotacheck.c        |  6 +++--
>  fs/xfs/scrub/quotacheck_repair.c |  6 +++--
>  fs/xfs/xfs_dquot.c               | 45 +++++++-------------------------
>  fs/xfs/xfs_dquot.h               |  1 -
>  fs/xfs/xfs_qm.c                  |  6 +++--
>  fs/xfs/xfs_qm_bhv.c              |  3 ++-
>  fs/xfs/xfs_qm_syscalls.c         |  6 +++--
>  fs/xfs/xfs_trace.h               |  3 +--
>  10 files changed, 32 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index c78cf9f96cf6..cfcd0fb66845 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -330,7 +330,8 @@ xchk_quota(
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
>  		error = xchk_quota_item(&sqi, dq);
> -		xfs_qm_dqput(dq);
> +		mutex_unlock(&dq->q_qlock);
> +		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
>  	}
> diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
> index 8c89c6cc2950..d4ce9e56d3ef 100644
> --- a/fs/xfs/scrub/quota_repair.c
> +++ b/fs/xfs/scrub/quota_repair.c
> @@ -513,7 +513,8 @@ xrep_quota_problems(
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
>  		error = xrep_quota_item(&rqi, dq);
> -		xfs_qm_dqput(dq);
> +		mutex_unlock(&dq->q_qlock);
> +		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
>  	}
> diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
> index e4105aaafe84..180449f654f6 100644
> --- a/fs/xfs/scrub/quotacheck.c
> +++ b/fs/xfs/scrub/quotacheck.c
> @@ -636,7 +636,8 @@ xqcheck_walk_observations(
>  			return error;
>  
>  		error = xqcheck_compare_dquot(xqc, dqtype, dq);
> -		xfs_qm_dqput(dq);
> +		mutex_unlock(&dq->q_qlock);
> +		xfs_qm_dqrele(dq);
>  		if (error)
>  			return error;
>  
> @@ -674,7 +675,8 @@ xqcheck_compare_dqtype(
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
>  		error = xqcheck_compare_dquot(xqc, dqtype, dq);
> -		xfs_qm_dqput(dq);
> +		mutex_unlock(&dq->q_qlock);
> +		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
>  	}
> diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
> index 415314911499..11153e24b565 100644
> --- a/fs/xfs/scrub/quotacheck_repair.c
> +++ b/fs/xfs/scrub/quotacheck_repair.c
> @@ -156,7 +156,8 @@ xqcheck_commit_dqtype(
>  	xchk_dqiter_init(&cursor, sc, dqtype);
>  	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
> -		xfs_qm_dqput(dq);
> +		mutex_unlock(&dq->q_qlock);
> +		xfs_qm_dqrele(dq);
>  		if (error)
>  			break;
>  	}
> @@ -187,7 +188,8 @@ xqcheck_commit_dqtype(
>  			return error;
>  
>  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
> -		xfs_qm_dqput(dq);
> +		mutex_unlock(&dq->q_qlock);
> +		xfs_qm_dqrele(dq);
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 34c325524ab9..52c521a1402d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1105,62 +1105,35 @@ xfs_qm_dqget_next(
>  			return 0;
>  		}
>  
> -		xfs_qm_dqput(dqp);
> +		mutex_unlock(&dqp->q_qlock);
> +		xfs_qm_dqrele(dqp);
>  	}
>  
>  	return error;
>  }
>  
>  /*
> - * Release a reference to the dquot (decrement ref-count) and unlock it.
> - *
> - * If there is a group quota attached to this dquot, carefully release that
> - * too without tripping over deadlocks'n'stuff.
> + * Release a reference to the dquot.
>   */
>  void
> -xfs_qm_dqput(
> +xfs_qm_dqrele(
>  	struct xfs_dquot	*dqp)
>  {
> -	ASSERT(XFS_DQ_IS_LOCKED(dqp));
> +	if (!dqp)
> +		return;
>  
> -	trace_xfs_dqput(dqp);
> +	trace_xfs_dqrele(dqp);
>  
>  	if (lockref_put_or_lock(&dqp->q_lockref))
> -		goto out_unlock;
> -
> +		return;
>  	if (!--dqp->q_lockref.count) {
>  		struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
> -		trace_xfs_dqput_free(dqp);
>  
> +		trace_xfs_dqrele_free(dqp);
>  		if (list_lru_add_obj(&qi->qi_lru, &dqp->q_lru))
>  			XFS_STATS_INC(dqp->q_mount, xs_qm_dquot_unused);
>  	}
>  	spin_unlock(&dqp->q_lockref.lock);
> -out_unlock:
> -	mutex_unlock(&dqp->q_qlock);
> -}
> -
> -/*
> - * Release a dquot. Flush it if dirty, then dqput() it.
> - * dquot must not be locked.
> - */
> -void
> -xfs_qm_dqrele(
> -	struct xfs_dquot	*dqp)
> -{
> -	if (!dqp)
> -		return;
> -
> -	trace_xfs_dqrele(dqp);
> -
> -	mutex_lock(&dqp->q_qlock);
> -	/*
> -	 * We don't care to flush it if the dquot is dirty here.
> -	 * That will create stutters that we want to avoid.
> -	 * Instead we do a delayed write when we try to reclaim
> -	 * a dirty dquot. Also xfs_sync will take part of the burden...
> -	 */
> -	xfs_qm_dqput(dqp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index c56fbc39d089..bbb824adca82 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -218,7 +218,6 @@ int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
>  int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
>  				xfs_dqid_t id, xfs_dqtype_t type,
>  				struct xfs_dquot **dqpp);
> -void		xfs_qm_dqput(struct xfs_dquot *dqp);
>  
>  void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
>  void		xfs_dqlockn(struct xfs_dqtrx *q);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index f98f9fdac0b5..5e6aefb17f19 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1346,7 +1346,8 @@ xfs_qm_quotacheck_dqadjust(
>  
>  	dqp->q_flags |= XFS_DQFLAG_DIRTY;
>  out_unlock:
> -	xfs_qm_dqput(dqp);
> +	mutex_unlock(&dqp->q_qlock);
> +	xfs_qm_dqrele(dqp);
>  	return error;
>  }
>  
> @@ -1487,7 +1488,8 @@ xfs_qm_flush_one(
>  		xfs_buf_delwri_queue(bp, buffer_list);
>  	xfs_buf_relse(bp);
>  out_unlock:
> -	xfs_qm_dqput(dqp);
> +	mutex_unlock(&dqp->q_qlock);
> +	xfs_qm_dqrele(dqp);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 245d754f382a..e5a30b12253c 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -74,7 +74,8 @@ xfs_qm_statvfs(
>  
>  	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
>  		xfs_fill_statvfs_from_dquot(statp, ip, dqp);
> -		xfs_qm_dqput(dqp);
> +		mutex_unlock(&dqp->q_qlock);
> +		xfs_qm_dqrele(dqp);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 59ef382900fe..441f9806cddb 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -467,7 +467,8 @@ xfs_qm_scall_getquota(
>  	xfs_qm_scall_getquota_fill_qc(mp, type, dqp, dst);
>  
>  out_put:
> -	xfs_qm_dqput(dqp);
> +	mutex_unlock(&dqp->q_qlock);
> +	xfs_qm_dqrele(dqp);
>  	return error;
>  }
>  
> @@ -497,7 +498,8 @@ xfs_qm_scall_getquota_next(
>  	*id = dqp->q_id;
>  
>  	xfs_qm_scall_getquota_fill_qc(mp, type, dqp, dst);
> +	mutex_unlock(&dqp->q_qlock);
>  
> -	xfs_qm_dqput(dqp);
> +	xfs_qm_dqrele(dqp);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 46d21eb11ccb..fccc032b3c6c 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1409,9 +1409,8 @@ DEFINE_DQUOT_EVENT(xfs_dqget_hit);
>  DEFINE_DQUOT_EVENT(xfs_dqget_miss);
>  DEFINE_DQUOT_EVENT(xfs_dqget_freeing);
>  DEFINE_DQUOT_EVENT(xfs_dqget_dup);
> -DEFINE_DQUOT_EVENT(xfs_dqput);
> -DEFINE_DQUOT_EVENT(xfs_dqput_free);
>  DEFINE_DQUOT_EVENT(xfs_dqrele);
> +DEFINE_DQUOT_EVENT(xfs_dqrele_free);
>  DEFINE_DQUOT_EVENT(xfs_dqflush);
>  DEFINE_DQUOT_EVENT(xfs_dqflush_force);
>  DEFINE_DQUOT_EVENT(xfs_dqflush_done);
> -- 
> 2.47.3
> 
> 
