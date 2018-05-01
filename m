Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54700 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752034AbeEAS6r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 14:58:47 -0400
Subject: [PATCH 2/6 V2] xfs: pass xfs_dqblk to
 xfs_dquot_verify/xfs_dquot_repair
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <998fdfcc-45f4-9837-dc2a-288fad08b49d@sandeen.net>
Date: Tue, 1 May 2018 13:58:46 -0500
MIME-Version: 1.0
In-Reply-To: <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

In order to validate the UUID in xfs_dquot_verify, we need the full
xfs_qblk, not just the xfs_disk_dquot_t (which is a subset).
    
Do the same for xfs_dquot_repair, for the same reasons.  Casting a
xfs_disk_dquot to a xfs_qblk is risky if the source pointer wasn't a full
xfs_dqblk, so enforce that by changing the arguments to these functions.
    
In xfs_qm_dqflush we move the memcpy up so that we have a full
(and updated) xfs_dqblk to test.
    
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: rename some variables for clarity, get rid of pointer math in
xfs_dquot_buf_verify_crc

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index a926058..b5c0f3c 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -44,11 +44,13 @@ xfs_calc_dquots_per_chunk(
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
@@ -104,27 +106,24 @@ xfs_dquot_verify(
 int
 xfs_dquot_repair(
 	struct xfs_mount	*mp,
-	struct xfs_disk_dquot	*ddq,
+	struct xfs_dqblk	*dqblk,
 	xfs_dqid_t		id,
 	uint			type)
 {
-	struct xfs_dqblk	*d = (struct xfs_dqblk *)ddq;
-
-
 	/*
 	 * Typically, a repair is only requested by quotacheck.
 	 */
 	ASSERT(id != -1);
-	memset(d, 0, sizeof(xfs_dqblk_t));
+	memset(dqblk, 0, sizeof(xfs_dqblk_t));
 
-	d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
-	d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
-	d->dd_diskdq.d_flags = type;
-	d->dd_diskdq.d_id = cpu_to_be32(id);
+	dqblk->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
+	dqblk->dd_diskdq.d_version = XFS_DQUOT_VERSION;
+	dqblk->dd_diskdq.d_flags = type;
+	dqblk->dd_diskdq.d_id = cpu_to_be32(id);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
-		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
+		uuid_copy(&dqblk->dd_uuid, &mp->m_sb.sb_meta_uuid);
+		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
 
@@ -136,7 +135,7 @@ xfs_dquot_buf_verify_crc(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	struct xfs_dqblk	*dqblks = (struct xfs_dqblk *)bp->b_addr;
 	int			ndquots;
 	int			i;
 
@@ -153,11 +152,11 @@ xfs_dquot_buf_verify_crc(
 	else
 		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
 
-	for (i = 0; i < ndquots; i++, d++) {
-		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
-				 XFS_DQUOT_CRC_OFF))
+	for (i = 0; i < ndquots; i++) {
+		if (!xfs_verify_cksum((char *)&dqblks[i],
+				sizeof(struct xfs_dqblk), XFS_DQUOT_CRC_OFF))
 			return false;
-		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
+		if (!uuid_equal(&dqblks[i].dd_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 	}
 	return true;
@@ -192,14 +191,10 @@ xfs_dquot_buf_verify(
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
@@ -152,9 +152,9 @@ typedef uint16_t	xfs_qwarncnt_t;
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
index 8d378f4..613fbe6 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -953,6 +953,7 @@ xfs_qm_dqflush(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_buf		*bp;
+	struct xfs_dqblk	*dqb;
 	struct xfs_disk_dquot	*ddqp;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -996,12 +997,16 @@ xfs_qm_dqflush(
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
@@ -1011,9 +1016,6 @@ xfs_qm_dqflush(
 		return -EIO;
 	}
 
-	/* This is the only portion of data that needs to persist */
-	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
-
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
 	 */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 06a09cb..d866a59 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3304,6 +3304,7 @@ xlog_recover_dquot_pass2(
 {
 	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
+	struct xfs_dqblk	*dqb;
 	struct xfs_disk_dquot	*ddq, *recddq;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -3317,7 +3318,8 @@ xlog_recover_dquot_pass2(
 	if (mp->m_qflags == 0)
 		return 0;
 
-	recddq = item->ri_buf[1].i_addr;
+	dqb = item->ri_buf[1].i_addr;
+	recddq = &dqb->dd_diskdq;
 	if (recddq == NULL) {
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 		return -EIO;
@@ -3348,7 +3350,7 @@ xlog_recover_dquot_pass2(
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
+	fa = xfs_dquot_verify(mp, dqb, dq_f->qlf_id, 0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c71ad79..7d784d6 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -857,7 +857,7 @@ xfs_qm_reset_dqcounts(
 	for (j = 0; j < mp->m_quotainfo->qi_dqperchunk; j++) {
 		struct xfs_disk_dquot	*ddq;
 
-		ddq = (struct xfs_disk_dquot *)&dqb[j];
+		ddq = &dqb[j].dd_diskdq;
 
 		/*
 		 * Do a sanity check, and if needed, repair the dqblk. Don't
@@ -865,9 +865,9 @@ xfs_qm_reset_dqcounts(
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

