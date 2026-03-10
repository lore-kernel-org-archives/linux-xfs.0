Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F691A5B9E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 00:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773102705; cv=none; b=qviKpgz++z9d9OkVFCGiTtH10BlwbxCTbTTdnlkTB4Av94W+Sp2f2E0ifIeJ9s7xz5F5CeVTawc1WlKnhrmIKIFSv8s7+oA15xuOAeZ45Xi79XRXo7j1AG8niuewABs8dtQFSUG+FhHI1OrnrSAAo2mNNvP0zcajq5LHJZ1UU0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773102705; c=relaxed/simple;
	bh=I6rLiXnXH9RRRMDMaa6nqpV83eIN6zDva9gPmTfJc0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QubykpnI1Q8UVKbjGB6ivvHbR02hggwPJu/UlwiUXX2QkMLys1pEg8IpW5qXwcJBIGv0Tn0CH4rl0IfzIE1pN4qu/W4GJq8cHH5WI+/OP7G8JSFgGSQ+LbkAJ6xpf8pxNDv2YY+uVZtq3cqoe0Nv0p8nWZe3Q80ivxXI8mR3k8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPjFj7F+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPjFj7F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE7FC4CEF7;
	Tue, 10 Mar 2026 00:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773102705;
	bh=I6rLiXnXH9RRRMDMaa6nqpV83eIN6zDva9gPmTfJc0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MPjFj7F+E7hcNot55Lr8nit/S6/CHMz10g8D5utzg41phSwggIlp59pZgtc9FOIMM
	 qY7CnRfdXhYt+jVUnvHNkNUb4gT61qXzeCWa+jw6oYwcJrDd8AlnugMr84iG+sAfrn
	 POvVpWeYT2UAESgev66EjI8uYXbc+4gKWIBOODsj2ubQtVRiRHWHmC2m7VrSXTPP0U
	 vInkrGTWXS51j9+DPz90kzn1VMmD2q781LaRhgT4bbK4hB5LexI55MTzfzidXLDaIK
	 On3TrQFGE3Lgtjl4qBTVlk/ykLlxP7sIfIqbY6rN4SJzszlUIdufFMUThszT1l3ugz
	 RP+eKLVnDTgEA==
Date: Mon, 9 Mar 2026 17:31:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
	p.raghav@samsung.com
Subject: Re: [PATCH 1/2] xfs: Introduce 'bmapi_flags' parameter to
 xfs_alloc_file_space()
Message-ID: <20260310003144.GT6033@frogsfrogsfrogs>
References: <20260309180708.427553-2-lukas@herbolt.com>
 <20260309180708.427553-4-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309180708.427553-4-lukas@herbolt.com>

On Mon, Mar 09, 2026 at 07:07:09PM +0100, Lukas Herbolt wrote:
> Add bmapi_flags to xfs_alloc_file_space for future use with
> FALLOC_FL_WRITE_ZEROES new fallocate mode. This allows callers to
> explicitly pass the required  XFS_BMAPI_* allocation flags.
> 
> Update all existing callers to pass XFS_BMAPI_PREALLOC to maintain
> the current behavior. No functional changes intended.
> 
> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> ---
>  fs/xfs/xfs_bmap_util.c | 5 +++--
>  fs/xfs/xfs_bmap_util.h | 2 +-
>  fs/xfs/xfs_file.c      | 9 ++++++---
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2208a720ec3f..e92f9cd05f52 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -646,7 +646,8 @@ int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset,
> -	xfs_off_t		len)
> +	xfs_off_t		len,
> +	uint32_t                bmapi_flags)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	xfs_off_t		count;
> @@ -748,7 +749,7 @@ xfs_alloc_file_space(
>  		 * will eventually reach the requested range.
>  		 */
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> +				allocatesize_fsb, bmapi_flags, 0, imapp,
>  				&nimaps);
>  		if (error) {
>  			if (error != -ENOSR)
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b3361630..2895cc97a572 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -56,7 +56,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  
>  /* preallocation and hole punch interface */
>  int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -		xfs_off_t len);
> +		xfs_off_t len, uint32_t bmapi_flags);
>  int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7874cf745af3..fd049a1fc9c6 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1310,7 +1310,8 @@ xfs_falloc_zero_range(
>  		len = round_up(offset + len, blksize) -
>  			round_down(offset, blksize);
>  		offset = round_down(offset, blksize);
> -		error = xfs_alloc_file_space(ip, offset, len);
> +		error = xfs_alloc_file_space(ip, offset, len,
> +				XFS_BMAPI_PREALLOC);
>  	}
>  	if (error)
>  		return error;
> @@ -1336,7 +1337,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1364,7 +1366,8 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_BMAPI_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> -- 
> 2.53.0
> 
> 
