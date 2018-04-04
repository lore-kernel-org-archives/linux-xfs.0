Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbeDDStK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 14:49:10 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE12D81127
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 18:49:10 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1B1A9D99E
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 18:49:10 +0000 (UTC)
Subject: [PATCH 1/6] xfs: remove unused flags arg from xfs_dquot_verify
From: Eric Sandeen <sandeen@redhat.com>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Message-ID: <51e940bc-9bcd-0fe6-ac90-003eae7e24f0@redhat.com>
Date: Wed, 4 Apr 2018 13:49:09 -0500
MIME-Version: 1.0
In-Reply-To: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Long ago the flags argument was used to determine whether
to issue warnings about corruptions, but that's done elsewhere
now and the flag is unused here, so remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  | 5 ++---
 fs/xfs/libxfs/xfs_quota_defs.h | 3 +--
 fs/xfs/xfs_dquot.c             | 2 +-
 fs/xfs/xfs_log_recover.c       | 4 ++--
 fs/xfs/xfs_qm.c                | 2 +-
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 8b7a6c3..a926058 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -47,8 +47,7 @@
 	struct xfs_mount *mp,
 	xfs_disk_dquot_t *ddq,
 	xfs_dqid_t	 id,
-	uint		 type,	  /* used only when IO_dorepair is true */
-	uint		 flags)
+	uint		 type)	  /* used only when IO_dorepair is true */
 {
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
@@ -200,7 +199,7 @@
 		if (i == 0)
 			id = be32_to_cpu(ddq->d_id);
 
-		fa = xfs_dquot_verify(mp, ddq, id + i, 0, 0);
+		fa = xfs_dquot_verify(mp, ddq, id + i, 0);
 		if (fa)
 			return fa;
 	}
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index bb1b13a..8433656 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -152,8 +152,7 @@
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
 extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
-		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type,
-		uint flags);
+		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_disk_dquot *ddq,
 		xfs_dqid_t id, uint type);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 43572f8..7e203f9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1003,7 +1003,7 @@
 	/*
 	 * A simple sanity check in case we got a corrupted dquot..
 	 */
-	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0, 0);
+	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
 				be32_to_cpu(ddqp->d_id), fa);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 00240c9..3b35feb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2702,7 +2702,7 @@ struct xfs_buf_cancel {
 				goto next;
 			}
 			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
-					       -1, 0, 0);
+					       -1, 0);
 			if (fa) {
 				xfs_alert(mp,
 	"dquot corrupt at %pS trying to replay into block 0x%llx",
@@ -3353,7 +3353,7 @@ struct xfs_buf_cancel {
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0, 0);
+	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5b848f4..64c22c32 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -867,7 +867,7 @@ struct xfs_qm_isolate {
 		 * find uninitialised dquot blks. See comment in
 		 * xfs_dquot_verify.
 		 */
-		fa = xfs_dquot_verify(mp, ddq, id + j, type, 0);
+		fa = xfs_dquot_verify(mp, ddq, id + j, type);
 		if (fa)
 			xfs_dquot_repair(mp, ddq, id + j, type);
 
-- 
1.8.3.1

