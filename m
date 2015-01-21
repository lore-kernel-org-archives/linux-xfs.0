Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A3C07F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 16:06:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58F4B304053
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 14:06:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TCz0wm7ngi0FZPUm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 14:06:16 -0800 (PST)
Date: Wed, 21 Jan 2015 17:06:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: set buf types when converting extent formats
Message-ID: <20150121220609.GD7960@laptop.bfoster>
References: <1421800780-26008-1-git-send-email-david@fromorbit.com>
	<1421800780-26008-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421800780-26008-4-git-send-email-david@fromorbit.com>
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
Cc: jack@suse.cz, xfs@oss.sgi.com

On Wed, Jan 21, 2015 at 11:39:40AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Conversion from local to extent format does not set the buffer type
> correctly on the new extent buffer when a symlink data is moved out
> of line.
> 
> Fix the symlink code and leave a comment in the generic bmap code
> reminding us that the format-specific data copy needs to set the
> destination buffer type appropriately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c           | 6 +++++-
>  fs/xfs/libxfs/xfs_symlink_remote.c | 2 ++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 63a5bb9..61ec015 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -973,7 +973,11 @@ xfs_bmap_local_to_extents(
>  	*firstblock = args.fsbno;
>  	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
>  
> -	/* initialise the block and copy the data */
> +	/*
> +	 * Initialise the block and copy the data
> +	 *
> +	 * Note: init_fn must set the buffer log item type correctly!
> +	 */
>  	init_fn(tp, bp, ip, ifp);
>  
>  	/* account for the change in fork size and log everything */
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index c80c523..e7e26bd 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -178,6 +178,8 @@ xfs_symlink_local_to_remote(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	char			*buf;
>  
> +	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
> +
>  	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
>  		bp->b_ops = NULL;
>  		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
