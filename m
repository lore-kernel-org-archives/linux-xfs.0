Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B26129EFB
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 22:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQJLDOX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B2CC433C8;
	Mon, 18 Dec 2023 22:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702939069;
	bh=HORlQuy2wH3auU2Xj5cVhWIagKmnXxHVeJ1hFG0y69k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VQJLDOX5PN313+x99iR2rmj7xLW24g8hegJaPPJNSQ1oLm5czCd8Mvo7O6pQbaSHw
	 0YiujNMRTRL1J1u0fcAo3eO+msDbqDy42OE2Aw3FXqbEcypqs8dEm3+/9MhWoQkDTd
	 ZQIZHQYqYjABeaXvF5pJiZLXDyJJOLdymrQrS0ezg/2CIC3wsgSe2pSap443E+AHAj
	 iqyNWcfSFRJL//bbNOI2MhEbzmgkqzZn67fv0F7nv8cXobLcagEADidF+OoDZN8R3E
	 wRP21ZQ5ds6wcmqugRSjgPiov1wpplZAYV/th2KQOxAj66ShG5B0tl8Jt9yBnCsvJI
	 HM3XcX87gwclA==
Date: Mon, 18 Dec 2023 14:37:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: use xfs_attr_sf_findname in
 xfs_attr_shortform_getvalue
Message-ID: <20231218223748.GB361584@frogsfrogsfrogs>
References: <20231217170350.605812-1-hch@lst.de>
 <20231217170350.605812-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231217170350.605812-7-hch@lst.de>

On Sun, Dec 17, 2023 at 06:03:48PM +0100, Christoph Hellwig wrote:
> xfs_attr_shortform_getvalue duplicates the logic in xfs_attr_sf_findname.
> Use the helper instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 75c597805ffa8b..82e1830334160b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -848,23 +848,17 @@ int
>  xfs_attr_shortform_getvalue(
>  	struct xfs_da_args		*args)
>  {
> -	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
>  	struct xfs_attr_sf_entry	*sfe;
> -	int				i;
>  
>  	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
>  
>  	trace_xfs_attr_sf_lookup(args);
>  
> -	sfe = &sf->list[0];
> -	for (i = 0; i < sf->hdr.count;
> -				sfe = xfs_attr_sf_nextentry(sfe), i++) {
> -		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> -				sfe->flags))
> -			return xfs_attr_copy_value(args,
> -				&sfe->nameval[args->namelen], sfe->valuelen);
> -	}
> -	return -ENOATTR;
> +	sfe = xfs_attr_sf_findname(args);
> +	if (!sfe)
> +		return -ENOATTR;
> +	return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
> +			sfe->valuelen);
>  }
>  
>  /* Convert from using the shortform to the leaf format. */
> -- 
> 2.39.2
> 
> 
