Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0QG9fDE132645 for <xfs@oss.sgi.com>; Tue, 26 Jan 2010 10:09:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59763151E86D
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2010 08:10:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7s23QXrXYvM0jH5V for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2010 08:10:46 -0800 (PST)
Date: Tue, 26 Jan 2010 11:10:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: Use delayed write for inodes rather than async
Message-ID: <20100126161045.GB24152@infradead.org>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
	<1264400564-19704-3-git-send-email-david@fromorbit.com>
	<20100125115308.GC8595@infradead.org>
	<20100125223140.GN25842@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100125223140.GN25842@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> > Also in this context
> > the requeue label name doesn't fit too well, even if it's the same
> > action as the requeue.
> 
> I'm open to suggestions for a better name ;)

What do you think about this version?

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-01-26 17:01:49.610012226 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2010-01-26 17:06:50.533006103 +0100
@@ -785,7 +785,7 @@ xfs_reclaim_inode(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (!xfs_iflock_nowait(ip)) {
 		if (!(sync_mode & SYNC_WAIT))
-			goto requeue_no_flock;
+			goto out;
 		xfs_iflock(ip);
 	}
 
@@ -796,8 +796,10 @@ xfs_reclaim_inode(
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip)) {
-		if (!(sync_mode & SYNC_WAIT))
-			goto requeue;
+		if (!(sync_mode & SYNC_WAIT)) {
+			xfs_ifunlock(ip);
+			goto out;
+		}
 		xfs_iunpin_wait(ip);
 	}
 	if (xfs_iflags_test(ip, XFS_ISTALE))
@@ -807,19 +809,18 @@ xfs_reclaim_inode(
 
 	/* Now we have an inode that needs flushing */
 	error = xfs_iflush(ip, sync_mode);
-	if (!(sync_mode & SYNC_WAIT))
-		goto requeue_no_flock;
-	xfs_iflock(ip);
-
-reclaim:
-	xfs_ifunlock(ip);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	xfs_ireclaim(ip);
-	return error;
+	if (sync_mode & SYNC_WAIT) {
+		xfs_iflock(ip);
+		goto reclaim;
+	}
 
-requeue:
-	xfs_ifunlock(ip);
-requeue_no_flock:
+	/*
+	 * When we have to flush an inode but don't have SYNC_WAIT set, we
+	 * flush the inode out with using a delwri buffer and wait for
+	 * the next call into the reclaim to find it in a clean state
+	 * instead of doing it now.
+	 */
+out:
 	xfs_iflags_clear(ip, XFS_IRECLAIM);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	/*
@@ -830,6 +831,12 @@ requeue_no_flock:
 	 * attempt to reclaim the inode again.
 	 */
 	return 0;
+
+reclaim:
+	xfs_ifunlock(ip);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_ireclaim(ip);
+	return error;
 }
 
 int

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
