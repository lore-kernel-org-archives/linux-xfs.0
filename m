Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59680 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:38 -0400
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNp-0002Ce-Ld
        for linux-xfs@vger.kernel.org; Wed, 05 Jun 2019 19:15:38 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/24] xfs: remove XLOG_STATE_IOABORT
Date: Wed,  5 Jun 2019 21:14:55 +0200
Message-Id: <20190605191511.32695-9-hch@lst.de>
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This value is the only flag in ic_state, which we otherwise use as
a state.  Switch it to a new debug-only field and also report and
actual error in the buffer in the I/O completion path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 20 +++++++++++---------
 fs/xfs/xfs_log_priv.h |  4 +++-
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index eececb847f8d..1af9302fbe1e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1257,16 +1257,16 @@ xlog_iodone(xfs_buf_t *bp)
 	struct xlog		*l = iclog->ic_log;
 	int			aborted = 0;
 
+#ifdef DEBUG
+	/* treat writes with injected CRC errors as failed */
+	if (iclog->ic_fail_crc)
+		bp->b_error = -EIO;
+#endif
+
 	/*
-	 * Race to shutdown the filesystem if we see an error or the iclog is in
-	 * IOABORT state. The IOABORT state is only set in DEBUG mode to inject
-	 * CRC errors into log recovery.
+	 * Race to shutdown the filesystem if we see an error.
 	 */
-	if (XFS_TEST_ERROR(bp->b_error, l->l_mp, XFS_ERRTAG_IODONE_IOERR) ||
-	    iclog->ic_state & XLOG_STATE_IOABORT) {
-		if (iclog->ic_state & XLOG_STATE_IOABORT)
-			iclog->ic_state &= ~XLOG_STATE_IOABORT;
-
+	if (XFS_TEST_ERROR(bp->b_error, l->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
 		xfs_buf_ioerror_alert(bp, __func__);
 		xfs_buf_stale(bp);
 		xfs_force_shutdown(l->l_mp, SHUTDOWN_LOG_IO_ERROR);
@@ -1881,13 +1881,15 @@ xlog_sync(
 	 * write on I/O completion and shutdown the fs. The subsequent mount
 	 * detects the bad CRC and attempts to recover.
 	 */
+#ifdef DEBUG
 	if (XFS_TEST_ERROR(false, log->l_mp, XFS_ERRTAG_LOG_BAD_CRC)) {
 		iclog->ic_header.h_crc &= cpu_to_le32(0xAAAAAAAA);
-		iclog->ic_state |= XLOG_STATE_IOABORT;
+		iclog->ic_fail_crc = true;
 		xfs_warn(log->l_mp,
 	"Intentionally corrupted log record at LSN 0x%llx. Shutdown imminent.",
 			 be64_to_cpu(iclog->ic_header.h_lsn));
 	}
+#endif
 
 	bp->b_io_length = BTOBB(count);
 	bp->b_log_item = iclog;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 78a2abeba895..ac4bca257609 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -50,7 +50,6 @@ static inline uint xlog_get_client_id(__be32 i)
 #define XLOG_STATE_CALLBACK  0x0020 /* Callback functions now */
 #define XLOG_STATE_DIRTY     0x0040 /* Dirty IC log, not ready for ACTIVE status*/
 #define XLOG_STATE_IOERROR   0x0080 /* IO error happened in sync'ing log */
-#define XLOG_STATE_IOABORT   0x0100 /* force abort on I/O completion (debug) */
 #define XLOG_STATE_ALL	     0x7FFF /* All possible valid flags */
 #define XLOG_STATE_NOTUSED   0x8000 /* This IC log not being used */
 
@@ -223,6 +222,9 @@ typedef struct xlog_in_core {
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
 	xlog_in_core_2_t	*ic_data;
 #define ic_header	ic_data->hic_header
+#ifdef DEBUG
+	bool			ic_fail_crc : 1;
+#endif
 } xlog_in_core_t;
 
 /*
-- 
2.20.1
