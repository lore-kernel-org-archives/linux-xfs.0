Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2IMqcrL198541 for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:52:39 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A8208F80A3
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 15:54:17 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o2IMsGWU001895
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:54:17 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o2IMsGKO001893
	for xfs@oss.sgi.com; Thu, 18 Mar 2010 17:54:16 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003182254.o2IMsGKO001893@stout.americas.sgi.com>
Date: Thu, 18 Mar 2010 17:54:16 -0500
Subject: [PATCH 7/7] xfs: xfs_log_recover.c odds and ends
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
To: xfs@oss.sgi.com

Odds and ends in "xfs_log_recover.c".  This patch just contains a
bunch of minor things that didn't seem to warrant their own
individual patches.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_log_recover.c |   83 ++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -170,8 +170,8 @@ xlog_bread_noalign(
 	nbblks = round_up(nbblks, xlog_sectbb(log));
 
 	ASSERT(nbblks > 0);
-	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 	ASSERT(bp);
+	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
@@ -354,26 +354,28 @@ xlog_find_cycle_start(
 {
 	xfs_caddr_t	offset;
 	xfs_daddr_t	mid_blk;
+	xfs_daddr_t	end_blk;
 	uint		mid_cycle;
 	int		error;
 
-	mid_blk = BLK_AVG(first_blk, *last_blk);
-	while (mid_blk != first_blk && mid_blk != *last_blk) {
+	ASSERT(last_blk != NULL);
+	end_blk = *last_blk;
+	mid_blk = BLK_AVG(first_blk, end_blk);
+	while (mid_blk != first_blk && mid_blk != end_blk) {
 		error = xlog_bread(log, mid_blk, 1, bp, &offset);
 		if (error)
 			return error;
 		mid_cycle = xlog_get_cycle(offset);
-		if (mid_cycle == cycle) {
-			*last_blk = mid_blk;
-			/* last_half_cycle == mid_cycle */
-		} else {
-			first_blk = mid_blk;
-			/* first_half_cycle == mid_cycle */
-		}
-		mid_blk = BLK_AVG(first_blk, *last_blk);
+		if (mid_cycle == cycle)
+			end_blk = mid_blk;   /* last_half_cycle == mid_cycle */
+		else
+			first_blk = mid_blk; /* first_half_cycle == mid_cycle */
+		mid_blk = BLK_AVG(first_blk, end_blk);
 	}
-	ASSERT((mid_blk == first_blk && mid_blk+1 == *last_blk) ||
-	       (mid_blk == *last_blk && mid_blk-1 == first_blk));
+	ASSERT((mid_blk == first_blk && mid_blk+1 == end_blk) ||
+	       (mid_blk == end_blk && mid_blk-1 == first_blk));
+
+	*last_blk = end_blk;
 
 	return 0;
 }
@@ -385,8 +387,11 @@ xlog_find_cycle_start(
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
@@ -471,7 +476,7 @@ xlog_find_verify_log_record(
 	int			num_blks = *last_blk - start_blk;
 	int			xhdrs;
 
-	ASSERT(start_blk != 0 || *last_blk != start_blk);
+	ASSERT(start_blk < *last_blk);
 
 	if (!(bp = xlog_get_bp(log, num_blks))) {
 		if (!(bp = xlog_get_bp(log, 1)))
@@ -514,7 +519,7 @@ xlog_find_verify_log_record(
 	 * to caller.  If caller can handle a return of -1, then this routine
 	 * will be called again for the end of the physical log.
 	 */
-	if (i == -1) {
+	if (i < 0) {
 		error = -1;
 		goto out;
 	}
@@ -660,7 +665,7 @@ xlog_find_head(
 		 * In this case we want to find the first block with cycle
 		 * number matching last_half_cycle.  We expect the log to be
 		 * some variation on
-		 *        x + 1 ... | x ...
+		 *        x + 1 ... | x ... | x
 		 * The first block with cycle number x (last_half_cycle) will
 		 * be where the new head belongs.  First we do a binary search
 		 * for the first occurrence of last_half_cycle.  The binary
@@ -670,11 +675,13 @@ xlog_find_head(
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
@@ -730,16 +737,16 @@ xlog_find_head(
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
 			goto bp_err;
 		if (new_blk != -1) {
 			head_blk = new_blk;
-			goto bad_blk;
+			goto fine_tune;
 		}
 
 		/*
@@ -757,7 +764,7 @@ xlog_find_head(
 			head_blk = new_blk;
 	}
 
- bad_blk:
+fine_tune:
 	/*
 	 * Now we need to make sure head_blk is not pointing to a block in
 	 * the middle of a log record.
@@ -779,7 +786,7 @@ xlog_find_head(
 		if ((error = xlog_find_verify_log_record(log, start_blk,
 							&head_blk, 0)) == -1) {
 			/* We hit the beginning of the log during our search */
-			start_blk = log_bbnum - num_scan_bblks + head_blk;
+			start_blk = log_bbnum - (num_scan_bblks - head_blk);
 			new_blk = log_bbnum;
 			ASSERT(start_blk <= INT_MAX &&
 				(xfs_daddr_t) log_bbnum-start_blk >= 0);
@@ -796,12 +803,10 @@ xlog_find_head(
 		} else if (error)
 			goto bp_err;
 	}
-
 	xlog_put_bp(bp);
-	if (head_blk == log_bbnum)
-		*return_head_blk = 0;
-	else
-		*return_head_blk = head_blk;
+
+	ASSERT(log_bbnum != 0);
+	*return_head_blk = head_blk % log_bbnum;
 	/*
 	 * When returning here, we have a good block number.  Bad block
 	 * means that during a previous crash, we didn't have a clean break
@@ -864,12 +869,12 @@ xlog_find_tail(
 	if (*head_blk == 0) {				/* special case */
 		error = xlog_bread(log, 0, 1, bp, &offset);
 		if (error)
-			goto bread_err;
+			goto done;
 
 		if (xlog_get_cycle(offset) == 0) {
 			*tail_blk = 0;
 			/* leave all other log inited values alone */
-			goto exit;
+			goto done;
 		}
 	}
 
@@ -880,7 +885,7 @@ xlog_find_tail(
 	for (i = (int)(*head_blk) - 1; i >= 0; i--) {
 		error = xlog_bread(log, i, 1, bp, &offset);
 		if (error)
-			goto bread_err;
+			goto done;
 
 		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(*(__be32 *)offset)) {
 			found = 1;
@@ -897,7 +902,7 @@ xlog_find_tail(
 		for (i = log->l_logBBsize - 1; i >= (int)(*head_blk); i--) {
 			error = xlog_bread(log, i, 1, bp, &offset);
 			if (error)
-				goto bread_err;
+				goto done;
 
 			if (XLOG_HEADER_MAGIC_NUM ==
 			    be32_to_cpu(*(__be32 *)offset)) {
@@ -972,7 +977,7 @@ xlog_find_tail(
 		umount_data_blk = (i + hblks) % log->l_logBBsize;
 		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
 		if (error)
-			goto bread_err;
+			goto done;
 
 		op_head = (xlog_op_header_t *)offset;
 		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
@@ -1018,12 +1023,10 @@ xlog_find_tail(
 	 * But... if the -device- itself is readonly, just skip this.
 	 * We can't recover this device anyway, so it won't matter.
 	 */
-	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
+	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp))
 		error = xlog_clear_stale_blocks(log, tail_lsn);
-	}
 
-bread_err:
-exit:
+done:
 	xlog_put_bp(bp);
 
 	if (error)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
