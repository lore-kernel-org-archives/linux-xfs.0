Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AAEC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBPUda (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBPUda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:33:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A395F7288
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 470A460AB9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8736C433EF;
        Thu, 16 Feb 2023 20:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579607;
        bh=1EdUW1nDJ8piaVeb4s0J1VgmztjJUps3uGVIIaIA/oM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oxIke+tX9PQIXPvLKVZPcL9+RIC+XcGvR6TcjI6YIJQ4hb7GR+asy3K+51k6GhOxj
         mxI1W+ExFC7wbEjzAZY89ejFZ08i9w4S5Vq560sZlnfAhS5rzdQp7ZjbVMnBr6Pf5b
         BIDJYRsXWhiaoWHCpjOJSeIlIypJYept3XC/YWMqxP02uWVeAJaFW7gBei/YYroZ28
         l36Y1gwqyvzEIbAVJcAFjHaqsX7NnWq0Ypgw9mEku1tqPXT7F21+a0eV6vNctQw2X5
         IqLBw3KVx1z2NWYBSqigWanZWfbo9DZlHRcYUtOLfsmQF2ncKoGKZi3cGhedltMhiF
         7+grjoAQCWNdA==
Date:   Thu, 16 Feb 2023 12:33:27 -0800
Subject: [PATCH 03/28] xfs: Increase XFS_QM_TRANS_MAXDQS to 5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657872409.3473407.17009064808697145467.stgit@magnolia>
In-Reply-To: <167657872335.3473407.14628732092515467392.stgit@magnolia>
References: <167657872335.3473407.14628732092515467392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

With parent pointers enabled, a rename operation can update up to 5
inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
their dquots to a be attached to the transaction chain, so we need
to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
function xfs_dqlockn to lock an arbitrary number of dquots.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   38 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h       |    1 +
 fs/xfs/xfs_qm.h          |    2 +-
 fs/xfs/xfs_trans_dquot.c |   15 ++++++++++-----
 4 files changed, 50 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8fb90da89787..9f311729c4c8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1333,6 +1333,44 @@ xfs_dqlock2(
 	}
 }
 
+static int
+xfs_dqtrx_cmp(
+	const void		*a,
+	const void		*b)
+{
+	const struct xfs_dqtrx	*qa = a;
+	const struct xfs_dqtrx	*qb = b;
+
+	if (qa->qt_dquot->q_id > qb->qt_dquot->q_id)
+		return 1;
+	if (qa->qt_dquot->q_id < qb->qt_dquot->q_id)
+		return -1;
+	return 0;
+}
+
+void
+xfs_dqlockn(
+	struct xfs_dqtrx	*q)
+{
+	unsigned int		i;
+
+	/* Sort in order of dquot id, do not allow duplicates */
+	for (i = 0; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++) {
+		unsigned int	j;
+
+		for (j = 0; j < i; j++)
+			ASSERT(q[i].qt_dquot != q[j].qt_dquot);
+	}
+	if (i == 0)
+		return;
+
+	sort(q, i, sizeof(struct xfs_dqtrx), xfs_dqtrx_cmp, NULL);
+
+	mutex_lock(&q[0].qt_dquot->q_qlock);
+	for (i = 1; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++)
+		mutex_lock_nested(&q[i].qt_dquot->q_qlock, XFS_QLOCK_NESTED);
+}
+
 int __init
 xfs_qm_init(void)
 {
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 80c8f851a2f3..dc7d0226242b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -223,6 +223,7 @@ int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
 void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void		xfs_dqlockn(struct xfs_dqtrx *q);
 
 void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 9683f0457d19..c6ec88779356 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -120,7 +120,7 @@ enum {
 	XFS_QM_TRANS_PRJ,
 	XFS_QM_TRANS_DQTYPES
 };
-#define XFS_QM_TRANS_MAXDQS		2
+#define XFS_QM_TRANS_MAXDQS		5
 struct xfs_dquot_acct {
 	struct xfs_dqtrx	dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
 };
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index aa00cf67ad72..8a48175ea3a7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -268,24 +268,29 @@ xfs_trans_mod_dquot(
 
 /*
  * Given an array of dqtrx structures, lock all the dquots associated and join
- * them to the transaction, provided they have been modified.  We know that the
- * highest number of dquots of one type - usr, grp and prj - involved in a
- * transaction is 3 so we don't need to make this very generic.
+ * them to the transaction, provided they have been modified.
  */
 STATIC void
 xfs_trans_dqlockedjoin(
 	struct xfs_trans	*tp,
 	struct xfs_dqtrx	*q)
 {
+	unsigned int		i;
 	ASSERT(q[0].qt_dquot != NULL);
 	if (q[1].qt_dquot == NULL) {
 		xfs_dqlock(q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
-	} else {
-		ASSERT(XFS_QM_TRANS_MAXDQS == 2);
+	} else if (q[2].qt_dquot == NULL) {
 		xfs_dqlock2(q[0].qt_dquot, q[1].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[1].qt_dquot);
+	} else {
+		xfs_dqlockn(q);
+		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
+			if (q[i].qt_dquot == NULL)
+				break;
+			xfs_trans_dqjoin(tp, q[i].qt_dquot);
+		}
 	}
 }
 

