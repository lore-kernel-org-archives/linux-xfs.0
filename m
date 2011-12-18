Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIMHBVe254534 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 16:17:11 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sD8uA9DfZCWEATm4 for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 14:17:09 -0800 (PST)
Date: Mon, 19 Dec 2011 09:17:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: log all dirty inodes in xfs_fs_sync_fs
Message-ID: <20111218221707.GH23662@dastard>
References: <20111218154936.GA17626@infradead.org>
	<20111218155015.GC17626@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218155015.GC17626@infradead.org>
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
Cc: Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>, xfs@oss.sgi.com

On Sun, Dec 18, 2011 at 10:50:15AM -0500, Christoph Hellwig wrote:
> Since Linux 2.6.36 the writeback code has introduces various measures for
> live lock prevention during sync().  Unfortunately some of these are
> actively harmful for the XFS model, where the inode gets marked dirty for
> metadata from the data I/O handler.
> 
> The older_than_this checks that are now more strictly enforced since
> 
>     writeback: avoid livelocking WB_SYNC_ALL writeback
> 
> by only calling into __writeback_inodes_sb and thus only sampling the
> current cut off time once.  But on a slow enough devices the previous
> asynchronous sync pass might not have fully completed yet, and thus XFS
> might mark metadata dirty only after that sampling of the cut off time for
> the blocking pass already happened.  I have not myself reproduced this
> myself on a real system, but by introducing artificial delay into the
> XFS I/O completion workqueues it can be reproduced easily.
> 
> Fix this by iterating over all XFS inodes in ->sync_fs and log all that
> are dirty.  This might log inode that only got redirtied after the
> previous pass, but given how cheap delayed logging of inodes is it
> isn't a major concern for performance.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_sync.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_sync.c	2011-12-14 05:33:06.436599621 -0800
> +++ xfs/fs/xfs/xfs_sync.c	2011-12-14 05:38:49.084743337 -0800
> @@ -336,6 +336,29 @@ xfs_sync_fsdata(
>  	return error;
>  }
>  
> +int
> +xfs_log_inode(
> +	struct xfs_inode	*ip,
> +	struct xfs_perag	*pag,
> +	int			flags)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
> +	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
> +		return error;
> +	}
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	return xfs_trans_commit(tp, 0);
> +}

This will do a transaction on the inode, clean or dirty. That's an
awful lot of overhead for the few inodes (out of perhaps millions in
memory) that actually need it. with the ->dirty_inode callback from
the VFS, we know the only inodes that need logging are those with
i_update_core set....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
