Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C4AC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 13:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DFC564DE8
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 13:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhBCNtV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 08:49:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37478 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbhBCNsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 08:48:24 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1l7IVN-00005y-Nw; Wed, 03 Feb 2021 13:47:38 +0000
Date:   Wed, 3 Feb 2021 14:47:34 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH -next] xfs: Fix unused variable 'mp' warning
Message-ID: <20210203134734.4oameuq262qdejwl@wittgenstein>
References: <1612341558-22171-1-git-send-email-zhangshaokun@hisilicon.com>
 <20210203093037.v2bhmjqrq7n5mlxx@wittgenstein>
 <20210203124117.GA16923@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203124117.GA16923@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 01:41:17PM +0100, Christoph Hellwig wrote:
> I don't think declaring a variable inside a switch statement is a good

Yeah. (I would think that the compiler would complain about this.)

> idea.  This is what I had lying around but never got around finishing
> up and submitting:
> 
> ---
> From 5e79886f08ca4dd96c9a508a380dfeb73cd4b529 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 3 Feb 2021 13:38:27 +0100
> Subject: xfs: remove the possibly unused mp variable in xfs_file_compat_ioctl
> 
> The mp variable in xfs_file_compat_ioctl is only used when
> BROKEN_X86_ALIGNMENT is define.  Remove it and just open code the
> dereference in a few places.
> 
> Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl32.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index e11139e18021c1..daf73cb53a05bb 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -420,7 +420,6 @@ xfs_file_compat_ioctl(
>  {
>  	struct inode		*inode = file_inode(filp);
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	struct xfs_mount	*mp = ip->i_mount;
>  	void			__user *arg = compat_ptr(p);
>  	int			error;
>  
> @@ -429,7 +428,7 @@ xfs_file_compat_ioctl(
>  	switch (cmd) {
>  #if defined(BROKEN_X86_ALIGNMENT)
>  	case XFS_IOC_FSGEOMETRY_V1_32:
> -		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
> +		return xfs_compat_ioc_fsgeometry_v1(ip->i_mount, arg);
>  	case XFS_IOC_FSGROWFSDATA_32: {
>  		struct xfs_growfs_data	in;
>  
> @@ -438,7 +437,7 @@ xfs_file_compat_ioctl(
>  		error = mnt_want_write_file(filp);
>  		if (error)
>  			return error;
> -		error = xfs_growfs_data(mp, &in);
> +		error = xfs_growfs_data(ip->i_mount, &in);
>  		mnt_drop_write_file(filp);
>  		return error;
>  	}
> @@ -450,7 +449,7 @@ xfs_file_compat_ioctl(
>  		error = mnt_want_write_file(filp);
>  		if (error)
>  			return error;
> -		error = xfs_growfs_rt(mp, &in);
> +		error = xfs_growfs_rt(ip->i_mount, &in);
>  		mnt_drop_write_file(filp);
>  		return error;
>  	}
> @@ -480,7 +479,7 @@ xfs_file_compat_ioctl(
>  	case XFS_IOC_FSBULKSTAT_32:
>  	case XFS_IOC_FSBULKSTAT_SINGLE_32:
>  	case XFS_IOC_FSINUMBERS_32:
> -		return xfs_compat_ioc_fsbulkstat(mp, cmd, arg);
> +		return xfs_compat_ioc_fsbulkstat(ip->i_mount, cmd, arg);

In the final version of you conversion (after the file_user_ns()
introduction) we simply pass down the fp so the patch needs to be?

If you're happy with it I can apply it on top. I don't want to rebase
this late. I can also send it separate as a reply in case this too much
in the body of this mail.

Patch passes cross-compilation for arm64 and native x864-64 and xfstests
pass too:

---
From a364f6e9de91cea671765cbd0e33fb823ebbba3c Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 3 Feb 2021 14:34:16 +0100
Subject: [PATCH] xfs: remove the possibly unused mp variable in
 xfs_file_compat_ioctl

The mp variable in xfs_file_compat_ioctl is only used when
BROKEN_X86_ALIGNMENT is define.  Remove it and just open code the
dereference in a few places.

Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl32.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 926427b19573..33c09ec8e6c0 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -438,7 +438,6 @@ xfs_file_compat_ioctl(
 {
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	void			__user *arg = compat_ptr(p);
 	int			error;
 
@@ -458,7 +457,7 @@ xfs_file_compat_ioctl(
 		return xfs_ioc_space(filp, &bf);
 	}
 	case XFS_IOC_FSGEOMETRY_V1_32:
-		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
+		return xfs_compat_ioc_fsgeometry_v1(ip->i_mount, arg);
 	case XFS_IOC_FSGROWFSDATA_32: {
 		struct xfs_growfs_data	in;
 
@@ -467,7 +466,7 @@ xfs_file_compat_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_growfs_data(mp, &in);
+		error = xfs_growfs_data(ip->i_mount, &in);
 		mnt_drop_write_file(filp);
 		return error;
 	}
@@ -479,7 +478,7 @@ xfs_file_compat_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_growfs_rt(mp, &in);
+		error = xfs_growfs_rt(ip->i_mount, &in);
 		mnt_drop_write_file(filp);
 		return error;
 	}

base-commit: f736d93d76d3e97d6986c6d26c8eaa32536ccc5c
-- 
2.30.0

