Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p051qXh0074397 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 19:52:33 -0600
Subject: Re: [PATCH 4/8] xfs: introduce xfs_rw_lock() helpers for locking
	the inode
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294116518-14908-5-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-5-git-send-email-david@fromorbit.com>
Date: Tue, 04 Jan 2011 19:54:41 -0600
Message-ID: <1294192481.2485.721.camel@doink>
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
> We need to obtain the i_mutex, i_iolock and i_ilock during the read
> and write paths. Add a set of wrapper functions to neatly
> encapsulate the lock ordering and shared/exclusive semantics to make
> the locking easier to follow and get right.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I like this change, but I think you missed a lock call.
I also notice there are some locking differences, and
I don't really question them but I wonder if you can
offer a little more explanation.

> ---
>  fs/xfs/linux-2.6/xfs_file.c |  123 ++++++++++++++++++++++++-------------------
>  1 files changed, 68 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index 33a688c..0d6111e 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c

. . .

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

Previously only XFS_IOLOCK_SHARED was used here.
I understand that using the IOLOCK_EXCL now gets
the desired mutex_lock() call.  Is the previous
code in error here though?  Can you anticipate
any different behavior because of this lock change?
Does this specific change justify separating it
into a small patch just before this one?

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

. . .

> @@ -386,14 +419,13 @@ xfs_file_splice_write(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL);

Similar sentiments here.  We will now be acquiring i_mutex
here where previously we did not.  Is that OK?

>  	new_size = *ppos + count;
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	if (new_size > ip->i_size)
>  		ip->i_new_size = new_size;
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
>  
>  	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
>  

. . .

> @@ -631,21 +662,16 @@ xfs_file_aio_write(
>  relock:
>  	if (ioflags & IO_ISDIRECT) {
>  		iolock = XFS_IOLOCK_SHARED;
> -		need_i_mutex = 0;
>  	} else {
>  		iolock = XFS_IOLOCK_EXCL;
> -		need_i_mutex = 1;
> -		mutex_lock(&inode->i_mutex);
>  	}
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
> -

Maybe I'm missing something, but I think you want to
insert this here:
	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|iolock);
...because (for starters) if generic_write_checks()
returns an error below you're going to be calling
the unlock routine.

>  start:
>  	ret = generic_write_checks(file, &pos, &count,
>  					S_ISBLK(inode->i_mode));
>  	if (ret) {
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
> -		goto out_unlock_mutex;
> +		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
> +		return ret;
>  	}
>  
>  	if (ioflags & IO_ISDIRECT) {
> @@ -654,16 +680,14 @@ start:
>  				mp->m_rtdev_targp : mp->m_ddev_targp;
>  
>  		if ((pos & target->bt_smask) || (count & target->bt_smask)) {
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
> +			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
>  			return XFS_ERROR(-EINVAL);
>  		}
>  

One can get a little lost in this code.  I don't know if
this comment is exactly right, but something like it might
be helpful (while you're in here).

		/*
		 * For direct I/O, if there are cached pages or
		 * we're extending the file, we need IOLOCK_EXCL
		 * until we're sure the bytes at the new EOF have
		 * been zeroed and/or the cached pages are flushed
		 * out.  Upgrade the I/O lock and start again.
		 */

> -		if (!need_i_mutex && (mapping->nrpages || pos > ip->i_size)) {
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
> +		if (iolock != XFS_IOLOCK_EXCL &&
> +		    (mapping->nrpages || pos > ip->i_size)) {
> +			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
>  			iolock = XFS_IOLOCK_EXCL;
> -			need_i_mutex = 1;
> -			mutex_lock(&inode->i_mutex);
> -			xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
>  			goto start;
>  		}
>  	}

. . .




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
