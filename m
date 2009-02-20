Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K8r1BA164772 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 02:53:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 174451383A9
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:52:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QrUw1PRgcp9TOGXe for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:52:29 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LaR7V-00041R-Lo
	for xfs@oss.sgi.com; Fri, 20 Feb 2009 08:52:29 +0000
Message-Id: <20090220085229.488121000@bombadil.infradead.org>
Date: Fri, 20 Feb 2009 03:52:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/7] xfs: cleanup xlog_bread
References: <20090220085207.663702000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xlog_bread
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Most callers of xlog_bread need to call xlog_align to get the actual offset.
Consolidate that call into the main xlog_bread and provide a _xlog_bread
for those few that don't want the actual offset.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2009-02-10 19:16:19.308944151 +0100
+++ xfs/fs/xfs/xfs_log_priv.h	2009-02-10 19:22:43.915068626 +0100
@@ -455,7 +455,6 @@ extern void	 xlog_recover_process_iunlin
 
 extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
 extern void	 xlog_put_bp(struct xfs_buf *);
-extern int	 xlog_bread(xlog_t *, xfs_daddr_t, int, struct xfs_buf *);
 
 extern kmem_zone_t	*xfs_log_ticket_zone;
 
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-10 19:16:19.314973900 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-10 19:22:43.917068532 +0100
@@ -94,12 +94,30 @@ xlog_put_bp(
 	xfs_buf_free(bp);
 }
 
+STATIC xfs_caddr_t
+xlog_align(
+	xlog_t		*log,
+	xfs_daddr_t	blk_no,
+	int		nbblks,
+	xfs_buf_t	*bp)
+{
+	xfs_caddr_t	ptr;
+
+	if (!log->l_sectbb_log)
+		return XFS_BUF_PTR(bp);
+
+	ptr = XFS_BUF_PTR(bp) + BBTOB((int)blk_no & log->l_sectbb_mask);
+	ASSERT(XFS_BUF_SIZE(bp) >=
+		BBTOB(nbblks + (blk_no & log->l_sectbb_mask)));
+	return ptr;
+}
+
 
 /*
  * nbblks should be uint, but oh well.  Just want to catch that 32-bit length.
  */
-int
-xlog_bread(
+STATIC int
+_xlog_bread(
 	xlog_t		*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
@@ -137,6 +155,24 @@ xlog_bread(
 	return error;
 }
 
+STATIC int
+xlog_bread(
+	xlog_t		*log,
+	xfs_daddr_t	blk_no,
+	int		nbblks,
+	xfs_buf_t	*bp,
+	xfs_caddr_t	*offset)
+{
+	int		error;
+
+	error = _xlog_bread(log, blk_no, nbblks, bp);
+	if (error)
+		return error;
+
+	*offset = xlog_align(log, blk_no, nbblks, bp);
+	return 0;
+}
+
 /*
  * Write out the buffer at the given block for the given number of blocks.
  * The buffer is kept locked across the write and is returned locked.
@@ -180,24 +216,6 @@ xlog_bwrite(
 	return error;
 }
 
-STATIC xfs_caddr_t
-xlog_align(
-	xlog_t		*log,
-	xfs_daddr_t	blk_no,
-	int		nbblks,
-	xfs_buf_t	*bp)
-{
-	xfs_caddr_t	ptr;
-
-	if (!log->l_sectbb_log)
-		return XFS_BUF_PTR(bp);
-
-	ptr = XFS_BUF_PTR(bp) + BBTOB((int)blk_no & log->l_sectbb_mask);
-	ASSERT(XFS_BUF_SIZE(bp) >=
-		BBTOB(nbblks + (blk_no & log->l_sectbb_mask)));
-	return ptr;
-}
-
 #ifdef DEBUG
 /*
  * dump debug superblock and log record information
@@ -321,9 +339,9 @@ xlog_find_cycle_start(
 
 	mid_blk = BLK_AVG(first_blk, *last_blk);
 	while (mid_blk != first_blk && mid_blk != *last_blk) {
-		if ((error = xlog_bread(log, mid_blk, 1, bp)))
+		error = xlog_bread(log, mid_blk, 1, bp, &offset);
+		if (error)
 			return error;
-		offset = xlog_align(log, mid_blk, 1, bp);
 		mid_cycle = xlog_get_cycle(offset);
 		if (mid_cycle == cycle) {
 			*last_blk = mid_blk;
@@ -379,10 +397,10 @@ xlog_find_verify_cycle(
 
 		bcount = min(bufblks, (start_blk + nbblks - i));
 
-		if ((error = xlog_bread(log, i, bcount, bp)))
+		error = xlog_bread(log, i, bcount, bp, &buf);
+		if (error)
 			goto out;
 
-		buf = xlog_align(log, i, bcount, bp);
 		for (j = 0; j < bcount; j++) {
 			cycle = xlog_get_cycle(buf);
 			if (cycle == stop_on_cycle_no) {
@@ -436,9 +454,9 @@ xlog_find_verify_log_record(
 			return ENOMEM;
 		smallmem = 1;
 	} else {
-		if ((error = xlog_bread(log, start_blk, num_blks, bp)))
+		error = xlog_bread(log, start_blk, num_blks, bp, &offset);
+		if (error)
 			goto out;
-		offset = xlog_align(log, start_blk, num_blks, bp);
 		offset += ((num_blks - 1) << BBSHIFT);
 	}
 
@@ -453,9 +471,9 @@ xlog_find_verify_log_record(
 		}
 
 		if (smallmem) {
-			if ((error = xlog_bread(log, i, 1, bp)))
+			error = xlog_bread(log, i, 1, bp, &offset);
+			if (error)
 				goto out;
-			offset = xlog_align(log, i, 1, bp);
 		}
 
 		head = (xlog_rec_header_t *)offset;
@@ -559,15 +577,18 @@ xlog_find_head(
 	bp = xlog_get_bp(log, 1);
 	if (!bp)
 		return ENOMEM;
-	if ((error = xlog_bread(log, 0, 1, bp)))
+
+	error = xlog_bread(log, 0, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, 0, 1, bp);
+
 	first_half_cycle = xlog_get_cycle(offset);
 
 	last_blk = head_blk = log_bbnum - 1;	/* get cycle # of last block */
-	if ((error = xlog_bread(log, last_blk, 1, bp)))
+	error = xlog_bread(log, last_blk, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, last_blk, 1, bp);
+
 	last_half_cycle = xlog_get_cycle(offset);
 	ASSERT(last_half_cycle != 0);
 
@@ -817,9 +838,10 @@ xlog_find_tail(
 	if (!bp)
 		return ENOMEM;
 	if (*head_blk == 0) {				/* special case */
-		if ((error = xlog_bread(log, 0, 1, bp)))
+		error = xlog_bread(log, 0, 1, bp, &offset);
+		if (error)
 			goto bread_err;
-		offset = xlog_align(log, 0, 1, bp);
+
 		if (xlog_get_cycle(offset) == 0) {
 			*tail_blk = 0;
 			/* leave all other log inited values alone */
@@ -832,9 +854,10 @@ xlog_find_tail(
 	 */
 	ASSERT(*head_blk < INT_MAX);
 	for (i = (int)(*head_blk) - 1; i >= 0; i--) {
-		if ((error = xlog_bread(log, i, 1, bp)))
+		error = xlog_bread(log, i, 1, bp, &offset);
+		if (error)
 			goto bread_err;
-		offset = xlog_align(log, i, 1, bp);
+
 		if (XLOG_HEADER_MAGIC_NUM == be32_to_cpu(*(__be32 *)offset)) {
 			found = 1;
 			break;
@@ -848,9 +871,10 @@ xlog_find_tail(
 	 */
 	if (!found) {
 		for (i = log->l_logBBsize - 1; i >= (int)(*head_blk); i--) {
-			if ((error = xlog_bread(log, i, 1, bp)))
+			error = xlog_bread(log, i, 1, bp, &offset);
+			if (error)
 				goto bread_err;
-			offset = xlog_align(log, i, 1, bp);
+
 			if (XLOG_HEADER_MAGIC_NUM ==
 			    be32_to_cpu(*(__be32 *)offset)) {
 				found = 2;
@@ -922,10 +946,10 @@ xlog_find_tail(
 	if (*head_blk == after_umount_blk &&
 	    be32_to_cpu(rhead->h_num_logops) == 1) {
 		umount_data_blk = (i + hblks) % log->l_logBBsize;
-		if ((error = xlog_bread(log, umount_data_blk, 1, bp))) {
+		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
+		if (error)
 			goto bread_err;
-		}
-		offset = xlog_align(log, umount_data_blk, 1, bp);
+
 		op_head = (xlog_op_header_t *)offset;
 		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
 			/*
@@ -1017,9 +1041,10 @@ xlog_find_zeroed(
 	bp = xlog_get_bp(log, 1);
 	if (!bp)
 		return ENOMEM;
-	if ((error = xlog_bread(log, 0, 1, bp)))
+	error = xlog_bread(log, 0, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, 0, 1, bp);
+
 	first_cycle = xlog_get_cycle(offset);
 	if (first_cycle == 0) {		/* completely zeroed log */
 		*blk_no = 0;
@@ -1028,9 +1053,10 @@ xlog_find_zeroed(
 	}
 
 	/* check partially zeroed log */
-	if ((error = xlog_bread(log, log_bbnum-1, 1, bp)))
+	error = xlog_bread(log, log_bbnum-1, 1, bp, &offset);
+	if (error)
 		goto bp_err;
-	offset = xlog_align(log, log_bbnum-1, 1, bp);
+
 	last_cycle = xlog_get_cycle(offset);
 	if (last_cycle != 0) {		/* log completely written to */
 		xlog_put_bp(bp);
@@ -1152,10 +1178,10 @@ xlog_write_log_records(
 	 */
 	balign = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, start_block);
 	if (balign != start_block) {
-		if ((error = xlog_bread(log, start_block, 1, bp))) {
-			xlog_put_bp(bp);
-			return error;
-		}
+		error = _xlog_bread(log, start_block, 1, bp);
+		if (error)
+			goto out_put_bp;
+
 		j = start_block - balign;
 	}
 
@@ -1175,10 +1201,14 @@ xlog_write_log_records(
 			balign = BBTOB(ealign - start_block);
 			error = XFS_BUF_SET_PTR(bp, offset + balign,
 						BBTOB(sectbb));
-			if (!error)
-				error = xlog_bread(log, ealign, sectbb, bp);
-			if (!error)
-				error = XFS_BUF_SET_PTR(bp, offset, bufblks);
+			if (error)
+				break;
+
+			error = _xlog_bread(log, ealign, sectbb, bp);
+			if (error)
+				break;
+
+			error = XFS_BUF_SET_PTR(bp, offset, bufblks);
 			if (error)
 				break;
 		}
@@ -1195,6 +1225,8 @@ xlog_write_log_records(
 		start_block += endcount;
 		j = 0;
 	}
+
+ out_put_bp:
 	xlog_put_bp(bp);
 	return error;
 }
@@ -3481,9 +3513,11 @@ xlog_do_recovery_pass(
 		hbp = xlog_get_bp(log, 1);
 		if (!hbp)
 			return ENOMEM;
-		if ((error = xlog_bread(log, tail_blk, 1, hbp)))
+
+		error = xlog_bread(log, tail_blk, 1, hbp, &offset);
+		if (error)
 			goto bread_err1;
-		offset = xlog_align(log, tail_blk, 1, hbp);
+
 		rhead = (xlog_rec_header_t *)offset;
 		error = xlog_valid_rec_header(log, rhead, tail_blk);
 		if (error)
@@ -3517,9 +3551,10 @@ xlog_do_recovery_pass(
 	memset(rhash, 0, sizeof(rhash));
 	if (tail_blk <= head_blk) {
 		for (blk_no = tail_blk; blk_no < head_blk; ) {
-			if ((error = xlog_bread(log, blk_no, hblks, hbp)))
+			error = xlog_bread(log, blk_no, hblks, hbp, &offset);
+			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no, hblks, hbp);
+
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
@@ -3527,10 +3562,11 @@ xlog_do_recovery_pass(
 
 			/* blocks in data section */
 			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
-			error = xlog_bread(log, blk_no + hblks, bblks, dbp);
+			error = xlog_bread(log, blk_no + hblks, bblks, dbp,
+					   &offset);
 			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no + hblks, bblks, dbp);
+
 			xlog_unpack_data(rhead, offset, log);
 			if ((error = xlog_recover_process_data(log,
 						rhash, rhead, offset, pass)))
@@ -3553,10 +3589,10 @@ xlog_do_recovery_pass(
 			wrapped_hblks = 0;
 			if (blk_no + hblks <= log->l_logBBsize) {
 				/* Read header in one read */
-				error = xlog_bread(log, blk_no, hblks, hbp);
+				error = xlog_bread(log, blk_no, hblks, hbp,
+						   &offset);
 				if (error)
 					goto bread_err2;
-				offset = xlog_align(log, blk_no, hblks, hbp);
 			} else {
 				/* This LR is split across physical log end */
 				if (blk_no != log->l_logBBsize) {
@@ -3564,12 +3600,13 @@ xlog_do_recovery_pass(
 					ASSERT(blk_no <= INT_MAX);
 					split_hblks = log->l_logBBsize - (int)blk_no;
 					ASSERT(split_hblks > 0);
-					if ((error = xlog_bread(log, blk_no,
-							split_hblks, hbp)))
+					error = xlog_bread(log, blk_no,
+							   split_hblks, hbp,
+							   &offset);
+					if (error)
 						goto bread_err2;
-					offset = xlog_align(log, blk_no,
-							split_hblks, hbp);
 				}
+
 				/*
 				 * Note: this black magic still works with
 				 * large sector sizes (non-512) only because:
@@ -3587,14 +3624,18 @@ xlog_do_recovery_pass(
 				error = XFS_BUF_SET_PTR(hbp,
 						bufaddr + BBTOB(split_hblks),
 						BBTOB(hblks - split_hblks));
-				if (!error)
-					error = xlog_bread(log, 0,
-							wrapped_hblks, hbp);
-				if (!error)
-					error = XFS_BUF_SET_PTR(hbp, bufaddr,
+				if (error)
+					goto bread_err2;
+
+				error = _xlog_bread(log, 0, wrapped_hblks, hbp);
+				if (error)
+					goto bread_err2;
+
+				error = XFS_BUF_SET_PTR(hbp, bufaddr,
 							BBTOB(hblks));
 				if (error)
 					goto bread_err2;
+
 				if (!offset)
 					offset = xlog_align(log, 0,
 							wrapped_hblks, hbp);
@@ -3610,10 +3651,10 @@ xlog_do_recovery_pass(
 
 			/* Read in data for log record */
 			if (blk_no + bblks <= log->l_logBBsize) {
-				error = xlog_bread(log, blk_no, bblks, dbp);
+				error = xlog_bread(log, blk_no, bblks, dbp,
+						   &offset);
 				if (error)
 					goto bread_err2;
-				offset = xlog_align(log, blk_no, bblks, dbp);
 			} else {
 				/* This log record is split across the
 				 * physical end of log */
@@ -3627,12 +3668,13 @@ xlog_do_recovery_pass(
 					split_bblks =
 						log->l_logBBsize - (int)blk_no;
 					ASSERT(split_bblks > 0);
-					if ((error = xlog_bread(log, blk_no,
-							split_bblks, dbp)))
+					error = xlog_bread(log, blk_no,
+							split_bblks, dbp,
+							&offset);
+					if (error)
 						goto bread_err2;
-					offset = xlog_align(log, blk_no,
-							split_bblks, dbp);
 				}
+
 				/*
 				 * Note: this black magic still works with
 				 * large sector sizes (non-512) only because:
@@ -3649,15 +3691,19 @@ xlog_do_recovery_pass(
 				error = XFS_BUF_SET_PTR(dbp,
 						bufaddr + BBTOB(split_bblks),
 						BBTOB(bblks - split_bblks));
-				if (!error)
-					error = xlog_bread(log, wrapped_hblks,
-							bblks - split_bblks,
-							dbp);
-				if (!error)
-					error = XFS_BUF_SET_PTR(dbp, bufaddr,
-							h_size);
 				if (error)
 					goto bread_err2;
+
+				error = _xlog_bread(log, wrapped_hblks,
+						bblks - split_bblks,
+						dbp);
+				if (error)
+					goto bread_err2;
+
+				error = XFS_BUF_SET_PTR(dbp, bufaddr, h_size);
+				if (error)
+					goto bread_err2;
+
 				if (!offset)
 					offset = xlog_align(log, wrapped_hblks,
 						bblks - split_bblks, dbp);
@@ -3674,17 +3720,21 @@ xlog_do_recovery_pass(
 
 		/* read first part of physical log */
 		while (blk_no < head_blk) {
-			if ((error = xlog_bread(log, blk_no, hblks, hbp)))
+			error = xlog_bread(log, blk_no, hblks, hbp, &offset);
+			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no, hblks, hbp);
+
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
 				goto bread_err2;
+
 			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
-			if ((error = xlog_bread(log, blk_no+hblks, bblks, dbp)))
+			error = xlog_bread(log, blk_no+hblks, bblks, dbp,
+					   &offset);
+			if (error)
 				goto bread_err2;
-			offset = xlog_align(log, blk_no+hblks, bblks, dbp);
+
 			xlog_unpack_data(rhead, offset, log);
 			if ((error = xlog_recover_process_data(log, rhash,
 							rhead, offset, pass)))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
