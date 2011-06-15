Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5FIcsLF203842 for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 13:38:54 -0500
Subject: Re: [PATCH] xfs: make log devices with write back caches work
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110527164137.GA5833@infradead.org>
References: <20110527164137.GA5833@infradead.org>
Date: Wed, 15 Jun 2011 13:38:47 -0500
Message-ID: <1308163127.2893.58.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, 2011-05-27 at 11:41 -0500, Christoph Hellwig wrote:
> There's no reason not to support cache flushing on external log devices.
> The only thing this really requires is flushing the data device first

I know this is just the description but it wasn't obvious to me
initially the reason for this ordering.  Now I know:  it's to
ensure any data written to new space on a file extending write
is on disk before a size change gets committed.  Maybe you could
mention this (in addition to mentioning it in a comment, as I
suggest below.

(And I don't know if the case mentioned above is the only
one where this ordering is important.  It's conceivable there
could be a case where the reverse ordering (log first) was
needed, but I have not thought that through at all and I
presume not.)

> both in fsync and log commits.  A side effect is that we also have to
> remove the barrier write test during mount, which has been superflous
> since the new FLUSH+FUA code anyway.  Also use the chance to flush the
> RT subvolume write cache before the fsync commit, which is required
> for correct semantics.

A few comments below.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2011-05-27 13:07:41.260498122 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_file.c	2011-05-27 17:37:30.152495811 +0200
> @@ -131,19 +131,32 @@ xfs_file_fsync(
>  {
>  	struct inode		*inode = file->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);

. . .

>  	xfs_ioend_wait(ip);
>  
> +	if (mp->m_flags & XFS_MOUNT_BARRIER) {
> +		/*
> +		 * If we have an RT and/or log subvolume we need to make sure
> +		 * to flush the write cache on the device that the data
> +		 * resides before commit the transaction.
> +		 */
> +		if (XFS_IS_REALTIME_INODE(ip))
> +			xfs_blkdev_issue_flush(mp->m_rtdev_targp);

I questioned the "else" below.  But as you mentioned on IRC
it makes sense because a realtime inode will never share the
same device target as the log (or later in this function, the
data device).  A short mention of that in the comment above
might be reassuring.  Similarly, I think it would be worthwhile
to mention the reason for doing this flush here *before* the
log gets forced.

> +		else if (mp->m_logdev_targp != mp->m_ddev_targp)
> +			xfs_blkdev_issue_flush(mp->m_ddev_targp);
> +	}
> +
>  	/*
>  	 * We always need to make sure that the required inode state is safe on
>  	 * disk.  The inode might be clean but we still might need to force the

. . .

> @@ -209,28 +222,23 @@ xfs_file_fsync(
>  		 * force the log.
>  		 */
>  		if (xfs_ipincount(ip)) {
> -			error = _xfs_log_force_lsn(ip->i_mount,
> +			error = _xfs_log_force_lsn(mp,
>  					ip->i_itemp->ili_last_lsn,
>  					XFS_LOG_SYNC, &log_flushed);

If log_flushed is set on return here, does that also imply
that the actual blkdev flush of the log device (which is
possibly the data device) has occurred?  It looks to
me like xlog_sync() marks each log buffer ordered but I
don't see the flush (though I didn't look *that* hard...).

>  		}
>  		xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  	}
>  
> -	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {
> -		/*
> -		 * If the log write didn't issue an ordered tag we need
> -		 * to flush the disk cache for the data device now.
> -		 */
> -		if (!log_flushed)
> -			xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
> -
> -		/*
> -		 * If this inode is on the RT dev we need to flush that
> -		 * cache as well.
> -		 */
> -		if (XFS_IS_REALTIME_INODE(ip))
> -			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
> -	}
> +	/*
> +	 * Flush the write cache on the data volume, if the data for this
> +	 * inode actually resides on it, and the transaction commit did
> +	 * not flush it yet.
> +	 */
> +	if ((mp->m_flags & XFS_MOUNT_BARRIER) &&
> +	    mp->m_logdev_targp == mp->m_ddev_targp &&
> +	    !XFS_IS_REALTIME_INODE(ip) &&
> +	    !log_flushed)
> +		xfs_blkdev_issue_flush(mp->m_ddev_targp);

Note my previous comment.  It kind of arose because my
thought when seeing this was "What if it is an internal
log but _xfs_log_force_lsn() does *not* issue a blkdev
flush to the log/data device?"

Breaking it down, we have either one or two devices to flush,
the log and either the realtime or (if external log) the data
device:
- realtime device (flush it before log device flush)
- data device (only if not realtime; do first if external log)
- log device (flush this last, realtime or not)

I may be wrong, but it seems like this may be the
logic you need:

    if (RT)
	flush RT device
    else if (external log)
	flush data device
    force the log
    if (log device wasn't flushed when log forced)
	flush log device

The log device flush of course implies a data device flush
for an internal log.

>  	return -error;
>  }
> Index: xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-05-27 13:07:41.272495356 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-05-27 15:37:11.673496345 +0200
> @@ -627,68 +627,6 @@ xfs_blkdev_put(
>  		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>  }

. . .

> -
> -STATIC void
> -xfs_mountfs_check_barriers(xfs_mount_t *mp)
> -{

. . .

> -	if (xfs_readonly_buftarg(mp->m_ddev_targp)) {
> -		xfs_notice(mp,
> -			"Disabling barriers, underlying device is readonly");
> -		mp->m_flags &= ~XFS_MOUNT_BARRIER;
> -		return;
> -	}

At first I was going to suggest this might still be
a worthwhile optimization.  But I think a read-only
underlying device will prevent us from ever reaching
the points that (now) would bother checking the
XFS_MOUNT_BARRIER flag.

> -
> -	error = xfs_barrier_test(mp);
> -	if (error) {
> -		xfs_notice(mp,
> -			"Disabling barriers, trial barrier write failed");
> -		mp->m_flags &= ~XFS_MOUNT_BARRIER;
> -		return;
> -	}
> -}
> -
>  void
>  xfs_blkdev_issue_flush(
>  	xfs_buftarg_t		*buftarg)

. . .

> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-05-27 13:07:41.284496076 +0200
> +++ xfs/fs/xfs/xfs_log.c	2011-05-27 15:37:11.681500020 +0200
> @@ -1372,8 +1372,15 @@ xlog_sync(xlog_t		*log,
>  	XFS_BUF_ASYNC(bp);
>  	bp->b_flags |= XBF_LOG_BUFFER;
>  
> -	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
> +	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
> +		/*
> +		 * If we have an external log device, flush the data device
> +		 * before flushing the log.
> +		 */
> +		if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
> +			xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);

Shouldn't we flush the realtime device as well here, if present?

>  		XFS_BUF_ORDERED(bp);
> +	}
>  
>  	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
>  	ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
