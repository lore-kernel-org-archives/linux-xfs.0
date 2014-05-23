Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E428E7F3F
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 14:05:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A851AC006
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 12:05:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IrUiFmwk73ivAPja for
	<xfs@oss.sgi.com>; Fri, 23 May 2014 12:05:22 -0700 (PDT)
Date: Fri, 23 May 2014 15:05:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/16] xfs: move directory block translatiosn to
	xfs_da_btree.h
Message-ID: <20140523190518.GC8343@laptop.bfoster>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400803432-20048-3-git-send-email-david@fromorbit.com>
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

On Fri, May 23, 2014 at 10:03:38AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because they aren't actually part of the on-disk format, and so
> shouldn't be in xfs_da_format.h.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks straightforward.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_da_btree.h  | 137 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_da_format.c |   1 +
>  fs/xfs/xfs_da_format.h | 138 -------------------------------------------------
>  3 files changed, 138 insertions(+), 138 deletions(-)
> 
> diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
> index 0ac63ad..6d13fd6 100644
> --- a/fs/xfs/xfs_da_btree.h
> +++ b/fs/xfs/xfs_da_btree.h
> @@ -157,6 +157,143 @@ struct xfs_nameops {
>  };
>  
>  
> +/*
> + * Directory offset/block conversion functions.
> + *
> + * DB blocks here are logical directory block numbers, not filesystem blocks.
> + */
> +
> +/*
> + * Convert dataptr to byte in file space
> + */
> +static inline xfs_dir2_off_t
> +xfs_dir2_dataptr_to_byte(xfs_dir2_dataptr_t dp)
> +{
> +	return (xfs_dir2_off_t)dp << XFS_DIR2_DATA_ALIGN_LOG;
> +}
> +
> +/*
> + * Convert byte in file space to dataptr.  It had better be aligned.
> + */
> +static inline xfs_dir2_dataptr_t
> +xfs_dir2_byte_to_dataptr(xfs_dir2_off_t by)
> +{
> +	return (xfs_dir2_dataptr_t)(by >> XFS_DIR2_DATA_ALIGN_LOG);
> +}
> +
> +/*
> + * Convert byte in space to (DB) block
> + */
> +static inline xfs_dir2_db_t
> +xfs_dir2_byte_to_db(struct xfs_mount *mp, xfs_dir2_off_t by)
> +{
> +	return (xfs_dir2_db_t)
> +		(by >> (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog));
> +}
> +
> +/*
> + * Convert dataptr to a block number
> + */
> +static inline xfs_dir2_db_t
> +xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
> +{
> +	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(dp));
> +}
> +
> +/*
> + * Convert byte in space to offset in a block
> + */
> +static inline xfs_dir2_data_aoff_t
> +xfs_dir2_byte_to_off(struct xfs_mount *mp, xfs_dir2_off_t by)
> +{
> +	return (xfs_dir2_data_aoff_t)(by &
> +		((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) - 1));
> +}
> +
> +/*
> + * Convert dataptr to a byte offset in a block
> + */
> +static inline xfs_dir2_data_aoff_t
> +xfs_dir2_dataptr_to_off(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
> +{
> +	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(dp));
> +}
> +
> +/*
> + * Convert block and offset to byte in space
> + */
> +static inline xfs_dir2_off_t
> +xfs_dir2_db_off_to_byte(struct xfs_mount *mp, xfs_dir2_db_t db,
> +			xfs_dir2_data_aoff_t o)
> +{
> +	return ((xfs_dir2_off_t)db <<
> +		(mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) + o;
> +}
> +
> +/*
> + * Convert block (DB) to block (dablk)
> + */
> +static inline xfs_dablk_t
> +xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
> +{
> +	return (xfs_dablk_t)(db << mp->m_sb.sb_dirblklog);
> +}
> +
> +/*
> + * Convert byte in space to (DA) block
> + */
> +static inline xfs_dablk_t
> +xfs_dir2_byte_to_da(struct xfs_mount *mp, xfs_dir2_off_t by)
> +{
> +	return xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, by));
> +}
> +
> +/*
> + * Convert block and offset to dataptr
> + */
> +static inline xfs_dir2_dataptr_t
> +xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
> +			   xfs_dir2_data_aoff_t o)
> +{
> +	return xfs_dir2_byte_to_dataptr(xfs_dir2_db_off_to_byte(mp, db, o));
> +}
> +
> +/*
> + * Convert block (dablk) to block (DB)
> + */
> +static inline xfs_dir2_db_t
> +xfs_dir2_da_to_db(struct xfs_mount *mp, xfs_dablk_t da)
> +{
> +	return (xfs_dir2_db_t)(da >> mp->m_sb.sb_dirblklog);
> +}
> +
> +/*
> + * Convert block (dablk) to byte offset in space
> + */
> +static inline xfs_dir2_off_t
> +xfs_dir2_da_to_byte(struct xfs_mount *mp, xfs_dablk_t da)
> +{
> +	return xfs_dir2_db_off_to_byte(mp, xfs_dir2_da_to_db(mp, da), 0);
> +}
> +
> +/*
> + * Directory tail pointer accessor functions. Based on block geometry.
> + */
> +static inline struct xfs_dir2_block_tail *
> +xfs_dir2_block_tail_p(struct xfs_mount *mp, struct xfs_dir2_data_hdr *hdr)
> +{
> +	return ((struct xfs_dir2_block_tail *)
> +		((char *)hdr + mp->m_dirblksize)) - 1;
> +}
> +
> +static inline struct xfs_dir2_leaf_tail *
> +xfs_dir2_leaf_tail_p(struct xfs_mount *mp, struct xfs_dir2_leaf *lp)
> +{
> +	return (struct xfs_dir2_leaf_tail *)
> +		((char *)lp + mp->m_dirblksize -
> +		  sizeof(struct xfs_dir2_leaf_tail));
> +}
> +
>  /*========================================================================
>   * Function prototypes.
>   *========================================================================*/
> diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
> index e6c83e1..22bbc79 100644
> --- a/fs/xfs/xfs_da_format.c
> +++ b/fs/xfs/xfs_da_format.c
> @@ -26,6 +26,7 @@
>  #include "xfs_ag.h"
>  #include "xfs_mount.h"
>  #include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_dir2.h"
>  
> diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
> index 1432b57..32b415c 100644
> --- a/fs/xfs/xfs_da_format.h
> +++ b/fs/xfs/xfs_da_format.h
> @@ -514,17 +514,6 @@ struct xfs_dir3_leaf {
>  #define XFS_DIR3_LEAF_CRC_OFF  offsetof(struct xfs_dir3_leaf_hdr, info.crc)
>  
>  /*
> - * Get address of the bestcount field in the single-leaf block.
> - */
> -static inline struct xfs_dir2_leaf_tail *
> -xfs_dir2_leaf_tail_p(struct xfs_mount *mp, struct xfs_dir2_leaf *lp)
> -{
> -	return (struct xfs_dir2_leaf_tail *)
> -		((char *)lp + mp->m_dirblksize -
> -		  sizeof(struct xfs_dir2_leaf_tail));
> -}
> -
> -/*
>   * Get address of the bests array in the single-leaf block.
>   */
>  static inline __be16 *
> @@ -534,123 +523,6 @@ xfs_dir2_leaf_bests_p(struct xfs_dir2_leaf_tail *ltp)
>  }
>  
>  /*
> - * DB blocks here are logical directory block numbers, not filesystem blocks.
> - */
> -
> -/*
> - * Convert dataptr to byte in file space
> - */
> -static inline xfs_dir2_off_t
> -xfs_dir2_dataptr_to_byte(xfs_dir2_dataptr_t dp)
> -{
> -	return (xfs_dir2_off_t)dp << XFS_DIR2_DATA_ALIGN_LOG;
> -}
> -
> -/*
> - * Convert byte in file space to dataptr.  It had better be aligned.
> - */
> -static inline xfs_dir2_dataptr_t
> -xfs_dir2_byte_to_dataptr(xfs_dir2_off_t by)
> -{
> -	return (xfs_dir2_dataptr_t)(by >> XFS_DIR2_DATA_ALIGN_LOG);
> -}
> -
> -/*
> - * Convert byte in space to (DB) block
> - */
> -static inline xfs_dir2_db_t
> -xfs_dir2_byte_to_db(struct xfs_mount *mp, xfs_dir2_off_t by)
> -{
> -	return (xfs_dir2_db_t)
> -		(by >> (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog));
> -}
> -
> -/*
> - * Convert dataptr to a block number
> - */
> -static inline xfs_dir2_db_t
> -xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
> -{
> -	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(dp));
> -}
> -
> -/*
> - * Convert byte in space to offset in a block
> - */
> -static inline xfs_dir2_data_aoff_t
> -xfs_dir2_byte_to_off(struct xfs_mount *mp, xfs_dir2_off_t by)
> -{
> -	return (xfs_dir2_data_aoff_t)(by &
> -		((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) - 1));
> -}
> -
> -/*
> - * Convert dataptr to a byte offset in a block
> - */
> -static inline xfs_dir2_data_aoff_t
> -xfs_dir2_dataptr_to_off(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
> -{
> -	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(dp));
> -}
> -
> -/*
> - * Convert block and offset to byte in space
> - */
> -static inline xfs_dir2_off_t
> -xfs_dir2_db_off_to_byte(struct xfs_mount *mp, xfs_dir2_db_t db,
> -			xfs_dir2_data_aoff_t o)
> -{
> -	return ((xfs_dir2_off_t)db <<
> -		(mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) + o;
> -}
> -
> -/*
> - * Convert block (DB) to block (dablk)
> - */
> -static inline xfs_dablk_t
> -xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
> -{
> -	return (xfs_dablk_t)(db << mp->m_sb.sb_dirblklog);
> -}
> -
> -/*
> - * Convert byte in space to (DA) block
> - */
> -static inline xfs_dablk_t
> -xfs_dir2_byte_to_da(struct xfs_mount *mp, xfs_dir2_off_t by)
> -{
> -	return xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, by));
> -}
> -
> -/*
> - * Convert block and offset to dataptr
> - */
> -static inline xfs_dir2_dataptr_t
> -xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
> -			   xfs_dir2_data_aoff_t o)
> -{
> -	return xfs_dir2_byte_to_dataptr(xfs_dir2_db_off_to_byte(mp, db, o));
> -}
> -
> -/*
> - * Convert block (dablk) to block (DB)
> - */
> -static inline xfs_dir2_db_t
> -xfs_dir2_da_to_db(struct xfs_mount *mp, xfs_dablk_t da)
> -{
> -	return (xfs_dir2_db_t)(da >> mp->m_sb.sb_dirblklog);
> -}
> -
> -/*
> - * Convert block (dablk) to byte offset in space
> - */
> -static inline xfs_dir2_off_t
> -xfs_dir2_da_to_byte(struct xfs_mount *mp, xfs_dablk_t da)
> -{
> -	return xfs_dir2_db_off_to_byte(mp, xfs_dir2_da_to_db(mp, da), 0);
> -}
> -
> -/*
>   * Free space block defintions for the node format.
>   */
>  
> @@ -736,16 +608,6 @@ typedef struct xfs_dir2_block_tail {
>  } xfs_dir2_block_tail_t;
>  
>  /*
> - * Pointer to the leaf header embedded in a data block (1-block format)
> - */
> -static inline struct xfs_dir2_block_tail *
> -xfs_dir2_block_tail_p(struct xfs_mount *mp, struct xfs_dir2_data_hdr *hdr)
> -{
> -	return ((struct xfs_dir2_block_tail *)
> -		((char *)hdr + mp->m_dirblksize)) - 1;
> -}
> -
> -/*
>   * Pointer to the leaf entries embedded in a data block (1-block format)
>   */
>  static inline struct xfs_dir2_leaf_entry *
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
