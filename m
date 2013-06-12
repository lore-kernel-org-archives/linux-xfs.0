Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 269847FAB
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:23:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDAA5304064
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:23:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UHFs6Z9BhzgOxUdb for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:23:35 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiDE-00017K-7m
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:32 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiD3-00066s-Pw
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 24/27] xfs: move xfs_bmap_punch_delalloc() to xfs_aops.c
Date: Wed, 12 Jun 2013 20:22:44 +1000
Message-Id: <1371032567-21772-25-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-1-git-send-email-david@fromorbit.com>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
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

It is only used in that file, and delayed allocation is only used
in the kernel. Hence it has to be removed from xfs_bmap.c in
userspace, so to minimise the differences between kernel and
userspace, move this function out of xfs_bmap.c.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_bmap.c |   75 -------------------------------------------------
 fs/xfs/xfs_bmap.h |    2 --
 3 files changed, 78 insertions(+), 79 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2895178..2480046 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -848,6 +848,82 @@ xfs_vm_invalidatepage(
 	block_invalidatepage(page, offset);
 }
 
+
+/*
+ * dead simple method of punching delayed allocation blocks from a range in
+ * the inode. Walks a block at a time so will be slow, but is only executed in
+ * rare error cases so the overhead is not critical. This will alays punch out
+ * both the start and end blocks, even if the ranges only partially overlap
+ * them, so it is up to the caller to ensure that partial blocks are not
+ * passed in.
+ */
+STATIC int
+xfs_aops_punch_delalloc_range(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		length)
+{
+	xfs_fileoff_t		remaining = length;
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	do {
+		int		done;
+		xfs_bmbt_irec_t	imap;
+		int		nimaps = 1;
+		xfs_fsblock_t	firstblock;
+		xfs_bmap_free_t flist;
+
+		/*
+		 * Map the range first and check that it is a delalloc extent
+		 * before trying to unmap the range. Otherwise we will be
+		 * trying to remove a real extent (which requires a
+		 * transaction) or a hole, which is probably a bad idea...
+		 */
+		error = xfs_bmapi_read(ip, start_fsb, 1, &imap, &nimaps,
+				       XFS_BMAPI_ENTIRE);
+
+		if (error) {
+			/* something screwed, just bail */
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_alert(ip->i_mount,
+			"Failed delalloc mapping lookup ino %lld fsb %lld.",
+						ip->i_ino, start_fsb);
+			}
+			break;
+		}
+		if (!nimaps) {
+			/* nothing there */
+			goto next_block;
+		}
+		if (imap.br_startblock != DELAYSTARTBLOCK) {
+			/* been converted, ignore */
+			goto next_block;
+		}
+		WARN_ON(imap.br_blockcount == 0);
+
+		/*
+		 * Note: while we initialise the firstblock/flist pair, they
+		 * should never be used because blocks should never be
+		 * allocated or freed for a delalloc extent and hence we need
+		 * don't cancel or finish them after the xfs_bunmapi() call.
+		 */
+		xfs_bmap_init(&flist, &firstblock);
+		error = xfs_bunmapi(NULL, ip, start_fsb, 1, 0, 1, &firstblock,
+					&flist, &done);
+		if (error)
+			break;
+
+		ASSERT(!flist.xbf_count && !flist.xbf_first);
+next_block:
+		start_fsb++;
+		remaining--;
+	} while(remaining > 0);
+
+	return error;
+}
+
 /*
  * If the page has delalloc buffers on it, we need to punch them out before we
  * invalidate the page. If we don't, we leave a stale delalloc mapping on the
@@ -893,7 +969,7 @@ xfs_aops_discard_page(
 			goto next_buffer;
 
 		start_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
-		error = xfs_bmap_punch_delalloc_range(ip, start_fsb, 1);
+		error = xfs_aops_punch_delalloc_range(ip, start_fsb, 1);
 		if (error) {
 			/* something screwed, just bail */
 			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
@@ -1493,7 +1569,7 @@ xfs_vm_kill_delalloc_range(
 		return;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
+	error = xfs_aops_punch_delalloc_range(ip, start_fsb,
 						end_fsb - start_fsb);
 	if (error) {
 		/* something screwed, just bail */
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 7b8b3ab..fa90247 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5788,78 +5788,3 @@ error0:
 	}
 	return error;
 }
-
-/*
- * dead simple method of punching delalyed allocation blocks from a range in
- * the inode. Walks a block at a time so will be slow, but is only executed in
- * rare error cases so the overhead is not critical. This will alays punch out
- * both the start and end blocks, even if the ranges only partially overlap
- * them, so it is up to the caller to ensure that partial blocks are not
- * passed in.
- */
-int
-xfs_bmap_punch_delalloc_range(
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		start_fsb,
-	xfs_fileoff_t		length)
-{
-	xfs_fileoff_t		remaining = length;
-	int			error = 0;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	do {
-		int		done;
-		xfs_bmbt_irec_t	imap;
-		int		nimaps = 1;
-		xfs_fsblock_t	firstblock;
-		xfs_bmap_free_t flist;
-
-		/*
-		 * Map the range first and check that it is a delalloc extent
-		 * before trying to unmap the range. Otherwise we will be
-		 * trying to remove a real extent (which requires a
-		 * transaction) or a hole, which is probably a bad idea...
-		 */
-		error = xfs_bmapi_read(ip, start_fsb, 1, &imap, &nimaps,
-				       XFS_BMAPI_ENTIRE);
-
-		if (error) {
-			/* something screwed, just bail */
-			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_alert(ip->i_mount,
-			"Failed delalloc mapping lookup ino %lld fsb %lld.",
-						ip->i_ino, start_fsb);
-			}
-			break;
-		}
-		if (!nimaps) {
-			/* nothing there */
-			goto next_block;
-		}
-		if (imap.br_startblock != DELAYSTARTBLOCK) {
-			/* been converted, ignore */
-			goto next_block;
-		}
-		WARN_ON(imap.br_blockcount == 0);
-
-		/*
-		 * Note: while we initialise the firstblock/flist pair, they
-		 * should never be used because blocks should never be
-		 * allocated or freed for a delalloc extent and hence we need
-		 * don't cancel or finish them after the xfs_bunmapi() call.
-		 */
-		xfs_bmap_init(&flist, &firstblock);
-		error = xfs_bunmapi(NULL, ip, start_fsb, 1, 0, 1, &firstblock,
-					&flist, &done);
-		if (error)
-			break;
-
-		ASSERT(!flist.xbf_count && !flist.xbf_first);
-next_block:
-		start_fsb++;
-		remaining--;
-	} while(remaining > 0);
-
-	return error;
-}
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 31b7c0e..262f760 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -214,8 +214,6 @@ int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
 		int whichfork, int *eof);
 int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		int whichfork, int *count);
-int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
-		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
 
 xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
