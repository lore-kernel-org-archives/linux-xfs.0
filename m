Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7CB4wx215541 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 06:11:05 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id qckm5dxZJYLlsNgA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 04:13:30 -0800 (PST)
Message-ID: <50C1DD62.20209@oracle.com>
Date: Fri, 07 Dec 2012 20:13:22 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 4/4] Make disk quota related transactions aware of this change
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

Make disk quota related transaction reservation works with this new wrapper.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c       |    6 ++++--
 fs/xfs/xfs_qm.c          |    6 +++---
 fs/xfs/xfs_qm_syscalls.c |   20 +++++++++++---------
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bf27fcc..ba08a1b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -527,9 +527,11 @@ xfs_qm_dqread(
 				XFS_WRITE_LOG_RES(mp) +
 				/*
 				 * Round the chunklen up to the next multiple
-				 * of 128 (buf log item chunk size)).
+				 * of xfs_buf_log_overhead(), that is buf log
+				 * item chunk size.
 				 */
-				BBTOB(mp->m_quotainfo->qi_dqchunklen) - 1 + 128,
+				BBTOB(mp->m_quotainfo->qi_dqchunklen) - 1 +
+				xfs_buf_log_overhead(),
 				0,
 				XFS_TRANS_PERM_LOG_RES,
 				XFS_WRITE_LOG_COUNT);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 2e86fa0..59492c1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1583,9 +1583,9 @@ xfs_qm_write_sb_changes(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
 	if ((error = xfs_trans_reserve(tp, 0,
-				      mp->m_sb.sb_sectsize + 128, 0,
-				      0,
-				      XFS_DEFAULT_LOG_COUNT))) {
+				       mp->m_sb.sb_sectsize +
+				       xfs_buf_log_overhead(), 0, 0,
+				       XFS_DEFAULT_LOG_COUNT))) {
 		xfs_trans_cancel(tp, 0);
 		return error;
 	}
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 858a3b1..16351c1 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -489,8 +489,11 @@ xfs_qm_scall_setqlim(
 		return 0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
-	if ((error = xfs_trans_reserve(tp, 0, sizeof(xfs_disk_dquot_t) + 128,
-				      0, 0, XFS_DEFAULT_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, 0,
+				  sizeof(xfs_disk_dquot_t) +
+				  xfs_buf_log_overhead(), 0, 0,
+				  XFS_DEFAULT_LOG_COUNT);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return (error);
 	}
@@ -670,14 +673,13 @@ xfs_qm_log_quotaoff(
 	uint			oldsbqflag=0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF);
-	if ((error = xfs_trans_reserve(tp, 0,
-				      sizeof(xfs_qoff_logitem_t) * 2 +
-				      mp->m_sb.sb_sectsize + 128,
-				      0,
-				      0,
-				      XFS_DEFAULT_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, 0,
+				  sizeof(xfs_qoff_logitem_t) * 2 +
+				  mp->m_sb.sb_sectsize +
+				  xfs_buf_log_overhead(), 0, 0,
+				  XFS_DEFAULT_LOG_COUNT);
+	if (error)
 		goto error0;
-	}
 
 	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
