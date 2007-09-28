Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Sep 2007 17:41:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8S0exaJ006819
	for <xfs@oss.sgi.com>; Thu, 27 Sep 2007 17:41:02 -0700
Message-ID: <46FC4DFB.40709@sgi.com>
Date: Fri, 28 Sep 2007 10:42:35 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] kill xfs_dm_fsops.c
References: <20070916120523.GB31602@lst.de>
In-Reply-To: <20070916120523.GB31602@lst.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

It is looking good Christoph.

I will merge it to the XFS dev tree shortly.

Regards,
Vlad

Christoph Hellwig wrote:
> No point having a separate file for these few methods, especially if
> we want to merge the crufty ops vector into the dmapiops one day.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-09-15 10:35:50.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-09-15 10:37:46.000000000 +0200
> @@ -46,6 +46,7 @@
>  #include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_inode_item.h"
> +#include "xfs_vfsops.h"
>  #include "xfs_vnodeops.h"
>  #include <dmapi.h>
>  #include <dmapi_kern.h>
> @@ -3071,9 +3072,10 @@ xfs_dm_obj_ref_hold(
>  static fsys_function_vector_t	xfs_fsys_vector[DM_FSYS_MAX];
>  
>  
> -int
> -xfs_dm_get_fsys_vector(
> -	caddr_t		addr)
> +STATIC int
> +xfs_dm_get_dmapiops(
> +	struct super_block	*sb,
> +	void			*addr)
>  {
>  	static	int		initialized = 0;
>  	dm_fcntl_vector_t	*vecrq;
> @@ -3357,6 +3359,81 @@ xfs_dmops_t	xfs_dmcore_xfs = {
>  };
>  EXPORT_SYMBOL(xfs_dmcore_xfs);
>  
> +STATIC const struct file_operations *
> +xfs_dm_get_invis_ops(
> +	struct inode *ip)
> +{
> +	return &xfs_invis_file_operations;
> +}
> +
> +STATIC int
> +xfs_dm_fh_to_inode(
> +	struct super_block	*sb,
> +	struct inode		**ip,
> +	dm_fid_t		*dmfid)
> +{
> +	bhv_vnode_t	*vp = NULL;
> +	xfs_mount_t	*mp = XFS_M(sb);
> +	int		error;
> +	struct xfs_fid	xfid;
> +
> +	/* Returns negative errors to DMAPI */
> +
> +	*ip = NULL;
> +	memcpy(&xfid, dmfid, sizeof(*dmfid));
> +	if (xfid.fid_len) {	/* file object handle */
> +		error = xfs_vget(mp, &vp, &xfid);
> +	}
> +	else {			/* filesystem handle */
> +		error = xfs_root(mp, &vp);
> +	}
> +	if (vp && (error == 0))
> +		*ip = vn_to_inode(vp);
> +	return -error; /* Return negative error to DMAPI */
> +}
> +
> +STATIC int
> +xfs_dm_inode_to_fh(
> +	struct inode		*inode,
> +	dm_fid_t		*dmfid,
> +	dm_fsid_t		*dmfsid)
> +{
> +	xfs_inode_t		*ip = XFS_I(inode);
> +	int			error;
> +	struct xfs_fid		xfid;
> +
> +	/* Returns negative errors to DMAPI */
> +
> +	if (ip->i_mount->m_fixedfsid == NULL)
> +		return -EINVAL;
> +	error = xfs_fid2(ip, &xfid);
> +	if (error)
> +		return -error; /* Return negative error to DMAPI */
> +
> +	memcpy(dmfid, &xfid, sizeof(*dmfid));
> +	memcpy(dmfsid, ip->i_mount->m_fixedfsid, sizeof(*dmfsid));
> +	return 0;
> +}
> +
> +STATIC void
> +xfs_dm_get_fsid(
> +	struct super_block	*sb,
> +	dm_fsid_t		*fsid)
> +{
> +	memcpy(fsid, XFS_M(sb)->m_fixedfsid, sizeof(*fsid));
> +}
> +
> +/*
> + * Filesystem operations accessed by the DMAPI core.
> + */
> +static struct filesystem_dmapi_operations xfs_dmapiops = {
> +	.get_fsys_vector	= xfs_dm_get_dmapiops,
> +	.fh_to_inode		= xfs_dm_fh_to_inode,
> +	.get_invis_ops		= xfs_dm_get_invis_ops,
> +	.inode_to_fh		= xfs_dm_inode_to_fh,
> +	.get_fsid		= xfs_dm_get_fsid,
> +};
> +
>  static int __init
>  xfs_dm_init(void)
>  {
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.h	2007-09-15 10:35:50.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.h	2007-09-15 10:36:07.000000000 +0200
> @@ -18,9 +18,6 @@
>  #ifndef __XFS_DM_H__
>  #define __XFS_DM_H__
>  
> -extern int xfs_dm_get_fsys_vector(caddr_t);
> -
>  extern struct file_system_type xfs_fs_type;
> -extern struct filesystem_dmapi_operations xfs_dmapiops;
>  
>  #endif /* __XFS_DM_H__ */
> Index: linux-2.6-xfs/fs/xfs/dmapi/Makefile-linux-2.6
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/Makefile-linux-2.6	2007-09-15 10:35:50.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/Makefile-linux-2.6	2007-09-15 10:36:07.000000000 +0200
> @@ -25,5 +25,4 @@ endif
>  
>  obj-$(CONFIG_XFS_DMAPI)		+= xfs_dmapi.o
>  
> -xfs_dmapi-y			+= xfs_dm_fsops.o \
> -				   xfs_dm.o
> +xfs_dmapi-y			+= xfs_dm.o
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-09-15 10:36:19.000000000 +0200
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,135 +0,0 @@
> -/*
> - * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -#include "xfs.h"
> -#include "xfs_fs.h"
> -#include "xfs_types.h"
> -#include "xfs_bit.h"
> -#include "xfs_log.h"
> -#include "xfs_inum.h"
> -#include "xfs_clnt.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
> -#include "xfs_ag.h"
> -#include "xfs_dir2.h"
> -#include "xfs_alloc.h"
> -#include "xfs_dmapi.h"
> -#include "xfs_mount.h"
> -#include "xfs_bmap_btree.h"
> -#include "xfs_alloc_btree.h"
> -#include "xfs_ialloc_btree.h"
> -#include "xfs_dir2_sf.h"
> -#include "xfs_attr_sf.h"
> -#include "xfs_dinode.h"
> -#include "xfs_inode.h"
> -#include "xfs_btree.h"
> -#include "xfs_ialloc.h"
> -#include "xfs_itable.h"
> -#include "xfs_bmap.h"
> -#include "xfs_rw.h"
> -#include "xfs_acl.h"
> -#include "xfs_attr.h"
> -#include "xfs_inode_item.h"
> -#include "xfs_vnodeops.h"
> -#include "xfs_vfsops.h"
> -#include <dmapi.h>
> -#include <dmapi_kern.h>
> -#include "xfs_dm.h"
> -
> -
> -STATIC const struct file_operations *
> -xfs_dm_get_invis_ops(
> -	struct inode *ip)
> -{
> -	return &xfs_invis_file_operations;
> -}
> -
> -STATIC int
> -xfs_dm_fh_to_inode(
> -	struct super_block	*sb,
> -	struct inode		**ip,
> -	dm_fid_t		*dmfid)
> -{
> -	bhv_vnode_t	*vp = NULL;
> -	xfs_mount_t	*mp = XFS_M(sb);
> -	int		error;
> -	struct xfs_fid	xfid;
> -
> -	/* Returns negative errors to DMAPI */
> -
> -	*ip = NULL;
> -	memcpy(&xfid, dmfid, sizeof(*dmfid));
> -	if (xfid.fid_len) {	/* file object handle */
> -		error = xfs_vget(mp, &vp, &xfid);
> -	}
> -	else {			/* filesystem handle */
> -		error = xfs_root(mp, &vp);
> -	}
> -	if (vp && (error == 0))
> -		*ip = vn_to_inode(vp);
> -	return -error; /* Return negative error to DMAPI */
> -}
> -
> -STATIC int
> -xfs_dm_inode_to_fh(
> -	struct inode		*inode,
> -	dm_fid_t		*dmfid,
> -	dm_fsid_t		*dmfsid)
> -{
> -	xfs_inode_t		*ip = XFS_I(inode);
> -	int			error;
> -	struct xfs_fid		xfid;
> -
> -	/* Returns negative errors to DMAPI */
> -
> -	if (ip->i_mount->m_fixedfsid == NULL)
> -		return -EINVAL;
> -	error = xfs_fid2(ip, &xfid);
> -	if (error)
> -		return -error; /* Return negative error to DMAPI */
> -
> -	memcpy(dmfid, &xfid, sizeof(*dmfid));
> -	memcpy(dmfsid, ip->i_mount->m_fixedfsid, sizeof(*dmfsid));
> -	return 0;
> -}
> -
> -STATIC int
> -xfs_dm_get_dmapiops(
> -	struct super_block	*sb,
> -	void			*addr)
> -{
> -	return -xfs_dm_get_fsys_vector(addr);
> -}
> -
> -STATIC void
> -xfs_dm_get_fsid(
> -	struct super_block	*sb,
> -	dm_fsid_t		*fsid)
> -{
> -	memcpy(fsid, XFS_M(sb)->m_fixedfsid, sizeof(*fsid));
> -}
> -
> -/*
> - * Filesystem operations accessed by the DMAPI core.
> - */
> -struct filesystem_dmapi_operations xfs_dmapiops = {
> -	.get_fsys_vector	= xfs_dm_get_dmapiops,
> -	.fh_to_inode		= xfs_dm_fh_to_inode,
> -	.get_invis_ops		= xfs_dm_get_invis_ops,
> -	.inode_to_fh		= xfs_dm_inode_to_fh,
> -	.get_fsid		= xfs_dm_get_fsid,
> -};
>
>   
