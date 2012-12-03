Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NegOt067673 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:43 -0600
Message-Id: <20121203144309.267172499@sgi.com>
Date: Mon, 03 Dec 2012 17:42:13 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 05/36] xfs: only take the ILOCK in
	xfs_reclaim_inode()
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=048
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Alex Elder <elder@dreamhost.com>

Upstream commit: ad637a10f444fc66b1f6d4a28fe30d4c61ed0161

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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   10 ++++------
 fs/xfs/xfs_iget.c           |    9 +++++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -921,17 +921,15 @@ reclaim:
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
Index: b/fs/xfs/xfs_iget.c
===================================================================
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -430,6 +430,15 @@ xfs_iget(
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
