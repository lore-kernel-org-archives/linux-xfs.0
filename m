Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35682 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbeEDReF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 13:34:05 -0400
Subject: [PATCH 1/5] xfs: remove unused flags arg from xfs_dquot_verify
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4b1f5e0b-820f-6de0-cd85-4a258666fba4@sandeen.net>
Date: Fri, 4 May 2018 12:34:03 -0500
MIME-Version: 1.0
In-Reply-To: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Long ago the flags argument was used to determine whether to issue warnings
about corruptions, but that's done elsewhere now and the flag is unused
here, so remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  | 5 ++---
 fs/xfs/libxfs/xfs_quota_defs.h | 3 +--
 fs/xfs/xfs_dquot.c             | 2 +-
 fs/xfs/xfs_log_recover.c       | 4 ++--
 fs/xfs/xfs_qm.c                | 2 +-
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 8b7a6c3cb599..a926058f7b0c 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -47,8 +47,7 @@ xfs_dquot_verify(
 	struct xfs_mount *mp,
 	xfs_disk_dquot_t *ddq,
 	xfs_dqid_t	 id,
-	uint		 type,	  /* used only when IO_dorepair is true */
-	uint		 flags)
+	uint		 type)	  /* used only when IO_dorepair is true */
 {
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
@@ -200,7 +199,7 @@ xfs_dquot_buf_verify(
 		if (i == 0)
 			id = be32_to_cpu(ddq->d_id);
 
-		fa = xfs_dquot_verify(mp, ddq, id + i, 0, 0);
+		fa = xfs_dquot_verify(mp, ddq, id + i, 0);
 		if (fa)
 			return fa;
 	}
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index bb1b13a9b5f4..8433656af0da 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -152,8 +152,7 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
 extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
-		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type,
-		uint flags);
+		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_disk_dquot *ddq,
 		xfs_dqid_t id, uint type);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a7daef9e16bf..8d378f485260 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1001,7 +1001,7 @@ xfs_qm_dqflush(
 	/*
 	 * A simple sanity check in case we got a corrupted dquot..
 	 */
-	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0, 0);
+	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
 				be32_to_cpu(ddqp->d_id), fa);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2b2383f1895e..06a09cb948b5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2702,7 +2702,7 @@ xlog_recover_do_reg_buffer(
 				goto next;
 			}
 			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
-					       -1, 0, 0);
+					       -1, 0);
 			if (fa) {
 				xfs_alert(mp,
 	"dquot corrupt at %pS trying to replay into block 0x%llx",
@@ -3348,7 +3348,7 @@ xlog_recover_dquot_pass2(
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0, 0);
+	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec39ae274c78..c71ad79bb2e6 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -865,7 +865,7 @@ xfs_qm_reset_dqcounts(
 		 * find uninitialised dquot blks. See comment in
 		 * xfs_dquot_verify.
 		 */
-		fa = xfs_dquot_verify(mp, ddq, id + j, type, 0);
+		fa = xfs_dquot_verify(mp, ddq, id + j, type);
 		if (fa)
 			xfs_dquot_repair(mp, ddq, id + j, type);
 
-- 
2.17.0


