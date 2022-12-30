Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F201C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbiLaBM3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiLaBM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:12:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368E316588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:12:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6C4961D5C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3470EC433EF;
        Sat, 31 Dec 2022 01:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449145;
        bh=278pFZsnFbKdtUss2DJsj16OG4ZbnlFMhvpLA76A26Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VbYUJDLOwwSJ2vE31peCbrOEpNjcYS05w2G42I9o8vfbxEBp+wY5eK/P0T165nrRE
         jgbomvzC4FjMqg3hiL2YKNxM8Hk7zJijcGYWqnRfLgFJfj2t3by3Oa7DWdX3JZKrYu
         6aOLAtSPnBjOSVGmouNWFp41fngXax1P0YsjKzEpMkKsip3VrOmqHAH4bmqgzQS85F
         6r16poUPSwIeaICgagNLPE4OyA6I+ixJ8sFZqPuYMjJ/Kvu8Ji5unD0pWzL4WlMSr4
         DXtca2pEgLDMJxYv7w34IWnZXk1y+QmqYPzCrisq9YUt7hvdEuP18V7h0juk+/hjlv
         DHXlR1sQY1afw==
Subject: [PATCH 08/23] xfs: update imeta transaction reservations for metadir
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864570.708110.5651381327143623067.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the new metadata inode transaction reservations to handle
metadata directories if that feature is enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |    9 +++++
 fs/xfs/libxfs/xfs_trans_resv.c |   68 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412..a7ad8fe5dab9 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -48,6 +48,15 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * The metadata directory tree feature drops the oversized minimum log
+	 * size computations introduced by the original reflink code.
+	 */
+	if (xfs_has_metadir(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d2716184bd8f..08d5d6e7f554 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -909,6 +909,56 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
+/*
+ * Metadata inode creation needs enough space to create or mkdir a directory,
+ * plus logging the superblock.
+ */
+static unsigned int
+xfs_calc_imeta_create_resv(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret;
+
+	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+	ret += resp->tr_create.tr_logres;
+	return ret;
+}
+
+/* Metadata inode creation needs enough rounds to create or mkdir a directory */
+static int
+xfs_calc_imeta_create_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	return resp->tr_create.tr_logcount;
+}
+
+/*
+ * Metadata inode unlink needs enough space to remove a file plus logging the
+ * superblock.
+ */
+static unsigned int
+xfs_calc_imeta_unlink_resv(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret;
+
+	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+	ret += resp->tr_remove.tr_logres;
+	return ret;
+}
+
+/* Metadata inode creation needs enough rounds to remove a file. */
+static int
+xfs_calc_imeta_unlink_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	return resp->tr_remove.tr_logcount;
+}
+
 void
 xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
@@ -1027,6 +1077,20 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;
 
 	/* metadata inode creation and unlink */
-	resp->tr_imeta_create = resp->tr_create;
-	resp->tr_imeta_unlink = resp->tr_remove;
+	if (xfs_has_metadir(mp)) {
+		resp->tr_imeta_create.tr_logres =
+				xfs_calc_imeta_create_resv(mp, resp);
+		resp->tr_imeta_create.tr_logcount =
+				xfs_calc_imeta_create_count(mp, resp);
+		resp->tr_imeta_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+		resp->tr_imeta_unlink.tr_logres =
+				xfs_calc_imeta_unlink_resv(mp, resp);
+		resp->tr_imeta_unlink.tr_logcount =
+				xfs_calc_imeta_unlink_count(mp, resp);
+		resp->tr_imeta_unlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	} else {
+		resp->tr_imeta_create = resp->tr_create;
+		resp->tr_imeta_unlink = resp->tr_remove;
+	}
 }

