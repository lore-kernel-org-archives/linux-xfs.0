Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E1D1C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 262AC619E8
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCXSeg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237203AbhCXSeV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F2C561A07;
        Wed, 24 Mar 2021 18:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616610861;
        bh=+NTW2++EsfJUNZCQ/2jn8Lbh3OJrpKW+mb6zJ7jb2YA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RCKoOOMZYOA4jl0g0K/uJWUmMbiBmQ47D7iT0OohnE1IcBmQGZFqkEo6CyBOFs897
         x6qkA8eM3QHZiJa+dACutENUFDCzaPUWqkiUHjY5JCFd7I9IST4QGsGWP6LoI+69GM
         sjnWFElEJ25rdpYrV83518EkhDm4DtfeAQBmzo3lqRDvMF9NXW4nhLB/W7Vji/rNv6
         wJVZjBSqMG0g7/DFZoUlHlgqYr6FgsZftBijdcHVLs68V522p50nuwcVzDSbkaZU0F
         XVYF62qgQ6btDkqgfNuhHYiCBcXUtwGrbnw334XLG1VAba6fELWGSjMTjqKn4KNwK5
         Zl6Pk6Ijx9M0w==
Date:   Wed, 24 Mar 2021 11:34:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/18] xfs: cleanup xfs_fill_fsxattr
Message-ID: <20210324183420.GN22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-15-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:25PM +0100, Christoph Hellwig wrote:
> Add a local xfs_mount variable, and use the XFS_FSB_TO_B helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3405a5f5bacfda..2b32dd4e14890b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1117,15 +1117,14 @@ xfs_fill_fsxattr(
>  	bool			attr,
>  	struct fsxattr		*fa)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = attr ? ip->i_afp : &ip->i_df;
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
> -	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
> -	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) &&
> -	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)) {
> -		fa->fsx_cowextsize =
> -			ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
> -	}
> +	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> +	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> +		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> -- 
> 2.30.1
> 
