Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 185267F54
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:46:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CFF0E304087
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:46:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bwdMDn2g6fVXHGJt for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 22:46:00 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkpUd-0004YR-LY
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkpUd-0003lG-Hq
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/17] xfs: Use inode create transaction
Date: Fri,  7 Jun 2013 15:45:24 +1000
Message-Id: <1370583929-14276-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1370583929-14276-1-git-send-email-david@fromorbit.com>
References: <1370583929-14276-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_buf_item.c |   12 ++++++++++--
 fs/xfs/xfs_ialloc.c   |   32 +++++++++++++++++++++++---------
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 61f6876..bfc4e0c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -310,13 +310,21 @@ xfs_buf_item_format(
 
 	/*
 	 * If it is an inode buffer, transfer the in-memory state to the
-	 * format flags and clear the in-memory state. We do not transfer
+	 * format flags and clear the in-memory state.
+	 *
+	 * For buffer based inode allocation, we do not transfer
 	 * this state if the inode buffer allocation has not yet been committed
 	 * to the log as setting the XFS_BLI_INODE_BUF flag will prevent
 	 * correct replay of the inode allocation.
+	 *
+	 * For icreate item based inode allocation, the buffers aren't written
+	 * to the journal during allocation, and hence we should always tag the
+	 * buffer as an inode buffer so that the correct unlinked list replay
+	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (!((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
+		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
+		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
 		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index d5ef81a..319d9e4 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -38,6 +38,7 @@
 #include "xfs_bmap.h"
 #include "xfs_cksum.h"
 #include "xfs_buf_item.h"
+#include "xfs_icreate_item.h"
 
 
 /*
@@ -155,7 +156,7 @@ xfs_check_agi_freecount(
  * than logging them (which in a transaction context puts them into the AIL
  * for writeback rather than the xfsbufd queue).
  */
-STATIC int
+int
 xfs_ialloc_inode_init(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
@@ -212,6 +213,18 @@ xfs_ialloc_inode_init(
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
+		if (tp)
+			xfs_icreate_log(tp, agno, agbno, XFS_IALLOC_INODES(mp),
+					mp->m_sb.sb_inodesize, length, gen);
 	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
 		version = 2;
 	else
@@ -227,13 +240,8 @@ xfs_ialloc_inode_init(
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
@@ -269,7 +277,13 @@ xfs_ialloc_inode_init(
 			 */
 			xfs_trans_inode_alloc_buf(tp, fbuf);
 			if (version == 3) {
-				/* need to log the entire buffer */
+				/*
+				 * Mark the buffer as ordered so that they are
+				 * not physically logged in the transaction but
+				 * still tracked in the AIL as part of the
+				 * transaction and pin the log appropriately.
+				 */
+				xfs_trans_ordered_buf(tp, fbuf);
 				xfs_trans_log_buf(tp, fbuf, 0,
 						  BBTOB(fbuf->b_length) - 1);
 			}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
