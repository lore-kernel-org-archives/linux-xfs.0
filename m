Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F285BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 00:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9656B64E08
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 00:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhBDA4c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:56:32 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11675 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbhBDA4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 19:56:32 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DWKnF0VxKzlG7y;
        Thu,  4 Feb 2021 08:54:09 +0800 (CST)
Received: from [10.67.77.175] (10.67.77.175) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.498.0; Thu, 4 Feb 2021
 08:55:45 +0800
Subject: Re: [PATCH -next] xfs: remove the possibly unused mp variable in
 xfs_file_compat_ioctl
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>
CC:     <linux-xfs@vger.kernel.org>
References: <https://lore.kernel.org/linux-xfs/20210203171633.GX7193@magnolia>
 <20210203173009.462205-1-christian.brauner@ubuntu.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <80b1a8c1-6638-d967-6dc9-169784bb0958@hisilicon.com>
Date:   Thu, 4 Feb 2021 08:55:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20210203173009.462205-1-christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.77.175]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It works on arm64 platform, so,

Tested-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Thanks,
Shaokun

ÔÚ 2021/2/4 1:30, Christian Brauner Ð´µÀ:
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
> 
