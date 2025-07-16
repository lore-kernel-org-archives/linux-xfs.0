Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407D62F3C3E
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681569; cv=none; b=t/Z0yOq6qcp2zfTHMZLNFhOqq2mBPvA8OMJfxzl01tfMrOE5zYBTKCA/4nPSVBfTeiIHRE+jrUSMtrZ4dxscvBp9Tey0BVNvV4S4TX30JGAFN4AROmCdSOXIHfUqpEPTa6UUwArwK9qPxDniiiqc04YyQLMvEK9ljjkDTt6tKjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681569; c=relaxed/simple;
	bh=sTxjvRPazykAcSdSzpc8JyNTsh5/VgjbhrWLjV3xJhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZhVCuVFg8auAwBZWbkrm2oDBdfVsNxadWRh0i+D6EK0PHmtIPvkgmU2/LZvFbwZc9pa9/C07+Wp9ZkIhkUR8OSO3P8ZvFOZ9liN7gCbbdARw8wpsrf6zhq2Qe0UsgACwhhI7LJSIFy0+el23KgwOU0OVLa/Bs4iNi4ZVCl2uN2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gumFgJyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gumFgJyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F46C4CEE7;
	Wed, 16 Jul 2025 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752681568;
	bh=sTxjvRPazykAcSdSzpc8JyNTsh5/VgjbhrWLjV3xJhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gumFgJyVrBtWy4noUCvFdLPGgYrl9Ayv9Kay403IqARo866xnD3MHV3Lr5CMbce4d
	 KJm7ARSDrvD/A97DKempe+FCK3MP4SQba6hEY+OyEXIU44oZ2B3mfKApNQWaP1Ds6h
	 RcCcKYlec1mYM4bzIFEbtvoymOMJYqT7WKqCN/dZwBriZM+CBedze55UtBKwiKCo/Z
	 O5UTW//kyUf6lFhBnxCr96Xu5TMUQ/IzHPcGPouNlvfTRuvgV3ht1x9gNCrSIlsJe+
	 3PwoSZvEMaKoloWPIcvKvdsSDWaETjrIRsFAyviBuaQnjtT+m167iwUxZUzeV6+lQ8
	 Ub+lWOdc5KD9A==
Date: Wed, 16 Jul 2025 08:59:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: stop passing an inode to the zone space
 reservation helpers
Message-ID: <20250716155927.GK2672049@frogsfrogsfrogs>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716125413.2148420-5-hch@lst.de>

On Wed, Jul 16, 2025 at 02:54:04PM +0200, Christoph Hellwig wrote:
> None of them actually needs the inode, the mount is enough.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c            | 24 ++++++++++++------------
>  fs/xfs/xfs_iops.c            |  4 ++--
>  fs/xfs/xfs_zone_alloc.h      |  4 ++--
>  fs/xfs/xfs_zone_space_resv.c | 17 ++++++-----------
>  4 files changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 38e365b16348..ed69a65f56d7 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -497,7 +497,7 @@ xfs_file_write_checks(
>  
>  static ssize_t
>  xfs_zoned_write_space_reserve(
> -	struct xfs_inode		*ip,
> +	struct xfs_mount		*mp,
>  	struct kiocb			*iocb,
>  	struct iov_iter			*from,
>  	unsigned int			flags,
> @@ -533,8 +533,8 @@ xfs_zoned_write_space_reserve(
>  	 *
>  	 * Any remaining block will be returned after the write.
>  	 */
> -	return xfs_zoned_space_reserve(ip,
> -			XFS_B_TO_FSB(ip->i_mount, count) + 1 + 2, flags, ac);
> +	return xfs_zoned_space_reserve(mp, XFS_B_TO_FSB(mp, count) + 1 + 2,
> +			flags, ac);
>  }
>  
>  static int
> @@ -718,13 +718,13 @@ xfs_file_dio_write_zoned(
>  	struct xfs_zone_alloc_ctx ac = { };
>  	ssize_t			ret;
>  
> -	ret = xfs_zoned_write_space_reserve(ip, iocb, from, 0, &ac);
> +	ret = xfs_zoned_write_space_reserve(ip->i_mount, iocb, from, 0, &ac);
>  	if (ret < 0)
>  		return ret;
>  	ret = xfs_file_dio_write_aligned(ip, iocb, from,
>  			&xfs_zoned_direct_write_iomap_ops,
>  			&xfs_dio_zoned_write_ops, &ac);
> -	xfs_zoned_space_unreserve(ip, &ac);
> +	xfs_zoned_space_unreserve(ip->i_mount, &ac);
>  	return ret;
>  }
>  
> @@ -1032,7 +1032,7 @@ xfs_file_buffered_write_zoned(
>  	struct xfs_zone_alloc_ctx ac = { };
>  	ssize_t			ret;
>  
> -	ret = xfs_zoned_write_space_reserve(ip, iocb, from, XFS_ZR_GREEDY, &ac);
> +	ret = xfs_zoned_write_space_reserve(mp, iocb, from, XFS_ZR_GREEDY, &ac);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -1073,7 +1073,7 @@ xfs_file_buffered_write_zoned(
>  out_unlock:
>  	xfs_iunlock(ip, iolock);
>  out_unreserve:
> -	xfs_zoned_space_unreserve(ip, &ac);
> +	xfs_zoned_space_unreserve(ip->i_mount, &ac);
>  	if (ret > 0) {
>  		XFS_STATS_ADD(mp, xs_write_bytes, ret);
>  		ret = generic_write_sync(iocb, ret);
> @@ -1414,11 +1414,11 @@ xfs_file_zoned_fallocate(
>  	struct xfs_inode	*ip = XFS_I(file_inode(file));
>  	int			error;
>  
> -	error = xfs_zoned_space_reserve(ip, 2, XFS_ZR_RESERVED, &ac);
> +	error = xfs_zoned_space_reserve(ip->i_mount, 2, XFS_ZR_RESERVED, &ac);
>  	if (error)
>  		return error;
>  	error = __xfs_file_fallocate(file, mode, offset, len, &ac);
> -	xfs_zoned_space_unreserve(ip, &ac);
> +	xfs_zoned_space_unreserve(ip->i_mount, &ac);
>  	return error;
>  }
>  
> @@ -1828,12 +1828,12 @@ xfs_write_fault_zoned(
>  	 * But as the overallocation is limited to less than a folio and will be
>  	 * release instantly that's just fine.
>  	 */
> -	error = xfs_zoned_space_reserve(ip, XFS_B_TO_FSB(ip->i_mount, len), 0,
> -			&ac);
> +	error = xfs_zoned_space_reserve(ip->i_mount,
> +			XFS_B_TO_FSB(ip->i_mount, len), 0, &ac);
>  	if (error < 0)
>  		return vmf_fs_error(error);
>  	ret = __xfs_write_fault(vmf, order, &ac);
> -	xfs_zoned_space_unreserve(ip, &ac);
> +	xfs_zoned_space_unreserve(ip->i_mount, &ac);
>  	return ret;
>  }
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 01e597290eb5..149b5460fbfd 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -970,7 +970,7 @@ xfs_setattr_size(
>  	 * change.
>  	 */
>  	if (xfs_is_zoned_inode(ip)) {
> -		error = xfs_zoned_space_reserve(ip, 1,
> +		error = xfs_zoned_space_reserve(mp, 1,
>  				XFS_ZR_NOWAIT | XFS_ZR_RESERVED, &ac);
>  		if (error) {
>  			if (error == -EAGAIN)
> @@ -998,7 +998,7 @@ xfs_setattr_size(
>  	}
>  
>  	if (xfs_is_zoned_inode(ip))
> -		xfs_zoned_space_unreserve(ip, &ac);
> +		xfs_zoned_space_unreserve(mp, &ac);
>  
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
> index ecf39106704c..4db02816d0fd 100644
> --- a/fs/xfs/xfs_zone_alloc.h
> +++ b/fs/xfs/xfs_zone_alloc.h
> @@ -23,9 +23,9 @@ struct xfs_zone_alloc_ctx {
>   */
>  #define XFS_ZR_RESERVED		(1U << 2)
>  
> -int xfs_zoned_space_reserve(struct xfs_inode *ip, xfs_filblks_t count_fsb,
> +int xfs_zoned_space_reserve(struct xfs_mount *mp, xfs_filblks_t count_fsb,
>  		unsigned int flags, struct xfs_zone_alloc_ctx *ac);
> -void xfs_zoned_space_unreserve(struct xfs_inode *ip,
> +void xfs_zoned_space_unreserve(struct xfs_mount *mp,
>  		struct xfs_zone_alloc_ctx *ac);
>  void xfs_zoned_add_available(struct xfs_mount *mp, xfs_filblks_t count_fsb);
>  
> diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
> index 93c9a7721139..1313c55b8cbe 100644
> --- a/fs/xfs/xfs_zone_space_resv.c
> +++ b/fs/xfs/xfs_zone_space_resv.c
> @@ -117,11 +117,10 @@ xfs_zoned_space_wait_error(
>  
>  static int
>  xfs_zoned_reserve_available(
> -	struct xfs_inode		*ip,
> +	struct xfs_mount		*mp,
>  	xfs_filblks_t			count_fsb,
>  	unsigned int			flags)
>  {
> -	struct xfs_mount		*mp = ip->i_mount;
>  	struct xfs_zone_info		*zi = mp->m_zone_info;
>  	struct xfs_zone_reservation	reservation = {
>  		.task		= current,
> @@ -198,11 +197,10 @@ xfs_zoned_reserve_available(
>   */
>  static int
>  xfs_zoned_reserve_extents_greedy(
> -	struct xfs_inode		*ip,
> +	struct xfs_mount		*mp,
>  	xfs_filblks_t			*count_fsb,
>  	unsigned int			flags)
>  {
> -	struct xfs_mount		*mp = ip->i_mount;
>  	struct xfs_zone_info		*zi = mp->m_zone_info;
>  	s64				len = *count_fsb;
>  	int				error = -ENOSPC;
> @@ -220,12 +218,11 @@ xfs_zoned_reserve_extents_greedy(
>  
>  int
>  xfs_zoned_space_reserve(
> -	struct xfs_inode		*ip,
> +	struct xfs_mount		*mp,
>  	xfs_filblks_t			count_fsb,
>  	unsigned int			flags,
>  	struct xfs_zone_alloc_ctx	*ac)
>  {
> -	struct xfs_mount		*mp = ip->i_mount;
>  	int				error;
>  
>  	ASSERT(ac->reserved_blocks == 0);
> @@ -234,11 +231,11 @@ xfs_zoned_space_reserve(
>  	error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
>  			flags & XFS_ZR_RESERVED);
>  	if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
> -		error = xfs_zoned_reserve_extents_greedy(ip, &count_fsb, flags);
> +		error = xfs_zoned_reserve_extents_greedy(mp, &count_fsb, flags);
>  	if (error)
>  		return error;
>  
> -	error = xfs_zoned_reserve_available(ip, count_fsb, flags);
> +	error = xfs_zoned_reserve_available(mp, count_fsb, flags);
>  	if (error) {
>  		xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb);
>  		return error;
> @@ -249,12 +246,10 @@ xfs_zoned_space_reserve(
>  
>  void
>  xfs_zoned_space_unreserve(
> -	struct xfs_inode		*ip,
> +	struct xfs_mount		*mp,
>  	struct xfs_zone_alloc_ctx	*ac)
>  {
>  	if (ac->reserved_blocks > 0) {
> -		struct xfs_mount	*mp = ip->i_mount;
> -
>  		xfs_zoned_add_available(mp, ac->reserved_blocks);
>  		xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, ac->reserved_blocks);
>  	}
> -- 
> 2.47.2
> 
> 
