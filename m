Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBDC4D5BF
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714600257; cv=none; b=F+euK07CBzhw0gb6gVmMyoZgGp7OXELVSLFfpJgEVeyzX6vyanCdtZlxZGuZRSqpkrr4ih1GYw4gmGrnN1f1w0jLyh0+A+jkUCTBM4jspD+jDm2uF1Mb+rtbcBKMZgKNgBMa8Xln9PiMB4jaqxzOy7Wj95inkPQUKteVA4kLDTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714600257; c=relaxed/simple;
	bh=W+u8mB7N7dwsFP5sywvOWzoy2roUtl6o0a68RRknSO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSvyQAl2jPApcDgJ8je8tjCL5QPcXU9rdyqQAxF1TAYswvSzIh5L7bTB/0p0qz4wZLKsy3QouYzCXkMQmKvC/P0ijH2quxudjVd56Il6uixs14/lkQow4tDseqAQwjOM+a+QU2vxEw85AGafcxMHwpu99RcA4QvtxTC8ZQVGPFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kebDnnIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kebDnnIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03670C32789;
	Wed,  1 May 2024 21:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714600257;
	bh=W+u8mB7N7dwsFP5sywvOWzoy2roUtl6o0a68RRknSO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kebDnnIT/PVKHmoo6qQqHCB9J/SVuLjhpwKOKR30lmVaclg/pvoKCkCLs6LH6Hfo6
	 crpI//QgfCiKR9Nu4+7rE89ye92lIydKZz+8blYNh3jfIf7Pmi0d5uhqt1+vPL2HQa
	 yyBCMY1ff7oAX9BYKUzDarFrgjDvbNkGgAhjl0tUIbXHf5VAZIEXW+O9LkHyKzsf8s
	 TfOIg+7D5E1AnBUClnWHgYlCbY/BkIueP+0IZlFa7DEATpZI1wV0QBXU76x35eFxr6
	 yjyTDEoEN050zTDnqAAqegkEtXYltUBevJ2Fn3EQxnxzc4XviqKc+LOMEn1gKW0cgR
	 xkvsFKE15n+SA==
Date: Wed, 1 May 2024 14:50:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/16] xfs: optimize adding the first 8-byte inode to a
 shortform directory
Message-ID: <20240501215056.GD360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-15-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:24PM +0200, Christoph Hellwig wrote:
> When adding a new entry to a shortform directory we have to convert the
> format of the entire inode fork if the new entry is the first 8-byte
> inode number.
> 
> Instead of allocating a new buffer to convert the format, and then
> possible another one when doing an insert in the middle of the directory,
> simply add the new entry while converting the format and avoid the
> extra allocation.
> 
> For this to work, xfs_dir2_sf_addname_pick also has to return the
> offset for the hard case, but this is entirely trivial.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 46 +++++++++++++++++++++++++++++++++----
>  1 file changed, 41 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index a9d614dfb9e43b..02aa176348a795 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -35,7 +35,8 @@ static void xfs_dir2_sf_check(xfs_da_args_t *args);
>  #endif /* DEBUG */
>  
>  static void xfs_dir2_sf_toino4(struct xfs_da_args *args, bool remove);
> -static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
> +static void xfs_dir2_sf_toino8(struct xfs_da_args *args,
> +		xfs_dir2_data_aoff_t offset);

I noticed a few places where we pass offset == 0 here.  That's ok as a
null value because the start of a shortform directory is always the
header, correct?

>  
>  int
>  xfs_dir2_sf_entsize(
> @@ -450,6 +451,16 @@ xfs_dir2_sf_addname(
>  	 */
>  	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
>  		return 0;
> +
> +	/*
> +	 * If we need convert to 8-byte inodes, piggy back adding the new entry
> +	 * to the rewrite of the fork to fit the large inode number.
> +	 */
> +	if (objchange) {
> +		xfs_dir2_sf_toino8(args, offset);
> +		return 0;
> +	}
> +
>  	/*
>  	 * Do it the easy way - just add it at the end.
>  	 */
> @@ -461,8 +472,6 @@ xfs_dir2_sf_addname(
>  	 */
>  	else {
>  		ASSERT(pick == 2);
> -		if (objchange)
> -			xfs_dir2_sf_toino8(args);

Ok, so this isn't needed anymore because the ino8 conversion now adds
the new dirent?

>  		xfs_dir2_sf_addname_hard(args, objchange, new_isize);
>  	}
>  
> @@ -622,6 +631,8 @@ xfs_dir2_sf_addname_pick(
>  	for (i = 0; i < sfp->count; i++) {
>  		if (!holefit)
>  			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
> +		if (holefit)
> +			*offsetp = offset;
>  		offset = xfs_dir2_sf_get_offset(sfep) +
>  			 xfs_dir2_data_entsize(mp, sfep->namelen);
>  		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
> @@ -1053,7 +1064,7 @@ xfs_dir2_sf_replace(
>  		/*
>  		 * Still fits, convert to 8-byte now.
>  		 */
> -		xfs_dir2_sf_toino8(args);
> +		xfs_dir2_sf_toino8(args, 0);

This is a replace, so we pass 0 here effectively as a null value?

>  		i8elevated = 1;
>  		sfp = dp->i_df.if_data;
>  	} else
> @@ -1205,7 +1216,8 @@ xfs_dir2_sf_toino4(
>   */
>  static void
>  xfs_dir2_sf_toino8(
> -	xfs_da_args_t		*args)		/* operation arguments */
> +	struct xfs_da_args	*args,
> +	xfs_dir2_data_aoff_t	new_offset)

Yeah, the comment for this function should note that new_offset!=0 means
to add the entry referenced in the args structure.

>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
> @@ -1213,6 +1225,7 @@ xfs_dir2_sf_toino8(
>  	int			oldsize = dp->i_df.if_bytes;
>  	int			i;		/* entry index */
>  	int			newsize;	/* new inode size */
> +	unsigned int		newent_size;
>  	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
>  	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
>  	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
> @@ -1225,6 +1238,18 @@ xfs_dir2_sf_toino8(
>  	 * Compute the new inode size (nb: entry count + 1 for parent)
>  	 */
>  	newsize = oldsize + (oldsfp->count + 1) * XFS_INO64_DIFF;
> +	if (new_offset) {
> +		/*
> +		 * Account for the bytes actually used.
> +		 */
> +		newsize += xfs_dir2_sf_entsize(mp, oldsfp, args->namelen);
> +
> +		/*
> +		 * But for the offset calculation use the bigger data entry
> +		 * format.
> +		 */
> +		newent_size = xfs_dir2_data_entsize(mp, args->namelen);

		/*
		 * Bump up the buffer size by the size of the new
		 * dirent.  Now that we've set i8count, compute the size
		 * of the new dirent.
		 */
		newsize += xfs_dir2_sf_entsize(mp, oldsfp, args->namelen);
		newent_size = xfs_dir2_data_entsize(mp, args->namelen);

> +	}
>  
>  	dp->i_df.if_data = sfp = kmalloc(newsize, GFP_KERNEL | __GFP_NOFAIL);
>  	dp->i_df.if_bytes = newsize;
> @@ -1250,6 +1275,17 @@ xfs_dir2_sf_toino8(
>  				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
>  		xfs_dir2_sf_put_ftype(mp, sfep,
>  				xfs_dir2_sf_get_ftype(mp, oldsfep));
> +
> +		/*
> +		 * If there is a new entry to add it once we reach the specified
> +		 * offset.

It took me a minute of staring at the if test logic to figure out what
we're doing here.  If, after, reformatting a directory entry, the next
entry is the offset where _pick wants us to place the new dirent, we
should jump sfep to the next entry, and then add the new entry.

Is that right?  And we can't simplify the logic to:

	if (new_offset && new_offset = xfs_dir2_sf_get_offset(sfep))

Because _pick might want us to add the entry at the end of the directory
but we haven't incremented sfp->count yet, so the loop body will not be
executed in that case.

Is it ever the case that the entry get added in the middle of a
shortform directory?

--D

> +		 */
> +		if (new_offset &&
> +		    new_offset == xfs_dir2_sf_get_offset(sfep) + newent_size) {
> +			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
> +			xfs_dir2_sf_addname_common(args, sfep, new_offset,
> +					true);
> +		}
>  	}
>  
>  	kfree(oldsfp);
> -- 
> 2.39.2
> 
> 
