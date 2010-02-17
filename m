Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H3rw5a202745 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 21:53:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 154481CD8178
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 19:55:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	BK4vKfnp1DkQ2txx for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 19:55:14 -0800 (PST)
Date: Wed, 17 Feb 2010 14:55:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] [PATCH 2/4] xfs: remove wrappers for read/write
	file operations
Message-ID: <20100217035511.GJ28392@discord.disaster>
References: <20100215094445.528696829@bombadil.infradead.org>
	<20100215094604.318261333@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100215094604.318261333@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 15, 2010 at 04:44:47AM -0500, Christoph Hellwig wrote:
> Currently the aio_read, aio_write, splice_read and splice_write file
> operations are divided into a low-level routine doing all the work and
> one that implements the Linux file operations and does minimal argument
> wrapping.  This is a leftover from the days of the vnode operations layer
> and can be removed to simplify the code a lot.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

One main issue I see:

....

> -ssize_t				/* bytes written, or (-) error */
> -xfs_write(
> -	struct xfs_inode	*xip,
> +STATIC ssize_t
> +xfs_file_aio_write(
>  	struct kiocb		*iocb,
>  	const struct iovec	*iovp,
> -	unsigned int		nsegs,
> -	loff_t			*offset,
> -	int			ioflags)
> +	unsigned long		nr_segs,
> +	loff_t			pos)
>  {
>  	struct file		*file = iocb->ki_filp;
>  	struct address_space	*mapping = file->f_mapping;
>  	struct inode		*inode = mapping->host;
> -	unsigned long		segs = nsegs;
> -	xfs_mount_t		*mp;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
>  	ssize_t			ret = 0, error = 0;
> +	int			ioflags = 0;
>  	xfs_fsize_t		isize, new_size;
>  	int			iolock;
>  	int			eventsent = 0;
>  	size_t			ocount = 0, count;
> -	loff_t			pos;
>  	int			need_i_mutex;
>  
>  	XFS_STATS_INC(xs_write_calls);
>  
> -	error = generic_segment_checks(iovp, &segs, &ocount, VERIFY_READ);
> +	BUG_ON(iocb->ki_pos != pos);

You've changed a local variable "pos" which had the value
iocb->ki_pos to a function parameter of the same name which has a
different value.  Given this, all the existing uses of "pos" in this
function need to be converted to "iocb->ki_pos" as the old
xfs_write() never saw the original "pos" variable passed to
xfs_file_aio_write().

.....

> @@ -535,30 +550,30 @@ relock:
>  		mutex_lock(&inode->i_mutex);
>  	}
>  
> -	xfs_ilock(xip, XFS_ILOCK_EXCL|iolock);
> +	xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
>  
>  start:
>  	error = -generic_write_checks(file, &pos, &count,
>  					S_ISBLK(inode->i_mode));

Such as here. Actually, I'm surprised the compiler let you take
the address of a function parameter considering parameters may be
passed in registers....

>  	if (error) {
> -		xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
>  		goto out_unlock_mutex;
>  	}
>  
> -	if ((DM_EVENT_ENABLED(xip, DM_EVENT_WRITE) &&
> +	if ((DM_EVENT_ENABLED(ip, DM_EVENT_WRITE) &&
>  	    !(ioflags & IO_INVIS) && !eventsent)) {
>  		int		dmflags = FILP_DELAY_FLAG(file);
>  
>  		if (need_i_mutex)
>  			dmflags |= DM_FLAGS_IMUX;
>  
> -		xfs_iunlock(xip, XFS_ILOCK_EXCL);
> -		error = XFS_SEND_DATA(xip->i_mount, DM_EVENT_WRITE, xip,
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		error = XFS_SEND_DATA(ip->i_mount, DM_EVENT_WRITE, ip,
>  				      pos, count, dmflags, &iolock);

And here. There's lots of others that haven't been converted - can
you make sure you get them all?

> @@ -642,16 +657,16 @@ start:
>  
>  		if (need_i_mutex) {
>  			/* demote the lock now the cached pages are gone */
> -			xfs_ilock_demote(xip, XFS_IOLOCK_EXCL);
> +			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  			mutex_unlock(&inode->i_mutex);
>  
>  			iolock = XFS_IOLOCK_SHARED;
>  			need_i_mutex = 0;
>  		}
>  
> -		trace_xfs_file_direct_write(xip, count, *offset, ioflags);
> +		trace_xfs_file_direct_write(ip, count, iocb->ki_pos, ioflags);
>  		ret = generic_file_direct_write(iocb, iovp,
> -				&segs, pos, offset, count, ocount);
> +				&nr_segs, pos, &iocb->ki_pos, count, ocount);

But you did convert some ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
