Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0893B7F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 17:23:05 -0500 (CDT)
Date: Wed, 24 Jul 2013 17:23:05 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 11/48] xfs: add CRC checking to dir2 data blocks
Message-ID: <20130724222305.GT3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-12-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:34AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This addition follows the same pattern as the dir2 block CRCs.
>

Corresponds to 33363feed16.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

...

> diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
> index c79199a..18eabd1 100644
> --- a/libxfs/xfs_dir2_block.c
> +++ b/libxfs/xfs_dir2_block.c
> @@ -59,7 +59,7 @@ xfs_dir3_block_verify(
>  		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
>  			return false;
>  	}
> -	if (__xfs_dir2_data_check(NULL, bp))
> +	if (__xfs_dir3_data_check(NULL, bp))
>  		return false;
>  	return true;
>  }
> @@ -535,7 +535,7 @@ xfs_dir2_block_addname(
>  		xfs_dir2_data_log_header(tp, bp);
>  	xfs_dir2_block_log_tail(tp, bp);
>  	xfs_dir2_data_log_entry(tp, bp, dep);
> -	xfs_dir2_data_check(dp, bp);
> +	xfs_dir3_data_check(dp, bp);
>  	return 0;
>  }

Changes to xfs_dir2_block_getdents in the kernel are not included here.  Again,
it seems that we don't have this function in userspace.

> diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
> index 66aab07..69841df 100644
> --- a/libxfs/xfs_dir2_data.c
> +++ b/libxfs/xfs_dir2_data.c
> @@ -25,7 +25,7 @@
>   * Return 0 is the buffer is good, otherwise an error.
>   */
>  int
> -__xfs_dir2_data_check(
> +__xfs_dir3_data_check(
>  	struct xfs_inode	*dp,		/* incore inode pointer */
>  	struct xfs_buf		*bp)		/* data block's buffer */
>  {
> @@ -61,6 +61,7 @@ __xfs_dir2_data_check(
>  		endp = (char *)lep;
>  		break;
>  	case XFS_DIR2_DATA_MAGIC:
> +	case XFS_DIR3_DATA_MAGIC:

The endian swap was done in the switch parens in the kernel

> @@ -196,7 +203,7 @@ xfs_dir2_data_verify(
>   * format buffer or a data format buffer on readahead.
>   */
>  static void
> -xfs_dir2_data_reada_verify(
> +xfs_dir3_data_reada_verify(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -209,7 +216,8 @@ xfs_dir2_data_reada_verify(
>  		bp->b_ops->verify_read(bp);
>  		return;
>  	case XFS_DIR2_DATA_MAGIC:
> -		xfs_dir2_data_verify(bp);
> +	case XFS_DIR3_DATA_MAGIC:
> +		xfs_dir3_data_verify(bp);

Also here the endian swap was done differently in the kernel.

> diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
> index a1df347..0f848b4 100644
> --- a/libxfs/xfs_dir2_leaf.c
> +++ b/libxfs/xfs_dir2_leaf.c
> @@ -369,6 +373,7 @@ xfs_dir2_leaf_addname(
>  	__be16			*tagp;		/* end of data entry */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	xfs_dir2_db_t		use_block;	/* data block number */
> +	struct xfs_dir2_data_free *bf;		/* bestfree table */
>  
>  	trace_xfs_dir2_leaf_addname(args);

Seem to be missing changes to xfs_dir2_leaf_readbuf, which we don't have in
userspace...

Looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
