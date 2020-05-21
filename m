Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15097C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E738720756
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgEUCft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 22:35:49 -0400
Received: from sandeen.net ([63.231.237.45]:41448 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgEUCfs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 22:35:48 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 02BB2323C1C; Wed, 20 May 2020 21:35:20 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: pass xfs_dquot to xfs_qm_adjust_dqtimers
Date:   Wed, 20 May 2020 21:35:15 -0500
Message-Id: <1590028518-6043-5-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Pass xfs_dquot rather than xfs_disk_dquot to xfs_qm_adjust_dqtimers;
this makes it symmetric with xfs_qm_adjust_dqlimits and will help
the next patch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c       | 3 ++-
 fs/xfs/xfs_dquot.h       | 2 +-
 fs/xfs/xfs_qm.c          | 2 +-
 fs/xfs/xfs_qm_syscalls.c | 2 +-
 fs/xfs/xfs_trans_dquot.c | 2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 55b95d4..714ecea 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -114,8 +114,9 @@
 void
 xfs_qm_adjust_dqtimers(
 	struct xfs_mount	*mp,
-	struct xfs_disk_dquot	*d)
+	struct xfs_dquot	*dq)
 {
+	struct xfs_disk_dquot	*d = &dq->q_core;
 	ASSERT(d->d_id);
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index fe3e46d..71e36c8 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -154,7 +154,7 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
-						struct xfs_disk_dquot *d);
+						struct xfs_dquot *d);
 void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
 						struct xfs_dquot *d);
 xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 27a9076..6609b4b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1117,7 +1117,7 @@ struct xfs_qm_isolate {
 	 */
 	if (dqp->q_core.d_id) {
 		xfs_qm_adjust_dqlimits(mp, dqp);
-		xfs_qm_adjust_dqtimers(mp, &dqp->q_core);
+		xfs_qm_adjust_dqtimers(mp, dqp);
 	}
 
 	dqp->dq_flags |= XFS_DQ_DIRTY;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 9edf761e..bd0f005 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -588,7 +588,7 @@
 		 * is on or off. We don't really want to bother with iterating
 		 * over all ondisk dquots and turning the timers on/off.
 		 */
-		xfs_qm_adjust_dqtimers(mp, ddq);
+		xfs_qm_adjust_dqtimers(mp, dqp);
 	}
 	dqp->dq_flags |= XFS_DQ_DIRTY;
 	xfs_trans_log_dquot(tp, dqp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2c07897..2054207 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -388,7 +388,7 @@
 			 */
 			if (d->d_id) {
 				xfs_qm_adjust_dqlimits(tp->t_mountp, dqp);
-				xfs_qm_adjust_dqtimers(tp->t_mountp, d);
+				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
 			}
 
 			dqp->dq_flags |= XFS_DQ_DIRTY;
-- 
1.8.3.1

