Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E35189BAF
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734037948; cv=none; b=AvrLWITLoGb9b3woZFkxalvKxCExXAHiP45UptM8oO3X4YsDjgqxEyZqpGXrvfGRWA04osvDBn1RvMsCO1TSXFzEcKlwCbyYw5nD0kVLEl4nkLA8D1h8IP9mti4CEJLNGtMHBz4wE5fEdy6YrLCEBXdD4UnmMSEGjeI6SwMsgbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734037948; c=relaxed/simple;
	bh=t4ulW45zZ1nPJadllzl6LAOlNhw9gKsdmlqrMynZqAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uFqEo1BWisWLztQrpbNHRjZgFMUlfJNQ4Csf7PTYrIItrGUP0au4elONVn5M4iCtR4dxveXRpekSqUa/1LBfADg0Tv00yW+OSLVv4jOIEoKBmlGYalVYOULVL1fXEgx6OkQCHhYlbEJh07wrGtuwRg3zoUI8isJCzwWaUUpcUfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ok83Xa/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ok83Xa/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8B9C4CECE;
	Thu, 12 Dec 2024 21:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734037946;
	bh=t4ulW45zZ1nPJadllzl6LAOlNhw9gKsdmlqrMynZqAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ok83Xa/4GV98pS6Afob+bX6pCy/uKS9s6w8huuAsZIfJlc00m5/lDJ2iHIPTYZSfL
	 3qDSuv0v+lAczmy1f6Wh9rWxMe8uw0sN834NWKBcfCxB4DREAO24vjmO5EKjy9j09d
	 VCGleiI5pB6LT4RN04Plklj/KNRfcNqvTU3yUFYYH5GzlkLbX2Lkrys7JLToB3UJ0d
	 Z9B/n183cULJQuPx8y72bUTKTeLumeF7NC4f1R0du0MLJZjHbJuZWt/qYbHSl8pjKv
	 EfDtITxH0EdxM4HO038k7ZaLe+2t78O8d8ZwMx1qlgzDR+4k6sXlUmkLbqC2Q3zwp1
	 QZljYVMQ9xnJA==
Date: Thu, 12 Dec 2024 13:12:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/43] xfs: add a rtg_blocks helper
Message-ID: <20241212211225.GP6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-4-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:28AM +0100, Christoph Hellwig wrote:
> Shortcut dereferencing the xg_block_count field in the generic group
> structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, though I imagine there are a few more places where you could
use this helper?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtgroup.c | 2 +-
>  fs/xfs/libxfs/xfs_rtgroup.h | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> index d84d32f1b48f..97aad8967149 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.c
> +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> @@ -270,7 +270,7 @@ xfs_rtgroup_get_geometry(
>  	/* Fill out form. */
>  	memset(rgeo, 0, sizeof(*rgeo));
>  	rgeo->rg_number = rtg_rgno(rtg);
> -	rgeo->rg_length = rtg_group(rtg)->xg_block_count;
> +	rgeo->rg_length = rtg_blocks(rtg);
>  	xfs_rtgroup_geom_health(rtg, rgeo);
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index de4eeb381fc9..0e1d9474ab77 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -66,6 +66,11 @@ static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
>  	return rtg->rtg_group.xg_gno;
>  }
>  
> +static inline xfs_rgblock_t rtg_blocks(const struct xfs_rtgroup *rtg)
> +{
> +	return rtg->rtg_group.xg_block_count;
> +}
> +
>  static inline struct xfs_inode *rtg_bitmap(const struct xfs_rtgroup *rtg)
>  {
>  	return rtg->rtg_inodes[XFS_RTGI_BITMAP];
> -- 
> 2.45.2
> 
> 
