Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3Nee8T067599 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:40 -0600
Message-Id: <20121203144309.540365371@sgi.com>
Date: Mon, 03 Dec 2012 17:42:16 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 08/36] xfs: fix deadlock in xfs_rtfree_extent
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=059
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

From: Kamal Dasu <kdasu.kdev@gmail.com>

Upstream commit: 5575acc7807595687288b3bbac15103f2a5462e1

To fix the deadlock caused by repeatedly calling xfs_rtfree_extent

 - removed xfs_ilock() and xfs_trans_ijoin() from xfs_rtfree_extent(),
   instead added asserts that the inode is locked and has an inode_item
   attached to it.
 - in xfs_bunmapi() when dealing with an inode with the rt flag
   call xfs_ilock() and xfs_trans_ijoin() so that the
   reference count is bumped on the inode and attached it to the
   transaction before calling into xfs_bmap_del_extent, similar to
   what we do in xfs_bmap_rtalloc.

Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_bmap.c    |    9 +++++++++
 fs/xfs/xfs_rtalloc.c |    9 ++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5041,6 +5041,15 @@ xfs_bunmapi(
 		cur->bc_private.b.flags = 0;
 	} else
 		cur = NULL;
+
+	if (isrt) {
+		/*
+		 * Synchronize by locking the bitmap inode.
+		 */
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, mp->m_rbmip);
+	}
+
 	extno = 0;
 	while (bno != (xfs_fileoff_t)-1 && bno >= start && lastx >= 0 &&
 	       (nexts == 0 || extno < nexts)) {
Index: b/fs/xfs/xfs_rtalloc.c
===================================================================
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
@@ -2149,11 +2150,9 @@ xfs_rtfree_extent(
 	xfs_buf_t	*sumbp;		/* summary file block buffer */
 
 	mp = tp->t_mountp;
-	/*
-	 * Synchronize by locking the bitmap inode.
-	 */
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+
+	ASSERT(mp->m_rbmip->i_itemp != NULL);
+	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
 #if defined(__KERNEL__) && defined(DEBUG)
 	/*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
