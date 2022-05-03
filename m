Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B246DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiECXCz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 19:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiECXCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 19:02:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827A641630
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40176B821F1
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 22:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC05C385A9;
        Tue,  3 May 2022 22:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651618759;
        bh=45SKE5QCotaTGn6SziK2LOU15o/xO+6D5HHYvAVjQ8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ic3WvwUWRcyQ9fTmWv0A65qwjWM/zRbKhG4VVSzewhHjs5DtW+PVNgE7dtEKrEHqQ
         BXzKVoo4LLONVjcAiRR5tYdqKVHKFDhd0Da9tcvPjMSnzOwx83I9XT+Ba8jewxQ9SW
         Vs599J45PhozsZFfDL71ph1j4E8Eq5b1Ul6Sm3GJy6mfRwsgo0hEvfzFXGBqx3xtgD
         qcGW+QrUWP69ax1k4tSyClzFyxsY+TOLFIDuXE+vRFoo3/J2WzTk4mjVTl99SxGqyf
         Q/QUWaR0XSlzV5atNxRiKc4FWHiNtBekxVjmQYtdMPV09uPhSYOx/IktkduyiaqX3x
         NzLpFrtqpUk6Q==
Date:   Tue, 3 May 2022 15:59:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: validate v5 feature fields
Message-ID: <20220503225918.GI8265@magnolia>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502082018.1076561-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 02, 2022 at 06:20:18PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because stupid dumb fuzzers.

Dumb question: Should we make db_flds[] in db/sb.c (userspace) report
each individual feature flag as a field_t?  I've been wondering why none
of my fuzz tests ever found these problems, and it's probably because
it never hit the magic bits that $scriptkiddie happened to hit.

Modulo hch's comments,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 67 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 57 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index ec6eec5c0e02..d1afe0d43d7f 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -30,6 +30,46 @@
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
>   */
>  
> +/*
> + * Validate all the compulsory V4 feature bits are set on a V5 filesystem.
> + */
> +bool
> +xfs_sb_validate_v5_features(
> +	struct xfs_sb	*sbp)
> +{
> +	/* We must not have any unknown V4 feature bits set */
> +	if (sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS)
> +		return false;
> +
> +	/*
> +	 * The CRC bit is considered an invalid V4 flag, so we have to add it
> +	 * manually to the OKBITS mask.
> +	 */
> +	if (sbp->sb_features2 & ~(XFS_SB_VERSION2_OKBITS |
> +				  XFS_SB_VERSION2_CRCBIT))
> +		return false;
> +
> +	/* Now check all the required V4 feature flags are set. */
> +
> +#define V5_VERS_FLAGS	(XFS_SB_VERSION_NLINKBIT	| \
> +			XFS_SB_VERSION_ALIGNBIT		| \
> +			XFS_SB_VERSION_LOGV2BIT		| \
> +			XFS_SB_VERSION_EXTFLGBIT	| \
> +			XFS_SB_VERSION_DIRV2BIT		| \
> +			XFS_SB_VERSION_MOREBITSBIT)
> +
> +#define V5_FEAT_FLAGS	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
> +			XFS_SB_VERSION2_ATTR2BIT	| \
> +			XFS_SB_VERSION2_PROJID32BIT	| \
> +			XFS_SB_VERSION2_CRCBIT)
> +
> +	if ((sbp->sb_versionnum & V5_VERS_FLAGS) != V5_VERS_FLAGS)
> +		return false;
> +	if ((sbp->sb_features2 & V5_FEAT_FLAGS) != V5_FEAT_FLAGS)
> +		return false;
> +	return true;
> +}
> +
>  /*
>   * We support all XFS versions newer than a v4 superblock with V2 directories.
>   */
> @@ -37,9 +77,19 @@ bool
>  xfs_sb_good_version(
>  	struct xfs_sb	*sbp)
>  {
> -	/* all v5 filesystems are supported */
> +	/*
> +	 * All v5 filesystems are supported, but we must check that all the
> +	 * required v4 feature flags are enabled correctly as the code checks
> +	 * those flags and not for v5 support.
> +	 */
>  	if (xfs_sb_is_v5(sbp))
> -		return true;
> +		return xfs_sb_validate_v5_features(sbp);
> +
> +	/* We must not have any unknown v4 feature bits set */
> +	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
> +	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
> +	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
> +		return false;
>  
>  	/* versions prior to v4 are not supported */
>  	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
> @@ -51,12 +101,6 @@ xfs_sb_good_version(
>  	if (!(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT))
>  		return false;
>  
> -	/* And must not have any unknown v4 feature bits set */
> -	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
> -	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
> -	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
> -		return false;
> -
>  	/* It's a supported v4 filesystem */
>  	return true;
>  }
> @@ -267,12 +311,15 @@ xfs_validate_sb_common(
>  	bool			has_dalign;
>  
>  	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
> -		xfs_warn(mp, "bad magic number");
> +		xfs_warn(mp,
> +"Superblock has bad magic number 0x%x. Not an XFS filesystem?",
> +			be32_to_cpu(dsb->sb_magicnum));
>  		return -EWRONGFS;
>  	}
>  
>  	if (!xfs_sb_good_version(sbp)) {
> -		xfs_warn(mp, "bad version");
> +		xfs_warn(mp,
> +"Superblock has unknown features enabled or corrupted feature masks.");
>  		return -EWRONGFS;
>  	}
>  
> -- 
> 2.35.1
> 
