Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02F017F58
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 08:19:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAE83304053
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 06:19:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZKCzRT0s1UjfEE60 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Aug 2014 06:19:42 -0700 (PDT)
Date: Fri, 22 Aug 2014 09:19:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: combine xfs_dir_canenter into xfs_dir_createname
Message-ID: <20140822131938.GB3915@laptop.bfoster>
References: <53F6942B.80808@redhat.com>
 <53F695C3.1020607@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F695C3.1020607@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 21, 2014 at 07:58:43PM -0500, Eric Sandeen wrote:
> xfs_dir_canenter and xfs_dir_createname are
> almost identical.
> 
> Fold the former into the latter, with a helpful
> wrapper for the former.  If createname is called without
> an inode number, it now only checks for space, and does
> not actually add the entry.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index ea84e1c..fdd391f 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -237,7 +237,8 @@ xfs_dir_init(
>  }
>  
>  /*
> -  Enter a name in a directory.
> + * Enter a name in a directory.
> + * If inum is 0, only test for available space.
>   */
>  int
>  xfs_dir_createname(
> @@ -254,10 +255,12 @@ xfs_dir_createname(
>  	int			v;		/* type-checking value */
>  
>  	ASSERT(S_ISDIR(dp->i_d.di_mode));
> -	rval = xfs_dir_ino_validate(tp->t_mountp, inum);
> -	if (rval)
> -		return rval;
> -	XFS_STATS_INC(xs_dir_create);
> +	if (inum) {
> +		rval = xfs_dir_ino_validate(tp->t_mountp, inum);
> +		if (rval)
> +			return rval;
> +		XFS_STATS_INC(xs_dir_create);
> +	}
>  
>  	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
>  	if (!args)
> @@ -276,6 +279,8 @@ xfs_dir_createname(
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
>  	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> +	if (!inum)
> +		args->op_flags |= XFS_DA_OP_JUSTCHECK;
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
>  		rval = xfs_dir2_sf_addname(args);
> @@ -542,50 +547,7 @@ xfs_dir_canenter(
>  	xfs_inode_t	*dp,
>  	struct xfs_name	*name)		/* name of entry to add */
>  {
> -	struct xfs_da_args *args;
> -	int		rval;
> -	int		v;		/* type-checking value */
> -
> -	ASSERT(S_ISDIR(dp->i_d.di_mode));
> -
> -	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> -	if (!args)
> -		return -ENOMEM;
> -
> -	args->geo = dp->i_mount->m_dir_geo;
> -	args->name = name->name;
> -	args->namelen = name->len;
> -	args->filetype = name->type;
> -	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> -	args->dp = dp;
> -	args->whichfork = XFS_DATA_FORK;
> -	args->trans = tp;
> -	args->op_flags = XFS_DA_OP_JUSTCHECK | XFS_DA_OP_ADDNAME |
> -							XFS_DA_OP_OKNOENT;
> -
> -	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> -		rval = xfs_dir2_sf_addname(args);
> -		goto out_free;
> -	}
> -
> -	rval = xfs_dir2_isblock(args, &v);
> -	if (rval)
> -		goto out_free;
> -	if (v) {
> -		rval = xfs_dir2_block_addname(args);
> -		goto out_free;
> -	}
> -
> -	rval = xfs_dir2_isleaf(args, &v);
> -	if (rval)
> -		goto out_free;
> -	if (v)
> -		rval = xfs_dir2_leaf_addname(args);
> -	else
> -		rval = xfs_dir2_node_addname(args);
> -out_free:
> -	kmem_free(args);
> -	return rval;
> +	return xfs_dir_createname(tp, dp, name, 0, NULL, NULL, 0);
>  }
>  
>  /*
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
