Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95CA3EE1F1
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 12:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778156227; cv=none; b=GxMIRTTkIeJ1BJHn8qc8tG4Jkre8ttv1iOTtQXtpLD7uLtfIAtsWNXj7w2rtQDuBIGVIvGN5/YrhvVk7Fr6H+kAGiz5ID6DsR0+879xXrk9/0c0tpmWhJC33KMWn6uita7EvXCgal2wF60Um+kDiRAxa4oHu54XWMvOmb4D9xdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778156227; c=relaxed/simple;
	bh=+WPNjgw8FlEbVSXdbMbypZJbOckQMgbf8dIDIa9h+ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g24V8RKxhFqtCfK+UH+ExejGyMJKxfsuabXSGpZpngzUYa36uHM4crw6lgxaM9cWuewhfBX7KAHA0th9wvEZ1bpxYUixQxgzJ0HVz9n9bpb1Jc8GDGny7PwacOS4IpYrDo/LwDGYygocMTkYfh+/DWQ2OIXA8qkreLgKBrbiMwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRngfCiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRngfCiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8E7C2BCB8;
	Thu,  7 May 2026 12:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778156226;
	bh=+WPNjgw8FlEbVSXdbMbypZJbOckQMgbf8dIDIa9h+ZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FRngfCizoD9bEHlIysi9RtrOnXT7MJq0HoA24/UEZ8lP5CeDhOCuqfMtC8yD6r3N5
	 9vt8797AlNXo+HZx4PN/lEM3ie2nPt5YxlhhnD3F4A+VjQaTu2K04J9L5g52C3MEBu
	 aF1yR7oknA175hD5ojWpAoeqlGZaYauJNY/iOzuemmRmSl7lj2ctJ5k0htyEUSfEJA
	 AfEf9YADBr/af8XYh6QgZL1sN7C9wkkIwBXYUqlC9zbl+3sk7GS1MagsUz1nQz+xtm
	 Dhzw6X/+YsM3j/qGTiS6jHIES6Tg32C9L2agvm1GXRFgtnMPFUxHPYQTK34tHKUU2u
	 NW4EkPWyKJBxA==
Date: Thu, 7 May 2026 14:17:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: improve RT geometry validation
Message-ID: <afyAzghWC9_lwf13@andromeda.toxiclabs.cc>
References: <wV6uRtt8Mdv0dR-Ory4pMu4E-SDYDmUrTwaPRauY7S4lM07r4ogMmp38xxeF3FNG3X_E46ujDJHX94Lq_Oe-Vg==@protonmail.internalid>
 <20260507052543.1305129-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507052543.1305129-1-hch@lst.de>

On Thu, May 07, 2026 at 07:25:35AM +0200, Christoph Hellwig wrote:
> Make sure the rtgcount is plausible for the given RT group size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 47322adb7690..c0354f43704f 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -302,17 +302,25 @@ xfs_validate_rt_geometry(
>  		return false;
> 
>  	if (xfs_sb_is_v5(sbp) &&
> -	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
> +	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
> +		uint64_t		nr_rgs;
>  		uint32_t		mod;
> 
>  		/*
> -		 * Zoned RT devices must be aligned to the RT group size,
> -		 * because garbage collection assumes that all zones have the
> -		 * same size to avoid insane complexity if that weren't the
> -		 * case.
> +		 * Check that the number of rgcounts is plausible for the RG
> +		 * size.
> +		 */
> +		nr_rgs = div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
> +		if (nr_rgs != sbp->sb_rgcount + !!mod)
> +			return false;
> +
> +		/*
> +		 * Zoned RT devices must be aligned to the RT group size because
> +		 * garbage collection assumes that all zones have the same size
> +		 * to avoid insane complexity if that weren't the case.
>  		 */
> -		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
> -		if (mod)
> +		if ((sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) &&
> +		    mod > 0)
>  			return false;
>  	}

Looks good
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> --
> 2.53.0
> 
