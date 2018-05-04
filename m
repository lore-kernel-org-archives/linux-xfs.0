Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35730 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbeEDReu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 13:34:50 -0400
Subject: [PATCH 3/5] xfs: repair full xfs_dqblk during quotacheck
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b4796b08-5a1b-c541-395e-3450aecae29b@sandeen.net>
Date: Fri, 4 May 2018 12:34:49 -0500
MIME-Version: 1.0
In-Reply-To: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

It's a bit dicey to pass in the smaller xfs_disk_dquot and then cast it to
something larger; pass in the full xfs_dqblk so we know the caller has sent
us the right thing.  Rename the function to xfs_dqblk_repair for
clarity.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  | 21 +++++++++------------
 fs/xfs/libxfs/xfs_quota_defs.h |  2 +-
 fs/xfs/xfs_qm.c                |  2 +-
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index c00174f32f0d..3b92427883fa 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -104,29 +104,26 @@ xfs_dquot_verify(
  * Do some primitive error checking on ondisk dquot data structures.
  */
 int
-xfs_dquot_repair(
+xfs_dqblk_repair(
 	struct xfs_mount	*mp,
-	struct xfs_disk_dquot	*ddq,
+	struct xfs_dqblk	*dqb,
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
+	memset(dqb, 0, sizeof(xfs_dqblk_t));
 
-	d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
-	d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
-	d->dd_diskdq.d_flags = type;
-	d->dd_diskdq.d_id = cpu_to_be32(id);
+	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
+	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
+	dqb->dd_diskdq.d_flags = type;
+	dqb->dd_diskdq.d_id = cpu_to_be32(id);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
-		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
+		uuid_copy(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid);
+		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 8433656af0da..a2f8cb334bb3 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -154,7 +154,7 @@ typedef uint16_t	xfs_qwarncnt_t;
 extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
 		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
-extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_disk_dquot *ddq,
+extern int xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, uint type);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c71ad79bb2e6..6690b938d450 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -867,7 +867,7 @@ xfs_qm_reset_dqcounts(
 		 */
 		fa = xfs_dquot_verify(mp, ddq, id + j, type);
 		if (fa)
-			xfs_dquot_repair(mp, ddq, id + j, type);
+			xfs_dqblk_repair(mp, &dqb[j], id + j, type);
 
 		/*
 		 * Reset type in case we are reusing group quota file for
-- 
2.17.0

