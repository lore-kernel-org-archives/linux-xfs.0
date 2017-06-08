Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbdFHNCe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 09:02:34 -0400
Date: Thu, 8 Jun 2017 09:02:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/13] xfs: pass along transaction context when reading
 directory block buffers
Message-ID: <20170608130230.GB5244@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643871474.23065.12129624430660182688.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643871474.23065.12129624430660182688.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2017 at 02:25:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach the directory reading functions to pass along a transaction context
> if one was supplied.  The directory scrub code will use transactions to
> lock buffers and avoid deadlocking with itself in the case of loops.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_dir2_priv.h |    4 ++--
>  fs/xfs/xfs_dir2_readdir.c     |   15 +++++++++++----
>  fs/xfs/xfs_file.c             |    2 +-
>  3 files changed, 14 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index c09bca1..cb679cf 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -132,7 +132,7 @@ extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
>  extern int xfs_dir2_sf_verify(struct xfs_inode *ip);
>  
>  /* xfs_dir2_readdir.c */
> -extern int xfs_readdir(struct xfs_inode *dp, struct dir_context *ctx,
> -		       size_t bufsize);
> +extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
> +		       struct dir_context *ctx, size_t bufsize);
>  
>  #endif /* __XFS_DIR2_PRIV_H__ */
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index ede4790..ba2638d 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -170,7 +170,7 @@ xfs_dir2_block_getdents(
>  		return 0;
>  
>  	lock_mode = xfs_ilock_data_map_shared(dp);
> -	error = xfs_dir3_block_read(NULL, dp, &bp);
> +	error = xfs_dir3_block_read(args->trans, dp, &bp);
>  	xfs_iunlock(dp, lock_mode);
>  	if (error)
>  		return error;
> @@ -228,7 +228,7 @@ xfs_dir2_block_getdents(
>  		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
>  			    be64_to_cpu(dep->inumber),
>  			    xfs_dir3_get_dtype(dp->i_mount, filetype))) {
> -			xfs_trans_brelse(NULL, bp);
> +			xfs_trans_brelse(args->trans, bp);
>  			return 0;
>  		}
>  	}
> @@ -239,7 +239,7 @@ xfs_dir2_block_getdents(
>  	 */
>  	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
>  								0x7fffffff;
> -	xfs_trans_brelse(NULL, bp);
> +	xfs_trans_brelse(args->trans, bp);
>  	return 0;
>  }
>  
> @@ -495,15 +495,21 @@ xfs_dir2_leaf_getdents(
>  	else
>  		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
>  	if (bp)
> -		xfs_trans_brelse(NULL, bp);
> +		xfs_trans_brelse(args->trans, bp);
>  	return error;
>  }
>  
>  /*
>   * Read a directory.
> + *
> + * If supplied, the transaction collects locked dir buffers to avoid
> + * nested buffer deadlocks.  This function does not dirty the
> + * transaction.  The caller should ensure that the inode is locked
> + * before calling this function.
>   */
>  int
>  xfs_readdir(
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	struct dir_context	*ctx,
>  	size_t			bufsize)
> @@ -522,6 +528,7 @@ xfs_readdir(
>  
>  	args.dp = dp;
>  	args.geo = dp->i_mount->m_dir_geo;
> +	args.trans = tp;
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>  		rval = xfs_dir2_sf_getdents(&args, ctx);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5fb5a09..36c1293 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -950,7 +950,7 @@ xfs_file_readdir(
>  	 */
>  	bufsize = (size_t)min_t(loff_t, 32768, ip->i_d.di_size);
>  
> -	return xfs_readdir(ip, ctx, bufsize);
> +	return xfs_readdir(NULL, ip, ctx, bufsize);
>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
