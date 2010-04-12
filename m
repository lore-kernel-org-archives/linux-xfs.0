Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3C4qdJ1079278 for <xfs@oss.sgi.com>; Sun, 11 Apr 2010 23:52:39 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FAE08F8074
	for <xfs@oss.sgi.com>; Sun, 11 Apr 2010 21:54:31 -0700 (PDT)
Subject: [PATCHv2 10/10] xfs: track the log sector size rather than log2(that)
From: Alex Elder <aelder@sgi.com>
Date: Sun, 11 Apr 2010 23:54:30 -0500
Message-ID: <1271048070.3174.125.camel@doink>
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
To: xfs@oss.sgi.com

Change struct log so it keeps track of the size (in basic blocks)
of a log sector in l_sectsize rather than the log-base-2 of that
value (previously, l_sectbb_log).

Signed-off-by: Alex Elder <aelder@sgi.com>

---
fs/xfs/xfs_log_recover.c |   21 +++++++++++++++++----
 fs/xfs/xfs_log.c         |   33 ++++++++++++++++++---------------
 fs/xfs/xfs_log_priv.h    |    2 +-
 fs/xfs/xfs_log_recover.c |   27 ++++++++++++---------------
 3 files changed, 31 insertions(+), 31 deletions(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1025,6 +1025,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	int			i;
 	int			iclogsize;
 	int			error = ENOMEM;
+	uint			sector_bits = 0;
 
 	log = kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
 	if (!log) {
@@ -1050,29 +1051,31 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
-		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
-		if (log->l_sectbb_log < 0 ||
-		    log->l_sectbb_log > mp->m_sectbb_log) {
-			xlog_warn("XFS: Log sector size (0x%x) out of range.",
-						log->l_sectbb_log);
+	        sector_bits = mp->m_sb.sb_logsectlog;
+		if (sector_bits < BBSHIFT) {
+			xlog_warn("XFS: Log sector byte size too small "
+				"(0x%x < 0x%x)", sector_bits, BBSHIFT);
 			goto out_free_log;
 		}
 
-		/* for larger sector sizes, must have v2 or external log */
-		if (log->l_sectbb_log != 0 &&
-		    (log->l_logBBstart != 0 &&
-		     !xfs_sb_version_haslogv2(&mp->m_sb))) {
-			xlog_warn("XFS: log sector size (0x%x) invalid "
-				  "for configuration.", log->l_sectbb_log);
+	        sector_bits -= BBSHIFT;
+		if (sector_bits > mp->m_sectbb_log) {
+			xlog_warn("XFS: Log sector basic block size too large "
+				"(0x%x > 0x%x)", sector_bits, mp->m_sectbb_log);
 			goto out_free_log;
 		}
-		if (mp->m_sb.sb_logsectlog < BBSHIFT) {
-			xlog_warn("XFS: Log sector log (0x%x) too small.",
-						mp->m_sb.sb_logsectlog);
+
+		/* for larger sector sizes, must have v2 or external log */
+		if (sector_bits && (log->l_logBBstart > 0 &&
+					!xfs_sb_version_haslogv2(&mp->m_sb))) {
+
+			xlog_warn("XFS: log sector size (0x%x) invalid "
+				  "for configuration.", sector_bits);
 			goto out_free_log;
 		}
 	}
-	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
+	log->l_sectsize = 1 << sector_bits;
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
 	ASSERT(bp);
@@ -222,8 +219,8 @@ xlog_bwrite(
 		return EFSCORRUPTED;
 	}
 
-	blk_no = round_down(blk_no, xlog_sectbb(log));
-	nbblks = round_up(nbblks, xlog_sectbb(log));
+	blk_no = round_down(blk_no, log->l_sectsize);
+	nbblks = round_up(nbblks, log->l_sectsize);
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
@@ -417,7 +414,7 @@ xlog_find_verify_cycle(
 	bufblks = 1 << ffs(nbblks);
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
-		if (bufblks < xlog_sectbb(log))
+		if (bufblks < log->l_sectsize)
 			return ENOMEM;
 	}
 
@@ -1188,7 +1185,7 @@ xlog_write_log_records(
 	xfs_caddr_t	offset;
 	xfs_buf_t	*bp;
 	int		balign, ealign;
-	int		sectbb = xlog_sectbb(log);
+	int		sectbb = log->l_sectsize;
 	int		end_block = start_block + blocks;
 	int		bufblks;
 	int		error = 0;
@@ -1203,7 +1200,7 @@ xlog_write_log_records(
 	bufblks = 1 << ffs(blocks);
 	while (!(bp = xlog_get_bp(log, bufblks))) {
 		bufblks >>= 1;
-		if (bufblks < xlog_sectbb(log))
+		if (bufblks < log->l_sectsize)
 			return ENOMEM;
 	}
 
@@ -3532,7 +3529,7 @@ xlog_do_recovery_pass(
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
