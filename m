Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBF2C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347381AbiDNW5R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347377AbiDNW5Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:57:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92F424F04
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 695B262071
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB30C385A1;
        Thu, 14 Apr 2022 22:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976888;
        bh=6AxkejlYACMtztc3KRobsNKJk2XIQjbvo8ud81pw7K0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CUgA2d/HiWHRNTbLNnAYNvM1lg92Rcz1YlHX45iaIxOz88EiJrLVlV6wCPsFbDqdN
         KfDY3q76wz84cbmPd7/BOC9lPFfLStZ51XG7C57A8t9nSoc+NA2uJ9u1QhOm0HpGQs
         aCF12zi7CKmjZjZGlNticGf7IRdW3M0ZFL8zMQos9k3m++b0f+tnD3HzXshCLGNaK9
         tlh/baWFbZHiLY+4jEgFJrfdfkmujkmHYQKTwheoRR36jdhW/DAlGe9CF+gEx9Tyvr
         cHZy9Bino++IeOUpSUWfLJf7vQSgBL/7qaOIYnHjjPB1EsG3aTh15HHXuEEpSfb9Z+
         nbvTFAmOXb/bQ==
Subject: [PATCH 4/6] xfs: reduce the absurdly large log reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:48 -0700
Message-ID: <164997688838.383881.2386659608282052005.stgit@magnolia>
In-Reply-To: <164997686569.383881.8935566398533700022.stgit@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_trans_resv.c |   88 +++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_trans_resv.h |    6 ++-
 2 files changed, 64 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 12d4e451e70e..8d2f04dddb65 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -814,36 +814,16 @@ xfs_trans_resv_calc(
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
-
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
@@ -900,10 +880,7 @@ xfs_trans_resv_calc(
 	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
-	if (xfs_has_reflink(mp))
-		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
-	else
-		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	/*
@@ -930,8 +907,26 @@ xfs_trans_resv_calc(
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
 
-	/* Put everything back the way it was.  This goes at the end. */
-	mp->m_rmap_maxlevels = rmap_maxlevels;
+	/* Add one logcount for BUI items that appear with rmap or reflink. */
+	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp)) {
+		resp->tr_itruncate.tr_logcount++;
+		resp->tr_write.tr_logcount++;
+		resp->tr_qm_dqalloc.tr_logcount++;
+	}
+
+	/* Add one logcount for refcount intent items. */
+	if (xfs_has_reflink(mp)) {
+		resp->tr_itruncate.tr_logcount++;
+		resp->tr_write.tr_logcount++;
+		resp->tr_qm_dqalloc.tr_logcount++;
+	}
+
+	/* Add one logcount for rmap intent items. */
+	if (xfs_has_rmapbt(mp)) {
+		resp->tr_itruncate.tr_logcount++;
+		resp->tr_write.tr_logcount++;
+		resp->tr_qm_dqalloc.tr_logcount++;
+	}
 }
 
 /*
@@ -943,5 +938,42 @@ xfs_trans_resv_calc_logsize(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
+	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
+
+	ASSERT(resp != M_RES(mp));
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
 	xfs_trans_resv_calc(mp, resp);
+
+	if (xfs_has_reflink(mp)) {
+		/*
+		 * In the early days of reflink we set the logcounts absurdly
+		 * high.
+		 */
+		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
+		resp->tr_itruncate.tr_logcount =
+				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
+		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
+	} else if (xfs_has_rmapbt(mp)) {
+		/*
+		 * In the early days of non-reflink rmap we set the logcount
+		 * too low.
+		 */
+		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
+	}
+
+	/* Put everything back the way it was.  This goes at the end. */
+	mp->m_rmap_maxlevels = rmap_maxlevels;
 }
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 9fa4863f72a4..461859f4a745 100644
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
@@ -83,12 +82,15 @@ struct xfs_trans_resv {
 #define	XFS_LINK_LOG_COUNT		2
 #define	XFS_RENAME_LOG_COUNT		2
 #define	XFS_WRITE_LOG_COUNT		2
-#define	XFS_WRITE_LOG_COUNT_REFLINK	8
 #define	XFS_ADDAFORK_LOG_COUNT		2
 #define	XFS_ATTRINVAL_LOG_COUNT		1
 #define	XFS_ATTRSET_LOG_COUNT		3
 #define	XFS_ATTRRM_LOG_COUNT		3
 
+/* Absurdly high log counts from the early days of reflink.  Do not use. */
+#define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
+#define	XFS_WRITE_LOG_COUNT_REFLINK	8
+
 void xfs_trans_resv_calc_logsize(struct xfs_mount *mp,
 		struct xfs_trans_resv *resp);
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);

