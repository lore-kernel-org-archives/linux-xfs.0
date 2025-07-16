Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807D11D7E26
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681781; cv=none; b=GAYgJNs7OFrmXLnudSmLo2VQk50MUaznmuta2+YOauF2hDNlinoSYqno1Sskjged2psPD1jTyFXLYKHDVGh/BQIYb4PjTPTuqaDAM8zkafMaZpp3CmaoWhm40uXMa9nLjehzoK/1a+BfnHaSXA0wDHlYHmEMRC2zfsIUVewgED8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681781; c=relaxed/simple;
	bh=z6H6MpcSvxEQDgOZ9+vME4rJ9jwXYwLHbwOXRd5Tro0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knims8hvcamWW7//aI3bYUg3AzALIa1cNckQuiN1VtcplCk9ilSCiWNBUMk/9ao6iJRF0qi6JQNJS9UOYqgnY/ijnUWRh/yLJYHRr96gnWxZSW9iZXKNMibNFPGam26jOX8wj234aDJaSuwkxUBo+cgHsoNz44ss6egZwjwlXEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XavNWOHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XavNWOHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5777FC4CEF0;
	Wed, 16 Jul 2025 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752681781;
	bh=z6H6MpcSvxEQDgOZ9+vME4rJ9jwXYwLHbwOXRd5Tro0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XavNWOHonw1cdqJsYmM8nEmJZzwjCRLjcExA4GqLhu/BnX2j1n8geJS9bIAy1z91n
	 mcsmEPfDGR0g16G8BCWxl3IhI3I2J8yhE+1Qv26ra2QUoy0/4o14DR1Yz4TFBGC4Z7
	 Yg7ykdU1/ibkewLevXIltsMlLv4ZGANfdHormWdSUDFusvHGm4k+/ofvkG7BgrW+PK
	 jMvcLFEc3XCBitmHVmNqgBA9ndp13NtLD0Arynidho9KNLcnGyAhCnN6KgtrcIcIJs
	 GKyFtlBxB454qNxpG4FmnKy4q3Z6GygO1b6jqXthTBrCPNtde2cZvJxACsvz6FpuDW
	 L/WIl/XdtqtLQ==
Date: Wed, 16 Jul 2025 09:03:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: improve the comments in xfs_max_open_zones
Message-ID: <20250716160300.GM2672049@frogsfrogsfrogs>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716125413.2148420-7-hch@lst.de>

On Wed, Jul 16, 2025 at 02:54:06PM +0200, Christoph Hellwig wrote:
> Describe the rationale for the decisions a bit better.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_alloc.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index d9e2b1411434..c1f053f4a82a 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1114,24 +1114,27 @@ xfs_get_zone_info_cb(
>  }
>  
>  /*
> - * Calculate the max open zone limit based on the of number of
> - * backing zones available
> + * Calculate the max open zone limit based on the of number of backing zones
> + * available.
>   */
>  static inline uint32_t
>  xfs_max_open_zones(
>  	struct xfs_mount	*mp)
>  {
>  	unsigned int		max_open, max_open_data_zones;
> +
>  	/*
> -	 * We need two zones for every open data zone,
> -	 * one in reserve as we don't reclaim open zones. One data zone
> -	 * and its spare is included in XFS_MIN_ZONES.
> +	 * We need two zones for every open data zone, one in reserve as we
> +	 * don't reclaim open zones.  One data zone and its spare is included
> +	 * in XFS_MIN_ZONES to support at least one user data writer.
>  	 */
>  	max_open_data_zones = (mp->m_sb.sb_rgcount - XFS_MIN_ZONES) / 2 + 1;
>  	max_open = max_open_data_zones + XFS_OPEN_GC_ZONES;
>  
>  	/*
> -	 * Cap the max open limit to 1/4 of available space
> +	 * Cap the max open limit to 1/4 of available space.  Without this we'd
> +	 * run out of easy reclaim targets too quickly and storage devices don't
> +	 * handle huge numbers of concurrent write streams overly well.
>  	 */
>  	return clamp(max_open, XFS_MIN_OPEN_ZONES, mp->m_sb.sb_rgcount / 4);
>  }
> -- 
> 2.47.2
> 
> 
