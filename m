Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 95E487F3F
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 14:05:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4794B304032
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 12:05:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vR38vrSdjFcKOHOw for
	<xfs@oss.sgi.com>; Fri, 23 May 2014 12:05:08 -0700 (PDT)
Date: Fri, 23 May 2014 15:04:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/16] xfs: introduce directory geometry structure
Message-ID: <20140523190459.GB8343@laptop.bfoster>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400803432-20048-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, May 23, 2014 at 10:03:37AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The directory code has a dependency on the struct xfs_mount to
> supply the directory block geometry. Block size, block log size,
> and other parameters are pre-caclulated in the struct xfs_mount or
> access directly from the superblock embedded in the struct
> xfs_mount.
> 
> Extract all of this geometry information out of the struct xfs_mount
> and superblock and place it into a new struct xfs_da_geometry
> defined by the directory code. Allocate and initialise it at mount
> time, and attach it to the struct xfs_mount so it canbe passed back
> into the directory code appropriately rather than using the struct
> xfs_mount.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_attr.c      |  1 +
>  fs/xfs/xfs_attr_leaf.c |  2 ++
>  fs/xfs/xfs_attr_list.c |  1 +
>  fs/xfs/xfs_da_btree.h  | 18 +++++++++++++++
>  fs/xfs/xfs_dir2.c      | 63 ++++++++++++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_dir2.h      |  2 +-
>  fs/xfs/xfs_mount.c     | 18 +++++++++------
>  fs/xfs/xfs_mount.h     |  3 +++
>  8 files changed, 88 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index 1fc1f06..c547498 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
> @@ -88,6 +88,7 @@ xfs_attr_args_init(
>  		return EINVAL;
>  
>  	memset(args, 0, sizeof(*args));
> +	args->geo = dp->i_mount->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->dp = dp;
>  	args->flags = flags;
> diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> index 511c283..2c0fdc8 100644
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -711,6 +711,7 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
>  
>  	memset((char *)&nargs, 0, sizeof(nargs));
>  	nargs.dp = dp;
> +	nargs.geo = args->geo;
>  	nargs.firstblock = args->firstblock;
>  	nargs.flist = args->flist;
>  	nargs.total = args->total;
> @@ -838,6 +839,7 @@ xfs_attr3_leaf_to_shortform(
>  	 * Copy the attributes
>  	 */
>  	memset((char *)&nargs, 0, sizeof(nargs));
> +	nargs.geo = args->geo;
>  	nargs.dp = dp;
>  	nargs.firstblock = args->firstblock;
>  	nargs.flist = args->flist;
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 833fe5d..90e2eeb 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -444,6 +444,7 @@ xfs_attr3_leaf_list_int(
>  				xfs_da_args_t args;
>  
>  				memset((char *)&args, 0, sizeof(args));
> +				args.geo = context->dp->i_mount->m_attr_geo;
>  				args.dp = context->dp;
>  				args.whichfork = XFS_ATTR_FORK;
>  				args.valuelen = valuelen;
> diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
> index c824a0a..0ac63ad 100644
> --- a/fs/xfs/xfs_da_btree.h
> +++ b/fs/xfs/xfs_da_btree.h
> @@ -25,6 +25,23 @@ struct xfs_trans;
>  struct zone;
>  struct xfs_dir_ops;
>  
> +/*
> + * Directory/attribute geometry information. There will be one of these for each
> + * data fork type, and it will be passed around via the xfs_da_args. Global
> + * structures will be attached to the xfs_mount.
> + */
> +struct xfs_da_geometry {
> +	int		blksize;	/* da block size in bytes */
> +	int		fsbcount;	/* da block size in filesystem blocks */
> +	uint8_t		fsblog;		/* log2 of _filesystem_ block size */
> +	uint8_t		blklog;		/* log2 of da block size */
> +	uint		node_ents;	/* # of entries in a danode */
> +	int		magicpct;	/* 37% of block size in bytes */
> +	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
> +	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
> +	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
> +};
> +
>  /*========================================================================
>   * Btree searching and modification structure definitions.
>   *========================================================================*/
> @@ -42,6 +59,7 @@ enum xfs_dacmp {
>   * Structure to ease passing around component names.
>   */
>  typedef struct xfs_da_args {
> +	struct xfs_da_geometry *geo;	/* da block geometry */
>  	const __uint8_t	*name;		/* string (maybe not NULL terminated) */
>  	int		namelen;	/* length of string (maybe no NULL) */
>  	__uint8_t	filetype;	/* filetype of inode for directories */
> diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
> index 93fcebd..16c3c4b 100644
> --- a/fs/xfs/xfs_dir2.c
> +++ b/fs/xfs/xfs_dir2.c
> @@ -85,11 +85,12 @@ static struct xfs_nameops xfs_ascii_ci_nameops = {
>  	.compname	= xfs_ascii_ci_compname,
>  };
>  
> -void
> -xfs_dir_mount(
> +int
> +xfs_da_mount(
>  	xfs_mount_t	*mp)
>  {
> -	int	nodehdr_size;
> +	struct xfs_da_geometry	*dageo;
> +	int			nodehdr_size;
>  
>  
>  	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
> @@ -99,24 +100,56 @@ xfs_dir_mount(
>  	mp->m_dir_inode_ops = xfs_dir_get_ops(mp, NULL);
>  	mp->m_nondir_inode_ops = xfs_nondir_get_ops(mp, NULL);
>  
> -	mp->m_dirblksize = 1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog);
> -	mp->m_dirblkfsbs = 1 << mp->m_sb.sb_dirblklog;
> -	mp->m_dirdatablk = xfs_dir2_db_to_da(mp, XFS_DIR2_DATA_FIRSTDB(mp));
> -	mp->m_dirleafblk = xfs_dir2_db_to_da(mp, XFS_DIR2_LEAF_FIRSTDB(mp));
> -	mp->m_dirfreeblk = xfs_dir2_db_to_da(mp, XFS_DIR2_FREE_FIRSTDB(mp));
> -
>  	nodehdr_size = mp->m_dir_inode_ops->node_hdr_size;
> -	mp->m_attr_node_ents = (mp->m_sb.sb_blocksize - nodehdr_size) /
> +	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> +				    KM_SLEEP | KM_MAYFAIL);
> +	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> +				     KM_SLEEP | KM_MAYFAIL);
> +	if (!mp->m_dir_geo || !mp->m_attr_geo) {
> +		kmem_free(mp->m_dir_geo);
> +		kmem_free(mp->m_attr_geo);
> +		return ENOMEM;
> +	}

While it looks like everything is handled correctly here, I think this
would be much cleaner if we just created a set of xfs_mount_alloc/free()
helpers that did all of the allocations at once. Then we wouldn't have a
situation where the caller has non-obvious memory allocations to clean
up should it fail sometime after calling xfs_da_mount().

Brian

> +
> +	/* set up directory geometry */
> +	dageo = mp->m_dir_geo;
> +	dageo->blklog = mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog;
> +	dageo->fsblog = mp->m_sb.sb_blocklog;
> +	dageo->blksize = 1 << dageo->blklog;
> +	dageo->fsbcount = 1 << mp->m_sb.sb_dirblklog;
> +	dageo->datablk = xfs_dir2_byte_to_da(mp, XFS_DIR2_DATA_OFFSET);
> +	dageo->leafblk = xfs_dir2_byte_to_da(mp, XFS_DIR2_LEAF_OFFSET);
> +	dageo->freeblk = xfs_dir2_byte_to_da(mp, XFS_DIR2_FREE_OFFSET);
> +	dageo->node_ents = (dageo->blksize - nodehdr_size) /
>  				(uint)sizeof(xfs_da_node_entry_t);
> -	mp->m_dir_node_ents = (mp->m_dirblksize - nodehdr_size) /
> +	dageo->magicpct = (dageo->blksize * 37) / 100;
> +
> +	/* set up attribute geometry - single fsb only */
> +	dageo = mp->m_attr_geo;
> +	dageo->blklog = mp->m_sb.sb_blocklog;
> +	dageo->fsblog = mp->m_sb.sb_blocklog;
> +	dageo->blksize = 1 << dageo->blklog;
> +	dageo->fsbcount = 1;
> +	dageo->node_ents = (dageo->blksize - nodehdr_size) /
>  				(uint)sizeof(xfs_da_node_entry_t);
> +	dageo->magicpct = (dageo->blksize * 37) / 100;
>  
> -	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
>  	if (xfs_sb_version_hasasciici(&mp->m_sb))
>  		mp->m_dirnameops = &xfs_ascii_ci_nameops;
>  	else
>  		mp->m_dirnameops = &xfs_default_nameops;
>  
> +	/* XXX: these are to be removed as code is converted to use geo */
> +	mp->m_dirblksize = mp->m_dir_geo->blksize;
> +	mp->m_dirblkfsbs = mp->m_dir_geo->fsbcount;
> +	mp->m_dirdatablk = mp->m_dir_geo->datablk;
> +	mp->m_dirleafblk = mp->m_dir_geo->leafblk;
> +	mp->m_dirfreeblk = mp->m_dir_geo->freeblk;
> +	mp->m_dir_node_ents = mp->m_dir_geo->node_ents;
> +	mp->m_dir_magicpct = mp->m_dir_geo->magicpct;
> +	mp->m_attr_node_ents = mp->m_attr_geo->node_ents;
> +	mp->m_attr_magicpct = mp->m_attr_geo->magicpct;
> +	return 0;
>  }
>  
>  /*
> @@ -192,6 +225,7 @@ xfs_dir_init(
>  	if (!args)
>  		return ENOMEM;
>  
> +	args->geo = dp->i_mount->m_dir_geo;
>  	args->dp = dp;
>  	args->trans = tp;
>  	error = xfs_dir2_sf_create(args, pdp->i_ino);
> @@ -226,6 +260,7 @@ xfs_dir_createname(
>  	if (!args)
>  		return ENOMEM;
>  
> +	args->geo = dp->i_mount->m_dir_geo;
>  	args->name = name->name;
>  	args->namelen = name->len;
>  	args->filetype = name->type;
> @@ -320,6 +355,7 @@ xfs_dir_lookup(
>  	 * annotations into the reclaim path for the ilock.
>  	 */
>  	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
> +	args->geo = dp->i_mount->m_dir_geo;
>  	args->name = name->name;
>  	args->namelen = name->len;
>  	args->filetype = name->type;
> @@ -391,6 +427,7 @@ xfs_dir_removename(
>  	if (!args)
>  		return ENOMEM;
>  
> +	args->geo = dp->i_mount->m_dir_geo;
>  	args->name = name->name;
>  	args->namelen = name->len;
>  	args->filetype = name->type;
> @@ -455,6 +492,7 @@ xfs_dir_replace(
>  	if (!args)
>  		return ENOMEM;
>  
> +	args->geo = dp->i_mount->m_dir_geo;
>  	args->name = name->name;
>  	args->namelen = name->len;
>  	args->filetype = name->type;
> @@ -516,6 +554,7 @@ xfs_dir_canenter(
>  	if (!args)
>  		return ENOMEM;
>  
> +	args->geo = dp->i_mount->m_dir_geo;
>  	args->name = name->name;
>  	args->namelen = name->len;
>  	args->filetype = name->type;
> diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
> index 64a6b19..7b09ef0 100644
> --- a/fs/xfs/xfs_dir2.h
> +++ b/fs/xfs/xfs_dir2.h
> @@ -112,7 +112,7 @@ extern const struct xfs_dir_ops *
>   * Generic directory interface routines
>   */
>  extern void xfs_dir_startup(void);
> -extern void xfs_dir_mount(struct xfs_mount *mp);
> +extern int xfs_da_mount(struct xfs_mount *mp);
>  extern int xfs_dir_isempty(struct xfs_inode *dp);
>  extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_inode *pdp);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 8dbd718..8d1afb8 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -784,12 +784,11 @@ xfs_mountfs(
>  
>  	mp->m_dmevmask = 0;	/* not persistent; set after each mount */
>  
> -	xfs_dir_mount(mp);
> -
> -	/*
> -	 * Initialize the attribute manager's entries.
> -	 */
> -	mp->m_attr_magicpct = (mp->m_sb.sb_blocksize * 37) / 100;
> +	error = xfs_da_mount(mp);
> +	if (error) {
> +		xfs_warn(mp, "Failed dir/attr init: %d", error);
> +		goto out_remove_uuid;
> +	}
>  
>  	/*
>  	 * Initialize the precomputed transaction reservations values.
> @@ -804,7 +803,7 @@ xfs_mountfs(
>  	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
>  	if (error) {
>  		xfs_warn(mp, "Failed per-ag init: %d", error);
> -		goto out_remove_uuid;
> +		goto out_free_dir;
>  	}
>  
>  	if (!sbp->sb_logblocks) {
> @@ -986,6 +985,9 @@ xfs_mountfs(
>  	xfs_wait_buftarg(mp->m_ddev_targp);
>   out_free_perag:
>  	xfs_free_perag(mp);
> + out_free_dir:
> +	kmem_free(mp->m_dir_geo);
> +	kmem_free(mp->m_attr_geo);
>   out_remove_uuid:
>  	xfs_uuid_unmount(mp);
>   out:
> @@ -1072,6 +1074,8 @@ xfs_unmountfs(
>  #if defined(DEBUG)
>  	xfs_errortag_clearall(mp, 0);
>  #endif
> +	kmem_free(mp->m_dir_geo);
> +	kmem_free(mp->m_attr_geo);
>  	xfs_free_perag(mp);
>  }
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index b7f1cfb..01b25e41 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -27,6 +27,7 @@ struct xfs_nameops;
>  struct xfs_ail;
>  struct xfs_quotainfo;
>  struct xfs_dir_ops;
> +struct xfs_da_geometry;
>  
>  #ifdef HAVE_PERCPU_SB
>  
> @@ -96,6 +97,8 @@ typedef struct xfs_mount {
>  	uint			m_readio_blocks; /* min read size blocks */
>  	uint			m_writeio_log;	/* min write size log bytes */
>  	uint			m_writeio_blocks; /* min write size blocks */
> +	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
> +	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
>  	struct xlog		*m_log;		/* log specific stuff */
>  	int			m_logbufs;	/* number of log buffers */
>  	int			m_logbsize;	/* size of each log buffer */
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
