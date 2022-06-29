Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743E9C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiF2Swp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiF2Swj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:52:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA38C1C939
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 642BF6201C
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F6CC34114;
        Wed, 29 Jun 2022 18:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656528756;
        bh=5GI38V/3xHFb4ou2fi45GlQB1d5dQ8nuIlBlR4wJ3xY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ggSZPP4seW81beeCbLyYiyjsX1nnE8Ln+6j0qY5RtDHYGMlnN1WJw7+pmuPw46565
         Z7ppJIyQbQWEVbkfZxKAZoNV2vfMDwJT3/TX2TNPMOc3g45HZ24mTDGhQdxRH6jNx9
         6QSEr2XhR4suQYZbtDNB0Qhtm+rFWsx7fkGr5X9xpirFaWykoBxUZo0L/6U+sC3Mi4
         +GzINB5kS95GYSzWKBLReWpaCRhLiIe+qZmzxfFbcEDgE/6IMPlGdCmddSZNnVNJKy
         Ois5s8tPScfzUamsHEC7TIE21kPw8DKN0m/W9RTuRpO+4Pp0qljXvx+BO6MHtMVIsN
         +ZOv9y+r8uL3A==
Date:   Wed, 29 Jun 2022 11:52:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 17/17] xfs: Add parent pointer ioctl
Message-ID: <YryfdCrBUyH6jOij@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-18-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:42:00AM -0700, Allison Henderson wrote:
> This patch adds a new file ioctl to retrieve the parent pointer of a
> given inode
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/Makefile            |   1 +
>  fs/xfs/libxfs/xfs_fs.h     |  46 +++++++++++++
>  fs/xfs/libxfs/xfs_parent.c |  10 +++
>  fs/xfs/libxfs/xfs_parent.h |   2 +
>  fs/xfs/xfs_ioctl.c         |  90 ++++++++++++++++++++++++-
>  fs/xfs/xfs_ondisk.h        |   4 ++
>  fs/xfs/xfs_parent_utils.c  | 133 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_parent_utils.h  |  22 ++++++
>  8 files changed, 306 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index fc717dc3470c..da86f6231f2e 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
>  				   xfs_mount.o \
>  				   xfs_mru_cache.o \
>  				   xfs_pwork.o \
> +				   xfs_parent_utils.o \
>  				   xfs_reflink.o \
>  				   xfs_stats.o \
>  				   xfs_super.o \
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index b0b4d7a3aa15..e6c8873cd234 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -574,6 +574,7 @@ typedef struct xfs_fsop_handlereq {
>  #define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
>  #define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
>  #define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
> +#define XFS_IOC_ATTR_PARENT	0x0040  /* use attrs in parent namespace */
>  
>  typedef struct xfs_attrlist_cursor {
>  	__u32		opaque[4];
> @@ -752,6 +753,50 @@ struct xfs_scrub_metadata {
>  				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
>  #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
>  
> +#define XFS_PPTR_MAXNAMELEN				256
> +
> +/* return parents of the handle, not the open fd */
> +#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
> +
> +/* target was the root directory */
> +#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
> +
> +/* Cursor is done iterating pptrs */
> +#define XFS_PPTR_OFLAG_DONE    (1U << 2)
> +
> +/* Get an inode parent pointer through ioctl */
> +struct xfs_parent_ptr {
> +	__u64		xpp_ino;			/* Inode */
> +	__u32		xpp_gen;			/* Inode generation */
> +	__u32		xpp_diroffset;			/* Directory offset */
> +	__u32		xpp_namelen;			/* File name length */
> +	__u32		xpp_pad;
> +	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
> +};
> +
> +/* Iterate through an inodes parent pointers */
> +struct xfs_pptr_info {
> +	struct xfs_handle		pi_handle;
> +	struct xfs_attrlist_cursor	pi_cursor;
> +	__u32				pi_flags;
> +	__u32				pi_reserved;
> +	__u32				pi_ptrs_size;
> +	__u32				pi_ptrs_used;
> +	__u64				pi_reserved2[6];
> +
> +	/*
> +	 * An array of struct xfs_parent_ptr follows the header
> +	 * information. Use XFS_PPINFO_TO_PP() to access the
> +	 * parent pointer array entries.
> +	 */

	struct xfs_parent_ptr		pi_parents[];

Unless you want to conserve space in the userspace buffer by making the
size of xfs_parent_ptr itself variable?  Userspace would have to walk
the entire buffer by hand like it does for listxattr, but it saves a
fair amount of space.

> +};
> +
> +#define XFS_PPTR_INFO_SIZEOF(nr_ptrs) sizeof (struct xfs_pptr_info) + \
> +				      nr_ptrs * sizeof(struct xfs_parent_ptr)
> +
> +#define XFS_PPINFO_TO_PP(info, idx)    \
> +	(&(((struct xfs_parent_ptr *)((char *)(info) + sizeof(*(info))))[(idx)]))

Turn these into static inline functions so that client programs get some
proper typechecking by the C compiler.

> +
>  /*
>   * ioctl limits
>   */
> @@ -797,6 +842,7 @@ struct xfs_scrub_metadata {
>  /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
>  #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
>  #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
> +#define XFS_IOC_GETPPOINTER	_IOR ('X', 62, struct xfs_parent_ptr)
>  
>  /*
>   * ioctl commands that replace IRIX syssgi()'s
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index cb546652bde9..a5b99f30bc63 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -33,6 +33,16 @@
>  #include "xfs_attr_sf.h"
>  #include "xfs_bmap.h"
>  
> +/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
> +void
> +xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
> +		     struct xfs_parent_name_rec	*rec)

Indenting...

> +{
> +	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
> +	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
> +	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
> +}
> +
>  /*
>   * Parent pointer attribute handling.
>   *
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> index 10dc576ce693..fa50ada0d6a9 100644
> --- a/fs/xfs/libxfs/xfs_parent.h
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -28,4 +28,6 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
>  			      uint32_t p_diroffset);
>  void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
>  			       struct xfs_parent_name_rec *rec);
> +void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
> +			 struct xfs_parent_name_rec *rec);
>  #endif	/* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index e1612e99e0c5..4cd1de3e9d0b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -37,6 +37,7 @@
>  #include "xfs_health.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ioctl.h"
> +#include "xfs_parent_utils.h"
>  #include "xfs_xattr.h"
>  
>  #include <linux/mount.h>
> @@ -355,6 +356,8 @@ xfs_attr_filter(
>  		return XFS_ATTR_ROOT;
>  	if (ioc_flags & XFS_IOC_ATTR_SECURE)
>  		return XFS_ATTR_SECURE;
> +	if (ioc_flags & XFS_IOC_ATTR_PARENT)
> +		return XFS_ATTR_PARENT;
>  	return 0;
>  }
>  
> @@ -422,7 +425,8 @@ xfs_ioc_attr_list(
>  	/*
>  	 * Reject flags, only allow namespaces.
>  	 */
> -	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
> +	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE |
> +		      XFS_IOC_ATTR_PARENT))
>  		return -EINVAL;
>  	if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
>  		return -EINVAL;
> @@ -1672,6 +1676,87 @@ xfs_ioc_scrub_metadata(
>  	return 0;
>  }
>  
> +/*
> + * IOCTL routine to get the parent pointers of an inode and return it to user
> + * space.  Caller must pass a buffer space containing a struct xfs_pptr_info,
> + * followed by a region large enough to contain an array of struct
> + * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the inode contains
> + * more parent pointers than can fit in the buffer space, caller may re-call
> + * the function using the returned pi_cursor to resume iteration.  The
> + * number of xfs_parent_ptr returned will be stored in pi_ptrs_used.
> + *
> + * Returns 0 on success or non-zero on failure
> + */
> +STATIC int
> +xfs_ioc_get_parent_pointer(
> +	struct file			*filp,
> +	void				__user *arg)
> +{
> +	struct xfs_pptr_info		*ppi = NULL;
> +	int				error = 0;
> +	struct xfs_inode		*ip = XFS_I(file_inode(filp));
> +	struct xfs_mount		*mp = ip->i_mount;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* Allocate an xfs_pptr_info to put the user data */
> +	ppi = kmem_alloc(sizeof(struct xfs_pptr_info), 0);
> +	if (!ppi)
> +		return -ENOMEM;
> +
> +	/* Copy the data from the user */
> +	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
> +	if (error)
> +		goto out;
> +
> +	/* Check size of buffer requested by user */
> +	if (XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
> +		error = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Now that we know how big the trailing buffer is, expand
> +	 * our kernel xfs_pptr_info to be the same size
> +	 */
> +	ppi = krealloc(ppi, XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size),
> +		       GFP_NOFS | __GFP_NOFAIL);
> +	if (!ppi)
> +		return -ENOMEM;
> +
> +	if (ppi->pi_flags != 0 && ppi->pi_flags != XFS_PPTR_IFLAG_HANDLE) {

Flags validation should come before the big memory allocation.

> +		error = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {
> +		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
> +				0, 0, &ip);
> +		if (error)
> +			goto out;

This ought to be checking the generation number in the file handle.

> +	}
> +
> +	if (ip->i_ino == mp->m_sb.sb_rootino)
> +		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
> +
> +	/* Get the parent pointers */
> +	error = xfs_attr_get_parent_pointer(ip, ppi);
> +
> +	if (error)
> +		goto out;
> +
> +	/* Copy the parent pointers back to the user */
> +	error = copy_to_user(arg, ppi,
> +			XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size));
> +	if (error)
> +		goto out;
> +
> +out:
> +	kmem_free(ppi);
> +	return error;
> +}
> +
>  int
>  xfs_ioc_swapext(
>  	xfs_swapext_t	*sxp)
> @@ -1961,7 +2046,8 @@ xfs_file_ioctl(
>  
>  	case XFS_IOC_FSGETXATTRA:
>  		return xfs_ioc_fsgetxattra(ip, arg);
> -
> +	case XFS_IOC_GETPPOINTER:
> +		return xfs_ioc_get_parent_pointer(filp, arg);
>  	case XFS_IOC_GETBMAP:
>  	case XFS_IOC_GETBMAPA:
>  	case XFS_IOC_GETBMAPX:
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 758702b9495f..765eb514a917 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -135,6 +135,10 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
>  
> +	/* parent pointer ioctls */
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
> +
>  	/*
>  	 * The v5 superblock format extended several v4 header structures with
>  	 * additional data. While new fields are only accessible on v5
> diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
> new file mode 100644
> index 000000000000..9880718395c6
> --- /dev/null
> +++ b/fs/xfs/xfs_parent_utils.c
> @@ -0,0 +1,133 @@
> +/*
> + * Copyright (c) 2015 Red Hat, Inc.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_shared.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_inode.h"
> +#include "xfs_error.h"
> +#include "xfs_trace.h"
> +#include "xfs_trans.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr.h"
> +#include "xfs_ioctl.h"
> +#include "xfs_parent.h"
> +#include "xfs_da_btree.h"
> +
> +/*
> + * Get the parent pointers for a given inode
> + *
> + * Returns 0 on success and non zero on error
> + */
> +int
> +xfs_attr_get_parent_pointer(struct xfs_inode		*ip,
> +			    struct xfs_pptr_info	*ppi)
> +

Indenting.  Also, should this go in xfs_parent.c ?

> +{
> +
> +	struct xfs_attrlist		*alist;
> +	struct xfs_attrlist_ent		*aent;
> +	struct xfs_parent_ptr		*xpp;
> +	struct xfs_parent_name_rec	*xpnr;
> +	char				*namebuf;
> +	unsigned int			namebuf_size;
> +	int				name_len;
> +	int				error = 0;
> +	unsigned int			ioc_flags = XFS_IOC_ATTR_PARENT;
> +	unsigned int			flags = XFS_ATTR_PARENT;
> +	int				i;
> +	struct xfs_attr_list_context	context;
> +	struct xfs_da_args		args;
> +
> +	/* Allocate a buffer to store the attribute names */
> +	namebuf_size = sizeof(struct xfs_attrlist) +
> +		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
> +	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
> +	if (!namebuf)
> +		return -ENOMEM;
> +
> +	memset(&context, 0, sizeof(struct xfs_attr_list_context));
> +	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size,
> +			ioc_flags, &context);
> +
> +	/* Copy the cursor provided by caller */
> +	memcpy(&context.cursor, &ppi->pi_cursor,
> +	       sizeof(struct xfs_attrlist_cursor));
> +
> +	if (error)
> +		goto out_kfree;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	error = xfs_attr_list_ilocked(&context);
> +	if (error)
> +		goto out_kfree;
> +
> +	alist = (struct xfs_attrlist *)namebuf;
> +	for (i = 0; i < alist->al_count; i++) {
> +		xpp = XFS_PPINFO_TO_PP(ppi, i);
> +		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
> +		aent = (struct xfs_attrlist_ent *)
> +			&namebuf[alist->al_offset[i]];
> +		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
> +
> +		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
> +			error = -ERANGE;
> +			goto out_kfree;
> +		}
> +		name_len = aent->a_valuelen;
> +
> +		memset(&args, 0, sizeof(args));
> +		args.geo = ip->i_mount->m_attr_geo;
> +		args.whichfork = XFS_ATTR_FORK;
> +		args.dp = ip;
> +		args.name = (char *)xpnr;
> +		args.namelen = sizeof(struct xfs_parent_name_rec);
> +		args.attr_filter = flags;
> +		args.hashval = xfs_da_hashname(args.name, args.namelen);
> +		args.value = (unsigned char *)(xpp->xpp_name);
> +		args.valuelen = name_len;
> +		args.op_flags = XFS_DA_OP_OKNOENT;

You might want to convert this to a C99 named initialization inside the
loop body.

Otherwise looks ok.

--D

> +
> +		error = xfs_attr_get_ilocked(&args);
> +		error = (error == -EEXIST ? 0 : error);
> +		if (error)
> +			goto out_kfree;
> +
> +		xpp->xpp_namelen = name_len;
> +		xfs_init_parent_ptr(xpp, xpnr);
> +	}
> +	ppi->pi_ptrs_used = alist->al_count;
> +	if (!alist->al_more)
> +		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
> +
> +	/* Update the caller with the current cursor position */
> +	memcpy(&ppi->pi_cursor, &context.cursor,
> +		sizeof(struct xfs_attrlist_cursor));
> +
> +out_kfree:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	kmem_free(namebuf);
> +
> +	return error;
> +}
> +
> diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
> new file mode 100644
> index 000000000000..0e952b2ebd4a
> --- /dev/null
> +++ b/fs/xfs/xfs_parent_utils.h
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (c) 2017 Oracle, Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation Inc.
> + */
> +#ifndef	__XFS_PARENT_UTILS_H__
> +#define	__XFS_PARENT_UTILS_H__
> +
> +int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
> +				struct xfs_pptr_info *ppi);
> +#endif	/* __XFS_PARENT_UTILS_H__ */
> -- 
> 2.25.1
> 
