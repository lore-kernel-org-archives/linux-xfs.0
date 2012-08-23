Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53xNt135459 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:59 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UrNQFul74gHcxETc for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:44 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paz-0003Hl-LA
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pap-0003g4-Js
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 059/102] xfs: fix deadlock in xfs_rtfree_extent
Date: Thu, 23 Aug 2012 15:02:17 +1000
Message-Id: <1345698180-13612-60-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

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

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 2af58c4..8f3b730 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5039,6 +5039,15 @@ xfs_bunmapi(
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
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8f76fdf..7c62363 100644
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
