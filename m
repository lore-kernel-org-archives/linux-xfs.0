Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GKq1tr010591 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 15:52:01 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201004162053.o3GKrrgr025189@stout.americas.sgi.com>
Date: Fri, 16 Apr 2010 15:53:53 -0500
Subject: [PATCHv2 4/5] xfs: record log sector size rather than log2(that)
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

Change struct log so it keeps track of the size (in basic blocks) of
a log sector in l_sectBBsize rather than the log-base-2 of that
value (previously, l_sectbb_log).  The name was chosen for
consistency with the other fields in the structure that represent
a number of basic blocks.

(Updated so that a variable used in computing and verifying a log's
sector size is named "log2_size".  Also added the "BB" to the
structure field name, based on feedback from Eric Sandeen.  Also
dropped some superfluous parentheses.)

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_log.c         |   33 ++++++++++++++++++---------------
 fs/xfs/xfs_log_priv.h    |    2 +-
 fs/xfs/xfs_log_recover.c |   27 ++++++++++++---------------
 3 files changed, 31 insertions(+), 31 deletions(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1039,6 +1039,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	int			i;
 	int			iclogsize;
 	int			error = ENOMEM;
+	uint			log2_size = 0;
 
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
+	        log2_size = mp->m_sb.sb_logsectlog;
+		if (log2_size < BBSHIFT) {
+			xlog_warn("XFS: Log sector size too small "
+				"(0x%x < 0x%x)", log2_size, BBSHIFT);
 			goto out_free_log;
 		}
 
-		/* for larger sector sizes, must have v2 or external log */
-		if (log->l_sectbb_log != 0 &&
-		    (log->l_logBBstart != 0 &&
-		     !xfs_sb_version_haslogv2(&mp->m_sb))) {
-			xlog_warn("XFS: log sector size (0x%x) invalid "
-				  "for configuration.", log->l_sectbb_log);
+	        log2_size -= BBSHIFT;
+		if (log2_size > mp->m_sectbb_log) {
+			xlog_warn("XFS: Log sector size too large "
+				"(0x%x > 0x%x)", log2_size, mp->m_sectbb_log);
 			goto out_free_log;
 		}
-		if (mp->m_sb.sb_logsectlog < BBSHIFT) {
-			xlog_warn("XFS: Log sector log (0x%x) too small.",
-						mp->m_sb.sb_logsectlog);
+
+		/* for larger sector sizes, must have v2 or external log */
+		if (log2_size && log->l_logBBstart > 0 &&
+			    !xfs_sb_version_haslogv2(&mp->m_sb)) {
+
+			xlog_warn("XFS: log sector size (0x%x) invalid "
+				  "for configuration.", log2_size);
 			goto out_free_log;
 		}
 	}
-	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
+	log->l_sectBBsize = 1 << log2_size;
+	log->l_sectbb_mask = log->l_sectBBsize - 1;
 
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
+	uint			l_sectBBsize;   /* sector size in BBs */
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
+	if (nbblks > 1 && log->l_sectBBsize > 1)
+		nbblks += log->l_sectBBsize;
+	nbblks = round_up(nbblks, log->l_sectBBsize);
 
 	return xfs_buf_get_noaddr(BBTOB(nbblks), log->l_mp->m_logdev_targp);
 }
@@ -133,7 +130,7 @@ xlog_align(
 {
 	xfs_caddr_t	ptr;
 
-	if (!log->l_sectbb_log)
+	if (log->l_sectBBsize == 1)
 		return XFS_BUF_PTR(bp);
 
 	ptr = XFS_BUF_PTR(bp) + BBTOB((int)blk_no & log->l_sectbb_mask);
@@ -162,8 +159,8 @@ xlog_bread_noalign(
 		return EFSCORRUPTED;
 	}
 
-	blk_no = round_down(blk_no, xlog_sectbb(log));
-	nbblks = round_up(nbblks, xlog_sectbb(log));
+	blk_no = round_down(blk_no, log->l_sectBBsize);
+	nbblks = round_up(nbblks, log->l_sectBBsize);
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
@@ -221,8 +218,8 @@ xlog_bwrite(
 		return EFSCORRUPTED;
 	}
 
-	blk_no = round_down(blk_no, xlog_sectbb(log));
-	nbblks = round_up(nbblks, xlog_sectbb(log));
+	blk_no = round_down(blk_no, log->l_sectBBsize);
+	nbblks = round_up(nbblks, log->l_sectBBsize);
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
@@ -410,7 +407,7 @@ xlog_find_verify_cycle(
 	bufblks = 1 << ffs(nbblks);
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
-		if (bufblks < xlog_sectbb(log))
+		if (bufblks < log->l_sectBBsize)
 			return ENOMEM;
 	}
 
@@ -1181,7 +1178,7 @@ xlog_write_log_records(
 	xfs_caddr_t	offset;
 	xfs_buf_t	*bp;
 	int		balign, ealign;
-	int		sectbb = xlog_sectbb(log);
+	int		sectbb = log->l_sectBBsize;
 	int		end_block = start_block + blocks;
 	int		bufblks;
 	int		error = 0;
@@ -1196,7 +1193,7 @@ xlog_write_log_records(
 	bufblks = 1 << ffs(blocks);
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
-		if (bufblks < xlog_sectbb(log))
+		if (bufblks < sectbb)
 			return ENOMEM;
 	}
 
@@ -3553,7 +3550,7 @@ xlog_do_recovery_pass(
 			hblks = 1;
 		}
 	} else {
-		ASSERT(log->l_sectbb_log == 0);
+		ASSERT(log->l_sectBBsize == 1);
 		hblks = 1;
 		hbp = xlog_get_bp(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
