Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3FIFfDZ183252 for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 13:15:41 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0ECC3040DA
	for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 11:17:37 -0700 (PDT)
Subject: [PATCH 4/5] xfs: record log sector size rather than log2(that)
From: Alex Elder <aelder@sgi.com>
Date: Thu, 15 Apr 2010 13:17:37 -0500
Message-ID: <1271355457.2680.93.camel@doink>
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
To: XFS Mailing List <xfs@oss.sgi.com>

Change struct log so it keeps track of the size (in basic blocks)
of a log sector in l_sectsize rather than the log-base-2 of that
value (previously, l_sectbb_log).  Rename a variable holding the
sector size to more closely match the field it comes from.

(Updated so that a variable used in computing and verifying a log's
sector size is named simply "size".  Also dropped some superfluous
parentheses and renamed another local variable.)

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_log.c         |   33 ++++++++++++++++++---------------
 fs/xfs/xfs_log_priv.h    |    2 +-
 fs/xfs/xfs_log_recover.c |   35 ++++++++++++++++-------------------
 3 files changed, 35 insertions(+), 35 deletions(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1039,6 +1039,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	int			i;
 	int			iclogsize;
 	int			error = ENOMEM;
+	uint			size = 0;
 
 	log = kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
 	if (!log) {
@@ -1064,29 +1065,31 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
-		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
-		if (log->l_sectbb_log < 0 ||
-		    log->l_sectbb_log > mp->m_sectbb_log) {
-			xlog_warn("XFS: Log sector size (0x%x) out of range.",
-						log->l_sectbb_log);
+	        size = mp->m_sb.sb_logsectlog;
+		if (size < BBSHIFT) {
+			xlog_warn("XFS: Log sector size too small "
+				"(0x%x < 0x%x)", size, BBSHIFT);
 			goto out_free_log;
 		}
 
-		/* for larger sector sizes, must have v2 or external log */
-		if (log->l_sectbb_log != 0 &&
-		    (log->l_logBBstart != 0 &&
-		     !xfs_sb_version_haslogv2(&mp->m_sb))) {
-			xlog_warn("XFS: log sector size (0x%x) invalid "
-				  "for configuration.", log->l_sectbb_log);
+	        size -= BBSHIFT;
+		if (size > mp->m_sectbb_log) {
+			xlog_warn("XFS: Log sector size too large "
+				"(0x%x > 0x%x)", size, mp->m_sectbb_log);
 			goto out_free_log;
 		}
-		if (mp->m_sb.sb_logsectlog < BBSHIFT) {
-			xlog_warn("XFS: Log sector log (0x%x) too small.",
-						mp->m_sb.sb_logsectlog);
+
+		/* for larger sector sizes, must have v2 or external log */
+		if (size && log->l_logBBstart > 0 &&
+			    !xfs_sb_version_haslogv2(&mp->m_sb)) {
+
+			xlog_warn("XFS: log sector size (0x%x) invalid "
+				  "for configuration.", size);
 			goto out_free_log;
 		}
 	}
-	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
+	log->l_sectsize = 1 << size;
+	log->l_sectbb_mask = log->l_sectsize - 1;
 
 	xlog_get_iclog_buffer_size(mp, log);
 
Index: b/fs/xfs/xfs_log_priv.h
===================================================================
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -396,7 +396,7 @@ typedef struct log {
 	struct xfs_buf_cancel	**l_buf_cancel_table;
 	int			l_iclog_hsize;  /* size of iclog header */
 	int			l_iclog_heads;  /* # of iclog header sectors */
-	uint			l_sectbb_log;   /* log2 of sector size in BBs */
+	uint			l_sectsize;     /* sector size in BBs */
 	uint			l_sectbb_mask;  /* sector size (in BBs)
 						 * alignment mask */
 	int			l_iclog_size;	/* size of log in bytes */
Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -60,9 +60,6 @@ STATIC void	xlog_recover_check_summary(x
  * Sector aligned buffer routines for buffer create/read/write/access
  */
 
-/* Number of basic blocks in a log sector */
-#define xlog_sectbb(log) (1 << (log)->l_sectbb_log)
-
 /*
  * Verify the given count of basic blocks is valid number of blocks
  * to specify for an operation involving the given XFS log buffer.
@@ -110,9 +107,9 @@ xlog_get_bp(
 	 * extend the buffer by one extra log sector to ensure
 	 * there's space to accomodate this possiblility.
 	 */
-	if (nbblks > 1 && log->l_sectbb_log)
-		nbblks += xlog_sectbb(log);
-	nbblks = round_up(nbblks, xlog_sectbb(log));
+	if (nbblks > 1 && log->l_sectsize > 1)
+		nbblks += log->l_sectsize;
+	nbblks = round_up(nbblks, log->l_sectsize);
 
 	return xfs_buf_get_noaddr(BBTOB(nbblks), log->l_mp->m_logdev_targp);
 }
@@ -133,7 +130,7 @@ xlog_align(
 {
 	xfs_caddr_t	ptr;
 
-	if (!log->l_sectbb_log)
+	if (log->l_sectsize == 1)
 		return XFS_BUF_PTR(bp);
 
 	ptr = XFS_BUF_PTR(bp) + BBTOB((int)blk_no & log->l_sectbb_mask);
@@ -162,8 +159,8 @@ xlog_bread_noalign(
 		return EFSCORRUPTED;
 	}
 
-	blk_no = round_down(blk_no, xlog_sectbb(log));
-	nbblks = round_up(nbblks, xlog_sectbb(log));
+	blk_no = round_down(blk_no, log->l_sectsize);
+	nbblks = round_up(nbblks, log->l_sectsize);
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
@@ -221,8 +218,8 @@ xlog_bwrite(
 		return EFSCORRUPTED;
 	}
 
-	blk_no = round_down(blk_no, xlog_sectbb(log));
-	nbblks = round_up(nbblks, xlog_sectbb(log));
+	blk_no = round_down(blk_no, log->l_sectsize);
+	nbblks = round_up(nbblks, log->l_sectsize);
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
@@ -410,7 +407,7 @@ xlog_find_verify_cycle(
 	bufblks = 1 << ffs(nbblks);
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
-		if (bufblks < xlog_sectbb(log))
+		if (bufblks < log->l_sectsize)
 			return ENOMEM;
 	}
 
@@ -1181,7 +1178,7 @@ xlog_write_log_records(
 	xfs_caddr_t	offset;
 	xfs_buf_t	*bp;
 	int		balign, ealign;
-	int		sectbb = xlog_sectbb(log);
+	int		sectsize = log->l_sectsize;
 	int		end_block = start_block + blocks;
 	int		bufblks;
 	int		error = 0;
@@ -1196,7 +1193,7 @@ xlog_write_log_records(
 	bufblks = 1 << ffs(blocks);
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
-		if (bufblks < xlog_sectbb(log))
+		if (bufblks < sectsize)
 			return ENOMEM;
 	}
 
@@ -1204,7 +1201,7 @@ xlog_write_log_records(
 	 * the buffer in the starting sector not covered by the first
 	 * write below.
 	 */
-	balign = round_down(start_block, sectbb);
+	balign = round_down(start_block, sectsize);
 	if (balign != start_block) {
 		error = xlog_bread_noalign(log, start_block, 1, bp);
 		if (error)
@@ -1223,16 +1220,16 @@ xlog_write_log_records(
 		 * the buffer in the final sector not covered by the write.
 		 * If this is the same sector as the above read, skip it.
 		 */
-		ealign = round_down(end_block, sectbb);
+		ealign = round_down(end_block, sectsize);
 		if (j == 0 && (start_block + endcount > ealign)) {
 			offset = XFS_BUF_PTR(bp);
 			balign = BBTOB(ealign - start_block);
 			error = XFS_BUF_SET_PTR(bp, offset + balign,
-						BBTOB(sectbb));
+						BBTOB(sectsize));
 			if (error)
 				break;
 
-			error = xlog_bread_noalign(log, ealign, sectbb, bp);
+			error = xlog_bread_noalign(log, ealign, sectsize, bp);
 			if (error)
 				break;
 
@@ -3553,7 +3550,7 @@ xlog_do_recovery_pass(
 			hblks = 1;
 		}
 	} else {
-		ASSERT(log->l_sectbb_log == 0);
+		ASSERT(log->l_sectsize == 1);
 		hblks = 1;
 		hbp = xlog_get_bp(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
