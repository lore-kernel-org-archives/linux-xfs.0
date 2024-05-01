Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9878AD52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598720; cv=none; b=CSz5oaUx0F3XVKb3KYoLbiylvOSIIPVeNqIBFmmGAwcPuggaQQdIi9V7SAjyv/UN6psed9fclrG1OSQgJUbQD0rTY9IprTmIpV03CQ0cyiYkm4bDUVJ21ZFUCLVmqggM55FlLMWq6RNkJIyU2T2WnrEYfwbvjix1IKKgeLHStJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598720; c=relaxed/simple;
	bh=6S3CGg5/9/TicSDcr/lXOyi+fgEuJNI2Hql9pc0EnGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UZfyQ6h8wfhbVMvFZf4viJgea9pNOy0+LnRMgIjNo56c8EPnOXPoy+/7ZsuC0HYbZhfeVlGUOVwPd0iCGGvcgoZ4K6NZnvcOlssQu05DvGyYqapSoB+wYe2DFvVAppp14hOSTxU9NWNqnl8mgcrpaxlvYZ/DagimuaQHB6SUlPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIVlWmMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIVlWmMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B01C072AA;
	Wed,  1 May 2024 21:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714598720;
	bh=6S3CGg5/9/TicSDcr/lXOyi+fgEuJNI2Hql9pc0EnGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NIVlWmMojA6E0jOK/R+kVt+LDPCLOYeZknHG43knQCol6EXzPCad4PWV67MgzStU2
	 gGHZtTHxhxOcsLmjhgUyEsaEwrqH9vU8T1/1cdpUHltLWz5ISAQfarVjYxKur8K1MM
	 +/9b3lQBKz7Iv7H9lz+MKaXOzMZzYIcy8uwcMbTGfczo8qcjhTTnhxgW9le2tgNiHb
	 eUeDLfCIxIbsiTayunuZHtmLHgXsEAWUCEtrjbFbLeaIDF6R0DpsZ18dZvsYxQpGIV
	 kWq5oXjdQO73hhuz1eieLjxjrjA62z4LXOWgYcs300J1pRRsZ6gtrWBtCW0/+1TJxC
	 1Y0uqc/5tr8NQ==
Date: Wed, 1 May 2024 14:25:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/16] xfs: optimize removing the last 8-byte inode from
 a shortform directory
Message-ID: <20240501212519.GY360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-11-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:20PM +0200, Christoph Hellwig wrote:
> When removing the last 8-byte inode, xfs_dir2_sf_removename calls
> xfs_dir2_sf_toino4 after removing the entry.  This is rather inefficient
> as it causes two buffer realloacations.  Instead of that pass a bool
> argument to xfs_dir2_sf_toino4 so that it can remove the entry pointed
> to by args as part of the conversion and use that to shortcut the
> process.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 41 ++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 3b6d6dda92f29f..21e04594606b89 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -34,7 +34,7 @@ static void xfs_dir2_sf_check(xfs_da_args_t *args);
>  #define	xfs_dir2_sf_check(args)
>  #endif /* DEBUG */
>  
> -static void xfs_dir2_sf_toino4(xfs_da_args_t *args);
> +static void xfs_dir2_sf_toino4(struct xfs_da_args *args, bool remove);
>  static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
>  
>  int
> @@ -935,6 +935,15 @@ xfs_dir2_sf_removename(
>  	ASSERT(dp->i_df.if_bytes == oldsize);
>  	ASSERT(oldsize >= xfs_dir2_sf_hdr_size(sfp->i8count));
>  
> +	/*
> +	 * If this is the last 8-byte, directly convert to the 4-byte format
> +	 * and just skip the removed entry when building the new fork.
> +	 */
> +	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 1) {
> +		xfs_dir2_sf_toino4(args, true);
> +		return 0;
> +	}
> +
>  	/*
>  	 * Loop over the old directory entries.
>  	 * Find the one we're deleting.
> @@ -980,10 +989,8 @@ xfs_dir2_sf_removename(
>  	 * Are we changing inode number size?
>  	 */
>  	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM) {
> -		if (sfp->i8count == 1)
> -			xfs_dir2_sf_toino4(args);
> -		else
> -			sfp->i8count--;
> +		ASSERT(sfp->i8count > 1);
> +		sfp->i8count--;
>  	}
>  	xfs_dir2_sf_check(args);
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
> @@ -1087,7 +1094,7 @@ xfs_dir2_sf_replace(
>  		if (i == sfp->count) {
>  			ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
>  			if (i8elevated)
> -				xfs_dir2_sf_toino4(args);
> +				xfs_dir2_sf_toino4(args, false);
>  			return -ENOENT;
>  		}
>  	}
> @@ -1100,7 +1107,7 @@ xfs_dir2_sf_replace(
>  		 * And the old count was one, so need to convert to small.
>  		 */
>  		if (sfp->i8count == 1)
> -			xfs_dir2_sf_toino4(args);
> +			xfs_dir2_sf_toino4(args, false);
>  		else
>  			sfp->i8count--;
>  	}
> @@ -1128,7 +1135,8 @@ xfs_dir2_sf_replace(
>   */
>  static void
>  xfs_dir2_sf_toino4(
> -	xfs_da_args_t		*args)		/* operation arguments */
> +	struct xfs_da_args	*args,
> +	bool			remove)
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
> @@ -1148,6 +1156,8 @@ xfs_dir2_sf_toino4(
>  	 * Compute the new inode size.
>  	 */
>  	newsize = oldsize - (oldsfp->count + 1) * XFS_INO64_DIFF;
> +	if (remove)
> +		newsize -= xfs_dir2_sf_entsize(mp, oldsfp, args->namelen);
>  
>  	dp->i_df.if_data = sfp = kmalloc(newsize, GFP_KERNEL | __GFP_NOFAIL);
>  	dp->i_df.if_bytes = newsize;
> @@ -1166,11 +1176,22 @@ xfs_dir2_sf_toino4(
>  	     i < sfp->count;
>  	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
>  		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
> +		xfs_ino_t ino = xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep);
> +
> +		/*
> +		 * Just skip over the entry that is removed if there is one.
> +		 */
> +		if (remove && args->inumber == ino) {
> +			oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep);
> +			sfp->count--;
> +			if (++i == sfp->count)
> +				break;
> +		}

What happens if a shortform directory contains two entries to the same
file?  I think @remove really means that the caller has verified that
the sf directory only contains one link @args->inumber?  If that's so,
then the comment for this function should say that.

--D

> +
>  		sfep->namelen = oldsfep->namelen;
>  		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
>  		memcpy(sfep->name, oldsfep->name, sfep->namelen);
> -		xfs_dir2_sf_put_ino(mp, sfp, sfep,
> -				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> +		xfs_dir2_sf_put_ino(mp, sfp, sfep, ino);
>  		xfs_dir2_sf_put_ftype(mp, sfep,
>  				xfs_dir2_sf_get_ftype(mp, oldsfep));
>  	}
> -- 
> 2.39.2
> 
> 
