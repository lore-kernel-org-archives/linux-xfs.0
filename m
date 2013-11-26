Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1705D29E17
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 07:38:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B482AC001
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 05:38:57 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3cq8vAbwPNP0d9ED (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 05:38:56 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAQDcsPk005871
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 13:38:55 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAQDcr0M004728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 13:38:54 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAQDcrRR015614 for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 13:38:53 GMT
Message-ID: <5294A469.1060000@oracle.com>
Date: Tue, 26 Nov 2013 21:38:49 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 2/3] xfs: fix infinite loop by detaching the group/project
	hints from user dquot
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

xfs_quota(8) will hang up if trying to turn group/project quota off
before the user quota is off, this could be 100% reproduced by:
  # mount -ouquota,gquota /dev/sda7 /xfs
  # mkdir /xfs/test
  # xfs_quota -xc 'off -g' /xfs <-- hangs up
  # echo w > /proc/sysrq-trigger
  # dmesg

  SysRq : Show Blocked State
  task                        PC stack   pid father
  xfs_quota       D 0000000000000000     0 27574   2551 0x00000000
  [snip]
  Call Trace:
  [<ffffffff81aaa21d>] schedule+0xad/0xc0
  [<ffffffff81aa327e>] schedule_timeout+0x35e/0x3c0
  [<ffffffff8114b506>] ? mark_held_locks+0x176/0x1c0
  [<ffffffff810ad6c0>] ? call_timer_fn+0x2c0/0x2c0
  [<ffffffffa0c25380>] ? xfs_qm_shrink_count+0x30/0x30 [xfs]
  [<ffffffff81aa3306>] schedule_timeout_uninterruptible+0x26/0x30
  [<ffffffffa0c26155>] xfs_qm_dquot_walk+0x235/0x260 [xfs]
  [<ffffffffa0c059d8>] ? xfs_perag_get+0x1d8/0x2d0 [xfs]
  [<ffffffffa0c05805>] ? xfs_perag_get+0x5/0x2d0 [xfs]
  [<ffffffffa0b7707e>] ? xfs_inode_ag_iterator+0xae/0xf0 [xfs]
  [<ffffffffa0c22280>] ? xfs_trans_free_dqinfo+0x50/0x50 [xfs]
  [<ffffffffa0b7709f>] ? xfs_inode_ag_iterator+0xcf/0xf0 [xfs]
  [<ffffffffa0c261e6>] xfs_qm_dqpurge_all+0x66/0xb0 [xfs]
  [<ffffffffa0c2497a>] xfs_qm_scall_quotaoff+0x20a/0x5f0 [xfs]
  [<ffffffffa0c2b8f6>] xfs_fs_set_xstate+0x136/0x180 [xfs]
  [<ffffffff8136cf7a>] do_quotactl+0x53a/0x6b0
  [<ffffffff812fba4b>] ? iput+0x5b/0x90
  [<ffffffff8136d257>] SyS_quotactl+0x167/0x1d0
  [<ffffffff814cf2ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff81abcd19>] system_call_fastpath+0x16/0x1b

It's fine if we turn user quota off at first, then turn off other
kind of quotas if they are enabled since the group/project dquot
refcount is decreased to zero once the user quota if off. Otherwise,
those dquots refcount is non-zero due to the user dquot might refer
to them as hint(s).  Hence, above operation cause an infinite loop
at xfs_qm_dquot_walk() while trying to purge dquot cache.

This problem has been around since Linux 3.4, it was introduced by:
  [ b84a3a9675 xfs: remove the per-filesystem list of dquots ]

Originally we will release the group dquot pointers because the user
dquots maybe carrying around as a hint via xfs_qm_detach_gdquots().
However, with above change, there is no such work to be done before
purging group/project dquot cache.

In order to solve this problem, this patch introduces a special routine
xfs_qm_dqpurge_hints(), and it would release the group/project dquot
pointers the user dquots maybe carrying around as a hint, and then it
will proceed to purge the user dquot cache if requested.

Cc: stable@vger.kernel.org
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_qm.c | 71 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 14a4996..424ef73 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -134,8 +134,6 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
 
 	xfs_dqlock(dqp);
 	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
@@ -143,21 +141,6 @@ xfs_qm_dqpurge(
 		return EAGAIN;
 	}
 
-	/*
-	 * If this quota has a hint attached, prepare for releasing it now.
-	 */
-	gdqp = dqp->q_gdquot;
-	if (gdqp) {
-		xfs_dqlock(gdqp);
-		dqp->q_gdquot = NULL;
-	}
-
-	pdqp = dqp->q_pdquot;
-	if (pdqp) {
-		xfs_dqlock(pdqp);
-		dqp->q_pdquot = NULL;
-	}
-
 	dqp->dq_flags |= XFS_DQ_FREEING;
 
 	xfs_dqflock(dqp);
@@ -206,11 +189,47 @@ xfs_qm_dqpurge(
 	XFS_STATS_DEC(xs_qm_dquot_unused);
 
 	xfs_qm_dqdestroy(dqp);
+	return 0;
+}
+
+/*
+ * Release the group or project dquot pointers the user dquots maybe carrying
+ * around as a hint, and proceed to purge the user dquot cache if requested.
+*/
+STATIC int
+xfs_qm_dqpurge_hints(
+	struct xfs_dquot	*dqp,
+	void			*data)
+{
+	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
+	uint			flags = *((uint *)data);
 
+	xfs_dqlock(dqp);
+	if (dqp->dq_flags & XFS_DQ_FREEING) {
+		xfs_dqunlock(dqp);
+		return EAGAIN;
+	}
+
+	/* If this quota has a hint attached, prepare for releasing it now */
+	gdqp = dqp->q_gdquot;
 	if (gdqp)
-		xfs_qm_dqput(gdqp);
+		dqp->q_gdquot = NULL;
+
+	pdqp = dqp->q_pdquot;
 	if (pdqp)
-		xfs_qm_dqput(pdqp);
+		dqp->q_pdquot = NULL;
+
+	xfs_dqunlock(dqp);
+
+	if (gdqp)
+		xfs_qm_dqrele(gdqp);
+	if (pdqp)
+		xfs_qm_dqrele(pdqp);
+
+	if (flags & XFS_QMOPT_UQUOTA)
+		return xfs_qm_dqpurge(dqp, NULL);
+
 	return 0;
 }
 
@@ -222,8 +241,18 @@ xfs_qm_dqpurge_all(
 	struct xfs_mount	*mp,
 	uint			flags)
 {
-	if (flags & XFS_QMOPT_UQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
+	/*
+	 * We have to release group/project dquot hint(s) from the user dquot
+	 * at first if they are there, otherwise we would run into an infinite
+	 * loop while walking through radix tree to purge other type of dquots
+	 * since their refcount is not zero if the user dquot refers to them
+	 * as hint.
+	 *
+	 * Call the special xfs_qm_dqpurge_hints() will end up go through the
+	 * general xfs_qm_dqpurge() against user dquot cache if requested.
+	 */
+	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge_hints, &flags);
+
 	if (flags & XFS_QMOPT_GQUOTA)
 		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
 	if (flags & XFS_QMOPT_PQUOTA)
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
