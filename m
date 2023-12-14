Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717701110
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AAMJ1lvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9014C433C7;
	Thu, 14 Dec 2023 21:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702587739;
	bh=JY2Po2x6m/+X4UEtUwHbpcPxu83yEFEpw4Uftw3cRHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AAMJ1lvwJGzM4gaQ67FmNy+2JEFODgAnJiEMj47nGp5APZawksc0BDqe0k9tHNbm/
	 jF+lcpzd08MduaxfySFwoJQQnt7oXQ4FsT1koVo0ZH+W/4WtC7h+U60RD3XH8KoCl+
	 WTc7HfJKdNdoDgC/3VCNlDXG8l0WzDOwi6ETdPWgYy25tJ8OBXyKWOJGD3LYFgBmDe
	 9yvlGphsiVHHhaTQ5dgmi2ZFU7E9dqTJjtdQUiwqSeTdzXJprMsBDUC+mwT4XQOiXN
	 ioEVJHRw19NatQBfWpl/uX80kXJLNdR8lu9rAqrACETsm9f8LUv2UmZ+FduytnAkcW
	 PSi28Da4bd76w==
Date: Thu, 14 Dec 2023 13:02:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/19] xfs: split xfs_rtmodify_summary_int
Message-ID: <20231214210219.GZ361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-12-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:30AM +0100, Christoph Hellwig wrote:
> Inline the logic of xfs_rtmodify_summary_int into xfs_rtmodify_summary
> and xfs_rtget_summary instead of having a somewhat awakard helper to

s/awakard/awkward/g

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> share a little bit of code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c | 76 ++++++++++++------------------------
>  1 file changed, 25 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index e67f6f763f7d0f..5773e4ea36c624 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -452,71 +452,38 @@ xfs_trans_log_rtsummary(
>  }
>  
>  /*
> - * Read and/or modify the summary information for a given extent size,
> - * bitmap block combination.
> - * Keeps track of a current summary block, so we don't keep reading
> - * it from the buffer cache.
> - *
> - * Summary information is returned in *sum if specified.
> - * If no delta is specified, returns summary only.
> + * Modify the summary information for a given extent size, bitmap block
> + * combination.
>   */
>  int
> -xfs_rtmodify_summary_int(
> +xfs_rtmodify_summary(
>  	struct xfs_rtalloc_args	*args,
>  	int			log,	/* log2 of extent size */
>  	xfs_fileoff_t		bbno,	/* bitmap block number */
> -	int			delta,	/* change to make to summary info */
> -	xfs_suminfo_t		*sum)	/* out: summary info for this block */
> +	int			delta)	/* in/out: summary block number */
>  {
>  	struct xfs_mount	*mp = args->mp;
> -	int			error;
> -	xfs_fileoff_t		sb;	/* summary fsblock */
> -	xfs_rtsumoff_t		so;	/* index into the summary file */
> +	xfs_rtsumoff_t		so = xfs_rtsumoffs(mp, log, bbno);
>  	unsigned int		infoword;
> +	xfs_suminfo_t		val;
> +	int			error;
>  
> -	/*
> -	 * Compute entry number in the summary file.
> -	 */
> -	so = xfs_rtsumoffs(mp, log, bbno);
> -	/*
> -	 * Compute the block number in the summary file.
> -	 */
> -	sb = xfs_rtsumoffs_to_block(mp, so);
> -
> -	error = xfs_rtsummary_read_buf(args, sb);
> +	error = xfs_rtsummary_read_buf(args, xfs_rtsumoffs_to_block(mp, so));
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * Point to the summary information, modify/log it, and/or copy it out.
> -	 */
>  	infoword = xfs_rtsumoffs_to_infoword(mp, so);
> -	if (delta) {
> -		xfs_suminfo_t	val = xfs_suminfo_add(args, infoword, delta);
> -
> -		if (mp->m_rsum_cache) {
> -			if (val == 0 && log + 1 == mp->m_rsum_cache[bbno])
> -				mp->m_rsum_cache[bbno] = log;
> -			if (val != 0 && log >= mp->m_rsum_cache[bbno])
> -				mp->m_rsum_cache[bbno] = log + 1;
> -		}
> -		xfs_trans_log_rtsummary(args, infoword);
> -		if (sum)
> -			*sum = val;
> -	} else if (sum) {
> -		*sum = xfs_suminfo_get(args, infoword);
> +	val = xfs_suminfo_add(args, infoword, delta);
> +
> +	if (mp->m_rsum_cache) {
> +		if (val == 0 && log + 1 == mp->m_rsum_cache[bbno])
> +			mp->m_rsum_cache[bbno] = log;
> +		if (val != 0 && log >= mp->m_rsum_cache[bbno])
> +			mp->m_rsum_cache[bbno] = log + 1;
>  	}
> -	return 0;
> -}
>  
> -int
> -xfs_rtmodify_summary(
> -	struct xfs_rtalloc_args	*args,
> -	int			log,	/* log2 of extent size */
> -	xfs_fileoff_t		bbno,	/* bitmap block number */
> -	int			delta)	/* in/out: summary block number */
> -{
> -	return xfs_rtmodify_summary_int(args, log, bbno, delta, NULL);
> +	xfs_trans_log_rtsummary(args, infoword);
> +	return 0;
>  }
>  
>  /*
> @@ -530,7 +497,14 @@ xfs_rtget_summary(
>  	xfs_fileoff_t		bbno,	/* bitmap block number */
>  	xfs_suminfo_t		*sum)	/* out: summary info for this block */
>  {
> -	return xfs_rtmodify_summary_int(args, log, bbno, 0, sum);
> +	struct xfs_mount	*mp = args->mp;
> +	xfs_rtsumoff_t		so = xfs_rtsumoffs(mp, log, bbno);
> +	int			error;
> +
> +	error = xfs_rtsummary_read_buf(args, xfs_rtsumoffs_to_block(mp, so));
> +	if (!error)
> +		*sum = xfs_suminfo_get(args, xfs_rtsumoffs_to_infoword(mp, so));
> +	return error;
>  }
>  
>  /* Log rtbitmap block from the word @from to the byte before @next. */
> -- 
> 2.39.2
> 
> 
