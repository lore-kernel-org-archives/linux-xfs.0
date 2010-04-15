Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3FIFfFJ183251 for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 13:15:41 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6BE73040CA
	for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 11:17:34 -0700 (PDT)
Subject: [PATCH 3/5] xfs: minor odds and ends in xfs_log_recover.c
From: Alex Elder <aelder@sgi.com>
Date: Thu, 15 Apr 2010 13:17:34 -0500
Message-ID: <1271355454.2680.92.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

Odds and ends in "xfs_log_recover.c".  This patch just contains some
minor things that didn't seem to warrant their own individual
patches:
- In xlog_bread_noalign(), drop an assertion that a pointer is
  non-null (the crash will tell us it was a bad pointer).
- Add a more descriptive header comment for xlog_find_verify_cycle().
- Make a few additions to the comments in xlog_find_head().  Also
  rearrange some expressions in a few spots to produce the same
  result, but in a way that seems more clear what's being computed.

(Updated in response to Dave's review comments.  Note I did not
split this patch like I said I would.)

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_log_recover.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -167,7 +167,6 @@ xlog_bread_noalign(
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
-	ASSERT(bp);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
@@ -380,14 +379,12 @@ xlog_find_cycle_start(
 }
 
 /*
- * Check that the range of blocks does not contain the cycle number
- * given.  The scan needs to occur from front to back and the ptr into the
- * region must be updated since a later routine will need to perform another
- * test.  If the region is completely good, we end up returning the same
- * last block number.
- *
- * Set blkno to -1 if we encounter no errors.  This is an invalid block number
- * since we don't ever expect logs to get this large.
+ * Check that a range of blocks does not contain stop_on_cycle_no.
+ * Fill in *new_blk with the block offset where such a block is
+ * found, or with -1 (an invalid block number) if there is no such
+ * block in the range.  The scan needs to occur from front to back
+ * and the pointer into the region must be updated since a later
+ * routine will need to perform another test.
  */
 STATIC int
 xlog_find_verify_cycle(
@@ -661,7 +658,7 @@ xlog_find_head(
 		 * In this case we want to find the first block with cycle
 		 * number matching last_half_cycle.  We expect the log to be
 		 * some variation on
-		 *        x + 1 ... | x ...
+		 *        x + 1 ... | x ... | x
 		 * The first block with cycle number x (last_half_cycle) will
 		 * be where the new head belongs.  First we do a binary search
 		 * for the first occurrence of last_half_cycle.  The binary
@@ -671,11 +668,13 @@ xlog_find_head(
 		 * the log, then we look for occurrences of last_half_cycle - 1
 		 * at the end of the log.  The cases we're looking for look
 		 * like
-		 *        x + 1 ... | x | x + 1 | x ...
-		 *                               ^ binary search stopped here
+		 *                               v binary search stopped here
+		 *        x + 1 ... | x | x + 1 | x ... | x
+		 *                   ^ but we want to locate this spot
 		 * or
-		 *        x + 1 ... | x ... | x - 1 | x
 		 *        <---------> less than scan distance
+		 *        x + 1 ... | x ... | x - 1 | x
+		 *                           ^ we want to locate this spot
 		 */
 		stop_on_cycle = last_half_cycle;
 		if ((error = xlog_find_cycle_start(log, bp, first_blk,
@@ -731,9 +730,9 @@ xlog_find_head(
 		 * certainly not the head of the log.  By searching for
 		 * last_half_cycle-1 we accomplish that.
 		 */
-		start_blk = log_bbnum - num_scan_bblks + head_blk;
 		ASSERT(head_blk <= INT_MAX &&
-			(xfs_daddr_t) num_scan_bblks - head_blk >= 0);
+			(xfs_daddr_t) num_scan_bblks >= head_blk);
+		start_blk = log_bbnum - (num_scan_bblks - head_blk);
 		if ((error = xlog_find_verify_cycle(log, start_blk,
 					num_scan_bblks - (int)head_blk,
 					(stop_on_cycle - 1), &new_blk)))
@@ -780,7 +779,7 @@ validate_head:
 		if ((error = xlog_find_verify_log_record(log, start_blk,
 							&head_blk, 0)) == -1) {
 			/* We hit the beginning of the log during our search */
-			start_blk = log_bbnum - num_scan_bblks + head_blk;
+			start_blk = log_bbnum - (num_scan_bblks - head_blk);
 			new_blk = log_bbnum;
 			ASSERT(start_blk <= INT_MAX &&
 				(xfs_daddr_t) log_bbnum-start_blk >= 0);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
