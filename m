Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899B5C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 18:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbiAJShj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 13:37:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241381AbiAJShj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 13:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641839858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=79i0NxKzTMntiGGJA0MJS/EBaVJb9j0F6H2iBqZ1ZYs=;
        b=d2JJYi5KePPOZSJ66IPxKS5NNkX5KGts8I1gSaaJMeO9CXzWfstU1dnqDzSuVLQBWq5rEt
        OMUr/nneimC+zM/oC7rzlSUWd0mQxiSWPrAJUGc6cQ1G6r5Li4F0GZ2trNl6ZsTTnHtOhV
        y40OPpyJNKjKMgU0Du/xGTzgoSsmrHw=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-QdY8Ee3QOX2X7DKN4ZVkag-1; Mon, 10 Jan 2022 13:37:36 -0500
X-MC-Unique: QdY8Ee3QOX2X7DKN4ZVkag-1
Received: by mail-io1-f69.google.com with SMTP id g26-20020a056602243a00b00604a6a4e0e9so5167465iob.19
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 10:37:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=79i0NxKzTMntiGGJA0MJS/EBaVJb9j0F6H2iBqZ1ZYs=;
        b=Fb+GF/G2K3gfdybhzzpsq8ZiC73hrl3HmkNzWz/CV/uTzV/uFVX1jvRDkRmoSYE7PK
         ZajSwezas9sd0Xzl0nZeFLSKmcgaohoBg43yrlslHe1dCMFKMtK02wiELwlMjOxABy01
         iIMAm6FUZQfyzWR1b4oJdE8orXeT1ojGgBHq/eggNdufITfJTBy/OBx/J7sumuE2cY3H
         Yd4tmyts+Z2p+yQ//xtrYQJj27fpqfmlxhAEYfv1ZtFbz5mdwpSlyDi9I9F4TeGqYlAC
         j0XGDKFr5MPKvJGXP+gZCHfw+VMWp/FJL3hi94W2KWdHkSXyN6GSEvyHkHzBWpmeJqNs
         8vdA==
X-Gm-Message-State: AOAM5314qiHvUUmLe5Ps6j5YYMa3Xgo1vWnwFOWOr8OTFPzRGsL1zH6Q
        jUcrLkjDpw5KvlyX9CYPcN7kwAHqsyGNpGAQ++D4TyAIs4UiNIMt6DIfRel+cgDDAQT7jVI9EnE
        CxiT6R/PxCspGC6K2VFtA
X-Received: by 2002:a05:6638:1921:: with SMTP id p33mr566969jal.311.1641839855647;
        Mon, 10 Jan 2022 10:37:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDSdW8/HZIbG8Lp7ujGc2pk2J20hztls5Ib3RWIFT+Mtlt906VpGYEijWgIcV4rB7r+4EZKg==
X-Received: by 2002:a05:6638:1921:: with SMTP id p33mr566958jal.311.1641839855287;
        Mon, 10 Jan 2022 10:37:35 -0800 (PST)
Received: from [10.2.0.2] ([74.119.146.34])
        by smtp.gmail.com with ESMTPSA id l14sm4902185ios.24.2022.01.10.10.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 10:37:35 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <4e135a9f-159a-a06a-a9b2-939d711ebc52@redhat.com>
Date:   Mon, 10 Jan 2022 12:37:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 1/2] xfs: kill the XFS_IOC_{ALLOC,FREE}SP* ioctls
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20220110174827.GW656707@magnolia>
In-Reply-To: <20220110174827.GW656707@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/10/22 11:48 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> According to Dave lore, these ioctls originated in the early 1990s in
> Irix EFS as a (somewhat clunky) way to preallocate space at the end of a
> file.  Irix XFS, naturally, picked up these ioctls to maintain
> compatibility, which meant that they were ported to Linux in the early
> 2000s.
> 
> Recently it was pointed out to me they still lurk in the kernel, even
> though the Linux fallocate syscall supplanted the functionality a long
> time ago.  fstests doesn't seem to include any real functional or stress
> tests for these ioctls, which means that the code quality is ... very
> questionable.  Most notably, it was a stale disk block exposure vector
> for 21 years and nobody noticed or complained.  As mature programmers
> say, "If you're not testing it, it's broken."
> 
> Given all that, let's withdraw these ioctls from the XFS userspace API.
> Normally we'd set a long deprecation process, but I estimate that there
> aren't any real users, so let's trigger a warning in dmesg and return
> -ENOTTY.
> 
> See: CVE-2021-4155
> 
> Augments: 983d8e60f508 ("xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Thanks Darrick.

Random thoughts, take them or leave them.

We could suggest fallocate in the warning, unless we don't want to
prescribe solutions.

Since xfs_alloc_file_space() only does one thing, we could change it
to xfs_prealloc_file_space() for clarity.

With or wiithout those changes, this looks fine to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> ---
>   fs/xfs/xfs_bmap_util.c |    7 ++--
>   fs/xfs/xfs_bmap_util.h |    2 +
>   fs/xfs/xfs_file.c      |    3 +-
>   fs/xfs/xfs_ioctl.c     |   92 ++----------------------------------------------
>   fs/xfs/xfs_ioctl.h     |    6 ---
>   fs/xfs/xfs_ioctl32.c   |   27 --------------
>   6 files changed, 9 insertions(+), 128 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 73a36b7be3bd..575060a7c768 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -771,8 +771,7 @@ int
>   xfs_alloc_file_space(
>   	struct xfs_inode	*ip,
>   	xfs_off_t		offset,
> -	xfs_off_t		len,
> -	int			alloc_type)
> +	xfs_off_t		len)
>   {
>   	xfs_mount_t		*mp = ip->i_mount;
>   	xfs_off_t		count;
> @@ -865,8 +864,8 @@ xfs_alloc_file_space(
>   			goto error;
>   
>   		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -					allocatesize_fsb, alloc_type, 0, imapp,
> -					&nimaps);
> +				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> +				&nimaps);
>   		if (error)
>   			goto error;
>   
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 9f993168b55b..24b37d211f1d 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -54,7 +54,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>   
>   /* preallocation and hole punch interface */
>   int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -			     xfs_off_t len, int alloc_type);
> +			     xfs_off_t len);
>   int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>   			    xfs_off_t len);
>   int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 27594738b0d1..d81a28cada35 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1052,8 +1052,7 @@ xfs_file_fallocate(
>   		}
>   
>   		if (!xfs_is_always_cow_inode(ip)) {
> -			error = xfs_alloc_file_space(ip, offset, len,
> -						     XFS_BMAPI_PREALLOC);
> +			error = xfs_alloc_file_space(ip, offset, len);
>   			if (error)
>   				goto out_unlock;
>   		}
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8ea47a9d5aad..38b2a1e881a6 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -627,87 +627,6 @@ xfs_attrmulti_by_handle(
>   	return error;
>   }
>   
> -int
> -xfs_ioc_space(
> -	struct file		*filp,
> -	xfs_flock64_t		*bf)
> -{
> -	struct inode		*inode = file_inode(filp);
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	struct iattr		iattr;
> -	enum xfs_prealloc_flags	flags = XFS_PREALLOC_CLEAR;
> -	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> -	int			error;
> -
> -	if (inode->i_flags & (S_IMMUTABLE|S_APPEND))
> -		return -EPERM;
> -
> -	if (!(filp->f_mode & FMODE_WRITE))
> -		return -EBADF;
> -
> -	if (!S_ISREG(inode->i_mode))
> -		return -EINVAL;
> -
> -	if (xfs_is_always_cow_inode(ip))
> -		return -EOPNOTSUPP;
> -
> -	if (filp->f_flags & O_DSYNC)
> -		flags |= XFS_PREALLOC_SYNC;
> -	if (filp->f_mode & FMODE_NOCMTIME)
> -		flags |= XFS_PREALLOC_INVISIBLE;
> -
> -	error = mnt_want_write_file(filp);
> -	if (error)
> -		return error;
> -
> -	xfs_ilock(ip, iolock);
> -	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
> -	if (error)
> -		goto out_unlock;
> -	inode_dio_wait(inode);
> -
> -	switch (bf->l_whence) {
> -	case 0: /*SEEK_SET*/
> -		break;
> -	case 1: /*SEEK_CUR*/
> -		bf->l_start += filp->f_pos;
> -		break;
> -	case 2: /*SEEK_END*/
> -		bf->l_start += XFS_ISIZE(ip);
> -		break;
> -	default:
> -		error = -EINVAL;
> -		goto out_unlock;
> -	}
> -
> -	if (bf->l_start < 0 || bf->l_start > inode->i_sb->s_maxbytes) {
> -		error = -EINVAL;
> -		goto out_unlock;
> -	}
> -
> -	if (bf->l_start > XFS_ISIZE(ip)) {
> -		error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
> -				bf->l_start - XFS_ISIZE(ip),
> -				XFS_BMAPI_PREALLOC);
> -		if (error)
> -			goto out_unlock;
> -	}
> -
> -	iattr.ia_valid = ATTR_SIZE;
> -	iattr.ia_size = bf->l_start;
> -	error = xfs_vn_setattr_size(file_mnt_user_ns(filp), file_dentry(filp),
> -				    &iattr);
> -	if (error)
> -		goto out_unlock;
> -
> -	error = xfs_update_prealloc_flags(ip, flags);
> -
> -out_unlock:
> -	xfs_iunlock(ip, iolock);
> -	mnt_drop_write_file(filp);
> -	return error;
> -}
> -
>   /* Return 0 on success or positive error */
>   int
>   xfs_fsbulkstat_one_fmt(
> @@ -1965,13 +1884,10 @@ xfs_file_ioctl(
>   	case XFS_IOC_ALLOCSP:
>   	case XFS_IOC_FREESP:
>   	case XFS_IOC_ALLOCSP64:
> -	case XFS_IOC_FREESP64: {
> -		xfs_flock64_t		bf;
> -
> -		if (copy_from_user(&bf, arg, sizeof(bf)))
> -			return -EFAULT;
> -		return xfs_ioc_space(filp, &bf);
> -	}
> +	case XFS_IOC_FREESP64:
> +		xfs_warn_once(mp,
> +	"dangerous XFS_IOC_{ALLOC,FREE}SP ioctls no longer supported");
> +		return -ENOTTY;
>   	case XFS_IOC_DIOINFO: {
>   		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
>   		struct dioattr		da;
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index 845d3bcab74b..d4abba2c13c1 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -10,12 +10,6 @@ struct xfs_bstat;
>   struct xfs_ibulk;
>   struct xfs_inogrp;
>   
> -
> -extern int
> -xfs_ioc_space(
> -	struct file		*filp,
> -	xfs_flock64_t		*bf);
> -
>   int
>   xfs_ioc_swapext(
>   	xfs_swapext_t	*sxp);
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 8783af203cfc..004ed2a251e8 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -27,22 +27,6 @@
>   	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
>   
>   #ifdef BROKEN_X86_ALIGNMENT
> -STATIC int
> -xfs_compat_flock64_copyin(
> -	xfs_flock64_t		*bf,
> -	compat_xfs_flock64_t	__user *arg32)
> -{
> -	if (get_user(bf->l_type,	&arg32->l_type) ||
> -	    get_user(bf->l_whence,	&arg32->l_whence) ||
> -	    get_user(bf->l_start,	&arg32->l_start) ||
> -	    get_user(bf->l_len,		&arg32->l_len) ||
> -	    get_user(bf->l_sysid,	&arg32->l_sysid) ||
> -	    get_user(bf->l_pid,		&arg32->l_pid) ||
> -	    copy_from_user(bf->l_pad,	&arg32->l_pad,	4*sizeof(u32)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
>   STATIC int
>   xfs_compat_ioc_fsgeometry_v1(
>   	struct xfs_mount	  *mp,
> @@ -445,17 +429,6 @@ xfs_file_compat_ioctl(
>   
>   	switch (cmd) {
>   #if defined(BROKEN_X86_ALIGNMENT)
> -	case XFS_IOC_ALLOCSP_32:
> -	case XFS_IOC_FREESP_32:
> -	case XFS_IOC_ALLOCSP64_32:
> -	case XFS_IOC_FREESP64_32: {
> -		struct xfs_flock64	bf;
> -
> -		if (xfs_compat_flock64_copyin(&bf, arg))
> -			return -EFAULT;
> -		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
> -		return xfs_ioc_space(filp, &bf);
> -	}
>   	case XFS_IOC_FSGEOMETRY_V1_32:
>   		return xfs_compat_ioc_fsgeometry_v1(ip->i_mount, arg);
>   	case XFS_IOC_FSGROWFSDATA_32: {
> 

