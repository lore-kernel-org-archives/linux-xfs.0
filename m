Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U6OOnI117280 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 01:24:25 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE981124CE9
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 23:24:22 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QCE6xBtIa3VZ9wFS for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2011 23:24:22 -0700 (PDT)
Date: Tue, 30 Aug 2011 16:24:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: fix xfs_mark_inode_dirty during umount
Message-ID: <20110830062416.GN3162@dastard>
References: <20110827055731.GA24159@infradead.org>
	<20110827055744.GA28351@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110827055744.GA28351@infradead.org>
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

On Sat, Aug 27, 2011 at 01:57:44AM -0400, Christoph Hellwig wrote:
> During umount we do not add a dirty inode to the lru and wait for it to
> become clean first, but force writeback of data and metadata with
> I_WILL_FREE set.  Currently there is no way for XFS to detect that the
> inode has been redirtied for metadata operations, as we skip the
> mark_inode_dirty call during teardown.  Fix this by setting i_update_core
> nanually in that case, so that the inode gets flushed during inode reclaim.
> 
> Alternatively we could enable calling mark_inode_dirty for inodes in
> I_WILL_FREE state, and let the VFS dirty tracking handle this.  I decided
> against this as we will get better I/O patterns from reclaim compared to
> the synchronous writeout in write_inode_now, and always marking the inode
> dirty in some way from xfs_mark_inode_dirty is a better safetly net in
> either case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/xfs/xfs_iops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_iops.c	2011-08-26 12:31:19.090631739 +0200
> +++ linux-2.6/fs/xfs/xfs_iops.c	2011-08-26 12:35:43.692531800 +0200
> @@ -70,9 +70,8 @@ xfs_synchronize_times(
>  }
>  
>  /*
> - * If the linux inode is valid, mark it dirty.
> - * Used when committing a dirty inode into a transaction so that
> - * the inode will get written back by the linux code
> + * If the linux inode is valid, mark it dirty, else mark the dirty state
> + * in the XFS inode to make sure we pick it up when reclaiming the inode.
>   */
>  void
>  xfs_mark_inode_dirty_sync(
> @@ -82,6 +81,10 @@ xfs_mark_inode_dirty_sync(
>  
>  	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
>  		mark_inode_dirty_sync(inode);
> +	else {
> +		barrier();
> +		ip->i_update_core = 1;
> +	}
>  }

Why the barrier()? Isn't that just a compiler barrier? If you are
worried about catching the update vs clearing it in transaction
commit, shouldn't that use smp_mb() instead (in both places)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
