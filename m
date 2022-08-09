Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D971EC25B07
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 18:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344383AbiHISCQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 14:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245635AbiHISBv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 14:01:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433C627141
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 11:01:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5937FB8171C
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 18:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C2AC433D7;
        Tue,  9 Aug 2022 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660068062;
        bh=90k0aQBoRyDhk2DuF+TTpxvVxC25+FJL3jk8XoMh/t0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tg2axOzAuuOquHwyymh7oqgkGNmqt913f5kzGitj+DLn13cityvfJl211nK9Gf7B4
         PGW+YHltgAYYBc8hrgZD7DBd4p1slVNt0fqAD2CyP2VAdbfClD3toi+FAGrSWXO0Uu
         fZnbjJZerXijEpe3zov6cfz+nyS0f89PCaGqRIGD0Dd6ET8dk5p/FcWvkOaK6Dn5fy
         2whhabl0WkeM+pV6NeeDRYv4ukYHqlwpefpo3tuoqfLueK8i/gEhIVeYQ7xyDEbD/i
         GjyiyP3wE8vcA4OyehQyrL/G04aYMX/PyxDJXxa+Wb0gWJ8GFlDbhikAWMQsKg9TQA
         OoJoM+fHxrsdQ==
Date:   Tue, 9 Aug 2022 11:01:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 12/18] xfs: parent pointer attribute creation
Message-ID: <YvKg3XBOmAmFli0o@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-13-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:40:07PM -0700, Allison Henderson wrote:
> Add parent pointer attribute during xfs_create, and subroutines to
> initialize attributes
> 
> [bfoster: rebase, use VFS inode generation]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,

Nit: uint32_t, not unint32_t.

>            fixed some null pointer bugs,
>            merged error handling patch,
>            remove unnecessary ENOSPC handling in xfs_attr_set_first_parent]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/Makefile            |   1 +
>  fs/xfs/libxfs/xfs_attr.c   |   4 +-
>  fs/xfs/libxfs/xfs_attr.h   |   4 +-
>  fs/xfs/libxfs/xfs_parent.c | 134 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_parent.h |  34 ++++++++++
>  fs/xfs/xfs_inode.c         |  37 ++++++++--
>  fs/xfs/xfs_xattr.c         |   2 +-
>  fs/xfs/xfs_xattr.h         |   1 +
>  8 files changed, 208 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 1131dd01e4fe..caeea8d968ba 100644
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
> index 2ef3262f21e8..0a458ea7051f 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -880,7 +880,7 @@ xfs_attr_lookup(
>  	return error;
>  }
>  
> -static int
> +int
>  xfs_attr_intent_init(
>  	struct xfs_da_args	*args,
>  	unsigned int		op_flags,	/* op flag (set or remove) */
> @@ -898,7 +898,7 @@ xfs_attr_intent_init(
>  }
>  
>  /* Sets an attribute for an inode as a deferred operation */
> -static int
> +int
>  xfs_attr_defer_add(
>  	struct xfs_da_args	*args)
>  {
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index af92cc57e7d8..b47417b5172f 100644
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
> index 000000000000..4ab531c77d7d
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -0,0 +1,134 @@
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

Shouldn't we increase XFS_LINK_SPACE_RES to avoid this?  The reserve
pool isn't terribly large (8192 blocks) and was really only supposed to
save us from an ENOSPC shutdown if an unwritten extent conversion in the
writeback endio handler needs a few more blocks.

IOWs, we really ought to ENOSPC at transaction reservation time instead
of draining the reserve pool.

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
> +	xfs_mount_t                     *mp,
> +	xfs_inode_t			*ip,
> +	struct xfs_name			*target_name,
> +	struct xfs_parent_defer		**parentp)
> +{
> +	struct xfs_parent_defer		*parent;
> +	int				error;
> +
> +	if (!xfs_has_parent(mp))
> +		return 0;
> +
> +	error = xfs_attr_grab_log_assist(mp);

At some point we might want to consider boosting performance by setting
XFS_SB_FEAT_INCOMPAT_LOG_XATTRS permanently when parent pointers are
turned on, since adding the feature requires a synchronous bwrite of the
primary superblock.

I /think/ this could be accomplished by setting the feature bit in mkfs
and teaching xlog_clear_incompat to exit if xfs_has_parent()==true.
Then we can skip the xfs_attr_grab_log_assist calls.

But, let's focus on getting this patchset into good enough shape that
we can be confident that we don't need any ondisk format changes, and
worry about speed later.

> +	if (error)
> +		return error;
> +
> +	parent = kzalloc(sizeof(*parent), GFP_KERNEL);

These objects are going to be created and freed fairly frequently; could
you please convert these to a kmem cache?  (That can be a cleanup at the
end.)

> +	if (!parent)
> +		return -ENOMEM;
> +
> +	/* init parent da_args */
> +	parent->args.dp = ip;
> +	parent->args.geo = mp->m_attr_geo;
> +	parent->args.whichfork = XFS_ATTR_FORK;
> +	parent->args.attr_filter = XFS_ATTR_PARENT;
> +	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
> +	parent->args.name = (const uint8_t *)&parent->rec;
> +	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
> +
> +	if (target_name) {
> +		parent->args.value = (void *)target_name->name;
> +		parent->args.valuelen = target_name->len;
> +	}
> +
> +	*parentp = parent;
> +	return 0;
> +}
> +
> +int
> +xfs_parent_defer_add(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	struct xfs_parent_defer	*parent,
> +	xfs_dir2_dataptr_t	diroffset)
> +{
> +	struct xfs_da_args	*args = &parent->args;
> +
> +	xfs_init_parent_name_rec(&parent->rec, ip, diroffset);
> +	args->trans = tp;
> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
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
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> new file mode 100644
> index 000000000000..21a350b97ed5
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
> +int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
> +		    struct xfs_name *target_name,
> +		    struct xfs_parent_defer **parentp);
> +int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_inode *ip,
> +			 struct xfs_parent_defer *parent,
> +			 xfs_dir2_dataptr_t diroffset);
> +void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
> +
> +#endif	/* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 09876ba10a42..ef993c3a8963 100644
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
> @@ -950,7 +952,7 @@ xfs_bumplink(
>  int
>  xfs_create(
>  	struct user_namespace	*mnt_userns,
> -	xfs_inode_t		*dp,
> +	struct xfs_inode	*dp,
>  	struct xfs_name		*name,
>  	umode_t			mode,
>  	dev_t			rdev,
> @@ -962,7 +964,7 @@ xfs_create(
>  	struct xfs_inode	*ip = NULL;
>  	struct xfs_trans	*tp = NULL;
>  	int			error;
> -	bool                    unlock_dp_on_error = false;
> +	bool			unlock_dp_on_error = false;
>  	prid_t			prid;
>  	struct xfs_dquot	*udqp = NULL;
>  	struct xfs_dquot	*gdqp = NULL;
> @@ -970,6 +972,8 @@ xfs_create(
>  	struct xfs_trans_res	*tres;
>  	uint			resblks;
>  	xfs_ino_t		ino;
> +	xfs_dir2_dataptr_t	diroffset;
> +	struct xfs_parent_defer	*parent = NULL;
>  
>  	trace_xfs_create(dp, name);
>  
> @@ -996,6 +1000,12 @@ xfs_create(
>  		tres = &M_RES(mp)->tr_create;
>  	}
>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, dp, name, &parent);
> +		if (error)
> +			goto out_release_dquots;
> +	}
> +
>  	/*
>  	 * Initially assume that the file does not exist and
>  	 * reserve the resources for that case.  If that is not
> @@ -1011,7 +1021,7 @@ xfs_create(
>  				resblks, &tp);
>  	}
>  	if (error)
> -		goto out_release_dquots;
> +		goto drop_incompat;
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
> @@ -1021,6 +1031,7 @@ xfs_create(
>  	 * entry pointing to them, but a directory also the "." entry
>  	 * pointing to itself.
>  	 */
> +	init_xattrs |= xfs_has_parent(mp);
>  	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
>  	if (!error)
>  		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
> @@ -1035,11 +1046,12 @@ xfs_create(
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
> @@ -1055,6 +1067,17 @@ xfs_create(
>  		xfs_bumplink(tp, dp);
>  	}
>  
> +	/*
> +	 * If we have parent pointers, we need to add the attribute containing
> +	 * the parent information now.
> +	 */
> +	if (parent) {
> +		parent->args.dp	= ip;
> +		error = xfs_parent_defer_add(tp, dp, parent, diroffset);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * create transaction goes to disk before returning to
> @@ -1080,6 +1103,7 @@ xfs_create(
>  
>  	*ipp = ip;
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);

I don't think we need the ILOCK class annotations for unlocks.

Other than the two things I asked about, this is looking good.

--D

>  	return 0;
>  
>   out_trans_cancel:
> @@ -1094,6 +1118,9 @@ xfs_create(
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
