Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57244 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfDPPOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 11:14:52 -0400
Date: Tue, 16 Apr 2019 08:14:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: serialize unaligned dio writes against all other
 dio writes
Message-ID: <20190416151434.GM4752@magnolia>
References: <20190325172448.55284-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325172448.55284-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 25, 2019 at 01:24:48PM -0400, Brian Foster wrote:
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
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
> 
> v2:
> - Use dio return value instead of I/O type in wait logic.
> - Drop spurious else logic and fix up comments.
> v1: https://marc.info/?l=linux-xfs&m=155327356800415&w=2
> 
>  fs/xfs/xfs_file.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 770cc2edf777..933d9c467f56 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -529,18 +529,17 @@ xfs_file_dio_aio_write(
>  	count = iov_iter_count(from);
>  
>  	/*
> -	 * If we are doing unaligned IO, wait for all other IO to drain,
> -	 * otherwise demote the lock if we had to take the exclusive lock
> -	 * for other reasons in xfs_file_aio_write_checks.
> +	 * If we are doing unaligned IO, we can't allow any other overlapping IO
> +	 * in-flight at the same time or we risk data corruption. Wait for all
> +	 * other IO to drain before we submit. If the IO is aligned, demote the
> +	 * iolock if we had to take the exclusive lock in
> +	 * xfs_file_aio_write_checks() for other reasons.
>  	 */
>  	if (unaligned_io) {
> -		/* If we are going to wait for other DIO to finish, bail */
> -		if (iocb->ki_flags & IOCB_NOWAIT) {
> -			if (atomic_read(&inode->i_dio_count))
> -				return -EAGAIN;
> -		} else {
> -			inode_dio_wait(inode);
> -		}
> +		/* unaligned dio always waits, bail */
> +		if (iocb->ki_flags & IOCB_NOWAIT)
> +			return -EAGAIN;

Hmm, Dave pointed out on IRC that this looks like we're bailing out with
*iolock held.  I took another look at the function and wondered why
wouldn't we bail out as soon as we know that we're doing unaligned
nowait directio, which is before we take all the locks and such?

--D

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cdcc75735521..c586fd9f244c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -517,7 +517,8 @@ xfs_file_dio_aio_write(
        }
 
        if (iocb->ki_flags & IOCB_NOWAIT) {
-               if (!xfs_ilock_nowait(ip, iolock))
+               /* unaligned dio always waits, bail */
+               if (unaligned_io || !xfs_ilock_nowait(ip, iolock))
                        return -EAGAIN;
        } else {
                xfs_ilock(ip, iolock);
@@ -536,9 +537,6 @@ xfs_file_dio_aio_write(
         * xfs_file_aio_write_checks() for other reasons.
         */
        if (unaligned_io) {
-               /* unaligned dio always waits, bail */
-               if (iocb->ki_flags & IOCB_NOWAIT)
-                       return -EAGAIN;
                inode_dio_wait(inode);
        } else if (iolock == XFS_IOLOCK_EXCL) {
                xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);


> +		inode_dio_wait(inode);
>  	} else if (iolock == XFS_IOLOCK_EXCL) {
>  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  		iolock = XFS_IOLOCK_SHARED;
> @@ -548,6 +547,14 @@ xfs_file_dio_aio_write(
>  
>  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
>  	ret = iomap_dio_rw(iocb, from, &xfs_iomap_ops, xfs_dio_write_end_io);
> +
> +	/*
> +	 * If unaligned, this is the only IO in-flight. If it has not yet
> +	 * completed, wait on it before we release the iolock to prevent
> +	 * subsequent overlapping IO.
> +	 */
> +	if (ret == -EIOCBQUEUED && unaligned_io)
> +		inode_dio_wait(inode);
>  out:
>  	xfs_iunlock(ip, iolock);
>  
> -- 
> 2.17.2
> 
