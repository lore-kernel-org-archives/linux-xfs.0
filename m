Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKBIWlC150736 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 05:18:33 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CiZUbMtz1MVwR6R9 for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 03:20:41 -0800 (PST)
Date: Tue, 20 Nov 2012 22:20:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: honor the O_SYNC flag for aysnchronous direct
	I/O requests
Message-ID: <20121120112038.GC2591@dastard>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120075114.25270.40680.stgit@blackbox.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120075114.25270.40680.stgit@blackbox.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, djwong+kernel@djwong.org, xfs@oss.sgi.com, jack@suse.cz, bpm@sgi.com, linux-kernel@vger.kernel.org, hch@infradead.org, jmoyer@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org

On Mon, Nov 19, 2012 at 11:51:14PM -0800, Darrick J. Wong wrote:
> If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
> flushed after the write completion for AIOs.  This patch attempts to fix
> that problem by marking an I/O as requiring a cache flush in endio
> processing, and then issuing the cache flush after any unwritten extent
> conversion is done.
> 
> From: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> [darrick.wong@oracle.com: Rework patch to use per-mount workqueues]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_aops.c  |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_aops.h  |    1 +
>  fs/xfs/xfs_mount.h |    1 +
>  fs/xfs/xfs_super.c |    8 ++++++++
>  4 files changed, 61 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index e57e2da..9cebbb7 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -173,6 +173,24 @@ xfs_setfilesize(
>  }
>  
>  /*
> + * In the case of synchronous, AIO, O_DIRECT writes, we need to flush
> + * the disk cache when the I/O is complete.
> + */

That's not quite right - we need to fsync the metadata when the data
IO is complete. Block device/disk cache flushes are irrelevant at
this level as that is wholly encapsulated inside the metadata fsync
processing.

> +STATIC bool
> +xfs_ioend_needs_cache_flush(

xfs_ioend_need_fsync()

> +	struct xfs_ioend	*ioend)
> +{
> +	struct xfs_inode *ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount *mp = ip->i_mount;
> +
> +	if (!(mp->m_flags & XFS_MOUNT_BARRIER))
> +		return false;

And regardless of whether we have barriers enabled or not, we need
to flush the dirty metadata to the log for O_SYNC/O_DSYNC+AIO+DIO
writes here. So there should be no check of the mount flags here.

> +	return IS_SYNC(ioend->io_inode) ||
> +	       (ioend->io_iocb->ki_filp->f_flags & O_DSYNC);
> +}
> +
> +/*
>   * Schedule IO completion handling on the final put of an ioend.
>   *
>   * If there is no work to do we might as well call it a day and free the
> @@ -189,11 +207,30 @@ xfs_finish_ioend(
>  			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
>  		else if (ioend->io_append_trans)
>  			queue_work(mp->m_data_workqueue, &ioend->io_work);
> +		else if (ioend->io_needs_fsync)
> +			queue_work(mp->m_aio_blkdev_flush_wq, &ioend->io_work);
>  		else
>  			xfs_destroy_ioend(ioend);
>  	}
>  }
>  
> +STATIC int
> +xfs_ioend_force_cache_flush(

STATIC void
xfs_ioend_fsync()

> +	xfs_ioend_t	*ioend)
> +{
> +	struct xfs_inode *ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount *mp = ip->i_mount;
> +	int		err = 0;
> +	int		datasync;

	trace_xfs_ioend_fsync(ip);

> +	datasync = !IS_SYNC(ioend->io_inode) &&
> +		!(ioend->io_iocb->ki_filp->f_flags & __O_SYNC);
> +	err = do_xfs_file_fsync(ip, mp, datasync);
> +	xfs_destroy_ioend(ioend);

I think this is wrong. The ioend is destroyed by the caller, so
putting it here turns all subsequent uses by the caller into
use-after-free memory corruption bugs.


> +	/* do_xfs_file_fsync returns -errno. our caller expects positive. */
> +	return -err;

This is why xfs_do_file_fsync() should be returning a positive
error - to avoid repeated juggling of error signs.

> +}
> +
>  /*
>   * IO write completion.
>   */
> @@ -250,12 +287,22 @@ xfs_end_io(
>  		error = xfs_setfilesize(ioend);
>  		if (error)
>  			ioend->io_error = -error;
> +	} else if (ioend->io_needs_fsync) {
> +		error = xfs_ioend_force_cache_flush(ioend);
> +		if (error && ioend->io_result > 0)
> +			ioend->io_error = -error;
> +		ioend->io_needs_fsync = 0;

So this is all use-after-free. Also, there's no need to clear
io_needs_fsync() as the ioend is about to be destroyed.

>  	} else {
>  		ASSERT(!xfs_ioend_is_append(ioend));
>  	}
>  
>  done:
> -	xfs_destroy_ioend(ioend);
> +	/* the honoring of O_SYNC has to be done last */
> +	if (ioend->io_needs_fsync) {
> +		atomic_inc(&ioend->io_remaining);
> +		xfs_finish_ioend(ioend);
> +	} else
> +		xfs_destroy_ioend(ioend);

And requeuing work from one workqueue to the next is something that
we can avoid.  We know at IO submission time (i.e.
xfs_vm_direct_io)) whether an fsync completion is going to be needed
during Io completion.  The ioend->io_needs_fsync flag can be set
then, and the first pass through xfs_finish_ioend() can queue it to
the correct workqueue.  i.e. it only needs to be queued if it's not
already an unwritten or append ioend and it needs an fsync.

As it is, all the data completion workqueues run the same completion
function so all you need to do is handle the fsync case at the end
of the existing processing - it's not an else case. i.e the end of
xfs_end_io() becomes:

	if (ioend->io_needs_fsync) {
		error = xfs_ioend_fsync(ioend);
		if (error)
			ioend->io_error = -error;
		goto done;
	}
done:
	xfs_destroy_ioend(ioend);

As it is, this code is going to change before these changes go in -
there's a nasty regression in the DIO code that I found this
afternoon that requires reworking this IO completion logic to
avoid. The patch will appear on the list soon....

> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -209,6 +209,7 @@ typedef struct xfs_mount {
>  	struct workqueue_struct	*m_data_workqueue;
>  	struct workqueue_struct	*m_unwritten_workqueue;
>  	struct workqueue_struct	*m_cil_workqueue;
> +	struct workqueue_struct *m_aio_blkdev_flush_wq;

	struct workqueue_struct *m_aio_fsync_wq;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
