Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FFE14B06E
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732032944; cv=none; b=KJpBVXx3DKkDQDAoDV09+fevxB1+m4TX2WPPz7IpXv2yQiKHTrWIvZmWfOcggOvuSrCehomz+YAnflmRTdX3VLUWX7G/As9boUJrpXNSuYo270NYh2+XTlZgIhs3V1SLfi1nF+Nk4Fh1pmVX9TwdNltY6a9Y1d1fo8jtYr/U/0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732032944; c=relaxed/simple;
	bh=NjpdEJyR3v6BjqroHrx5lyJ7qdBANcfLnuAYYgDTWB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABPe51J9IvZ9i6UofLuR5Jnalzin4gKriM51PwpLmLDWU628j0+Z8hMtwNv0UkBU+z9fwbNJpMqzZsxSsDEWr4Su1a9emQqi3K+Yurt6TYmojh3UHGr0xLHLpzgS7FpMuxE+WcuZGoibilg1u4c2dPXt8NEs1umBMeCJHKdIGhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kR0bvq6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kR0bvq6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30238C4CECF;
	Tue, 19 Nov 2024 16:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732032944;
	bh=NjpdEJyR3v6BjqroHrx5lyJ7qdBANcfLnuAYYgDTWB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kR0bvq6S/c2+RoZI62MWJE9IrwHNYcik7p6hPjJWRDMsGnRkDZUXS/F9SZlX+MLAB
	 ch8X6VhpjNVL/ri2I8jdtf7gp1nZECEyvQtYXTRcFM14tk7LS1IyJRwGYmlL5IY2Uy
	 eAZGlrItMNpDyI5MfFS01a9I1kIyxoAtw6afkOFIjJdz8G7Tc3urHGLDttnj9RrLF8
	 cOWwHJGVuggSvNTSTBvT0omVnv4L/FJ3iIUKTZxuwd7jgKtqeslcinw06rMFLzNMKR
	 DUFwXWhdY6Nr751nv4PkSRkaqff6c26ejMcpNSSj7ecJWpzq3wIytSQ8ASULGmuFDF
	 /ZYkS0CmrAnWw==
Date: Tue, 19 Nov 2024 08:15:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: factor out a xfs_rt_check_size helper
Message-ID: <20241119161543.GW9438@frogsfrogsfrogs>
References: <20241119154959.1302744-1-hch@lst.de>
 <20241119154959.1302744-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119154959.1302744-2-hch@lst.de>

On Tue, Nov 19, 2024 at 04:49:47PM +0100, Christoph Hellwig wrote:
> Add a helper to check that the last block of a RT device is readable
> to share the code between mount and growfs.  This also adds the mount
> time overflow check to growfs and improves the error messages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_rtalloc.c | 62 ++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 0cb534d71119..90f4fdd47087 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1225,6 +1225,34 @@ xfs_grow_last_rtg(
>  			mp->m_sb.sb_rgextents;
>  }
>  
> +/*
> + * Read in the last block of the RT device to make sure it is accessible.
> + */
> +static int
> +xfs_rt_check_size(
> +	struct xfs_mount	*mp,
> +	xfs_rfsblock_t		last_block)
> +{
> +	xfs_daddr_t		daddr = XFS_FSB_TO_BB(mp, last_block);
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	if (XFS_BB_TO_FSB(mp, daddr) != last_block) {
> +		xfs_warn(mp, "RT device size overflow: %llu != %llu",
> +			XFS_BB_TO_FSB(mp, daddr), last_block);
> +		return -EFBIG;
> +	}
> +
> +	error = xfs_buf_read_uncached(mp->m_rtdev_targp, daddr,
> +			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> +	if (error)
> +		xfs_warn(mp, "cannot read last RT device block (%lld)",
> +				last_block);

"cannot read last RT device sector"?  Something to hint that the units
are 512b blocks, not fsblocks?  This is certainly better than the old
message. :)

Also, should there be a similar function to handle the last datadev
read that mount and growfs perform?

--D

> +	else
> +		xfs_buf_relse(bp);
> +	return error;
> +}
> +
>  /*
>   * Grow the realtime area of the filesystem.
>   */
> @@ -1236,7 +1264,6 @@ xfs_growfs_rt(
>  	xfs_rgnumber_t		old_rgcount = mp->m_sb.sb_rgcount;
>  	xfs_rgnumber_t		new_rgcount = 1;
>  	xfs_rgnumber_t		rgno;
> -	struct xfs_buf		*bp;
>  	xfs_agblock_t		old_rextsize = mp->m_sb.sb_rextsize;
>  	int			error;
>  
> @@ -1273,15 +1300,10 @@ xfs_growfs_rt(
>  	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);
>  	if (error)
>  		goto out_unlock;
> -	/*
> -	 * Read in the last block of the device, make sure it exists.
> -	 */
> -	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
> -				XFS_FSB_TO_BB(mp, in->newblocks - 1),
> -				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> +
> +	error = xfs_rt_check_size(mp, in->newblocks - 1);
>  	if (error)
>  		goto out_unlock;
> -	xfs_buf_relse(bp);
>  
>  	/*
>  	 * Calculate new parameters.  These are the final values to be reached.
> @@ -1408,10 +1430,6 @@ int				/* error */
>  xfs_rtmount_init(
>  	struct xfs_mount	*mp)	/* file system mount structure */
>  {
> -	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
> -	xfs_daddr_t		d;	/* address of last block of subvolume */
> -	int			error;
> -
>  	if (mp->m_sb.sb_rblocks == 0)
>  		return 0;
>  	if (mp->m_rtdev_targp == NULL) {
> @@ -1422,25 +1440,7 @@ xfs_rtmount_init(
>  
>  	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, &mp->m_rsumlevels);
>  
> -	/*
> -	 * Check that the realtime section is an ok size.
> -	 */
> -	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
> -	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_rblocks) {
> -		xfs_warn(mp, "realtime mount -- %llu != %llu",
> -			(unsigned long long) XFS_BB_TO_FSB(mp, d),
> -			(unsigned long long) mp->m_sb.sb_rblocks);
> -		return -EFBIG;
> -	}
> -	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
> -					d - XFS_FSB_TO_BB(mp, 1),
> -					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> -	if (error) {
> -		xfs_warn(mp, "realtime device size check failed");
> -		return error;
> -	}
> -	xfs_buf_relse(bp);
> -	return 0;
> +	return xfs_rt_check_size(mp, mp->m_sb.sb_rblocks - 1);
>  }
>  
>  static int
> -- 
> 2.45.2
> 
> 
