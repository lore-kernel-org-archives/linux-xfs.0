Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 557577F96
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 12:25:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B1FC8F8050
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 10:25:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OTrpFADfG1pw8FUI for
	<xfs@oss.sgi.com>; Wed, 19 Feb 2014 10:25:36 -0800 (PST)
Message-ID: <5304F71B.4060002@redhat.com>
Date: Wed, 19 Feb 2014 13:25:31 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfs: allocate xfs_da_args to reduce stack footprint
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
	<1392783402-4726-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1392783402-4726-4-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 02/18/2014 11:16 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The struct xfs_da_args used to pass directory/attribute operation
> information to the lower layers is 128 bytes in size and is
> allocated on the stack. Dynamically allocate them to reduce the
> stack footprint of directory operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_dir2.c | 344 +++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 214 insertions(+), 130 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
> index ce16ef0..fc9a41f 100644
> --- a/fs/xfs/xfs_dir2.c
> +++ b/fs/xfs/xfs_dir2.c
> @@ -180,16 +180,23 @@ xfs_dir_init(
>  	xfs_inode_t	*dp,
>  	xfs_inode_t	*pdp)
>  {
> -	xfs_da_args_t	args;
> +	struct xfs_da_args *args;
>  	int		error;
>  
> -	memset((char *)&args, 0, sizeof(args));
> -	args.dp = dp;
> -	args.trans = tp;
>  	ASSERT(S_ISDIR(dp->i_d.di_mode));
> -	if ((error = xfs_dir_ino_validate(tp->t_mountp, pdp->i_ino)))
> +	error = xfs_dir_ino_validate(tp->t_mountp, pdp->i_ino);
> +	if (error)
>  		return error;
> -	return xfs_dir2_sf_create(&args, pdp->i_ino);
> +
> +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> +	if (!args)
> +		return ENOMEM;
> +
> +	args->dp = dp;
> +	args->trans = tp;
> +	error = xfs_dir2_sf_create(args, pdp->i_ino);
> +	kmem_free(args);
> +	return error;
>  }
>  
>  /*
> @@ -205,41 +212,56 @@ xfs_dir_createname(
>  	xfs_bmap_free_t		*flist,		/* bmap's freeblock list */
>  	xfs_extlen_t		total)		/* bmap's total block count */
>  {
> -	xfs_da_args_t		args;
> +	struct xfs_da_args	*args;
>  	int			rval;
>  	int			v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(dp->i_d.di_mode));
> -	if ((rval = xfs_dir_ino_validate(tp->t_mountp, inum)))
> +	rval = xfs_dir_ino_validate(tp->t_mountp, inum);
> +	if (rval)
>  		return rval;
>  	XFS_STATS_INC(xs_dir_create);
>  
> -	memset(&args, 0, sizeof(xfs_da_args_t));
> -	args.name = name->name;
> -	args.namelen = name->len;
> -	args.filetype = name->type;
> -	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
> -	args.inumber = inum;
> -	args.dp = dp;
> -	args.firstblock = first;
> -	args.flist = flist;
> -	args.total = total;
> -	args.whichfork = XFS_DATA_FORK;
> -	args.trans = tp;
> -	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> -
> -	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
> -		rval = xfs_dir2_sf_addname(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_block_addname(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_leaf_addname(&args);
> +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> +	if (!args)
> +		return ENOMEM;
> +
> +	args->name = name->name;
> +	args->namelen = name->len;
> +	args->filetype = name->type;
> +	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args->inumber = inum;
> +	args->dp = dp;
> +	args->firstblock = first;
> +	args->flist = flist;
> +	args->total = total;
> +	args->whichfork = XFS_DATA_FORK;
> +	args->trans = tp;
> +	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> +
> +	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		rval = xfs_dir2_sf_addname(args);
> +		goto out_free;
> +	}
> +
> +	rval = xfs_dir2_isblock(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v) {
> +		rval = xfs_dir2_block_addname(args);
> +		goto out_free;
> +	}
> +
> +	rval = xfs_dir2_isleaf(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v)
> +		rval = xfs_dir2_leaf_addname(args);
>  	else
> -		rval = xfs_dir2_node_addname(&args);
> +		rval = xfs_dir2_node_addname(args);
> +
> +out_free:
> +	kmem_free(args);
>  	return rval;
>  }
>  
> @@ -282,46 +304,68 @@ xfs_dir_lookup(
>  	xfs_ino_t	*inum,		/* out: inode number */
>  	struct xfs_name *ci_name)	/* out: actual name if CI match */
>  {
> -	xfs_da_args_t	args;
> +	struct xfs_da_args *args;
>  	int		rval;
>  	int		v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(dp->i_d.di_mode));
>  	XFS_STATS_INC(xs_dir_lookup);
>  
> -	memset(&args, 0, sizeof(xfs_da_args_t));
> -	args.name = name->name;
> -	args.namelen = name->len;
> -	args.filetype = name->type;
> -	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
> -	args.dp = dp;
> -	args.whichfork = XFS_DATA_FORK;
> -	args.trans = tp;
> -	args.op_flags = XFS_DA_OP_OKNOENT;
> +	/*
> +	 * If we don't use KM_NOFS here, lockdep will through false positive

							throw?

Reviewed-by: Brian Foster <bfoster@redhat.com>


> +	 * deadlock warnings when we come through here of the non-transactional
> +	 * lookup path because the allocation can recurse into inode reclaim.
> +	 * Doing this avoids having to add a bunch of lockdep class
> +	 * annotations into the reclaim patch for the ilock.
> +	 */
> +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> +	if (!args)
> +		return ENOMEM;
> +
> +	args->name = name->name;
> +	args->namelen = name->len;
> +	args->filetype = name->type;
> +	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args->dp = dp;
> +	args->whichfork = XFS_DATA_FORK;
> +	args->trans = tp;
> +	args->op_flags = XFS_DA_OP_OKNOENT;
>  	if (ci_name)
> -		args.op_flags |= XFS_DA_OP_CILOOKUP;
> +		args->op_flags |= XFS_DA_OP_CILOOKUP;
>  
> -	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
> -		rval = xfs_dir2_sf_lookup(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_block_lookup(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_leaf_lookup(&args);
> +	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		rval = xfs_dir2_sf_lookup(args);
> +		goto out_check_rval;
> +	}
> +
> +	rval = xfs_dir2_isblock(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v) {
> +		rval = xfs_dir2_block_lookup(args);
> +		goto out_check_rval;
> +	}
> +
> +	rval = xfs_dir2_isleaf(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v)
> +		rval = xfs_dir2_leaf_lookup(args);
>  	else
> -		rval = xfs_dir2_node_lookup(&args);
> +		rval = xfs_dir2_node_lookup(args);
> +
> +out_check_rval:
>  	if (rval == EEXIST)
>  		rval = 0;
>  	if (!rval) {
> -		*inum = args.inumber;
> +		*inum = args->inumber;
>  		if (ci_name) {
> -			ci_name->name = args.value;
> -			ci_name->len = args.valuelen;
> +			ci_name->name = args->value;
> +			ci_name->len = args->valuelen;
>  		}
>  	}
> +out_free:
> +	kmem_free(args);
>  	return rval;
>  }
>  
> @@ -338,38 +382,51 @@ xfs_dir_removename(
>  	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
>  	xfs_extlen_t	total)		/* bmap's total block count */
>  {
> -	xfs_da_args_t	args;
> +	struct xfs_da_args *args;
>  	int		rval;
>  	int		v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(dp->i_d.di_mode));
>  	XFS_STATS_INC(xs_dir_remove);
>  
> -	memset(&args, 0, sizeof(xfs_da_args_t));
> -	args.name = name->name;
> -	args.namelen = name->len;
> -	args.filetype = name->type;
> -	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
> -	args.inumber = ino;
> -	args.dp = dp;
> -	args.firstblock = first;
> -	args.flist = flist;
> -	args.total = total;
> -	args.whichfork = XFS_DATA_FORK;
> -	args.trans = tp;
> -
> -	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
> -		rval = xfs_dir2_sf_removename(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_block_removename(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_leaf_removename(&args);
> +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> +	if (!args)
> +		return ENOMEM;
> +
> +	args->name = name->name;
> +	args->namelen = name->len;
> +	args->filetype = name->type;
> +	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args->inumber = ino;
> +	args->dp = dp;
> +	args->firstblock = first;
> +	args->flist = flist;
> +	args->total = total;
> +	args->whichfork = XFS_DATA_FORK;
> +	args->trans = tp;
> +
> +	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		rval = xfs_dir2_sf_removename(args);
> +		goto out_free;
> +	}
> +
> +	rval = xfs_dir2_isblock(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v) {
> +		rval = xfs_dir2_block_removename(args);
> +		goto out_free;
> +	}
> +
> +	rval = xfs_dir2_isleaf(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v)
> +		rval = xfs_dir2_leaf_removename(args);
>  	else
> -		rval = xfs_dir2_node_removename(&args);
> +		rval = xfs_dir2_node_removename(args);
> +out_free:
> +	kmem_free(args);
>  	return rval;
>  }
>  
> @@ -386,40 +443,54 @@ xfs_dir_replace(
>  	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
>  	xfs_extlen_t	total)		/* bmap's total block count */
>  {
> -	xfs_da_args_t	args;
> +	struct xfs_da_args *args;
>  	int		rval;
>  	int		v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(dp->i_d.di_mode));
>  
> -	if ((rval = xfs_dir_ino_validate(tp->t_mountp, inum)))
> +	rval = xfs_dir_ino_validate(tp->t_mountp, inum);
> +	if (rval)
>  		return rval;
>  
> -	memset(&args, 0, sizeof(xfs_da_args_t));
> -	args.name = name->name;
> -	args.namelen = name->len;
> -	args.filetype = name->type;
> -	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
> -	args.inumber = inum;
> -	args.dp = dp;
> -	args.firstblock = first;
> -	args.flist = flist;
> -	args.total = total;
> -	args.whichfork = XFS_DATA_FORK;
> -	args.trans = tp;
> -
> -	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
> -		rval = xfs_dir2_sf_replace(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_block_replace(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_leaf_replace(&args);
> +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> +	if (!args)
> +		return ENOMEM;
> +
> +	args->name = name->name;
> +	args->namelen = name->len;
> +	args->filetype = name->type;
> +	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args->inumber = inum;
> +	args->dp = dp;
> +	args->firstblock = first;
> +	args->flist = flist;
> +	args->total = total;
> +	args->whichfork = XFS_DATA_FORK;
> +	args->trans = tp;
> +
> +	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		rval = xfs_dir2_sf_replace(args);
> +		goto out_free;
> +	}
> +
> +	rval = xfs_dir2_isblock(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v) {
> +		rval = xfs_dir2_block_replace(args);
> +		goto out_free;
> +	}
> +
> +	rval = xfs_dir2_isleaf(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v)
> +		rval = xfs_dir2_leaf_replace(args);
>  	else
> -		rval = xfs_dir2_node_replace(&args);
> +		rval = xfs_dir2_node_replace(args);
> +out_free:
> +	kmem_free(args);
>  	return rval;
>  }
>  
> @@ -434,7 +505,7 @@ xfs_dir_canenter(
>  	struct xfs_name	*name,		/* name of entry to add */
>  	uint		resblks)
>  {
> -	xfs_da_args_t	args;
> +	struct xfs_da_args *args;
>  	int		rval;
>  	int		v;		/* type-checking value */
>  
> @@ -443,29 +514,42 @@ xfs_dir_canenter(
>  
>  	ASSERT(S_ISDIR(dp->i_d.di_mode));
>  
> -	memset(&args, 0, sizeof(xfs_da_args_t));
> -	args.name = name->name;
> -	args.namelen = name->len;
> -	args.filetype = name->type;
> -	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
> -	args.dp = dp;
> -	args.whichfork = XFS_DATA_FORK;
> -	args.trans = tp;
> -	args.op_flags = XFS_DA_OP_JUSTCHECK | XFS_DA_OP_ADDNAME |
> +	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> +	if (!args)
> +		return ENOMEM;
> +
> +	args->name = name->name;
> +	args->namelen = name->len;
> +	args->filetype = name->type;
> +	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args->dp = dp;
> +	args->whichfork = XFS_DATA_FORK;
> +	args->trans = tp;
> +	args->op_flags = XFS_DA_OP_JUSTCHECK | XFS_DA_OP_ADDNAME |
>  							XFS_DA_OP_OKNOENT;
>  
> -	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
> -		rval = xfs_dir2_sf_addname(&args);
> -	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_block_addname(&args);
> -	else if ((rval = xfs_dir2_isleaf(tp, dp, &v)))
> -		return rval;
> -	else if (v)
> -		rval = xfs_dir2_leaf_addname(&args);
> +	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		rval = xfs_dir2_sf_addname(args);
> +		goto out_free;
> +	}
> +
> +	rval = xfs_dir2_isblock(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v) {
> +		rval = xfs_dir2_block_addname(args);
> +		goto out_free;
> +	}
> +
> +	rval = xfs_dir2_isleaf(tp, dp, &v);
> +	if (rval)
> +		goto out_free;
> +	if (v)
> +		rval = xfs_dir2_leaf_addname(args);
>  	else
> -		rval = xfs_dir2_node_addname(&args);
> +		rval = xfs_dir2_node_addname(args);
> +out_free:
> +	kmem_free(args);
>  	return rval;
>  }
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
