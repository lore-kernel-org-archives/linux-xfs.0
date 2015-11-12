Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 681457F6D
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 09:37:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2FEEAC005
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ijQbGgxqOCGDVQ1S (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:30 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id E403FB4C4D
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 15:37:29 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-36.bos.redhat.com [10.18.41.36])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tACFbTm3014213
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:37:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 7/8] xfs: detect and trim torn writes during log recovery
Date: Thu, 12 Nov 2015 10:37:27 -0500
Message-Id: <1447342648-40012-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
References: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
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

Certain types of storage, such as persistent memory, do not provide
sector atomicity for writes. This means that if a crash occurs while XFS
is writing log records, only part of those records might make it to the
storage. This is problematic because log recovery uses the cycle value
packed at the top of each log block to locate the head/tail of the log.
This can lead to CRC verification failures during log recovery and an
unmountable fs for a filesystem that is otherwise consistent.

Update log recovery to incorporate log record CRC verification as part
of the head/tail discovery process. Once the head is located via the
traditional algorithm, run a CRC-only pass over the records up to the
head of the log. If CRC verification fails, assume that the records are
torn as a matter of policy and trim the head block back to the start of
the first bad record.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 306 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 287 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 423c36d..5bf8076 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -61,6 +61,9 @@ xlog_recover_check_summary(
 #else
 #define	xlog_recover_check_summary(log)
 #endif
+STATIC int
+xlog_do_recovery_pass(
+        struct xlog *, xfs_daddr_t, xfs_daddr_t, int, xfs_daddr_t *);
 
 /*
  * This structure is used during recovery to record the buf log items which
@@ -941,6 +944,278 @@ out_error:
 }
 
 /*
+ * Seek forward in the log for log record headers.
+ *
+ * Given head and tail blocks, walk forward from the tail block until we find
+ * the provided number of records or hit the head block. The return value is the
+ * number of records encountered or a negative error code. The log block and
+ * buffer pointer of the last record seen are returned in rblk and rhead
+ * respectively.
+ */
+STATIC int
+xlog_seek_logrec_hdr(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		tail_blk,
+	int			count,
+	struct xfs_buf		*bp,
+	xfs_daddr_t		*rblk,
+	struct xlog_rec_header	**rhead,
+	bool			*wrapped)
+{
+	int			i;
+	int			error;
+	int			found = 0;
+	char			*offset = NULL;
+	xfs_daddr_t		end_blk;
+
+	*wrapped = false;
+
+	/*
+	 * Walk forward from the tail block until we hit the head or the last
+	 * block in the log.
+	 */
+	end_blk = head_blk > tail_blk ? head_blk : log->l_logBBsize - 1;
+	for (i = (int) tail_blk; i <= end_blk; i++) {
+		error = xlog_bread(log, i, 1, bp, &offset);
+		if (error)
+			goto out_error;
+
+		if (*(__be32 *) offset == cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
+			*rblk = i;
+			*rhead = (struct xlog_rec_header *) offset;
+			if (++found == count)
+				break;
+		}
+	}
+
+	/*
+	 * If we haven't hit the head block or the log record header count,
+	 * start looking again from the start of the physical log.
+	 */
+	if (tail_blk > head_blk && found != count) {
+		for (i = 0; i < (int) head_blk; i++) {
+			error = xlog_bread(log, i, 1, bp, &offset);
+			if (error)
+				goto out_error;
+
+			if (*(__be32 *)offset ==
+			    cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
+				*wrapped = true;
+				*rblk = i;
+				*rhead = (struct xlog_rec_header *) offset;
+				if (++found == count)
+					break;
+			}
+		}
+	}
+
+	return found;
+
+out_error:
+	return error;
+}
+
+/*
+ * Check the log tail for torn writes. This is required when torn writes are
+ * detected at the head and the head had to be walked back to a previous record.
+ * The tail of the previous record must now be verified to ensure the torn
+ * writes didn't corrupt the previous tail.
+ *
+ * Return an error if CRC verification fails as recovery cannot proceed.
+ */
+STATIC int
+xlog_verify_tail(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		tail_blk)
+{
+	struct xlog_rec_header	*thead;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		first_bad;
+	int			count;
+	int			error = 0;
+	bool			wrapped;
+	xfs_daddr_t		tmp_head;
+
+	bp = xlog_get_bp(log, 1);
+	if (!bp)
+		return -ENOMEM;
+
+	/*
+	 * Seek XLOG_MAX_ICLOGS + 1 records past the current tail record to get
+	 * a temporary head block that points after the last possible
+	 * concurrently written record of the tail.
+	 */
+	count = xlog_seek_logrec_hdr(log, head_blk, tail_blk,
+				     XLOG_MAX_ICLOGS + 1, bp, &tmp_head, &thead,
+				     &wrapped);
+	if (count < 0) {
+		error = count;
+		goto out;
+	}
+
+	/*
+	 * If the call above didn't find XLOG_MAX_ICLOGS + 1 records, we ran
+	 * into the actual log head. tmp_head points to the start of the record
+	 * so update it to the actual head block.
+	 */
+	if (count < XLOG_MAX_ICLOGS + 1)
+		tmp_head = head_blk;
+
+	/*
+	 * We now have a tail and temporary head block that covers at least
+	 * XLOG_MAX_ICLOGS records from the tail. We need to verify that these
+	 * records were completely written. Run a CRC verification pass from
+	 * tail to head and return the result.
+	 */
+	error = xlog_do_recovery_pass(log, tmp_head, tail_blk,
+				      XLOG_RECOVER_CRCPASS, &first_bad);
+
+out:
+	xlog_put_bp(bp);
+	return error;
+}
+
+/*
+ * Detect and trim torn writes from the head of the log.
+ *
+ * Storage without sector atomicity guarantees can result in torn writes in the
+ * log in the event of a crash. Our only means to detect this scenario is via
+ * CRC verification. While we can't always be certain that CRC verification
+ * failure is due to a torn write vs. an unrelated corruption, we do know that
+ * only a certain number (XLOG_MAX_ICLOGS) of log records can be written out at
+ * one time. Therefore, CRC verify up to XLOG_MAX_ICLOGS records at the head of
+ * the log and treat failures in this range as torn writes as a matter of
+ * policy. In the event of CRC failure, the head is walked back to the last good
+ * record in the log and the tail is updated from that record and verified.
+ */
+STATIC int
+xlog_verify_head(
+	struct xlog		*log,
+	xfs_daddr_t		*head_blk,	/* in/out: unverified head */
+	xfs_daddr_t		*tail_blk,	/* out: tail block */
+	struct xfs_buf		*bp,
+	xfs_daddr_t		*rhead_blk,	/* start blk of last record */
+	struct xlog_rec_header	**rhead,	/* ptr to last record */
+	bool			*wrapped)	/* last rec. wraps phys. log */
+{
+	struct xlog_rec_header	*tmp_rhead;
+	struct xfs_buf		*tmp_bp;
+	xfs_daddr_t		first_bad;
+	xfs_daddr_t		tmp_rhead_blk;
+	int			found;
+	int			error;
+	bool			tmp_wrapped;
+
+	/*
+	 * Search backwards through the log looking for the log record header
+	 * block. This wraps all the way back around to the head so something is
+	 * seriously wrong if we can't find it.
+	 */
+	found = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, bp, rhead_blk,
+				      rhead, wrapped);
+	if (found < 0)
+		return found;
+	if (!found) {
+		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
+		return -EIO;
+	}
+
+	*tail_blk = BLOCK_LSN(be64_to_cpu((*rhead)->h_tail_lsn));
+
+	/*
+	 * Now that we have a tail block, check the head of the log for torn
+	 * writes. Search again until we hit the tail or the maximum number of
+	 * log record I/Os that could have been in flight at one time. Use a
+	 * temporary buffer so we don't trash the rhead/bp pointer from the
+	 * call above.
+	 */
+	tmp_bp = xlog_get_bp(log, 1);
+	if (!tmp_bp)
+		return -ENOMEM;
+	error = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
+				      XLOG_MAX_ICLOGS, tmp_bp, &tmp_rhead_blk,
+				      &tmp_rhead, &tmp_wrapped);
+	xlog_put_bp(tmp_bp);
+	if (error < 0)
+		return error;
+
+	/*
+	 * Now run a CRC verification pass over the records starting at the
+	 * block found above to the current head. If a CRC failure occurs, the
+	 * log block of the first bad record is saved in first_bad.
+	 */
+	error = xlog_do_recovery_pass(log, *head_blk, tmp_rhead_blk,
+				      XLOG_RECOVER_CRCPASS, &first_bad);
+	if (error == -EFSBADCRC) {
+		/*
+		 * We've hit a potential torn write. Reset the error and warn
+		 * about it.
+		 */
+		error = 0;
+		xfs_warn(log->l_mp,
+"Torn write (CRC failure) detected at log block 0x%llx. Truncating head block from 0x%llx.",
+			 first_bad, *head_blk);
+
+		/*
+		 * Get the header block and buffer pointer for the last good
+		 * record before the bad record.
+		 *
+		 * Note that xlog_find_tail() clears the blocks at the new head
+		 * (i.e., the records with invalid CRC) if the cycle number
+		 * matches the the current cycle.
+		 */
+		found = xlog_rseek_logrec_hdr(log, first_bad, *tail_blk, 1, bp,
+					      rhead_blk, rhead, wrapped);
+		if (found < 0)
+			return found;
+		if (found == 0)		/* XXX: right thing to do here? */
+			return -EIO;
+
+		/*
+		 * Reset the head block to the starting block of the first bad
+		 * log record and set the tail block based on the last good
+		 * record.
+		 *
+		 * Bail out if the updated head/tail match as this indicates
+		 * possible corruption outside of the acceptable
+		 * (XLOG_MAX_ICLOGS) range. This is a job for xfs_repair...
+		 */
+		*head_blk = first_bad;
+		*tail_blk = BLOCK_LSN(be64_to_cpu((*rhead)->h_tail_lsn));
+		if (*head_blk == *tail_blk) {
+			ASSERT(0);
+			return 0;
+		}
+
+		/*
+		 * Now verify the tail based on the updated head. This is
+		 * required because the torn writes trimmed from the head could
+		 * have been written over the tail of a previous record. Return
+		 * any errors since recovery cannot proceed if the tail is
+		 * corrupt.
+		 *
+		 * XXX: This leaves a gap in truly robust protection from torn
+		 * writes in the log. If the head is behind the tail, the tail
+		 * pushes forward to create some space and then a crash occurs
+		 * causing the writes into the previous record's tail region to
+		 * tear, log recovery isn't able to recover.
+		 *
+		 * How likely is this to occur? If possible, can we do something
+		 * more intelligent here? Is it safe to push the tail forward if
+		 * we can determine that the tail is within the range of the
+		 * torn write (e.g., the kernel can only overwrite the tail if
+		 * it has actually been pushed forward)? Alternatively, could we
+		 * somehow prevent this condition at runtime?
+		 */
+		error = xlog_verify_tail(log, *head_blk, *tail_blk);
+	}
+
+	return error;
+}
+
+/*
  * Find the sync block number or the tail of the log.
  *
  * This will be the block number of the last record to have its
@@ -966,9 +1241,10 @@ xlog_find_tail(
 	xlog_op_header_t	*op_head;
 	char			*offset = NULL;
 	xfs_buf_t		*bp;
-	int			error, i, found;
+	int			error;
 	xfs_daddr_t		umount_data_blk;
 	xfs_daddr_t		after_umount_blk;
+	xfs_daddr_t		rhead_blk;
 	xfs_lsn_t		tail_lsn;
 	int			hblks;
 	bool			wrapped = false;
@@ -995,24 +1271,16 @@ xlog_find_tail(
 	}
 
 	/*
-	 * Search backwards through the log looking for the log record header
-	 * block. This wraps all the way back around to the head so something is
-	 * seriously wrong if we can't find it.
+	 * Trim the head block back to skip over torn records. We can have
+	 * multiple log I/Os in flight at any time, so we assume CRC failures
+	 * back through the previous several records are torn writes and skip
+	 * them.
 	 */
 	ASSERT(*head_blk < INT_MAX);
-	found = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, bp, &i,
-				      &rhead, &wrapped);
-	if (found < 0) {
-		error = found;
+	error = xlog_verify_head(log, head_blk, tail_blk, bp, &rhead_blk,
+				 &rhead, &wrapped);
+	if (error)
 		goto done;
-	}
-	if (!found) {
-		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		xlog_put_bp(bp);
-		ASSERT(0);
-		return -EIO;
-	}
-	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
 	/*
 	 * Reset log values according to the state of the log when we
@@ -1024,7 +1292,7 @@ xlog_find_tail(
 	 * written was complete and ended exactly on the end boundary
 	 * of the physical log.
 	 */
-	log->l_prev_block = i;
+	log->l_prev_block = rhead_blk;
 	log->l_curr_block = (int)*head_blk;
 	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
 	if (wrapped)
@@ -1062,12 +1330,12 @@ xlog_find_tail(
 	} else {
 		hblks = 1;
 	}
-	after_umount_blk = (i + hblks + (int)
+	after_umount_blk = (rhead_blk + hblks + (int)
 		BTOBB(be32_to_cpu(rhead->h_len))) % log->l_logBBsize;
 	tail_lsn = atomic64_read(&log->l_tail_lsn);
 	if (*head_blk == after_umount_blk &&
 	    be32_to_cpu(rhead->h_num_logops) == 1) {
-		umount_data_blk = (i + hblks) % log->l_logBBsize;
+		umount_data_blk = (rhead_blk + hblks) % log->l_logBBsize;
 		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
 		if (error)
 			goto done;
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
