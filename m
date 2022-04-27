Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFE8C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356547AbiD0Azh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356541AbiD0Azh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B059D13DC5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:52:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DE0B61B03
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931BCC385A4;
        Wed, 27 Apr 2022 00:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020746;
        bh=ByoyYjVEGSAEk9m77UCxTXPfxLjkE/qZxecC2NTp/js=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hhaLIvGc5YKmPC7bgdeqLipjqvDJlcNH1x4Hc4H/jjITSICk3DjWZxgIF130zW+V7
         LIoK0FXksX/yLuzmVlX8101tx9sW8l0AyLQm2BioPw/Yn7MWA9dWjIPl83nQNM9ypr
         vhQygfaxKFUTMQXp439On4bZGMQLBskhW7CylK2X7GAOIfr/TCv5qRyClhPhDDOn6g
         EAXtPFuwg0GKsUdHo9swRlacG8EIoSgcZTLppW7z3QKoECDe7jAK94TEm2oPVCukqs
         8kg3cCNXsqGMcpUvv6HtUpKwn08N1IAGHna1H4SiNiItCvvxC+2PyAOeHgJdFntTme
         ngWQrErm9rdEg==
Subject: [PATCH 6/9] xfs: reduce the absurdly large log operation count
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:52:26 -0700
Message-ID: <165102074605.3922658.2732417123514234429.stgit@magnolia>
In-Reply-To: <165102071223.3922658.5241787533081256670.stgit@magnolia>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Back in the early days of reflink and rmap development I set the
transaction reservation sizes to be overly generous for rmap+reflink
filesystems, and a little under-generous for rmap-only filesystems.

Since we don't need *eight* transaction rolls to handle three new log
intent items, decrease the logcounts to what we actually need, and amend
the shadow reservation computation function to reflect what we used to
do so that the minimum log size doesn't change.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   51 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_trans_resv.c |   46 +++++++++++++++---------------------
 fs/xfs/libxfs/xfs_trans_resv.h |   10 ++++++--
 3 files changed, 76 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 1db27c3a1d16..60fff8c6716f 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -37,6 +37,53 @@ xfs_log_calc_max_attrsetm_res(
 		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
 }
 
+/*
+ * Compute an alternate set of log reservation sizes for use exclusively with
+ * minimum log size calculations.
+ */
+static void
+xfs_log_calc_trans_resv_for_minlogblocks(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resv)
+{
+	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
+
+	/*
+	 * In the early days of rmap+reflink, we always set the rmap maxlevels
+	 * to 9 even if the AG was small enough that it would never grow to
+	 * that height.  Transaction reservation sizes influence the minimum
+	 * log size calculation, which influences the size of the log that mkfs
+	 * creates.  Use the old value here to ensure that newly formatted
+	 * small filesystems will mount on older kernels.
+	 */
+	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
+		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
+
+	xfs_trans_resv_calc(mp, resv);
+
+	if (xfs_has_reflink(mp)) {
+		/*
+		 * In the early days of reflink, typical log operation counts
+		 * were greatly overestimated.
+		 */
+		resv->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
+		resv->tr_itruncate.tr_logcount =
+				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
+		resv->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
+	} else if (xfs_has_rmapbt(mp)) {
+		/*
+		 * In the early days of non-reflink rmap, the impact of rmapbt
+		 * updates on log counts were not taken into account at all.
+		 */
+		resv->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+		resv->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+		resv->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
+	}
+
+	/* Put everything back the way it was.  This goes at the end. */
+	mp->m_rmap_maxlevels = rmap_maxlevels;
+}
+
 /*
  * Iterate over the log space reservation table to figure out and return
  * the maximum one in terms of the pre-calculated values which were done
@@ -47,7 +94,7 @@ xfs_log_get_max_trans_res(
 	struct xfs_mount	*mp,
 	struct xfs_trans_res	*max_resp)
 {
-	struct xfs_trans_resv	resv;
+	struct xfs_trans_resv	resv = {};
 	struct xfs_trans_res	*resp;
 	struct xfs_trans_res	*end_resp;
 	unsigned int		i;
@@ -56,7 +103,7 @@ xfs_log_get_max_trans_res(
 
 	attr_space = xfs_log_calc_max_attrsetm_res(mp);
 
-	memcpy(&resv, M_RES(mp), sizeof(struct xfs_trans_resv));
+	xfs_log_calc_trans_resv_for_minlogblocks(mp, &resv);
 
 	resp = (struct xfs_trans_res *)&resv;
 	end_resp = (struct xfs_trans_res *)(&resv + 1);
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 8e1d09e8cc9a..60be82cd491b 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -815,36 +815,18 @@ xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
-	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
-
-	/*
-	 * In the early days of rmap+reflink, we always set the rmap maxlevels
-	 * to 9 even if the AG was small enough that it would never grow to
-	 * that height.  Transaction reservation sizes influence the minimum
-	 * log size calculation, which influences the size of the log that mkfs
-	 * creates.  Use the old value here to ensure that newly formatted
-	 * small filesystems will mount on older kernels.
-	 */
-	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
-		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
+	int			logcount_adj = 0;
 
 	/*
 	 * The following transactions are logged in physical format and
 	 * require a permanent reservation on space.
 	 */
 	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
-	if (xfs_has_reflink(mp))
-		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
-	else
-		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
-	if (xfs_has_reflink(mp))
-		resp->tr_itruncate.tr_logcount =
-				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
-	else
-		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
 	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
@@ -901,10 +883,7 @@ xfs_trans_resv_calc(
 	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
-	if (xfs_has_reflink(mp))
-		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
-	else
-		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	/*
@@ -931,6 +910,19 @@ xfs_trans_resv_calc(
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
 
-	/* Put everything back the way it was.  This goes at the end. */
-	mp->m_rmap_maxlevels = rmap_maxlevels;
+	/*
+	 * Add one logcount for BUI items that appear with rmap or reflink,
+	 * one logcount for refcount intent items, and one logcount for rmap
+	 * intent items.
+	 */
+	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp))
+		logcount_adj++;
+	if (xfs_has_reflink(mp))
+		logcount_adj++;
+	if (xfs_has_rmapbt(mp))
+		logcount_adj++;
+
+	resp->tr_itruncate.tr_logcount += logcount_adj;
+	resp->tr_write.tr_logcount += logcount_adj;
+	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;
 }
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index fc4e9b369a3a..fa330e646dc5 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -73,7 +73,6 @@ struct xfs_trans_resv {
 #define	XFS_DEFAULT_LOG_COUNT		1
 #define	XFS_DEFAULT_PERM_LOG_COUNT	2
 #define	XFS_ITRUNCATE_LOG_COUNT		2
-#define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
 #define XFS_INACTIVE_LOG_COUNT		2
 #define	XFS_CREATE_LOG_COUNT		2
 #define	XFS_CREATE_TMPFILE_LOG_COUNT	2
@@ -83,12 +82,19 @@ struct xfs_trans_resv {
 #define	XFS_LINK_LOG_COUNT		2
 #define	XFS_RENAME_LOG_COUNT		2
 #define	XFS_WRITE_LOG_COUNT		2
-#define	XFS_WRITE_LOG_COUNT_REFLINK	8
 #define	XFS_ADDAFORK_LOG_COUNT		2
 #define	XFS_ATTRINVAL_LOG_COUNT		1
 #define	XFS_ATTRSET_LOG_COUNT		3
 #define	XFS_ATTRRM_LOG_COUNT		3
 
+/*
+ * Original log operation counts were overestimated in the early days of
+ * reflink.  These are retained here purely for minimum log size calculations
+ * and must not be used for runtime reservations.
+ */
+#define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
+#define	XFS_WRITE_LOG_COUNT_REFLINK	8
+
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
 

