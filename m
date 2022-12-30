Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4F1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiL3Xju (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiL3Xjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:39:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9281DF26
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D07661C31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFB6C433EF;
        Fri, 30 Dec 2022 23:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443587;
        bh=WnblG1QGYEpUgZwtGmf9Twwa4k6j2UpyNRWk9+7guYE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=btv5/L8gE28S3QObo+L+wiJvfGmBDZgDOSs2IHn03+rkhJprukBmtmF0AcOySsfxW
         d25yD4L0/tAl5AOQk3WFmv69yUD0WFtxHGmpU4uytuiWuTE9SqmBbQ3ON2Tj106JN+
         VpQCJ1eAvTkSZxZVRmqapD6gOs79FJKXLTnb73CU5iwychrBYszR2y7hIYkTLV1iWA
         KYTuSZPdV/oFySlJKAtIq1+YUfU1qrfVO/8IrIyj/Bn23OcTdC7fFskb5/sIjswZ7W
         whPnxPIQgdcR1SVG+XaZOVIKsYTmS/cq0vgSyD1dKlrdVgeUIZsL+HtvI2470xDRfd
         6lL5MuuwZR7ng==
Subject: [PATCH 1/3] xfs: add secondary and indirect classes to the health
 tracking system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:19 -0800
Message-ID: <167243839929.696295.5390306396779689502.stgit@magnolia>
In-Reply-To: <167243839911.696295.17985265962177375571.stgit@magnolia>
References: <167243839911.696295.17985265962177375571.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Establish two more classes of health tracking bits:

 * Indirect problems, which suggest problems in other health domains
   that we weren't able to preserve.

 * Secondary problems, which track state that's related to primary
   evidence of health problems; and

The first class we'll use in an upcoming patch to record in the AG
health status the fact that we ran out of memory and had to inactivate
an inode with defective metadata.  The second class we use to indicate
that repair knows that an inode is bad and we need to fix it later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_health.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_health.c        |   24 ++++++++++++++++--------
 2 files changed, 58 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index e2e1b95ddfb9..b3733f756bb2 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -31,6 +31,19 @@
  *  - !checked && sick  => errors have been observed during normal operation,
  *                         but the metadata has not been checked thoroughly
  *  - !checked && !sick => has not been examined since mount
+ *
+ * Evidence of health problems can be sorted into three basic categories:
+ *
+ * a) Primary evidence, which signals that something is defective within the
+ *    general grouping of metadata.
+ *
+ * b) Secondary evidence, which are side effects of primary problem but are
+ *    not themselves problems.  These can be forgotten when the primary
+ *    health problems are addressed.
+ *
+ * c) Indirect evidence, which points to something being wrong in another
+ *    group, but we had to release resources and this is all that's left of
+ *    that state.
  */
 
 struct xfs_mount;
@@ -105,6 +118,35 @@ struct xfs_da_args;
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT)
 
+/* Secondary state related to (but not primary evidence of) health problems. */
+#define XFS_SICK_FS_SECONDARY	(0)
+#define XFS_SICK_RT_SECONDARY	(0)
+#define XFS_SICK_AG_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(0)
+
+/* Evidence of health problems elsewhere. */
+#define XFS_SICK_FS_INDIRECT	(0)
+#define XFS_SICK_RT_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_INO_INDIRECT	(0)
+
+/* All health masks. */
+#define XFS_SICK_FS_ALL	(XFS_SICK_FS_PRIMARY | \
+				 XFS_SICK_FS_SECONDARY | \
+				 XFS_SICK_FS_INDIRECT)
+
+#define XFS_SICK_RT_ALL	(XFS_SICK_RT_PRIMARY | \
+				 XFS_SICK_RT_SECONDARY | \
+				 XFS_SICK_RT_INDIRECT)
+
+#define XFS_SICK_AG_ALL	(XFS_SICK_AG_PRIMARY | \
+				 XFS_SICK_AG_SECONDARY | \
+				 XFS_SICK_AG_INDIRECT)
+
+#define XFS_SICK_INO_ALL	(XFS_SICK_INO_PRIMARY | \
+				 XFS_SICK_INO_SECONDARY | \
+				 XFS_SICK_INO_INDIRECT)
+
 /*
  * These functions must be provided by the xfs implementation.  Function
  * behavior with respect to the first argument should be as follows:
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index aef5345804da..e1c7fe898161 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -97,7 +97,7 @@ xfs_fs_mark_sick(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_FS_ALL));
 	trace_xfs_fs_mark_sick(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
@@ -124,11 +124,13 @@ xfs_fs_mark_healthy(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_FS_ALL));
 	trace_xfs_fs_mark_healthy(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_fs_sick &= ~mask;
+	if (!(mp->m_fs_sick & XFS_SICK_FS_PRIMARY))
+		mp->m_fs_sick &= ~XFS_SICK_FS_SECONDARY;
 	mp->m_fs_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -152,7 +154,7 @@ xfs_rt_mark_sick(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
 	trace_xfs_rt_mark_sick(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
@@ -180,11 +182,13 @@ xfs_rt_mark_healthy(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
 	trace_xfs_rt_mark_healthy(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_rt_sick &= ~mask;
+	if (!(mp->m_rt_sick & XFS_SICK_RT_PRIMARY))
+		mp->m_rt_sick &= ~XFS_SICK_RT_SECONDARY;
 	mp->m_rt_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -225,7 +229,7 @@ xfs_ag_mark_sick(
 	struct xfs_perag	*pag,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
 	trace_xfs_ag_mark_sick(pag->pag_mount, pag->pag_agno, mask);
 
 	spin_lock(&pag->pag_state_lock);
@@ -252,11 +256,13 @@ xfs_ag_mark_healthy(
 	struct xfs_perag	*pag,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
 	trace_xfs_ag_mark_healthy(pag->pag_mount, pag->pag_agno, mask);
 
 	spin_lock(&pag->pag_state_lock);
 	pag->pag_sick &= ~mask;
+	if (!(pag->pag_sick & XFS_SICK_AG_PRIMARY))
+		pag->pag_sick &= ~XFS_SICK_AG_SECONDARY;
 	pag->pag_checked |= mask;
 	spin_unlock(&pag->pag_state_lock);
 }
@@ -280,7 +286,7 @@ xfs_inode_mark_sick(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 	trace_xfs_inode_mark_sick(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
@@ -316,11 +322,13 @@ xfs_inode_mark_healthy(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 	trace_xfs_inode_mark_healthy(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
 	ip->i_sick &= ~mask;
+	if (!(ip->i_sick & XFS_SICK_INO_PRIMARY))
+		ip->i_sick &= ~XFS_SICK_INO_SECONDARY;
 	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
 }

