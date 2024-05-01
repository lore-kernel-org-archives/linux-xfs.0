Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CFAD52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598442; cv=none; b=VBvWdkQr1mXWGY+aADhkMx8WUjNftmfyCcGhLD7Kv7g/9txwYCgOONgD24ECn0DY7YevOLOl7WLMRSkR2M5wT8YpnbeEtfcg+MSqtWpciTtD53dObHrAq9rOOS9czKNyQvp1lrIAtD5j2F+YZdUx7OsUddzNJ1Vq5uC9RuxA2W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598442; c=relaxed/simple;
	bh=t+Fu1tc87bUM2TnVQxpmxOGHOoc5Z2TtLshTlbSqzDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7fOCBjZgKB2vUB2ve0eMLhb+mZjhgawesmkMKXRAw57m27nfsZmbbglhY33YPzgz78+FyqnSW5A2zTN0smjgnD3hoHkRd04/IjIDfhuVm6Ilg3QHS8/VmlfgYKnIApgNc9oQ03XRrkToJL7aXPCYQ95qUkezyVFn2OSpb0bWBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Txsuh1jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Txsuh1jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44414C072AA;
	Wed,  1 May 2024 21:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714598442;
	bh=t+Fu1tc87bUM2TnVQxpmxOGHOoc5Z2TtLshTlbSqzDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Txsuh1jy+/hsEnwnIUVqsKD1HJMPgJRflIWTyjqslevqjfGlobizdcqqqfDYNfBP4
	 3YAe4GbvPr+f1m83Ci7t/vppCquhfqsA6IA6j8ihDp+8z85l1J/9X3qosD6mKr3f9+
	 bTMl3E2ETKAOhNoTmnWkQfSIUWCR2ajOr1z/EjBOE1KZMe2rZ7Ep27n+tnZuElvNHB
	 XefHl4PYKVwh5dtLeHfc82/xvqk8xhpQp2NuHDtO4DzKaet83G98StibS+515byLOb
	 MTYn079A2sTCQdFCsVTvQoy86E5JCFdvN/lRItHvj7/zUHvwG4VeED4TfcH7fZOFvr
	 cedNuaguugjKQ==
Date: Wed, 1 May 2024 14:20:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/16] xfs: remove a superfluous memory allocation in
 xfs_dir2_sf_toino4
Message-ID: <20240501212041.GX360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-10-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:19PM +0200, Christoph Hellwig wrote:
> Transfer the temporary buffer allocation to the inode fork instead of
> copying to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks decent,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 29 ++++++++---------------------
>  1 file changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 87552c01260a1c..3b6d6dda92f29f 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -1133,36 +1133,25 @@ xfs_dir2_sf_toino4(
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_dir2_sf_hdr	*oldsfp = dp->i_df.if_data;
> -	char			*buf;		/* old dir's buffer */
> +	int			oldsize = dp->i_df.if_bytes;
>  	int			i;		/* entry index */
>  	int			newsize;	/* new inode size */
>  	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
> -	int			oldsize;	/* old inode size */
>  	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
>  	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
>  
>  	trace_xfs_dir2_sf_toino4(args);
>  
> -	/*
> -	 * Copy the old directory to the buffer.
> -	 * Then nuke it from the inode, and add the new buffer to the inode.
> -	 * Don't want xfs_idata_realloc copying the data here.
> -	 */
> -	oldsize = dp->i_df.if_bytes;
> -	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
>  	ASSERT(oldsfp->i8count == 1);
> -	memcpy(buf, oldsfp, oldsize);
> +
>  	/*
>  	 * Compute the new inode size.
>  	 */
>  	newsize = oldsize - (oldsfp->count + 1) * XFS_INO64_DIFF;
> -	xfs_idata_realloc(dp, -oldsize, XFS_DATA_FORK);
> -	xfs_idata_realloc(dp, newsize, XFS_DATA_FORK);
> -	/*
> -	 * Reset our pointers, the data has moved.
> -	 */
> -	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
> -	sfp = dp->i_df.if_data;
> +
> +	dp->i_df.if_data = sfp = kmalloc(newsize, GFP_KERNEL | __GFP_NOFAIL);
> +	dp->i_df.if_bytes = newsize;
> +
>  	/*
>  	 * Fill in the new header.
>  	 */
> @@ -1185,10 +1174,8 @@ xfs_dir2_sf_toino4(
>  		xfs_dir2_sf_put_ftype(mp, sfep,
>  				xfs_dir2_sf_get_ftype(mp, oldsfep));
>  	}
> -	/*
> -	 * Clean up the inode.
> -	 */
> -	kfree(buf);
> +
> +	kfree(oldsfp);
>  	dp->i_disk_size = newsize;
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  }
> -- 
> 2.39.2
> 
> 
