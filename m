Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 00:22:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4G7LnN3030580
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:21:56 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E48016D5143
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:22:36 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id hT5qzeIKaXh1XZpM for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:22:36 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4G7MSF3001097
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 09:22:28 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4G7MSDL001095
	for xfs@oss.sgi.com; Fri, 16 May 2008 09:22:28 +0200
Date: Fri, 16 May 2008 09:22:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill xfs_igrow_start and xfs_igrow_finish
Message-ID: <20080516072228.GA1052@lst.de>
References: <20080430112448.GA17537@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430112448.GA17537@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Apr 30, 2008 at 01:24:48PM +0200, Christoph Hellwig wrote:
> xfs_igrow_start just expands to xfs_zero_eof with two assers that are
> useless in the context of the only caller and some rather confusing
> comments.
> 
> xfs_igrow_finish is just a few lines of code decorated again with
> useless asserts and confusing comments.
> 
> Just kill those two and merge them into xfs_setattr.

ping?

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-04-24 21:18:18.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-04-24 21:23:58.000000000 +0200
> @@ -1763,67 +1763,6 @@ xfs_itruncate_finish(
>  	return 0;
>  }
>  
> -
> -/*
> - * xfs_igrow_start
> - *
> - * Do the first part of growing a file: zero any data in the last
> - * block that is beyond the old EOF.  We need to do this before
> - * the inode is joined to the transaction to modify the i_size.
> - * That way we can drop the inode lock and call into the buffer
> - * cache to get the buffer mapping the EOF.
> - */
> -int
> -xfs_igrow_start(
> -	xfs_inode_t	*ip,
> -	xfs_fsize_t	new_size,
> -	cred_t		*credp)
> -{
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> -	ASSERT(new_size > ip->i_size);
> -
> -	/*
> -	 * Zero any pages that may have been created by
> -	 * xfs_write_file() beyond the end of the file
> -	 * and any blocks between the old and new file sizes.
> -	 */
> -	return xfs_zero_eof(ip, new_size, ip->i_size);
> -}
> -
> -/*
> - * xfs_igrow_finish
> - *
> - * This routine is called to extend the size of a file.
> - * The inode must have both the iolock and the ilock locked
> - * for update and it must be a part of the current transaction.
> - * The xfs_igrow_start() function must have been called previously.
> - * If the change_flag is not zero, the inode change timestamp will
> - * be updated.
> - */
> -void
> -xfs_igrow_finish(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*ip,
> -	xfs_fsize_t	new_size,
> -	int		change_flag)
> -{
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> -	ASSERT(ip->i_transp == tp);
> -	ASSERT(new_size > ip->i_size);
> -
> -	/*
> -	 * Update the file size.  Update the inode change timestamp
> -	 * if change_flag set.
> -	 */
> -	ip->i_d.di_size = new_size;
> -	ip->i_size = new_size;
> -	if (change_flag)
> -		xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -
> -}
> -
> -
>  /*
>   * This is called when the inode's link count goes to 0.
>   * We place the on-disk inode on a list in the AGI.  It
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-04-24 21:18:10.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-04-24 21:18:14.000000000 +0200
> @@ -507,9 +507,6 @@ int		xfs_itruncate_start(xfs_inode_t *, 
>  int		xfs_itruncate_finish(struct xfs_trans **, xfs_inode_t *,
>  				     xfs_fsize_t, int, int);
>  int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
> -int		xfs_igrow_start(xfs_inode_t *, xfs_fsize_t, struct cred *);
> -void		xfs_igrow_finish(struct xfs_trans *, xfs_inode_t *,
> -				 xfs_fsize_t, int);
>  
>  void		xfs_idestroy_fork(xfs_inode_t *, int);
>  void		xfs_idestroy(xfs_inode_t *);
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-04-24 21:18:18.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-04-24 21:24:07.000000000 +0200
> @@ -444,7 +444,13 @@ xfs_setattr(
>  		code = 0;
>  		if ((vap->va_size > ip->i_size) &&
>  		    (flags & ATTR_NOSIZETOK) == 0) {
> -			code = xfs_igrow_start(ip, vap->va_size, credp);
> +			/*
> +			 * Do the first part of growing a file: zero any data
> +			 * in the last block that is beyond the old EOF.  We
> +			 * need to do this before the inode is joined to the
> +			 * transaction to modify the i_size.
> +			 */
> +			code = xfs_zero_eof(ip, vap->va_size, ip->i_size);
>  		}
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
> @@ -512,8 +518,11 @@ xfs_setattr(
>  			timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
>  
>  		if (vap->va_size > ip->i_size) {
> -			xfs_igrow_finish(tp, ip, vap->va_size,
> -			    !(flags & ATTR_DMI));
> +			ip->i_d.di_size = vap->va_size;
> +			ip->i_size = vap->va_size;
> +			if (!(flags & ATTR_DMI))
> +				xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
> +			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		} else if ((vap->va_size <= ip->i_size) ||
>  			   ((vap->va_size == 0) && ip->i_d.di_nextents)) {
>  			/*
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-04-24 21:24:34.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-04-24 21:24:37.000000000 +0200
> @@ -235,8 +235,6 @@ EXPORT_SYMBOL(xfs_iflock_nowait);
>  EXPORT_SYMBOL(xfs_iflush);
>  EXPORT_SYMBOL(xfs_ifunlock);
>  EXPORT_SYMBOL(xfs_iget);
> -EXPORT_SYMBOL(xfs_igrow_start);
> -EXPORT_SYMBOL(xfs_igrow_finish);
>  EXPORT_SYMBOL(xfs_ilock);
>  EXPORT_SYMBOL(xfs_ilock_map_shared);
>  EXPORT_SYMBOL(xfs_ilock_nowait);
---end quoted text---
