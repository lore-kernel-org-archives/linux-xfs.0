Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E9C47F3F
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 14:05:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F15A830406B
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 12:05:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IVAmn6w8oYswovrt for
	<xfs@oss.sgi.com>; Fri, 23 May 2014 12:05:39 -0700 (PDT)
Date: Fri, 23 May 2014 15:05:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/16] xfs: convert dir byte/off conversion to
	xfs_da_geometry
Message-ID: <20140523190536.GE8343@laptop.bfoster>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400803432-20048-5-git-send-email-david@fromorbit.com>
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

On Fri, May 23, 2014 at 10:03:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_da_btree.h     | 18 +++++++++---------
>  fs/xfs/xfs_dir2.c         |  2 +-
>  fs/xfs/xfs_dir2_readdir.c |  7 ++++---
>  3 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
> index 6d13fd6..e9496a9 100644
> --- a/fs/xfs/xfs_da_btree.h
> +++ b/fs/xfs/xfs_da_btree.h
> @@ -204,10 +204,9 @@ xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
>   * Convert byte in space to offset in a block
>   */
>  static inline xfs_dir2_data_aoff_t
> -xfs_dir2_byte_to_off(struct xfs_mount *mp, xfs_dir2_off_t by)
> +xfs_dir2_byte_to_off(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
>  {
> -	return (xfs_dir2_data_aoff_t)(by &
> -		((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) - 1));
> +	return (xfs_dir2_data_aoff_t)(by & (geo->blksize - 1));
>  }
>  
>  /*
> @@ -216,18 +215,17 @@ xfs_dir2_byte_to_off(struct xfs_mount *mp, xfs_dir2_off_t by)
>  static inline xfs_dir2_data_aoff_t
>  xfs_dir2_dataptr_to_off(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
>  {
> -	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(dp));
> +	return xfs_dir2_byte_to_off(mp->m_dir_geo, xfs_dir2_dataptr_to_byte(dp));
>  }
>  
>  /*
>   * Convert block and offset to byte in space
>   */
>  static inline xfs_dir2_off_t
> -xfs_dir2_db_off_to_byte(struct xfs_mount *mp, xfs_dir2_db_t db,
> +xfs_dir2_db_off_to_byte(struct xfs_da_geometry *geo, xfs_dir2_db_t db,
>  			xfs_dir2_data_aoff_t o)
>  {
> -	return ((xfs_dir2_off_t)db <<
> -		(mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) + o;
> +	return ((xfs_dir2_off_t)db << geo->blklog) + o;
>  }
>  
>  /*
> @@ -255,7 +253,8 @@ static inline xfs_dir2_dataptr_t
>  xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
>  			   xfs_dir2_data_aoff_t o)
>  {
> -	return xfs_dir2_byte_to_dataptr(xfs_dir2_db_off_to_byte(mp, db, o));
> +	return xfs_dir2_byte_to_dataptr(
> +				xfs_dir2_db_off_to_byte(mp->m_dir_geo, db, o));
>  }
>  
>  /*
> @@ -273,7 +272,8 @@ xfs_dir2_da_to_db(struct xfs_mount *mp, xfs_dablk_t da)
>  static inline xfs_dir2_off_t
>  xfs_dir2_da_to_byte(struct xfs_mount *mp, xfs_dablk_t da)
>  {
> -	return xfs_dir2_db_off_to_byte(mp, xfs_dir2_da_to_db(mp, da), 0);
> +	return xfs_dir2_db_off_to_byte(mp->m_dir_geo,
> +				       xfs_dir2_da_to_db(mp, da), 0);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
> index 1268dae..a7d3884 100644
> --- a/fs/xfs/xfs_dir2.c
> +++ b/fs/xfs/xfs_dir2.c
> @@ -741,7 +741,7 @@ xfs_dir2_shrink_inode(
>  	/*
>  	 * If the block isn't the last one in the directory, we're done.
>  	 */
> -	if (dp->i_d.di_size > xfs_dir2_db_off_to_byte(mp, db + 1, 0))
> +	if (dp->i_d.di_size > xfs_dir2_db_off_to_byte(args->geo, db + 1, 0))
>  		return 0;
>  	bno = da;
>  	if ((error = xfs_bmap_last_before(tp, dp, &bno, XFS_DATA_FORK))) {
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index bf7a5ce..ec912c8 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -560,7 +560,8 @@ xfs_dir2_leaf_getdents(
>  			/*
>  			 * Having done a read, we need to set a new offset.
>  			 */
> -			newoff = xfs_dir2_db_off_to_byte(mp, map_info->curdb, 0);
> +			newoff = xfs_dir2_db_off_to_byte(mp->m_dir_geo,
> +							 map_info->curdb, 0);
>  			/*
>  			 * Start of the current block.
>  			 */
> @@ -578,7 +579,7 @@ xfs_dir2_leaf_getdents(
>  			 * Find our position in the block.
>  			 */
>  			ptr = (char *)dp->d_ops->data_entry_p(hdr);
> -			byteoff = xfs_dir2_byte_to_off(mp, curoff);
> +			byteoff = xfs_dir2_byte_to_off(mp->m_dir_geo, curoff);
>  			/*
>  			 * Skip past the header.
>  			 */
> @@ -607,7 +608,7 @@ xfs_dir2_leaf_getdents(
>  				 * Now set our real offset.
>  				 */
>  				curoff =
> -					xfs_dir2_db_off_to_byte(mp,
> +					xfs_dir2_db_off_to_byte(mp->m_dir_geo,
>  					    xfs_dir2_byte_to_db(mp, curoff),
>  					    (char *)ptr - (char *)hdr);
>  				if (ptr >= (char *)hdr + mp->m_dirblksize) {
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
