Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GM15GF022297 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 16:01:05 -0600
Received: from mail.hq.newdream.net (mail.hq.newdream.net [66.33.206.127]) by
	cuda.sgi.com with ESMTP id CSsj99nkQtxbiGf9 for
	<xfs@oss.sgi.com>; Thu, 16 Feb 2012 14:01:02 -0800 (PST)
Received: from mail.hq.newdream.net (localhost [127.0.0.1])
	by mail.hq.newdream.net (Postfix) with ESMTP id F285424280
	for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 14:03:26 -0800 (PST)
Received: from [172.22.22.6] (c-71-195-31-37.hsd1.mn.comcast.net
	[71.195.31.37])
	by mail.hq.newdream.net (Postfix) with ESMTPSA id A73A12427E
	for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 14:03:26 -0800 (PST)
Message-ID: <1329429660.16207.19.camel@doink>
Subject: [PATCH] xfs: only take the ILOCK in xfs_reclaim_inode()
From: Alex Elder <elder@dreamhost.com>
Date: Thu, 16 Feb 2012 16:01:00 -0600
Mime-Version: 1.0
Reply-To: elder@dreamhost.com
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

At the end of xfs_reclaim_inode(), the inode is locked in order to
we wait for a possible concurrent lookup to complete before the
inode is freed.  This synchronization step was taking both the ILOCK
and the IOLOCK, but the latter was causing lockdep to produce
reports of the possibility of deadlock.

It turns out that there's no need to acquire the IOLOCK at this
point anyway.  It may have been required in some earlier version of
the code, but there should be no need to take the IOLOCK in
xfs_iget(), so there's no (longer) any need to get it here for
synchronization.  Add an assertion in xfs_iget() as a reminder
of this assumption.

Dave Chinner diagnosed this on IRC, and Christoph Hellwig suggested
no longer including the IOLOCK.  I just put together the patch.

Signed-off-by: Alex Elder <elder@dreamhost.com>
---
 fs/xfs/xfs_iget.c |    9 +++++++++
 fs/xfs/xfs_sync.c |   10 ++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 0fa98b1..39d51d9 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -421,6 +421,15 @@ xfs_iget(
 	xfs_perag_t	*pag;
 	xfs_agino_t	agino;
 
+	/*
+	 * xfs_reclaim_inode() uses the ILOCK to ensure an inode
+	 * doesn't get freed while it's being referenced during a
+	 * radix tree traversal here.  It assumes this function
+	 * aqcuires only the ILOCK (and therefore it has no need to
+	 * involve the IOLOCK in this synchronization).
+	 */
+	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
+
 	/* reject inode numbers outside existing AGs */
 	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
 		return EINVAL;
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index f0994aedc..61c6986 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -918,17 +918,15 @@ reclaim:
 	 * can reference the inodes in the cache without taking references.
 	 *
 	 * We make that OK here by ensuring that we wait until the inode is
-	 * unlocked after the lookup before we go ahead and free it.  We get
-	 * both the ilock and the iolock because the code may need to drop the
-	 * ilock one but will still hold the iolock.
+	 * unlocked after the lookup before we go ahead and free it.
 	 */
-	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_qm_dqdetach(ip);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	xfs_inode_free(ip);
-	return error;
 
+	return error;
 }
 
 /*
-- 
1.7.5.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
