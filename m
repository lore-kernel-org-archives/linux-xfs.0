Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P0mHUm133152 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 19:48:17 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C7CC139B6F6
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 17:51:03 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7b1Zyw1Y8FIsLBxB for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 17:51:03 -0700 (PDT)
Date: Thu, 25 Aug 2011 10:48:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20110825004811.GK3162@dastard>
References: <20110824055924.139283426@bombadil.infradead.org>
	<20110824060150.001321834@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110824060150.001321834@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Aug 24, 2011 at 01:59:26AM -0400, Christoph Hellwig wrote:
> The new concurrency managed workqueues are cheap enough that we can
> create them per-filesystem instead of global.  This allows us to only
> flush items for the current filesystem during sync, and to remove the
> trylock or defer scheme on the ilock, which is not compatible with
> using the workqueue flush for integrity purposes in the sync code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The only issue I see with this is that it brings back per-filesystem
workqueue threads. Because all the workqueues are defined with
MEM_RECLAIM, there is a rescuer thread per workqueue that is used
when the CWMQ cannot allocate memory to queue the work to the
appropriate per-cpu queue.

Right now we have:

$ ps -ef |grep [x]fs
root       748     2  0 Aug23 ?        00:00:00 [xfs_mru_cache]
root       749     2  0 Aug23 ?        00:00:00 [xfslogd]
root       750     2  0 Aug23 ?        00:00:00 [xfsdatad]
root       751     2  0 Aug23 ?        00:00:00 [xfsconvertd]
$

where the xfslogd, xfsdatad and xfsconvertd are the rescuer threads.

I don't think this is a big problem, but it is definitely something
worth noting (at least in the commit message) given that we've
removed just about all the per-filesystem threads recently...

Cheers,

Dave.

> Index: xfs/fs/xfs/xfs_aops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_aops.c	2011-08-23 04:35:20.822345321 +0200
> +++ xfs/fs/xfs/xfs_aops.c	2011-08-23 04:37:02.425128226 +0200
> @@ -131,30 +131,22 @@ static inline bool xfs_ioend_is_append(s
>   * will be the intended file size until i_size is updated.  If this write does
>   * not extend all the way to the valid file size then restrict this update to
>   * the end of the write.
> - *
> - * This function does not block as blocking on the inode lock in IO completion
> - * can lead to IO completion order dependency deadlocks.. If it can't get the
> - * inode ilock it will return EAGAIN. Callers must handle this.
>   */
> -STATIC int
> +STATIC void
>  xfs_setfilesize(
>  	xfs_ioend_t		*ioend)
>  {
>  	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
>  	xfs_fsize_t		isize;
>  
> -	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
> -		return EAGAIN;
> -
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	isize = xfs_ioend_new_eof(ioend);
>  	if (isize) {
>  		trace_xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
>  		ip->i_d.di_size = isize;
>  		xfs_mark_inode_dirty(ip);
>  	}
> -
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	return 0;
>  }

If we are going to block here, then we probably should increase the
per-cpu concurrency of the work queue so that we can continue to
process other ioends while this one is blocked.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
