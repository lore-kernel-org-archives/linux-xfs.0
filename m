Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 05:36:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9ICZw5U015499
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 05:35:58 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7ECF0130E559
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 05:37:41 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 3PDCG5WDZk1N2kgm for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 05:37:41 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9ICbdIF025510
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 14:37:39 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9ICbdwh025508
	for xfs@oss.sgi.com; Sat, 18 Oct 2008 14:37:39 +0200
Date: Sat, 18 Oct 2008 14:37:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] use proper mnt_want_write calls for handle ioctls
Message-ID: <20081018123739.GC25304@lst.de>
References: <20080814203952.GB18704@lst.de> <20080912084431.GA22641@lst.de> <20080929074234.GA23785@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929074234.GA23785@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Ping again.  As said before this could cause filesystem corruption with
the SGI tree, and it's always been correct in mainline there shouldn't
be any reason to delay it.

On Mon, Sep 29, 2008 at 09:42:34AM +0200, Christoph Hellwig wrote:
> ping^2?
> 
> On Fri, Sep 12, 2008 at 10:44:31AM +0200, Christoph Hellwig wrote:
> > ping?  Without this patch the CVS tree won't properly work with
> > read-only bind mounts.
> > 
> > On Thu, Aug 14, 2008 at 10:39:52PM +0200, Christoph Hellwig wrote:
> > > Since 2.6.26 all writes to filesystems need to be enclosed by a
> > > mnt_want_write / mnt_drop_write pair instead of checking for IS_RDONLY.
> > > 
> > > XFs was updated for this in mainline but the changes to xfs_ioctl.c
> > > were never megred back into the CVS tree.
> > > 
> > > The original commit introducing this was:
> > > 
> > > commit 42a74f206b914db13ee1f5ae932dcd91a77c8579
> > > Author: Dave Hansen <haveblue@us.ibm.com>
> > > Date:   Fri Feb 15 14:37:46 2008 -0800
> > > 
> > >     [PATCH] r/o bind mounts: elevate write count for ioctls()
> > > 
> > > Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
> > > ===================================================================
> > > --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-08-14 14:54:53.000000000 -0300
> > > +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-08-14 15:15:49.000000000 -0300
> > > @@ -543,8 +543,6 @@ xfs_attrmulti_attr_set(
> > >  	char			*kbuf;
> > >  	int			error = EFAULT;
> > >  
> > > -	if (IS_RDONLY(inode))
> > > -		return -EROFS;
> > >  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> > >  		return EPERM;
> > >  	if (len > XATTR_SIZE_MAX)
> > > @@ -570,8 +568,6 @@ xfs_attrmulti_attr_remove(
> > >  	char			*name,
> > >  	__uint32_t		flags)
> > >  {
> > > -	if (IS_RDONLY(inode))
> > > -		return -EROFS;
> > >  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> > >  		return EPERM;
> > >  	return xfs_attr_remove(XFS_I(inode), name, flags);
> > > @@ -581,6 +577,7 @@ STATIC int
> > >  xfs_attrmulti_by_handle(
> > >  	xfs_mount_t		*mp,
> > >  	void			__user *arg,
> > > +	struct file		*parfilp,
> > >  	struct inode		*parinode)
> > >  {
> > >  	int			error;
> > > @@ -634,13 +631,21 @@ xfs_attrmulti_by_handle(
> > >  					&ops[i].am_length, ops[i].am_flags);
> > >  			break;
> > >  		case ATTR_OP_SET:
> > > +			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
> > > +			if (ops[i].am_error)
> > > +				break;
> > >  			ops[i].am_error = xfs_attrmulti_attr_set(inode,
> > >  					attr_name, ops[i].am_attrvalue,
> > >  					ops[i].am_length, ops[i].am_flags);
> > > +			mnt_drop_write(parfilp->f_path.mnt);
> > >  			break;
> > >  		case ATTR_OP_REMOVE:
> > > +			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
> > > +			if (ops[i].am_error)
> > > +				break;
> > >  			ops[i].am_error = xfs_attrmulti_attr_remove(inode,
> > >  					attr_name, ops[i].am_flags);
> > > +			mnt_drop_write(parfilp->f_path.mnt);
> > >  			break;
> > >  		default:
> > >  			ops[i].am_error = EINVAL;
> > > @@ -1431,7 +1436,7 @@ xfs_ioctl(
> > >  		return xfs_attrlist_by_handle(mp, arg, inode);
> > >  
> > >  	case XFS_IOC_ATTRMULTI_BY_HANDLE:
> > > -		return xfs_attrmulti_by_handle(mp, arg, inode);
> > > +		return xfs_attrmulti_by_handle(mp, arg, filp, inode);
> > >  
> > >  	case XFS_IOC_SWAPEXT: {
> > >  		error = xfs_swapext((struct xfs_swapext __user *)arg);
> > ---end quoted text---
> ---end quoted text---
---end quoted text---
