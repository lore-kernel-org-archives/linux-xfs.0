Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K8I3lg130834 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 03:18:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30F4B172D308
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 01:18:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CuiA0Tm2u9QmaspM for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2011 01:18:02 -0700 (PDT)
Date: Mon, 20 Jun 2011 04:18:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: improve sync behaviour in face of aggressive dirtying
Message-ID: <20110620081802.GA27111@infradead.org>
References: <20110617131401.GC2141@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110617131401.GC2141@infradead.org>
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
To: xfs@oss.sgi.com
Cc: Wu Fengguang <fengguang.wu@intel.com>

As confirmed by Wu moving to a workqueue flush as in the test patch
below brings our performance on par with other filesystems.  But there's
a major and a minor issues with that.

The minor one is that we always flush all work items and not just those
on the filesystem to be flushed.  This might become an issue for lager
systems, or when we apply a similar scheme to fsync, which has the same
underlying issue.

The major one is that flush_workqueue only flushed work items that were
queued before it was called, but we can requeue completions when we fail
to get the ilock in xfs_setfilesize, which can lead to losing i_size
updates when it happens.

I see two ways to fix this:  either we implement our own workqueue
look-alike based on the old workqueue code.  This would allow flushing
queues per-sb or even per-inode, and allow us to special case flushing
requeues as well before returning.

Or we copy the scheme ext4 uses for fsync (it completely fails to flush
the completion queue for plain sync), that is add a list of pending
items to the inode, and a lock to protect it.  I don't like this because
it a) bloats the inode, b) adds a lot of complexity, and c) another lock
to the irq I/O completion.

Any other ideas?


Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2011-06-17 14:16:18.442399481 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2011-06-18 17:55:44.864025123 +0200
@@ -359,14 +359,16 @@ xfs_quiesce_data(
 {
 	int			error, error2 = 0;
 
-	/* push non-blocking */
-	xfs_sync_data(mp, 0);
 	xfs_qm_sync(mp, SYNC_TRYLOCK);
-
-	/* push and block till complete */
-	xfs_sync_data(mp, SYNC_WAIT);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
+	/* flush all pending size updates and unwritten extent conversions */
+	flush_workqueue(xfsconvertd_workqueue);
+	flush_workqueue(xfsdatad_workqueue);
+
+	/* force out the newly dirtied log buffers */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
 	/* write superblock and hoover up shutdown errors */
 	error = xfs_sync_fsdata(mp);
 
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-06-18 17:51:05.660705925 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-06-18 17:52:50.107367305 +0200
@@ -929,45 +929,12 @@ xfs_fs_write_inode(
 		 * ->sync_fs call do that for thus, which reduces the number
 		 * of synchronous log foces dramatically.
 		 */
-		xfs_ioend_wait(ip);
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		if (ip->i_update_core) {
+		if (ip->i_update_core)
 			error = xfs_log_inode(ip);
-			if (error)
-				goto out_unlock;
-		}
-	} else {
-		/*
-		 * We make this non-blocking if the inode is contended, return
-		 * EAGAIN to indicate to the caller that they did not succeed.
-		 * This prevents the flush path from blocking on inodes inside
-		 * another operation right now, they get caught later by
-		 * xfs_sync.
-		 */
-		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
-			goto out;
-
-		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
-			goto out_unlock;
-
-		/*
-		 * Now we have the flush lock and the inode is not pinned, we
-		 * can check if the inode is really clean as we know that
-		 * there are no pending transaction completions, it is not
-		 * waiting on the delayed write queue and there is no IO in
-		 * progress.
-		 */
-		if (xfs_inode_clean(ip)) {
-			xfs_ifunlock(ip);
-			error = 0;
-			goto out_unlock;
-		}
-		error = xfs_iflush(ip, SYNC_TRYLOCK);
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	}
 
- out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
- out:
 	/*
 	 * if we failed to write out the inode then mark
 	 * it dirty again so we'll try again later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
