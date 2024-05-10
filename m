Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0D91292F2
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 10:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715337529; cv=none; b=EiytQAVL9nfefzIVJBkHCHEQfYLfbmDhLcKIn+Hx28U4e801OP7H1RP6QjGs0y/x9Upha+5EBE0M8X4ihb2YUaB23MzciwYHV/qfqbvFgbuEdwAZj/DHyVRZSU/HOzSr34QS5OSdM44wBiDDGkHrwvmxMicyHV4F8SdKod8I30s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715337529; c=relaxed/simple;
	bh=Wq93lPs4XFSEBa/aWPK1iPYI8MQBoaqiADzzXfSR4Xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skqYu2dJ0YFJPT2Bb7jNevSONg8CQ3Z6bAhdArVqaZQtR0+FE89agl+BdIFa914VQ6uOi08G1URxc1Zl6s3Ng4A+wRrmCpcEyNHST7qRGzZuAAbxJQZesUJAOonw5Ih1IkMjf+5q7OjsYZLNzD9ksh5kuKPMMNbstExFa4vB6RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LtbEWHS5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LtbEWHS5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715337526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XZ8GQOLSzZjN+hKwXOHn41VkWpv9xsuV1JjtCn+vWNo=;
	b=LtbEWHS5hy5tb3XN+QD5LnB3kqLm28Dpq0Ry46gOCwiC4Rf/DZ1wTLjXRkqqRZopGl/sVk
	NFwKQKWGB9wVJ2EVqptk3RwuQAKHr8Ji6LI4Knl7PTLVHNi12OXur50WcMo437bj+P1e7r
	OtNsJphSRZI5Ltfpsg+/r4gcztom5RA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-VcWM_UnBNviecFaKO8OLxg-1; Fri, 10 May 2024 06:38:43 -0400
X-MC-Unique: VcWM_UnBNviecFaKO8OLxg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a59efa9f108so93146666b.2
        for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 03:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715337520; x=1715942320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZ8GQOLSzZjN+hKwXOHn41VkWpv9xsuV1JjtCn+vWNo=;
        b=Vny+aL086Vj+kU4dBUyOglH/29Kx4P6RRbvC9CY0JnJrZr+GA2hMAmI12GXDqkeEZm
         Ug4/krYfvkoncLMoySJJKOYvDz7mjtMd6rsr6Fz6gWnN6yBQ6mTAgAm9FvBWCecfYTa7
         Rea6jr2PHvbmVRj/fvebvIucFKjbpa8ALQBQCai/g0qFtOwFu4UuBHNkDtMayjEyowEL
         6WZg8YeRbBDim5plhghv6gqKuaSla1y/gZbwF7P9o9J50Oh+J6pa0WOm/BsXH6fEmzaB
         iR4pLuU9F39CWvfyfLYOeDltgxQio7pMIcK+vZAJcq4WKj2dnHh0h+p73F2GNscOpeg1
         dsbA==
X-Forwarded-Encrypted: i=1; AJvYcCXh3qUu4I3xL/7KGiuJL9maWePhQOxbnorMJ6EIv7travXKhmFfKPxopa7C+948kSYBE0it3j/9KjrmTXIW4orgdu3ybK6ZxF5d
X-Gm-Message-State: AOJu0YywfCbrQnR0it/C7TSK7hNZnCRX4zXNL0GC3Hg7fm1366qY16wL
	XorX/7NCcsC5647tIrut4FJxR9Tlm3Mx1UVvXxjy36boEgisrziSJYPoVd5jARuufxTf67Jjfw4
	IhT1Utbfp7pc150b/M05W3qVrPHubl4l3tsNuEKkjI9xYNPTFeI3c5jPFU000Rw5I
X-Received: by 2002:a17:906:24cc:b0:a5a:44e:2b87 with SMTP id a640c23a62f3a-a5a2d57a3bcmr133003166b.21.1715337520011;
        Fri, 10 May 2024 03:38:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOhlEgNcZyT8GIAVe2Vxl7iGXuVA0Y+oXksqgX/6BMjsCnyoh5SG1LMZAJxBtU8ppfZ2nkkA==
X-Received: by 2002:a17:906:24cc:b0:a5a:44e:2b87 with SMTP id a640c23a62f3a-a5a2d57a3bcmr133000666b.21.1715337519274;
        Fri, 10 May 2024 03:38:39 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a1781ce3fsm169020566b.4.2024.05.10.03.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 03:38:38 -0700 (PDT)
Date: Fri, 10 May 2024 12:38:37 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: add XFS_IOC_SETFSXATTRAT and
 XFS_IOC_GETFSXATTRAT
Message-ID: <q334ez5n7jrrts7l2akpq4p772dzncudjj3xc4zbkyxin3k5dv@lkum7alo2rvi>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-6-aalbersh@redhat.com>
 <20240509232517.GR360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509232517.GR360919@frogsfrogsfrogs>

On 2024-05-09 16:25:17, Darrick J. Wong wrote:
> On Thu, May 09, 2024 at 05:15:00PM +0200, Andrey Albershteyn wrote:
> > XFS has project quotas which could be attached to a directory. All
> > new inodes in these directories inherit project ID.
> > 
> > The project is created from userspace by opening and calling
> > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > files such as FIFO, SOCK, BLK etc. as opening them return special
> > inode from VFS. Therefore, some inodes are left with empty project
> > ID.
> > 
> > This patch adds new XFS ioctl which allows userspace, such as
> > xfs_quota, to set project ID on special files. This will let
> > xfs_quota set ID on all inodes and also reset it when project is
> > removed.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h   | 11 +++++
> >  fs/xfs/xfs_ioctl.c       | 86 ++++++++++++++++++++++++++++++++++++++++
> >  include/linux/fileattr.h |  2 +-
> >  3 files changed, 98 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 97996cb79aaa..f68e98005d4b 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -670,6 +670,15 @@ typedef struct xfs_swapext
> >  	struct xfs_bstat sx_stat;	/* stat of target b4 copy */
> >  } xfs_swapext_t;
> >  
> > +/*
> > + * Structure passed to XFS_IOC_GETFSXATTRAT/XFS_IOC_GETFSXATTRAT
> > + */
> > +struct xfs_xattrat_req {
> > +	struct fsxattr	__user *fsx;		/* XATTR to get/set */
> 
> Shouldn't this fsxattr object be embedded directly into xfs_xattrat_req?
> That's one less pointer to mess with.

Yes, I think it can, will change that

> 
> > +	__u32		dfd;			/* parent dir */
> > +	const char	__user *path;
> 
> Fugly wart: passing in a pointer as part of a ioctl structure means that
> you also have to implement an ioctl32.c wrapper because pointer sizes
> are not the same across the personalities that the kernel can run (e.g.
> i386 on an x64 kernel).

aha, I see, thanks! Will look into it

> 
> Unfortunately the only way I know of to work around the ioctl32 crud is
> to declare this as a __u64 field, employ a bunch of uintptr_t casting to
> shut up gcc, and pretend that pointers never exceed 64 bits.
> 
> > +};
> > +
> >  /*
> >   * Flags for going down operation
> >   */
> > @@ -997,6 +1006,8 @@ struct xfs_getparents_by_handle {
> >  #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
> >  #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
> >  #define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exchange_range)
> > +#define XFS_IOC_GETFSXATTRAT	     _IOR ('X', 130, struct xfs_xattrat_req)
> > +#define XFS_IOC_SETFSXATTRAT	     _IOW ('X', 131, struct xfs_xattrat_req)
> 
> These really ought to be defined in the VFS alongside
> FS_IOC_FSGETXATTR, not in XFS.
> 
> >  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
> >  
> >  
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 515c9b4b862d..d54dba9128a0 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1408,6 +1408,74 @@ xfs_ioctl_fs_counts(
> >  	return 0;
> >  }
> >  
> > +static int
> > +xfs_xattrat_get(
> > +	struct file		*dir,
> > +	const char __user	*pathname,
> > +	struct xfs_xattrat_req	*xreq)
> > +{
> > +	struct path		filepath;
> > +	struct xfs_inode	*ip;
> > +	struct fileattr		fa;
> > +	int			error = -EBADF;
> > +
> > +	memset(&fa, 0, sizeof(struct fileattr));
> > +
> > +	if (!S_ISDIR(file_inode(dir)->i_mode))
> > +		return error;
> > +
> > +	error = user_path_at(xreq->dfd, pathname, 0, &filepath);
> > +	if (error)
> > +		return error;
> > +
> > +	ip = XFS_I(filepath.dentry->d_inode);
> 
> Can we trust that this path points to an XFS inode?  Or even the same
> filesystem as the ioctl fd?  I think if you put the user_path_at part in
> the VFS, you could use the resulting filepath.dentry to call the regular
> ->fileattr_[gs]et functions, couldn't you?

Yeah, I missed that this could be a cross mount point, I will move
it to VFS.

> 
> --D
> 
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > +	xfs_fill_fsxattr(ip, XFS_DATA_FORK, &fa);
> > +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > +
> > +	error = copy_fsxattr_to_user(&fa, xreq->fsx);
> > +
> > +	path_put(&filepath);
> > +	return error;
> > +}
> > +
> > +static int
> > +xfs_xattrat_set(
> > +	struct file		*dir,
> > +	const char __user	*pathname,
> > +	struct xfs_xattrat_req	*xreq)
> > +{
> > +	struct fileattr		fa;
> > +	struct path		filepath;
> > +	struct mnt_idmap	*idmap = file_mnt_idmap(dir);
> > +	int			error = -EBADF;
> > +
> > +	if (!S_ISDIR(file_inode(dir)->i_mode))
> > +		return error;
> > +
> > +	error = copy_fsxattr_from_user(&fa, xreq->fsx);
> > +	if (error)
> > +		return error;
> > +
> > +	error = user_path_at(xreq->dfd, pathname, 0, &filepath);
> > +	if (error)
> > +		return error;
> > +
> > +	error = mnt_want_write(filepath.mnt);
> > +	if (error) {
> > +		path_put(&filepath);
> > +		return error;
> > +	}
> > +
> > +	fa.fsx_valid = true;
> > +	error = vfs_fileattr_set(idmap, filepath.dentry, &fa);
> > +
> > +	mnt_drop_write(filepath.mnt);
> > +	path_put(&filepath);
> > +	return error;
> > +}
> > +
> >  /*
> >   * These long-unused ioctls were removed from the official ioctl API in 5.17,
> >   * but retain these definitions so that we can log warnings about them.
> > @@ -1652,6 +1720,24 @@ xfs_file_ioctl(
> >  		sb_end_write(mp->m_super);
> >  		return error;
> >  	}
> > +	case XFS_IOC_GETFSXATTRAT: {
> > +		struct xfs_xattrat_req xreq;
> > +
> > +		if (copy_from_user(&xreq, arg, sizeof(struct xfs_xattrat_req)))
> > +			return -EFAULT;
> > +
> > +		error = xfs_xattrat_get(filp, xreq.path, &xreq);
> > +		return error;
> > +	}
> > +	case XFS_IOC_SETFSXATTRAT: {
> > +		struct xfs_xattrat_req xreq;
> > +
> > +		if (copy_from_user(&xreq, arg, sizeof(struct xfs_xattrat_req)))
> > +			return -EFAULT;
> > +
> > +		error = xfs_xattrat_set(filp, xreq.path, &xreq);
> > +		return error;
> > +	}
> >  
> >  	case XFS_IOC_EXCHANGE_RANGE:
> >  		return xfs_ioc_exchange_range(filp, arg);
> > diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> > index 3c4f8c75abc0..8598e94b530b 100644
> > --- a/include/linux/fileattr.h
> > +++ b/include/linux/fileattr.h
> > @@ -34,7 +34,7 @@ struct fileattr {
> >  };
> >  
> >  int copy_fsxattr_to_user(const struct fileattr *fa, struct fsxattr __user *ufa);
> > -int copy_fsxattr_from_user(struct fileattr *fa, struct fsxattr __user *ufa)
> > +int copy_fsxattr_from_user(struct fileattr *fa, struct fsxattr __user *ufa);
> >  
> >  void fileattr_fill_xflags(struct fileattr *fa, u32 xflags);
> >  void fileattr_fill_flags(struct fileattr *fa, u32 flags);
> > -- 
> > 2.42.0
> > 
> > 
> 

-- 
- Andrey

