Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19929 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdAUIEu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:04:50 -0500
Subject: [PATCH 41/55] xfs: shut off scrub-related error and corruption
 messages
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:04:47 -0800
Message-ID: <148498588779.15323.4547967509692752204.stgit@birch.djwong.org>
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

While we're scrubbing and repairing, silence errors and corruption
messages to avoid flooding the logs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |    3 +++
 fs/xfs/xfs_buf.c      |    3 +++
 fs/xfs/xfs_error.c    |    9 +++++++++
 fs/xfs/xfs_mount.h    |    1 +
 fs/xfs/xfs_super.c    |    1 +
 5 files changed, 17 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1c20006..b0d0ed2 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -790,6 +790,8 @@ xfs_scrub_metadata(
 		warned = true;
 	}
 
+	atomic_inc(&mp->m_scrubbers);
+
 retry_op:
 	/* Set up for the operation. */
 	error = fns->setup(&sc, ip, sm, deadlocked);
@@ -813,6 +815,7 @@ xfs_scrub_metadata(
 out_teardown:
 	error = xfs_scrub_teardown(&sc, ip, error);
 out:
+	atomic_dec(&mp->m_scrubbers);
 	trace_xfs_scrub_done(ip, sm->sm_type, sm->sm_agno, sm->sm_ino,
 			sm->sm_gen, sm->sm_flags, error);
 	return error;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7f0a01f..e8d2108 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -41,6 +41,7 @@
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_error.h"
 
 static kmem_zone_t *xfs_buf_zone;
 
@@ -561,6 +562,8 @@ _xfs_buf_find(
 	 */
 	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
 	if (cmap.bm_bn < 0 || cmap.bm_bn >= eofs) {
+		if (atomic_read(&btp->bt_mount->m_scrubbers) > 0)
+			return NULL;
 		/*
 		 * XXX (dgc): we should really be returning -EFSCORRUPTED here,
 		 * but none of the higher level infrastructure supports
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index ed7ee4e..955c4cc 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -132,6 +132,9 @@ xfs_error_report(
 	int			linenum,
 	void			*ra)
 {
+	if (atomic_read(&mp->m_scrubbers) > 0)
+		return;
+
 	if (level <= xfs_error_level) {
 		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
 		"Internal error %s at line %d of file %s.  Caller %pS",
@@ -151,6 +154,9 @@ xfs_corruption_error(
 	int			linenum,
 	void			*ra)
 {
+	if (atomic_read(&mp->m_scrubbers) > 0)
+		return;
+
 	if (level <= xfs_error_level)
 		xfs_hex_dump(p, 64);
 	xfs_error_report(tag, level, mp, filename, linenum, ra);
@@ -167,6 +173,9 @@ xfs_verifier_error(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 
+	if (atomic_read(&mp->m_scrubbers) > 0)
+		return;
+
 	xfs_alert(mp, "Metadata %s detected at %pF, %s block 0x%llx",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
 		  __return_address, bp->b_ops->name, bp->b_bn);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 84f7852..3883757 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -205,6 +205,7 @@ typedef struct xfs_mount {
 	 */
 	bool			m_fail_writes;
 #endif
+	atomic_t		m_scrubbers;	/* # of active scrub processes */
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eecbaac..950d268 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1538,6 +1538,7 @@ xfs_fs_fill_super(
 	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
+	atomic_set(&mp->m_scrubbers, 0);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);

