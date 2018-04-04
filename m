Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751231AbeDDSy1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 14:54:27 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D99A781DEC
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 18:54:27 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF3257A4CC
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 18:54:27 +0000 (UTC)
Subject: [PATCH 2/6] xfs: pass xfs_dqblk to xfs_dquot_verify/xfs_dquot_repair
From: Eric Sandeen <sandeen@redhat.com>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Message-ID: <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
Date: Wed, 4 Apr 2018 13:54:26 -0500
MIME-Version: 1.0
In-Reply-To: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

In order to validate the UUID in xfs_dquot_verify, we need
the full xfs_qblk, not just the xfs_disk_dquot_t (which is
a subset).

Do the same for xfs_dquot_repair, for the same reasons.
Casting a xfs_disk_dquot to a xfs_qblk is risky if the source
pointer wasn't a full xfs_dqblk, so enforce that by changing
the arguments to these functions.

In xfs_qm_dqflush we move the memcpy up so that we have
a full (and updated) xfs_dqblk to test.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  | 23 +++++++++--------------
 fs/xfs/libxfs/xfs_quota_defs.h |  4 ++--
 fs/xfs/xfs_dquot.c             | 12 +++++++-----
 fs/xfs/xfs_log_recover.c       |  6 ++++--
 fs/xfs/xfs_qm.c                |  6 +++---
 5 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index a926058..f94e8c2 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -44,11 +44,13 @@
  */
 xfs_failaddr_t
 xfs_dquot_verify(
-	struct xfs_mount *mp,
-	xfs_disk_dquot_t *ddq,
-	xfs_dqid_t	 id,
-	uint		 type)	  /* used only when IO_dorepair is true */
+	struct xfs_mount	*mp,
+	struct xfs_dqblk	*dqb,
+	xfs_dqid_t		id,
+	uint			type)	  /* used only during quota rebuild */
 {
+	struct xfs_disk_dquot	*ddq = &dqb->dd_diskdq;
+
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
 	 * 1. If we crash while deleting the quotainode(s), and those blks got
@@ -104,13 +106,10 @@
 int
 xfs_dquot_repair(
 	struct xfs_mount	*mp,
-	struct xfs_disk_dquot	*ddq,
+	struct xfs_dqblk	*d,
 	xfs_dqid_t		id,
 	uint			type)
 {
-	struct xfs_dqblk	*d = (struct xfs_dqblk *)ddq;
-
-
 	/*
 	 * Typically, a repair is only requested by quotacheck.
 	 */
@@ -192,14 +191,10 @@
 	 * buffer so corruptions could point to the wrong dquot in this case.
 	 */
 	for (i = 0; i < ndquots; i++) {
-		struct xfs_disk_dquot	*ddq;
-
-		ddq = &d[i].dd_diskdq;
-
 		if (i == 0)
-			id = be32_to_cpu(ddq->d_id);
+			id = be32_to_cpu(d[i].dd_diskdq.d_id);
 
-		fa = xfs_dquot_verify(mp, ddq, id + i, 0);
+		fa = xfs_dquot_verify(mp, &d[i], id + i, 0);
 		if (fa)
 			return fa;
 	}
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 8433656..424526a 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -152,9 +152,9 @@
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
 extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
-		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
+		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
-extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_disk_dquot *ddq,
+extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, uint type);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7e203f9..f7bed3c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -955,6 +955,7 @@
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_buf		*bp;
+	struct xfs_dqblk	*dqb;
 	struct xfs_disk_dquot	*ddqp;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -998,12 +999,16 @@
 	/*
 	 * Calculate the location of the dquot inside the buffer.
 	 */
-	ddqp = bp->b_addr + dqp->q_bufoffset;
+	dqb = bp->b_addr + dqp->q_bufoffset;
+	ddqp = &dqb->dd_diskdq;
+
+	/* This is the only portion of data that needs to persist */
+	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
 
 	/*
 	 * A simple sanity check in case we got a corrupted dquot..
 	 */
-	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0);
+	fa = xfs_dquot_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
 				be32_to_cpu(ddqp->d_id), fa);
@@ -1013,9 +1018,6 @@
 		return -EIO;
 	}
 
-	/* This is the only portion of data that needs to persist */
-	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
-
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
 	 */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3b35feb..546df8e1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3309,6 +3309,7 @@ struct xfs_buf_cancel {
 {
 	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
+	struct xfs_dqblk	*dqb;
 	struct xfs_disk_dquot	*ddq, *recddq;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -3322,7 +3323,8 @@ struct xfs_buf_cancel {
 	if (mp->m_qflags == 0)
 		return 0;
 
-	recddq = item->ri_buf[1].i_addr;
+	dqb = item->ri_buf[1].i_addr;
+	recddq = &dqb->dd_diskdq;
 	if (recddq == NULL) {
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 		return -EIO;
@@ -3353,7 +3355,7 @@ struct xfs_buf_cancel {
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
+	fa = xfs_dquot_verify(mp, dqb, dq_f->qlf_id, 0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 64c22c32..b422382 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -859,7 +859,7 @@ struct xfs_qm_isolate {
 	for (j = 0; j < mp->m_quotainfo->qi_dqperchunk; j++) {
 		struct xfs_disk_dquot	*ddq;
 
-		ddq = (struct xfs_disk_dquot *)&dqb[j];
+		ddq = &dqb[j].dd_diskdq;
 
 		/*
 		 * Do a sanity check, and if needed, repair the dqblk. Don't
@@ -867,9 +867,9 @@ struct xfs_qm_isolate {
 		 * find uninitialised dquot blks. See comment in
 		 * xfs_dquot_verify.
 		 */
-		fa = xfs_dquot_verify(mp, ddq, id + j, type);
+		fa = xfs_dquot_verify(mp, &dqb[j], id + j, type);
 		if (fa)
-			xfs_dquot_repair(mp, ddq, id + j, type);
+			xfs_dquot_repair(mp, &dqb[j], id + j, type);
 
 		/*
 		 * Reset type in case we are reusing group quota file for
-- 
1.8.3.1


