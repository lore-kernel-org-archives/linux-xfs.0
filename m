Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 40E0E7F4C
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 19:36:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C0CA304043
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 17:36:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OirnsorEtFuAjAx9 for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 17:36:49 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UeaZL-0000dY-KA
	for xfs@oss.sgi.com; Tue, 21 May 2013 10:36:47 +1000
Date: Tue, 21 May 2013 10:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/14 V2] xfs: avoid nesting transactions in
	xfs_qm_scall_setqlim()
Message-ID: <20130521003647.GK24543@dastard>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369007481-15185-5-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Lockdep reports:

=============================================
[ INFO: possible recursive locking detected ]
3.9.0+ #3 Not tainted
---------------------------------------------
setquota/28368 is trying to acquire lock:
 (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50

but task is already holding lock:
 (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50

from xfs_qm_scall_setqlim()->xfs_dqread() when a dquot needs to be
allocated.

xfs_qm_scall_setqlim() is starting a transaction and then not
passing it into xfs_qm_dqet() and so it starts it's own transaction
when allocating the dquot.  Splat!

Fix this by not allocating the dquot in xfs_qm_scall_setqlim()
inside the setqlim transaction. This requires getting the dquot
first (and allocating it if necessary) then dropping and relocking
the dquot before joining it to the setqlim transaction.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
V2: fix error handling path that failed to release the dquot.

 fs/xfs/xfs_qm_syscalls.c |   40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index c41190c..6cdf6ff 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -489,31 +489,36 @@ xfs_qm_scall_setqlim(
 	if ((newlim->d_fieldmask & XFS_DQ_MASK) == 0)
 		return 0;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return (error);
-	}
-
 	/*
 	 * We don't want to race with a quotaoff so take the quotaoff lock.
-	 * (We don't hold an inode lock, so there's nothing else to stop
-	 * a quotaoff from happening). (XXXThis doesn't currently happen
-	 * because we take the vfslock before calling xfs_qm_sysent).
+	 * We don't hold an inode lock, so there's nothing else to stop
+	 * a quotaoff from happening.
 	 */
 	mutex_lock(&q->qi_quotaofflock);
 
 	/*
-	 * Get the dquot (locked), and join it to the transaction.
-	 * Allocate the dquot if this doesn't exist.
+	 * Get the dquot (locked) before we start, as we need to do a
+	 * transaction to allocate it if it doesn't exist. Once we have the
+	 * dquot, unlock it so we can start the next transaction safely. We hold
+	 * a reference to the dquot, so it's safe to do this unlock/lock without
+	 * it being reclaimed in the mean time.
 	 */
-	if ((error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp))) {
-		xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+	error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	if (error) {
 		ASSERT(error != ENOENT);
 		goto out_unlock;
 	}
+	xfs_dqunlock(dqp);
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
+	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		goto out_rele;
+	}
+
+	xfs_dqlock(dqp);
 	xfs_trans_dqjoin(tp, dqp);
 	ddq = &dqp->q_core;
 
@@ -621,9 +626,10 @@ xfs_qm_scall_setqlim(
 	xfs_trans_log_dquot(tp, dqp);
 
 	error = xfs_trans_commit(tp, 0);
-	xfs_qm_dqrele(dqp);
 
- out_unlock:
+out_rele:
+	xfs_qm_dqrele(dqp);
+out_unlock:
 	mutex_unlock(&q->qi_quotaofflock);
 	return error;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
