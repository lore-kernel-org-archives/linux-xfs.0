Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p051qm6X074438 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 19:52:48 -0600
Subject: Re: [PATCH 5/8] xfs: split direct IO write path from
	xfs_file_aio_write
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294116518-14908-6-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-6-git-send-email-david@fromorbit.com>
Date: Tue, 04 Jan 2011 19:54:55 -0600
Message-ID: <1294192495.2485.726.camel@doink>
Mime-Version: 1.0
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

On Tue, 2011-01-04 at 15:48 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current xfs_file_aio_write code is a mess of locking shenanigans
> to handle the different locking requirements of buffered and direct
> IO. Start to clean this up by disentangling the direct IO path from
> the mess.

All good, very good.  But I'm not sure why you cut
out the code that backed off to buffered I/O if
generic_file_direct_write() returns an error.
(You gave no explanation.)

					-Alex

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_file.c |  168 ++++++++++++++++++++++++++++---------------
>  1 files changed, 110 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index 0d6111e..d546953 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -619,6 +619,110 @@ out_lock:
>  	return error;
>  }
>  
> +/*
> + * xfs_file_dio_aio_write - handle direct IO writes
> + *
> + * Lock the inode appropriately to prepare for and issue a direct IO write.
> + * By spearating it from the buffered write path we remove all the tricky to
         separating

> + * follow locking changes and looping. This also clearly indicates that XFS
> + * does not fall back to buffered IO in the direct IO write path.
> + *
> + * Returns with locks held indicated by @iolock and errors indicated by
> + * negative return values.
> + */
> +STATIC ssize_t
> +xfs_file_dio_aio_write(
> +	struct kiocb		*iocb,
> +	const struct iovec	*iovp,

. . .

> +	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
> +	ret = generic_file_direct_write(iocb, iovp,
> +			&nr_segs, pos, &iocb->ki_pos, count, ocount);
> +
> +	/* No fallback to buffered IO on errors for XFS. */

Why is this?  The previous code did fall back (so this change
is doing more than just splitting out the direct I/O path).

> +	return ret;
> +}
> +
>  STATIC ssize_t
>  xfs_file_aio_write(
>  	struct kiocb		*iocb,

. . .

> @@ -788,6 +839,7 @@ write_retry:
>  
>  	current->backing_dev_info = NULL;
>  
> +done_io:
>  	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
>  
>  	if (ret <= 0)



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
