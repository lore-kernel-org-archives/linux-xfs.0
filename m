Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AED165FAA
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714597894; cv=none; b=lN7K3COfBwVqFNa9EeG8/KX0rWg5BNdYaooS6VAMmYj1vmF4lKnjPaipy+cEEDi24p0K1ZP3RF65902YhIHFa/hv6vgoag3YRPEtgcFXDobQMAY7b5BYVd1UiGXP16VSpGthKP/ECzqH+re4I3gaIrmeWX5R94cWiB22LQiybz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714597894; c=relaxed/simple;
	bh=H4gNx564vsVmh9Dr+CxVL25n4MY/4wPqVaZiXDefUe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qN/Z0eiGzMpEuqUVO/PD12r8wR0hw9vkifrsd6Eu5GwLlWl8PpivggJCFh9jaAmfGpn5rnbt33uuza70hspTDUNQRbiWPSHqDlMZjqiC2d+FqaDXUlNbkC2ADdOHbvOWW/s7It1PbR7BiOWrP2xFMFZUvVrYw7m/q2SfLsTwCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWb3eJqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWb3eJqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636B7C072AA;
	Wed,  1 May 2024 21:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714597893;
	bh=H4gNx564vsVmh9Dr+CxVL25n4MY/4wPqVaZiXDefUe0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JWb3eJqG2jyp/FYGwZX2u0M+A0NtfrsQHDaDa55ZC4KbWyAeqh7+y3Mdn3CejAGg5
	 y7JP9UF/NVnRROfo7nG0zZiNP3xSgHX+F9UVE1kMzluzDGJatmLjA55CHATUWnQRzx
	 Jkzzhj8AqNfTMOkgxYZcnxXD/4AcF/B5oGKTqVyDuEmBnzlGWvfO8wBUs4Y+/Efu1M
	 9gVGU0LFbrihCqOouLjg5+yn5B0qWEfL36aDRsSewEL4Q+hHg/qbe8An83YUSI98Pa
	 Gf4iLAjNvqzcSK189iv56BonTfFqhctRnXuOwknMDXeFTakgzBroM2fv3EkveuHNb6
	 bCWgWRLZLYGIg==
Date: Wed, 1 May 2024 14:11:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs: remove an extra buffer allocation in
 xfs_attr_shortform_to_leaf
Message-ID: <20240501211132.GQ360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-3-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:12PM +0200, Christoph Hellwig wrote:
> Make use of the new ability to call xfs_bmap_local_to_extents_empty on
> a non-empty local fork to reuse the old inode fork data to build the leaf
> block to replace the local temporary buffer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b9e98950eb3d81..d9285614d7c21b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -942,24 +942,16 @@ xfs_attr_shortform_to_leaf(
>  	struct xfs_da_args		*args)
>  {
>  	struct xfs_inode		*dp = args->dp;
> -	struct xfs_ifork		*ifp = &dp->i_af;
> -	struct xfs_attr_sf_hdr		*sf = ifp->if_data;
> +	struct xfs_attr_sf_hdr		*sf;
>  	struct xfs_attr_sf_entry	*sfe;
> -	int				size = be16_to_cpu(sf->totsize);
>  	struct xfs_da_args		nargs;
> -	char				*tmpbuffer;
>  	int				error, i;
>  	xfs_dablk_t			blkno;
>  	struct xfs_buf			*bp;
>  
>  	trace_xfs_attr_sf_to_leaf(args);
>  
> -	tmpbuffer = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
> -	memcpy(tmpbuffer, ifp->if_data, size);
> -	sf = (struct xfs_attr_sf_hdr *)tmpbuffer;
> -
> -	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
> -	xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
> +	sf = xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
>  
>  	bp = NULL;
>  	error = xfs_da_grow_inode(args, &blkno);
> @@ -1003,7 +995,7 @@ xfs_attr_shortform_to_leaf(
>  	}
>  	error = 0;
>  out:
> -	kfree(tmpbuffer);
> +	kfree(sf);
>  	return error;
>  }
>  
> -- 
> 2.39.2
> 
> 
