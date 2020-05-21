Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60501C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A3E820709
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgEUCft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 22:35:49 -0400
Received: from sandeen.net ([63.231.237.45]:41450 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgEUCft (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 22:35:49 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 2129C328A00; Wed, 20 May 2020 21:35:20 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: switch xfs_get_defquota to take explicit type
Date:   Wed, 20 May 2020 21:35:16 -0500
Message-Id: <1590028518-6043-6-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_get_defquota() currently takes an xfs_dquot, and from that obtains
the type of default quota we should get (user/group/project).

But early in init, we don't have access to a fully set up quota, so
that's not possible.  The next patch needs go set up default quota
timers early, so switch xfs_get_defquota to take an explicit type
and add a helper function to obtain that type from an xfs_dquot
for the existing callers.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_dquot.c       |  2 +-
 fs/xfs/xfs_qm.c          |  2 +-
 fs/xfs/xfs_qm.h          | 28 +++++++++++++++++++++++-----
 fs/xfs/xfs_qm_syscalls.c |  2 +-
 fs/xfs/xfs_trans_dquot.c |  2 +-
 5 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 714ecea..6196f7c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -75,7 +75,7 @@
 	int			prealloc = 0;
 
 	ASSERT(d->d_id);
-	defq = xfs_get_defquota(dq, q);
+	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
 
 	if (defq->bsoftlimit && !d->d_blk_softlimit) {
 		d->d_blk_softlimit = cpu_to_be64(defq->bsoftlimit);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6609b4b..ac0b5e7f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -558,7 +558,7 @@ struct xfs_qm_isolate {
 		return;
 
 	ddqp = &dqp->q_core;
-	defq = xfs_get_defquota(dqp, qinf);
+	defq = xfs_get_defquota(qinf, xfs_dquot_type(dqp));
 
 	/*
 	 * Timers and warnings have been already set, let's just set the
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 3a85040..06df406 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -113,6 +113,19 @@ struct xfs_quotainfo {
 	return NULL;
 }
 
+static inline int
+xfs_dquot_type(struct xfs_dquot *dqp)
+{
+	if (XFS_QM_ISUDQ(dqp))
+		return XFS_DQ_USER;
+	else if (XFS_QM_ISGDQ(dqp))
+		return XFS_DQ_GROUP;
+	else {
+		ASSERT(XFS_QM_ISPDQ(dqp));
+		return XFS_DQ_PROJ;
+	}
+}
+
 extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
 				    uint field, int64_t delta);
 extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
@@ -164,17 +177,22 @@ extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
 extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
 
 static inline struct xfs_def_quota *
-xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
+xfs_get_defquota(struct xfs_quotainfo *qi, int type)
 {
 	struct xfs_def_quota *defq;
 
-	if (XFS_QM_ISUDQ(dqp))
+	switch (type) {
+	case XFS_DQ_USER:
 		defq = &qi->qi_usr_default;
-	else if (XFS_QM_ISGDQ(dqp))
+		break;
+	case XFS_DQ_GROUP:
 		defq = &qi->qi_grp_default;
-	else {
-		ASSERT(XFS_QM_ISPDQ(dqp));
+		break;
+	case XFS_DQ_PROJ:
 		defq = &qi->qi_prj_default;
+		break;
+	default:
+		ASSERT(0);
 	}
 	return defq;
 }
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index bd0f005..6fa08ae 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -479,7 +479,7 @@
 		goto out_unlock;
 	}
 
-	defq = xfs_get_defquota(dqp, q);
+	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
 	xfs_dqunlock(dqp);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2054207..edde366 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -591,7 +591,7 @@
 
 	xfs_dqlock(dqp);
 
-	defq = xfs_get_defquota(dqp, q);
+	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
 
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
 		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
-- 
1.8.3.1

