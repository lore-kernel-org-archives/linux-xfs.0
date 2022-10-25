Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A3EC38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiJYVLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiJYVLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:11:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4E3BC614
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91BCA61B6B
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 21:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80E5C433C1;
        Tue, 25 Oct 2022 21:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666732289;
        bh=EihaihSidIw1LscCc3Oyx4qXs71FXf3vzNiHxajoB78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b1grb/SL1J53UfgM8fjSN4/nCsfQ1iT0hJcq6r69MIdk9kylZ3/gzHZgPlz5PL7l3
         2OfeUVd6a39e0PgopT1rkzNdPO3BDwErMnSj+ihBoCuEeCgaLtaJTxwnnmYZz/cy02
         11bwAo0Dew5DmNVJAydw4FQhJEyjcKc/NwLauLcLNyn5X31dNA+iv03BlXro/NUze5
         xKweS4/HhIR1uK7e6ALxOQKVYdv7h9R9JcPz9fwwgww/cUDUTKWglH68eFYs9tQk4Q
         NGMZmvotOZQxPr5mSmhbSX4J7O9N7dRFscsktYxV9zU9pmACANwL01IG6yQJGWdvF8
         kFu8OpybNGvEA==
Date:   Tue, 25 Oct 2022 14:11:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 15/27] xfs: parent pointer attribute creation
Message-ID: <Y1hRAMAYtw2kBLTY@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-16-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-16-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:24PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Add parent pointer attribute during xfs_create, and subroutines to
> initialize attributes
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/Makefile            |   1 +
>  fs/xfs/libxfs/xfs_attr.c   |   4 +-
>  fs/xfs/libxfs/xfs_attr.h   |   4 +-
>  fs/xfs/libxfs/xfs_parent.c | 149 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_parent.h |  34 +++++++++
>  fs/xfs/xfs_inode.c         |  63 ++++++++++++++--
>  fs/xfs/xfs_xattr.c         |   2 +-
>  fs/xfs/xfs_xattr.h         |   1 +
>  8 files changed, 247 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 03135a1c31b6..e2b2cf50ffcf 100644
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
> index 0c9589261990..805aaa5639d2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -886,7 +886,7 @@ xfs_attr_lookup(
>  	return error;
>  }
>  
> -static int
> +int
>  xfs_attr_intent_init(
>  	struct xfs_da_args	*args,
>  	unsigned int		op_flags,	/* op flag (set or remove) */
> @@ -904,7 +904,7 @@ xfs_attr_intent_init(
>  }
>  
>  /* Sets an attribute for an inode as a deferred operation */
> -static int
> +int
>  xfs_attr_defer_add(
>  	struct xfs_da_args	*args)
>  {
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index b79dae788cfb..0cf23f5117ad 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
>  bool xfs_attr_is_leaf(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
> +int xfs_attr_defer_add(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
>  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> @@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>  void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
>  			 unsigned int *total);
> -
> +int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
> +			 struct xfs_attr_intent  **attr);
>  /*
>   * Check to see if the attr should be upgraded from non-existent or shortform to
>   * single-leaf-block attribute list.
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> new file mode 100644
> index 000000000000..cf5ea8ce8bd3
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -0,0 +1,149 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022 Oracle, Inc.
> + * All rights reserved.
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
> +#include "xfs_defer.h"
> +#include "xfs_log.h"
> +#include "xfs_xattr.h"
> +#include "xfs_parent.h"
> +#include "xfs_trans_space.h"
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
> +{
> +	irec->p_ino = be64_to_cpu(rec->p_ino);
> +	irec->p_gen = be32_to_cpu(rec->p_gen);
> +	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
> +}
> +
> +int
> +xfs_parent_init(
> +	struct xfs_mount		*mp,
> +	struct xfs_parent_defer		**parentp)
> +{
> +	struct xfs_parent_defer		*parent;
> +	int				error;
> +
> +	if (!xfs_has_parent(mp))
> +		return 0;
> +
> +	error = xfs_attr_grab_log_assist(mp);
> +	if (error)
> +		return error;
> +
> +	parent = kzalloc(sizeof(*parent), GFP_KERNEL);

I suspect we're still going to want to use a dedicated slab for greater
memory efficiency, but for now this is all right.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	if (!parent)
> +		return -ENOMEM;
> +
> +	/* init parent da_args */
> +	parent->args.geo = mp->m_attr_geo;
> +	parent->args.whichfork = XFS_ATTR_FORK;
> +	parent->args.attr_filter = XFS_ATTR_PARENT;
> +	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
> +	parent->args.name = (const uint8_t *)&parent->rec;
> +	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
> +
> +	*parentp = parent;
> +	return 0;
> +}
> +
> +int
> +xfs_parent_defer_add(
> +	struct xfs_trans	*tp,
> +	struct xfs_parent_defer	*parent,
> +	struct xfs_inode	*dp,
> +	struct xfs_name		*parent_name,
> +	xfs_dir2_dataptr_t	diroffset,
> +	struct xfs_inode	*child)
> +{
> +	struct xfs_da_args	*args = &parent->args;
> +
> +	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +
> +	args->trans = tp;
> +	args->dp = child;
> +	if (parent_name) {
> +		parent->args.value = (void *)parent_name->name;
> +		parent->args.valuelen = parent_name->len;
> +	}
> +
> +	return xfs_attr_defer_add(args);
> +}
> +
> +void
> +xfs_parent_cancel(
> +	xfs_mount_t		*mp,
> +	struct xfs_parent_defer *parent)
> +{
> +	xlog_drop_incompat_feat(mp->m_log);
> +	kfree(parent);
> +}
> +
> +unsigned int
> +xfs_pptr_calc_space_res(
> +	struct xfs_mount	*mp,
> +	unsigned int		namelen)
> +{
> +	/*
> +	 * Pptrs are always the first attr in an attr tree, and never larger
> +	 * than a block
> +	 */
> +	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
> +	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
> +}
> +
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> new file mode 100644
> index 000000000000..9b8d0764aad6
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022 Oracle, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef	__XFS_PARENT_H__
> +#define	__XFS_PARENT_H__
> +
> +/*
> + * Dynamically allocd structure used to wrap the needed data to pass around
> + * the defer ops machinery
> + */
> +struct xfs_parent_defer {
> +	struct xfs_parent_name_rec	rec;
> +	struct xfs_da_args		args;
> +};
> +
> +/*
> + * Parent pointer attribute prototypes
> + */
> +void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
> +			      struct xfs_inode *ip,
> +			      uint32_t p_diroffset);
> +void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
> +			       struct xfs_parent_name_rec *rec);
> +int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
> +int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
> +			 struct xfs_inode *dp, struct xfs_name *parent_name,
> +			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
> +void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
> +unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
> +				     unsigned int namelen);
> +
> +#endif	/* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ea7aeab839c2..ae6604f51ce8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -37,6 +37,8 @@
>  #include "xfs_reflink.h"
>  #include "xfs_ag.h"
>  #include "xfs_log_priv.h"
> +#include "xfs_parent.h"
> +#include "xfs_xattr.h"
>  
>  struct kmem_cache *xfs_inode_cache;
>  
> @@ -946,10 +948,32 @@ xfs_bumplink(
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  }
>  
> +unsigned int
> +xfs_create_space_res(
> +	struct xfs_mount	*mp,
> +	unsigned int		namelen)
> +{
> +	unsigned int		ret;
> +
> +	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen);
> +	if (xfs_has_parent(mp))
> +		ret += xfs_pptr_calc_space_res(mp, namelen);
> +
> +	return ret;
> +}
> +
> +unsigned int
> +xfs_mkdir_space_res(
> +	struct xfs_mount	*mp,
> +	unsigned int		namelen)
> +{
> +	return xfs_create_space_res(mp, namelen);
> +}
> +
>  int
>  xfs_create(
>  	struct user_namespace	*mnt_userns,
> -	xfs_inode_t		*dp,
> +	struct xfs_inode	*dp,
>  	struct xfs_name		*name,
>  	umode_t			mode,
>  	dev_t			rdev,
> @@ -961,7 +985,7 @@ xfs_create(
>  	struct xfs_inode	*ip = NULL;
>  	struct xfs_trans	*tp = NULL;
>  	int			error;
> -	bool                    unlock_dp_on_error = false;
> +	bool			unlock_dp_on_error = false;
>  	prid_t			prid;
>  	struct xfs_dquot	*udqp = NULL;
>  	struct xfs_dquot	*gdqp = NULL;
> @@ -969,6 +993,8 @@ xfs_create(
>  	struct xfs_trans_res	*tres;
>  	uint			resblks;
>  	xfs_ino_t		ino;
> +	xfs_dir2_dataptr_t	diroffset;
> +	struct xfs_parent_defer	*parent = NULL;
>  
>  	trace_xfs_create(dp, name);
>  
> @@ -988,13 +1014,19 @@ xfs_create(
>  		return error;
>  
>  	if (is_dir) {
> -		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
> +		resblks = xfs_mkdir_space_res(mp, name->len);
>  		tres = &M_RES(mp)->tr_mkdir;
>  	} else {
> -		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
> +		resblks = xfs_create_space_res(mp, name->len);
>  		tres = &M_RES(mp)->tr_create;
>  	}
>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, &parent);
> +		if (error)
> +			goto out_release_dquots;
> +	}
> +
>  	/*
>  	 * Initially assume that the file does not exist and
>  	 * reserve the resources for that case.  If that is not
> @@ -1010,7 +1042,7 @@ xfs_create(
>  				resblks, &tp);
>  	}
>  	if (error)
> -		goto out_release_dquots;
> +		goto drop_incompat;
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
> @@ -1020,6 +1052,7 @@ xfs_create(
>  	 * entry pointing to them, but a directory also the "." entry
>  	 * pointing to itself.
>  	 */
> +	init_xattrs = init_xattrs || xfs_has_parent(mp);
>  	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
>  	if (!error)
>  		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
> @@ -1034,11 +1067,12 @@ xfs_create(
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
> @@ -1054,6 +1088,17 @@ xfs_create(
>  		xfs_bumplink(tp, dp);
>  	}
>  
> +	/*
> +	 * If we have parent pointers, we need to add the attribute containing
> +	 * the parent information now.
> +	 */
> +	if (parent) {
> +		error = xfs_parent_defer_add(tp, parent, dp, name, diroffset,
> +					     ip);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * create transaction goes to disk before returning to
> @@ -1079,6 +1124,7 @@ xfs_create(
>  
>  	*ipp = ip;
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	return 0;
>  
>   out_trans_cancel:
> @@ -1093,6 +1139,9 @@ xfs_create(
>  		xfs_finish_inode_setup(ip);
>  		xfs_irele(ip);
>  	}
> + drop_incompat:
> +	if (parent)
> +		xfs_parent_cancel(mp, parent);
>   out_release_dquots:
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index c325a28b89a8..d9067c5f6bd6 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -27,7 +27,7 @@
>   * they must release the permission by calling xlog_drop_incompat_feat
>   * when they're done.
>   */
> -static inline int
> +int
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
