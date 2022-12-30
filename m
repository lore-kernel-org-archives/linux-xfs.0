Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B977FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiLaCL5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:11:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA3C1C906
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58B2661CFF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAB1C433D2;
        Sat, 31 Dec 2022 02:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452713;
        bh=uC8oE5kFz+MmpvqHE59vBJfKsB6Nf/7NtuspXMf/2PI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JHTiQexG9eZkT4bcPgbOFSpHh5CHJGwcAF2Y2PMWVoF4cllCACYFlfLq7WVdUG7yf
         YLgrG8jWySXMgVZdEXUvjg+UgVQwVT+X1CsELdg75Tyzh0kZUylqYY/AcqA+S+2cYC
         JbdHZmyvnjkoyBpwiBQ9JEqBpJW3VAY3cNXdTazVDuEc9rVFEhUS+ToQ36i0CcCpu+
         9rlI1276+g2j8RQ8vJC9t/Y2vnzWJ4xvKCz6rBJYy7VxXnIX/GswE4B3C0bz+vKwfr
         B6/clih0dpwD61uNDfRA+1LQM5XQGnzONTnKXQh21p67+gcKoepNDhjXzu+pcoUj4m
         VFyu5dr/YTvdg==
Subject: [PATCH 08/46] xfs: update imeta transaction reservations for metadir
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876044.725900.3184303855604686427.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
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
 libxfs/xfs_log_rlimit.c |    9 ++++++
 libxfs/xfs_trans_resv.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index cba24493f86..84ebdbddd0a 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
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
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 00bdcb1d550..67008bb4b72 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -908,6 +908,56 @@ xfs_calc_sb_reservation(
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
@@ -1026,6 +1076,20 @@ xfs_trans_resv_calc(
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

