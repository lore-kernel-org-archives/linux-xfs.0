Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1392484A30
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404464; cv=none; b=ZsMXvFNZMtCy85LBac90vGYGL3tENDY6HUGu0+Pr+bAr61qQRYbEwGCMBOz4ksS1Pj8jII2vg35c6jPlT+EyNWb8/1ncUV7N1s4+7pQYzGGX15WIUp+3TD7KfBRHCrtNmbwCiGUS4yRaZEpnvgH37pzQMGqHNvtk/S4wY+TnfTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404464; c=relaxed/simple;
	bh=Jg+JAU5uJgLPFU0wrIphJbGKFnG+Vjp2eSaSlYwc5/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cn50cEjPva4GfkbafEBiXuaY0KYW3PmsWN+tMNVbpbLBkf0VIzzXPvHuHrRmAXRXd5Mr4RCi3s0sdOA9g5et9FKyMnCvggjzncJA7v4be21+01k2qrNEQSJwImjjAHX8abMcyMCYvAgf8neRaUk7TPGG0GqZAgO/h/TCH75fxKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBtqWxnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBtqWxnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C32CC116B1;
	Mon, 29 Apr 2024 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714404463;
	bh=Jg+JAU5uJgLPFU0wrIphJbGKFnG+Vjp2eSaSlYwc5/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iBtqWxnBHZrU9zYFUUjiOm0M3wvimxGsonWvV4HkAY5SD5mIknwFWqvVCR+TtILjG
	 nOrTnLqVht2rJbbL090R9JqAwBg6maEsLDwHNdJaRHKc+4cTntH5Xf4Hk6P96OBaQ7
	 8CMnvfLbJbJI425rU0Cw6LXaAe8lKX2XUUZ9dIn9QLZNPglHVFd6t4ENYTqOv4V+qk
	 F/2IBqtAwacLVHi4Rg5So4SI7yNIleTPI3VRs5Olm3MGukrR4gFHtfSrLTv2IMUICC
	 V/gdUe+9UuNunpMYgCLk7YuSxSgGoxTXCjYGqYAeVqmJxNmxk7gDSZbysTPi146+pf
	 OpUG2t4MYRYzg==
Date: Mon, 29 Apr 2024 08:27:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: remove a racy if_bytes check in
 xfs_reflink_end_cow_extent
Message-ID: <20240429152743.GW360919@frogsfrogsfrogs>
References: <20240429044917.1504566-1-hch@lst.de>
 <20240429044917.1504566-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429044917.1504566-3-hch@lst.de>

On Mon, Apr 29, 2024 at 06:49:11AM +0200, Christoph Hellwig wrote:
> Accessing if_bytes without the ilock is racy.  Remove the initial
> if_bytes == 0 check in xfs_reflink_end_cow_extent and let
> ext_iext_lookup_extent fail for this case after we've taken the ilock.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I wonder if this has any practical (mal)effects on the system?

Regardless,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_reflink.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 9ce37d366534c3..0ab2ef5b58f6c4 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -731,12 +731,6 @@ xfs_reflink_end_cow_extent(
>  	int			nmaps;
>  	int			error;
>  
> -	/* No COW extents?  That's easy! */
> -	if (ifp->if_bytes == 0) {
> -		*offset_fsb = end_fsb;
> -		return 0;
> -	}
> -
>  	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
>  			XFS_TRANS_RESERVE, &tp);
> -- 
> 2.39.2
> 
> 
