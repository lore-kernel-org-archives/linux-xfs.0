Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:56253 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726743AbfCXU7b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Mar 2019 16:59:31 -0400
Date: Mon, 25 Mar 2019 07:59:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: serialize unaligned dio writes against all other
 dio writes
Message-ID: <20190324205926.GY23020@dastard>
References: <20190322165242.40662-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322165242.40662-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>

On Fri, Mar 22, 2019 at 12:52:42PM -0400, Brian Foster wrote:
> XFS applies more strict serialization constraints to unaligned
> direct writes to accommodate things like direct I/O layer zeroing,
> unwritten extent conversion, etc. Unaligned submissions acquire the
> exclusive iolock and wait for in-flight dio to complete to ensure
> multiple submissions do not race on the same block and cause data
> corruption.
> 
> This generally works in the case of an aligned dio followed by an
> unaligned dio, but the serialization is lost if I/Os occur in the
> opposite order. If an unaligned write is submitted first and
> immediately followed by an overlapping, aligned write, the latter
> submits without the typical unaligned serialization barriers because
> there is no indication of an unaligned dio still in-flight. This can
> lead to unpredictable results.
> 
> To provide proper unaligned dio serialization, require that such
> direct writes are always the only dio allowed in-flight at one time
> for a particular inode. We already acquire the exclusive iolock and
> drain pending dio before submitting the unaligned dio. Wait once
> more after the dio submission to hold the iolock across the I/O and
> prevent further submissions until the unaligned I/O completes. This
> is heavy handed, but consistent with the current pre-submission
> serialization for unaligned direct writes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> I was originally going to deal with this problem by hacking in an inode
> flag to track unaligned dio writes in-flight and use that to block any
> follow on dio writes until cleared. Dave suggested we could use the
> iolock to serialize by converting unaligned async dio writes to sync dio
> writes and just letting the unaligned dio itself always block. That
> seemed reasonable to me, but I morphed the approach slightly to just use
> inode_dio_wait() because it seemed a bit cleaner. Thoughts?
> 
> Zorro,
> 
> You reproduced this problem originally. It addresses the problem in the
> test case that reproduced for me. Care to confirm whether this patch
> fixes the problem for you? Thanks.
> 
> Brian
> 
>  fs/xfs/xfs_file.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 770cc2edf777..8b2aaed82343 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -529,18 +529,19 @@ xfs_file_dio_aio_write(
>  	count = iov_iter_count(from);
>  
>  	/*
> -	 * If we are doing unaligned IO, wait for all other IO to drain,
> -	 * otherwise demote the lock if we had to take the exclusive lock
> -	 * for other reasons in xfs_file_aio_write_checks.
> +	 * If we are doing unaligned IO, we can't allow any other IO in-flight

* any other overlapping IO in-flight

> +	 * at the same time or we risk data corruption. Wait for all other IO to
> +	 * drain, submit and wait for completion before we release the iolock.
> +	 *
> +	 * If the IO is aligned, demote the iolock if we had to take the
> +	 * exclusive lock in xfs_file_aio_write_checks() for other reasons.
>  	 */
>  	if (unaligned_io) {
> -		/* If we are going to wait for other DIO to finish, bail */
> -		if (iocb->ki_flags & IOCB_NOWAIT) {
> -			if (atomic_read(&inode->i_dio_count))
> -				return -EAGAIN;
> -		} else {
> +		/* unaligned dio always waits, bail */
> +		if (iocb->ki_flags & IOCB_NOWAIT)
> +			return -EAGAIN;
> +		else
>  			inode_dio_wait(inode);
> -		}
>  	} else if (iolock == XFS_IOLOCK_EXCL) {
>  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  		iolock = XFS_IOLOCK_SHARED;
> @@ -548,6 +549,8 @@ xfs_file_dio_aio_write(
>  
>  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
>  	ret = iomap_dio_rw(iocb, from, &xfs_iomap_ops, xfs_dio_write_end_io);
> +	if (unaligned_io && !is_sync_kiocb(iocb))
> +		inode_dio_wait(inode);

If it's AIO and it has already been completed, then this wait is
unnecessary. i.e. we only need to wait in the case where AIO has
been queued but not completed:

	/*
	 * If we are doing unaligned IO, it will be the only IO in
	 * progress right now. If it has not completed yet, wait on
	 * it before we drop the IOLOCK.
	 */
	if (ret == -EIOCBQUEUED && unaligned_io)
		inode_dio_wait(inode);

Next question: do we need to change the return value here to reflect
the actual completion result?

Hmmmm.  iomap_dio_complete() will return either the IO byte count or
an error for synchronous IO. And for AIO, ki->complete will only be
called by the iomap bio completion path if it's the last reference.
So for AIO that is completed before the submitter returns, it will
return the result of iomap_dio_complete() without having called
iocb->ki_complete(). Which means we want to return a byte count or
IO error to the higher layers, and that will result in
aio_read/aio_write calling aio_rw_done() and calling the completion
appropriately.

Ok, so we don't need to futz with the return value, and we only
need to check for ret == -EIOCBQUEUED to determine if we should wait
or not, because any other return value indicates either IO completion
or an error has already occurred.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
