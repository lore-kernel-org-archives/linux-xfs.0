Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019E8C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEBFC64F84
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhBCRjS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 12:39:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229731AbhBCRjR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 12:39:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4665B64F84;
        Wed,  3 Feb 2021 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612373916;
        bh=MSS/IOscjVYrqq6rA0jEDDc3CQllSHZjkPLtuEwHKfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cZQlip2YQ2+wx9XGiMDpzkFji/X4r6tprvJMEs7fvNPskNkh7SjyKfBuI8pGvBkug
         F8rZoUU2U0WCI4xiLfMOblOhjf9k33W0wqeR8/8ZH9FJ318Z5gJQFubYyzflNKG78n
         6JiTZL/wFaWABbToogXtPA9F8z8DrhSO+XCwDDWoKRxdXHL+GMcG/xU83sp1Ifmlmk
         6Z+5s81BQCe7zikwR21BukanwZJPLvQocuvRlHm0JcwEDbdiKYaUE9aldrsdeb1483
         /SPuDAAfh28Fo9mBvJmD1Ih8r9XV8GPxW2osRDJ+hOwQ2nh/7RH9uyjpBYmShn6ldL
         5tott5NVJhNsg==
Date:   Wed, 3 Feb 2021 09:38:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH -next] xfs: remove the possibly unused mp variable in
 xfs_file_compat_ioctl
Message-ID: <20210203173835.GY7193@magnolia>
References: <https://lore.kernel.org/linux-xfs/20210203171633.GX7193@magnolia>
 <20210203173009.462205-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203173009.462205-1-christian.brauner@ubuntu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 06:30:10PM +0100, Christian Brauner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> The mp variable in xfs_file_compat_ioctl is only used when
> BROKEN_X86_ALIGNMENT is define.  Remove it and just open code the
> dereference in a few places.
> 
> Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> As mentioned in the thread, I'd take this on top of Christoph's patch if
> people are ok with this:
> https://git.kernel.org/brauner/h/idmapped_mounts

I don't mind taking this via the xfs tree, unless merging through the
idmapped mounts series is easier/causes less rebase mess?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioctl32.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 926427b19573..33c09ec8e6c0 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -438,7 +438,6 @@ xfs_file_compat_ioctl(
>  {
>  	struct inode		*inode = file_inode(filp);
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	struct xfs_mount	*mp = ip->i_mount;
>  	void			__user *arg = compat_ptr(p);
>  	int			error;
>  
> @@ -458,7 +457,7 @@ xfs_file_compat_ioctl(
>  		return xfs_ioc_space(filp, &bf);
>  	}
>  	case XFS_IOC_FSGEOMETRY_V1_32:
> -		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
> +		return xfs_compat_ioc_fsgeometry_v1(ip->i_mount, arg);
>  	case XFS_IOC_FSGROWFSDATA_32: {
>  		struct xfs_growfs_data	in;
>  
> @@ -467,7 +466,7 @@ xfs_file_compat_ioctl(
>  		error = mnt_want_write_file(filp);
>  		if (error)
>  			return error;
> -		error = xfs_growfs_data(mp, &in);
> +		error = xfs_growfs_data(ip->i_mount, &in);
>  		mnt_drop_write_file(filp);
>  		return error;
>  	}
> @@ -479,7 +478,7 @@ xfs_file_compat_ioctl(
>  		error = mnt_want_write_file(filp);
>  		if (error)
>  			return error;
> -		error = xfs_growfs_rt(mp, &in);
> +		error = xfs_growfs_rt(ip->i_mount, &in);
>  		mnt_drop_write_file(filp);
>  		return error;
>  	}
> 
> base-commit: f736d93d76d3e97d6986c6d26c8eaa32536ccc5c
> -- 
> 2.30.0
> 
