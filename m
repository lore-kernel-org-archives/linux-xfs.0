Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D3327FA0
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:39:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 981E4AC001
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:39:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5Gp9tqE69r3cbPKh for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:39:07 -0800 (PST)
Date: Mon, 9 Dec 2013 09:39:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/11] xfs: use xfs_ilock_attr_map_shared in xfs_attr_get
Message-ID: <20131208223902.GJ31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203129.330138179@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203129.330138179@bombadil.infradead.org>
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

On Fri, Dec 06, 2013 at 12:30:15PM -0800, Christoph Hellwig wrote:
> We might not have read in the extent list at this point, so make sure we
> take the ilock exclusively if we have to do so.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_attr.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_attr.c	2013-12-06 17:20:27.447331601 +0100
> +++ xfs/fs/xfs/xfs_attr.c	2013-12-06 19:41:05.119158446 +0100
> @@ -164,6 +164,7 @@ xfs_attr_get(
>  {
>  	int		error;
>  	struct xfs_name	xname;
> +	uint		lock_mode;
>  
>  	XFS_STATS_INC(xs_attr_get);
>  
> @@ -174,9 +175,9 @@ xfs_attr_get(
>  	if (error)
>  		return error;
>  
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	lock_mode = xfs_ilock_attr_map_shared(ip);
>  	error = xfs_attr_get_int(ip, &xname, value, valuelenp, flags);
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	xfs_iunlock(ip, lock_mode);
>  	return(error);
>  }

Yup, that should fix the assert problem. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
