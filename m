Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B694C2D0DD
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C80062064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="out2W8yd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgAABJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAABJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001190Fc089152
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=a3Ce/5MCTDkyJ3Vi8ti9FxrsaZ//d2nhrFwykgthlFk=;
 b=out2W8ydck1/B+Bi7XeX8jn+eFZ6xmxUJ5N39sRU1zNakwINVq1Poj5t4lIhpoSjyy79
 fZcFnHsqxJw85fFrbMu9gIAl0D0/0TT/CygwHeFlCGaOzHCP63yDTdm2OPslB/qe8Pif
 Pe7RDUV9y0c397RM1WNUhVhqsB9EGGx0FQJzn3DdxavPe4VT8oN0zsc+osou7jY3iWQj
 mCoxHk1dJhRlr4b5vIszSKVsuhdC9l3fjCfzzWDW+x6ruCq0bNKcf2D6GGVHvyYw+YHA
 5iYzFuWf1uk2kLeVT7Fys6lAvHicWteckv2hmIOdCLtE6v7/fRxOQ34nr7tqteFCMLx6 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118v2x190375
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x8bsrfydk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:02 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 001191cq005682
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:01 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:09:00 -0800
Subject: [PATCH 03/10] xfs: track unlinked inactive inode quota counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:08:58 -0800
Message-ID: <157784093877.1362752.15817417024591800990.stgit@magnolia>
In-Reply-To: <157784092020.1362752.15046503361741521784.stgit@magnolia>
References: <157784092020.1362752.15046503361741521784.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Set up quota counters to track the number of inodes and blocks that will
be freed from inactivating unlinked inodes.  We'll use this in the
deferred inactivation patch to hide the effects of deferred processing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h       |   10 ++++++++++
 fs/xfs/xfs_inode.c       |    4 ++++
 fs/xfs/xfs_qm.c          |   13 +++++++++++++
 fs/xfs/xfs_qm_syscalls.c |    7 ++++---
 fs/xfs/xfs_quota.h       |    4 +++-
 fs/xfs/xfs_trace.h       |    1 +
 7 files changed, 80 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6429001d1895..e50c75d9d788 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1275,3 +1275,48 @@ xfs_qm_dqiterate(
 
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
index fe3e46df604b..0d58f4ae8349 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -47,6 +47,16 @@ struct xfs_dquot {
 	xfs_qcnt_t		q_res_icount;
 	/* total realtime blks used+reserved */
 	xfs_qcnt_t		q_res_rtbcount;
+
+	/* inactive inodes attached to this dquot */
+	uint64_t		q_ina_total;
+	/* inactive regular nblks used+reserved */
+	xfs_qcnt_t		q_ina_bcount;
+	/* inactive inos allocd+reserved */
+	xfs_qcnt_t		q_ina_icount;
+	/* inactive realtime blks used+reserved */
+	xfs_qcnt_t		q_ina_rtbcount;
+
 	xfs_qcnt_t		q_prealloc_lo_wmark;
 	xfs_qcnt_t		q_prealloc_hi_wmark;
 	int64_t			q_low_space[XFS_QLOWSP_MAX];
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2fe8f030ebb8..aa019e49e512 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -36,6 +36,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_health.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -1858,6 +1860,8 @@ xfs_inode_iadjust(
 	percpu_counter_add(&mp->m_iinactive, inodes);
 	percpu_counter_add(&mp->m_dinactive, dblocks);
 	percpu_counter_add(&mp->m_rinactive, rblocks);
+
+	xfs_qm_iadjust(ip, direction, inodes, dblocks, rblocks);
 }
 
 /*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ed6cc943db92..fc3898f5e27d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -424,6 +424,19 @@ xfs_qm_dquot_isolate(
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
index c339b7404cf3..d93bf0c39d3d 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -616,8 +616,8 @@ xfs_qm_scall_getquota_fill_qc(
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
@@ -626,7 +626,8 @@ xfs_qm_scall_getquota_fill_qc(
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_hardlimit));
 	dst->d_rt_spc_softlimit =
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
-	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_res_rtbcount);
+	dst->d_rt_space =
+		XFS_FSB_TO_B(mp, dqp->q_res_rtbcount - dqp->q_ina_rtbcount);
 	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
 	dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index efe42ae7a2f3..c354f01dae7b 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -106,7 +106,8 @@ extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
 extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
-
+extern void xfs_qm_iadjust(struct xfs_inode *ip, int direction, int64_t inodes,
+			   int64_t dblocks, int64_t rblocks);
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
@@ -148,6 +149,7 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 #define xfs_qm_mount_quotas(mp)
 #define xfs_qm_unmount(mp)
 #define xfs_qm_unmount_quotas(mp)
+#define xfs_qm_iadjust(ip, dir, inodes, dblocks, rblocks)
 #endif /* CONFIG_XFS_QUOTA */
 
 #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cee45e6cdb39..0064f4491d66 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -906,6 +906,7 @@ DEFINE_EVENT(xfs_dquot_class, name, \
 	TP_PROTO(struct xfs_dquot *dqp), \
 	TP_ARGS(dqp))
 DEFINE_DQUOT_EVENT(xfs_dqadjust);
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_inactive);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_busy);

