Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A4677F9F
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:39:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB9F0AC001
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:39:32 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0lxACoIaUqdF5zBE for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:39:28 -0800 (PST)
Date: Mon, 9 Dec 2013 09:39:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/11] xfs: use xfs_ilock_attr_map_shared in
	xfs_attr_list_int
Message-ID: <20131208223923.GK31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203129.460873551@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203129.460873551@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 12:30:16PM -0800, Christoph Hellwig wrote:
> We might not have read in the extent list at this point, so make sure we
> take the ilock exclusively if we have to do so.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_attr_list.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_attr_list.c	2013-12-06 17:20:27.371331603 +0100
> +++ xfs/fs/xfs/xfs_attr_list.c	2013-12-06 19:41:42.779157674 +0100
> @@ -507,17 +507,17 @@ xfs_attr_list_int(
>  {
>  	int error;
>  	xfs_inode_t *dp = context->dp;
> +	uint		lock_mode;
>  
>  	XFS_STATS_INC(xs_attr_list);
>  
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return EIO;
>  
> -	xfs_ilock(dp, XFS_ILOCK_SHARED);
> -
>  	/*
>  	 * Decide on what work routines to call based on the inode size.
>  	 */
> +	lock_mode = xfs_ilock_attr_map_shared(dp);
>  	if (!xfs_inode_hasattr(dp)) {
>  		error = 0;
>  	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> @@ -527,9 +527,7 @@ xfs_attr_list_int(
>  	} else {
>  		error = xfs_attr_node_list(context);
>  	}
> -
> -	xfs_iunlock(dp, XFS_ILOCK_SHARED);
> -
> +	xfs_iunlock(dp, lock_mode);
>  	return error;
>  }

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
