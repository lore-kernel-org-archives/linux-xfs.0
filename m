Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BK9R6x003226 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 15:09:27 -0500
Subject: Re: [PATCH 2/2] xfs: don't serialise adjacent concurrent direct IO
	appending writes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1312785628-10561-3-git-send-email-david@fromorbit.com>
References: <1312785628-10561-1-git-send-email-david@fromorbit.com>
	<1312785628-10561-3-git-send-email-david@fromorbit.com>
Date: Thu, 11 Aug 2011 15:09:15 -0500
Message-ID: <1313093355.2899.92.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-08-08 at 16:40 +1000, Dave Chinner wrote:
> For append write workloads, extending the file requires a certain
> amount of exclusive locking to be done up front to ensure sanity in
> things like ensuring that we've zeroed any allocated regions
> between the old EOF and the start of the new IO.
> 
> For single threads, this typically isn't a problem, and for large
> IOs we don't serialise enough for it to be a problem for two
> threads on really fast block devices. However for smaller IO and
> larger thread counts we have a problem.
> 
> Take 4 concurrent sequential, single block sized and aligned IOs.
> After the first IO is submitted but before it completes, we end up
> with this state:
> 
>         IO 1    IO 2    IO 3    IO 4
>       +-------+-------+-------+-------+
>       ^       ^
>       |       |
>       |       |
>       |       |
>       |       \- ip->i_new_size
>       \- ip->i_size
> 
> And the IO is done without exclusive locking because offset <=
> ip->i_size. When we submit IO 2, we see offset > ip->i_size, and
> grab the IO lock exclusive, because there is a chance we need to do
> EOF zeroing. However, there is already an IO in progress that avoids
> the need for IO zeroing because offset <= ip->i_new_size. hence we
> could avoid holding the IO lock exlcusive for this. Hence after
> submission of the second IO, we'd end up this state:
> 
>         IO 1    IO 2    IO 3    IO 4
>       +-------+-------+-------+-------+
>       ^               ^
>       |               |
>       |               |
>       |               |
>       |               \- ip->i_new_size
>       \- ip->i_size
> 
> There is no need to grab the i_mutex of the IO lock in exclusive
> mode if we don't need to invalidate the page cache. Taking these
> locks on every direct IO effective serialises them as taking the IO
> lock in exclusive mode has to wait for all shared holders to drop
> the lock. That only happens when IO is complete, so effective it
> prevents dispatch of concurrent direct IO writes to the same inode.
> 
> And so you can see that for the third concurrent IO, we'd avoid
> exclusive locking for the same reason we avoided the exclusive lock
> for the second IO.
> 
> Fixing this is a bit more complex than that, because we need to hold
> a write-submission local value of ip->i_new_size to that clearing
> the value is only done if no other thread has updated it before our
> IO completes.....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I have several suggestions below, but they are all
minor--mostly ways to re-phrase comments.  I'd like
to see an update of this patch, but you can consider
it reviewed by me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/linux-2.6/xfs_aops.c |    7 ++++
>  fs/xfs/linux-2.6/xfs_file.c |   73 +++++++++++++++++++++++++++++++++---------
>  2 files changed, 64 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
> index 63e971e..dda9a9e 100644
> --- a/fs/xfs/linux-2.6/xfs_aops.c
> +++ b/fs/xfs/linux-2.6/xfs_aops.c
> @@ -176,6 +176,13 @@ xfs_setfilesize(
>  	if (unlikely(ioend->io_error))
>  		return 0;
>  
> +	/*
> +	 * If the IO is clearly not beyond the on-disk inode size,
> +	 * return before we take locks.
> +	 */
> +	if (ioend->io_offset + ioend->io_size <= ip->i_d.di_size)
> +		return 0;
> +

This hunk is a good change, independent of the rest
of this patch.

>  	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>  		return EAGAIN;
>  
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index a1dea10..62a5022 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c

. . .

> @@ -677,6 +680,8 @@ xfs_file_aio_write_checks(
>  	xfs_fsize_t		new_size;
>  	int			error = 0;
>  
> +restart:
> +	*new_sizep = 0;

	*new_sizep = 0;
restart:

>  	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
>  	if (error) {
>  		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
> @@ -684,20 +689,41 @@ xfs_file_aio_write_checks(
>  		return error;
>  	}
>  
> -	new_size = *pos + *count;
> -	if (new_size > ip->i_size)
> -		ip->i_new_size = new_size;
> -
>  	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
>  		file_update_time(file);
>  
>  	/*
>  	 * If the offset is beyond the size of the file, we need to zero any
>  	 * blocks that fall between the existing EOF and the start of this
> -	 * write.
> +	 * write. Don't issue zeroing if this IO is adjacent to an IO already in
> +	 * flight. If we are currently holding the iolock shared, we need to

Maybe:
	 * write.  There is no need to issue zeroing if another
	 * in-flight IO ends at or before this one.  If zeroing
	 * is needed, and we are currently holding...

> +	 * update it to exclusive which involves dropping all locks and
> +	 * relocking to maintain correct locking order. If we do this, restart
> +	 * the function to ensure all checks and values are still valid.
>  	 */
> -	if (*pos > ip->i_size)
> +	if ((ip->i_new_size && *pos > ip->i_new_size) ||
> +	    (!ip->i_new_size && *pos > ip->i_size)) {
> +		if (*iolock == XFS_IOLOCK_SHARED) {
> +			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
> +			*iolock = XFS_IOLOCK_EXCL;
> +			xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
> +			goto restart;
> +		}
>  		error = -xfs_zero_eof(ip, *pos, ip->i_size);
> +	}
> +
> +	/*
> +	 * Now we have zeroed beyond EOF as necessary, update the ip->i_new_size
> +	 * only if it is larger than any other concurrent write beyond EOF.
> +	 * Regardless of whether we update ip->i_new_size, return the updated
> +	 * new_size to the caller.

Maybe:
	 * If this IO extends beyond EOF, we may need to update
	 * ip->i_new_size.  We have already zeroed space beyond
	 * EOF (if necessary).  Only update ip->i_new_size if
	 * this IO ends beyond any other in-flight writes.

> +	 */
> +	new_size = *pos + *count;
> +	if (new_size > ip->i_size) {
> +		if (new_size > ip->i_new_size)
> +			ip->i_new_size = new_size;
		/*
		 * Tell the caller that this write goes beyond
		 * EOF, and what the size would become as a
		 * result of *this* IO.
		 */ 
> +		*new_sizep = new_size;
> +	}
>  
>  	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (error)

. . .

> @@ -764,13 +791,25 @@ xfs_file_dio_aio_write(
>  	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
>  		unaligned_io = 1;
>  
> -	if (unaligned_io || mapping->nrpages || pos > ip->i_size)
> +	/*
> +	 * Tricky locking alert: if we are doing multiple concurrent sequential
> +	 * writes (e.g. via aio), we don't need to do EOF zeroing if the current
> +	 * IO is adjacent to an in-flight IO. That means for such IO we can
> +	 * avoid taking the IOLOCK exclusively. Hence we avoid checking for
> +	 * writes beyond EOF at this point when deciding what lock to take.
> +	 * We will take the IOLOCK exclusive later if necessary.
> +	 *
> +	 * This, however, means that we need a local copy of the ip->i_new_size
> +	 * value from this IO if we change it so that we can determine if we can
> +	 * clear the value from the inode when this IO completes.

This comment seems out of place here, or maybe it just
emphasizes the wrong thing.  What we need to know here is
that we don't need to take the exclusive IO lock here
even for writes unless there are pages in the page cache
that need to be invalidated.  xfs_file_aio_write_checks()
will take care of zeroing space between the current EOF
and the start of this write if necessary, "promoting" the
lock if needed to get that done.

That function fills in the new_size value needed by our
caller in order to coordinate updating the inode's size
once this IO completes.

(Maybe you can massage this to come up with a different
comment that satisfies both of us.)

> +	 */
> +	if (unaligned_io || mapping->nrpages)
>  		*iolock = XFS_IOLOCK_EXCL;
>  	else
>  		*iolock = XFS_IOLOCK_SHARED;
>  	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
>  
> -	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
> +	ret = xfs_file_aio_write_checks(file, &pos, &count, new_size, iolock);
>  	if (ret)
>  		return ret;
>  

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
