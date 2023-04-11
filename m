Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C39C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 23:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjDKXcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDKXco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 19:32:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B4130FD
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E3D860C8C
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 23:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BC9C433EF;
        Tue, 11 Apr 2023 23:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681255962;
        bh=oHwt7TbA7M0IWAea6dtn2TjX4e9G5vRLcrx+/vul/AE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tAQgTHHRzgWev3o+wKs9rVvZfoHte/9cfwvInai+PdMbOZg1fc7X7Bm5Dk4CA533y
         bqEZBv3+tK9izn9z71iFPSTWCwfMSiV+z6/Bo5f6+iJtQ3h72VdSHYwKib8hEl4Fhc
         8cHSdkixqod7RS2LejukclxL3MdM/w3Aa+f1+8mfXpF628+qvmR+vspWtLlfSjrwh3
         lmJfqPBH69n3Pyrqmwt61f1q8pKO+kvGqUAlX5i9f5UsepDHYBk2NHCGhjZ8gEJNMf
         Yl5FFfqr4QsAc+wOBrpoDA2lsXbi/P3bIAwOeEs4kUU0lWvQevZkPoVGjXfjXKQEwO
         7xtMEPLPTK3vA==
Date:   Tue, 11 Apr 2023 16:32:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't consider future format versions valid
Message-ID: <20230411233241.GM360889@frogsfrogsfrogs>
References: <20230411232342.233433-1-david@fromorbit.com>
 <20230411232342.233433-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411232342.233433-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 09:23:42AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In commit fe08cc504448 we reworked the valid superblock version
> checks. If it is a V5 filesystem, it is always valid, then we
> checked if the version was less than V4 (reject) and then checked
> feature fields in the V4 flags to determine if it was valid.
> 
> What we missed was that if the version is not V4 at this point,
> we shoudl reject the fs. i.e. the check current treats V6+
> filesystems as if it was a v4 filesystem. Fix this.
> 
> cc: stable@vger.kernel.org
> Fixes: fe08cc504448 ("xfs: open code sb verifier feature checks")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ugh, old code...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 99cc03a298e2..ba0f17bc1dc0 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -72,7 +72,8 @@ xfs_sb_validate_v5_features(
>  }
>  
>  /*
> - * We support all XFS versions newer than a v4 superblock with V2 directories.
> + * We current support XFS v5 formats with known features and v4 superblocks with
> + * at least V2 directories.
>   */
>  bool
>  xfs_sb_good_version(
> @@ -86,16 +87,16 @@ xfs_sb_good_version(
>  	if (xfs_sb_is_v5(sbp))
>  		return xfs_sb_validate_v5_features(sbp);
>  
> +	/* versions prior to v4 are not supported */
> +	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_4)
> +		return false;
> +
>  	/* We must not have any unknown v4 feature bits set */
>  	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
>  	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
>  	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
>  		return false;
>  
> -	/* versions prior to v4 are not supported */
> -	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
> -		return false;
> -
>  	/* V4 filesystems need v2 directories and unwritten extents */
>  	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
>  		return false;
> -- 
> 2.39.2
> 
