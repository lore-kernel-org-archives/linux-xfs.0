Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4B3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 05:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358245AbiFPFuB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiFPFt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 01:49:59 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90DF45B8A2
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 22:49:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BBA905ECAC2;
        Thu, 16 Jun 2022 15:49:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1iOC-007DvH-EK; Thu, 16 Jun 2022 15:49:56 +1000
Date:   Thu, 16 Jun 2022 15:49:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 10/17] xfs: parent pointer attribute creation
Message-ID: <20220616054956.GD227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-11-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62aac485
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=AYwfIHMwKsK5K1JwrvsA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
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
......
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

Why the cast to void?

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

Parent pointers can only use logged attributes - so this check
should actually be:

	if (xfs_has_parent_pointers(mp)) {
		.....
	}

i.e. having the parent pointer feature bit present on disk turns on
LARP mode unconditionally for that filesystem.

This means you are probably going to have to add a LARP mount
feature bit and xfs_has_larp(mp) should be converted to it. i.e. the
sysfs debug knob should go away once parent pointers are merged
because LARP will be turned on by PP and we won't need a debug mode
for testing LARP anymore...

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

White space.

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

	if (xfs_has_parent_pointers(mp))

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

Drop the inline, too.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
