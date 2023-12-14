Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAFC347A1
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSy0IhzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06295C433C7;
	Thu, 14 Dec 2023 21:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702589046;
	bh=NVNIeavcQxGhTMG6iVnzhp9p9QJr917c67ex4G5D9zY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fSy0IhzOYKtqyfYc0KhnwJPDokHsc7mUI64Jt1JLDiALxocXraTKamr41nobUv8Af
	 XhvnNmk/a3n6lKgK1AOg46CvORvHwdlFqUM+XK5WGSPfVozmheuFBe0Fx9dWufdhg2
	 8vaofg6uranPW8MfcIuanhf3tYzvR+0U2a8ed8MavW/SFov026z+ydI5PPnJwgX43U
	 i4giBRjdkk461Dqt2GH6opIgeD3cmycB+linXq4JxzFyMYHzMYHuDBPA6k6nYzh8Ou
	 iv25BLLjlNKncA1n7kAzip8A+SwikQE3le3pAvMetfbmumqjaLu6Z7vdI4fu+1/sWj
	 R1OMxgUrZLK/g==
Date: Thu, 14 Dec 2023 13:24:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/19] xfs: reorder the minlen and prod calculations in
 xfs_bmap_rtalloc
Message-ID: <20231214212405.GG361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-18-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:36AM +0100, Christoph Hellwig wrote:
> xfs_bmap_rtalloc is a bit of a mess in terms of calculating the locally
> need variables.  Reorder them a bit so that related code is located
> next to each other - the raminlen calculation moves up next to where
> the maximum len is calculated, and all the prod calculation is move
> into a single place and rearranged so that the real prod calculation
> only happens when it actually is needed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks like a simple enough change,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 24d74c8b532e5f..595740d18dc4c3 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1369,7 +1369,6 @@ xfs_bmap_rtalloc(
>  
>  	align = xfs_get_extsz_hint(ap->ip);
>  retry:
> -	prod = xfs_extlen_to_rtxlen(mp, align);
>  	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
>  					align, 1, ap->eof, 0,
>  					ap->conv, &ap->offset, &ap->length);
> @@ -1387,13 +1386,6 @@ xfs_bmap_rtalloc(
>  	if (ap->offset != orig_offset)
>  		minlen += orig_offset - ap->offset;
>  
> -	/*
> -	 * If the offset & length are not perfectly aligned
> -	 * then kill prod, it will just get us in trouble.
> -	 */
> -	div_u64_rem(ap->offset, align, &mod);
> -	if (mod || ap->length % align)
> -		prod = 1;
>  	/*
>  	 * Set ralen to be the actual requested length in rtextents.
>  	 *
> @@ -1404,6 +1396,7 @@ xfs_bmap_rtalloc(
>  	 * adjust the starting point to match it.
>  	 */
>  	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
> +	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
>  
>  	/*
>  	 * Lock out modifications to both the RT bitmap and summary inodes
> @@ -1432,7 +1425,16 @@ xfs_bmap_rtalloc(
>  		start = 0;
>  	}
>  
> -	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
> +	/*
> +	 * Only bother calculating a real prod factor if offset & length are
> +	 * perfectly aligned, otherwise it will just get us in trouble.
> +	 */
> +	div_u64_rem(ap->offset, align, &mod);
> +	if (mod || ap->length % align)
> +		prod = 1;
> +	else
> +		prod = xfs_extlen_to_rtxlen(mp, align);
> +
>  	error = xfs_rtallocate_extent(ap->tp, start, raminlen, ralen, &ralen,
>  			ap->wasdel, prod, &rtx);
>  	if (error == -ENOSPC) {
> -- 
> 2.39.2
> 
> 
