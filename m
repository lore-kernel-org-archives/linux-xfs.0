Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 08:47:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8JFlQuw001339
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 08:47:30 -0700
Message-ID: <46F08F98.9070102@sgi.com>
Date: Wed, 19 Sep 2007 12:55:20 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] simplify xfs_vn_getattr
References: <20070914162757.GD7110@lst.de>
In-Reply-To: <20070914162757.GD7110@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Just one question below - patch looks fine.

Christoph Hellwig wrote:
> Just fill in struct kstat directly from the xfs_inode instead of doing
> a detour through a bhv_vattr_t and xfs_getattr.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-09-06 10:42:40.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-09-06 10:44:33.000000000 +0200
> @@ -564,33 +564,61 @@ xfs_vn_permission(
>  
>  STATIC int
>  xfs_vn_getattr(
> -	struct vfsmount	*mnt,
> -	struct dentry	*dentry,
> -	struct kstat	*stat)
> +	struct vfsmount		*mnt,
> +	struct dentry		*dentry,
> +	struct kstat		*stat)
>  {
> -	struct inode	*inode = dentry->d_inode;
> -	bhv_vattr_t	vattr = { .va_mask = XFS_AT_STAT };
> -	int		error;
> -
> -	error = xfs_getattr(XFS_I(inode), &vattr, ATTR_LAZY);
> -	if (likely(!error)) {
> -		stat->size = i_size_read(inode);
> -		stat->dev = inode->i_sb->s_dev;
> -		stat->rdev = (vattr.va_rdev == 0) ? 0 :
> -				MKDEV(sysv_major(vattr.va_rdev) & 0x1ff,
> -				      sysv_minor(vattr.va_rdev));
> -		stat->mode = vattr.va_mode;
> -		stat->nlink = vattr.va_nlink;
> -		stat->uid = vattr.va_uid;
> -		stat->gid = vattr.va_gid;
> -		stat->ino = vattr.va_nodeid;
> -		stat->atime = vattr.va_atime;
> -		stat->mtime = vattr.va_mtime;
> -		stat->ctime = vattr.va_ctime;
> -		stat->blocks = vattr.va_nblocks;
> -		stat->blksize = vattr.va_blocksize;
> +	struct inode		*inode = dentry->d_inode;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	xfs_itrace_entry(ip);
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return XFS_ERROR(EIO);
> +
> +	stat->size = XFS_ISIZE(ip);
> +	stat->dev = inode->i_sb->s_dev;
> +	stat->mode = ip->i_d.di_mode;
> +	stat->nlink = ip->i_d.di_nlink;
> +	stat->uid = ip->i_d.di_uid;
> +	stat->gid = ip->i_d.di_gid;
> +	stat->ino = ip->i_ino;
> +#if XFS_BIG_INUMS
> +	stat->ino += mp->m_inoadd;
> +#endif
> +	stat->atime = inode->i_atime;
> +	stat->mtime.tv_sec = ip->i_d.di_mtime.t_sec;
> +	stat->mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
> +	stat->ctime.tv_sec = ip->i_d.di_ctime.t_sec;
> +	stat->ctime.tv_nsec = ip->i_d.di_ctime.t_nsec;
Why do we copy the atime from the inode and not the xfs_inode?

I think I see what's the deal here - the atime in the inode is
the authoritative atime.  It gets updated from various places and
we synchronise it to the xfs inode before flushing the xfs inode
to disk.  This means we shouldn't be using the atime in the
xfs_inode because it will be stale - is this correct?

> +	stat->blocks =
> +		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
> +
> +
> +	switch (inode->i_mode & S_IFMT) {
> +	case S_IFBLK:
> +	case S_IFCHR:
> +		stat->blksize = BLKDEV_IOSIZE;
> +		stat->rdev = MKDEV(sysv_major(ip->i_df.if_u2.if_rdev) & 0x1ff,
> +				   sysv_minor(ip->i_df.if_u2.if_rdev));
> +		break;
> +	default:
> +		if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
> +			/*
> +			 * If the file blocks are being allocated from a
> +			 * realtime volume, then return the inode's realtime
> +			 * extent size or the realtime volume's extent size.
> +			 */
> +			stat->blksize =
> +				xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
> +		} else
> +			stat->blksize = xfs_preferred_iosize(mp);
> +		stat->rdev = 0;
> +		break;
>  	}
> -	return -error;
> +
> +	return 0;
>  }
>  
>  STATIC int
> 
> 
> 
