Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9661017A317
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752591269; cv=none; b=rG2Bo1DSHNaAOYFFEJskR16i0zA36kiYWKjzEDy33bEBLIgnPM31ke6/TCFsE+7CSgs+3dchCQsScJqL+xQkQS6+2m9iRRvDfKK+3ZHIX1ZxLh+XyEeOLHsbu+BVYcUjNfKy3WDLBT3upM0Jw8H+ARHavHEFZD9S4AvEvC7lSnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752591269; c=relaxed/simple;
	bh=Ji+lzSGCQlhEvee9x0Dfp4X7r6Jd70TRFb6Nd6sJssM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/r+r4PYy81YEiNKhv+RnnWI7jPZiGDjHzY0lO/Fne9fyjXIJH3lxUlpvcJ5HmcONb0FTAgpsgsekUilquo/Pxu1kIVKb+fKmbjHKvOKb4eeb+VsEP9w5YWAWboSDhsUTuN/4jnR5cmq+Ycl/Rt0bUZeEI/x/hmcgsc2rSyFWYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9e53/8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9e53/8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21630C4CEF4;
	Tue, 15 Jul 2025 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752591269;
	bh=Ji+lzSGCQlhEvee9x0Dfp4X7r6Jd70TRFb6Nd6sJssM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L9e53/8wANp3ZGXb5Xzs4ZkbWdTUzSb0CZ4XIN/fq8XFoOt0MY7qhnYmzZ8nxUGJj
	 nkMP5SA8EA8AJN8OpxEnwjaHa3s5kz2fIZjHw2iDXOZ2EN1ZeNYThCshOoPj32x2q3
	 v2MzDxP4dvV+cwqmnxAxOFHtGh1+DN7r7U3MU22Osvnc8u+V9nZk74LacVFfGmyEIQ
	 HAvQ+xLEBCTlAsmeucKxotIntObfeol7toq9zUrmcpv4ae0MZ6Wnb4JG7PGoJq8p9m
	 Z3KyzfA3/lq/E6H5+RFn5nB8cEOfWKh/Egi5kwoduuuVcKH7/N4Zx//uzyMUzn1GPW
	 1HJuvnxxXHawA==
Date: Tue, 15 Jul 2025 07:54:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: decouple xfs_trans_alloc_empty from
 xfs_trans_alloc
Message-ID: <20250715145428.GV2672049@frogsfrogsfrogs>
References: <20250715122544.1943403-1-hch@lst.de>
 <20250715122544.1943403-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715122544.1943403-4-hch@lst.de>

On Tue, Jul 15, 2025 at 02:25:36PM +0200, Christoph Hellwig wrote:
> xfs_trans_alloc_empty only shares the very basic transaction structure
> allocation and initialization with xfs_trans_alloc.
> 
> Split out a new __xfs_trans_alloc helper for that and otherwise decouple
> xfs_trans_alloc_empty from xfs_trans_alloc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That makes sense, especially because all the _empty callsites become so
much cleaner later on...

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans.c | 52 +++++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 1fddea8d761a..e43f44f62c5f 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -241,6 +241,28 @@ xfs_trans_reserve(
>  	return error;
>  }
>  
> +static struct xfs_trans *
> +__xfs_trans_alloc(
> +	struct xfs_mount	*mp,
> +	uint			flags)
> +{
> +	struct xfs_trans	*tp;
> +
> +	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp));
> +
> +	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
> +	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> +		sb_start_intwrite(mp->m_super);
> +	xfs_trans_set_context(tp);
> +	tp->t_flags = flags;
> +	tp->t_mountp = mp;
> +	INIT_LIST_HEAD(&tp->t_items);
> +	INIT_LIST_HEAD(&tp->t_busy);
> +	INIT_LIST_HEAD(&tp->t_dfops);
> +	tp->t_highest_agno = NULLAGNUMBER;
> +	return tp;
> +}
> +
>  int
>  xfs_trans_alloc(
>  	struct xfs_mount	*mp,
> @@ -254,33 +276,16 @@ xfs_trans_alloc(
>  	bool			want_retry = true;
>  	int			error;
>  
> +	ASSERT(resp->tr_logres > 0);
> +
>  	/*
>  	 * Allocate the handle before we do our freeze accounting and setting up
>  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
>  	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
>  	 */
>  retry:
> -	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
> -	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> -		sb_start_intwrite(mp->m_super);
> -	xfs_trans_set_context(tp);
> -
> -	/*
> -	 * Zero-reservation ("empty") transactions can't modify anything, so
> -	 * they're allowed to run while we're frozen.
> -	 */
> -	WARN_ON(resp->tr_logres > 0 &&
> -		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> -	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
> -	       xfs_has_lazysbcount(mp));
> -
> -	tp->t_flags = flags;
> -	tp->t_mountp = mp;
> -	INIT_LIST_HEAD(&tp->t_items);
> -	INIT_LIST_HEAD(&tp->t_busy);
> -	INIT_LIST_HEAD(&tp->t_dfops);
> -	tp->t_highest_agno = NULLAGNUMBER;
> -
> +	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> +	tp = __xfs_trans_alloc(mp, flags);
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
>  	if (error == -ENOSPC && want_retry) {
>  		xfs_trans_cancel(tp);
> @@ -329,9 +334,8 @@ xfs_trans_alloc_empty(
>  	struct xfs_mount		*mp,
>  	struct xfs_trans		**tpp)
>  {
> -	struct xfs_trans_res		resv = {0};
> -
> -	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
> +	*tpp = __xfs_trans_alloc(mp, XFS_TRANS_NO_WRITECOUNT);
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.47.2
> 
> 
