Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E9F9629DFB
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 12:49:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 86A2DAC001
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 10:49:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jqjFiu1pSCjTK7xC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Apr 2015 10:49:18 -0700 (PDT)
Date: Mon, 6 Apr 2015 13:49:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/8] xfs: add DAX IO path support
Message-ID: <20150406174913.GE58965@bfoster.bfoster>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1427194266-2885-8-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Tue, Mar 24, 2015 at 09:51:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> DAX does not do buffered IO (can't buffer direct access!) and hence
> all read/write IO is vectored through the direct IO path.  Hence we
> need to add the DAX IO path callouts to the direct IO
> infrastructure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c | 35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 3fc5052..97979e9 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1559,6 +1559,30 @@ xfs_end_io_direct_write(
>  	}
>  }
>  
> +static inline ssize_t
> +xfs_vm_do_dio(
> +	struct inode		*inode,
> +	int			rw,
> +	struct kiocb		*iocb,
> +	struct iov_iter		*iter,
> +	loff_t			offset,
> +	void			(*endio)(struct kiocb	*iocb,
> +					 loff_t		offset,
> +					 ssize_t	size,
> +					 void		*private),
> +	int			flags)
> +{
> +	struct block_device	*bdev;
> +
> +	if (IS_DAX(inode))
> +		return dax_do_io(rw, iocb, inode, iter, offset,
> +				 xfs_get_blocks_direct, endio, 0);
> +

I assume this is supposed to be get_blocks_direct and not
get_blocks_dax, based on the I/O codepath. The naming is starting to get
a little confusing though. xfs_get_blocks_dax() implies to me that it's
for any DAX I/O, but we only appear to use it internally for
truncate/zeroing/mmap and such. Alas, I can't think of a better name atm
and the code seems Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

... but a comment somewhere around here and/or at the
xfs_get_blocks_dax() function would be helpful.

Brian

> +	bdev = xfs_find_bdev_for_inode(inode);
> +	return  __blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
> +				     xfs_get_blocks_direct, endio, NULL, flags);
> +}
> +
>  STATIC ssize_t
>  xfs_vm_direct_IO(
>  	int			rw,
> @@ -1567,17 +1591,12 @@ xfs_vm_direct_IO(
>  	loff_t			offset)
>  {
>  	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> -	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
>  
>  	if (rw & WRITE) {
> -		return __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
> -					    offset, xfs_get_blocks_direct,
> -					    xfs_end_io_direct_write, NULL,
> -					    DIO_ASYNC_EXTEND);
> +		return xfs_vm_do_dio(inode, rw, iocb, iter, offset,
> +				     xfs_end_io_direct_write, DIO_ASYNC_EXTEND);
>  	}
> -	return __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
> -				    offset, xfs_get_blocks_direct,
> -				    NULL, NULL, 0);
> +	return xfs_vm_do_dio(inode, rw, iocb, iter, offset, NULL, 0);
>  }
>  
>  /*
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
