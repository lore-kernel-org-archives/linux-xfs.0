Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04291E1C36
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752590876; cv=none; b=cEOJ2zLP9v1XuPKKdWP3L1z2lI3CKjGcDdQ3UZSF72EUiD2+lAQPP2g2EAhRa7nGU0VkIvZ9qczyJF7Dt/YDsV2RrBc1OTKCySn9awxzr7jNu23E/Z6c9nOYW6Tkpx+PwftNpvAG4WnqOVGEEwpTRUhXlvAXbE8G/13QJpJm/ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752590876; c=relaxed/simple;
	bh=m8iO969aFHQLeQ83Py+5utiX2dvjTouZKBTWv1Ej6ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n03xR2k0Wuez4DCH9jhBdHpeCYJ6Angno9zFPP1NoCQF6L6iCMFM1QlvnqtQolDWQIlxfTUuDd1QAvh9vXJgGVak3albeXRPl6IacHCvliV+IkUDRClF3bKuYlo6QJkjyMw/vpRzZFBzsg5Anaga+YZQkNLuhcb/yMJwqowJ2yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7nIMO/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7nIMO/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D95CC4CEE3;
	Tue, 15 Jul 2025 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752590876;
	bh=m8iO969aFHQLeQ83Py+5utiX2dvjTouZKBTWv1Ej6ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X7nIMO/Fq5wdvmiTH7rH56hR20PRzzunOW9JxSqOgvYD9GAUqBfwTrDarroGVGFwk
	 yAxPGX8CUORaSxl2OGE0qZvHNrd7nTt9t873TOb2v1Urc+jErMhpz//5lj34nxx4ZH
	 BtzxXCeoGk4VWG96Dukpm6d3dX2uLZLM0waWYwuYx5b+D1Y3oUUPYXke/OHb4GV4yQ
	 5/HW/uJ0FNob2xdIw8/xTa02AYyrbg1sW1JVnY5p+gikc4iqQAKfjy5VP8r9hEJoQj
	 LNDMmFbM6mKNSehHBX2ICTXsRWmtovUJRiWsUweXp3WxVR7orKt9T+StU+YUrohY+I
	 OmkT2CaxjS5nQ==
Date: Tue, 15 Jul 2025 07:47:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: use xfs_trans_reserve_more in
 xfs_trans_reserve_more_inode
Message-ID: <20250715144755.GT2672049@frogsfrogsfrogs>
References: <20250715122544.1943403-1-hch@lst.de>
 <20250715122544.1943403-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715122544.1943403-2-hch@lst.de>

On Tue, Jul 15, 2025 at 02:25:34PM +0200, Christoph Hellwig wrote:
> Instead of duplicating the empty transacaction reservation
> definition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index b4a07af513ba..8b15bfe68774 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1163,14 +1163,13 @@ xfs_trans_reserve_more_inode(
>  	unsigned int		rblocks,
>  	bool			force_quota)
>  {
> -	struct xfs_trans_res	resv = { };
>  	struct xfs_mount	*mp = ip->i_mount;
>  	unsigned int		rtx = xfs_extlen_to_rtxlen(mp, rblocks);
>  	int			error;
>  
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
>  
> -	error = xfs_trans_reserve(tp, &resv, dblocks, rtx);
> +	error = xfs_trans_reserve_more(tp, dblocks, rtx);
>  	if (error)
>  		return error;
>  
> -- 
> 2.47.2
> 
> 
