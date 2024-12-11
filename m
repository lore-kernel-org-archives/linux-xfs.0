Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E6F24632E
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 18:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733941155; cv=none; b=DI2kMLGaiv2sD31QZlwr9GODH3Rx1eWTpSgbWyNG0pDedgG4vZfKDpJW3gTyRWsoo9hHOr7/O5qmgReeX4Re3v1sPj2hrK3ysGgrbcDryN5WFGkMpmLSdzdKiTehJrmTTAOmthkvcMUOqD+o0A8D9dX4GSIsUwhPefjnzQXbyP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733941155; c=relaxed/simple;
	bh=yOjypnPICJoqFydMgHZgrlptJoYd9f0SoVvEU5lat0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HbTab/iJgNpB8m/oyalcl4j05Oej1TNaSUjA94ozGQLETAd96GXC/MFMGsPbxnaNcWWWjrTEMKSQ+SX6J4d8W0Yqr6+xpXRI64ZptRJ34nGffVhVGwRxqMaZnU1FnDahUO0ZikyJy4F6+ZnviVAw9uhiZxlyZY6sLPdMMG1sjjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAbpBdSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAbpBdSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6BCC4CED2;
	Wed, 11 Dec 2024 18:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733941154;
	bh=yOjypnPICJoqFydMgHZgrlptJoYd9f0SoVvEU5lat0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WAbpBdSzKWwCMQzVEuAOkKnfkwHak0mELho6U3Pl6FMOTgg7+pyY2IaqMSZlfQGQ3
	 l2BA+T0YszqTEjEKiMZaOaOM/rhzzdwKMb7Qk+oyo3dbi01fCiFrGwm5/EPcQaMGjw
	 NJPDG99AEZbga4rbUnkfbYiwCrKNuRRbJnpGPhI9pbEGACJu8j5N7ioX9Zyd0+/4dZ
	 ig6bYa5+w6lTdf7iKOjPrxp1ZKp1rgF0LVKrI6pSsh/Vim3Hbm6j0qNAC36pSgeHM+
	 PZk0wuQHjHvRbHUZrTjRhlUlc/dNMpeorj5u0TW76je5H8W8mNuhm2JPWvQCSrLv8F
	 QDShlC9CnnTPA==
Date: Wed, 11 Dec 2024 10:19:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] man: document rgextents geom field
Message-ID: <20241211181914.GE6678@frogsfrogsfrogs>
References: <20241211180542.1411428-1-hch@lst.de>
 <20241211180542.1411428-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211180542.1411428-3-hch@lst.de>

On Wed, Dec 11, 2024 at 07:05:37PM +0100, Christoph Hellwig wrote:
> Document the new rgextent geom field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  man/man2/ioctl_xfs_fsgeometry.2 | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
> index c808ad5b8b91..502054f391e9 100644
> --- a/man/man2/ioctl_xfs_fsgeometry.2
> +++ b/man/man2/ioctl_xfs_fsgeometry.2
> @@ -49,7 +49,8 @@ struct xfs_fsop_geom {
>  
>  	__u32         sick;
>  	__u32         checked;
> -	__u64         reserved[17];
> +	__u64         rgextents;
> +	__u64         reserved[16];
>  };
>  .fi
>  .in
> @@ -139,6 +140,9 @@ Please see the section
>  .B XFS METADATA HEALTH REPORTING
>  for more details.
>  .PP
> +.I rgextents
> +Is the number of RT extents in each rtgroup.
> +.PP
>  .I reserved
>  is set to zero.
>  .SH FILESYSTEM FEATURE FLAGS
> -- 
> 2.45.2
> 
> 
