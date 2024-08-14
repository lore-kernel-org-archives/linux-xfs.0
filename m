Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7489720B0F
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 05:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723614079; cv=none; b=MJ9xL5gBywqB1vvFfIKb45gfCtLUgTQajdOcsPsiMoQRQtyOb6mwY0yKGRhsx0VV6sMObdoF4c07QIjprArFlNe1KspBRO2Rou35eIesbSg6B4QXOdeoPSaRk3BSjMytTdPk1iPxP/dtYKqWQ6nBAQvBEDCtp69EZta0JIDE5Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723614079; c=relaxed/simple;
	bh=mCwAcsmcgmHjo7/6m1n46KO1VdNH8oGQO2+coBF91jI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HidKo/RBiR2l5JawXsb/DrPBuikbJci20vtY9TD8QyN/AJcvwP75RDdmUDUpDuCSuZViz7z8OVht9A4CaZ1d0uIOb0LKm5r9EVGA6w+Ayq/Toi+RoATYWfMpn/y24oUQ7s+Yjy7ESHHF4hbcR8IrgepULHoo3PnvZdX/xmZpiSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nb3LqFuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nb3LqFuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAE1C32786;
	Wed, 14 Aug 2024 05:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723614078;
	bh=mCwAcsmcgmHjo7/6m1n46KO1VdNH8oGQO2+coBF91jI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nb3LqFuz+PHWtLLG3UuOfYalYMUC0/wl7LL8wLKkUUEjLLuqPCBDjgysfeaTTI4l9
	 lEEzkD4kPWLDjH5Ns7TU8yfWWQAGSNv7zmUBnOPSrnksWc3/qO+f1fouvAcUdxDJIY
	 BHKG3X/OL1/Yt2EjJVdg3mlLoXRwdSusEtQsObtZbjUhh6DFbbV6ZtS24Vs/LFAgPv
	 ZQHuDW4AHUYCbm0ishO/GOrSVmv12qlaNDX+W9GfXtb7fqmWydnhRN6A1/VA8DOfEj
	 T0dhtMugJPZzgVYQ1dTwpH8XRVBsmjdYMINxtFuc2RH8QmZmgfZSF1vO7ywuJRp6Bi
	 kxLQnykgDd2gA==
Date: Tue, 13 Aug 2024 22:41:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt device
 does not support discard
Message-ID: <20240814054118.GE865349@frogsfrogsfrogs>
References: <20240814042358.19297-1-hch@lst.de>
 <20240814042358.19297-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814042358.19297-2-hch@lst.de>

On Wed, Aug 14, 2024 at 06:23:58AM +0200, Christoph Hellwig wrote:
> Fix the newly added discard support to only offer a FITRIM range that
> spans the RT device in addition to the main device if the RT device
> actually supports discard.  Without this we'll incorrectly accept
> a larger range than actually supported and confuse user space if the
> RT device does not support discard.  This can easily happen when the
> main device is a SSD but the RT device is a hard driver.
> 
> Move the code around a bit to keep the max_blocks and granularity
> assignments together and to handle the case where only the RT device
> supports discard as well.
> 
> Fixes: 3ba3ab1f6719 ("xfs: enable FITRIM on the realtime device")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_discard.c | 37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 6516afecce0979..46e28499a7d3ce 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -654,9 +654,9 @@ xfs_ioc_trim(
>  	struct xfs_mount		*mp,
>  	struct fstrim_range __user	*urange)
>  {
> -	unsigned int		granularity =
> -		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
> +	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
>  	struct block_device	*rt_bdev = NULL;
> +	unsigned int		granularity = 0;
>  	struct fstrim_range	range;
>  	xfs_daddr_t		start, end;
>  	xfs_extlen_t		minlen;
> @@ -666,15 +666,6 @@ xfs_ioc_trim(
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	if (mp->m_rtdev_targp &&
> -	    bdev_max_discard_sectors(mp->m_rtdev_targp->bt_bdev))
> -		rt_bdev = mp->m_rtdev_targp->bt_bdev;
> -	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev) && !rt_bdev)
> -		return -EOPNOTSUPP;

Does this still return EOPNOTSUPP if there's no rt device and the data
device doesn't support discard?  I only see an EOPNOTSUPP return if
there is a rt device and both devices don't support discard.

> -
> -	if (rt_bdev)
> -		granularity = max(granularity,
> -				  bdev_discard_granularity(rt_bdev));
>  
>  	/*
>  	 * We haven't recovered the log, so we cannot use our bnobt-guided
> @@ -683,13 +674,33 @@ xfs_ioc_trim(
>  	if (xfs_has_norecovery(mp))
>  		return -EROFS;
>  
> +	if (bdev_max_discard_sectors(bdev)) {
> +		max_blocks = mp->m_sb.sb_dblocks;
> +		granularity = bdev_discard_granularity(bdev);
> +	} else {
> +		bdev = NULL;
> +	}
> +
> +	if (mp->m_rtdev_targp) {
> +		rt_bdev = mp->m_rtdev_targp->bt_bdev;
> +		if (!bdev_max_discard_sectors(rt_bdev)) {
> +			if (!bdev)
> +				return -EOPNOTSUPP;
> +			rt_bdev = NULL;
> +		}
> +	}
> +	if (rt_bdev) {
> +		max_blocks += mp->m_sb.sb_rblocks;

I think this will break xfs_scrub, which (unlike fstrim) breaks up its
FITRIM requests into smaller pieces.  The (afwul) FITRIM interface says
that [0, dblocks) trims the data device, and [dblocks, dblocks +
rblocks) trims the realtime device.

If the data device doesn't support discard, max_blocks will be rblocks,
and that's what we use to validate the @start parameter.  For example,
if the data device is 10T spinning rust and the rt device is a 10G SSD,
max_blocks will be 10G.  A FITRIM request for just the rt device will be
[10T, 10G), which now fails with EINVAL.

I don't have a fix to suggest for this yet, but let me play around with
this tomorrow and see if I can come up with something better, or figure
out how I'm being thick. ;)

My guess is that what we really want is if either device supports
discard we allow the full range, but if a specific device doesn't
support discard then we skip it and don't add anything to the outgoing
range.len.  But that's what I thought the current code does. <shrug>

--D

> +		granularity =
> +			max(granularity, bdev_discard_granularity(rt_bdev));
> +	}
> +
>  	if (copy_from_user(&range, urange, sizeof(range)))
>  		return -EFAULT;
>  
>  	range.minlen = max_t(u64, granularity, range.minlen);
>  	minlen = XFS_B_TO_FSB(mp, range.minlen);
>  
> -	max_blocks = mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks;
>  	if (range.start >= XFS_FSB_TO_B(mp, max_blocks) ||
>  	    range.minlen > XFS_FSB_TO_B(mp, mp->m_ag_max_usable) ||
>  	    range.len < mp->m_sb.sb_blocksize)
> @@ -698,7 +709,7 @@ xfs_ioc_trim(
>  	start = BTOBB(range.start);
>  	end = start + BTOBBT(range.len) - 1;
>  
> -	if (bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev)) {
> +	if (bdev) {
>  		error = xfs_trim_datadev_extents(mp, start, end, minlen,
>  				&blocks_trimmed);
>  		if (error)
> -- 
> 2.43.0
> 
> 
