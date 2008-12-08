Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8MpvfV004562 for <xfs@oss.sgi.com>; Mon, 8 Dec 2008 16:51:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF00B606
	for <xfs@oss.sgi.com>; Mon,  8 Dec 2008 14:51:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fALiI8MBYJ9x0T25 for
	<xfs@oss.sgi.com>; Mon, 08 Dec 2008 14:51:56 -0800 (PST)
Date: Mon, 8 Dec 2008 17:51:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: [PATCH] Fix race in xfs_write() between direct and
	buffered I/O with DMAPI]
Message-ID: <20081208225125.GA15647@infradead.org>
References: <493779B1.3010703@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <493779B1.3010703@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Dec 04, 2008 at 05:33:21PM +1100, Lachlan McIlroy wrote:
> --- a/fs/xfs/linux-2.6/xfs_lrw.c	2008-09-22 15:47:38.000000000 +1000
> +++ b/fs/xfs/linux-2.6/xfs_lrw.c	2008-09-22 15:50:56.000000000 +1000
> @@ -707,7 +707,6 @@ start:
> 		}
> 	}
> 
> -retry:
> 	/* We can write back this queue in page reclaim */
> 	current->backing_dev_info = mapping->backing_dev_info;
> 
> @@ -763,6 +762,17 @@ retry:
> 	if (ret == -EIOCBQUEUED && !(ioflags & IO_ISAIO))
> 		ret = wait_on_sync_kiocb(iocb);
> 
> +	isize = i_size_read(inode);
> +	if (unlikely(ret < 0 && ret != -EFAULT && *offset > isize))
> +		*offset = isize;
> +
> +	if (*offset > xip->i_size) {
> +		xfs_ilock(xip, XFS_ILOCK_EXCL);
> +		if (*offset > xip->i_size)
> +			xip->i_size = *offset;
> +		xfs_iunlock(xip, XFS_ILOCK_EXCL);
> +	}
> +
> 	if (ret == -ENOSPC &&
> 	    DM_EVENT_ENABLED(xip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
> 		xfs_iunlock(xip, iolock);

Moving these updates to before the dmapi nospace callout provale doesn't
make any changes to the non-dmapi codepath, so good from that
perspective.  And as you say above it makes sense to have this update
before the dmapi callout.

> @@ -776,20 +786,7 @@ retry:
> 		xfs_ilock(xip, iolock);
> 		if (error)
> 			goto out_unlock_internal;
> -		pos = xip->i_size;
> -		ret = 0;
> -		goto retry;
> -	}
> -
> -	isize = i_size_read(inode);
> -	if (unlikely(ret < 0 && ret != -EFAULT && *offset > isize))
> -		*offset = isize;
> -
> -	if (*offset > xip->i_size) {
> -		xfs_ilock(xip, XFS_ILOCK_EXCL);
> -		if (*offset > xip->i_size)
> -			xip->i_size = *offset;
> -		xfs_iunlock(xip, XFS_ILOCK_EXCL);
> +		goto start;

Again all this won't affect non-dmapi operations, so OK with my mainline
hat on.  Now if we check what start does over the old retry labels:

 - calls generic_write_checks.  This could and should redo checks based
   on the new inode size, ok.
 - dmapi write even - shouldn't happen because eventsent is non-zero,
   ok.
 - O_DIRECT alignment validation.  Superflous, but harmless, ok.
 - check for exclusive lock.  This is what you said you wanted, and
   indded due to the lock dropping we need it.  But why don't
   you duplicate this check in the dmapi case below so that we
   only have to go to start once instead of possibly twice?
 - i_new_size update - needed due to the possible i_size changes, ok
 - ichgtime - if time passed since the last time we might want to
   re-updated it, ok
 - zero_eof, ok
 - setuid clearing, superflous, but harmless.

So the patch looks good to me, but as mention above it might be possible
to optimize it a littler more.
  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
