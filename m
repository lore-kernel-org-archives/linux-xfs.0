Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1CB587F8B
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:34:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AC4ADAC002
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:34:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HIw7vQHpPuoYFlK4 for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:34:06 -0800 (PST)
Date: Mon, 9 Dec 2013 09:33:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: rename xfs_ilock_map_shared
Message-ID: <20131208223359.GD31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.511935311@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203128.511935311@bombadil.infradead.org>
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

On Fri, Dec 06, 2013 at 12:30:09PM -0800, Christoph Hellwig wrote:
> Make it clear that we're only locking against the extent map on the data
> fork.  Also clean the function up a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2013-12-06 19:57:33.199138169 +0100
> +++ xfs/fs/xfs/xfs_inode.c	2013-12-06 19:58:41.667136764 +0100
> @@ -91,20 +91,15 @@ xfs_get_extsz_hint(
>   * xfs_iunlock() call.
>   */
>  uint
> -xfs_ilock_map_shared(
> -	xfs_inode_t	*ip)
> +xfs_ilock_data_map_shared(
> +	struct xfs_inode	*ip)
>  {
> -	uint	lock_mode;
> +	uint			lock_mode = XFS_ILOCK_SHARED;
>  
> -	if ((ip->i_d.di_format == XFS_DINODE_FMT_BTREE) &&
> -	    ((ip->i_df.if_flags & XFS_IFEXTENTS) == 0)) {
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> +	    (ip->i_df.if_flags & XFS_IFEXTENTS) == 0)
>  		lock_mode = XFS_ILOCK_EXCL;
> -	} else {
> -		lock_mode = XFS_ILOCK_SHARED;
> -	}
> -
>  	xfs_ilock(ip, lock_mode);
> -
>  	return lock_mode;
>  }

While we are changing this, I think it makes sense to move it to
being a static inline function given how simple it is....

Otherwise it looks good.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
