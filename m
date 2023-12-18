Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF9C1D141
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 22:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o6aDyVot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A49C433C7;
	Mon, 18 Dec 2023 22:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702939046;
	bh=DJWtTbAB9O2RdY/BuxUP9iqgNF8tCfeHo/R/a8S/9Lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o6aDyVotemCVjMSeq0lsiyNi61UnS4U2zruJCH3TtAJ3Yehmd3qcHLi08M8WVimWe
	 DByGxE9dCE2O82f2/1qDIlkgiTn1u6gxfDZAtkhLpn6mcTec/gpvueDb5p2kDs1u4I
	 hXcvkCnTepXRI/rlM0yKXPJtAg5Eafvr0surihLyss17SuGv03xO738rzZed2aiMq4
	 9A1vA9Xk/p8cClUvWMCZxkHgJc1gCCUs0Q25wltZIm5FjlABoOrWpxNtNO5QA/QTt1
	 mIq+GLBNNNnqOHC6gheI2bv5Y2ly+/tO2C7Tna1X7NNsdAUfK/Os7ATJsp74Y2xSWJ
	 5dTh6F2Gz5j/w==
Date: Mon, 18 Dec 2023 14:37:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: remove xfs_attr_shortform_lookup
Message-ID: <20231218223725.GA361584@frogsfrogsfrogs>
References: <20231217170350.605812-1-hch@lst.de>
 <20231217170350.605812-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231217170350.605812-6-hch@lst.de>

On Sun, Dec 17, 2023 at 06:03:47PM +0100, Christoph Hellwig wrote:
> xfs_attr_shortform_lookup is only used by xfs_attr_shortform_addname,
> which is much better served by calling xfs_attr_sf_findname.  Switch
> it over and remove xfs_attr_shortform_lookup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 16 ++++------------
>  fs/xfs/libxfs/xfs_attr_leaf.c | 24 ------------------------
>  fs/xfs/libxfs/xfs_attr_leaf.h |  1 -
>  3 files changed, 4 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index bcf8748cb1a333..d6173888ed0d56 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1070,13 +1070,7 @@ xfs_attr_shortform_addname(
>  
>  	trace_xfs_attr_sf_addname(args);
>  
> -	error = xfs_attr_shortform_lookup(args);
> -	switch (error) {
> -	case -ENOATTR:
> -		if (args->op_flags & XFS_DA_OP_REPLACE)
> -			return error;
> -		break;
> -	case -EEXIST:
> +	if (xfs_attr_sf_findname(args)) {
>  		if (!(args->op_flags & XFS_DA_OP_REPLACE))
>  			return error;
>  
> @@ -1091,11 +1085,9 @@ xfs_attr_shortform_addname(
>  		 * around.
>  		 */
>  		args->op_flags &= ~XFS_DA_OP_REPLACE;
> -		break;
> -	case 0:
> -		break;
> -	default:
> -		return error;
> +	} else {
> +		if (args->op_flags & XFS_DA_OP_REPLACE)
> +			return error;
>  	}
>  
>  	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 7a623efd23a6a4..75c597805ffa8b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -837,30 +837,6 @@ xfs_attr_sf_removename(
>  	return 0;
>  }
>  
> -/*
> - * Look up a name in a shortform attribute list structure.
> - */
> -/*ARGSUSED*/
> -int
> -xfs_attr_shortform_lookup(
> -	struct xfs_da_args		*args)
> -{
> -	struct xfs_ifork		*ifp = &args->dp->i_af;
> -	struct xfs_attr_shortform	*sf = ifp->if_data;
> -	struct xfs_attr_sf_entry	*sfe;
> -	int				i;
> -
> -	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
> -	sfe = &sf->list[0];
> -	for (i = 0; i < sf->hdr.count;
> -				sfe = xfs_attr_sf_nextentry(sfe), i++) {
> -		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> -				sfe->flags))
> -			return -EEXIST;
> -	}
> -	return -ENOATTR;
> -}
> -
>  /*
>   * Retrieve the attribute value and length.
>   *
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 56fcd689eedfe7..35e668ae744fb1 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -47,7 +47,6 @@ struct xfs_attr3_icleaf_hdr {
>   */
>  void	xfs_attr_shortform_create(struct xfs_da_args *args);
>  void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
> -int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
>  int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
>  int	xfs_attr_sf_removename(struct xfs_da_args *args);
> -- 
> 2.39.2
> 
> 
