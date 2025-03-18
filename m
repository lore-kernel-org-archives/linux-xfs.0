Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D0A290F
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 12:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742302339; cv=none; b=NG4IVQQD0e+64sFLe+PhFO1C8IkaZGcR0WmYdhnMajzR2yc5245QX+oF4MsWvG95r0jg4m0/8NThMTZbty0D5Hr6PWWCrLs3CRT5FPFYTR27L1m7lYqrdWqMoM4NuManVFvoHHfXT7Yf+5G0wGvACb6TnTmiSWFKwu/QUN5Tsas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742302339; c=relaxed/simple;
	bh=F+YlhIQRfhEoQnFiMm/xnFHpVTgdNIC16ek8/1G3s8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAxRKme0UyGSBEIH5QlvkIV2Cxq5/LfFiE72cb1O/xlDykKvAmeiE8MNFWnTeWIpzNzWDz+QQudEDgj9Up2VegIEfnQJ7WvEwDIqgCv3eTkaJQGs96oBAf/VhFwbPhGUDLgfkGvyEIL96+cPVJYRSN5IpaX8S+37OQog5GRRlPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=teFvGt6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="teFvGt6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD827C4CEEA;
	Tue, 18 Mar 2025 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742302339;
	bh=F+YlhIQRfhEoQnFiMm/xnFHpVTgdNIC16ek8/1G3s8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=teFvGt6fh4nHiKiwepMi4r18B1+7tgz82Np3EYOsyS41UhAzNASKGasaLlNZ/j9a7
	 /iFzQdnnyXQLlqbXHRib8LBFkiv1/ZCkLssvPdAXpViMMi0i+wrtTz0wVA1axLVNDl
	 CsVmkDeEHjk3B/MXSe5RL9l8Y8visiOuWJ/bJT4eoR21eV8QtS5MVnOKacnx7tFjOY
	 p6CvDpbHuc+eE3DzSJhu/AA/r5v5twAhQzT0iGyCDWkDgPkWDFYhzzD4oBeE7VlA90
	 r1sjvXFCPG0m0o5WAFr1+IwxDdUbROiB6UC1n6VsxvkJ2OklRcrZbcmmiYG7Af9Yfj
	 PJyqxA3M+j5/g==
Date: Tue, 18 Mar 2025 13:47:14 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: remove the flags argument to
 xfs_buf_read_uncached
Message-ID: <lvtep7n2w24636xtge45r45bpjn3ys7yn5ftwt7npyroegjbnp@h2qvmq7sw5hb>
References: <20250317054850.1132557-1-hch@lst.de>
 <GQ6A3wkAK9Tbps4feoM01lvSe_oDBCnr1gWDMUHet8yWModunn24xfWwhQLRgFq3MxLZD0r0k3Zb8mKfLC_TCw==@protonmail.internalid>
 <20250317054850.1132557-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317054850.1132557-5-hch@lst.de>

On Mon, Mar 17, 2025 at 06:48:35AM +0100, Christoph Hellwig wrote:
> No callers passes flags to xfs_buf_read_uncached, which makes sense
> given that the flags apply to behavior not used for uncached buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf.c     | 3 +--
>  fs/xfs/xfs_buf.h     | 2 +-
>  fs/xfs/xfs_fsops.c   | 2 +-
>  fs/xfs/xfs_mount.c   | 6 +++---
>  fs/xfs/xfs_rtalloc.c | 4 ++--
>  5 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index bf75964bbfe8..6469a69b18fe 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -802,7 +802,6 @@ xfs_buf_read_uncached(
>  	struct xfs_buftarg	*target,
>  	xfs_daddr_t		daddr,
>  	size_t			numblks,
> -	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
> @@ -811,7 +810,7 @@ xfs_buf_read_uncached(
> 
>  	*bpp = NULL;
> 
> -	error = xfs_buf_get_uncached(target, numblks, flags, &bp);
> +	error = xfs_buf_get_uncached(target, numblks, 0, &bp);
>  	if (error)
>  		return error;
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index db43bdc17f55..6a426a8d6197 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -275,7 +275,7 @@ xfs_buf_readahead(
>  int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
>  		xfs_buf_flags_t flags, struct xfs_buf **bpp);
>  int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
> -		size_t numblks, xfs_buf_flags_t flags, struct xfs_buf **bpp,
> +		size_t numblks, struct xfs_buf **bpp,
>  		const struct xfs_buf_ops *ops);
>  int _xfs_buf_read(struct xfs_buf *bp);
>  void xfs_buf_hold(struct xfs_buf *bp);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index b6f3d7abdae5..0ada73569394 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -111,7 +111,7 @@ xfs_growfs_data_private(
>  	if (nb > mp->m_sb.sb_dblocks) {
>  		error = xfs_buf_read_uncached(mp->m_ddev_targp,
>  				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
> -				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> +				XFS_FSS_TO_BB(mp, 1), &bp, NULL);
>  		if (error)
>  			return error;
>  		xfs_buf_relse(bp);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index e65a659901d5..00b53f479ece 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -186,7 +186,7 @@ xfs_readsb(
>  	 */
>  reread:
>  	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
> -				      BTOBB(sector_size), 0, &bp, buf_ops);
> +				      BTOBB(sector_size), &bp, buf_ops);
>  	if (error) {
>  		if (loud)
>  			xfs_warn(mp, "SB validate failed with error %d.", error);
> @@ -414,7 +414,7 @@ xfs_check_sizes(
>  	}
>  	error = xfs_buf_read_uncached(mp->m_ddev_targp,
>  					d - XFS_FSS_TO_BB(mp, 1),
> -					XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> +					XFS_FSS_TO_BB(mp, 1), &bp, NULL);
>  	if (error) {
>  		xfs_warn(mp, "last sector read failed");
>  		return error;
> @@ -431,7 +431,7 @@ xfs_check_sizes(
>  	}
>  	error = xfs_buf_read_uncached(mp->m_logdev_targp,
>  					d - XFS_FSB_TO_BB(mp, 1),
> -					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> +					XFS_FSB_TO_BB(mp, 1), &bp, NULL);
>  	if (error) {
>  		xfs_warn(mp, "log device read failed");
>  		return error;
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 3aa222ea9500..e35c728f222e 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1350,7 +1350,7 @@ xfs_rt_check_size(
> 
>  	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
>  			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart) + daddr,
> -			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> +			XFS_FSB_TO_BB(mp, 1), &bp, NULL);
>  	if (error)
>  		xfs_warn(mp, "cannot read last RT device sector (%lld)",
>  				last_block);
> @@ -1511,7 +1511,7 @@ xfs_rtmount_readsb(
> 
>  	/* m_blkbb_log is not set up yet */
>  	error = xfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
> -			mp->m_sb.sb_blocksize >> BBSHIFT, 0, &bp,
> +			mp->m_sb.sb_blocksize >> BBSHIFT, &bp,
>  			&xfs_rtsb_buf_ops);
>  	if (error) {
>  		xfs_warn(mp, "rt sb validate failed with error %d.", error);
> --
> 2.45.2
> 
