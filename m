Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbdBOPks (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 10:40:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/5] xfs: allocate quotaoff transactions up front to avoid log deadlock
Date: Wed, 15 Feb 2017 10:40:44 -0500
Message-Id: <1487173247-5965-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, Dave Chinner <david@fromorbit.com>

The quotaoff operation commits two explicitly synchronous
transactions to correctly handle log recovery of dquots being
modified at the time the quotaoff occurs. The first quotaoff
transaction pins the tail of the log with a qoff logitem in the AIL
to ensure further logged dquots stay ahead of the quotaoff operation
in the log. The second quotaoff_end transaction is committed after
the quotaoff operation completes, releases the original log item and
thus unpins the log.

Since the first transaction pins the tail of the log, this means a
finite amount of space in the log is available between the time a
quotaoff starts and completes before transaction reservations have
to block on the log. While the quotaoff operation itself consumes no
further log space, it is possible for other operations in the
filesystem to consume the remaining log space before the quotaoff
completes. If this occurs, the quotaoff_end transaction also blocks
on the log which prevents the release of the log item and the
filesystem deadlocks. This has been reproduced via repeated xfs/305
iterations on a vm with fairly limited resources.

To avoid a deadlock due to a particularly slow quotaoff operation,
allocate the quotaoff_end transaction immediately after the initial
quotaoff transaction is committed. Carry a reference to the
transaction through xfs_qm_scall_quotaoff() rather than the qoff log
item and commit it once the quotaoff completes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_qm_syscalls.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 475a388..dbb6802 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -35,9 +35,11 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 
-STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
-STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
-					uint);
+STATIC int	xfs_qm_log_quotaoff(struct xfs_mount *, struct xfs_trans **,
+				    uint);
+STATIC int	xfs_qm_log_quotaoff_end(struct xfs_mount *,
+					struct xfs_qoff_logitem *,
+					struct xfs_trans **, uint);
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -56,7 +58,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	xfs_qoff_logitem_t	*qoffstart;
+	struct xfs_trans	*qend_tp;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -128,7 +130,7 @@ xfs_qm_scall_quotaoff(
 	 * and synchronously. If we fail to write, we should abort the
 	 * operation as it cannot be recovered safely if we crash.
 	 */
-	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
+	error = xfs_qm_log_quotaoff(mp, &qend_tp, flags);
 	if (error)
 		goto out_unlock;
 
@@ -181,7 +183,7 @@ xfs_qm_scall_quotaoff(
 	 * So, we have QUOTAOFF start and end logitems; the start
 	 * logitem won't get overwritten until the end logitem appears...
 	 */
-	error = xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
+	error = xfs_trans_commit(qend_tp);
 	if (error) {
 		/* We're screwed now. Shutdown is the only option. */
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
@@ -556,13 +558,14 @@ xfs_qm_scall_setqlim(
 
 STATIC int
 xfs_qm_log_quotaoff_end(
-	xfs_mount_t		*mp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*startqoff,
+	struct xfs_trans	**tpp,
 	uint			flags)
 {
-	xfs_trans_t		*tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t	*qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
 	if (error)
@@ -578,21 +581,22 @@ xfs_qm_log_quotaoff_end(
 	 * We don't care about quotoff's performance.
 	 */
 	xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp);
+	*tpp = tp;
+	return 0;
 }
 
 
 STATIC int
 xfs_qm_log_quotaoff(
-	xfs_mount_t	       *mp,
-	xfs_qoff_logitem_t     **qoffstartp,
-	uint		       flags)
+	struct xfs_mount	*mp,
+	struct xfs_trans	**end_tp,
+	uint			flags)
 {
-	xfs_trans_t	       *tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t     *qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
-	*qoffstartp = NULL;
+	*end_tp = NULL;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
 	if (error)
@@ -617,7 +621,9 @@ xfs_qm_log_quotaoff(
 	if (error)
 		goto out;
 
-	*qoffstartp = qoffi;
+	error = xfs_qm_log_quotaoff_end(mp, qoffi, end_tp, flags);
+	if (error)
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 out:
 	return error;
 }
-- 
2.7.4

