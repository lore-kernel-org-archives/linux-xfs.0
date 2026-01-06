Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17EC338934;
	Tue,  6 Jan 2026 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714027; cv=none; b=LyqQv5Px5TGcTxmkt3855Gv7RFa9Dtyqho5vKqnBJ+lAvf3O1sLpErxMV0eS5u/MGAaO43S6KXZuyuTyb1HLZ4ca9tKp/bG8MZY8zMgsaXigta4+OrhmuKWdXlOEiIq7DuwwxSxrXg0/AARV8PCOwf5vxEeg/7lU2Dzy4Kyj7RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714027; c=relaxed/simple;
	bh=e/Pd51QZJsB3AAH06hxHf84t4DaW0yiwh7A150JKxsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJewfQlO6YLeCgcb9jeVO5rqI2AhgIWub8wui8PIqDrGvAA2EgX6nmiLX/ZsdO2kB/2IIbjFIKFz4CGDIy8NRkGz+1GGSsV3xawyM16/IBFJwCJShQ/lFgHFwL1EcUqnanVsWKxNtPjM9m5BHi0jhQl4C9NSS0QNGdGvtS18DOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+IlqTQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+IlqTQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD9BC116C6;
	Tue,  6 Jan 2026 15:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767714027;
	bh=e/Pd51QZJsB3AAH06hxHf84t4DaW0yiwh7A150JKxsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F+IlqTQXZhRGr2PJvjJ82Sn9NPcodFHAneobNo28/vR1R5s9e0bdpNptKP+1Kl0b7
	 HmxDOzsS/dsSJPotJVI/N1j/z9EXx9Nqquk970VVSMYY5UOy0V2XPSb1W7IXgz3F4a
	 0Xe/mJMWvGtbA7L7o/TZ1Isdg/LuBdvVSaNbd3q0aaX/N3+NX+ata1eazN8mgLp944
	 NPssXMAk8ExrhSqv7mo4KkREPseRSrETjJBbfjFWMAuPnuTSTx7BH7xD49DnCHxiDr
	 5/QtkKaP5t1F6U7ef+3C51I1gN5xzDwx3er0aT+rWhsVKw0nlZbf0Mk5puVkGjWpEG
	 Dnl0UnGOfnl5g==
Date: Tue, 6 Jan 2026 07:40:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix NULL ptr in xfs_attr_leaf_get
Message-ID: <20260106154026.GA191501@frogsfrogsfrogs>
References: <20251230190029.32684-1-mark.tinguely@oracle.com>
 <17cd5bef-e787-4dc9-9536-112d1e2cda2d@oracle.com>
 <aVzDNYiygzgjMAkA@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVzDNYiygzgjMAkA@infradead.org>

On Tue, Jan 06, 2026 at 12:09:25AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 30, 2025 at 01:02:41PM -0600, Mark Tinguely wrote:
> > 
> > The error path of xfs_attr_leaf_hasname() can leave a NULL
> > xfs_buf pointer. xfs_has_attr() checks for the NULL pointer but
> > the other callers do not.
> > 
> > We tripped over the NULL pointer in xfs_attr_leaf_get() but fix
> > the other callers too.
> > 
> > Fixes v5.8-rc4-95-g07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> > No reproducer.
> 
> Eww, what a mess.  I think we're better off to always leave releasing
> bp to the caller.  Something like the patch below.  Only compile tested
> for now, but I'll kick off an xfstests run.
> 
> Or maybe we might just kill off xfs_attr_leaf_hasname entirely and open
> code it in the three callers, which might end up being more readable?

...unless this is yet another case of the block layer returning ENODATA,
which is then mistaken for returning ENOATTR-but-here's-your-buffer by
the xfs_attr code?

--D

> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8c04acd30d48..c5259641dd97 100644
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
> @@ -951,6 +950,22 @@ xfs_attr_set_iter(
>  	return error;
>  }
>  
> +/*
> + * Return EEXIST if attr is found, or ENOATTR if not.
> + * Caller must relese @bp on error if non-NULL.
> + */
> +static int
> +xfs_attr_leaf_hasname(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf		**bp)
> +{
> +	int                     error;
> +
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, bp);
> +	if (error)
> +		return error;
> +	return xfs_attr3_leaf_lookup_int(*bp, args);
> +}
>  
>  /*
>   * Return EEXIST if attr is found, or ENOATTR if not
> @@ -980,10 +995,8 @@ xfs_attr_lookup(
>  
>  	if (xfs_attr_is_leaf(dp)) {
>  		error = xfs_attr_leaf_hasname(args, &bp);
> -
>  		if (bp)
>  			xfs_trans_brelse(args->trans, bp);
> -
>  		return error;
>  	}
>  
> @@ -1222,27 +1235,6 @@ xfs_attr_shortform_addname(
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
> @@ -1253,26 +1245,24 @@ STATIC int
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
>  	error = xfs_attr_leaf_hasname(args, &bp);
> -	if (error == -ENOATTR) {
> -		xfs_trans_brelse(args->trans, bp);
> -		if (args->op_flags & XFS_DA_OP_RECOVERY)
> +	if (error != -EEXIST) {
> +		if (bp)
> +			xfs_trans_brelse(args->trans, bp);
> +		if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
>  			return 0;
>  		return error;
> -	} else if (error != -EEXIST)
> -		return error;
> +	}
>  
> +	/*
> +	 * Remove the attribute.
> +	 */
>  	xfs_attr3_leaf_remove(bp, args);
>  
>  	/*
> @@ -1281,8 +1271,8 @@ xfs_attr_leaf_removename(
>  	forkoff = xfs_attr_shortform_allfit(bp, dp);
>  	if (forkoff)
>  		return xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -		/* bp is gone due to xfs_da_shrink_inode */
>  
> +	/* bp is gone due to xfs_da_shrink_inode */
>  	return 0;
>  }
>  
> @@ -1295,24 +1285,19 @@ xfs_attr_leaf_removename(
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
>  	error = xfs_attr_leaf_hasname(args, &bp);
> -
> -	if (error == -ENOATTR)  {
> +	if (error == -EEXIST)
> +		error = xfs_attr3_leaf_getvalue(bp, args);
> +	if (bp)
>  		xfs_trans_brelse(args->trans, bp);
> -		return error;
> -	} else if (error != -EEXIST)
> -		return error;
> -
> -
> -	error = xfs_attr3_leaf_getvalue(bp, args);
> -	xfs_trans_brelse(args->trans, bp);
>  	return error;
>  }
>  
> 
