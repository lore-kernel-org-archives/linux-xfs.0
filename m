Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEADCD52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714599108; cv=none; b=Ya9kBmEV1/hZ5kPTQxLtFER2AxOzMNhKW/rD99jiTsGa55pL3GjYAgd0ebF37pToYEJfAxbGTyXHDKavmiAJjyhJOEWU7ZPpTdcxM7MdL1eOrqTTRr6JVxkI9zy8cOl+RBucoO47UoX7SmqDx2OXxDa9j1wvxMe4UdZjxeMkon8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714599108; c=relaxed/simple;
	bh=Ecc/gUqzc4/gNLIt4p+JUIcvj0qmWjIDzH8xoWVXSq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQw/OpLqZSqHab/G+S7mfb38lpgs497d4j6io8PwEY3LdtTv0pogGpAxVLa3Z7DPVIL6tTSd8lzeMjxwvSM58PVi1gyrovFtl8p9Qx2LxJfBuhSKsTdXI7Bw9uhxgmw6vFklu4whlsiUc2YDivT8BNtZrDSPip6V3HybtPcOLVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ks4XK5Xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ks4XK5Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43991C072AA;
	Wed,  1 May 2024 21:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714599108;
	bh=Ecc/gUqzc4/gNLIt4p+JUIcvj0qmWjIDzH8xoWVXSq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ks4XK5Xmv+gLRGHAraUFcEwQSt5vrTyEKIQ2s5BGKw7nMhLbVltTfa7ivnoaELeZ4
	 SGK5ROnTTZGmQJ20iF2hTEifo5K65f3M0j0FCBe/RJIyDtW/WLP/o2EjItCb0SUCIg
	 ABHGeytuXCH/WkW6Yv/mcmCZRLfZ8JDDeJT9oHjYEqa1iO1Sgi7eC0aEo70Pkiu7sy
	 5SgE1xpiQA7/qowdIyk7kNlg2VJ6rBk/uyXRVeYPyE03CzV/iCI05rBVYiUY+XM56k
	 NW3CAlV7HIyUagrBjNSlYltoF7kTHO0o431F6lLJHfmQ5XUXwFTZjSHepBWM63kBa6
	 psqasb+5Q52Vw==
Date: Wed, 1 May 2024 14:31:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] xfs: factor out a xfs_dir2_sf_addname_common helper
Message-ID: <20240501213147.GA360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-13-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:22PM +0200, Christoph Hellwig wrote:
> Move the common code between the easy and hard cases into a common helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 48 +++++++++++++++++++------------------
>  1 file changed, 25 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 1e1dcdf83b8f95..43e1090082b45d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -360,6 +360,27 @@ xfs_dir2_try_block_to_sf(
>  	return error;
>  }
>  
> +static void
> +xfs_dir2_sf_addname_common(
> +	struct xfs_da_args	*args,
> +	struct xfs_dir2_sf_entry *sfep,
> +	xfs_dir2_data_aoff_t	offset,
> +	bool			objchange)

Hmm.  @objchange==true in the _hard() case means that we already
converted the sf dir to ino8 format, right?  So that's why we don't need
to increment i8count?

If the answers are yes and yes, then
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
> +
> +	sfep->namelen = args->namelen;
> +	xfs_dir2_sf_put_offset(sfep, offset);
> +	memcpy(sfep->name, args->name, sfep->namelen);
> +	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
> +	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
> +	sfp->count++;
> +	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
> +		sfp->i8count++;
> +}
> +
>  /*
>   * Add a name to a shortform directory.
>   * There are two algorithms, "easy" and "hard" which we decide on
> @@ -476,21 +497,7 @@ xfs_dir2_sf_addname_easy(
>  	 * Need to set up again due to realloc of the inode data.
>  	 */
>  	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + byteoff);
> -	/*
> -	 * Fill in the new entry.
> -	 */
> -	sfep->namelen = args->namelen;
> -	xfs_dir2_sf_put_offset(sfep, offset);
> -	memcpy(sfep->name, args->name, sfep->namelen);
> -	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
> -	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
> -
> -	/*
> -	 * Update the header and inode.
> -	 */
> -	sfp->count++;
> -	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM)
> -		sfp->i8count++;
> +	xfs_dir2_sf_addname_common(args, sfep, offset, false);
>  	dp->i_disk_size = new_isize;
>  	xfs_dir2_sf_check(args);
>  }
> @@ -562,17 +569,12 @@ xfs_dir2_sf_addname_hard(
>  	nbytes = (int)((char *)oldsfep - (char *)oldsfp);
>  	memcpy(sfp, oldsfp, nbytes);
>  	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + nbytes);
> +
>  	/*
>  	 * Fill in the new entry, and update the header counts.
>  	 */
> -	sfep->namelen = args->namelen;
> -	xfs_dir2_sf_put_offset(sfep, offset);
> -	memcpy(sfep->name, args->name, sfep->namelen);
> -	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
> -	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
> -	sfp->count++;
> -	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
> -		sfp->i8count++;
> +	xfs_dir2_sf_addname_common(args, sfep, offset, objchange);
> +
>  	/*
>  	 * If there's more left to copy, do that.
>  	 */
> -- 
> 2.39.2
> 
> 
