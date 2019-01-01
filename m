Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfAACRY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:17:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012E4J2173563
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:23 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jqx411-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:17:23 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012HMub020775
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:23 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012HMP8000662
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:22 GMT
Subject: [PATCH 05/12] xfs: track unlinked inactive inode quota counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:17:21 -0800
Message-ID: <154630904149.16693.3792457499320708413.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Set up quota counters to track the number of inodes and blocks that will
be freed from inactivating unlinked inodes.  We'll use this in the
deferred inactivation patch to hide the effects of deferred processing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h       |    4 ++++
 fs/xfs/xfs_inode.c       |    4 ++++
 fs/xfs/xfs_qm.c          |   13 +++++++++++++
 fs/xfs/xfs_qm_syscalls.c |    7 ++++---
 fs/xfs/xfs_quota.h       |    4 +++-
 fs/xfs/xfs_trace.h       |    1 +
 7 files changed, 74 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 87e6dd5326d5..14e2b732213e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1270,3 +1270,48 @@ xfs_qm_dqiterate(
 
 	return error;
 }
+
+/* Update dquot pending-inactivation counters. */
+STATIC void
+xfs_dquot_adjust(
+	struct xfs_dquot	*dqp,
+	int			direction,
+	int64_t			inodes,
+	int64_t			dblocks,
+	int64_t			rblocks)
+{
+	xfs_dqlock(dqp);
+	dqp->q_ina_total += direction;
+	dqp->q_ina_icount += inodes;
+	dqp->q_ina_bcount += dblocks;
+	dqp->q_ina_rtbcount += rblocks;
+	xfs_dqunlock(dqp);
+}
+
+/* Update pending-inactivation counters for all dquots attach to inode. */
+void
+xfs_qm_iadjust(
+	struct xfs_inode	*ip,
+	int			direction,
+	int64_t			inodes,
+	int64_t			dblocks,
+	int64_t			rblocks)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp) ||
+	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
+		return;
+
+	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
+		xfs_dquot_adjust(ip->i_udquot, direction, inodes, dblocks,
+				rblocks);
+
+	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
+		xfs_dquot_adjust(ip->i_gdquot, direction, inodes, dblocks,
+				rblocks);
+
+	if (XFS_IS_PQUOTA_ON(mp) && ip->i_pdquot)
+		xfs_dquot_adjust(ip->i_pdquot, direction, inodes, dblocks,
+				rblocks);
+}
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 64bd8640f6e8..4be05d44fa4a 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -45,6 +45,10 @@ typedef struct xfs_dquot {
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
 	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
 	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
+	uint64_t	 q_ina_total;	/* inactive inodes attached here */
+	xfs_qcnt_t	 q_ina_bcount;	/* inactive regular nblks used+reserved */
+	xfs_qcnt_t	 q_ina_icount;	/* inactive inos allocd+reserved */
+	xfs_qcnt_t	 q_ina_rtbcount;/* inactive realtime blks used+reserved */
 	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
 	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
 	int64_t		 q_low_space[XFS_QLOWSP_MAX];
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9689479ae67d..78c88a8c947a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -41,6 +41,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -1836,6 +1838,8 @@ xfs_inode_iadjust(
 	percpu_counter_add(&mp->m_iinactive, inodes);
 	percpu_counter_add(&mp->m_dinactive, dblocks);
 	percpu_counter_add(&mp->m_rinactive, rblocks);
+
+	xfs_qm_iadjust(ip, direction, inodes, dblocks, rblocks);
 }
 
 /*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 52ed7904df10..116b24c980fd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -426,6 +426,19 @@ xfs_qm_dquot_isolate(
 	if (!xfs_dqlock_nowait(dqp))
 		goto out_miss_busy;
 
+	/*
+	 * An inode is on the inactive list waiting to release its resources,
+	 * so remove this dquot from the freelist and try again.  We detached
+	 * the dquot from the NEEDS_INACTIVE inode so that quotaoff won't
+	 * deadlock on inactive inodes holding dquots.
+	 */
+	if (dqp->q_ina_total > 0) {
+		xfs_dqunlock(dqp);
+		trace_xfs_dqreclaim_inactive(dqp);
+		list_lru_isolate(lru, &dqp->q_lru);
+		return LRU_REMOVED;
+	}
+
 	/*
 	 * This dquot has acquired a reference in the meantime remove it from
 	 * the freelist and try again.
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index b3190890f096..ba058b8da8a8 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -626,8 +626,8 @@ xfs_qm_scall_getquota_fill_qc(
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_blk_softlimit));
 	dst->d_ino_hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
 	dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
-	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_res_bcount);
-	dst->d_ino_count = dqp->q_res_icount;
+	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_res_bcount - dqp->q_ina_bcount);
+	dst->d_ino_count = dqp->q_res_icount - dqp->q_ina_icount;
 	dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
 	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
 	dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
@@ -636,7 +636,8 @@ xfs_qm_scall_getquota_fill_qc(
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_hardlimit));
 	dst->d_rt_spc_softlimit =
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
-	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_res_rtbcount);
+	dst->d_rt_space =
+		XFS_FSB_TO_B(mp, dqp->q_res_rtbcount - dqp->q_ina_rtbcount);
 	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
 	dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 55b798265ef7..bd95a0738086 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -103,7 +103,8 @@ extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
 extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
-
+extern void xfs_qm_iadjust(struct xfs_inode *ip, int direction, int64_t inodes,
+			   int64_t dblocks, int64_t rblocks);
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
@@ -145,6 +146,7 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 #define xfs_qm_mount_quotas(mp)
 #define xfs_qm_unmount(mp)
 #define xfs_qm_unmount_quotas(mp)
+#define xfs_qm_iadjust(ip, dir, inodes, dblocks, rblocks)
 #endif /* CONFIG_XFS_QUOTA */
 
 #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6fcc893dfc91..5127f91ce3fd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -901,6 +901,7 @@ DEFINE_EVENT(xfs_dquot_class, name, \
 	TP_PROTO(struct xfs_dquot *dqp), \
 	TP_ARGS(dqp))
 DEFINE_DQUOT_EVENT(xfs_dqadjust);
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_inactive);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_busy);
