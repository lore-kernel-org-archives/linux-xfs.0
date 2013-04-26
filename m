Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B5BF7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 14:09:59 -0500 (CDT)
Date: Fri, 26 Apr 2013 14:09:53 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 19/22] xfs: add buffer types to directory and attribute
	buffers
Message-ID: <20130426190953.GH29359@sgi.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-20-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364965892-19623-20-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Wed, Apr 03, 2013 at 04:11:29PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add buffer types to the buffer log items so that log recovery can
> validate the buffers and calculate CRCs correctly after the buffers
> are recovered.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Comments below.

> diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
> index 2b7c9f6..a78865e 100644
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -292,7 +292,6 @@ const struct xfs_buf_ops xfs_da3_node_buf_ops = {
>  	.verify_write = xfs_da3_node_write_verify,
>  };
>  
> -
>  int
>  xfs_da3_node_read(
>  	struct xfs_trans	*tp,
> @@ -302,8 +301,35 @@ xfs_da3_node_read(
>  	struct xfs_buf		**bpp,
>  	int			which_fork)
>  {
> -	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
> +	int			err;
> +
> +	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
>  					which_fork, &xfs_da3_node_buf_ops);
> +	if (!err && tp) {
> +		struct xfs_da_blkinfo	*info = (*bpp)->b_addr;
> +		int			type;
> +
> +		switch (be16_to_cpu(info->magic)) {
> +		case XFS_DA3_NODE_MAGIC:
> +		case XFS_DA_NODE_MAGIC:

Nit:  
		case XFS_DA_NODE_MAGIC:
		case XFS_DA3_NODE_MAGIC:


> +			type = XFS_BLF_DA_NODE_BUF;
> +			break;
> +		case XFS_ATTR_LEAF_MAGIC:
> +		case XFS_ATTR3_LEAF_MAGIC:
> +			type = XFS_BLF_ATTR_LEAF_BUF;
> +			break;
> +		case XFS_DIR2_LEAFN_MAGIC:
> +		case XFS_DIR3_LEAFN_MAGIC:
> +			type = XFS_BLF_DIR_LEAFN_BUF;
> +			break;
> +		default:
> +			type = 0;
> +			ASSERT(0);
> +			break;

Would some kind of shutdown be desireable here?  Maybe not.

> @@ -2004,19 +1960,169 @@ xlog_recover_do_reg_buffer(
>  		bp->b_ops = &xfs_inode_buf_ops;
>  		break;
>  	case XFS_BLF_SYMLINK_BUF:
> -		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_SYMLINK_MAGIC)) {
> +		if (magic32 != XFS_SYMLINK_MAGIC) {
>  			xfs_warn(mp, "Bad symlink block magic!");
>  			ASSERT(0);
>  			break;
>  		}
>  		bp->b_ops = &xfs_symlink_buf_ops;
>  		break;

...

> +	case XFS_BLF_ATTR_RMT_BUF:
> +		if (!xfs_sb_version_hascrc(&mp->m_sb))
> +			break;
> +		if (magicda != XFS_ATTR3_RMT_MAGIC) {
		    magic32

The new remote attribute header has magic at offset 0.

> +STATIC void
> +xlog_recover_do_reg_buffer(
> +	struct xfs_mount	*mp,
> +	xlog_recover_item_t	*item,
> +	struct xfs_buf		*bp,
> +	xfs_buf_log_format_t	*buf_f)
> +{

...

> +	/* Shouldn't be any more regions */
> +	ASSERT(i == item->ri_total);
> +
> +	xlog_recovery_validate_buf_type(mp, bp, buf_f);
> +

Extra line.


Looks good.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
