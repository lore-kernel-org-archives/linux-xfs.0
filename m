Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TMvlZa204910 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 17:57:47 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	upBu96PYtV3QTiyB for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 15:57:46 -0700 (PDT)
Date: Fri, 30 Mar 2012 09:57:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct
	I/O requests
Message-ID: <20120329225743.GC18323@dastard>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
	<1333058705-31512-6-git-send-email-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1333058705-31512-6-git-send-email-jmoyer@redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, linux-ext4@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

On Thu, Mar 29, 2012 at 06:05:03PM -0400, Jeff Moyer wrote:
> Hi,
> 
> If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
> flushed after the write completion for AIOs.  This patch attempts to fix
> that problem by marking an I/O as requiring a cache flush in endio
> processing, and then issuing the cache flush after any unwritten extent
> conversion is done.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

....

>         }
>  }
> +xfs_ioend_force_cache_flush(
> +	xfs_ioend_t	*ioend)
> +{
> +	struct xfs_inode *ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount *mp = ip->i_mount;
> +	xfs_lsn_t	lsn = 0;
> +	int		err = 0;
> +	int		log_flushed = 0;
> +
> +	/*
> +	 * Check to see if we need to sync metadata.  If so,
> +	 * perform a log flush.  If not, just flush the disk
> +	 * write cache for the data disk.
> +	 */
> +	if (IS_SYNC(ioend->io_inode) ||
> +	    (ioend->io_iocb->ki_filp->f_flags & __O_SYNC)) {
> +		/*
> +		 * TODO: xfs_blkdev_issue_flush and _xfs_log_force_lsn
> +		 * are synchronous, and so will block the I/O
> +		 * completion work queue.
> +		 */

Sure, but the workqueue allows the default number of concurrent
per-cpu works to be executed (512, IIRC), so blocking the work here
simply means the next one will be executed in another per-cpu
kworker thread. So I don't think this is an issue.

> +		/*
> +		 * If the log device is different from the data device,
> +		 * be sure to flush the cache on the data device
> +		 * first.
> +		 */
> +		if (mp->m_logdev_targp != mp->m_ddev_targp)
> +			xfs_blkdev_issue_flush(mp->m_ddev_targp);

The data device for the inode could be the realtime device, which
means this could be wrong. See xfs_file_fsync()....

> +
> +		xfs_ilock(ip, XFS_ILOCK_SHARED);
> +		if (xfs_ipincount(ip))
> +			lsn = ip->i_itemp->ili_last_lsn;
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +		if (lsn)
> +			err = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC,
> +						 &log_flushed);

Yes, that is an fsync, but....

> +		if (err && ioend->io_result > 0)
> +			ioend->io_result = err;
> +		if (err || log_flushed)
> +			xfs_destroy_ioend(ioend);
> +		else
> +			xfs_ioend_flush_cache(ioend, mp->m_logdev_targp);
> +	} else
> +		/* data sync only, flush the disk cache */
> +		xfs_ioend_flush_cache(ioend, mp->m_ddev_targp);

... that is not an fdatasync.  That will miss EOF size updates or
unwritten extent conversion transactions that have been committed
but are not yet on disk. That is, it will force the data to be
stable, but not necessarily the metadata that points to the data...

It seems to my that what you really want here is almost:

	datasync = !(IS_SYNC(ioend->io_inode) ||
		     (ioend->io_iocb->ki_filp->f_flags & __O_SYNC));
	error = xfs_file_fsync(ioend->io_inode, 0, 0, datasync);

or better still, factor xfs_file_fsync() so that it calls a helper
that doesn't wait for data IO completion, and call that helper here
too. The semantics of fsync/fdatasync are too complex to have to
implement and maintain in multiple locations....

>  /*
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 9eba738..e406204 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -214,6 +214,7 @@ typedef struct xfs_mount {
>  
>  	struct workqueue_struct	*m_data_workqueue;
>  	struct workqueue_struct	*m_unwritten_workqueue;
> +	struct workqueue_struct *m_flush_workqueue;

I have to say that I'm not a great fan of the "flush" name here. It
is way too generic. "m_aio_blkdev_flush_wq" seems like a better name
to me because it describes exactly what is it used for...

>  } xfs_mount_t;
>  
>  /*
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index dab9a5f..e32b309 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -773,8 +773,15 @@ xfs_init_mount_workqueues(
>  	if (!mp->m_unwritten_workqueue)
>  		goto out_destroy_data_iodone_queue;
>  
> +	mp->m_flush_workqueue = alloc_workqueue("xfs-flush/%s",
> +			WQ_MEM_RECLAIM, 0, mp->m_fsname);

same with the thread name....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
