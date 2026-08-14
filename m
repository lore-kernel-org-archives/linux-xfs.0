Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DCB33B6CC
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786733893; cv=none; b=BUvdt0q0F0MFlnQK8s2ns7Nlwl22Smin1Gg7EuGt5HIqUEoILl0HRK9moT0y4vTavPr5hBRtntgad3ehyozIt8BvgLpGAbQ6TFtu5GkSHJkLEbup8bWMroF0/imXimJrONFc0qJk71uljYJx+HhCX66W2YeCQIXtpA2K/WVaE3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786733893; c=relaxed/simple;
	bh=DCgjFS/3Dxt9u9y3aRri5tkE9KVfN/7bvVeyOJPjyuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VV2dxHhOHyX5XvOVSqpf6if7Usl6nhKePK0/6CR6PjgLQ1POwGkFKS6rSlcz7qksaDSPrMwzbCFvauoG3Fb3uYpTC5WyNooAVbyX3ajexHW7UnwXKYoynqDJ9g5/kbxZG61hVZnNHHZkdqb1a4QFYW3PwWfmvLxXWXlzdQHVMIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPnS6xoZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPnS6xoZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 901D31F000E9;
	Fri, 14 Aug 2026 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786733891;
	bh=wZtG94Rq4nqwgq3Zxsd0ZshlDD35Ax1AtXj3J3rhieY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mPnS6xoZ6yFvwyJ77uWJ1aZIT+ocuA3F4Bi9Yv19PLO7apuV4uUY8PQMAUTkvfwCa
	 MlBy0Y6IPGiZcUu5Xl08HsON662CFZRLbe8dspRhQfn5Iwb+veDLHEIsZH/UN8+pY8
	 eEE0Cr5Rish7GBVPKUuL4aG1wEaC+lc1VJr8la2fWUy3Rk21gUVqRsI6dYFCgz2mXY
	 puLKJhGgrOuNjqrOHVkTStXhkUoPDMhPvN3MAYpLIQuSRa9qgZk91m0YuqS19prFRH
	 322235fswd2bjL8myWFHuMkOvDK7EIk1aZQvcJ2j2XSaVGNH3lMRRVx4iGJqiQpK1X
	 9MzA+hBmD7ijw==
Date: Fri, 14 Aug 2026 11:58:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH v2 2/3] xfs: support additional levels in the agfl
 minimum calculation
Message-ID: <20260814185811.GK3556460@frogsfrogsfrogs>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814132239.271492-3-bfoster@redhat.com>

On Fri, Aug 14, 2026 at 09:22:38AM -0400, Brian Foster wrote:
> xfs_alloc_min_freelist() calculates the worst case AGFL block
> requirement for a full split plus partial refill for each alloc
> btree. An upcoming patch needs to calculate the requirement for
> multiple level increases, so add an optional extra levels parameter
> and factor out a wrapper function for the common case of a single
> split. No functional changes.
> 
> Assisted-by: LLM
> Signed-off-by: Brian Foster <bfoster@redhat.com>

This looks like a simple enough hoist, so I'll move on to the next patch
to see how it's used.  In the meantime,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d99602bcc16f..dbb85fb6314b 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2439,17 +2439,22 @@ xfs_alloc_longest_free_extent(
>  
>  /*
>   * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
> - * return the largest possible minimum length.
> + * return the largest possible minimum length. The base calculation accounts
> + * for a single full split per btree. @extra_levels adds additional split
> + * levels to compute the prospective AGFL requirement increase for
> + * multi-allocation transactions.
>   */
> -unsigned int
> -xfs_alloc_min_freelist(
> +static unsigned int
> +__xfs_alloc_min_freelist(
>  	struct xfs_mount	*mp,
> -	struct xfs_perag	*pag)
> +	struct xfs_perag	*pag,
> +	unsigned int		extra_levels)
>  {
>  	/* AG btrees have at least 1 level. */
>  	const unsigned int	bno_level = pag ? pag->pagf_bno_level : 1;
>  	const unsigned int	cnt_level = pag ? pag->pagf_cnt_level : 1;
>  	const unsigned int	rmap_level = pag ? pag->pagf_rmap_level : 1;
> +	const unsigned int	levels = 1 + extra_levels;
>  	unsigned int		min_free;
>  
>  	ASSERT(mp->m_alloc_maxlevels > 0);
> @@ -2476,15 +2481,25 @@ xfs_alloc_min_freelist(
>  	 */
>  
>  	/* space needed by-bno freespace btree */
> -	min_free = min(bno_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
> +	min_free = min(bno_level + levels, mp->m_alloc_maxlevels) * 2 - 2;
>  	/* space needed by-size freespace btree */
> -	min_free += min(cnt_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
> +	min_free += min(cnt_level + levels, mp->m_alloc_maxlevels) * 2 - 2;
>  	/* space needed reverse mapping used space btree */
> -	if (xfs_has_rmapbt(mp))
> -		min_free += min(rmap_level + 1, mp->m_rmap_maxlevels) * 2 - 2;
> +	if (xfs_has_rmapbt(mp)) {
> +		min_free += min(rmap_level + levels,
> +				mp->m_rmap_maxlevels) * 2 - 2;
> +	}
>  	return min_free;
>  }
>  
> +unsigned int
> +xfs_alloc_min_freelist(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag)
> +{
> +	return __xfs_alloc_min_freelist(mp, pag, 0);
> +}
> +
>  /*
>   * Check if the operation we are fixing up the freelist for should go ahead or
>   * not. If we are freeing blocks, we always allow it, otherwise the allocation
> -- 
> 2.55.0
> 
> 
