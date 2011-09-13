Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DFRC2f067668 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 10:27:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C73A71525E93
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:31:49 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FVlptxR3s3H1GDgz for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2011 08:31:49 -0700 (PDT)
Date: Tue, 13 Sep 2011 11:27:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Code Changes [Review Request]: xfs_trans_ail_delete() gets
	invoked with corrupted values ? Causing Crash and Deadlock.
Message-ID: <20110913152706.GB21460@infradead.org>
References: <CADDb1s0HwQtno3qWJd5CDriGD+m1EJ3fKihrRXuGmqayzwb_Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s0HwQtno3qWJd5CDriGD+m1EJ3fKihrRXuGmqayzwb_Pw@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hmm, I don't think this is the correct fix.  We should never have
buffers still around once we unmount the log.  Can you try the patch
below?

---
From: Christoph Hellwig <hch@lst.de>
Subject: xfs: fix buffer flushing during unmount

The code to flush buffers in the umount code is a bit iffy: we first flush
all delwri buffers out, but then might be able to queue up a new one when
logging the sb counts.  On a normal shutdown that one would get flushed
out when doing the synchronous superblock write in xfs_unmountfs_writesb,
but we skip that one if the filesystem has been shut down.

Fix this by moving the delwri list flushing until just before unmounting
the log, and while we're at it also remove the superflous delwri list
and buffer lru flusing for the rt and log device that can never have
cached or delwri buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2011-09-13 10:55:20.748087866 -0400
+++ xfs/fs/xfs/xfs_mount.c	2011-09-13 10:56:19.108088343 -0400
@@ -44,9 +44,6 @@
 #include "xfs_trace.h"
 
 
-STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
-
-
 #ifdef HAVE_PERCPU_SB
 STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t,
 						int);
@@ -1496,11 +1493,6 @@ xfs_unmountfs(
 	 */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	xfs_binval(mp->m_ddev_targp);
-	if (mp->m_rtdev_targp) {
-		xfs_binval(mp->m_rtdev_targp);
-	}
-
 	/*
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
@@ -1526,7 +1518,16 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
 	xfs_unmountfs_writesb(mp);
-	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
+
+	/*
+	 * Make sure all buffers have been flushed and completed before
+	 * unmounting the log.
+	 */
+	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
+	if (error)
+		xfs_warn(mp, "%d busy buffers during unmount.", error);
+	xfs_wait_buftarg(mp->m_ddev_targp);
+
 	xfs_log_unmount_write(mp);
 	xfs_log_unmount(mp);
 	xfs_uuid_unmount(mp);
@@ -1537,16 +1538,6 @@ xfs_unmountfs(
 	xfs_free_perag(mp);
 }
 
-STATIC void
-xfs_unmountfs_wait(xfs_mount_t *mp)
-{
-	if (mp->m_logdev_targp != mp->m_ddev_targp)
-		xfs_wait_buftarg(mp->m_logdev_targp);
-	if (mp->m_rtdev_targp)
-		xfs_wait_buftarg(mp->m_rtdev_targp);
-	xfs_wait_buftarg(mp->m_ddev_targp);
-}
-
 int
 xfs_fs_writable(xfs_mount_t *mp)
 {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
