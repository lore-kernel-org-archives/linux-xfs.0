Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1CBE97F6A
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 06:32:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8EAB5AC001
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 04:32:56 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id k66qtzmVTkYUYRXK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 04:32:55 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s0NCWroY024169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 12:32:54 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s0NCWqJL025001
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 12:32:53 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s0NCWqN8010383 for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 12:32:52 GMT
Message-ID: <52E10BED.8090607@oracle.com>
Date: Thu, 23 Jan 2014 20:32:45 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: convert xfs_log_commit_cil() to void
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Convert xfs_log_commit_cil() to a void function since it return nothing
but 0 in any case, after that we can simplify the relative code logic
in xfs_trans_commit() accordingly.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_log.h     |  2 +-
 fs/xfs/xfs_log_cil.c |  3 +--
 fs/xfs/xfs_trans.c   | 12 ++----------
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index e148719..67927c3 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -129,7 +129,7 @@ void	  xlog_iodone(struct xfs_buf *);
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
-int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
+void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_lsn_t *commit_lsn, int flags);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5eb51fc..bb1027a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -740,7 +740,7 @@ xlog_cil_empty(
  * background commit, returns without it held once background commits are
  * allowed again.
  */
-int
+void
 xfs_log_commit_cil(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
@@ -786,7 +786,6 @@ xfs_log_commit_cil(
 	xlog_cil_push_background(log);
 
 	up_read(&cil->xc_ctx_lock);
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c812c5c..54a5732 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -887,12 +887,7 @@ xfs_trans_commit(
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
-	error = xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
-	if (error == ENOMEM) {
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-		error = XFS_ERROR(EIO);
-		goto out_unreserve;
-	}
+	xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
 
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 	xfs_trans_free(tp);
@@ -902,10 +897,7 @@ xfs_trans_commit(
 	 * log out now and wait for it.
 	 */
 	if (sync) {
-		if (!error) {
-			error = _xfs_log_force_lsn(mp, commit_lsn,
-				      XFS_LOG_SYNC, NULL);
-		}
+		error = _xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
 		XFS_STATS_INC(xs_trans_sync);
 	} else {
 		XFS_STATS_INC(xs_trans_async);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
