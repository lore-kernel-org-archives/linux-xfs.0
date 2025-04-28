Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C34925EF9C
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 09:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833938; cv=none; b=cwdqhSdfdHWCPZLcf1ekXK+QbOYLqOxkE7fQ7fc51xXwbLXT2lA7pw5ct2Tk2Q6+/+im3FRatoIh194Y2ldFANZoxUwKcq962ehkuBFZwFRx2IL+/Ykfi+H7bQj5FBAwMZICk3vO+6mOu9R+eGOLZx1nAik29+tnwI2g8pj1Nz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833938; c=relaxed/simple;
	bh=Nx9lnuShYP6/h1Nj1FPmBLlG9N4NtZIn8PAasWKe0aU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBrX53BztaIVXOwk/MDCqgB18pl7RvO6rdp4yuWlO1UKVHT2lf7sMWR21PbFQSqV9UhOC8roS1UliWKzeUjmFiz7PuVeVB6bHpodJoSKl+WO4Wsz7ThvfkqfFlsH6wkWaArjFiqQrsZXyk+RtWgj9MPws6KeUi1YRTkdbRgakEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pdtot2fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pdtot2fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C1FC4CEE4;
	Mon, 28 Apr 2025 09:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745833936;
	bh=Nx9lnuShYP6/h1Nj1FPmBLlG9N4NtZIn8PAasWKe0aU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pdtot2fhhmx1Dx+AgrpPTsNvK3XDqcQHIREAuQs08Ltm/ITpst1vZZCvAbsDNIgD4
	 MilsVTzIVqPncHABcN68TtpLkvkEMeeBHQmoPtLaBeoIix8o/dOaV4ju8l0pl9kX2T
	 CZSs1x0hnzxt4iuKrcas92Rimw3SUpcpgtfJ+Rcam7dFnxSXwN5M2cKHundxNlc9JB
	 AYWWBtK/09z4tGsSa8nyrxHwZJvOI3WvI+P69FwntlO/jBDo4ORvBgVfU0vOQFWwCS
	 DJ3eLVZ5We26I8oUmzTXgXLnVNKbUqZHyD5kb7XrHF9MvF/xt8gZsgCrQyTcHAZZee
	 AcNJG2DSPlCSA==
Date: Mon, 28 Apr 2025 11:52:12 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Message-ID: <iboil7qz4s76y53wlwvpnu2diypdv5bdryoqwhlh4duat5dtj2@lkptlw2z3pdq>
References: <M6FcYEJbADh29bAOdxfu6Qm-ktiyMPYZw39bsvsx-RJNJsTgTMpoahi2HA9UAqfEH9ueyBk3Kry5vydrxmxWrA==@protonmail.internalid>
 <20250425085217.9189-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425085217.9189-1-hans.holmberg@wdc.com>

On Fri, Apr 25, 2025 at 08:52:53AM +0000, Hans Holmberg wrote:
> Allow read-only mounts on rtdevs and logdevs that are marked as
> read-only and make sure those mounts can't be remounted read-write.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
> 
> I will post a couple of xfstests to add coverage for these cases.
> 
>  fs/xfs/xfs_super.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b2dd0c0bf509..d7ac1654bc80 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -380,10 +380,14 @@ xfs_blkdev_get(
>  	struct file		**bdev_filep)
>  {
>  	int			error = 0;
> +	blk_mode_t		mode;
> 
> -	*bdev_filep = bdev_file_open_by_path(name,
> -		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
> -		mp->m_super, &fs_holder_ops);
> +	mode = BLK_OPEN_READ | BLK_OPEN_RESTRICT_WRITES;

	Does BLK_OPEN_RESTRICT_WRITES makes sense without BLK_OPEN_WRITE?
	Perhaps this should be OR'ed together with OPEN_WRITE below?


-Carlos

> +	if (!xfs_is_readonly(mp))
> +		mode |= BLK_OPEN_WRITE;

> +
> +	*bdev_filep = bdev_file_open_by_path(name, mode,
> +			mp->m_super, &fs_holder_ops);
>  	if (IS_ERR(*bdev_filep)) {
>  		error = PTR_ERR(*bdev_filep);
>  		*bdev_filep = NULL;
> @@ -1969,6 +1973,20 @@ xfs_remount_rw(
>  	struct xfs_sb		*sbp = &mp->m_sb;
>  	int error;
> 
> +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp &&
> +	    bdev_read_only(mp->m_logdev_targp->bt_bdev)) {
> +		xfs_warn(mp,
> +			"ro->rw transition prohibited by read-only logdev");
> +		return -EACCES;
> +	}
> +
> +	if (mp->m_rtdev_targp &&
> +	    bdev_read_only(mp->m_rtdev_targp->bt_bdev)) {
> +		xfs_warn(mp,
> +			"ro->rw transition prohibited by read-only rtdev");
> +		return -EACCES;
> +	}
> +
>  	if (xfs_has_norecovery(mp)) {
>  		xfs_warn(mp,
>  			"ro->rw transition prohibited on norecovery mount");
> --
> 2.34.1
> 
