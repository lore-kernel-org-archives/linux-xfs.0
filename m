Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 237A4C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA30A619CE
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhC3PU7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 11:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232118AbhC3PU6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 11:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0F10619A7;
        Tue, 30 Mar 2021 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617117657;
        bh=66ZpRmixpZ/c+CiJ4bkN9wg4sRjwY8T8D8Lvaf4eSFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J3NZqW25bmmaIduc4g2hG0J3xI32V5zO9t6P1za+WLliB2i7PieAxzf2MWltVJju6
         JlLpHSauwHybhKAAh+hhOiYa8sY4q+kYyUfEG9fJIDyQeO21Rrm7FS+Bz5pNjBF7ug
         YM315z5Vi0VauAfWEvfPPG8SLWHgKjnRX6TbkNbneGa/fVCtKLkECT2uwznWRamPE7
         1iZZ+dQH4z4wFhvkFUw3/OyCgeBshLY5kO/u4Z5ymXxBd/XtFUzzKeZTJRtwusJe3a
         CxKPHp7uaoKb2iHbJgbc4MSHmGEgmJD1r6QhIl8P6ZQgoT0O+X0FCrzOSSaCBrqIlU
         kmOGIuSdX/Buw==
Date:   Tue, 30 Mar 2021 08:20:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/20] xfs: use XFS_B_TO_FSB in xfs_ioctl_setattr
Message-ID: <20210330152057.GN4090233@magnolia>
References: <20210329053829.1851318-1-hch@lst.de>
 <20210329053829.1851318-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329053829.1851318-15-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 07:38:23AM +0200, Christoph Hellwig wrote:
> Clean up xfs_ioctl_setattr a bit by using XFS_B_TO_FSB.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d589ecef4ec730..7909e46b5c5a18 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1520,12 +1520,12 @@ xfs_ioctl_setattr(
>  	 * are set on the inode then unconditionally clear the extent size hint.
>  	 */
>  	if (ip->i_d.di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
> -		ip->i_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> +		ip->i_extsize = XFS_B_TO_FSB(mp, fa->fsx_extsize);
>  	else
>  		ip->i_extsize = 0;
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
>  	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> -		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
> +		ip->i_cowextsize = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
>  	else
>  		ip->i_cowextsize = 0;
>  
> -- 
> 2.30.1
> 
