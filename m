Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699DCD52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598412; cv=none; b=uojEQc1av/4X0Ew+CAFSyFThTOsXaooccKTjBfLYkMQYqXo1KJFVgelCo29jo3dQ/PpwY63KRoFYUMZFLNgw/g6PedUxe1opl/J4IuCtYjXd2XSfpylYijARDRm3aL+nhVgMkiSrbwty6Fc/bjlqqWYglknoe+BKRQTtE2qSupA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598412; c=relaxed/simple;
	bh=eKqXC6HC2OYW2qegk4Vre1bSczGICjB7a8pdbavSnjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtqXizQjeulA8vz/1fV749NzPui99DMmpGYj2ASDdXQx75kw7HI4dCRbsjBsNlxZZObdicEmriRjZaWc47I9dzsqMfG3fs/q/bI4Kdz4O7rPam6XUYkAgidc87qhkIVna3h+XDzKij4EP7E65DO18ubRKVkvx3f2dc88pyPUpvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rcbpdkU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rcbpdkU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83B5C072AA;
	Wed,  1 May 2024 21:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714598411;
	bh=eKqXC6HC2OYW2qegk4Vre1bSczGICjB7a8pdbavSnjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rcbpdkU1ewpBcfKODLqtDe39ODBCjkNoQYqWhPz4Xi+OMOROXvkdBJ6e/1L3S++Vy
	 A7JHlKCfHKosU+I+yg/V1hiYJgYhqVRV8NlnHAfraNakSlFUTltC7uQ6m84R/ayk3r
	 nDXLMyVeMtvC6CbP7pJh5qUodITQ5pOeJ8J7EfjPK6AuPFi5v/KBmT8wS+zYaRj451
	 NV1JJU3y9tQZmgki52bBSlqWq55EvMOTC+xgJ1HTNFS92cIdgcI7slW6xdT76eoHo/
	 l4fZjTa78agRAerPLq+tpcna4MEjADzWFhFlDeKfeibfXgY2WJ7V5EoNCUsSB4l5X8
	 52OUlDz4Qr6Bg==
Date: Wed, 1 May 2024 14:20:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/16] xfs: remove a superfluous memory allocation in
 xfs_dir2_sf_toino8
Message-ID: <20240501212011.GW360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-9-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:18PM +0200, Christoph Hellwig wrote:
> Transfer the temporary buffer allocation to the inode fork instead of
> copying to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 29 ++++++++---------------------
>  1 file changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 164ae1684816b6..87552c01260a1c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -1205,36 +1205,25 @@ xfs_dir2_sf_toino8(
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
>  	trace_xfs_dir2_sf_toino8(args);
>  
> -	/*
> -	 * Copy the old directory to the buffer.
> -	 * Then nuke it from the inode, and add the new buffer to the inode.
> -	 * Don't want xfs_idata_realloc copying the data here.
> -	 */
> -	oldsize = dp->i_df.if_bytes;
> -	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
>  	ASSERT(oldsfp->i8count == 0);
> -	memcpy(buf, oldsfp, oldsize);
> +
>  	/*
>  	 * Compute the new inode size (nb: entry count + 1 for parent)
>  	 */
>  	newsize = oldsize + (oldsfp->count + 1) * XFS_INO64_DIFF;
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

I sure am glad we never implemented inline data for regular files on
xfs,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  	/*
>  	 * Fill in the new header.
>  	 */
> @@ -1257,10 +1246,8 @@ xfs_dir2_sf_toino8(
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
