Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B039ED52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598103; cv=none; b=g0wSxYZPqqp5B9gpdGcPOpA7VTJJqiwfiqM664uUQJNRsrloE6Ukj3WvaZ64SNw8GZzmI4M83qfTSlUVwPYawwV8iv8G4nwdXMBqsPt8znUg3nOpK3rO9ECsxDp0tgCQG97uLMopRD8c75UQ0LNmrWEhcvzZ5wW/KUfbRRDIU6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598103; c=relaxed/simple;
	bh=JzCitrEeAV0Y5M8cs5OhtDON194jfPszqTGI/O5HOPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwkuH3CBOqOngj1XHGxESEhoFOafwPl0Ctpa9H5vVa53u1UKXSr8ZsuoQQZfG/JHkTT7PIk9mXvQADHKPxS918qTmEMJcHxhEqeKT0CSBey0GOZF655LdmA+weP0fUEXSB7Uk6C6iW8ZrPd8ycB36YBs0dyFr3f53xh/GqVuvD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLLSJpGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLLSJpGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CCDC072AA;
	Wed,  1 May 2024 21:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714598103;
	bh=JzCitrEeAV0Y5M8cs5OhtDON194jfPszqTGI/O5HOPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLLSJpGE0J0ZfTjDi8pP/m5LrfxW43SBNjBqc7GZ8lpVsvcYJx2V3KdeP1qhM3mSJ
	 QabvPs4jhXE1OtiPbYKh47XsVIsi/DGporVZ1eIKuROO2/VJudtyWkL1FHVPv7ACgY
	 SqfrqUl2S6nXECJ3dTzTK3wj2l9d8LLcKJ2rUn6t7yH6hRhayd+CB73h5+BjFveVz0
	 rYYv15N3owcQAHWNFZ01JnWoQoux2O886k6aVeV2gs0gRZA3o3iEzp3/rlIPD1bVTZ
	 4wSRZ/Om6UvgvzrT2qAT3MVbkKmj5BCFu5ApGDKl7OPKBkQRAkLqG4ag1/hCf2KDt5
	 GQzJ1aux0iKfw==
Date: Wed, 1 May 2024 14:15:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/16] xfs: remove an extra buffer allocation in
 xfs_dir2_sf_to_block
Message-ID: <20240501211502.GS360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-5-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:14PM +0200, Christoph Hellwig wrote:
> Make use of the new ability to call xfs_bmap_local_to_extents_empty on
> a non-empty local fork to reuse the old inode fork data to build the
> directory block to replace the local temporary buffer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks pretty straightforward,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_block.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 035a54dbdd7586..20d4e86e14ab08 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1097,8 +1097,7 @@ xfs_dir2_sf_to_block(
>  	int			newoffset;	/* offset from current entry */
>  	unsigned int		offset = geo->data_entry_offset;
>  	xfs_dir2_sf_entry_t	*sfep;		/* sf entry pointer */
> -	struct xfs_dir2_sf_hdr	*oldsfp = ifp->if_data;
> -	xfs_dir2_sf_hdr_t	*sfp;		/* shortform header  */
> +	struct xfs_dir2_sf_hdr	*sfp = ifp->if_data;
>  	__be16			*tagp;		/* end of data entry */
>  	struct xfs_name		name;
>  
> @@ -1106,17 +1105,10 @@ xfs_dir2_sf_to_block(
>  
>  	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
>  	ASSERT(ifp->if_bytes == dp->i_disk_size);
> -	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
> +	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
>  
> -	/*
> -	 * Copy the directory into a temporary buffer.
> -	 * Then pitch the incore inode data so we can make extents.
> -	 */
> -	sfp = kmalloc(ifp->if_bytes, GFP_KERNEL | __GFP_NOFAIL);
> -	memcpy(sfp, oldsfp, ifp->if_bytes);
> +	sfp = xfs_bmap_local_to_extents_empty(tp, dp, XFS_DATA_FORK);
>  
> -	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
> -	xfs_bmap_local_to_extents_empty(tp, dp, XFS_DATA_FORK);
>  	dp->i_disk_size = 0;
>  
>  	/*
> -- 
> 2.39.2
> 
> 
