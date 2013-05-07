Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE9F429E16
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 03:05:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A86448F8033
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 01:05:04 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FFCgYLwnAPFmx0th for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 01:05:02 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZctR-0006ZC-D7
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:05:01 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZctH-0007rc-B2
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] xfs: Use inode create transaction
Date: Tue,  7 May 2013 18:04:35 +1000
Message-Id: <1367913876-30086-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1367913876-30086-1-git-send-email-david@fromorbit.com>
References: <1367913876-30086-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Replace the use of buffer based logging of inode initialisation,
uses the new logical form to describe the range to be initialised
in recovery. We continue to "log" the inode buffers to push them
into the AIL and ensure that the inode create transaction is not
removed from the log before the inode buffers are written to disk.

Update the transaction identifier and reservations to match the
changed implementation.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_ialloc.c |   39 ++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_ialloc.h |    7 +++++++
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index c8f5ae1..9126b59 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -38,6 +38,7 @@
 #include "xfs_bmap.h"
 #include "xfs_cksum.h"
 #include "xfs_buf_item.h"
+#include "xfs_icreate_item.h"
 
 
 /*
@@ -152,7 +153,7 @@ xfs_check_agi_freecount(
 /*
  * Initialise a new set of inodes.
  */
-STATIC int
+int
 xfs_ialloc_inode_init(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
@@ -208,6 +209,17 @@ xfs_ialloc_inode_init(
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno,
 				       XFS_OFFBNO_TO_AGINO(mp, agbno, 0));
+
+		/*
+		 * log the initialisation that is about to take place as an
+		 * logical operation. This means the transaction does not
+		 * need to log the physical changes to the inode buffers as log
+		 * recovery will know what initialisation is actually needed.
+		 * Hence we only need to log the buffers as "ordered" buffers so
+		 * they track in the AIL as if they were physically logged.
+		 */
+		xfs_icreate_log(tp, agno, agbno, XFS_IALLOC_INODES(mp),
+				mp->m_sb.sb_inodesize, length, gen);
 	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
 		version = 2;
 	else
@@ -223,13 +235,8 @@ xfs_ialloc_inode_init(
 					 XBF_UNMAPPED);
 		if (!fbuf)
 			return ENOMEM;
-		/*
-		 * Initialize all inodes in this buffer and then log them.
-		 *
-		 * XXX: It would be much better if we had just one transaction
-		 *	to log a whole cluster of inodes instead of all the
-		 *	individual transactions causing a lot of log traffic.
-		 */
+
+		/* Initialize the inode buffers and log them appropriately. */
 		fbuf->b_ops = &xfs_inode_buf_ops;
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
 		for (i = 0; i < ninodes; i++) {
@@ -253,11 +260,25 @@ xfs_ialloc_inode_init(
 						  ioffset + isize - 1);
 			}
 		}
+
 		if (version == 3) {
-			/* need to log the entire buffer */
+			/*
+			 * Mark the buffer as ordered so that it is not logged
+			 * in the transaction but still tracked in the AIL as
+			 * part of the transaction.
+			 */
+			xfs_trans_ordered_buf(tp, fbuf);
 			xfs_trans_log_buf(tp, fbuf, 0,
 					  BBTOB(fbuf->b_length) - 1);
 		}
+
+		/*
+		 * Mark the buffer as an inode allocation buffer so it sticks in
+		 * AIL at the point of this allocation transaction. This ensures
+		 * the they are on disk before the tail of the log can be moved
+		 * past this transaction (i.e. by preventing relogging from
+		 * moving it forward in the log).
+		 */
 		xfs_trans_inode_alloc_buf(tp, fbuf);
 	}
 	return 0;
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index c8da3df..ec1cc48 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -152,4 +152,11 @@ int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
 
 extern const struct xfs_buf_ops xfs_agi_buf_ops;
 
+/*
+ * Inode buffer initialisation routine
+ */
+int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
+		 xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 xfs_agblock_t length, unsigned int gen);
+
 #endif	/* __XFS_IALLOC_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
