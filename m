Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H48VtH203576 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 22:08:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00B3013B0837
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 20:09:47 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	ill065K79ETxcKIq for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 20:09:47 -0800 (PST)
Date: Wed, 17 Feb 2010 15:09:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] [PATCH 3/4] xfs: remove wrapper for the fsync file
	operation
Message-ID: <20100217040944.GK28392@discord.disaster>
References: <20100215094445.528696829@bombadil.infradead.org>
	<20100215094604.640912740@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100215094604.640912740@bombadil.infradead.org>
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

On Mon, Feb 15, 2010 at 04:44:48AM -0500, Christoph Hellwig wrote:
> Currently the fsync file operation is divided into a low-level routine doing
> all the work and one that implements the Linux file operation and does minimal
> argument wrapping.  This is a leftover from the days of the vnode operations
> layer and can be removed to simplify the code a bit, as well as preparing for
> the implementation of an optimized fdatasync which needs to look at the
> Linux inode state.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, one minor thing:

> 
> Index: xfs/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-02-15 10:18:58.640023657 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-02-15 10:28:07.311260422 +0100
> @@ -35,6 +35,7 @@
>  #include "xfs_dir2_sf.h"
>  #include "xfs_dinode.h"
>  #include "xfs_inode.h"
> +#include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
>  #include "xfs_error.h"
>  #include "xfs_rw.h"
> @@ -96,6 +97,120 @@ xfs_iozero(
>  	return (-status);
>  }
>  
> +/*
> + * We ignore the datasync flag here because a datasync is effectively
> + * identical to an fsync. That is, datasync implies that we need to write
> + * only the metadata needed to be able to access the data that is written
> + * if we crash after the call completes. Hence if we are writing beyond
> + * EOF we have to log the inode size change as well, which makes it a
> + * full fsync. If we don't write beyond EOF, the inode core will be
> + * clean in memory and so we don't need to log the inode, just like
> + * fsync.
> + */
> +STATIC int
> +xfs_file_fsync(
> +	struct file		*file,
> +	struct dentry		*dentry,
> +	int			datasync)
> +{
> +	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
> +	struct xfs_trans	*tp;
> +	int			error = 0;
> +	int			log_flushed = 0;
> +
> +	xfs_itrace_entry(ip);
> +
> +	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> +		return -XFS_ERROR(EIO);
> +
> +	xfs_iflags_clear(ip, XFS_ITRUNCATED);
> +
> +	/*
> +	 * We always need to make sure that the required inode state is safe on
> +	 * disk.  The inode might be clean but we still might need to force the
> +	 * log because of committed transactions that haven't hit the disk yet.
> +	 * Likewise, there could be unflushed non-transactional changes to the
> +	 * inode core that have to go to disk and this requires us to issue
> +	 * a synchronous transaction to capture these changes correctly.
> +	 *
> +	 * This code relies on the assumption that if the i_update_core field
> +	 * of the inode is clear and the inode is unpinned then it is clean
> +	 * and no action is required.
> +	 */
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +
> +	if (ip->i_update_core) {
> +		/*
> +		 * Kick off a transaction to log the inode core to get the
> +		 * updates.  The sync transaction will also force the log.
> +		 */
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +		tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_FSYNC_TS);
> +		error = xfs_trans_reserve(tp, 0,
> +				XFS_FSYNC_TS_LOG_RES(ip->i_mount), 0, 0, 0);
> +		if (error) {
> +			xfs_trans_cancel(tp, 0);
> +			return -error;
> +		}
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +		/*
> +		 * Note - it's possible that we might have pushed ourselves out
> +		 * of the way during trans_reserve which would flush the inode.
> +		 * But there's no guarantee that the inode buffer has actually
> +		 * gone out yet (it's delwri).	Plus the buffer could be pinned
> +		 * anyway if it's part of an inode in another recent
> +		 * transaction.	 So we play it safe and fire off the
> +		 * transaction anyway.
> +		 */
> +		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ihold(tp, ip);
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +		xfs_trans_set_sync(tp);
> +		error = _xfs_trans_commit(tp, 0, &log_flushed);
> +
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	} else {
> +		/*
> +		 * Timestamps/size haven't changed since last inode flush or
> +		 * inode transaction commit.  That means either nothing got
> +		 * written or a transaction committed which caught the updates.
> +		 * If the latter happened and the transaction hasn't hit the
> +		 * disk yet, the inode will be still be pinned.  If it is,
> +		 * force the log.
> +		 */
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +		if (xfs_ipincount(ip)) {
> +			if (ip->i_itemp->ili_last_lsn) {
> +				error = _xfs_log_force_lsn(ip->i_mount,
> +						ip->i_itemp->ili_last_lsn,
> +						XFS_LOG_SYNC, &log_flushed);
> +			} else {
> +				error = _xfs_log_force(ip->i_mount,
> +						XFS_LOG_SYNC, &log_flushed);
> +			}
> +		}

To be technically correct, the ilock should be held over the
pincount check and log force, as is done in xfs_iunpin_wait().
That way we can guarantee the inode was correctly forced and not
unpinned between the unlock/check/log force being issued. I know
this is just a copy of the existing fsync code, but I think that
the existing code is wrong, too. ;)

Also, if the inode is pinned while we have it locked, then
ip->i_itemp->ili_last_lsn is guaranteed to be set as it is updated
in IOP_COMMITTING() which is called during transaction commit.

As it is, ili_last_lsn is never reset to zero after a transaction,
so i think the _xfs_log_force() branch will never be executed,
either.

Other than that, the change looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
