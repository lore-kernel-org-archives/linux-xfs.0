Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 15:55:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PMtH8x024396
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:55:17 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EF7A107B3CF
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:51 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id PoQmPE3VTw7DS26m for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 15:56:51 -0700 (PDT)
Date: Fri, 26 Sep 2008 00:56:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/9] Replace log checksumming code with CRCs.
Message-ID: <20080925225650.GJ9822@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-log-crc
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <dgc@sgi.com>

From: Dave Chinner <dgc@sgi.com>

The log has debug only checksum validation; replace this with
stronger CRCs and always use it.

So far we only checksum the payload in every log buffer.  For the final
version this needs to be extended to include the headers, too.


[hch: minor adaptions]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dgc@sgi.com>

Index: linux-2.6-xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_priv.h	2008-09-25 14:50:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_priv.h	2008-09-25 14:50:55.000000000 +0200
@@ -142,7 +142,7 @@ static inline uint xlog_get_client_id(__
 /*
  * Flags for log structure
  */
-#define XLOG_CHKSUM_MISMATCH	0x1	/* used only during recovery */
+#define XLOG_CRC_MISMATCH	0x1	/* used only during recovery */
 #define XLOG_ACTIVE_RECOVERY	0x2	/* in the middle of recovery */
 #define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
 #define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
@@ -293,7 +293,7 @@ typedef struct xlog_rec_header {
 	__be32	  h_len;	/* len in bytes; should be 64-bit aligned: 4 */
 	__be64	  h_lsn;	/* lsn of this LR			:  8 */
 	__be64	  h_tail_lsn;	/* lsn of 1st LR w/ buffers not committed: 8 */
-	__be32	  h_chksum;	/* may not be used; non-zero if used	:  4 */
+	__be32	  h_crc;	/* crc of log record			:  4 */
 	__be32	  h_prev_block; /* block number to previous LR		:  4 */
 	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
 	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-09-25 14:50:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-09-25 15:15:39.000000000 +0200
@@ -48,6 +48,7 @@
 #include "xfs_quota.h"
 #include "xfs_rw.h"
 #include "xfs_utils.h"
+#include "xfs_cksum.h"
 
 STATIC int	xlog_find_zeroed(xlog_t *, xfs_daddr_t *);
 STATIC int	xlog_clear_stale_blocks(xlog_t *, xfs_lsn_t);
@@ -3346,29 +3347,6 @@ xlog_recover_process_iunlinks(
 }
 
 
-#ifdef DEBUG
-STATIC void
-xlog_pack_data_checksum(
-	xlog_t		*log,
-	xlog_in_core_t	*iclog,
-	int		size)
-{
-	int		i;
-	__be32		*up;
-	uint		chksum = 0;
-
-	up = (__be32 *)iclog->ic_datap;
-	/* divide length by 4 to get # words */
-	for (i = 0; i < (size >> 2); i++) {
-		chksum ^= be32_to_cpu(*up);
-		up++;
-	}
-	iclog->ic_header.h_chksum = cpu_to_be32(chksum);
-}
-#else
-#define xlog_pack_data_checksum(log, iclog, size)
-#endif
-
 /*
  * Stamp cycle number in every block
  */
@@ -3383,8 +3361,6 @@ xlog_pack_data(
 	__be32			cycle_lsn;
 	xfs_caddr_t		dp;
 
-	xlog_pack_data_checksum(log, iclog, size);
-
 	cycle_lsn = CYCLE_LSN_DISK(iclog->ic_header.h_lsn);
 
 	dp = iclog->ic_datap;
@@ -3410,51 +3386,57 @@ xlog_pack_data(
 			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
 		}
 	}
+
+	if (xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+		__uint32_t	crc;
+
+		crc = crc32c(XFS_CRC_SEED, iclog->ic_datap, size);
+		iclog->ic_header.h_crc = xfs_end_cksum(crc);
+	}
 }
 
-#if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
-STATIC void
-xlog_unpack_data_checksum(
+STATIC int
+xlog_unpack_data_crc(
 	xlog_rec_header_t	*rhead,
 	xfs_caddr_t		dp,
 	xlog_t			*log)
 {
-	__be32			*up = (__be32 *)dp;
-	uint			chksum = 0;
-	int			i;
+	__uint32_t		crc;
 
-	/* divide length by 4 to get # words */
-	for (i=0; i < be32_to_cpu(rhead->h_len) >> 2; i++) {
-		chksum ^= be32_to_cpu(*up);
-		up++;
-	}
-	if (chksum != be32_to_cpu(rhead->h_chksum)) {
-	    if (rhead->h_chksum ||
-		((log->l_flags & XLOG_CHKSUM_MISMATCH) == 0)) {
-		    cmn_err(CE_DEBUG,
-			"XFS: LogR chksum mismatch: was (0x%x) is (0x%x)\n",
-			    be32_to_cpu(rhead->h_chksum), chksum);
-		    cmn_err(CE_DEBUG,
-"XFS: Disregard message if filesystem was created with non-DEBUG kernel");
-		    if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-			    cmn_err(CE_DEBUG,
-				"XFS: LogR this is a LogV2 filesystem\n");
-		    }
-		    log->l_flags |= XLOG_CHKSUM_MISMATCH;
-	    }
+	crc = crc32c(XFS_CRC_SEED, dp, be32_to_cpu(rhead->h_len));
+	if (xfs_end_cksum(crc) != rhead->h_crc) {
+		cmn_err(CE_ALERT, "XFS Recovery: Log Record CRC error: "
+				"was (0x%x), computed (0x%x), size 0x%x.\n",
+				be32_to_cpu(rhead->h_crc), crc,
+				be32_to_cpu(rhead->h_len));
+		print_hex_dump(KERN_ALERT, "record: ", 0, 32, 1, dp, 32, 0);
+
+		/*
+		 * If we've detected a log record corruption, then we
+		 * can't recover past this point. Abort recovery and
+		 * punt an error back up the stack.
+		 */
+		log->l_flags |= XLOG_CRC_MISMATCH;
+		return EUCLEAN;
 	}
+
+	return 0;
 }
-#else
-#define xlog_unpack_data_checksum(rhead, dp, log)
-#endif
 
-STATIC void
+STATIC int
 xlog_unpack_data(
 	xlog_rec_header_t	*rhead,
 	xfs_caddr_t		dp,
 	xlog_t			*log)
 {
 	int			i, j, k;
+	int			error;
+
+	if (xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+		error = xlog_unpack_data_crc(rhead, dp, log);
+		if (error)
+			return error;
+	}
 
 	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
 		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
@@ -3472,7 +3454,7 @@ xlog_unpack_data(
 		}
 	}
 
-	xlog_unpack_data_checksum(rhead, dp, log);
+	return 0;
 }
 
 STATIC int
@@ -3586,8 +3568,10 @@ xlog_do_recovery_pass(
 	memset(rhash, 0, sizeof(rhash));
 	if (tail_blk <= head_blk) {
 		for (blk_no = tail_blk; blk_no < head_blk; ) {
-			if ((error = xlog_bread(log, blk_no, hblks, hbp)))
+			error = xlog_bread(log, blk_no, hblks, hbp);
+			if (error)
 				goto bread_err2;
+
 			offset = xlog_align(log, blk_no, hblks, hbp);
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
@@ -3599,11 +3583,17 @@ xlog_do_recovery_pass(
 			error = xlog_bread(log, blk_no + hblks, bblks, dbp);
 			if (error)
 				goto bread_err2;
+
 			offset = xlog_align(log, blk_no + hblks, bblks, dbp);
-			xlog_unpack_data(rhead, offset, log);
-			if ((error = xlog_recover_process_data(log,
-						rhash, rhead, offset, pass)))
+			error = xlog_unpack_data(rhead, offset, log);
+			if (error)
+				goto bread_err2;
+
+			error = xlog_recover_process_data(log, rhash, rhead,
+							  offset, pass);
+			if (error)
 				goto bread_err2;
+
 			blk_no += bblks + hblks;
 		}
 	} else {
@@ -3656,14 +3646,18 @@ xlog_do_recovery_pass(
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
+				error = xlog_bread(log, 0, wrapped_hblks, hbp);
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
@@ -3696,8 +3690,9 @@ xlog_do_recovery_pass(
 					split_bblks =
 						log->l_logBBsize - (int)blk_no;
 					ASSERT(split_bblks > 0);
-					if ((error = xlog_bread(log, blk_no,
-							split_bblks, dbp)))
+					error = xlog_bread(log, blk_no,
+							split_bblks, dbp);
+					if (error)
 						goto bread_err2;
 					offset = xlog_align(log, blk_no,
 							split_bblks, dbp);
@@ -3718,23 +3713,32 @@ xlog_do_recovery_pass(
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
+				error = xlog_bread(log, wrapped_hblks,
+						   bblks - split_bblks, dbp);
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
 			}
-			xlog_unpack_data(rhead, offset, log);
-			if ((error = xlog_recover_process_data(log, rhash,
-							rhead, offset, pass)))
+
+			error = xlog_unpack_data(rhead, offset, log);
+			if (error)
 				goto bread_err2;
+
+			error = xlog_recover_process_data(log, rhash, rhead,
+							  offset, pass);
+			if (error)
+				goto bread_err2;
+
 			blk_no += bblks;
 		}
 
@@ -3743,21 +3747,31 @@ xlog_do_recovery_pass(
 
 		/* read first part of physical log */
 		while (blk_no < head_blk) {
-			if ((error = xlog_bread(log, blk_no, hblks, hbp)))
+			error = xlog_bread(log, blk_no, hblks, hbp);
+			if (error)
 				goto bread_err2;
+
 			offset = xlog_align(log, blk_no, hblks, hbp);
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead, blk_no);
 			if (error)
 				goto bread_err2;
+
 			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
-			if ((error = xlog_bread(log, blk_no+hblks, bblks, dbp)))
+			error = xlog_bread(log, blk_no+hblks, bblks, dbp);
+			if (error)
 				goto bread_err2;
+
 			offset = xlog_align(log, blk_no+hblks, bblks, dbp);
-			xlog_unpack_data(rhead, offset, log);
-			if ((error = xlog_recover_process_data(log, rhash,
-							rhead, offset, pass)))
+			error = xlog_unpack_data(rhead, offset, log);
+			if (error)
 				goto bread_err2;
+
+			error = xlog_recover_process_data(log, rhash, rhead,
+							  offset, pass);
+			if (error)
+				goto bread_err2;
+
 			blk_no += bblks + hblks;
 		}
 	}

-- 
