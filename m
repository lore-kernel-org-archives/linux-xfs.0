Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6309633B6D5
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 17:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778174279; cv=none; b=OwewpK1EHW8u2rj63JvbmJN1bdKnysJILDwO7V6HBUKhHjN6PAoqiNtEClL2i++VKxD5eqodd0AbrQP8kwN5VAXecwbBM9z/Wk/545pIi/SeHZDCRQqH+EETEIP20VJgL0UDBCXQeSSYqb6Wmut7REV3KG4ctPJPMcvlvWBvHRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778174279; c=relaxed/simple;
	bh=1uNGP+aKHdEyZ+6iWWPeGYIMU4fA5KIF+Fs3mGoSm8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nw9Gk6TcEhXcq3W6DKrTTW7SgaAWhicwTUbdmbh4KW6h7VXZWyQkHzxiiXMQRi/PGcHF2WWOzulIQCHsfK132yq0eF04io5gxBjlWZmCzv+tCknhNruZYgTVUGrCqtdwBG58MR578Y2Vd7TOiFP4Xkms3SD8lIygbpnrpYezWmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUq3F3EC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUq3F3EC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5B7C2BCB2;
	Thu,  7 May 2026 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778174279;
	bh=1uNGP+aKHdEyZ+6iWWPeGYIMU4fA5KIF+Fs3mGoSm8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZUq3F3ECuP4NReQIFZsjJLL+shjsXcC4Zz9INgVHrCUWsrq9Kt7JHjieoRQQlM/Z4
	 sWo6nNoJ/PZO2me7Pd7F+etibrsJvARNXKtI8DAlRgK5vNoLpZADyYVSlmIG9yw0P4
	 RTUajp0zASon5AvV4FQBMoyNfH4ls9a2agVi+Qomy4GmQai/q9F0pPfOfRIvJC5tYS
	 oNEZUsHNxV4qDLjH0IBMbYcBONqq0hi4MAEOH8JoKMtX6IuUj7adBJ8b8tcizr2CNZ
	 BYQoRXcRyu4m7+gNC9zIVPDHWo8eOZ0uT25dFPVbrIY/vzMIyx1keCuUVPD9EgNa+5
	 brJZUymP+pX4A==
Date: Thu, 7 May 2026 10:17:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: improve RT geometry validation
Message-ID: <20260507171758.GJ7751@frogsfrogsfrogs>
References: <20260507052543.1305129-1-hch@lst.de>
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

Isn't this already covered by xfs_validate_sb_rtgroups?


	groups = howmany_64(sbp->sb_rextents, sbp->sb_rgextents);
	if (groups != sbp->sb_rgcount) {
		xfs_warn(mp,
"Realtime groups (%u) do not cover the entire rt section; need (%llu) groups.",
				sbp->sb_rgcount, groups);
		return -EINVAL;
	}

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

And shouldn't this be in xfs_validate_sb_zoned?

Or do you want this in xfs_validate_rt_geometry because that's what
xfs_repair calls to check the superblock?

--D
