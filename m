Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0184029E00
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 18:41:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3188AC004
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 16:41:21 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	b9EKeSIPCwZQdhbP for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 16:41:19 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRUPV-0000Rm-B2
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRUPV-0005Mm-AH
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: remove XBF_STALE flag wrapper macros
Date: Fri,  5 Feb 2016 11:38:02 +1100
Message-Id: <1454632683-20543-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1454632683-20543-1-git-send-email-david@fromorbit.com>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

They only set/clear/check a flag, no need for obfuscating this
with a macro.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.h       | 4 +---
 fs/xfs/xfs_buf_item.c  | 2 +-
 fs/xfs/xfs_trans_buf.c | 6 +++---
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index a118962..98b7ee9 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -302,6 +302,7 @@ extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
 
 /* Buffer Utility Routines */
 extern void *xfs_buf_offset(struct xfs_buf *, size_t);
+extern void xfs_buf_stale(struct xfs_buf *bp);
 
 /* Delayed Write Buffer Routines */
 extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
@@ -317,9 +318,6 @@ extern void xfs_buf_terminate(void);
 			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH| \
 			    XBF_WRITE_FAIL))
 
-void xfs_buf_stale(struct xfs_buf *bp);
-#define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
-#define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
 
 /*
  * These macros use the IO block map rather than b_bn. b_bn is now really
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 344ab44..2891134 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -408,7 +408,7 @@ xfs_buf_item_unpin(
 	if (freed && stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
 		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(XFS_BUF_ISSTALE(bp));
+		ASSERT(bp->b_flags & XBF_STALE);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 
 		trace_xfs_buf_item_unpin_stale(bip);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index ed6f61f..8ee29ca 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -534,8 +534,8 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	 */
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		bip->bli_flags &= ~XFS_BLI_STALE;
-		ASSERT(XFS_BUF_ISSTALE(bp));
-		XFS_BUF_UNSTALE(bp);
+		ASSERT(bp->b_flags & XBF_STALE);
+		bp->b_flags &= ~XBF_STALE;
 		bip->__bli_format.blf_flags &= ~XFS_BLF_CANCEL;
 	}
 
@@ -600,7 +600,7 @@ xfs_trans_binval(
 		 * If the buffer is already invalidated, then
 		 * just return.
 		 */
-		ASSERT(XFS_BUF_ISSTALE(bp));
+		ASSERT(bp->b_flags & XBF_STALE);
 		ASSERT(!(bip->bli_flags & (XFS_BLI_LOGGED | XFS_BLI_DIRTY)));
 		ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_INODE_BUF));
 		ASSERT(!(bip->__bli_format.blf_flags & XFS_BLFT_MASK));
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
