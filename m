Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7DaxL3153919 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 07:36:59 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HlSPenEueymmmEDi for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 05:38:54 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TW5p1-0001dY-Am
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 00:37:35 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TW5p1-0001GZ-7Y
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 00:37:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: add CRC checks to the log
Date: Thu,  8 Nov 2012 00:37:32 +1100
Message-Id: <1352295452-4726-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1352295452-4726-1-git-send-email-david@fromorbit.com>
References: <1352295452-4726-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@lst.de>

Implement CRCs for the log buffers.  We re-use a field in
struct xlog_rec_header that was used for a weak checksum of the
log buffer payload in debug builds before.

The new checksumming uses the crc32c checksum we will use elsewhere
in XFS, and also protects the record header and addition cycle data.

Due to this there are some interesting changes in xlog_sync, as we
need to do the cycle wrapping for the split buffer case much earlier,
as we would touch the buffer after generating the checksum otherwise.

The CRC calculation is always enabled, even for non-CRC filesystems,
as adding this CRC does not change the log format. On non-CRC
filesystems, only issue an alert if a CRC mismatch is found and
allow recovery to continue - this will act as an indicator that
log recovery problems are a result of log corruption. On CRC enabled
filesystems, however, log recovery will fail.

Note that existing debug kernels will write a simple checksum value
to the log, so the first time this is run on a filesystem taht was
last used on a debug kernel it will through CRC mismatch warning
errors. These can be ignored.

Initially based on a patch from Dave Chinner, then modified
significantly by Christoph Hellwig.  Modified again by Dave Chinner
to get to this version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c         |  132 ++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_log_priv.h    |   11 ++--
 fs/xfs/xfs_log_recover.c |  132 ++++++++++++++++++++++------------------------
 3 files changed, 176 insertions(+), 99 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1d6d2ee..c6d6e13 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -35,6 +35,7 @@
 #include "xfs_inode.h"
 #include "xfs_trace.h"
 #include "xfs_fsops.h"
+#include "xfs_cksum.h"
 
 kmem_zone_t	*xfs_log_ticket_zone;
 
@@ -1490,6 +1491,84 @@ xlog_grant_push_ail(
 }
 
 /*
+ * Stamp cycle number in every block
+ */
+STATIC void
+xlog_pack_data(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
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
+	struct xlog		*log,
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
+
+/*
  * The bdstrat callback function for log bufs. This gives us a central
  * place to trap bufs in case we get hit by a log I/O error and need to
  * shutdown. Actually, in practice, even when we didn't get a log error,
@@ -1549,7 +1628,6 @@ xlog_sync(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
-	xfs_caddr_t	dptr;		/* pointer to byte sized element */
 	xfs_buf_t	*bp;
 	int		i;
 	uint		count;		/* byte count of bwrite */
@@ -1558,6 +1636,7 @@ xlog_sync(
 	int		split = 0;	/* split write into two regions */
 	int		error;
 	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
+	int		size;
 
 	XFS_STATS_INC(xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
@@ -1588,13 +1667,10 @@ xlog_sync(
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
 	XFS_BUF_SET_ADDR(bp, BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn)));
@@ -1603,12 +1679,36 @@ xlog_sync(
 
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
+	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
+					    iclog->ic_datap, size);
+
 	bp->b_io_length = BTOBB(count);
 	bp->b_fspriv = iclog;
 	XFS_BUF_ZEROFLAGS(bp);
@@ -1662,19 +1762,6 @@ xlog_sync(
 		bp->b_flags |= XBF_SYNCIO;
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			bp->b_flags |= XBF_FUA;
-		dptr = bp->b_addr;
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
@@ -1691,7 +1778,6 @@ xlog_sync(
 	return 0;
 }	/* xlog_sync */
 
-
 /*
  * Deallocate a log structure
  */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 9a4e0e5..0c74e3f 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -139,7 +139,6 @@ static inline uint xlog_get_client_id(__be32 i)
 /*
  * Flags for log structure
  */
-#define XLOG_CHKSUM_MISMATCH	0x1	/* used only during recovery */
 #define XLOG_ACTIVE_RECOVERY	0x2	/* in the middle of recovery */
 #define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
 #define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
@@ -291,7 +290,7 @@ typedef struct xlog_rec_header {
 	__be32	  h_len;	/* len in bytes; should be 64-bit aligned: 4 */
 	__be64	  h_lsn;	/* lsn of this LR			:  8 */
 	__be64	  h_tail_lsn;	/* lsn of 1st LR w/ buffers not committed: 8 */
-	__be32	  h_chksum;	/* may not be used; non-zero if used	:  4 */
+	__be32	  h_crc;	/* crc of log record                    :  4 */
 	__be32	  h_prev_block; /* block number to previous LR		:  4 */
 	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
 	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
@@ -555,11 +554,9 @@ xlog_recover(
 extern int
 xlog_recover_finish(
 	struct xlog		*log);
-extern void
-xlog_pack_data(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	int);
+
+extern __be32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
+			    char *dp, int size);
 
 extern kmem_zone_t *xfs_log_ticket_zone;
 struct xlog_ticket *
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 931e8e2..9c3651c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -41,6 +41,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
 #include "xfs_utils.h"
+#include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 
@@ -3216,80 +3217,58 @@ xlog_recover_process_iunlinks(
 	mp->m_dmevmask = mp_dmevmask;
 }
 
-
-#ifdef DEBUG
-STATIC void
-xlog_pack_data_checksum(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	int			size)
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
- * Stamp cycle number in every block
+ * Upack the log buffer data and crc check it. If the check fails, issue a
+ * warning if and only if the CRC in the header is non-zero. This makes the
+ * check an advisory warning, and the zero CRC check will prevent failure
+ * warnings from being emitted when upgrading the kernel from one that does not
+ * add CRCs by default.
+ *
+ * When filesystems are CRC enabled, this CRC mismatch becomes a fatal log
+ * corruption failure
  */
-void
-xlog_pack_data(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	int			roundoff)
+STATIC int
+xlog_unpack_data_crc(
+	struct xlog_rec_header	*rhead,
+	xfs_caddr_t		dp,
+	struct xlog		*log)
 {
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
+	__be32			crc;
+
+	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
+	if (crc != rhead->h_crc) {
+		if (rhead->h_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+			xfs_alert(log->l_mp,
+		"log record CRC mismatch: found 0x%x, expected 0x%x.\n",
+					be32_to_cpu(rhead->h_crc),
+					be32_to_cpu(crc));
+			xfs_hex_dump(dp, 32);
 		}
 
-		for (i = 1; i < log->l_iclog_heads; i++) {
-			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
-		}
+		/*
+		 * If we've detected a log record corruption, then we can't
+		 * recover past this point. Abort recovery if we are enforcing
+		 * CRC protection by punting an error back up the stack.
+		 */
+		if (xfs_sb_version_hascrc(&log->l_mp->m_sb))
+			return EFSCORRUPTED;
 	}
+
+	return 0;
 }
 
-STATIC void
+STATIC int
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
 	xfs_caddr_t		dp,
 	struct xlog		*log)
 {
 	int			i, j, k;
+	int			error;
+
+	error = xlog_unpack_data_crc(rhead, dp, log);
+	if (error)
+		return error;
 
 	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
 		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
@@ -3306,6 +3285,8 @@ xlog_unpack_data(
 			dp += BBSIZE;
 		}
 	}
+
+	return 0;
 }
 
 STATIC int
@@ -3437,9 +3418,13 @@ xlog_do_recovery_pass(
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
@@ -3549,9 +3534,14 @@ xlog_do_recovery_pass(
 				if (error)
 					goto bread_err2;
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
@@ -3576,9 +3566,13 @@ xlog_do_recovery_pass(
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
