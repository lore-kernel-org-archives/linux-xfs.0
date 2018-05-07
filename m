Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbeEGWTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 18:19:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w47MGSF5038170
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 22:19:47 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2hs426e69b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 22:19:47 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w47MJlsM004520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 22:19:47 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w47MJkxj005440
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 22:19:47 GMT
Date: Mon, 7 May 2018 15:19:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/21] xfs: parent pointer attribute creation
Message-ID: <20180507221945.GG11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-16-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525627494-12873-16-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, May 06, 2018 at 10:24:48AM -0700, Allison Henderson wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add parent pointer attribute during xfs_create, and
> subroutines to initialize attributes
> 
> Kernel create routines take advantage of deferred attributes,
> where as libxfs routines will add parent pointers directly.
> 
> [bfoster: rebase, use VFS inode generation]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> 	   fixed some null pointer bugs,
> 	   merged error handling patch,
> 	   added subroutines to handle attribute initialization,
> 	   remove unnecessary ENOSPC handling in xfs_attr_set_first_parent]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/Makefile            |   2 +
>  fs/xfs/libxfs/xfs_parent.c | 158 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_parent.h |  36 +++++++++++
>  fs/xfs/xfs_inode.c         |  22 ++++++-
>  fs/xfs/xfs_parent_utils.c  |  51 +++++++++++++++
>  fs/xfs/xfs_parent_utils.h  |  26 ++++++++
>  6 files changed, 292 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index d3c0004..d092f72 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -53,6 +53,7 @@ xfs-y				+= $(addprefix libxfs/, \
>  				   xfs_inode_fork.o \
>  				   xfs_inode_buf.o \
>  				   xfs_log_rlimit.o \
> +				   xfs_parent.o \
>  				   xfs_ag_resv.o \
>  				   xfs_rmap.o \
>  				   xfs_rmap_btree.o \
> @@ -92,6 +93,7 @@ xfs-y				+= xfs_aops.o \
>  				   xfs_message.o \
>  				   xfs_mount.o \
>  				   xfs_mru_cache.o \
> +				   xfs_parent_utils.o \
>  				   xfs_reflink.o \
>  				   xfs_stats.o \
>  				   xfs_super.o \
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> new file mode 100644
> index 0000000..e6de97c
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -0,0 +1,158 @@
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
> +#include "xfs_da_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_shared.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_inode.h"
> +#include "xfs_error.h"
> +#include "xfs_trace.h"
> +#include "xfs_trans.h"
> +#include "xfs_attr.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr_sf.h"
> +#include "xfs_bmap.h"
> +
> +/*
> + * Parent pointer attribute handling.
> + *
> + * Because the attribute value is a filename component, it will never be longer
> + * than 255 bytes. This means the attribute will always be a local format
> + * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
> + * always be larger than this (max is 75% of block size).
> + *
> + * Creating a new parent attribute will always create a new attribute - there
> + * should never, ever be an existing attribute in the tree for a new inode.
> + * ENOSPC behaviour is problematic - creating the inode without the parent
> + * pointer is effectively a corruption, so we allow parent attribute creation
> + * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
> + * occurring.
> + */
> +
> +
> +/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
> +void
> +xfs_init_parent_name_rec(
> +			struct xfs_parent_name_rec	*rec,
> +			xfs_ino_t			p_ino,
> +			uint32_t			p_gen,

Seeing as both parameters are always from the same inode, just pass in
the inode to extract the inode number & generation.

> +			uint32_t			p_diroffset)

Only one indent here and in the other function definitions.

	uint32_t	p_diroffset)

> +{
> +	rec->p_ino = cpu_to_be64(p_ino);
> +	rec->p_gen = cpu_to_be32(p_gen);
> +	rec->p_diroffset = cpu_to_be32(p_diroffset);
> +}
> +
> +/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec */
> +void
> +xfs_init_parent_name_irec(
> +			struct xfs_parent_name_irec	*irec,
> +			struct xfs_parent_name_rec	*rec)
> +{
> +	irec->p_ino = be64_to_cpu(rec->p_ino);
> +	irec->p_gen = be32_to_cpu(rec->p_gen);
> +	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
> +}
> +
> +/*
> + * Directly add a parent pointer instead of as a deferred operation
> + * Currently only used during protofile creation
> + */
> +int
> +xfs_parent_add(
> +	struct xfs_inode	*parent,
> +	struct xfs_inode	*child,
> +	struct xfs_name		*child_name,
> +	uint32_t		diroffset,
> +	xfs_fsblock_t		*firstblock,
> +	struct xfs_defer_ops	*dfops)
> +{
> +	struct xfs_parent_name_rec	rec;

Indentation between the variable type and name should be consistent
with the parameters.  In other words, the parameters need an extra tab
before the name.

> +	int				error;
> +	struct xfs_da_args		args;
> +	int				flags = ATTR_PARENT;
> +	int				local = 0;
> +	int				rsvd = 0;
> +	struct xfs_buf			*leaf_bp = NULL;
> +	struct xfs_trans_res		tres;
> +	struct xfs_mount		*mp = child->i_mount;
> +
> +	xfs_init_parent_name_rec(&rec, parent->i_ino,
> +				 VFS_I(parent)->i_generation, diroffset);
> +
> +	error = xfs_attr_args_init(&args, child, (const unsigned char *)&rec,
> +				   sizeof(rec), flags);
> +	if (error)
> +		return error;
> +
> +	args.hashval = xfs_da_hashname(args.name, args.namelen);
> +	args.value = (char *)child_name->name;
> +	args.valuelen = child_name->len;
> +	args.dfops = dfops;
> +	args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_ADDNAME;
> +	args.firstblock = firstblock;
> +	args.total = xfs_attr_calc_size(&args, &local);
> +	ASSERT(local);
> +
> +	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> +			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> +	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> +	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +
> +	/*
> +	 * Root fork attributes can use reserved data blocks for this
> +	 * operation if necessary
> +	 */
> +	error = xfs_trans_alloc(mp, &tres, args.total, 0,
> +				rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * If the inode doesn't have an attribute fork, add one.
> +	 * (inode must not be locked when we call this routine)
> +	 */
> +	if (XFS_IFORK_Q(child) == 0) {
> +		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
> +			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, args.valuelen);
> +
> +		error = xfs_bmap_add_attrfork(child, sf_size, rsvd);
> +		if (error)
> +			return error;
> +	}
> +
> +	error = xfs_attr_set_args(&args, flags, leaf_bp, false);
> +
> +	if (error)
> +		goto out;
> +
> +	xfs_trans_log_inode(args.trans, child, XFS_ILOG_CORE);
> +
> +	return error;
> +
> +out:
> +	if (args.trans)
> +		xfs_trans_cancel(args.trans);
> +
> +	return error;
> +}
> +
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> new file mode 100644
> index 0000000..298562b
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -0,0 +1,36 @@
> +/*
> + * Copyright (c) 2017 Oracle, Inc.

Please update the copyright year. :)

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
> +#ifndef	__XFS_PARENT_H__
> +#define	__XFS_PARENT_H__
> +
> +#include "xfs_da_format.h"
> +#include "xfs_format.h"
> +
> +/*
> + * Parent pointer attribute prototypes
> + */
> +void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
> +			      xfs_ino_t p_ino, uint32_t p_gen,
> +			      uint32_t p_diroffset);
> +void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
> +			       struct xfs_parent_name_rec *rec);
> +
> +int xfs_parent_add(struct xfs_trans *tp, struct xfs_inode *parent,
> +		   struct xfs_inode *child, struct xfs_name *child_name,
> +		   uint32_t diroffset, xfs_fsblock_t *firstblock,
> +		   struct xfs_defer_ops *dfops);
> +#endif	/* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2859a697..a515f11 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -53,6 +53,7 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
>  #include "xfs_dir2_priv.h"
> +#include "xfs_parent_utils.h"
>  
>  kmem_zone_t *xfs_inode_zone;
>  
> @@ -1152,6 +1153,7 @@ xfs_create(
>  	struct xfs_dquot	*pdqp = NULL;
>  	struct xfs_trans_res	*tres;
>  	uint			resblks;
> +	xfs_dir2_dataptr_t	diroffset;
>  
>  	trace_xfs_create(dp, name);
>  
> @@ -1211,7 +1213,7 @@ xfs_create(
>  	 * entry pointing to them, but a directory also the "." entry
>  	 * pointing to itself.
>  	 */
> -	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip, XFS_ILOCK_EXCL);
> +	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip, 0);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1222,13 +1224,13 @@ xfs_create(
>  	 * the transaction cancel unlocking dp so don't do it explicitly in the
>  	 * error path.
>  	 */
> -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, 0);
>  	unlock_dp_on_error = false;
>  
>  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
>  					&first_block, &dfops, resblks ?
>  					resblks - XFS_IALLOC_SPACE_RES(mp) : 0,
> -					NULL);
> +					&diroffset);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
>  		goto out_trans_cancel;
> @@ -1247,6 +1249,17 @@ xfs_create(
>  	}
>  
>  	/*
> +	 * If we have parent pointers, we need to add the attribute containing
> +	 * the parent information now. 

Trailing whitespace (see scripts/checkpatch.pl)

> +	 */
> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +		error = xfs_parent_add_deferred(dp, ip, name, diroffset,
> +					  &dfops);
> +		if (error)
> +			goto out_bmap_cancel;
> +	}
> +
> +	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * create transaction goes to disk before returning to
>  	 * the user.
> @@ -1274,6 +1287,9 @@ xfs_create(
>  	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> +
>  	return 0;
>  
>   out_bmap_cancel:
> diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
> new file mode 100644
> index 0000000..cf4a7e2
> --- /dev/null
> +++ b/fs/xfs/xfs_parent_utils.c
> @@ -0,0 +1,51 @@
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
> +#include "xfs_attr.h"
> +#include "xfs_parent.h"
> +
> +/*
> + * Add a parent record to an inode with existing parent records.
> + */
> +int
> +xfs_parent_add_deferred(
> +	struct xfs_inode        *parent,
> +	struct xfs_inode        *child,
> +	struct xfs_name         *child_name,
> +	uint32_t                diroffset,
> +	struct xfs_defer_ops    *dfops)
> +{
> +	struct xfs_parent_name_rec rec;
> +
> +	xfs_init_parent_name_rec(&rec, parent->i_ino,
> +		VFS_I(parent)->i_generation, diroffset);
> +
> +	return xfs_attr_set_deferred(child, dfops, &rec, sizeof(rec),
> +		(void *)child_name->name, child_name->len, ATTR_PARENT);

Needs two indents here.

	return xfs_attr_set_deferred(child, dfops, &rec, sizeof(rec),
			(void *)child_name->name, child_name->len, ATTR_PARENT);

Looks ok otherwise.

--D

> +}
> +
> diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
> new file mode 100644
> index 0000000..a667d1d
> --- /dev/null
> +++ b/fs/xfs/xfs_parent_utils.h
> @@ -0,0 +1,26 @@
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
> +/*
> + * Parent pointer attribute prototypes
> + */
> +int xfs_parent_add_deferred(struct xfs_inode *parent, struct xfs_inode *child,
> +	       struct xfs_name *child_name, uint32_t diroffset,
> +	       struct xfs_defer_ops *dfops);
> +#endif	/* __XFS_PARENT_UTILS_H__ */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
