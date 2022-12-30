Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90801C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiLaATr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbiLaATq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:19:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D027E1CFEC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:19:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C3A561D13
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD94EC433D2;
        Sat, 31 Dec 2022 00:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445984;
        bh=7O+uPosiBbp6GEFitENXkYtXHgp+GpLvFNv9eX53JoU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=osDJih3zsXa26XRsOncgUtm/0ddrBVolPgGcYy5gMnHoRWSxNwr3/9y+AVEQ6TS9f
         9MkSblpp7U32wzkCHJQb2zPQ7gHCgxXbzkwR54oXYx1h3rHAA3Y1Moyv2H6VZq+HiY
         YRUKeV2l/rnt8ERZtreCJ6xgeb+FKSDQdCbXUm3RM7KWqvSDdaJ8iVLEvfQXbrMH1e
         H7X3awbnQujhkH1JKjQ/0laG0WsTAIli8NW75DGRaeuAlFKDQpb3s0WKTdG8E7IGLj
         G7+8D+TzrVjLSVUk4T33Y1HP3e41tfKpeQtvFU1ygHLbldte8sISvH1WzQ9p66MHU8
         O4Hb3Pwhr3EvQ==
Subject: [PATCH 04/19] xfs: introduce a swap-extent log intent item
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:59 -0800
Message-ID: <167243867991.713817.2254910847295894692.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Introduce a new intent log item to handle swapping extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_log_format.h |   51 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 367f536d988..b105a5ef664 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -117,8 +117,9 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
-
+#define XLOG_REG_TYPE_SXI_FORMAT	31
+#define XLOG_REG_TYPE_SXD_FORMAT	32
+#define XLOG_REG_TYPE_MAX		32
 
 /*
  * Flags to log operation header
@@ -243,6 +244,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_BUD		0x1245
 #define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
 #define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
+#define	XFS_LI_SXI		0x1248  /* extent swap intent */
+#define	XFS_LI_SXD		0x1249  /* extent swap done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -260,7 +263,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
 	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
 	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
-	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }, \
+	{ XFS_LI_SXI,		"XFS_LI_SXI" }, \
+	{ XFS_LI_SXD,		"XFS_LI_SXD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -871,6 +876,46 @@ struct xfs_bud_log_format {
 	uint64_t		bud_bui_id;	/* id of corresponding bui */
 };
 
+/*
+ * SXI/SXD (extent swapping) log format definitions
+ */
+
+struct xfs_swap_extent {
+	uint64_t		sx_inode1;
+	uint64_t		sx_inode2;
+	uint64_t		sx_startoff1;
+	uint64_t		sx_startoff2;
+	uint64_t		sx_blockcount;
+	uint64_t		sx_flags;
+	int64_t			sx_isize1;
+	int64_t			sx_isize2;
+};
+
+#define XFS_SWAP_EXT_FLAGS		(0)
+
+#define XFS_SWAP_EXT_STRINGS
+
+/* This is the structure used to lay out an sxi log item in the log. */
+struct xfs_sxi_log_format {
+	uint16_t		sxi_type;	/* sxi log item type */
+	uint16_t		sxi_size;	/* size of this item */
+	uint32_t		__pad;		/* must be zero */
+	uint64_t		sxi_id;		/* sxi identifier */
+	struct xfs_swap_extent	sxi_extent;	/* extent to swap */
+};
+
+/*
+ * This is the structure used to lay out an sxd log item in the
+ * log.  The sxd_extents array is a variable size array whose
+ * size is given by sxd_nextents;
+ */
+struct xfs_sxd_log_format {
+	uint16_t		sxd_type;	/* sxd log item type */
+	uint16_t		sxd_size;	/* size of this item */
+	uint32_t		__pad;
+	uint64_t		sxd_sxi_id;	/* id of corresponding bui */
+};
+
 /*
  * Dquot Log format definitions.
  *

