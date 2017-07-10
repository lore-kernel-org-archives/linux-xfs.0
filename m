Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754148AbdGJN2C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 09:28:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9DA2B19D28C
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66E2C53C32
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/6] xfs: fix log recovery corruption error due to tail overwrite
Date: Mon, 10 Jul 2017 09:27:57 -0400
Message-Id: <20170710132800.19506-4-bfoster@redhat.com>
In-Reply-To: <20170710132800.19506-1-bfoster@redhat.com>
References: <20170710132800.19506-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

If we consider the case where the tail (T) of the log is pinned long
enough for the head (H) to push and block behind the tail, we can
end up blocked in the following state without enough free space (f)
in the log to satisfy a transaction reservation:

	0	phys. log	N
	[-------HffT---H'--T'---]

The last good record in the log (before H) refers to T. The tail
eventually pushes forward (T') leaving more free space in the log
for writes to H. At this point, suppose space frees up in the log
for the maximum of 8 in-core log buffers to start flushing out to
the log. If this pushes the head from H to H', these next writes
overwrite the previous tail T. This is safe because the items logged
from T to T' have been written back and removed from the AIL.

If the next log writes (H -> H') happen to fail and result in
partial records in the log, the filesystem shuts down having
overwritten T with invalid data. Log recovery correctly locates H on
the subsequent mount, but H still refers to the now corrupted tail
T. This results in log corruption errors and recovery failure.

Since the tail overwrite results from otherwise correct runtime
behavior, it is up to log recovery to try and deal with this
situation. Update log recovery tail verification to run a CRC pass
from the first record past the tail to the head. This facilitates
error detection at T and moves the recovery tail to the first good
record past H' (similar to truncating the head on torn write
detection). If corruption is detected beyond the range possibly
affected by the max number of iclogs, the log is legitimately
corrupted and log recovery failure is expected.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 108 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 77 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 72c12b1..d3bef45 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1029,61 +1029,106 @@ xlog_seek_logrec_hdr(
 }
 
 /*
- * Check the log tail for torn writes. This is required when torn writes are
- * detected at the head and the head had to be walked back to a previous record.
- * The tail of the previous record must now be verified to ensure the torn
- * writes didn't corrupt the previous tail.
+ * Calculate distance from head to tail (i.e., unused space in the log).
+ */
+static inline int
+xlog_tail_distance(
+	struct xlog	*log,
+	xfs_daddr_t	head_blk,
+	xfs_daddr_t	tail_blk)
+{
+	if (head_blk < tail_blk)
+		return tail_blk - head_blk;
+
+	return tail_blk + (log->l_logBBsize - head_blk);
+}
+
+/*
+ * Verify the log tail. This is particularly important when torn or incomplete
+ * writes have been detected near the front of the log and the head has been
+ * walked back accordingly.
+ *
+ * We also have to handle the case where the tail was pinned and the head
+ * blocked behind the tail right before a crash. If the tail had been pushed
+ * immediately prior to the crash and the subsequent checkpoint was only
+ * partially written, it's possible it overwrote the last referenced tail in the
+ * log with garbage. This is not a coherency problem because the tail must have
+ * been pushed before it can be overwritten, but appears as log corruption to
+ * recovery because we have no way to know the tail was updated if the
+ * subsequent checkpoint didn't write successfully.
  *
- * Return an error if CRC verification fails as recovery cannot proceed.
+ * Therefore, CRC check the log from tail to head. If a failure occurs and the
+ * offending record is within max iclog bufs from the head, walk the tail
+ * forward and retry until a valid tail is found or corruption is detected out
+ * of the range of a possible overwrite.
  */
 STATIC int
 xlog_verify_tail(
 	struct xlog		*log,
 	xfs_daddr_t		head_blk,
-	xfs_daddr_t		tail_blk)
+	xfs_daddr_t		*tail_blk,
+	int			hsize)
 {
 	struct xlog_rec_header	*thead;
 	struct xfs_buf		*bp;
 	xfs_daddr_t		first_bad;
-	int			count;
 	int			error = 0;
 	bool			wrapped;
-	xfs_daddr_t		tmp_head;
+	xfs_daddr_t		tmp_tail;
+	xfs_daddr_t		orig_tail = *tail_blk;
 
 	bp = xlog_get_bp(log, 1);
 	if (!bp)
 		return -ENOMEM;
 
 	/*
-	 * Seek XLOG_MAX_ICLOGS + 1 records past the current tail record to get
-	 * a temporary head block that points after the last possible
-	 * concurrently written record of the tail.
+	 * Make sure the tail points to a record (returns positive count on
+	 * success).
 	 */
-	count = xlog_seek_logrec_hdr(log, head_blk, tail_blk,
-				     XLOG_MAX_ICLOGS + 1, bp, &tmp_head, &thead,
-				     &wrapped);
-	if (count < 0) {
-		error = count;
+	error = xlog_seek_logrec_hdr(log, head_blk, *tail_blk, 1, bp,
+			&tmp_tail, &thead, &wrapped);
+	if (error < 0)
 		goto out;
-	}
+	if (*tail_blk != tmp_tail)
+		*tail_blk = tmp_tail;
 
 	/*
-	 * If the call above didn't find XLOG_MAX_ICLOGS + 1 records, we ran
-	 * into the actual log head. tmp_head points to the start of the record
-	 * so update it to the actual head block.
+	 * Run a CRC check from the tail to the head. We can't just check
+	 * MAX_ICLOGS records past the tail because the tail may point to stale
+	 * blocks cleared during the search for the head/tail. These blocks are
+	 * overwritten with zero-length records and thus record count is not a
+	 * reliable indicator of the iclog state before a crash.
 	 */
-	if (count < XLOG_MAX_ICLOGS + 1)
-		tmp_head = head_blk;
-
-	/*
-	 * We now have a tail and temporary head block that covers at least
-	 * XLOG_MAX_ICLOGS records from the tail. We need to verify that these
-	 * records were completely written. Run a CRC verification pass from
-	 * tail to head and return the result.
-	 */
-	error = xlog_do_recovery_pass(log, tmp_head, tail_blk,
+	first_bad = 0;
+	error = xlog_do_recovery_pass(log, head_blk, *tail_blk,
 				      XLOG_RECOVER_CRCPASS, &first_bad);
+	while (error == -EFSBADCRC && first_bad) {
+		int	tail_distance;
+
+		/*
+		 * Is corruption within range of the head? If so, retry from
+		 * the next record. Otherwise return an error.
+		 */
+		tail_distance = xlog_tail_distance(log, head_blk, first_bad);
+		if (tail_distance > BTOBB(XLOG_MAX_ICLOGS * hsize))
+			break;
 
+		/* skip to the next record; returns positive count on success */
+		error = xlog_seek_logrec_hdr(log, head_blk, first_bad, 2, bp,
+				&tmp_tail, &thead, &wrapped);
+		if (error < 0)
+			goto out;
+
+		*tail_blk = tmp_tail;
+		first_bad = 0;
+		error = xlog_do_recovery_pass(log, head_blk, *tail_blk,
+					      XLOG_RECOVER_CRCPASS, &first_bad);
+	}
+
+	if (!error && *tail_blk != orig_tail)
+		xfs_warn(log->l_mp,
+		"Tail block (0x%llx) overwrite detected. Updated to 0x%llx",
+			 orig_tail, *tail_blk);
 out:
 	xlog_put_bp(bp);
 	return error;
@@ -1187,7 +1232,8 @@ xlog_verify_head(
 	if (error)
 		return error;
 
-	return xlog_verify_tail(log, *head_blk, *tail_blk);
+	return xlog_verify_tail(log, *head_blk, tail_blk,
+				be32_to_cpu((*rhead)->h_size));
 }
 
 /*
-- 
2.9.4

