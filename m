Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O7JVVB219311 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 01:19:31 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2YR2Ck2uyWwCCxM7 for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 23:19:29 -0800 (PST)
Date: Tue, 24 Jan 2012 18:19:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: Protect xfs_file_aio_write() &
	xfs_setattr_size() with sb_start_write - sb_end_write
Message-ID: <20120124071926.GM15102@dastard>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-6-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1327091686-23177-6-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Alex Elder <elder@kernel.org>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, Jan 20, 2012 at 09:34:43PM +0100, Jan Kara wrote:
> Replace racy xfs_wait_for_freeze() check in xfs_file_aio_write() with
> a reliable sb_start_write() - sb_end_write() locking. Due to lock ranking
> dictated by the page fault code we have to call sb_start_write() after we
> acquire ilock.

It appears to me that you have indeed confused the ilock with the
iolock.

> Similarly we have to protect xfs_setattr_size() because it can modify last
> page of truncated file. Because ilock is dropped in xfs_setattr_size() we
> have to drop and retake write access as well to avoid deadlocks.

> 
> CC: Ben Myers <bpm@sgi.com>
> CC: Alex Elder <elder@kernel.org>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_file.c |    6 ++++--
>  fs/xfs/xfs_iops.c |    6 ++++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 753ed9b..9efd153 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -862,9 +862,11 @@ xfs_file_dio_aio_write(
>  		*iolock = XFS_IOLOCK_SHARED;
>  	}
>  
> +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
>  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
>  	ret = generic_file_direct_write(iocb, iovp,
>  			&nr_segs, pos, &iocb->ki_pos, count, ocount);
> +	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);

That's inside the iolock, not the ilock. Either way, it is
incorrect. This accounting should be outside the iolock - because
xfs_trans_alloc() can be called with the iolock held. Therefore the
freeze/lock order needs to be

	sb_start_write(SB_FREEZE_WRITE)
	  XFS(ip)->i_iolock
	    XFS(ip)->i_ilock
	sb_end_write(SB_FREEZE_WRITE)

Which matches the current freeze/lock order.

> @@ -945,8 +949,6 @@ xfs_file_aio_write(
>  	if (ocount == 0)
>  		return 0;
>  
> -	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
> -

that's where sb_start_write() needs to be, and the sb-end_write()
call needs to below the generic_write_sync() calls that will trigger
IO on O_SYNC writes. Otherwise it is not covering all the IO path
correctly.

>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 3579bc8..798b9c6 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -793,6 +793,7 @@ xfs_setattr_size(
>  		return xfs_setattr_nonsize(ip, iattr, 0);
>  	}
>  
> +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
>  	/*
>  	 * Make sure that the dquots are attached to the inode.
>  	 */
> @@ -849,10 +850,14 @@ xfs_setattr_size(
>  				     xfs_get_blocks);
>  	if (error)
>  		goto out_unlock;
> +	/* Drop the write access to avoid lock inversion with ilock */
> +	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	lock_flags |= XFS_ILOCK_EXCL;
>  
> +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
> +

This is caused by the previous problems I pointed out. You should
not need to drop the freeze reference here at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
