Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECDBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbiLaBhl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbiLaBhk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:37:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8781413DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:37:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D490B81E0A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45B7C433EF;
        Sat, 31 Dec 2022 01:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450657;
        bh=C+07sLL0iNegsrDqDalCtM5J4ztIBnQwmGebMiPaR9w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EVrPNIpQodF6Qiffh1TBDJ9zrLbPpF7+LRrX6l8d66Ld+qrM/fCml1HULGdn6B/aq
         ICyZB5yQ08PoP8VLk3qWzRtEXqEJwtYesafebko1JC9QrR5lsX5aswhuJinOxLXMC9
         kikqEdhIPN4FcH5jjWfuN3PJtuirbGg+JRFodsR1LTo0JegcHCDbISFoD71NQPz/uV
         9+P7Tj8anKAcjFt7Vytx8Ju7XZQoohLUz9trc5H0Q+qsUZ3bTrW6LMLmgimK5jWJnf
         17O2obpeA6ngt5AAVOWBErz0DhwbyiLr1nkT+v09/W6NzYP8u9Q5mtINjIC/1Fu2Qf
         nIjn0rKiVdGbA==
Subject: [PATCH 03/38] xfs: introduce realtime rmap btree definitions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:16 -0800
Message-ID: <167243869642.715303.17832303961247536911.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_btree.h  |    1 +
 fs/xfs/libxfs/xfs_format.h |    7 +++++++
 fs/xfs/libxfs/xfs_types.h  |    5 +++--
 fs/xfs/scrub/trace.h       |    1 +
 fs/xfs/xfs_trace.h         |    1 +
 5 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 125f45731a54..ddaad83d4ff9 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -64,6 +64,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 #define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
+#define	XFS_BTNUM_RTRMAP ((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e4f3b2c5c054..b2d4ef28a480 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index d37f8a7ce5f8..e6a4f4a7d009 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 9a51eb404fae..cf1635e00cb0 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -42,6 +42,7 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RCBAGi);
+TRACE_DEFINE_ENUM(XFS_BTNUM_RTRMAPi);
 
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6bf7c2aa8e9d..390aa7a4afae 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2555,6 +2555,7 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RCBAGi);
+TRACE_DEFINE_ENUM(XFS_BTNUM_RTRMAPi);
 
 DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),

