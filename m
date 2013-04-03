Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B23887CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 17:13:48 -0500 (CDT)
Date: Wed, 3 Apr 2013 17:13:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 13/21] xfs: add CRC checking to dir2 data blocks
Message-ID: <20130403221345.GB22182@sgi.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-14-git-send-email-david@fromorbit.com>
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

Dave,

On Tue, Mar 12, 2013 at 11:30:46PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This addition follows the same pattern as the dir2 block CRCs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Just a few nits.

> @@ -908,7 +908,7 @@ xfs_dir2_block_removename(
>  		xfs_dir2_data_freescan(mp, hdr, &needlog);
>  	if (needlog)
>  		xfs_dir2_data_log_header(tp, bp);
> -	xfs_dir2_data_check(dp, bp);
> +	xfs_dir3_data_check(dp, bp);

In this debug code, maybe it is better check the blocks after making the
changes to them but before logging them?  Not sure.

> @@ -212,7 +221,7 @@ xfs_dir2_data_verify(
>   * format buffer or a data format buffer on readahead.
>   */
>  static void
> -xfs_dir2_data_reada_verify(
> +xfs_dir3_data_reada_verify(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -225,7 +234,8 @@ xfs_dir2_data_reada_verify(
>  		bp->b_ops->verify_read(bp);
>  		return;
>  	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
> -		xfs_dir2_data_verify(bp);
> +	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
> +		xfs_dir3_data_verify(bp);

I think it might be a good idea to add a print in the situation where we have
an error in readahead.  It needn't be a forced shutdown.

> diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
> index bec058f..dfc8ccf 100644
> --- a/fs/xfs/xfs_dir2_format.h
> +++ b/fs/xfs/xfs_dir2_format.h
> @@ -283,7 +283,8 @@ struct xfs_dir3_data_hdr {
>  	static inline struct xfs_dir2_data_free *
>  xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)

Get rid of the tab.

> @@ -204,8 +204,12 @@ xfs_dir2_block_to_leaf(
>  	/*
>  	 * Fix up the block header, make it a data block.
>  	 */
> -	dbp->b_ops = &xfs_dir2_data_buf_ops;
> -	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
> +	dbp->b_ops = &xfs_dir3_data_buf_ops;
> +	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
> +		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
> +	else
> +		hdr->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
> +

	else {
		ASSERT(hdr->magic == XFS_DIR3_BLOCK_MAGIC));
		hdr->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
	}

Might be nice...

Else, looks good.  I'll switch over to reviewing your new rev.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
