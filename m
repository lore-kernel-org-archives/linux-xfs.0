Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DD95B691
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 21:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715115734; cv=none; b=I7c95oOwoGRdW9ddqZnQFsTRHUEAo39WwV6yKg/KHVi81LWljL1x8W8HLvPePmdyCWCnauRU8xY4jhZpJgerw2paBhcb+XxAYP11vAnv6OvZIzIkG7WQ0oH1cOEiptXI0+nC24N+r6MlIbV7mYfI/OLWIdIvsxt51yRIFLPAhHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715115734; c=relaxed/simple;
	bh=3NLsbCf/5qG952NDyHYPfM9kyfKkws5083r+nxYBfM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=at5Np4VTN8v43wg07lT9DwbSs4GRTKPSZDpko855jqJSSKDgoEmGDTvmOwBvz9VG4MRXZVSB5y7Jzvc8S6Kts+JF2Anzj83sB0QaY3tjFCl+OWub3pm1zeOl+UhutKfmNG9wD4OeO19CBCv+Nd2gEF5nBgohtfZHnP4A1TJjihI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDCBNPJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDCBNPJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943DEC2BBFC;
	Tue,  7 May 2024 21:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715115733;
	bh=3NLsbCf/5qG952NDyHYPfM9kyfKkws5083r+nxYBfM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WDCBNPJTxL921NIol7lLByzFEqxxqJRt6+d9u5Hh4Xs/UogdPEAMcT3h8mahLzG5S
	 rOv71RjUChBM0OjdvKo83+mpaoZkgYXC6TlrQJ9m39nBEDR/HFOg5ZTCLj4O0aIaxV
	 lSuOd5jCyJJmkhJfbDt4AWD7koXI2V/31z/CfL6a8lVkC7lP2r3zB+a3RTbGDbMYHu
	 Fnm6YWBvm9jqqO617sU1UFDTtJT2WWrVktdMsrVOxGIJQ6fwLwvdqkoU+oeaPxYxbt
	 WCUdtQPh77b9vBL7z0UhxrQmhQXHElGL7wDixZgX1QcoGGbBytupqiaS+RnjWyt09s
	 BWoQBv5DpxB9A==
Date: Tue, 7 May 2024 14:02:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] xfs: Fix xfs_prepare_shift() range for RT
Message-ID: <20240507210213.GS360919@frogsfrogsfrogs>
References: <20240503140337.3426159-1-john.g.garry@oracle.com>
 <20240503140337.3426159-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503140337.3426159-3-john.g.garry@oracle.com>

On Fri, May 03, 2024 at 02:03:37PM +0000, John Garry wrote:
> The RT extent range must be considered in the xfs_flush_unmap_range() call
> to stabilize the boundary.
> 
> This code change is originally from Dave Chinner.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index da67c52d5f94..2775bb32489e 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -896,8 +896,8 @@ xfs_prepare_shift(
>  	struct xfs_inode	*ip,
>  	loff_t			offset)
>  {
> -	struct xfs_mount	*mp = ip->i_mount;
>  	int			error;
> +	unsigned int		rounding;
>  
>  	/*
>  	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
> @@ -914,11 +914,13 @@ xfs_prepare_shift(
>  	 * with the full range of the operation. If we don't, a COW writeback
>  	 * completion could race with an insert, front merge with the start
>  	 * extent (after split) during the shift and corrupt the file. Start
> -	 * with the block just prior to the start to stabilize the boundary.
> +	 * with the aligned block just prior to the start to stabilize the

"...with the allocation unit just prior to the start..."

> +	 * boundary.
>  	 */
> -	offset = round_down(offset, mp->m_sb.sb_blocksize);
> +	rounding = xfs_inode_alloc_unitsize(ip);
> +	offset = round_down(offset, rounding);

Again, round_down requires the divisor to be a power of two.

--D

>  	if (offset)
> -		offset -= mp->m_sb.sb_blocksize;
> +		offset -= rounding;
>  
>  	/*
>  	 * Writeback and invalidate cache for the remainder of the file as we're
> -- 
> 2.31.1
> 
> 
