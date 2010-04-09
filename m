Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39MTlts146514 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 17:29:47 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 483118F80D7
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 15:31:40 -0700 (PDT)
Subject: [PATCHv2 9/10] xfs: a few more minor xfs_log_recover.c cleanups
From: Alex Elder <aelder@sgi.com>
Date: Fri, 09 Apr 2010 17:31:06 -0500
Message-ID: <1270852266.7840.159.camel@doink>
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

Minor things that didn't seem to warrant their own individual
patches:
- In xlog_bread_noalign(), reorder assertions so the buffer pointer
  is known to be non-null before attempting to dereference it.
- Add a more descriptive header comment for xlog_find_verify_cycle().
- Make a few additions to the comments in xlog_find_head().  Also
  rearrange some expressions in a few spots to produce the same
  result, but in a way that seems more clear what's being computed.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
fs/xfs/xfs_log_recover.c |   83 ++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_log_recover.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -166,8 +166,8 @@ xlog_bread_noalign(
 	nbblks = round_up(nbblks, xlog_sectbb(log));
 
 	ASSERT(nbblks > 0);
-	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 	ASSERT(bp);
+	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
@@ -387,8 +387,11 @@ xlog_find_cycle_start(
  * test.  If the region is completely good, we end up returning the same
  * last block number.
  *
- * Set blkno to -1 if we encounter no errors.  This is an invalid block number
- * since we don't ever expect logs to get this large.
+ * If we encounter a basic block containing stop_on_cycle_no as its
+ * cycle number, return that basic block offset in *new_blk.  If no
+ * basic blocks in the range specified contain stop_on_cycle_no, set
+ * *new_blk to -1.  This is an invalid block number since we don't
+ * ever expect logs to get this large.
  */
 STATIC int
 xlog_find_verify_cycle(
@@ -662,7 +665,7 @@ xlog_find_head(
 		 * In this case we want to find the first block with cycle
 		 * number matching last_half_cycle.  We expect the log to be
 		 * some variation on
-		 *        x + 1 ... | x ...
+		 *        x + 1 ... | x ... | x
 		 * The first block with cycle number x (last_half_cycle) will
 		 * be where the new head belongs.  First we do a binary search
 		 * for the first occurrence of last_half_cycle.  The binary
@@ -672,11 +675,13 @@ xlog_find_head(
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
@@ -732,9 +737,9 @@ xlog_find_head(
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
@@ -781,7 +786,7 @@ fine_tune:
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
