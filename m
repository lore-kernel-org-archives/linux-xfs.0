Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762E3C19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 19:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbiHIT0j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbiHIT0i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 15:26:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B4211803
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 12:26:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62B51B8188F
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 19:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D2AC433C1;
        Tue,  9 Aug 2022 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660073194;
        bh=x1HDr/xxnocO9UTccxmq1jAHT6WDdiYiUDy3LkHg9TM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IEdYNatF6+tqtN+J60Ocvt+cWneQVPm6pQLiO5lqVmJYJFnT+3f6Yx5S+kAL5GwL/
         nvZSjQSx+BxZC6LVfCoi57b4RYrIUVGGE0ca9dB5Let4Jebc/r0yf9zwC2UYgflM7u
         +RGRWnS+vqE23pPI8PNxSq+iQYr9Sp+ucrUEao59PsPh8Tt1iBRmnyNCmwnT3lVQT4
         /zneJvBx4tFuMgmqSwzO98m/HcSfTS+0yXD3McyF5lLjuCJ684bFgd/KLkGkKw8yMf
         lxfykVLbQrsFUPtjetBBM5wgmWSewFAkDs2dHEFq9NNdPdNNWo46AYjqHMMbYB46GL
         XK34h+wVZLy4A==
Date:   Tue, 9 Aug 2022 12:26:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 18/18] xfs: Add parent pointer ioctl
Message-ID: <YvK06Xy2T7TgQcm0@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-19-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:40:13PM -0700, Allison Henderson wrote:
> This patch adds a new file ioctl to retrieve the parent pointer of a
> given inode
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/Makefile            |   1 +
>  fs/xfs/libxfs/xfs_fs.h     |  57 ++++++++++++++++
>  fs/xfs/libxfs/xfs_parent.c |  10 +++
>  fs/xfs/libxfs/xfs_parent.h |   2 +
>  fs/xfs/xfs_ioctl.c         |  95 +++++++++++++++++++++++++-
>  fs/xfs/xfs_ondisk.h        |   4 ++
>  fs/xfs/xfs_parent_utils.c  | 134 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_parent_utils.h  |  22 ++++++
>  8 files changed, 323 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index caeea8d968ba..998658e40ab4 100644
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
> index b0b4d7a3aa15..ba6ec82a0272 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -574,6 +574,7 @@ typedef struct xfs_fsop_handlereq {
>  #define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
>  #define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
>  #define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
> +#define XFS_IOC_ATTR_PARENT	0x0040  /* use attrs in parent namespace */

This is the userspace API header, so I wonder -- should we allow
XFS_IOC_ATTRLIST_BY_HANDLE and XFS_IOC_ATTRMULTI_BY_HANDLE to access
parent pointers?

I think it's *definitely* incorrect to let ATTR_OP_REMOVE or ATTR_OP_SET
(attrmulti subcommands) to mess with parent pointers.

I don't think attrlist or ATTR_OP_GET should be touching them either,
particularly since you're defining a new ioctl to extract *only* the
parent pointers.

If there wasn't XFS_IOC_GETPPOINTER then perhaps it would be ok to allow
reads via ATTRLIST/ATTRMULTI.  But even then, I don't think we want
things like xfsdump to think that it has to preserve those attributes
since xfsrestore will reconstruct the directory tree (and hence the
pptrs) for us.

>  
>  typedef struct xfs_attrlist_cursor {
>  	__u32		opaque[4];
> @@ -752,6 +753,61 @@ struct xfs_scrub_metadata {
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

Since xpp_name is a fixed-length array that is long enough to ensure
that there's a null at the end of the name, we don't need xpp_namelen.

I wonder if xpp_namelen and xpp_pad should simply turn into a u64 field
that's defined zero for future expansion?

> +};
> +
> +/* Iterate through an inodes parent pointers */
> +struct xfs_pptr_info {
> +	struct xfs_handle		pi_handle;
> +	struct xfs_attrlist_cursor	pi_cursor;
> +	__u32				pi_flags;
> +	__u32				pi_reserved;
> +	__u32				pi_ptrs_size;

Is this the number of elements in pi_parents[]?

> +	__u32				pi_ptrs_used;
> +	__u64				pi_reserved2[6];
> +
> +	/*
> +	 * An array of struct xfs_parent_ptr follows the header
> +	 * information. Use XFS_PPINFO_TO_PP() to access the
> +	 * parent pointer array entries.
> +	 */
> +	struct xfs_parent_ptr		pi_parents[];
> +};
> +
> +static inline size_t
> +xfs_pptr_info_sizeof(int nr_ptrs)
> +{
> +	return sizeof(struct xfs_pptr_info) +
> +	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
> +}
> +
> +static inline struct xfs_parent_ptr*
> +xfs_ppinfo_to_pp(
> +	struct xfs_pptr_info	*info,
> +	int			idx)
> +{
> +

Nit: extra space.

> +	return &info->pi_parents[idx];
> +}
> +
>  /*
>   * ioctl limits
>   */
> @@ -797,6 +853,7 @@ struct xfs_scrub_metadata {
>  /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
>  #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
>  #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
> +#define XFS_IOC_GETPPOINTER	_IOR ('X', 62, struct xfs_parent_ptr)

I wonder if this name should more strongly emphasize that it's for reading
the parents of a file?

#define XFS_IOC_GETPARENTS	_IOWR(...)

Also, the ioctl reads and writes its parameter, so this is _IOWR, not
_IOR.

BTW, is there a sample manpage somewhere?

>  
>  /*
>   * ioctl commands that replace IRIX syssgi()'s
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index 03f03f731d02..d9c922a78617 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -26,6 +26,16 @@
>  #include "xfs_xattr.h"
>  #include "xfs_parent.h"
>  
> +/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
> +void
> +xfs_init_parent_ptr(struct xfs_parent_ptr	*xpp,
> +		    struct xfs_parent_name_rec	*rec)

The second parameter ought to be const struct xfs_parent_name_rec *rec
to make it unambiguous to readers which is the source and which is the
destination argument.

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
> index 67948f4b3834..53161b79d1e2 100644
> --- a/fs/xfs/libxfs/xfs_parent.h
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -23,6 +23,8 @@ void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
>  			      uint32_t p_diroffset);
>  void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
>  			       struct xfs_parent_name_rec *rec);
> +void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
> +			 struct xfs_parent_name_rec *rec);
>  int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
>  		    struct xfs_name *target_name,
>  		    struct xfs_parent_defer **parentp);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5b600d3f7981..8a9530588ef4 100644
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

I think xfs_ioc_attrmulti_one needs filtering for XFS_IOC_ATTR_PARENT,
if we're still going to allow attrlist/attrmulti to return parent
pointers.

>  	if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
>  		return -EINVAL;
> @@ -1679,6 +1683,92 @@ xfs_ioc_scrub_metadata(
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

New code should call kmalloc instead of the old kmem_alloc wrapper.

> +	if (!ppi)
> +		return -ENOMEM;
> +
> +	/* Copy the data from the user */
> +	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));

Note: copy_from_user returns the number of bytes *not* copied.  If you
receive a nonzero return value, error usually gets set to EFAULT.

> +	if (error)
> +		goto out;
> +
> +	/* Check size of buffer requested by user */
> +	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
> +		error = -ENOMEM;
> +		goto out;
> +	}
> +
> +	if (ppi->pi_flags != 0 && ppi->pi_flags != XFS_PPTR_IFLAG_HANDLE) {

	if (ppi->pi_flags & ~XFS_PPTR_IFLAG_HANDLE) ?

(If we really want to be pedantic, this really ought to be:

#define XFS_PPTR_IFLAG_ALL	(XFS_PPTR_IFLAG_HANDLE)

	if (ppi->pi_flags & ~XFS_PPTR_IFLAG_ALL)
		return -EINVAL;

Or you could be more flexible, since the kernel could just set the
OFLAGs appropriately and not care about their value on input:

#define XFS_PPTR_FLAG_ALL	(XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG...)

	if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL)
		return -EINVAL;

	ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT | XFS_PPTR_OFLAG_DONE);

> +		error = -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Now that we know how big the trailing buffer is, expand
> +	 * our kernel xfs_pptr_info to be the same size
> +	 */
> +	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size),
> +		       GFP_NOFS | __GFP_NOFAIL);
> +	if (!ppi)
> +		return -ENOMEM;

Why NOFS and NOFAIL?  We don't have any writeback resources locked
(transactions and ILOCKs) so we can hit ourselves up for memory.

> +
> +	if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {

	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {

> +		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
> +				0, 0, &ip);
> +		if (error)
> +			goto out;
> +
> +		if (VFS_I(ip)->i_generation != ppi->pi_handle.ha_fid.fid_gen) {
> +			error = -EINVAL;
> +			goto out;
> +		}
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
> +			xfs_pptr_info_sizeof(ppi->pi_ptrs_size));

Same note as the one I made for copy_from_user.

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
> @@ -1968,7 +2058,8 @@ xfs_file_ioctl(
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
> index 000000000000..3351ce173075
> --- /dev/null
> +++ b/fs/xfs/xfs_parent_utils.c
> @@ -0,0 +1,134 @@
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

Please condense this boilerplate down to a SPDX tag and a copyright
statement.

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
> +{
> +
> +	struct xfs_attrlist		*alist;

int
xfs_attr_get_parent_pointer(
	struct xfs_inode		*ip,
	struct xfs_pptr_info		*ppi)
{
	struct xfs_attrlist		*alist;


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
> +
> +	/* Allocate a buffer to store the attribute names */
> +	namebuf_size = sizeof(struct xfs_attrlist) +
> +		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
> +	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
> +	if (!namebuf)
> +		return -ENOMEM;

Do we need the buffer to be zeroed if xfs_attr_list is just going to set
its contents?

> +
> +	memset(&context, 0, sizeof(struct xfs_attr_list_context));
> +	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size,
> +			ioc_flags, &context);

Aha, so the internal implementation has access to xfs_attr_list_context
before it calls into the attr list code.  Ok, in that case, xfs_fs.h
doesn't need the XFS_IOC_ATTR_PARENT flag, and you can set
context.attr_filter = XFS_ATTR_PARENT here.  Then we don't have to worry
about the existing xattr bulk ioctls returning parent pointers.

> +
> +	/* Copy the cursor provided by caller */
> +	memcpy(&context.cursor, &ppi->pi_cursor,
> +	       sizeof(struct xfs_attrlist_cursor));
> +
> +	if (error)
> +		goto out_kfree;

Why does the error check come after copying the cursor into the onstack
variable?

> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);

xfs_ilock_attr_map_shared() ?

> +
> +	error = xfs_attr_list_ilocked(&context);
> +	if (error)
> +		goto out_kfree;
> +
> +	alist = (struct xfs_attrlist *)namebuf;
> +	for (i = 0; i < alist->al_count; i++) {
> +		struct xfs_da_args args = {
> +			.geo = ip->i_mount->m_attr_geo,
> +			.whichfork = XFS_ATTR_FORK,
> +			.dp = ip,
> +			.namelen = sizeof(struct xfs_parent_name_rec),
> +			.attr_filter = flags,
> +			.op_flags = XFS_DA_OP_OKNOENT,
> +		};
> +
> +		xpp = xfs_ppinfo_to_pp(ppi, i);
> +		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
> +		aent = (struct xfs_attrlist_ent *)
> +			&namebuf[alist->al_offset[i]];
> +		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
> +
> +		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
> +			error = -ERANGE;
> +			goto out_kfree;

If a parent pointer has a name longer than MAXNAMELEN then isn't that a
corruption?  And in that case, -EFSCORRUPTED would be more appropriate
here, right?

> +		}
> +		name_len = aent->a_valuelen;
> +
> +		args.name = (char *)xpnr;
> +		args.hashval = xfs_da_hashname(args.name, args.namelen),
> +		args.value = (unsigned char *)(xpp->xpp_name);
> +		args.valuelen = name_len;
> +
> +		error = xfs_attr_get_ilocked(&args);

If error is ENOENT (or ENOATTR or whatever the return value is when the
attr doesn't exist) then shouldn't that be treated as a corruption too?
We still hold the ILOCK from earlier.  I don't think OKNOENT is correct
either.

> +		error = (error == -EEXIST ? 0 : error);
> +		if (error)
> +			goto out_kfree;
> +
> +		xpp->xpp_namelen = name_len;
> +		xfs_init_parent_ptr(xpp, xpnr);

Also, should we validate xpnr before copying it out to userspace?
If, say, the inode number is bogus, that should generate an
EFSCORRUPTED.

> +	}
> +	ppi->pi_ptrs_used = alist->al_count;
> +	if (!alist->al_more)
> +		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
> +
> +	/* Update the caller with the current cursor position */
> +	memcpy(&ppi->pi_cursor, &context.cursor,
> +		sizeof(struct xfs_attrlist_cursor));

Glad you remembered to do this; attrmulti forgot to do this for a long
time. :)

> +
> +out_kfree:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	kmem_free(namebuf);

kvfree, since you got namebuf from kvzalloc.

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

2022?

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

This also needs to be condensed to a SPDX header and a copyright
statement.

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
