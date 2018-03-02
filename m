Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163227AbeCBRF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 12:05:27 -0500
Date: Fri, 2 Mar 2018 09:05:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180302170520.GR19312@magnolia>
References: <20180301014144.28892-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180301014144.28892-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org

On Thu, Mar 01, 2018 at 12:41:44PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we are doing direct IO writes with datasync semantics, we often
> have to flush metadata changes along with the data write. However,
> if we are overwriting existing data, there are no metadata changes
> that we need to flush. In this case, optimising the IO by using
> FUA write makes sense.
> 
> We know from teh IOMAP_F_DIRTY flag as to whether a specific inode
> requires a metadata flush - this is currently used by DAX to ensure
> extent modi$fication as stable in page fault operations. For direct

           ^^^^ modification

> IO writes, we can use it to determine if we need to flush metadata
> or not once the data is on disk.
> 
> Hence if we have been returned a mapped extent that is not new and
> the IO mapping is not dirty, then we can use a FUA write to provide
> datasync semantics. This allows us to short-cut the
> generic_write_sync() call in IO completion and hence avoid
> unnecessary operations. This makes pure direct IO data write
> behaviour identical to the way block devices use REQ_FUA to provide
> datasync semantics.
> 
> Now that iomap_dio_rw() is determining if REQ_FUA can be used, we
> have to stop issuing generic_write_sync() calls from the XFS code
> when REQ_FUA is issued, otherwise it will still throw a cache flush
> to the device via xfs_file_fsync(). To do this, we need to make
> iomap_dio_rw() always responsible for issuing generic_write_sync()
> when necessary, not just for AIO calls. This means the filesystem
> doesn't have to guess when cache flushes are necessary now.
> 
> On a FUA enabled device, a synchronous direct IO write workload
> (sequential 4k overwrites in 32MB file) had the following results:
> 
> # xfs_io -fd -c "pwrite -V 1 -D 0 32m" /mnt/scratch/boo
> 
> kernel		time	write()s	write iops	Write b/w
> ------		----	--------	----------	---------
> (no dsync)	 4s	2173/s		2173		8.5MB/s
> vanilla		22s	 370/s		 750		1.4MB/s
> patched		19s	 420/s		 420		1.6MB/s
> 
> The patched code clearly doesn't send cache flushes anymore, but
> instead uses FUA (confirmed via blktrace), and performance improves
> a bit as a result. However, the benefits will be higher on workloads
> that mix O_DSYNC overwrites with other write IO as we won't be
> flushing the entire device cache on every DSYNC overwrite IO
> anymore.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/iomap.c        | 38 +++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_file.c |  5 +++++
>  2 files changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index afd163586aa0..bcc90e3a2e3f 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -685,6 +685,7 @@ EXPORT_SYMBOL_GPL(iomap_seek_data);
>   * Private flags for iomap_dio, must not overlap with the public ones in
>   * iomap.h:
>   */
> +#define IOMAP_DIO_WRITE_FUA	(1 << 29)
>  #define IOMAP_DIO_WRITE		(1 << 30)
>  #define IOMAP_DIO_DIRTY		(1 << 31)
>  
> @@ -760,8 +761,19 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
>  	}
>  
>  	inode_dio_end(file_inode(iocb->ki_filp));
> -	kfree(dio);
>  
> +	/*
> +	 * If a FUA write was done, then that is all we required for datasync
> +	 * semantics -. we don't need to call generic_write_sync() to complete

Minor nit: space-dash-period.

Looks ok to me, but does anyone else have comments?  (Looking at hch
here. ;))

--D

> +	 * the write.
> +	 */
> +	if (ret > 0 &&
> +	    (dio->flags & (IOMAP_DIO_WRITE|IOMAP_DIO_WRITE_FUA)) ==
> +							IOMAP_DIO_WRITE) {
> +		ret = generic_write_sync(iocb, ret);
> +	}
> +
> +	kfree(dio);
>  	return ret;
>  }
>  
> @@ -769,12 +781,9 @@ static void iomap_dio_complete_work(struct work_struct *work)
>  {
>  	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
>  	struct kiocb *iocb = dio->iocb;
> -	bool is_write = (dio->flags & IOMAP_DIO_WRITE);
>  	ssize_t ret;
>  
>  	ret = iomap_dio_complete(dio);
> -	if (is_write && ret > 0)
> -		ret = generic_write_sync(iocb, ret);
>  	iocb->ki_complete(iocb, ret, 0);
>  }
>  
> @@ -883,6 +892,15 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>  			dio->flags |= IOMAP_DIO_COW;
>  		if (iomap->flags & IOMAP_F_NEW)
>  			need_zeroout = true;
> +		/*
> +		 * Use a FUA write if we need datasync semantics and this is a
> +		 * pure data IO that doesn't require any metadata updates. This
> +		 * allows us to avoid cache flushes on IO completion.
> +		 */
> +		else if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
> +			 (dio->flags & IOMAP_DIO_WRITE) &&
> +			 (dio->iocb->ki_flags & IOCB_DSYNC))
> +			dio->flags |= IOMAP_DIO_WRITE_FUA;
>  		break;
>  	default:
>  		WARN_ON_ONCE(1);
> @@ -930,7 +948,11 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>  
>  		n = bio->bi_iter.bi_size;
>  		if (dio->flags & IOMAP_DIO_WRITE) {
> -			bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
> +			int op_flags = REQ_SYNC | REQ_IDLE;
> +
> +			if (dio->flags & IOMAP_DIO_WRITE_FUA)
> +				op_flags |= REQ_FUA;
> +			bio_set_op_attrs(bio, REQ_OP_WRITE, op_flags);
>  			task_io_account_write(n);
>  		} else {
>  			bio_set_op_attrs(bio, REQ_OP_READ, 0);
> @@ -961,6 +983,12 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>  	return copied;
>  }
>  
> +/*
> + * iomap_dio_rw() always completes O_[D]SYNC writes regardless of whether the IO
> + * is being issued as AIO or not. This allows us to optimise pure data writes to
> + * use REQ_FUA rather than requiring generic_write_sync() to issue a REQ_FLUSH
> + * post write.
> + */
>  ssize_t
>  iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		const struct iomap_ops *ops, iomap_dio_end_io_t end_io)
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 260ff5e5c264..81aa3b73471e 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -732,6 +732,11 @@ xfs_file_write_iter(
>  		ret = xfs_file_dio_aio_write(iocb, from);
>  		if (ret == -EREMCHG)
>  			goto buffered;
> +		/*
> +		 * Direct IO handles sync type writes internally on I/O
> +		 * completion.
> +		 */
> +		return ret;
>  	} else {
>  buffered:
>  		ret = xfs_file_buffered_aio_write(iocb, from);
> -- 
> 2.16.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
