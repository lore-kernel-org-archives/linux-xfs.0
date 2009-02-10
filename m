Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AKUHuX073492 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:30:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF18E191171D
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jqMKWBInfpyjkJM1 for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:29:41 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWzEj-0005os-Cl
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 20:29:41 +0000
Message-Id: <20090210202941.304328000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 15:22:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/13] xfs: add CRC checks to the log
References: <20090210202241.546501000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-log-crc
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

Implement CRCs for the log buffers.  We re-use a field in
struct xlog_rec_header that was used for a weak checksum of the
log buffer payload in debug builds before.

The new checksumming uses the same crc32c checksum we use elsewhere
in XFS, and also protects the record header and addition cycle data.

Due to this there are some interesting changes in xlog_sync, as we
need to do the cycle wrapping for the split buffer case much earlier,
as we would touch the buffer after generating the checksum otherwise.

Based on a patch from Dave Chinner with lots of changes.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2009-02-10 19:22:43.915068626 +0100
+++ xfs/fs/xfs/xfs_log_priv.h	2009-02-10 19:45:54.102069909 +0100
@@ -142,7 +142,7 @@ static inline uint xlog_get_client_id(__
 /*
  * Flags for log structure
  */
-#define XLOG_CHKSUM_MISMATCH	0x1	/* used only during recovery */
+#define XLOG_CRC_MISMATCH	0x1	/* used only during recovery */
 #define XLOG_ACTIVE_RECOVERY	0x2	/* in the middle of recovery */
 #define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
 #define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
@@ -294,7 +294,7 @@ typedef struct xlog_rec_header {
 	__be32	  h_len;	/* len in bytes; should be 64-bit aligned: 4 */
 	__be64	  h_lsn;	/* lsn of this LR			:  8 */
 	__be64	  h_tail_lsn;	/* lsn of 1st LR w/ buffers not committed: 8 */
-	__be32	  h_chksum;	/* may not be used; non-zero if used	:  4 */
+	__be32	  h_crc;	/* crc of log record			:  4 */
 	__be32	  h_prev_block; /* block number to previous LR		:  4 */
 	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
 	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
@@ -450,9 +450,11 @@ extern int	 xlog_find_tail(xlog_t	*log,
 				xfs_daddr_t *tail_blk);
 extern int	 xlog_recover(xlog_t *log);
 extern int	 xlog_recover_finish(xlog_t *log);
-extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
 extern void	 xlog_recover_process_iunlinks(xlog_t *log);
 
+extern __be32	 xlog_cksum(struct log *log, struct xlog_rec_header *rhead,
+			    char *dp, int size);
+
 extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
 extern void	 xlog_put_bp(struct xfs_buf *);
 
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-10 19:45:53.757070823 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-10 19:45:54.105069313 +0100
@@ -47,6 +47,7 @@
 #include "xfs_quota.h"
 #include "xfs_rw.h"
 #include "xfs_utils.h"
+#include "xfs_cksum.h"
 
 STATIC int	xlog_find_zeroed(xlog_t *, xfs_daddr_t *);
 STATIC int	xlog_clear_stale_blocks(xlog_t *, xfs_lsn_t);
@@ -3334,116 +3335,48 @@ xlog_recover_process_iunlinks(
 	mp->m_dmevmask = mp_dmevmask;
 }
 
-
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
-/*
- * Stamp cycle number in every block
- */
-void
-xlog_pack_data(
-	xlog_t			*log,
-	xlog_in_core_t		*iclog,
-	int			roundoff)
-{
-	int			i, j, k;
-	int			size = iclog->ic_offset + roundoff;
-	__be32			cycle_lsn;
-	xfs_caddr_t		dp;
-
-	xlog_pack_data_checksum(log, iclog, size);
-
-	cycle_lsn = CYCLE_LSN_DISK(iclog->ic_header.h_lsn);
-
-	dp = iclog->ic_datap;
-	for (i = 0; i < BTOBB(size) &&
-		i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
-		iclog->ic_header.h_cycle_data[i] = *(__be32 *)dp;
-		*(__be32 *)dp = cycle_lsn;
-		dp += BBSIZE;
-	}
-
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-		xlog_in_core_2_t *xhdr = iclog->ic_data;
-
-		for ( ; i < BTOBB(size); i++) {
-			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
-			*(__be32 *)dp = cycle_lsn;
-			dp += BBSIZE;
-		}
-
-		for (i = 1; i < log->l_iclog_heads; i++) {
-			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
-		}
-	}
-}
-
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
+	__be32			crc;
 
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
+	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
+	if (crc != rhead->h_crc) {
+		cmn_err(CE_ALERT, "XFS recovery: log record CRC error: "
+				"found 0x%x, expected 0x%x.\n",
+				be32_to_cpu(rhead->h_crc),
+				be32_to_cpu(crc));
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
@@ -3461,7 +3394,7 @@ xlog_unpack_data(
 		}
 	}
 
-	xlog_unpack_data_checksum(rhead, dp, log);
+	return 0;
 }
 
 STATIC int
@@ -3593,9 +3526,13 @@ xlog_do_recovery_pass(
 			if (error)
 				goto bread_err2;
 
-			xlog_unpack_data(rhead, offset, log);
-			if ((error = xlog_recover_process_data(log,
-						rhash, rhead, offset, pass)))
+			error = xlog_unpack_data(rhead, offset, log);
+			if (error)
+				goto bread_err2;
+
+			error = xlog_recover_process_data(log,
+						rhash, rhead, offset, pass);
+			if (error)
 				goto bread_err2;
 			blk_no += bblks + hblks;
 		}
@@ -3734,9 +3671,14 @@ xlog_do_recovery_pass(
 					offset = xlog_align(log, wrapped_hblks,
 						bblks - split_bblks, dbp);
 			}
-			xlog_unpack_data(rhead, offset, log);
-			if ((error = xlog_recover_process_data(log, rhash,
-							rhead, offset, pass)))
+
+			error = xlog_unpack_data(rhead, offset, log);
+			if (error)
+				goto bread_err2;
+
+			error = xlog_recover_process_data(log, rhash,
+							rhead, offset, pass);
+			if (error)
 				goto bread_err2;
 			blk_no += bblks;
 		}
@@ -3761,9 +3703,13 @@ xlog_do_recovery_pass(
 			if (error)
 				goto bread_err2;
 
-			xlog_unpack_data(rhead, offset, log);
-			if ((error = xlog_recover_process_data(log, rhash,
-							rhead, offset, pass)))
+			error = xlog_unpack_data(rhead, offset, log);
+			if (error)
+				goto bread_err2;
+
+			error = xlog_recover_process_data(log, rhash,
+							rhead, offset, pass);
+			if (error)
 				goto bread_err2;
 			blk_no += bblks + hblks;
 		}
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2009-02-10 19:21:28.338068613 +0100
+++ xfs/fs/xfs/xfs_log.c	2009-02-10 19:45:54.108070252 +0100
@@ -40,6 +40,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_rw.h"
+#include "xfs_cksum.h"
 
 kmem_zone_t	*xfs_log_ticket_zone;
 
@@ -1407,6 +1408,83 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
 	    xfs_trans_ail_push(log->l_ailp, threshold_lsn);
 }	/* xlog_grant_push_ail */
 
+/*
+ * Stamp cycle number in every block
+ */
+STATIC void
+xlog_pack_data(
+	xlog_t			*log,
+	xlog_in_core_t		*iclog,
+	int			roundoff)
+{
+	int			i, j, k;
+	int			size = iclog->ic_offset + roundoff;
+	__be32			cycle_lsn;
+	xfs_caddr_t		dp;
+
+	cycle_lsn = CYCLE_LSN_DISK(iclog->ic_header.h_lsn);
+
+	dp = iclog->ic_datap;
+	for (i = 0; i < BTOBB(size); i++) {
+		if (i >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE))
+			break;
+		iclog->ic_header.h_cycle_data[i] = *(__be32 *)dp;
+		*(__be32 *)dp = cycle_lsn;
+		dp += BBSIZE;
+	}
+
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+		xlog_in_core_2_t *xhdr = iclog->ic_data;
+
+		for ( ; i < BTOBB(size); i++) {
+			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
+			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
+			*(__be32 *)dp = cycle_lsn;
+			dp += BBSIZE;
+		}
+
+		for (i = 1; i < log->l_iclog_heads; i++)
+			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
+	}
+}
+
+/*
+ * Calculate the checksum for a log buffer.
+ *
+ * This is a little more complicated than it should be because the various
+ * headers and the actual data are non-contiguous.
+ */
+__be32
+xlog_cksum(
+	struct log		*log,
+	struct xlog_rec_header	*rhead,
+	char			*dp,
+	int			size)
+{
+	__uint32_t		crc;
+
+	/* first generate the crc for the record header ... */
+	crc = xfs_start_cksum((char *)rhead,
+			      sizeof(struct xlog_rec_header),
+			      offsetof(struct xlog_rec_header, h_crc));
+
+	/* ... then for additional cycle data for v2 logs ... */
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+		union xlog_in_core2 *xhdr = (union xlog_in_core2 *)rhead;
+		int		i;
+
+		for (i = 1; i < log->l_iclog_heads; i++) {
+			crc = crc32c(crc, &xhdr[i].hic_xheader,
+				     sizeof(struct xlog_rec_ext_header));
+		}
+	}
+
+	/* ... and finally for the payload */
+	crc = crc32c(crc, dp, size);
+
+	return xfs_end_cksum(crc);
+}
 
 /*
  * Flush out the in-core log (iclog) to the on-disk log in an asynchronous 
@@ -1437,7 +1515,6 @@ STATIC int
 xlog_sync(xlog_t		*log,
 	  xlog_in_core_t	*iclog)
 {
-	xfs_caddr_t	dptr;		/* pointer to byte sized element */
 	xfs_buf_t	*bp;
 	int		i;
 	uint		count;		/* byte count of bwrite */
@@ -1446,6 +1523,7 @@ xlog_sync(xlog_t		*log,
 	int		split = 0;	/* split write into two regions */
 	int		error;
 	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
+	int		size;
 
 	XFS_STATS_INC(xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
@@ -1477,13 +1555,10 @@ xlog_sync(xlog_t		*log,
 	xlog_pack_data(log, iclog, roundoff); 
 
 	/* real byte length */
-	if (v2) {
-		iclog->ic_header.h_len =
-			cpu_to_be32(iclog->ic_offset + roundoff);
-	} else {
-		iclog->ic_header.h_len =
-			cpu_to_be32(iclog->ic_offset);
-	}
+	size = iclog->ic_offset;
+	if (v2)
+		size += roundoff;
+	iclog->ic_header.h_len = cpu_to_be32(size);
 
 	bp = iclog->ic_bp;
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, unsigned long) == (unsigned long)1);
@@ -1494,12 +1569,39 @@ xlog_sync(xlog_t		*log,
 
 	/* Do we need to split this write into 2 parts? */
 	if (XFS_BUF_ADDR(bp) + BTOBB(count) > log->l_logBBsize) {
+		char		*dptr;
+
 		split = count - (BBTOB(log->l_logBBsize - XFS_BUF_ADDR(bp)));
 		count = BBTOB(log->l_logBBsize - XFS_BUF_ADDR(bp));
-		iclog->ic_bwritecnt = 2;	/* split into 2 writes */
+		iclog->ic_bwritecnt = 2;
+
+		/*
+		 * Bump the cycle numbers at the start of each block in the
+		 * part of the iclog that ends up in the buffer that gets
+		 * written to the start of the log.
+		 *
+		 * Watch out for the header magic number case, though.
+		 */
+		dptr = (char *)&iclog->ic_header + count;
+		for (i = 0; i < split; i += BBSIZE) {
+			__uint32_t cycle = be32_to_cpu(*(__be32 *)dptr);
+			if (++cycle == XLOG_HEADER_MAGIC_NUM)
+				cycle++;
+			*(__be32 *)dptr = cpu_to_be32(cycle);
+
+			dptr += BBSIZE;
+		}
 	} else {
 		iclog->ic_bwritecnt = 1;
 	}
+
+	/* calculcate the checksum */
+	if (xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+		iclog->ic_header.h_crc =
+			xlog_cksum(log, &iclog->ic_header,
+				   iclog->ic_datap, size);
+	}
+
 	XFS_BUF_SET_COUNT(bp, count);
 	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
 	XFS_BUF_ZEROFLAGS(bp);
@@ -1536,27 +1638,13 @@ xlog_sync(xlog_t		*log,
 							(unsigned long)1);
 		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)2);
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
-		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
-					    (__psint_t)count), split);
+		XFS_BUF_SET_PTR(bp, (char *)&iclog->ic_header + count, split);
 		XFS_BUF_SET_FSPRIVATE(bp, iclog);
 		XFS_BUF_ZEROFLAGS(bp);
 		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			XFS_BUF_ORDERED(bp);
-		dptr = XFS_BUF_PTR(bp);
-		/*
-		 * Bump the cycle numbers at the start of each block
-		 * since this part of the buffer is at the start of
-		 * a new cycle.  Watch out for the header magic number
-		 * case, though.
-		 */
-		for (i = 0; i < split; i += BBSIZE) {
-			be32_add_cpu((__be32 *)dptr, 1);
-			if (be32_to_cpu(*(__be32 *)dptr) == XLOG_HEADER_MAGIC_NUM)
-				be32_add_cpu((__be32 *)dptr, 1);
-			dptr += BBSIZE;
-		}
 
 		ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
 		ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
