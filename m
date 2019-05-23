Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56372 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731195AbfEWRl4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:41:56 -0400
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrj0-0002Sy-V6
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:41:56 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/20] xfs: stop using bp naming for log recovery buffers
Date: Thu, 23 May 2019 19:37:39 +0200
Message-Id: <20190523173742.15551-18-hch@lst.de>
In-Reply-To: <20190523173742.15551-1-hch@lst.de>
References: <20190523173742.15551-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that we don't use struct xfs_buf to hold log recovery buffer rename
the related functions and variables to just talk of a buffer instead of
using the bp name that we usually use for xfs_buf related functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 201 ++++++++++++++++++++-------------------
 1 file changed, 102 insertions(+), 99 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a28c9dc8f1f2..403c2c96ed71 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -79,7 +79,7 @@ struct xfs_buf_cancel {
  * are valid, false otherwise.
  */
 static inline bool
-xlog_verify_bp(
+xlog_verify_bno(
 	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		bbcount)
@@ -96,7 +96,7 @@ xlog_verify_bp(
  * a range of nbblks basic blocks at any valid offset within the log.
  */
 static char *
-xlog_get_bp(
+xlog_alloc_buffer(
 	struct xlog	*log,
 	int		nbblks)
 {
@@ -104,7 +104,7 @@ xlog_get_bp(
 	 * Pass log block 0 since we don't have an addr yet, buffer will be
 	 * verified on read.
 	 */
-	if (!xlog_verify_bp(log, 0, nbblks)) {
+	if (!xlog_verify_bno(log, 0, nbblks)) {
 		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
 			nbblks);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
@@ -153,7 +153,7 @@ xlog_do_io(
 {
 	int			error;
 
-	if (!xlog_verify_bp(log, blk_no, nbblks)) {
+	if (!xlog_verify_bno(log, blk_no, nbblks)) {
 		xfs_warn(log->l_mp,
 			 "Invalid log block/length (0x%llx, 0x%x) for buffer",
 			 blk_no, nbblks);
@@ -327,7 +327,7 @@ xlog_recover_iodone(
 STATIC int
 xlog_find_cycle_start(
 	struct xlog	*log,
-	char		*bp,
+	char		*buffer,
 	xfs_daddr_t	first_blk,
 	xfs_daddr_t	*last_blk,
 	uint		cycle)
@@ -341,7 +341,7 @@ xlog_find_cycle_start(
 	end_blk = *last_blk;
 	mid_blk = BLK_AVG(first_blk, end_blk);
 	while (mid_blk != first_blk && mid_blk != end_blk) {
-		error = xlog_bread(log, mid_blk, 1, bp, &offset);
+		error = xlog_bread(log, mid_blk, 1, buffer, &offset);
 		if (error)
 			return error;
 		mid_cycle = xlog_get_cycle(offset);
@@ -377,7 +377,7 @@ xlog_find_verify_cycle(
 {
 	xfs_daddr_t	i, j;
 	uint		cycle;
-	char		*bp;
+	char		*buffer;
 	xfs_daddr_t	bufblks;
 	char		*buf = NULL;
 	int		error = 0;
@@ -391,7 +391,7 @@ xlog_find_verify_cycle(
 	bufblks = 1 << ffs(nbblks);
 	while (bufblks > log->l_logBBsize)
 		bufblks >>= 1;
-	while (!(bp = xlog_get_bp(log, bufblks))) {
+	while (!(buffer = xlog_alloc_buffer(log, bufblks))) {
 		bufblks >>= 1;
 		if (bufblks < log->l_sectBBsize)
 			return -ENOMEM;
@@ -402,7 +402,7 @@ xlog_find_verify_cycle(
 
 		bcount = min(bufblks, (start_blk + nbblks - i));
 
-		error = xlog_bread(log, i, bcount, bp, &buf);
+		error = xlog_bread(log, i, bcount, buffer, &buf);
 		if (error)
 			goto out;
 
@@ -420,7 +420,7 @@ xlog_find_verify_cycle(
 	*new_blk = -1;
 
 out:
-	kmem_free(bp);
+	kmem_free(buffer);
 	return error;
 }
 
@@ -444,7 +444,7 @@ xlog_find_verify_log_record(
 	int			extra_bblks)
 {
 	xfs_daddr_t		i;
-	char			*bp;
+	char			*buffer;
 	char			*offset = NULL;
 	xlog_rec_header_t	*head = NULL;
 	int			error = 0;
@@ -454,12 +454,14 @@ xlog_find_verify_log_record(
 
 	ASSERT(start_blk != 0 || *last_blk != start_blk);
 
-	if (!(bp = xlog_get_bp(log, num_blks))) {
-		if (!(bp = xlog_get_bp(log, 1)))
+	buffer = xlog_alloc_buffer(log, num_blks);
+	if (!buffer) {
+		buffer = xlog_alloc_buffer(log, 1);
+		if (!buffer)
 			return -ENOMEM;
 		smallmem = 1;
 	} else {
-		error = xlog_bread(log, start_blk, num_blks, bp, &offset);
+		error = xlog_bread(log, start_blk, num_blks, buffer, &offset);
 		if (error)
 			goto out;
 		offset += ((num_blks - 1) << BBSHIFT);
@@ -476,7 +478,7 @@ xlog_find_verify_log_record(
 		}
 
 		if (smallmem) {
-			error = xlog_bread(log, i, 1, bp, &offset);
+			error = xlog_bread(log, i, 1, buffer, &offset);
 			if (error)
 				goto out;
 		}
@@ -529,7 +531,7 @@ xlog_find_verify_log_record(
 		*last_blk = i;
 
 out:
-	kmem_free(bp);
+	kmem_free(buffer);
 	return error;
 }
 
@@ -551,7 +553,7 @@ xlog_find_head(
 	struct xlog	*log,
 	xfs_daddr_t	*return_head_blk)
 {
-	char		*bp;
+	char		*buffer;
 	char		*offset;
 	xfs_daddr_t	new_blk, first_blk, start_blk, last_blk, head_blk;
 	int		num_scan_bblks;
@@ -581,20 +583,20 @@ xlog_find_head(
 	}
 
 	first_blk = 0;			/* get cycle # of 1st block */
-	bp = xlog_get_bp(log, 1);
-	if (!bp)
+	buffer = xlog_alloc_buffer(log, 1);
+	if (!buffer)
 		return -ENOMEM;
 
-	error = xlog_bread(log, 0, 1, bp, &offset);
+	error = xlog_bread(log, 0, 1, buffer, &offset);
 	if (error)
-		goto bp_err;
+		goto out_free_buffer;
 
 	first_half_cycle = xlog_get_cycle(offset);
 
 	last_blk = head_blk = log_bbnum - 1;	/* get cycle # of last block */
-	error = xlog_bread(log, last_blk, 1, bp, &offset);
+	error = xlog_bread(log, last_blk, 1, buffer, &offset);
 	if (error)
-		goto bp_err;
+		goto out_free_buffer;
 
 	last_half_cycle = xlog_get_cycle(offset);
 	ASSERT(last_half_cycle != 0);
@@ -662,9 +664,10 @@ xlog_find_head(
 		 *                           ^ we want to locate this spot
 		 */
 		stop_on_cycle = last_half_cycle;
-		if ((error = xlog_find_cycle_start(log, bp, first_blk,
-						&head_blk, last_half_cycle)))
-			goto bp_err;
+		error = xlog_find_cycle_start(log, buffer, first_blk, &head_blk,
+				last_half_cycle);
+		if (error)
+			goto out_free_buffer;
 	}
 
 	/*
@@ -684,7 +687,7 @@ xlog_find_head(
 		if ((error = xlog_find_verify_cycle(log,
 						start_blk, num_scan_bblks,
 						stop_on_cycle, &new_blk)))
-			goto bp_err;
+			goto out_free_buffer;
 		if (new_blk != -1)
 			head_blk = new_blk;
 	} else {		/* need to read 2 parts of log */
@@ -721,7 +724,7 @@ xlog_find_head(
 		if ((error = xlog_find_verify_cycle(log, start_blk,
 					num_scan_bblks - (int)head_blk,
 					(stop_on_cycle - 1), &new_blk)))
-			goto bp_err;
+			goto out_free_buffer;
 		if (new_blk != -1) {
 			head_blk = new_blk;
 			goto validate_head;
@@ -737,7 +740,7 @@ xlog_find_head(
 		if ((error = xlog_find_verify_cycle(log,
 					start_blk, (int)head_blk,
 					stop_on_cycle, &new_blk)))
-			goto bp_err;
+			goto out_free_buffer;
 		if (new_blk != -1)
 			head_blk = new_blk;
 	}
@@ -756,13 +759,13 @@ xlog_find_head(
 		if (error == 1)
 			error = -EIO;
 		if (error)
-			goto bp_err;
+			goto out_free_buffer;
 	} else {
 		start_blk = 0;
 		ASSERT(head_blk <= INT_MAX);
 		error = xlog_find_verify_log_record(log, start_blk, &head_blk, 0);
 		if (error < 0)
-			goto bp_err;
+			goto out_free_buffer;
 		if (error == 1) {
 			/* We hit the beginning of the log during our search */
 			start_blk = log_bbnum - (num_scan_bblks - head_blk);
@@ -775,14 +778,14 @@ xlog_find_head(
 			if (error == 1)
 				error = -EIO;
 			if (error)
-				goto bp_err;
+				goto out_free_buffer;
 			if (new_blk != log_bbnum)
 				head_blk = new_blk;
 		} else if (error)
-			goto bp_err;
+			goto out_free_buffer;
 	}
 
-	kmem_free(bp);
+	kmem_free(buffer);
 	if (head_blk == log_bbnum)
 		*return_head_blk = 0;
 	else
@@ -795,9 +798,8 @@ xlog_find_head(
 	 */
 	return 0;
 
- bp_err:
-	kmem_free(bp);
-
+out_free_buffer:
+	kmem_free(buffer);
 	if (error)
 		xfs_warn(log->l_mp, "failed to find log head");
 	return error;
@@ -817,7 +819,7 @@ xlog_rseek_logrec_hdr(
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk,
 	int			count,
-	char			*bp,
+	char			*buffer,
 	xfs_daddr_t		*rblk,
 	struct xlog_rec_header	**rhead,
 	bool			*wrapped)
@@ -836,7 +838,7 @@ xlog_rseek_logrec_hdr(
 	 */
 	end_blk = head_blk > tail_blk ? tail_blk : 0;
 	for (i = (int) head_blk - 1; i >= end_blk; i--) {
-		error = xlog_bread(log, i, 1, bp, &offset);
+		error = xlog_bread(log, i, 1, buffer, &offset);
 		if (error)
 			goto out_error;
 
@@ -855,7 +857,7 @@ xlog_rseek_logrec_hdr(
 	 */
 	if (tail_blk >= head_blk && found != count) {
 		for (i = log->l_logBBsize - 1; i >= (int) tail_blk; i--) {
-			error = xlog_bread(log, i, 1, bp, &offset);
+			error = xlog_bread(log, i, 1, buffer, &offset);
 			if (error)
 				goto out_error;
 
@@ -891,7 +893,7 @@ xlog_seek_logrec_hdr(
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk,
 	int			count,
-	char			*bp,
+	char			*buffer,
 	xfs_daddr_t		*rblk,
 	struct xlog_rec_header	**rhead,
 	bool			*wrapped)
@@ -910,7 +912,7 @@ xlog_seek_logrec_hdr(
 	 */
 	end_blk = head_blk > tail_blk ? head_blk : log->l_logBBsize - 1;
 	for (i = (int) tail_blk; i <= end_blk; i++) {
-		error = xlog_bread(log, i, 1, bp, &offset);
+		error = xlog_bread(log, i, 1, buffer, &offset);
 		if (error)
 			goto out_error;
 
@@ -928,7 +930,7 @@ xlog_seek_logrec_hdr(
 	 */
 	if (tail_blk > head_blk && found != count) {
 		for (i = 0; i < (int) head_blk; i++) {
-			error = xlog_bread(log, i, 1, bp, &offset);
+			error = xlog_bread(log, i, 1, buffer, &offset);
 			if (error)
 				goto out_error;
 
@@ -991,22 +993,22 @@ xlog_verify_tail(
 	int			hsize)
 {
 	struct xlog_rec_header	*thead;
-	char			*bp;
+	char			*buffer;
 	xfs_daddr_t		first_bad;
 	int			error = 0;
 	bool			wrapped;
 	xfs_daddr_t		tmp_tail;
 	xfs_daddr_t		orig_tail = *tail_blk;
 
-	bp = xlog_get_bp(log, 1);
-	if (!bp)
+	buffer = xlog_alloc_buffer(log, 1);
+	if (!buffer)
 		return -ENOMEM;
 
 	/*
 	 * Make sure the tail points to a record (returns positive count on
 	 * success).
 	 */
-	error = xlog_seek_logrec_hdr(log, head_blk, *tail_blk, 1, bp,
+	error = xlog_seek_logrec_hdr(log, head_blk, *tail_blk, 1, buffer,
 			&tmp_tail, &thead, &wrapped);
 	if (error < 0)
 		goto out;
@@ -1035,8 +1037,8 @@ xlog_verify_tail(
 			break;
 
 		/* skip to the next record; returns positive count on success */
-		error = xlog_seek_logrec_hdr(log, head_blk, first_bad, 2, bp,
-				&tmp_tail, &thead, &wrapped);
+		error = xlog_seek_logrec_hdr(log, head_blk, first_bad, 2,
+				buffer, &tmp_tail, &thead, &wrapped);
 		if (error < 0)
 			goto out;
 
@@ -1051,7 +1053,7 @@ xlog_verify_tail(
 		"Tail block (0x%llx) overwrite detected. Updated to 0x%llx",
 			 orig_tail, *tail_blk);
 out:
-	kmem_free(bp);
+	kmem_free(buffer);
 	return error;
 }
 
@@ -1073,13 +1075,13 @@ xlog_verify_head(
 	struct xlog		*log,
 	xfs_daddr_t		*head_blk,	/* in/out: unverified head */
 	xfs_daddr_t		*tail_blk,	/* out: tail block */
-	char			*bp,
+	char			*buffer,
 	xfs_daddr_t		*rhead_blk,	/* start blk of last record */
 	struct xlog_rec_header	**rhead,	/* ptr to last record */
 	bool			*wrapped)	/* last rec. wraps phys. log */
 {
 	struct xlog_rec_header	*tmp_rhead;
-	char			*tmp_bp;
+	char			*tmp_buffer;
 	xfs_daddr_t		first_bad;
 	xfs_daddr_t		tmp_rhead_blk;
 	int			found;
@@ -1090,15 +1092,15 @@ xlog_verify_head(
 	 * Check the head of the log for torn writes. Search backwards from the
 	 * head until we hit the tail or the maximum number of log record I/Os
 	 * that could have been in flight at one time. Use a temporary buffer so
-	 * we don't trash the rhead/bp pointers from the caller.
+	 * we don't trash the rhead/buffer pointers from the caller.
 	 */
-	tmp_bp = xlog_get_bp(log, 1);
-	if (!tmp_bp)
+	tmp_buffer = xlog_alloc_buffer(log, 1);
+	if (!tmp_buffer)
 		return -ENOMEM;
 	error = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
-				      XLOG_MAX_ICLOGS, tmp_bp, &tmp_rhead_blk,
-				      &tmp_rhead, &tmp_wrapped);
-	kmem_free(tmp_bp);
+				      XLOG_MAX_ICLOGS, tmp_buffer,
+				      &tmp_rhead_blk, &tmp_rhead, &tmp_wrapped);
+	kmem_free(tmp_buffer);
 	if (error < 0)
 		return error;
 
@@ -1127,8 +1129,8 @@ xlog_verify_head(
 		 * (i.e., the records with invalid CRC) if the cycle number
 		 * matches the the current cycle.
 		 */
-		found = xlog_rseek_logrec_hdr(log, first_bad, *tail_blk, 1, bp,
-					      rhead_blk, rhead, wrapped);
+		found = xlog_rseek_logrec_hdr(log, first_bad, *tail_blk, 1,
+				buffer, rhead_blk, rhead, wrapped);
 		if (found < 0)
 			return found;
 		if (found == 0)		/* XXX: right thing to do here? */
@@ -1188,7 +1190,7 @@ xlog_check_unmount_rec(
 	xfs_daddr_t		*tail_blk,
 	struct xlog_rec_header	*rhead,
 	xfs_daddr_t		rhead_blk,
-	char			*bp,
+	char			*buffer,
 	bool			*clean)
 {
 	struct xlog_op_header	*op_head;
@@ -1231,7 +1233,7 @@ xlog_check_unmount_rec(
 	if (*head_blk == after_umount_blk &&
 	    be32_to_cpu(rhead->h_num_logops) == 1) {
 		umount_data_blk = xlog_wrap_logbno(log, rhead_blk + hblks);
-		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
+		error = xlog_bread(log, umount_data_blk, 1, buffer, &offset);
 		if (error)
 			return error;
 
@@ -1310,7 +1312,7 @@ xlog_find_tail(
 {
 	xlog_rec_header_t	*rhead;
 	char			*offset = NULL;
-	char			*bp;
+	char			*buffer;
 	int			error;
 	xfs_daddr_t		rhead_blk;
 	xfs_lsn_t		tail_lsn;
@@ -1324,11 +1326,11 @@ xlog_find_tail(
 		return error;
 	ASSERT(*head_blk < INT_MAX);
 
-	bp = xlog_get_bp(log, 1);
-	if (!bp)
+	buffer = xlog_alloc_buffer(log, 1);
+	if (!buffer)
 		return -ENOMEM;
 	if (*head_blk == 0) {				/* special case */
-		error = xlog_bread(log, 0, 1, bp, &offset);
+		error = xlog_bread(log, 0, 1, buffer, &offset);
 		if (error)
 			goto done;
 
@@ -1344,7 +1346,7 @@ xlog_find_tail(
 	 * block. This wraps all the way back around to the head so something is
 	 * seriously wrong if we can't find it.
 	 */
-	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, bp,
+	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, buffer,
 				      &rhead_blk, &rhead, &wrapped);
 	if (error < 0)
 		return error;
@@ -1365,7 +1367,7 @@ xlog_find_tail(
 	 * state to determine whether recovery is necessary.
 	 */
 	error = xlog_check_unmount_rec(log, head_blk, tail_blk, rhead,
-				       rhead_blk, bp, &clean);
+				       rhead_blk, buffer, &clean);
 	if (error)
 		goto done;
 
@@ -1382,7 +1384,7 @@ xlog_find_tail(
 	if (!clean) {
 		xfs_daddr_t	orig_head = *head_blk;
 
-		error = xlog_verify_head(log, head_blk, tail_blk, bp,
+		error = xlog_verify_head(log, head_blk, tail_blk, buffer,
 					 &rhead_blk, &rhead, &wrapped);
 		if (error)
 			goto done;
@@ -1393,7 +1395,7 @@ xlog_find_tail(
 				       wrapped);
 			tail_lsn = atomic64_read(&log->l_tail_lsn);
 			error = xlog_check_unmount_rec(log, head_blk, tail_blk,
-						       rhead, rhead_blk, bp,
+						       rhead, rhead_blk, buffer,
 						       &clean);
 			if (error)
 				goto done;
@@ -1431,7 +1433,7 @@ xlog_find_tail(
 		error = xlog_clear_stale_blocks(log, tail_lsn);
 
 done:
-	kmem_free(bp);
+	kmem_free(buffer);
 
 	if (error)
 		xfs_warn(log->l_mp, "failed to locate log tail");
@@ -1459,7 +1461,7 @@ xlog_find_zeroed(
 	struct xlog	*log,
 	xfs_daddr_t	*blk_no)
 {
-	char		*bp;
+	char		*buffer;
 	char		*offset;
 	uint	        first_cycle, last_cycle;
 	xfs_daddr_t	new_blk, last_blk, start_blk;
@@ -1469,35 +1471,36 @@ xlog_find_zeroed(
 	*blk_no = 0;
 
 	/* check totally zeroed log */
-	bp = xlog_get_bp(log, 1);
-	if (!bp)
+	buffer = xlog_alloc_buffer(log, 1);
+	if (!buffer)
 		return -ENOMEM;
-	error = xlog_bread(log, 0, 1, bp, &offset);
+	error = xlog_bread(log, 0, 1, buffer, &offset);
 	if (error)
-		goto bp_err;
+		goto out_free_buffer;
 
 	first_cycle = xlog_get_cycle(offset);
 	if (first_cycle == 0) {		/* completely zeroed log */
 		*blk_no = 0;
-		kmem_free(bp);
+		kmem_free(buffer);
 		return 1;
 	}
 
 	/* check partially zeroed log */
-	error = xlog_bread(log, log_bbnum-1, 1, bp, &offset);
+	error = xlog_bread(log, log_bbnum-1, 1, buffer, &offset);
 	if (error)
-		goto bp_err;
+		goto out_free_buffer;
 
 	last_cycle = xlog_get_cycle(offset);
 	if (last_cycle != 0) {		/* log completely written to */
-		kmem_free(bp);
+		kmem_free(buffer);
 		return 0;
 	}
 
 	/* we have a partially zeroed log */
 	last_blk = log_bbnum-1;
-	if ((error = xlog_find_cycle_start(log, bp, 0, &last_blk, 0)))
-		goto bp_err;
+	error = xlog_find_cycle_start(log, buffer, 0, &last_blk, 0);
+	if (error)
+		goto out_free_buffer;
 
 	/*
 	 * Validate the answer.  Because there is no way to guarantee that
@@ -1520,7 +1523,7 @@ xlog_find_zeroed(
 	 */
 	if ((error = xlog_find_verify_cycle(log, start_blk,
 					 (int)num_scan_bblks, 0, &new_blk)))
-		goto bp_err;
+		goto out_free_buffer;
 	if (new_blk != -1)
 		last_blk = new_blk;
 
@@ -1532,11 +1535,11 @@ xlog_find_zeroed(
 	if (error == 1)
 		error = -EIO;
 	if (error)
-		goto bp_err;
+		goto out_free_buffer;
 
 	*blk_no = last_blk;
-bp_err:
-	kmem_free(bp);
+out_free_buffer:
+	kmem_free(buffer);
 	if (error)
 		return error;
 	return 1;
@@ -1579,7 +1582,7 @@ xlog_write_log_records(
 	int		tail_block)
 {
 	char		*offset;
-	char		*bp;
+	char		*buffer;
 	int		balign, ealign;
 	int		sectbb = log->l_sectBBsize;
 	int		end_block = start_block + blocks;
@@ -1596,7 +1599,7 @@ xlog_write_log_records(
 	bufblks = 1 << ffs(blocks);
 	while (bufblks > log->l_logBBsize)
 		bufblks >>= 1;
-	while (!(bp = xlog_get_bp(log, bufblks))) {
+	while (!(buffer = xlog_alloc_buffer(log, bufblks))) {
 		bufblks >>= 1;
 		if (bufblks < sectbb)
 			return -ENOMEM;
@@ -1608,9 +1611,9 @@ xlog_write_log_records(
 	 */
 	balign = round_down(start_block, sectbb);
 	if (balign != start_block) {
-		error = xlog_bread_noalign(log, start_block, 1, bp);
+		error = xlog_bread_noalign(log, start_block, 1, buffer);
 		if (error)
-			goto out_put_bp;
+			goto out_free_buffer;
 
 		j = start_block - balign;
 	}
@@ -1628,27 +1631,27 @@ xlog_write_log_records(
 		ealign = round_down(end_block, sectbb);
 		if (j == 0 && (start_block + endcount > ealign)) {
 			error = xlog_bread_noalign(log, ealign, sectbb,
-					bp + BBTOB(ealign - start_block));
+					buffer + BBTOB(ealign - start_block));
 			if (error)
 				break;
 
 		}
 
-		offset = bp + xlog_align(log, start_block);
+		offset = buffer + xlog_align(log, start_block);
 		for (; j < endcount; j++) {
 			xlog_add_record(log, offset, cycle, i+j,
 					tail_cycle, tail_block);
 			offset += BBSIZE;
 		}
-		error = xlog_bwrite(log, start_block, endcount, bp);
+		error = xlog_bwrite(log, start_block, endcount, buffer);
 		if (error)
 			break;
 		start_block += endcount;
 		j = 0;
 	}
 
- out_put_bp:
-	kmem_free(bp);
+out_free_buffer:
+	kmem_free(buffer);
 	return error;
 }
 
@@ -5253,7 +5256,7 @@ xlog_do_recovery_pass(
 		 * iclog header and extract the header size from it.  Get a
 		 * new hbp that is the correct size.
 		 */
-		hbp = xlog_get_bp(log, 1);
+		hbp = xlog_alloc_buffer(log, 1);
 		if (!hbp)
 			return -ENOMEM;
 
@@ -5296,20 +5299,20 @@ xlog_do_recovery_pass(
 			if (h_size % XLOG_HEADER_CYCLE_SIZE)
 				hblks++;
 			kmem_free(hbp);
-			hbp = xlog_get_bp(log, hblks);
+			hbp = xlog_alloc_buffer(log, hblks);
 		} else {
 			hblks = 1;
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);
 		hblks = 1;
-		hbp = xlog_get_bp(log, 1);
+		hbp = xlog_alloc_buffer(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
 	}
 
 	if (!hbp)
 		return -ENOMEM;
-	dbp = xlog_get_bp(log, BTOBB(h_size));
+	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
 	if (!dbp) {
 		kmem_free(hbp);
 		return -ENOMEM;
-- 
2.20.1
