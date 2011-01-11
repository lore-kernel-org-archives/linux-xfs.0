Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0BHYGMX103372 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 11:34:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54F5E153DE4E
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:36:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GAIYxExqqoF6EeNR for
	<xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:36:29 -0800 (PST)
Date: Tue, 11 Jan 2011 12:36:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] xfs: introduce xfs_rw_lock() helpers for locking the
	inode
Message-ID: <20110111173627.GB24025@infradead.org>
References: <1294702668-15216-1-git-send-email-david@fromorbit.com>
	<1294702668-15216-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294702668-15216-5-git-send-email-david@fromorbit.com>
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

On Tue, Jan 11, 2011 at 10:37:44AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We need to obtain the i_mutex, i_iolock and i_ilock during the read
> and write paths. Add a set of wrapper functions to neatly
> encapsulate the lock ordering and shared/exclusive semantics to make
> the locking easier to follow and get right.
> 
> Note that this changes some of the exclusive locking serialisation in
> that serialisation will occur against the i_mutex instead of the
> XFS_IOLOCK_EXCL. This does not change any behaviour, and it is
> arguably more efficient to use the mutex for such serialisation than
> the rw_sem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_file.c |  136 ++++++++++++++++++++++++++-----------------
>  1 files changed, 82 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index c47d7dc0..941d7c2 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -41,6 +41,40 @@
>  static const struct vm_operations_struct xfs_file_vm_ops;
>  
>  /*
> + * Locking primitives for read and write IO paths to ensure we consistently use
> + * and order the inode->i_mutex, ip->i_lock and ip->i_iolock.
> + */
> +static inline void
> +xfs_rw_ilock(
> +	struct xfs_inode	*ip,
> +	int			type)
> +{
> +	if (type & XFS_IOLOCK_EXCL)
> +		mutex_lock(&VFS_I(ip)->i_mutex);
> +	xfs_ilock(ip, type);
> +}
> +
> +static inline void
> +xfs_rw_iunlock(
> +	struct xfs_inode	*ip,
> +	int			type)
> +{
> +	xfs_iunlock(ip, type);
> +	if (type & XFS_IOLOCK_EXCL)
> +		mutex_unlock(&VFS_I(ip)->i_mutex);
> +}
> +
> +static inline void
> +xfs_rw_ilock_demote(
> +	struct xfs_inode	*ip,
> +	int			type)
> +{
> +	xfs_ilock_demote(ip, type);
> +	if (type & XFS_IOLOCK_EXCL)
> +		mutex_unlock(&VFS_I(ip)->i_mutex);
> +}
> +
> +/*
>   *	xfs_iozero
>   *
>   *	xfs_iozero clears the specified range of buffer supplied,
> @@ -262,22 +296,21 @@ xfs_file_aio_read(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	if (unlikely(ioflags & IO_ISDIRECT))
> -		mutex_lock(&inode->i_mutex);
> -	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -
>  	if (unlikely(ioflags & IO_ISDIRECT)) {
> +		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
> +
>  		if (inode->i_mapping->nrpages) {
>  			ret = -xfs_flushinval_pages(ip,
>  					(iocb->ki_pos & PAGE_CACHE_MASK),
>  					-1, FI_REMAPF_LOCKED);
> +			if (ret) {
> +				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
> +				return ret;
> +			}
>  		}
> -		mutex_unlock(&inode->i_mutex);
> -		if (ret) {
> -			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> -			return ret;
> -		}
> -	}
> +		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
> +	} else
> +		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
>  
>  	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
>  
> @@ -285,7 +318,7 @@ xfs_file_aio_read(
>  	if (ret > 0)
>  		XFS_STATS_ADD(xs_read_bytes, ret);
>  
> -	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
>  	return ret;
>  }
>  
> @@ -309,7 +342,7 @@ xfs_file_splice_read(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
>  
>  	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
>  
> @@ -317,7 +350,7 @@ xfs_file_splice_read(
>  	if (ret > 0)
>  		XFS_STATS_ADD(xs_read_bytes, ret);
>  
> -	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
>  	return ret;
>  }
>  
> @@ -338,10 +371,10 @@ xfs_aio_write_isize_update(
>  		*ppos = isize;
>  
>  	if (*ppos > ip->i_size) {
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
>  		if (*ppos > ip->i_size)
>  			ip->i_size = *ppos;
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
>  }
>  
> @@ -356,14 +389,22 @@ xfs_aio_write_newsize_update(
>  	struct xfs_inode	*ip)
>  {
>  	if (ip->i_new_size) {
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
>  		ip->i_new_size = 0;
>  		if (ip->i_d.di_size > ip->i_size)
>  			ip->i_d.di_size = ip->i_size;
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
>  }
>  
> +/*
> + * xfs_file_splice_write() does not use xfs_rw_ilock() because
> + * generic_file_splice_write() takes the i_mutex itself. This, in theory,
> + * couuld cause lock inversions between the aio_write path and the splice path
> + * if someone is doing concurrent splice(2) based writes and write(2) based
> + * writes to the same inode. The only real way to fix this is to re-implement
> + * the generic code here with correct locking orders.
> + */
>  STATIC ssize_t
>  xfs_file_splice_write(
>  	struct pipe_inode_info	*pipe,
> @@ -386,14 +427,13 @@ xfs_file_splice_write(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +	xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL);
>  
>  	new_size = *ppos + count;
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	if (new_size > ip->i_size)
>  		ip->i_new_size = new_size;
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);

While using the xfs_rw_iunlock here actually is correct I think it's
highly confusing, given that we didn't use it to take the ilock.  What
about just leaving all the code in xfs_file_splice_write as-is and not
touching it at all?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
