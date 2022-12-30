Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACFAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiLaCnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236191AbiLaCnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:43:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515BE2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:43:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1F6DCE1A8E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C78EC433EF;
        Sat, 31 Dec 2022 02:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454581;
        bh=Iwg1LFcYAUErKLO2xTGSk6OiCneK/Fzmkze3Mr8PHCI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jys/w7sfUvAhbg/yFUP0kHBdsYWEOoo59Rv+DTW+3TRU0W2IgwDi2B4FdGuFWfJyf
         yihiS8pY1hKm4vkqiFcgn81d4lpCHabXl/qpCTa4LgOISTXdG5OJRMGQNRVfvXVY2K
         +u3hBnVuIKKf+xpVUNgbQtoSsUwcoMN4D6CGCn4OKfHHBCBOOHe2cVxBbCySjVg+Ua
         e0AlCgYeuSENypeO7c83MOO6kj2P4nS9bi1Z3Uv3vtvdsjS+Ym87pk7Tert2HoZkuO
         WTz5mFmjfAktvOa3klV7fdVZEVPDiUwOLnZvsGLmgrdVt9NQRib0K6TAlDYiNrKcXS
         Z4QV5CjchJvDA==
Subject: [PATCH 02/41] xfs: introduce realtime rmap btree definitions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:56 -0800
Message-ID: <167243879620.732820.15052983975141259462.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add new realtime rmap btree definitions. The realtime rmap btree will
be rooted from a hidden inode, but has its own shape and therefore
needs to have most of its own separate types.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.h  |    1 +
 libxfs/xfs_format.h |    7 +++++++
 libxfs/xfs_types.h  |    5 +++--
 3 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 6ded5af94b3..72fd341eccd 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -64,6 +64,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 #define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
+#define	XFS_BTNUM_RTRMAP ((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index e4f3b2c5c05..b2d4ef28a48 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1727,6 +1727,13 @@ typedef __be32 xfs_rmap_ptr_t;
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
+/*
+ * Realtime Reverse mapping btree format definitions
+ *
+ * This is a btree for reverse mapping records for realtime volumes
+ */
+#define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
+
 /*
  * Reference Count Btree format definitions
  *
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index d37f8a7ce5f..e6a4f4a7d00 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -126,7 +126,7 @@ typedef enum {
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_RCBAGi,
-	XFS_BTNUM_MAX
+	XFS_BTNUM_RTRMAPi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 #define XFS_BTNUM_STRINGS \
@@ -137,7 +137,8 @@ typedef enum {
 	{ XFS_BTNUM_INOi,	"inobt" }, \
 	{ XFS_BTNUM_FINOi,	"finobt" }, \
 	{ XFS_BTNUM_REFCi,	"refcbt" }, \
-	{ XFS_BTNUM_RCBAGi,	"rcbagbt" }
+	{ XFS_BTNUM_RCBAGi,	"rcbagbt" }, \
+	{ XFS_BTNUM_RTRMAPi,	"rtrmapbt" }
 
 struct xfs_name {
 	const unsigned char	*name;

