Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3132222C0
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976152; cv=none; b=kWRnvzBCT4Yx+vdlcTlCb5lvoz+5mFoMSjU97ukDukeBDtUcDroKDAYoHmvafObXP9l33FBIwA2Z/1oyMfvr1/1UH/a5TPwSVvxpjH07kbVE8YAiowFykwy1I0p3HOPcIIaAXjJcPGOhOoKyimZMLTg1J6P49vMoq8sToRolWHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976152; c=relaxed/simple;
	bh=fwpwuxMvPTe/6g6kCDy9lf0zdppbVwlvbf0pr/j0Pj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIbxFycWgDSdUjDm+9+xizpIoRVZGpLKux5TNfa4akJZLynxTgM53UKcziTmOKqnCNFHu9ENruHA1YSoCZcibwu4yWP4ohCMgIOtU1axynuT5dpEvNsRToLh15P3riWmu0LgB4mqrmke67vf/uEEVG3qKuqwz1tK7Wsgoydw9/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TB/owMzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TB/owMzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72CEC4CEF1;
	Fri,  9 Jan 2026 16:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767976151;
	bh=fwpwuxMvPTe/6g6kCDy9lf0zdppbVwlvbf0pr/j0Pj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TB/owMzODmN538aOUAgDTxH22I/3DiS64ICDA7ivAMAqMghldchUlrFkHIZ2sw0vj
	 1Esb6B9fq/tiCwohm5CPnXUFBw+OK3qX1y1O8GNhtyJqTjzXaF4YcmHsEQuLFV9b5I
	 H56xE6g5HgxLqwI1sHZy2groCJs/zb+R7alWS1yNI3lUfIG310mtg8vUUjqXpMWxDs
	 hkyqOt+Mv4msnk/9w0hhTN2R7qEzBqTMyF59RqYJ16BbG3ec1OxHFxYzSglswQsBFq
	 t/S+D1mxmrI8gKEfP6J7JrfVE7QhmIZ1ddaOZ8tdx7cJePlXDArsfziMAHKKsq3RRU
	 tDeWK57o+0FXw==
Date: Fri, 9 Jan 2026 08:29:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
Subject: Re: [PATCH] xfs: remove xfs_attr_leaf_hasname
Message-ID: <20260109162911.GR15551@frogsfrogsfrogs>
References: <20260109151741.2376835-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109151741.2376835-1-hch@lst.de>

On Fri, Jan 09, 2026 at 04:17:40PM +0100, Christoph Hellwig wrote:
> The calling convention of xfs_attr_leaf_hasname() is problematic, because
> it returns a NULL buffer when xfs_attr3_leaf_read fails, a valid buffer
> when xfs_attr3_leaf_lookup_int returns -ENOATTR or -EEXIST, and a
> non-NULL buffer pointer for an already released buffer when
> xfs_attr3_leaf_lookup_int fails with other error values.
> 
> Fix this by simply open coding xfs_attr_leaf_hasname in the callers, so
> that the buffer release code is done by each caller of
> xfs_attr3_leaf_read.
> 
> X-Cc: stable@vger.kernel.org # v5.19+
> Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> Reported-by: Mark Tinguely <mark.tinguely@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Blerrgh, xfs_attr3_leaf_lookup_int encoding results with error numbers
makes my brain hurt every time I look at the xattr code... but this
patch is (afaict) a correct way to avoid the **bp state confusion
presented by xfs_attr_leaf_hasname.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 75 +++++++++++++---------------------------
>  1 file changed, 24 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8c04acd30d48..b88e65c7e45d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -50,7 +50,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  
>  /*
>   * Internal routines when attribute list is more than one block.
> @@ -979,11 +978,12 @@ xfs_attr_lookup(
>  		return error;
>  
>  	if (xfs_attr_is_leaf(dp)) {
> -		error = xfs_attr_leaf_hasname(args, &bp);
> -
> -		if (bp)
> -			xfs_trans_brelse(args->trans, bp);
> -
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
> +				0, &bp);
> +		if (error)
> +			return error;
> +		error = xfs_attr3_leaf_lookup_int(bp, args);
> +		xfs_trans_brelse(args->trans, bp);
>  		return error;
>  	}
>  
> @@ -1222,27 +1222,6 @@ xfs_attr_shortform_addname(
>   * External routines when attribute list is one block
>   *========================================================================*/
>  
> -/*
> - * Return EEXIST if attr is found, or ENOATTR if not
> - */
> -STATIC int
> -xfs_attr_leaf_hasname(
> -	struct xfs_da_args	*args,
> -	struct xfs_buf		**bp)
> -{
> -	int                     error = 0;
> -
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, bp);
> -	if (error)
> -		return error;
> -
> -	error = xfs_attr3_leaf_lookup_int(*bp, args);
> -	if (error != -ENOATTR && error != -EEXIST)
> -		xfs_trans_brelse(args->trans, *bp);
> -
> -	return error;
> -}
> -
>  /*
>   * Remove a name from the leaf attribute list structure
>   *
> @@ -1253,25 +1232,22 @@ STATIC int
>  xfs_attr_leaf_removename(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_inode	*dp;
> -	struct xfs_buf		*bp;
> +	struct xfs_inode	*dp = args->dp;
>  	int			error, forkoff;
> +	struct xfs_buf		*bp;
>  
>  	trace_xfs_attr_leaf_removename(args);
>  
> -	/*
> -	 * Remove the attribute.
> -	 */
> -	dp = args->dp;
> -
> -	error = xfs_attr_leaf_hasname(args, &bp);
> -	if (error == -ENOATTR) {
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
> +	if (error)
> +		return error;
> +	error = xfs_attr3_leaf_lookup_int(bp, args);
> +	if (error != -EEXIST) {
>  		xfs_trans_brelse(args->trans, bp);
> -		if (args->op_flags & XFS_DA_OP_RECOVERY)
> +		if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
>  			return 0;
>  		return error;
> -	} else if (error != -EEXIST)
> -		return error;
> +	}
>  
>  	xfs_attr3_leaf_remove(bp, args);
>  
> @@ -1295,23 +1271,20 @@ xfs_attr_leaf_removename(
>   * Returns 0 on successful retrieval, otherwise an error.
>   */
>  STATIC int
> -xfs_attr_leaf_get(xfs_da_args_t *args)
> +xfs_attr_leaf_get(
> +	struct xfs_da_args	*args)
>  {
> -	struct xfs_buf *bp;
> -	int error;
> +	struct xfs_buf		*bp;
> +	int			error;
>  
>  	trace_xfs_attr_leaf_get(args);
>  
> -	error = xfs_attr_leaf_hasname(args, &bp);
> -
> -	if (error == -ENOATTR)  {
> -		xfs_trans_brelse(args->trans, bp);
> -		return error;
> -	} else if (error != -EEXIST)
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
> +	if (error)
>  		return error;
> -
> -
> -	error = xfs_attr3_leaf_getvalue(bp, args);
> +	error = xfs_attr3_leaf_lookup_int(bp, args);
> +	if (error == -EEXIST)
> +		error = xfs_attr3_leaf_getvalue(bp, args);
>  	xfs_trans_brelse(args->trans, bp);
>  	return error;
>  }
> -- 
> 2.47.3
> 
> 
