Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F0CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbiLaAQn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiLaAQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:16:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13149E0C6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:16:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7EE11CE1A90
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABBAC433F0;
        Sat, 31 Dec 2022 00:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445797;
        bh=LxOBbYJ58hvIEeCc2oxpgh6b7ZK6cVSuPM6VqKghquo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O8vV7YPSlb7nY/tNnt8yuRQ5/shEr9KoS9yscb3qTCnpw2yMa4qnok3BVPqVCfUUh
         JieFp6KE5+ez5SewpVtXlconpftchV2d9xI19A9wfdWy5q0zgpsdEdCn5gXU3JpFMk
         vq2K1hOIxOscCGJzW3JRuB0I98o5vI4VMJhlLhKq3I3qDYLX8hBzatZ2E/RAI1GqyK
         suEjLyuntAfP5W2fJHavHWmiqADaG3cmQfW4O4cBwbshiXG9vJxzJCNBhNX/TsuQB0
         8aKGFm4veVd2dadNhCgFTkkwJeQ7wN0N5LkFDMvjNIvR2u5i9Fp88Zc21+5v2FTu4j
         J/VY1cMocj7Rw==
Subject: [PATCH 1/5] xfs: define an in-memory btree for storing refcount bag
 info
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:52 -0800
Message-ID: <167243867261.712955.1612864255541727420.stgit@magnolia>
In-Reply-To: <167243867247.712955.4006304832992035940.stgit@magnolia>
References: <167243867247.712955.4006304832992035940.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new in-memory btree type so that we can store refcount bag info
in a much more memory-efficient format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c  |    3 +++
 libxfs/xfs_btree.h  |    1 +
 libxfs/xfs_shared.h |    1 +
 libxfs/xfs_types.h  |    6 ++++--
 4 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 8c7f51f4195..b89e8ce7797 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1370,6 +1370,9 @@ xfs_btree_set_refs(
 	case XFS_BTNUM_REFC:
 		xfs_buf_set_ref(bp, XFS_REFC_BTREE_REF);
 		break;
+	case XFS_BTNUM_RCBAG:
+		xfs_buf_set_ref(bp, XFS_RCBAG_BTREE_REF);
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 7c2ff1a02dd..c795dd8ee84 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -62,6 +62,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
+#define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index d1b3f210326..eaabfa52eda 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -128,6 +128,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
 #define	XFS_REFC_BTREE_REF	1
+#define	XFS_RCBAG_BTREE_REF	1
 #define	XFS_SSB_REF		0
 
 /*
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index c2868e8b6a1..9a4019f23dd 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -116,7 +116,8 @@ typedef enum {
  */
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_RCBAGi,
+	XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 #define XFS_BTNUM_STRINGS \
@@ -126,7 +127,8 @@ typedef enum {
 	{ XFS_BTNUM_BMAPi,	"bmbt" }, \
 	{ XFS_BTNUM_INOi,	"inobt" }, \
 	{ XFS_BTNUM_FINOi,	"finobt" }, \
-	{ XFS_BTNUM_REFCi,	"refcbt" }
+	{ XFS_BTNUM_REFCi,	"refcbt" }, \
+	{ XFS_BTNUM_RCBAGi,	"rcbagbt" }
 
 struct xfs_name {
 	const unsigned char	*name;

