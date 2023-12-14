Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D450B5F1E2
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHyNTzAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D06C433C7;
	Thu, 14 Dec 2023 21:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702589738;
	bh=950EIOiLiAegO8iiJ9ciF7FCquDl98pwVuMwqr80hBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WHyNTzAYOLIupYmiOU7NF1cnblbR/Va2qXP9cG94ems0vzB+/Sw0kFhHrNgE6YXAS
	 X7YIOK89PiXdn5cvA5F3/kY1HPHdNl8QvWrvR6SDCJRcGSsp6RtTBAbBV15qubNeuL
	 xmUf2rrMZhlhy6G5OMgHEiYYat52erjKv+dXbiJnZMln0cVEGZPOQd65uPBXY3qITb
	 fONfL0zODcROGbtgRY26TNXTIeV8n1uE/0DWPMMcpT5q+Tt1lqacIG7TBiw5fqc09N
	 zXbL/Cld8D9fnos7eaFjfGev2OaoYI5MLN61aTpmfNMhR3eU1fyITvJV0Oa2XJSDrl
	 nr+6LQiv6+ChA==
Date: Thu, 14 Dec 2023 13:35:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/19] xfs: fold xfs_rtallocate_extent into
 xfs_bmap_rtalloc
Message-ID: <20231214213538.GJ361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-20-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-20-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:38AM +0100, Christoph Hellwig wrote:
> There isn't really much left in xfs_rtallocate_extent now, fold it into
> the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, what a nice cleanup!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 67 ++++++++++++--------------------------------
>  1 file changed, 18 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 16255617629ef5..cbcdf604756fd3 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1063,53 +1063,6 @@ xfs_growfs_rt(
>  	return error;
>  }
>  
> -/*
> - * Allocate an extent in the realtime subvolume, with the usual allocation
> - * parameters.  The length units are all in realtime extents, as is the
> - * result block number.
> - */
> -static int
> -xfs_rtallocate_extent(
> -	struct xfs_trans	*tp,
> -	xfs_rtxnum_t		start,	/* starting rtext number to allocate */
> -	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
> -	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
> -	xfs_rtxlen_t		*len,	/* out: actual length allocated */
> -	int			wasdel,	/* was a delayed allocation extent */
> -	xfs_rtxlen_t		prod,	/* extent product factor */
> -	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
> -{
> -	struct xfs_rtalloc_args	args = {
> -		.mp		= tp->t_mountp,
> -		.tp		= tp,
> -	};
> -	int			error;	/* error value */
> -
> -	ASSERT(xfs_isilocked(args.mp->m_rbmip, XFS_ILOCK_EXCL));
> -	ASSERT(minlen > 0 && minlen <= maxlen);
> -
> -	if (start == 0) {
> -		error = xfs_rtallocate_extent_size(&args, minlen,
> -				maxlen, len, prod, rtx);
> -	} else {
> -		error = xfs_rtallocate_extent_near(&args, start, minlen,
> -				maxlen, len, prod, rtx);
> -	}
> -	xfs_rtbuf_cache_relse(&args);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * If it worked, update the superblock.
> -	 */
> -	ASSERT(*len >= minlen && *len <= maxlen);
> -	if (wasdel)
> -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FREXTENTS, -(long)*len);
> -	else
> -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, -(long)*len);
> -	return 0;
> -}
> -
>  /*
>   * Initialize realtime fields in the mount structure.
>   */
> @@ -1374,6 +1327,10 @@ xfs_bmap_rtalloc(
>  	xfs_rtxlen_t		raminlen;
>  	bool			rtlocked = false;
>  	bool			ignore_locality = false;
> +	struct xfs_rtalloc_args	args = {
> +		.mp		= mp,
> +		.tp		= ap->tp,
> +	};
>  	int			error;
>  
>  	align = xfs_get_extsz_hint(ap->ip);
> @@ -1406,6 +1363,8 @@ xfs_bmap_rtalloc(
>  	 */
>  	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
>  	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
> +	ASSERT(raminlen > 0);
> +	ASSERT(raminlen <= ralen);
>  
>  	/*
>  	 * Lock out modifications to both the RT bitmap and summary inodes
> @@ -1447,8 +1406,15 @@ xfs_bmap_rtalloc(
>  			xfs_rtalloc_align_minmax(&raminlen, &ralen, &prod);
>  	}
>  
> -	error = xfs_rtallocate_extent(ap->tp, start, raminlen, ralen, &ralen,
> -			ap->wasdel, prod, &rtx);
> +	if (start) {
> +		error = xfs_rtallocate_extent_near(&args, start, raminlen,
> +				ralen, &ralen, prod, &rtx);
> +	} else {
> +		error = xfs_rtallocate_extent_size(&args, raminlen,
> +				ralen, &ralen, prod, &rtx);
> +	}
> +	xfs_rtbuf_cache_relse(&args);
> +
>  	if (error == -ENOSPC) {
>  		if (align > mp->m_sb.sb_rextsize) {
>  			/*
> @@ -1480,6 +1446,9 @@ xfs_bmap_rtalloc(
>  	if (error)
>  		return error;
>  
> +	xfs_trans_mod_sb(ap->tp, ap->wasdel ?
> +			XFS_TRANS_SB_RES_FREXTENTS : XFS_TRANS_SB_FREXTENTS,
> +			-(long)ralen);
>  	ap->blkno = xfs_rtx_to_rtb(mp, rtx);
>  	ap->length = xfs_rtxlen_to_extlen(mp, ralen);
>  	xfs_bmap_alloc_account(ap);
> -- 
> 2.39.2
> 
> 
