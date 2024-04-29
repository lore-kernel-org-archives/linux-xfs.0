Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F305E81741
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404838; cv=none; b=EfM2F56Hw3CtdZrpCywz3sPiJ+POjt5AYVa5jA02z5B2ewhyjXEf7BLpYKHD9+KKugz3u3b4GCbAk9xcz6gCfA8gwUj+mTHq5mIgmvr3ruf/oZZwXnA+gZ2C+27HZuw2wYxkaf2DZOPhQZCPYvdRQgUfVQ7/4ZASbKxGcJ2J0C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404838; c=relaxed/simple;
	bh=daBwDpoO6nvov1Fhq+R923Nc3E+Q3oZH8HxuWVID48g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9oymYcegQyQW9Fnepwp2tpFp86HlQ2HvFHkYCGGazQzF7wCHMwEn0fTEhui5yuMJykWPLdaZWa5NRgC2AcCUOBYlDG2u3yIk7K1lsCGj3afGlTJYZtIArbxpQlqr2xd72AreQ4DSX271VUx+eTAxrkPk4+6aara3a3JM9jMFLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OB8S5HAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OB8S5HAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68640C113CD;
	Mon, 29 Apr 2024 15:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714404837;
	bh=daBwDpoO6nvov1Fhq+R923Nc3E+Q3oZH8HxuWVID48g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OB8S5HAVXUX8J8PIaYB4NCff5EZco8tXGlX5abdyNXQI4s8nM9pXyXXjQ48izv/jv
	 QhMJ9qZInIX3lLZbD/HnH96puFjyW73AR3G/hgFHFbi51ea+NhZFptlUDB5/Bs9CIG
	 mS/EnQPJW/yFONTs8LVTpmE7vO3fs4FoMsSZ4JwtwvAxHdoqZY87+DDo3x6Wa/Gl3w
	 xIXEN66B4L26SY9oa1pjpaV8Qh7wGeCixevwuyOLGSgHF6Am8vqzV0KxHJlksxPsUY
	 Dw5Al10qA62TN7XvFNRHYz+rFPYbxeloiCFaV7OqTjMbLqJy4VFgIQ25HTvtajwCF/
	 pMSrxv+svFA4A==
Date: Mon, 29 Apr 2024 08:33:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: rename the del variable in
 xfs_reflink_end_cow_extent
Message-ID: <20240429153356.GZ360919@frogsfrogsfrogs>
References: <20240429044917.1504566-1-hch@lst.de>
 <20240429044917.1504566-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429044917.1504566-9-hch@lst.de>

On Mon, Apr 29, 2024 at 06:49:17AM +0200, Christoph Hellwig wrote:
> del contains the new extent that we are remapping.  Give it a somewhat
> less confusing name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That's a much better choice of name!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_reflink.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index e20db39d1cc46f..f4c4cd4ef72336 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -784,7 +784,7 @@ xfs_reflink_end_cow_extent(
>  	xfs_fileoff_t		end_fsb)
>  {
>  	struct xfs_iext_cursor	icur;
> -	struct xfs_bmbt_irec	got, del;
> +	struct xfs_bmbt_irec	got, remap;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
> @@ -820,7 +820,7 @@ xfs_reflink_end_cow_extent(
>  	 * Only remap real extents that contain data.  With AIO, speculative
>  	 * preallocations can leak into the range we are called upon, and we
>  	 * need to skip them.  Preserve @got for the eventual CoW fork
> -	 * deletion; from now on @del represents the mapping that we're
> +	 * deletion; from now on @remap represents the mapping that we're
>  	 * actually remapping.
>  	 */
>  	while (!xfs_bmap_is_written_extent(&got)) {
> @@ -830,9 +830,9 @@ xfs_reflink_end_cow_extent(
>  			goto out_cancel;
>  		}
>  	}
> -	del = got;
> -	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
> -	trace_xfs_reflink_cow_remap_from(ip, &del);
> +	remap = got;
> +	xfs_trim_extent(&remap, *offset_fsb, end_fsb - *offset_fsb);
> +	trace_xfs_reflink_cow_remap_from(ip, &remap);
>  
>  	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
>  			XFS_IEXT_REFLINK_END_COW_CNT);
> @@ -840,23 +840,24 @@ xfs_reflink_end_cow_extent(
>  		goto out_cancel;
>  
>  	/* Unmap the old data. */
> -	error = xfs_reflink_unmap_old_data(&tp, ip, del.br_startoff,
> -			del.br_startoff + del.br_blockcount);
> +	error = xfs_reflink_unmap_old_data(&tp, ip, remap.br_startoff,
> +			remap.br_startoff + remap.br_blockcount);
>  	if (error)
>  		goto out_cancel;
>  
>  	/* Free the CoW orphan record. */
> -	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
> +	xfs_refcount_free_cow_extent(tp, remap.br_startblock,
> +			remap.br_blockcount);
>  
>  	/* Map the new blocks into the data fork. */
> -	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
> +	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &remap);
>  
>  	/* Charge this new data fork mapping to the on-disk quota. */
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
> -			(long)del.br_blockcount);
> +			(long)remap.br_blockcount);
>  
>  	/* Remove the mapping from the CoW fork. */
> -	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> +	xfs_bmap_del_extent_cow(ip, &icur, &got, &remap);
>  
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -864,7 +865,7 @@ xfs_reflink_end_cow_extent(
>  		return error;
>  
>  	/* Update the caller about how much progress we made. */
> -	*offset_fsb = del.br_startoff + del.br_blockcount;
> +	*offset_fsb = remap.br_startoff + remap.br_blockcount;
>  	return 0;
>  
>  out_cancel:
> -- 
> 2.39.2
> 
> 
