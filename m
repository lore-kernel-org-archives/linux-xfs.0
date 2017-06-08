Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbdFHNCm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 09:02:42 -0400
Date: Thu, 8 Jun 2017 09:02:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 13/13] xfs: pass along transaction context when reading
 xattr block buffers
Message-ID: <20170608130238.GC5244@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643872077.23065.18432527054896718134.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643872077.23065.18432527054896718134.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2017 at 02:25:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach the extended attribute reading functions to pass along a
> transaction context if one was supplied.  The extended attribute scrub
> code will use transactions to lock buffers and avoid deadlocking with
> itself in the case of loops; since it will already have the inode
> locked, also create xattr get/list helpers that don't take locks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c        |   26 ++++++++++++-----
>  fs/xfs/libxfs/xfs_attr_remote.c |    5 ++-
>  fs/xfs/xfs_attr.h               |    3 ++
>  fs/xfs/xfs_attr_list.c          |   59 ++++++++++++++++++++++-----------------
>  4 files changed, 57 insertions(+), 36 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6622d46..ef8a1c7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -114,6 +114,23 @@ xfs_inode_hasattr(
>   * Overall external interface routines.
>   *========================================================================*/
>  
> +/* Retrieve an extended attribute and its value.  Must have iolock. */
> +int
> +xfs_attr_get_ilocked(
> +	struct xfs_inode	*ip,
> +	struct xfs_da_args	*args)
> +{
> +	if (!xfs_inode_hasattr(ip))
> +		return -ENOATTR;
> +	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
> +		return xfs_attr_shortform_getvalue(args);
> +	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
> +		return xfs_attr_leaf_get(args);
> +	else
> +		return xfs_attr_node_get(args);
> +}
> +
> +/* Retrieve an extended attribute by name, and its value. */
>  int
>  xfs_attr_get(
>  	struct xfs_inode	*ip,
> @@ -141,14 +158,7 @@ xfs_attr_get(
>  	args.op_flags = XFS_DA_OP_OKNOENT;
>  
>  	lock_mode = xfs_ilock_attr_map_shared(ip);
> -	if (!xfs_inode_hasattr(ip))
> -		error = -ENOATTR;
> -	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
> -		error = xfs_attr_shortform_getvalue(&args);
> -	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
> -		error = xfs_attr_leaf_get(&args);
> -	else
> -		error = xfs_attr_node_get(&args);
> +	error = xfs_attr_get_ilocked(ip, &args);
>  	xfs_iunlock(ip, lock_mode);
>  
>  	*valuelenp = args.valuelen;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index da72b16..5236d8e 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -386,7 +386,8 @@ xfs_attr_rmtval_get(
>  			       (map[i].br_startblock != HOLESTARTBLOCK));
>  			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
>  			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
> -			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> +			error = xfs_trans_read_buf(mp, args->trans,
> +						   mp->m_ddev_targp,
>  						   dblkno, dblkcnt, 0, &bp,
>  						   &xfs_attr3_rmt_buf_ops);
>  			if (error)
> @@ -395,7 +396,7 @@ xfs_attr_rmtval_get(
>  			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
>  							&offset, &valuelen,
>  							&dst);
> -			xfs_buf_relse(bp);
> +			xfs_trans_brelse(args->trans, bp);
>  			if (error)
>  				return error;
>  
> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
> index d14691a..5d5a5e2 100644
> --- a/fs/xfs/xfs_attr.h
> +++ b/fs/xfs/xfs_attr.h
> @@ -117,6 +117,7 @@ typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
>  			      unsigned char *, int, int);
>  
>  typedef struct xfs_attr_list_context {
> +	struct xfs_trans		*tp;
>  	struct xfs_inode		*dp;		/* inode */
>  	struct attrlist_cursor_kern	*cursor;	/* position in list */
>  	char				*alist;		/* output buffer */
> @@ -140,8 +141,10 @@ typedef struct xfs_attr_list_context {
>   * Overall external interface routines.
>   */
>  int xfs_attr_inactive(struct xfs_inode *dp);
> +int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
>  int xfs_attr_list_int(struct xfs_attr_list_context *);
>  int xfs_inode_hasattr(struct xfs_inode *ip);
> +int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>  		 unsigned char *value, int *valuelenp, int flags);
>  int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 9bc1e12..545eca5 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -230,7 +230,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
>  	 */
>  	bp = NULL;
>  	if (cursor->blkno > 0) {
> -		error = xfs_da3_node_read(NULL, dp, cursor->blkno, -1,
> +		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, -1,
>  					      &bp, XFS_ATTR_FORK);
>  		if ((error != 0) && (error != -EFSCORRUPTED))
>  			return error;
> @@ -242,7 +242,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
>  			case XFS_DA_NODE_MAGIC:
>  			case XFS_DA3_NODE_MAGIC:
>  				trace_xfs_attr_list_wrong_blk(context);
> -				xfs_trans_brelse(NULL, bp);
> +				xfs_trans_brelse(context->tp, bp);
>  				bp = NULL;
>  				break;
>  			case XFS_ATTR_LEAF_MAGIC:
> @@ -254,18 +254,18 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
>  				if (cursor->hashval > be32_to_cpu(
>  						entries[leafhdr.count - 1].hashval)) {
>  					trace_xfs_attr_list_wrong_blk(context);
> -					xfs_trans_brelse(NULL, bp);
> +					xfs_trans_brelse(context->tp, bp);
>  					bp = NULL;
>  				} else if (cursor->hashval <= be32_to_cpu(
>  						entries[0].hashval)) {
>  					trace_xfs_attr_list_wrong_blk(context);
> -					xfs_trans_brelse(NULL, bp);
> +					xfs_trans_brelse(context->tp, bp);
>  					bp = NULL;
>  				}
>  				break;
>  			default:
>  				trace_xfs_attr_list_wrong_blk(context);
> -				xfs_trans_brelse(NULL, bp);
> +				xfs_trans_brelse(context->tp, bp);
>  				bp = NULL;
>  			}
>  		}
> @@ -281,7 +281,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
>  		for (;;) {
>  			uint16_t magic;
>  
> -			error = xfs_da3_node_read(NULL, dp,
> +			error = xfs_da3_node_read(context->tp, dp,
>  						      cursor->blkno, -1, &bp,
>  						      XFS_ATTR_FORK);
>  			if (error)
> @@ -297,7 +297,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
>  						     XFS_ERRLEVEL_LOW,
>  						     context->dp->i_mount,
>  						     node);
> -				xfs_trans_brelse(NULL, bp);
> +				xfs_trans_brelse(context->tp, bp);
>  				return -EFSCORRUPTED;
>  			}
>  
> @@ -313,10 +313,10 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
>  				}
>  			}
>  			if (i == nodehdr.count) {
> -				xfs_trans_brelse(NULL, bp);
> +				xfs_trans_brelse(context->tp, bp);
>  				return 0;
>  			}
> -			xfs_trans_brelse(NULL, bp);
> +			xfs_trans_brelse(context->tp, bp);
>  		}
>  	}
>  	ASSERT(bp != NULL);
> @@ -333,12 +333,12 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
>  		if (context->seen_enough || leafhdr.forw == 0)
>  			break;
>  		cursor->blkno = leafhdr.forw;
> -		xfs_trans_brelse(NULL, bp);
> -		error = xfs_attr3_leaf_read(NULL, dp, cursor->blkno, -1, &bp);
> +		xfs_trans_brelse(context->tp, bp);
> +		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno, -1, &bp);
>  		if (error)
>  			return error;
>  	}
> -	xfs_trans_brelse(NULL, bp);
> +	xfs_trans_brelse(context->tp, bp);
>  	return 0;
>  }
>  
> @@ -448,16 +448,34 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
>  	trace_xfs_attr_leaf_list(context);
>  
>  	context->cursor->blkno = 0;
> -	error = xfs_attr3_leaf_read(NULL, context->dp, 0, -1, &bp);
> +	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, -1, &bp);
>  	if (error)
>  		return error;
>  
>  	xfs_attr3_leaf_list_int(bp, context);
> -	xfs_trans_brelse(NULL, bp);
> +	xfs_trans_brelse(context->tp, bp);
>  	return 0;
>  }
>  
>  int
> +xfs_attr_list_int_ilocked(
> +	struct xfs_attr_list_context	*context)
> +{
> +	struct xfs_inode		*dp = context->dp;
> +
> +	/*
> +	 * Decide on what work routines to call based on the inode size.
> +	 */
> +	if (!xfs_inode_hasattr(dp))
> +		return 0;
> +	else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
> +		return xfs_attr_shortform_list(context);
> +	else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +		return xfs_attr_leaf_list(context);
> +	return xfs_attr_node_list(context);
> +}
> +
> +int
>  xfs_attr_list_int(
>  	xfs_attr_list_context_t *context)
>  {
> @@ -470,19 +488,8 @@ xfs_attr_list_int(
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
>  
> -	/*
> -	 * Decide on what work routines to call based on the inode size.
> -	 */
>  	lock_mode = xfs_ilock_attr_map_shared(dp);
> -	if (!xfs_inode_hasattr(dp)) {
> -		error = 0;
> -	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> -		error = xfs_attr_shortform_list(context);
> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_list(context);
> -	} else {
> -		error = xfs_attr_node_list(context);
> -	}
> +	error = xfs_attr_list_int_ilocked(context);
>  	xfs_iunlock(dp, lock_mode);
>  	return error;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
