Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB2NnqxB025425 for <xfs@oss.sgi.com>; Sun, 2 Dec 2012 17:49:52 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kwI3jMiunGfGIfK1 for <xfs@oss.sgi.com>;
	Sun, 02 Dec 2012 15:52:12 -0800 (PST)
Date: Mon, 3 Dec 2012 10:52:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/3] xfs: fix the multi-segment log buffer format
Message-ID: <20121202235211.GE29399@dastard>
References: <20121128222309.109033307@.sgi.com>
	<20121128222622.908368793@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121128222622.908368793@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 28, 2012 at 04:23:12PM -0600, Mark Tinguely wrote:
> Per Dave Chinner suggestion, this patch:
>  1) Corrects the detection of whether a multi-segment buffer is
>     still tracking data.
>  2) Clears all the buffer log formats for a multi-segment buffer.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> 
> ---
>  fs/xfs/xfs_buf_item.c  |   13 ++++++++++---
>  fs/xfs/xfs_trans_buf.c |    7 +++++--
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> Index: b/fs/xfs/xfs_buf_item.c
> ===================================================================
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -508,7 +508,7 @@ xfs_buf_item_unlock(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> -	int			aborted;
> +	int			aborted, empty, i;
>  	uint			hold;
>  
>  	/* Clear the buffer's association with this transaction. */
> @@ -551,8 +551,15 @@ xfs_buf_item_unlock(
>  	 * If the buf item isn't tracking any data, free it, otherwise drop the
>  	 * reference we hold to it.
>  	 */
> -	if (xfs_bitmap_empty(bip->__bli_format.blf_data_map,
> -			     bip->__bli_format.blf_map_size))
> +	empty = 1;
> +	for (i = 0; i < bip->bli_format_count; i++) {
> +		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
> +			     bip->bli_formats[i].blf_map_size)) {
> +			empty = 0;
> +			break;
> +		}
> +	}
> +	if (empty)
>  		xfs_buf_item_relse(bp);
>  	else
>  		atomic_dec(&bip->bli_refcount);

I think "clean" is a better name for the temporary variable, as what
we are actually checking is whether the buffer has been modified or
not (i.e. whether it is clean or dirty)....

> Index: b/fs/xfs/xfs_trans_buf.c
> ===================================================================
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -643,6 +643,7 @@ xfs_trans_binval(
>  	xfs_buf_t	*bp)
>  {
>  	xfs_buf_log_item_t	*bip = bp->b_fspriv;
> +	int			i;
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> @@ -670,8 +671,10 @@ xfs_trans_binval(
>  	bip->bli_flags &= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);
>  	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
>  	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
> -	memset((char *)(bip->__bli_format.blf_data_map), 0,
> -	      (bip->__bli_format.blf_map_size * sizeof(uint)));
> +	for (i = 0; i < bip->bli_format_count; i++) {
> +		memset((char *)(bip->bli_formats[i].blf_data_map), 0,
> +		       (bip->bli_formats[i].blf_map_size * sizeof(uint)));

No cast needed - memset() takes a void pointer....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
