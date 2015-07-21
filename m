Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E97FE29E06
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 06:50:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88A3AAC009
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 04:50:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aSVKbaOJQQ5IK47k (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 04:50:47 -0700 (PDT)
Date: Tue, 21 Jul 2015 07:50:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: xfs_bunmapi() does not need XFS_BMAPI_METADATA
	flag
Message-ID: <20150721115045.GD23013@bfoster.bfoster>
References: <1437440945-23457-1-git-send-email-david@fromorbit.com>
	<1437440945-23457-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437440945-23457-5-git-send-email-david@fromorbit.com>
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
Cc: willy@linux.intel.com, xfs@oss.sgi.com

On Tue, Jul 21, 2015 at 11:09:05AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_bunmapi() doesn't care what type of extent is being freed and
> does not look at the XFS_BMAPI_METADATA flag at all. As such we can
> remove the XFS_BMAPI_METADATA from all callers that use it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr_remote.c |  5 ++---
>  fs/xfs/libxfs/xfs_da_btree.c    |  4 ++--
>  fs/xfs/libxfs/xfs_dir2.c        | 33 +++++++++++++++------------------
>  fs/xfs/xfs_symlink.c            |  2 +-
>  4 files changed, 20 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index dd71403..89356aa 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -618,9 +618,8 @@ xfs_attr_rmtval_remove(
>  
>  		xfs_bmap_init(args->flist, args->firstblock);
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> -				    XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
> -				    1, args->firstblock, args->flist,
> -				    &done);
> +				    XFS_BMAPI_ATTRFORK, 1, args->firstblock,
> +				    args->flist, &done);
>  		if (!error) {
>  			error = xfs_bmap_finish(&args->trans, args->flist,
>  						&committed);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 2385f8c..2ae91e8 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2351,8 +2351,8 @@ xfs_da_shrink_inode(
>  		 * the last block to the place we want to kill.
>  		 */
>  		error = xfs_bunmapi(tp, dp, dead_blkno, count,
> -				    xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
> -				    0, args->firstblock, args->flist, &done);
> +				    xfs_bmapi_aflag(w), 0, args->firstblock,
> +				    args->flist, &done);
>  		if (error == -ENOSPC) {
>  			if (w != XFS_DATA_FORK)
>  				break;
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index a69fb3a..e0ba976 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -674,25 +674,22 @@ xfs_dir2_shrink_inode(
>  	mp = dp->i_mount;
>  	tp = args->trans;
>  	da = xfs_dir2_db_to_da(args->geo, db);
> -	/*
> -	 * Unmap the fsblock(s).
> -	 */
> -	if ((error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount,
> -			XFS_BMAPI_METADATA, 0, args->firstblock, args->flist,
> -			&done))) {
> +
> +	/* Unmap the fsblock(s). */
> +	error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount, 0, 0,
> +			    args->firstblock, args->flist, &done);
> +	if (error) {
>  		/*
> -		 * ENOSPC actually can happen if we're in a removename with
> -		 * no space reservation, and the resulting block removal
> -		 * would cause a bmap btree split or conversion from extents
> -		 * to btree.  This can only happen for un-fragmented
> -		 * directory blocks, since you need to be punching out
> -		 * the middle of an extent.
> -		 * In this case we need to leave the block in the file,
> -		 * and not binval it.
> -		 * So the block has to be in a consistent empty state
> -		 * and appropriately logged.
> -		 * We don't free up the buffer, the caller can tell it
> -		 * hasn't happened since it got an error back.
> +		 * ENOSPC actually can happen if we're in a removename with no
> +		 * space reservation, and the resulting block removal would
> +		 * cause a bmap btree split or conversion from extents to btree.
> +		 * This can only happen for un-fragmented directory blocks,
> +		 * since you need to be punching out the middle of an extent.
> +		 * In this case we need to leave the block in the file, and not
> +		 * binval it.  So the block has to be in a consistent empty
> +		 * state and appropriately logged.  We don't free up the buffer,
> +		 * the caller can tell it hasn't happened since it got an error
> +		 * back.
>  		 */
>  		return error;
>  	}
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 4be27b0..05c44bf 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -501,7 +501,7 @@ xfs_inactive_symlink_rmt(
>  	/*
>  	 * Unmap the dead block(s) to the free_list.
>  	 */
> -	error = xfs_bunmapi(tp, ip, 0, size, XFS_BMAPI_METADATA, nmaps,
> +	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps,
>  			    &first_block, &free_list, &done);
>  	if (error)
>  		goto error_bmap_cancel;
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
