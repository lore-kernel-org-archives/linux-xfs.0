Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKAMFRW139705 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 04:22:15 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id RpACMRH6bBr1c158 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 02:24:23 -0800 (PST)
Date: Tue, 20 Nov 2012 11:24:20 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/9] xfs: honor the O_SYNC flag for aysnchronous direct
	I/O requests
Message-ID: <20121120102420.GD1408@quack.suse.cz>
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
Cc: axboe@kernel.dk, djwong+kernel@djwong.org, xfs@oss.sgi.com, tytso@mit.edu, bpm@sgi.com, linux-kernel@vger.kernel.org, hch@infradead.org, jmoyer@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org

On Mon 19-11-12 23:51:14, Darrick J. Wong wrote:
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
> +STATIC bool
> +xfs_ioend_needs_cache_flush(
> +	struct xfs_ioend	*ioend)
> +{
> +	struct xfs_inode *ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount *mp = ip->i_mount;
> +
> +	if (!(mp->m_flags & XFS_MOUNT_BARRIER))
> +		return false;
> +
> +	return IS_SYNC(ioend->io_inode) ||
> +	       (ioend->io_iocb->ki_filp->f_flags & O_DSYNC);
> +}
  I'm not really a XFS developer but calling things "...cache_flush" when
you actually mean fsync is IMHO misleading.

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
> +	xfs_ioend_t	*ioend)
> +{
> +	struct xfs_inode *ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount *mp = ip->i_mount;
> +	int		err = 0;
> +	int		datasync;
> +
> +	datasync = !IS_SYNC(ioend->io_inode) &&
> +		!(ioend->io_iocb->ki_filp->f_flags & __O_SYNC);
> +	err = do_xfs_file_fsync(ip, mp, datasync);
> +	xfs_destroy_ioend(ioend);
> +	/* do_xfs_file_fsync returns -errno. our caller expects positive. */
> +	return -err;
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
>  }
  Umm, I don't quite get why you do things the way you do in xfs_end_io().
Why don't you handle fsync there always but offload it instead to workqueue
again in some cases? Is it so that it gets processed in the right workqueue
or why?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
