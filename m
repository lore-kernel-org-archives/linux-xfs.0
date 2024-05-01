Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA7AD52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598003; cv=none; b=MGRPtuMQHYZb0sqc94FafLGMWm3nfOk/0VfkqIRkQ9B08/CxFmZZofj9bPmj4PHSlDnxrHG0vnRCZqc7MWHQGBkfjt4AowUnKwA95jBgquJ6RhMMTL0949KrOcjpgjsAq8tr28OEAAEatj7bBeZmk8k6JL/ZsRimwZ67k5CBnsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598003; c=relaxed/simple;
	bh=z/TRhchhRyOhi8RCLCF/1uMR8tC6aXELjaGS1PMQQ5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qon7FZZEwVP+g66wICMuuCXlqN40pKYyNaVS/rKm1KqLKkOuVRHz1sXL58dV2qPc0YIy5Hzf8goUgJGUddjLvqx7VByw2iConGJkvcMQ+hSsFpFEdyjWXUYF0zNRF9vmHOBp/ut+HTIcO9jG8UTYvIMFaKzrBy6AhKT0Ot1losM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cd5TvU4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cd5TvU4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D85CC072AA;
	Wed,  1 May 2024 21:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714598002;
	bh=z/TRhchhRyOhi8RCLCF/1uMR8tC6aXELjaGS1PMQQ5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cd5TvU4YSQhu41VJfEJeu4m1DhJgBFwYP8OOVRetacv6778jVojdbWnJGbLinL/UA
	 m0TYXeb5MmOOgFvZGl8ggjrp3hCncITX6fJBq21hUZso0yXJnJNP7bKeG4PhmZhX2w
	 gR4jPqprVV8uLV4rCkeeKabQqzPFW7pY6ADepp9HUDKRF7je+sj4luMd165Xm3+yBq
	 Q6jgRbEeNEnEbAGzQ4PgSSo0c/YTvnMYc1tVLjUPCfwuhMV2EZvt7485UNg01F6b4Y
	 jk/F1Wo19PQpJ/w09TD8DLHwTKNG7fm/nPkXzQ11IxyhzkfefuMAjwLLWrhHRN6uRv
	 CY6GLRmOBIb/w==
Date: Wed, 1 May 2024 14:13:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rationalize dir2_sf entry condition asserts
Message-ID: <20240501211322.GR360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-4-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:13PM +0200, Christoph Hellwig wrote:
> Various routines dealing with shortform directories have a similar
> pre-condition ASSERT boilerplate that does look a bit weird.
> 
> Remove the assert that the inode fork is non-NULL as it doesn't buy
> anything over the NULL pointer dereference if it is.
> 
> Remove the duplicate i_disk_size ASSERT that uses the less precise
> location of the parent inode number over the one using
> xfs_dir2_sf_hdr_size().
> 
> Remove the if_nextents assert in xfs_dir2_sf_to_block as that is implied
> by the local formt (and not checked by the other functions either).

               format

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_dir2_block.c |  4 ----
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 12 ++----------
>  2 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 0f93ed1a4a74f4..035a54dbdd7586 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1105,12 +1105,8 @@ xfs_dir2_sf_to_block(
>  	trace_xfs_dir2_sf_to_block(args);
>  
>  	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
> -	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
> -
>  	ASSERT(ifp->if_bytes == dp->i_disk_size);
> -	ASSERT(oldsfp != NULL);
>  	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
> -	ASSERT(dp->i_df.if_nextents == 0);
>  
>  	/*
>  	 * Copy the directory into a temporary buffer.
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 17a20384c8b719..1cd5228e1ce6af 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -378,9 +378,7 @@ xfs_dir2_sf_addname(
>  
>  	ASSERT(xfs_dir2_sf_lookup(args) == -ENOENT);
>  	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
> -	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
> -	ASSERT(sfp != NULL);
>  	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
>  	/*
>  	 * Compute entry (and change in) size.
> @@ -855,9 +853,7 @@ xfs_dir2_sf_lookup(
>  	xfs_dir2_sf_check(args);
>  
>  	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
> -	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
> -	ASSERT(sfp != NULL);
>  	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
>  	/*
>  	 * Special case for .
> @@ -920,21 +916,19 @@ xfs_dir2_sf_removename(
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
> +	int			oldsize = dp->i_disk_size;
>  	int			byteoff;	/* offset of removed entry */
>  	int			entsize;	/* this entry's size */
>  	int			i;		/* shortform entry index */
>  	int			newsize;	/* new inode size */
> -	int			oldsize;	/* old inode size */
>  	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
>  
>  	trace_xfs_dir2_sf_removename(args);
>  
>  	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
> -	oldsize = (int)dp->i_disk_size;
> -	ASSERT(oldsize >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  	ASSERT(dp->i_df.if_bytes == oldsize);
> -	ASSERT(sfp != NULL);
>  	ASSERT(oldsize >= xfs_dir2_sf_hdr_size(sfp->i8count));
> +
>  	/*
>  	 * Loop over the old directory entries.
>  	 * Find the one we're deleting.
> @@ -1028,9 +1022,7 @@ xfs_dir2_sf_replace(
>  	trace_xfs_dir2_sf_replace(args);
>  
>  	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
> -	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
> -	ASSERT(sfp != NULL);
>  	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
>  
>  	/*
> -- 
> 2.39.2
> 
> 
