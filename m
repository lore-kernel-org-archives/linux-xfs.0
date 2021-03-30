Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D67C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CF0A619DA
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhC3SKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232552AbhC3SKW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 14:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06A48619D1;
        Tue, 30 Mar 2021 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617127822;
        bh=GKjqDedszfpgwtR56m7WOtYsBB7W3Q2M3ULPS+/jjrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QUR9HulGmdvEyGyWv6UWTMMssqqp2I57XmJjWpBNJ6yvHMPxavA8Zo851WEEN28KZ
         P3SFhBXS4SZYZx7HzX1gu3uPGDuXCk0Ko1UZo7l0Jh7HHCvW112GOqsrglQRZ42dW6
         tgNPHsft9Z+NkR/pq7Uu6ZwLVX+q02syDaQlIlNrCuXrjG5k68pC9J108xBdmzpgFh
         VzeXUMko74sQPYHaUTfD3WCStoRK5pH8iZ68NrCAHsSTqI7ghHxr+gjLjy2Dw56937
         8vRWBGaltqcvTQg4XtA2cmJLbEYMosqi6BScUeObdyeGkZWYx27aaw5zkRLSKOySla
         TtdDneVwZEZzA==
Date:   Tue, 30 Mar 2021 11:10:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: default attr fork size does not handle device
 inodes
Message-ID: <20210330181020.GU4090233@magnolia>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330053059.1339949-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 04:30:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Device inodes have a non-default data fork size of 8 bytes
> as checked/enforced by xfs_repair. xfs_default_attroffset() doesn't
> handle this, so lets do a minor refactor so it does.
> 
> Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 2f72849c05f9..16c8730c140f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -195,6 +195,9 @@ xfs_default_attroffset(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	uint			offset;
>  
> +	if (ip->i_df.if_format == XFS_DINODE_FMT_DEV)
> +		return roundup(sizeof(xfs_dev_t), 8);
> +
>  	if (mp->m_sb.sb_inodesize == 256)
>  		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
>  	else
> @@ -1036,16 +1039,18 @@ xfs_bmap_set_attrforkoff(
>  	int			size,
>  	int			*version)
>  {
> +	int			default_size = xfs_default_attroffset(ip) >> 3;
> +
>  	switch (ip->i_df.if_format) {
>  	case XFS_DINODE_FMT_DEV:
> -		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
> +		ip->i_d.di_forkoff = default_size;
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
>  	case XFS_DINODE_FMT_EXTENTS:
>  	case XFS_DINODE_FMT_BTREE:
>  		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
>  		if (!ip->i_d.di_forkoff)
> -			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> +			ip->i_d.di_forkoff = default_size;
>  		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
>  			*version = 2;
>  		break;
> -- 
> 2.31.0
> 
