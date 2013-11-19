Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B41CE7F4E
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 02:41:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83747304039
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 00:41:12 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 76qopHYSJ2iVcoWg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Nov 2013 00:41:11 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAJ8f94M027253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 08:41:10 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAJ8f9qb011458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 08:41:09 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAJ8f8HM011400 for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 08:41:08 GMT
Message-ID: <528B2476.9050404@oracle.com>
Date: Tue, 19 Nov 2013 16:42:30 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix infinite loop by detaching the group/project hints
	from user dquot
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

xfs_quota(8) will hang up if trying to turn group quota or project
quota before the user quota is off, this could be 100% reproduced by:
# mount -ouquota,gquota /dev/sda7 /xfs
# mkdir /xfs/test
# xfs_quota -xc 'off -g' /xfs
# echo w > /proc/sysrq-trigger
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
refcount is decreased to zero once the user quota if off.  Otherwse,
those dquots refcount is non-zero due to the user dquot maybe refer
to them as hint(s).  Hence, above operation hit an infinite loop at
xfs_qm_dquot_walk() to purge dquot cache.

This problem has been around since Linux 3.4, it was introduced by:
	b84a3a96751f93071c1863f2962273973c8b8f5e
	xfs: remove the per-filesystem list of dquots

Originally we will release the group dquot pointers because the user
dquots maybe carrying around as a hint via xfs_qm_detach_gdquots().
However, with this change, there is no such work to be done before
purge group/project dquot cache.

This fix introduce a similar routine to the old xfs_qm_detach_gdquots(),
it will detach the group/project hints by searching the user dquot radix
tree and release those hints if they are there.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_qm.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 14a4996..410adf4 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -60,6 +60,77 @@ STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
  */
 #define XFS_DQ_LOOKUP_BATCH	32
 
+/*
+ * Release the group or project dquot pointers the user dquots may be
+ * carrying around as a hint.
+ */
+STATIC void
+xfs_qm_dqdetach_hint(
+	struct xfs_mount	*mp,
+	int			type)
+{
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	struct radix_tree_root	*tree = xfs_dquot_tree(qi, XFS_DQ_USER);
+	uint32_t		next_index;
+	int			skipped;
+	int			nr_found;
+
+	ASSERT(type == XFS_DQ_GROUP || type == XFS_DQ_PROJ);
+
+restart:
+	next_index = 0;
+	skipped = 0;
+	nr_found = 0;
+
+	while (1) {
+		struct xfs_dquot *batch[XFS_DQ_LOOKUP_BATCH];
+		int		i;
+
+		mutex_lock(&qi->qi_tree_lock);
+		nr_found = radix_tree_gang_lookup(tree, (void **)batch,
+					next_index, XFS_DQ_LOOKUP_BATCH);
+		if (!nr_found) {
+			mutex_unlock(&qi->qi_tree_lock);
+			break;
+		}
+
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_dquot *dqp = batch[i];
+			struct xfs_dquot *dqhintp;
+
+			next_index = be32_to_cpu(dqp->q_core.d_id) + 1;
+
+			xfs_dqlock(dqp);
+			if (dqp->dq_flags & XFS_DQ_FREEING) {
+				xfs_dqunlock(dqp);
+				skipped++;
+				continue;
+			}
+
+			if (type == XFS_DQ_GROUP) {
+				dqhintp = dqp->q_gdquot;
+				if (dqhintp)
+					dqp->q_gdquot = NULL;
+			} else {
+				dqhintp = dqp->q_pdquot;
+				if (dqhintp)
+					dqp->q_pdquot = NULL;
+			}
+			xfs_dqunlock(dqp);
+
+			if (dqhintp)
+				xfs_qm_dqrele(dqhintp);
+		}
+
+		mutex_unlock(&qi->qi_tree_lock);
+	}
+
+	if (skipped) {
+		delay(1);
+		goto restart;
+	}
+}
+
 STATIC int
 xfs_qm_dquot_walk(
 	struct xfs_mount	*mp,
@@ -224,10 +295,14 @@ xfs_qm_dqpurge_all(
 {
 	if (flags & XFS_QMOPT_UQUOTA)
 		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
-	if (flags & XFS_QMOPT_GQUOTA)
+	if (flags & XFS_QMOPT_GQUOTA) {
+		xfs_qm_dqdetach_hint(mp, XFS_DQ_GROUP);
 		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
-	if (flags & XFS_QMOPT_PQUOTA)
+	}
+	if (flags & XFS_QMOPT_PQUOTA) {
+		xfs_qm_dqdetach_hint(mp, XFS_DQ_PROJ);
 		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, NULL);
+	}
 }
 
 /*
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
