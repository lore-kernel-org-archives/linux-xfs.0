Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1N0gZKr062063 for <xfs@oss.sgi.com>; Wed, 22 Feb 2012 18:42:35 -0600
Received: from MMS3.broadcom.com (mms3.broadcom.com [216.31.210.19]) by
	cuda.sgi.com with ESMTP id 8mDdBBkfQ5RnObjt for
	<xfs@oss.sgi.com>; Wed, 22 Feb 2012 16:42:34 -0800 (PST)
From: "Kamal Dasu" <kdasu.kdev@gmail.com>
Subject: [PATCH] xfs: fix deadlock in xfs_rtfree_extent with kernel v3.x
Date: Wed, 22 Feb 2012 19:41:39 -0500
Message-ID: <1329957699-20769-1-git-send-email-kdasu.kdev@gmail.com>
In-Reply-To: <kdasu.kdev@gmail.com>
References: <kdasu.kdev@gmail.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, kdasu.kdev@gmail.com, cernekee@gmail.com

To fix the deadlock caused by recursively calling xfs_rtfree_extent

 - removed xfs_ilock() and xfs_trans_ijoin() from xfs_rtfree_extent(),
   instead added asserts that the inode is locked and has an inode_item
   attached to it.
 - in xfs_bunmapi() when dealing with an inode with the rt flag
   call xfs_ilock() and xfs_trans_ijoin() so that the
   reference count is bumped on the inode and attached it to the
   transaction before calling into xfs_bmap_del_extent, similar to
   what we do in xfs_bmap_rtalloc.

Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
---
 fs/xfs/xfs_bmap.c    |    9 +++++++++
 fs/xfs/xfs_rtalloc.c |    9 ++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 188ef2f..9a0aa33 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5124,6 +5124,15 @@ xfs_bunmapi(
 		cur->bc_private.b.flags = 0;
 	} else
 		cur = NULL;
+
+	if (isrt) {
+		/*
+		 * Synchronize by locking the bitmap inode.
+		 */
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+	}
+
 	extno = 0;
 	while (bno != (xfs_fileoff_t)-1 && bno >= start && lastx >= 0 &&
 	       (nexts == 0 || extno < nexts)) {
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 87323f1..ca4f315 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -183,6 +183,7 @@ error_cancel:
 		oblocks = map.br_startoff + map.br_blockcount;
 	}
 	return 0;
+
 error:
 	return error;
 }
@@ -2139,11 +2140,9 @@ xfs_rtfree_extent(
 	xfs_buf_t	*sumbp;		/* summary file block buffer */
 
 	mp = tp->t_mountp;
-	/*
-	 * Synchronize by locking the bitmap inode.
-	 */
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+
+	ASSERT(mp->m_rbmip->i_itemp != NULL);
+	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
 #if defined(__KERNEL__) && defined(DEBUG)
 	/*
-- 
1.7.5.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
