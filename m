Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbcLAMrn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 07:47:43 -0500
Date: Thu, 1 Dec 2016 07:47:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: Always flush caches when integrity is required
Message-ID: <20161201124740.GD22890@bfoster.bfoster>
References: <20161130225444.15869-1-david@fromorbit.com>
 <20161130225444.15869-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161130225444.15869-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2016 at 09:54:43AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is no reason anymore for not issuing device integrity
> operations when teh filesystem requires ordering or data integrity
> guarantees. We should always issue cache flushes and FUA writes
> where necessary and let the underlying storage optimise them as
> necessary for correct integrity operation.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---

Seems reasonable to me. Just a few nits below..

>  fs/xfs/xfs_buf.c  |  3 +--
>  fs/xfs/xfs_file.c | 29 ++++++++++++-----------------
>  fs/xfs/xfs_log.c  | 36 +++++++++++++++---------------------
>  3 files changed, 28 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a2f0648743db..1264908ef8f2 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1738,8 +1738,7 @@ xfs_free_buftarg(
>  	percpu_counter_destroy(&btp->bt_io_count);
>  	list_lru_destroy(&btp->bt_lru);
>  
> -	if (mp->m_flags & XFS_MOUNT_BARRIER)
> -		xfs_blkdev_issue_flush(btp);
> +	xfs_blkdev_issue_flush(btp);
>  
>  	kmem_free(btp);
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f5effa68e037..2951c483b24b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -149,19 +149,16 @@ xfs_file_fsync(
>  
>  	xfs_iflags_clear(ip, XFS_ITRUNCATED);
>  
> -	if (mp->m_flags & XFS_MOUNT_BARRIER) {
> -		/*
> -		 * If we have an RT and/or log subvolume we need to make sure
> -		 * to flush the write cache the device used for file data
> -		 * first.  This is to ensure newly written file data make
> -		 * it to disk before logging the new inode size in case of
> -		 * an extending write.
> -		 */
> -		if (XFS_IS_REALTIME_INODE(ip))
> -			xfs_blkdev_issue_flush(mp->m_rtdev_targp);
> -		else if (mp->m_logdev_targp != mp->m_ddev_targp)
> -			xfs_blkdev_issue_flush(mp->m_ddev_targp);
> -	}
> +	/*
> +	 * If we have an RT and/or log subvolume we need to make sure to flush
> +	 * the write cache the device used for file data first.  This is to
> +	 * ensure newly written file data make it to disk before logging the new
> +	 * inode size in case of an extending write.
> +	 */
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		xfs_blkdev_issue_flush(mp->m_rtdev_targp);
> +	else if (mp->m_logdev_targp != mp->m_ddev_targp)
> +		xfs_blkdev_issue_flush(mp->m_ddev_targp);
>  
>  	/*
>  	 * All metadata updates are logged, which means that we just have to
> @@ -196,10 +193,8 @@ xfs_file_fsync(
>  	 * an already allocated file and thus do not have any metadata to
>  	 * commit.
>  	 */
> -	if ((mp->m_flags & XFS_MOUNT_BARRIER) &&
> -	    mp->m_logdev_targp == mp->m_ddev_targp &&
> -	    !XFS_IS_REALTIME_INODE(ip) &&
> -	    !log_flushed)
> +	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
> +	    mp->m_logdev_targp == mp->m_ddev_targp)
>  		xfs_blkdev_issue_flush(mp->m_ddev_targp);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 3ebe444eb60f..573d0841851d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1863,25 +1863,21 @@ xlog_sync(
>  	bp->b_io_length = BTOBB(count);
>  	bp->b_fspriv = iclog;
>  	bp->b_flags &= ~(XBF_FUA | XBF_FLUSH);
> -	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
> +	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);

There's no need to clear XBF_FUA on the line above any longer.

>  
> -	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
> -		bp->b_flags |= XBF_FUA;
> -
> -		/*
> -		 * Flush the data device before flushing the log to make
> -		 * sure all meta data written back from the AIL actually made
> -		 * it to disk before stamping the new log tail LSN into the
> -		 * log buffer.  For an external log we need to issue the
> -		 * flush explicitly, and unfortunately synchronously here;
> -		 * for an internal log we can simply use the block layer
> -		 * state machine for preflushes.
> -		 */
> -		if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
> -			xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
> -		else
> -			bp->b_flags |= XBF_FLUSH;
> -	}
> +	/*
> +	 * Flush the data device before flushing the log to make
> +	 * sure all meta data written back from the AIL actually made
> +	 * it to disk before stamping the new log tail LSN into the
> +	 * log buffer.  For an external log we need to issue the
> +	 * flush explicitly, and unfortunately synchronously here;
> +	 * for an internal log we can simply use the block layer
> +	 * state machine for preflushes.
> +	 */

Comment can be rewrapped.

> +	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
> +		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
> +	else
> +		bp->b_flags |= XBF_FLUSH;
>  
>  	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
>  	ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
> @@ -1907,9 +1903,7 @@ xlog_sync(
>  				(char *)&iclog->ic_header + count, split);
>  		bp->b_fspriv = iclog;
>  		bp->b_flags &= ~(XBF_FUA | XBF_FLUSH);

No need to clear XBF_FUA here as well.

Brian

> -		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
> -		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
> -			bp->b_flags |= XBF_FUA;
> +		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
>  
>  		ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
>  		ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
