Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010F9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiLaCy1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:54:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D25B19023
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:54:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C6B61C11
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1ACC433EF;
        Sat, 31 Dec 2022 02:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455265;
        bh=4e35lsQbJLe6BXuSetkE5qBlgcP4P0I2OoEBOJlwS0E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AsOSXruiKEzxSMG3P09xHk55e0TxLsP/+4rMUpm4s1lNwMyOorOQjwozOEP9C4o7y
         XBxlgnLchR8mSSBG7ogM3G6o+T3U1hOx4fLtey6SePLNnLZhOEh/L1vrp0xzD7qeKt
         oghUAyucoq8t1bvpnfdTX8GbMb0BZNy+CYw5RoUbrQuSwkOkEoy0FxFQ+fUKR/Tfm/
         X1BqZKVmhxipBLXaipIqcrXuE3AaOYZyspTCx3YqK0tEsbz3VYYCNS8oaBIgOaIxkr
         y5dQwkZcde4dwWF/wLGUT+LUjoA0qFl4VfcsUh0B4wA7AyJlZDg0rLBTtW4ufGYjQK
         Rt7vTqnwdtkkg==
Subject: [PATCH 01/41] xfs: introduce realtime refcount btree definitions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:07 -0800
Message-ID: <167243880783.734096.6960877986905380138.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add new realtime refcount btree definitions. The realtime refcount btree
will be rooted from a hidden inode, but has its own shape and therefore
needs to have most of its own separate types.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.h  |    1 +
 libxfs/xfs_format.h |    6 ++++++
 libxfs/xfs_types.h  |    5 +++--
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 1d8656ca112..48dbb681cf3 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -65,6 +65,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 #define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
 #define	XFS_BTNUM_RTRMAP ((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
+#define	XFS_BTNUM_RTREFC ((xfs_btnum_t)XFS_BTNUM_RTREFCi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index a2b8d8ee8af..c78fe8e78b8 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1796,6 +1796,12 @@ struct xfs_refcount_key {
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
 
+/*
+ * Realtime Reference Count btree format definitions
+ *
+ * This is a btree for reference count records for realtime volumes
+ */
+#define	XFS_RTREFC_CRC_MAGIC	0x52434e54	/* 'RCNT' */
 
 /*
  * BMAP Btree format definitions
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index e6a4f4a7d00..92c60a9d586 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -126,7 +126,7 @@ typedef enum {
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_RCBAGi,
-	XFS_BTNUM_RTRMAPi, XFS_BTNUM_MAX
+	XFS_BTNUM_RTRMAPi, XFS_BTNUM_RTREFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 #define XFS_BTNUM_STRINGS \
@@ -138,7 +138,8 @@ typedef enum {
 	{ XFS_BTNUM_FINOi,	"finobt" }, \
 	{ XFS_BTNUM_REFCi,	"refcbt" }, \
 	{ XFS_BTNUM_RCBAGi,	"rcbagbt" }, \
-	{ XFS_BTNUM_RTRMAPi,	"rtrmapbt" }
+	{ XFS_BTNUM_RTRMAPi,	"rtrmapbt" }, \
+	{ XFS_BTNUM_RTREFCi,	"rtrefcbt" }
 
 struct xfs_name {
 	const unsigned char	*name;

