Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A6F27F5E
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 14:59:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D9079AC004
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 12:59:15 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DdulrlA4BKrkQ3QH for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 12:59:14 -0800 (PST)
Date: Fri, 6 Dec 2013 07:59:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: use xfs_ilock_map_shared in xfs_attr_get
Message-ID: <20131205205910.GD29897@dastard>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.679310054@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205155951.679310054@bombadil.infradead.org>
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

On Thu, Dec 05, 2013 at 07:58:34AM -0800, Christoph Hellwig wrote:
> We might not have read in the extent list at this point, so make sure we
> take the ilock exclusively if we have to do so.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index b861270..5343034 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
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
> +	lock_mode = xfs_ilock_map_shared(ip);
>  	error = xfs_attr_get_int(ip, &xname, value, valuelenp, flags);
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	xfs_iunlock_map_shared(ip, lock_mode);
>  	return(error);
>  }

I think the locking here should be moved inside xfs_attr_get_int()
so that it uses the same locking pattern as xfs_attr_set() and
xfs_attr_remove().

Also, xfs_attr_list() needs this treatment (the attr version of
readdir) as well (and it has the locking inside xfs_attr_list_int(),
too ;).

It looks like xfs_readlink needs fixing, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
