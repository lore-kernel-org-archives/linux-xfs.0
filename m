Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D8874435
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 10:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716288768; cv=none; b=Pi/uzbj3NwkT54kB8dN+8jZ4URdAkDLRPXvSxJmB+bc2IDHfG5zpP1/XEZD+gANYPyfByNozj4JjeAvJVnFbvtpbQ5He75wRnfq9Xq6PmMsbTodix4YkTFIxN635Pxy9K47ZmcVM4BMU7b4qoNJVZOG1jvOhmIW0z6aiFKqlEMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716288768; c=relaxed/simple;
	bh=e9/Jn1k9vV9epBJrZXg4uSK4RPSRoT+u0KqFE5tpxA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgSwzXbFFlIuNqJeVTXqsU5H1TmtscLzlMJZhuGoPAcoEylvMUHxUxiV1y6Wr+czLMV5FgYLq6Sbq7e54b53PCmR1WK3cHXT8iGgv22kAs+/Wlsjr3sw4ePRUM14ikXUycDD39p8LRYpyPdL4dqXsHT8i6In+fE9Rr+DXTTLTqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b0BSwckP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b0BSwckP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716288765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=56nvd/3MP7DtivfrraZ2mnUYGxV4GioUyzj3puEJA5Q=;
	b=b0BSwckPqKW1mVg7Ui+5JEC//kxk0Wv7wDUpon+t2pw360uAvsdxCxqbJf/mYV4l/LZsfN
	yzdq63AnJ8hCMERqE0leEyHJ4tXtnP2aS+cesSdwdRxbOflOt9m5aZU8RSRPpU+Nbh1GBd
	cobd5vINg8NjJrScdIrqcHRb8f8O/ow=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-eAhu3txPMTuuJxGxlSYkHA-1; Tue, 21 May 2024 06:52:44 -0400
X-MC-Unique: eAhu3txPMTuuJxGxlSYkHA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-34f7618a1f2so6905298f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 03:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716288763; x=1716893563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=56nvd/3MP7DtivfrraZ2mnUYGxV4GioUyzj3puEJA5Q=;
        b=SynEz3D3OyFImqOEqNiyDU+M+YCkzckh0qbaEkKKqqmaSYAwo33hkTe/upew7WltgX
         mpbFYcMcLiMQiArfgwYcIiW2CN3YaU0ixR/CclQHbeyKOhoHU4Re3JZGpAPRSeBlpXk7
         CLZQO8EmsDfuFIjezWy0RTFevD13u6ckX07GnMlCKOlU7w8zneAGHT8PULDkqW3n96lU
         253MLKtIm4GpICZsckfHAEn+K5g01HsZFq5ObR6+WDiS+NjaQFcVt8HXjQ30NL/CDAcV
         A7CgyjrR3ShzvlqVpbuiGX9Lccn4ylyUw2FvWwhZoKbKJrpT1/i6LRAwR9Ih64OWvMM2
         9GJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaQtJ9kdaYzdsWBVy9cAtDJYETBFjvrGEAnts85Q7MegMqgUUVUqd2QkwlBQg/ENx+U1TlYjZF+0wG/fRtU6r0URziayzhkWtS
X-Gm-Message-State: AOJu0YynL1k3bgKSwGMObx3HTmEC8MqlgEXRvisX1yPHhS9Rxaa0Kj2P
	pH8t2UHOuToNL+rLb1Z2WaH85PKAHurju8oStLgSZ6Uo2OMOZM2bcSl6Ifgu+nhi0U0s18Aw9RP
	MdyermylereCgy5QuFCgJlJKt1NvS9TD8gKOOuiIE24TS2FY2PkmPxpSE
X-Received: by 2002:a05:6000:367:b0:34c:7ed4:55a with SMTP id ffacd0b85a97d-354b9068ef6mr7201742f8f.33.1716288763174;
        Tue, 21 May 2024 03:52:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8X3T5ls2zvNTQPr42SEqp90ElmOB3G+kJaiypVEcci2UquiYpUqBaQ4MQm5HfBGvyHnDrDw==
X-Received: by 2002:a05:6000:367:b0:34c:7ed4:55a with SMTP id ffacd0b85a97d-354b9068ef6mr7201703f8f.33.1716288762574;
        Tue, 21 May 2024 03:52:42 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502baacfc6sm31803283f8f.72.2024.05.21.03.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 03:52:42 -0700 (PDT)
Date: Tue, 21 May 2024 12:52:41 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and
 FS_IOC_FSGETXATTRAT
Message-ID: <wetpv5posln2xv5dy26a7ohrsrcr6yi3lr6qrpbtjf3ymiilxy@ohukv2n3do6t>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-4-aalbersh@redhat.com>
 <20240520175159.GD25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520175159.GD25518@frogsfrogsfrogs>

On 2024-05-20 10:51:59, Darrick J. Wong wrote:
> On Mon, May 20, 2024 at 06:46:21PM +0200, Andrey Albershteyn wrote:
> > XFS has project quotas which could be attached to a directory. All
> > new inodes in these directories inherit project ID set on parent
> > directory.
> > 
> > The project is created from userspace by opening and calling
> > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > files such as FIFO, SOCK, BLK etc. as opening them returns a special
> > inode from VFS. Therefore, some inodes are left with empty project
> > ID. Those inodes then are not shown in the quota accounting but
> > still exist in the directory.
> > 
> > This patch adds two new ioctls which allows userspace, such as
> > xfs_quota, to set project ID on special files by using parent
> > directory to open FS inode. This will let xfs_quota set ID on all
> > inodes and also reset it when project is removed. Also, as
> > vfs_fileattr_set() is now will called on special files too, let's
> > forbid any other attributes except projid and nextents (symlink can
> > have one).
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/ioctl.c              | 93 +++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/fs.h | 11 +++++
> >  2 files changed, 104 insertions(+)
> > 
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 1d5abfdf0f22..3e3aacb6ea6e 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/mount.h>
> >  #include <linux/fscrypt.h>
> >  #include <linux/fileattr.h>
> > +#include <linux/namei.h>
> >  
> >  #include "internal.h"
> >  
> > @@ -647,6 +648,19 @@ static int fileattr_set_prepare(struct inode *inode,
> >  	if (fa->fsx_cowextsize == 0)
> >  		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
> >  
> > +	/*
> > +	 * The only use case for special files is to set project ID, forbid any
> > +	 * other attributes
> > +	 */
> > +	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
> > +		if (fa->fsx_xflags & ~FS_XFLAG_PROJINHERIT)
> 
> When would PROJINHERIT be set on a non-reg/non-dir file?

Oh I thought it's set on all inodes in projects anyway, but looks
like it's dropped for files in xfs_flags2diflags(). The xfs_quota
just set it for each inode so I just haven't checked it. I will drop
this check and change xfs_quota to not set PROJINHERIT for special
files.

> > +			return -EINVAL;
> > +		if (!S_ISLNK(inode->i_mode) && fa->fsx_nextents)
> 
> FS_IOC_FSSETXATTR doesn't enforce anything for fsx_nextents for any
> other type of file, does it?

yes, it doesn't enforce anything, as I described in the comment I
tried to reject any other uses. But symlink has fsx_nextents == 1 so
get + set call will fail.

> 
> > +			return -EINVAL;
> > +		if (fa->fsx_extsize || fa->fsx_cowextsize)
> > +			return -EINVAL;
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > @@ -763,6 +777,79 @@ static int ioctl_fssetxattr(struct file *file, void __user *argp)
> >  	return err;
> >  }
> >  
> > +static int ioctl_fsgetxattrat(struct file *file, void __user *argp)
> > +{
> > +	struct path filepath;
> > +	struct fsxattrat fsxat;
> > +	struct fileattr fa;
> > +	int error;
> > +
> > +	if (!S_ISDIR(file_inode(file)->i_mode))
> > +		return -EBADF;
> > +
> > +	if (copy_from_user(&fsxat, argp, sizeof(struct fsxattrat)))
> > +		return -EFAULT;
> > +
> > +	error = user_path_at(fsxat.dfd, fsxat.path, 0, &filepath);
> > +	if (error)
> > +		return error;
> > +
> > +	error = vfs_fileattr_get(filepath.dentry, &fa);
> > +	if (error) {
> > +		path_put(&filepath);
> > +		return error;
> > +	}
> > +
> > +	fsxat.fsx.fsx_xflags = fa.fsx_xflags;
> > +	fsxat.fsx.fsx_extsize = fa.fsx_extsize;
> > +	fsxat.fsx.fsx_nextents = fa.fsx_nextents;
> > +	fsxat.fsx.fsx_projid = fa.fsx_projid;
> > +	fsxat.fsx.fsx_cowextsize = fa.fsx_cowextsize;
> > +
> > +	if (copy_to_user(argp, &fsxat, sizeof(struct fsxattrat)))
> > +		error = -EFAULT;
> > +
> > +	path_put(&filepath);
> > +	return error;
> > +}
> > +
> > +static int ioctl_fssetxattrat(struct file *file, void __user *argp)
> > +{
> > +	struct mnt_idmap *idmap = file_mnt_idmap(file);
> > +	struct fsxattrat fsxat;
> > +	struct path filepath;
> > +	struct fileattr fa;
> > +	int error;
> > +
> > +	if (!S_ISDIR(file_inode(file)->i_mode))
> > +		return -EBADF;
> > +
> > +	if (copy_from_user(&fsxat, argp, sizeof(struct fsxattrat)))
> > +		return -EFAULT;
> > +
> > +	error = user_path_at(fsxat.dfd, fsxat.path, 0, &filepath);
> > +	if (error)
> > +		return error;
> > +
> > +	error = mnt_want_write(filepath.mnt);
> > +	if (error) {
> > +		path_put(&filepath);
> > +		return error;
> 
> This could be a goto to the path_put below.
> 
> > +	}
> > +
> > +	fileattr_fill_xflags(&fa, fsxat.fsx.fsx_xflags);
> > +	fa.fsx_extsize = fsxat.fsx.fsx_extsize;
> > +	fa.fsx_nextents = fsxat.fsx.fsx_nextents;
> > +	fa.fsx_projid = fsxat.fsx.fsx_projid;
> > +	fa.fsx_cowextsize = fsxat.fsx.fsx_cowextsize;
> > +	fa.fsx_valid = true;
> > +
> > +	error = vfs_fileattr_set(idmap, filepath.dentry, &fa);
> 
> Why not pass &fsxat.fsx directly to vfs_fileattr_set?

vfs_fileattr_set() takes fileattr and there won't be fsx_valid, no? I
suppose they aren't aligned

> 
> > +	mnt_drop_write(filepath.mnt);
> > +	path_put(&filepath);
> > +	return error;
> > +}
> > +
> >  static int ioctl_getfsuuid(struct file *file, void __user *argp)
> >  {
> >  	struct super_block *sb = file_inode(file)->i_sb;
> > @@ -872,6 +959,12 @@ static int do_vfs_ioctl(struct file *filp, unsigned int fd,
> >  	case FS_IOC_FSSETXATTR:
> >  		return ioctl_fssetxattr(filp, argp);
> >  
> > +	case FS_IOC_FSGETXATTRAT:
> > +		return ioctl_fsgetxattrat(filp, argp);
> > +
> > +	case FS_IOC_FSSETXATTRAT:
> > +		return ioctl_fssetxattrat(filp, argp);
> > +
> >  	case FS_IOC_GETFSUUID:
> >  		return ioctl_getfsuuid(filp, argp);
> >  
> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index 45e4e64fd664..f8cd8d7bf35d 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -139,6 +139,15 @@ struct fsxattr {
> >  	unsigned char	fsx_pad[8];
> >  };
> >  
> > +/*
> > + * Structure passed to FS_IOC_FSGETXATTRAT/FS_IOC_FSSETXATTRAT
> > + */
> > +struct fsxattrat {
> > +	struct fsxattr	fsx;		/* XATTR to get/set */
> > +	__u32		dfd;		/* parent dir */
> > +	const char	__user *path;
> 
> As I mentioned last time[1], embedding a pointer in an ioctl structure
> creates porting problems because pointer sizes vary between process
> personalities, so the size of struct fsxattrat will vary and lead to
> copy_to/from_user overflows.

Oh right, sorry, totally forgot about that

> 
> 
> [1] https://lore.kernel.org/linux-xfs/20240509232517.GR360919@frogsfrogsfrogs/
> 
> --D
> 
> > +};
> > +
> >  /*
> >   * Flags for the fsx_xflags field
> >   */
> > @@ -231,6 +240,8 @@ struct fsxattr {
> >  #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
> >  #define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
> >  #define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
> > +#define FS_IOC_FSGETXATTRAT		_IOR('X', 33, struct fsxattrat)
> > +#define FS_IOC_FSSETXATTRAT		_IOW('X', 34, struct fsxattrat)
> >  #define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
> >  #define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
> >  /* Returns the external filesystem UUID, the same one blkid returns */
> > -- 
> > 2.42.0
> > 
> > 
> 

-- 
- Andrey

