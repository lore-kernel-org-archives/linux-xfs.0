Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A2DC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiF2SlS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiF2SlR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:41:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686162A952
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27748B82564
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2D6C34114;
        Wed, 29 Jun 2022 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656528070;
        bh=SSscVzMq2YTglw1+lA9/csYTAJyG7Zg7KRtXVBaGKXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V3T5jocCdBjb5hEgMdOuIYqz79qVw11A4C5qARFRA/LP3tgeRF4c5hhfBACWXbi3u
         usxlqSB2P+5Layruc2x/4tPEVz5LJzCL0nOemYKBhQ5mmleMTrGVCO9Ma19+HwSpad
         LGMedGTVKWcuw+KtqYQM9WHumZI2OilwKIYwg8CFy8TLfQoV+YqLv1PsS3F9+wdRgg
         vY9/VM5fsE2uqR2Jm+24TyP0fIqbaQft6T165fYfTgaQ6fBCorkxtG+LxhDSuzecyu
         Cf8xaZB9JCRMdANP6PI8N3M9+hpmDaLmubwdwHQTmjiprrkb8hidF8lfO/kK+0GfWK
         hk3fnBLYfrBgw==
Date:   Wed, 29 Jun 2022 11:41:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 10/17] xfs: parent pointer attribute creation
Message-ID: <YrycxuNGtYUvtYwC@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-11-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:53AM -0700, Allison Henderson wrote:
> Add parent pointer attribute during xfs_create, and subroutines to
> initialize attributes
> 
> [bfoster: rebase, use VFS inode generation]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
>            fixed some null pointer bugs,
>            merged error handling patch,
>            added subroutines to handle attribute initialization,
>            remove unnecessary ENOSPC handling in xfs_attr_set_first_parent]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/Makefile            |  1 +
>  fs/xfs/libxfs/xfs_attr.c   |  2 +-
>  fs/xfs/libxfs/xfs_attr.h   |  1 +
>  fs/xfs/libxfs/xfs_parent.c | 77 +++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_parent.h | 31 ++++++++++++++
>  fs/xfs/xfs_inode.c         | 88 +++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_xattr.c         |  2 +-
>  fs/xfs/xfs_xattr.h         |  1 +
>  8 files changed, 177 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index b056cfc6398e..fc717dc3470c 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
>  				   xfs_inode_fork.o \
>  				   xfs_inode_buf.o \
>  				   xfs_log_rlimit.o \
> +				   xfs_parent.o \
>  				   xfs_ag_resv.o \
>  				   xfs_rmap.o \
>  				   xfs_rmap_btree.o \
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 30c8d9e9c2f1..f814a9177237 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -926,7 +926,7 @@ xfs_attr_intent_init(
>  }
>  
>  /* Sets an attribute for an inode as a deferred operation */
> -static int
> +int
>  xfs_attr_defer_add(
>  	struct xfs_da_args	*args)
>  {
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index a87bc503976b..576062e37d11 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -559,6 +559,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
>  bool xfs_attr_is_leaf(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
> +int xfs_attr_defer_add(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
>  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> new file mode 100644
> index 000000000000..cb546652bde9
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -0,0 +1,77 @@
> +/*

New files need an SPDX header.

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

No need for all this boilerplate once you've switched to SPDX tags.

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
> +#include "xfs_da_btree.h"
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
> + * ENOSPC behavior is problematic - creating the inode without the parent
> + * pointer is effectively a corruption, so we allow parent attribute creation
> + * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
> + * occurring.
> + */
> +
> +
> +/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
> +void
> +xfs_init_parent_name_rec(
> +	struct xfs_parent_name_rec	*rec,
> +	struct xfs_inode		*ip,
> +	uint32_t			p_diroffset)
> +{
> +	xfs_ino_t			p_ino = ip->i_ino;
> +	uint32_t			p_gen = VFS_I(ip)->i_generation;
> +
> +	rec->p_ino = cpu_to_be64(p_ino);
> +	rec->p_gen = cpu_to_be32(p_gen);
> +	rec->p_diroffset = cpu_to_be32(p_diroffset);
> +}
> +
> +/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec */
> +void
> +xfs_init_parent_name_irec(
> +	struct xfs_parent_name_irec	*irec,
> +	struct xfs_parent_name_rec	*rec)

Should this second arg be const struct xfs_parent_name_rec* ?

> +{
> +	irec->p_ino = be64_to_cpu(rec->p_ino);
> +	irec->p_gen = be32_to_cpu(rec->p_gen);
> +	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
> +}
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> new file mode 100644
> index 000000000000..10dc576ce693
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -0,0 +1,31 @@
> +/*
> + * Copyright (c) 2018 Oracle, Inc.

New file needs an SPDX header, and you should probably update the
copyright to be 2018-2022.

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

No need for all this boilerplate once you've switched to SPDX tags.

> + */
> +#ifndef	__XFS_PARENT_H__
> +#define	__XFS_PARENT_H__
> +
> +#include "xfs_da_format.h"
> +#include "xfs_format.h"

Don't include headers in headers.  If it's really a mess to add these
two to every single .c file, then just add:

struct xfs_inode;
struct xfs_parent_name_rec;
struct xfs_parent_name_irec;

and that'll do for pointers.

> +
> +/*
> + * Parent pointer attribute prototypes
> + */
> +void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
> +			      struct xfs_inode *ip,
> +			      uint32_t p_diroffset);
> +void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
> +			       struct xfs_parent_name_rec *rec);
> +#endif	/* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b2dfd84e1f62..6b1e4cb11b5c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -36,6 +36,8 @@
>  #include "xfs_reflink.h"
>  #include "xfs_ag.h"
>  #include "xfs_log_priv.h"
> +#include "xfs_parent.h"
> +#include "xfs_xattr.h"
>  
>  struct kmem_cache *xfs_inode_cache;
>  
> @@ -962,27 +964,40 @@ xfs_bumplink(
>  
>  int
>  xfs_create(
> -	struct user_namespace	*mnt_userns,
> -	xfs_inode_t		*dp,
> -	struct xfs_name		*name,
> -	umode_t			mode,
> -	dev_t			rdev,
> -	bool			init_xattrs,
> -	xfs_inode_t		**ipp)
> -{
> -	int			is_dir = S_ISDIR(mode);
> -	struct xfs_mount	*mp = dp->i_mount;
> -	struct xfs_inode	*ip = NULL;
> -	struct xfs_trans	*tp = NULL;
> -	int			error;
> -	bool                    unlock_dp_on_error = false;
> -	prid_t			prid;
> -	struct xfs_dquot	*udqp = NULL;
> -	struct xfs_dquot	*gdqp = NULL;
> -	struct xfs_dquot	*pdqp = NULL;
> -	struct xfs_trans_res	*tres;
> -	uint			resblks;
> -	xfs_ino_t		ino;
> +	struct user_namespace		*mnt_userns,
> +	xfs_inode_t			*dp,

Convert the struct typedefs...

--D

> +	struct xfs_name			*name,
> +	umode_t				mode,
> +	dev_t				rdev,
> +	bool				init_xattrs,
> +	xfs_inode_t			**ipp)
> +{
> +	int				is_dir = S_ISDIR(mode);
> +	struct xfs_mount		*mp = dp->i_mount;
> +	struct xfs_inode		*ip = NULL;
> +	struct xfs_trans		*tp = NULL;
> +	int				error;
> +	bool				unlock_dp_on_error = false;
> +	prid_t				prid;
> +	struct xfs_dquot		*udqp = NULL;
> +	struct xfs_dquot		*gdqp = NULL;
> +	struct xfs_dquot		*pdqp = NULL;
> +	struct xfs_trans_res		*tres;
> +	uint				resblks;
> +	xfs_ino_t			ino;
> +	xfs_dir2_dataptr_t		diroffset;
> +	struct xfs_parent_name_rec	rec;
> +	struct xfs_da_args		args = {
> +		.dp		= dp,
> +		.geo		= mp->m_attr_geo,
> +		.whichfork	= XFS_ATTR_FORK,
> +		.attr_filter	= XFS_ATTR_PARENT,
> +		.op_flags	= XFS_DA_OP_OKNOENT,
> +		.name		= (const uint8_t *)&rec,
> +		.namelen	= sizeof(rec),
> +		.value		= (void *)name->name,
> +		.valuelen	= name->len,
> +	};
>  
>  	trace_xfs_create(dp, name);
>  
> @@ -1009,6 +1024,12 @@ xfs_create(
>  		tres = &M_RES(mp)->tr_create;
>  	}
>  
> +	if (xfs_has_larp(mp)) {
> +		error = xfs_attr_grab_log_assist(mp);
> +		if (error)
> +			goto out_release_dquots;
> +	}
> +
>  	/*
>  	 * Initially assume that the file does not exist and
>  	 * reserve the resources for that case.  If that is not
> @@ -1024,7 +1045,7 @@ xfs_create(
>  				resblks, &tp);
>  	}
>  	if (error)
> -		goto out_release_dquots;
> +		goto drop_incompat;
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
> @@ -1048,11 +1069,12 @@ xfs_create(
>  	 * the transaction cancel unlocking dp so don't do it explicitly in the
>  	 * error path.
>  	 */
> -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, 0);
>  	unlock_dp_on_error = false;
>  
>  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> -				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
> +				   resblks - XFS_IALLOC_SPACE_RES(mp),
> +				   &diroffset);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
>  		goto out_trans_cancel;
> @@ -1068,6 +1090,20 @@ xfs_create(
>  		xfs_bumplink(tp, dp);
>  	}
>  
> +	/*
> +	 * If we have parent pointers, we need to add the attribute containing
> +	 * the parent information now.
> +	 */
> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +		xfs_init_parent_name_rec(&rec, dp, diroffset);
> +		args.dp	= ip;
> +		args.trans = tp;
> +		args.hashval = xfs_da_hashname(args.name, args.namelen);
> +		error =  xfs_attr_defer_add(&args);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * create transaction goes to disk before returning to
> @@ -1093,6 +1129,7 @@ xfs_create(
>  
>  	*ipp = ip;
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	return 0;
>  
>   out_trans_cancel:
> @@ -1107,6 +1144,9 @@ xfs_create(
>  		xfs_finish_inode_setup(ip);
>  		xfs_irele(ip);
>  	}
> + drop_incompat:
> +	if (xfs_has_larp(mp))
> +		xlog_drop_incompat_feat(mp->m_log);
>   out_release_dquots:
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 35e13e125ec6..6012a6ba512c 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -27,7 +27,7 @@
>   * they must release the permission by calling xlog_drop_incompat_feat
>   * when they're done.
>   */
> -static inline int
> +inline int
>  xfs_attr_grab_log_assist(
>  	struct xfs_mount	*mp)
>  {
> diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
> index 2b09133b1b9b..3fd6520a4d69 100644
> --- a/fs/xfs/xfs_xattr.h
> +++ b/fs/xfs/xfs_xattr.h
> @@ -7,6 +7,7 @@
>  #define __XFS_XATTR_H__
>  
>  int xfs_attr_change(struct xfs_da_args *args);
> +int xfs_attr_grab_log_assist(struct xfs_mount *mp);
>  
>  extern const struct xattr_handler *xfs_xattr_handlers[];
>  
> -- 
> 2.25.1
> 
