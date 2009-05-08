Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n480jXXL239930 for <xfs@oss.sgi.com>; Thu, 7 May 2009 19:45:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A8351D1B3A7
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 17:45:37 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ArYROYi8XQj8cHZ1 for
	<xfs@oss.sgi.com>; Thu, 07 May 2009 17:45:37 -0700 (PDT)
Message-ID: <4A0380B0.1050101@sandeen.net>
Date: Thu, 07 May 2009 19:45:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 03/17] xfs: cleanup handling in xfs_swap_extents
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073200.459094000@bombadil.infradead.org>
In-Reply-To: <20090126073200.459094000@bombadil.infradead.org>
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
Cc: Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:

> Use multiple lables for proper error unwinding and get rid of some now
> superflous variables.
>
>
> Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Problem in this patch, I think, getting hangs on x86 fsr...

> Index: xfs/fs/xfs/xfs_dfrag.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dfrag.c	2008-12-19 15:02:54.003908425 +0100
> +++ xfs/fs/xfs/xfs_dfrag.c	2008-12-22 15:59:55.013247371 +0100
<snip>
> @@ -352,19 +344,19 @@ xfs_swap_extents(
>  	 * If this is a synchronous mount, make sure that the
>  	 * transaction goes to disk before returning to the user.
>  	 */
> -	if (mp->m_flags & XFS_MOUNT_WSYNC) {
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(tp);
> -	}
>  
>  	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
> -	locked = 0;

old code said "unlocked" here thanks to the trans commit ...

> - error0:
> -	if (locked) {
> -		xfs_iunlock(ip,  lock_flags);
> -		xfs_iunlock(tip, lock_flags);
> -	}
and so we wouldn't unlock again ...
> -	if (tempifp != NULL)
> -		kmem_free(tempifp);
> +out_unlock:
> +	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);

But now we do it unconditionally, and ruh-roh.

> +out:
> +	kmem_free(tempifp);
>  	return error;
> +
> +out_trans_cancel:
> +	xfs_trans_cancel(tp, 0);
> +	goto out_unlock;
>  }

Is this too ugly a fix?

XFS: Fix double unlock of inodes in xfs_swap_extents()

commit ef8f7fc549bf345d92f396f5aa7b152b4969cbf7 had an error
where we would try to re-unlock the inodes after they had been
committed in the transaction; this double unlock caused a

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
xfs_fsr/1459 is trying to release lock (&(&ip->i_iolock)->mr_lock) at:
[<e248dedb>] xfs_iunlock+0x2c/0x92 [xfs]
but there are no more locks to release!

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dfrag.c
+++ linux-2.6/fs/xfs/xfs_dfrag.c
@@ -347,13 +347,15 @@ xfs_swap_extents(
 
 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
 
-out_unlock:
-	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 out:
 	kmem_free(tempifp);
 	return error;
 
+out_unlock:
+	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	goto out;
+
 out_trans_cancel:
 	xfs_trans_cancel(tp, 0);
 	goto out_unlock;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
