Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C480E19D092
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719244264; cv=none; b=SBXGEbN4qVMDe2U2ChF175xZr6mA5p+ULwm4o90a1jDUuxxVXfemsplq27hK1a/cUYCwguT9Pj2SNmJHEyV8xbUz4O4tuQJvcV1PzpmNOoQ2g7A9YbOpd0A1AFZ5LCkBhthR90vZq8fILzHRqFb6sc5XdCmNpbTKRcCMHAbOnLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719244264; c=relaxed/simple;
	bh=BrNCIaxIHCshGhwemwH3Kv8ms28XERjnFiWnvdd649I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B1F0QZt6yC3Ctxakv5Gx0YPwTWv5n0YAfr16MvWIAchxenn8Wx3uq7kwQcj9U0ftjZJ3FFnQ5QG7vrCG3ppq+hsKi3V3fB/1MTrxpc2iVShWxtkH71ZDPt+ZGtdEjLOunY4iJjvf+n7/ZOri4r0ruFNkRKMVSgnZRz/QkrNoNj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGeAr0qR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGeAr0qR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305D8C32782;
	Mon, 24 Jun 2024 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719244264;
	bh=BrNCIaxIHCshGhwemwH3Kv8ms28XERjnFiWnvdd649I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QGeAr0qREEVUl7MfGl5pNf9D4VahbIh4srfdKpPushj1HHhGFBaAm6biK/owyUrOj
	 vyh584ECEaKm2/ko+543tG6WxFpwVqqRaWm9hGKj0UzdcspVa+4R+2jD5t7jwNJQkF
	 tYPQtuTLKEua74G9kkH4WKKqTcwOfbS3gUohwBEY9n0brpCvnu3pDEyZwd9VYT/VK1
	 pHzZHfqLG+PwQPjUWps9E4G6qB0Gm9sjWXrDlNakLRjG0eaGQN0A2RqMozefD6W8P5
	 lSNehZJQf9LnCJ4umOKRC/833uvphArbOWn6UwMjKVKFMk6xmvUqQf5U1Y5bHCQELT
	 OsgJP53R6KPEQ==
Date: Mon, 24 Jun 2024 08:51:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: simplify extent lookup in
 xfs_can_free_eofblocks
Message-ID: <20240624155103.GM3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-10-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:54AM +0200, Christoph Hellwig wrote:
> xfs_can_free_eofblocks just cares if there is an extent beyond EOF.
> Replace the call to xfs_bmapi_read with a xfs_iext_lookup_extent
> as we've already checked that extents are read in earlier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I guess that works :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index a4d9fbc21b8343..52863b784b023f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -492,12 +492,12 @@ bool
>  xfs_can_free_eofblocks(
>  	struct xfs_inode	*ip)
>  {
> -	struct xfs_bmbt_irec	imap;
>  	struct xfs_mount	*mp = ip->i_mount;
> +	bool			found_blocks = false;
>  	xfs_fileoff_t		end_fsb;
>  	xfs_fileoff_t		last_fsb;
> -	int			nimaps = 1;
> -	int			error;
> +	struct xfs_bmbt_irec	imap;
> +	struct xfs_iext_cursor	icur;
>  
>  	/*
>  	 * Caller must either hold the exclusive io lock; or be inactivating
> @@ -544,21 +544,13 @@ xfs_can_free_eofblocks(
>  		return false;
>  
>  	/*
> -	 * Look up the mapping for the first block past EOF.  If we can't find
> -	 * it, there's nothing to free.
> +	 * Check if there is an post-EOF extent to free.
>  	 */
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	error = xfs_bmapi_read(ip, end_fsb, last_fsb - end_fsb, &imap, &nimaps,
> -			0);
> +	if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
> +		found_blocks = true;
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -	if (error || nimaps == 0)
> -		return false;
> -
> -	/*
> -	 * If there's a real mapping there or there are delayed allocation
> -	 * reservations, then we have post-EOF blocks to try to free.
> -	 */
> -	return imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
> +	return found_blocks;
>  }
>  
>  /*
> -- 
> 2.43.0
> 
> 
