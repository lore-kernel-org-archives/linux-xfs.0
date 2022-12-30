Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167B8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbiLaCMa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCM3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:12:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8EA1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C360CE1A76
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95FEC433D2;
        Sat, 31 Dec 2022 02:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452744;
        bh=jVUdclQL9aNAdOJM0ZpQ9K7kjG2jttJ7+3CbsF4TFQE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mrynAbhm/Hm6R2aPvnsU+YFTe0mB2uFrbo5YWkBO0mpL9hw0ZA1QxatjP9Afm+7dK
         UI+Q9UN/DicLm6oNmFRwgEsVc/QIO5wg7zLQypbYzH2+Wd0BDS27PxN5OGq+9NoSZY
         jOp2Vvz5RkcAvU+uGlF3NAtLguI4CWRFXbgaJpoMzULyPYQkxYQO86a2V0tc0NVUx5
         P+QgQVo1/xuj8I/gCfPpiFMimDGp6aRPbxZlHPiIxVpFhy7Yy1P+ebSnQT1NG5E9rI
         AVz/JjW/GcNgscqHhjqc3UO8z+v0QYPkqwDIAglwsE/WXA+g+uzsivVKBs40BOWAoA
         p5X3j3lSAF/0g==
Subject: [PATCH 10/46] xfs: convert metadata inode lookup keys to use paths
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876069.725900.9127748574834493558.stgit@magnolia>
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

Convert the magic metadata inode lookup keys to use actual strings
for paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_imeta.c |   48 ++++++++++++++++++++++++++----------------------
 libxfs/xfs_imeta.h |   17 +++++++++++++++--
 2 files changed, 41 insertions(+), 24 deletions(-)


diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index bc3c94634ce..8fa0b5a5c1c 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -48,26 +48,17 @@
  */
 
 /* Static metadata inode paths */
-
-const struct xfs_imeta_path XFS_IMETA_RTBITMAP = {
-	.bogus = 0,
-};
-
-const struct xfs_imeta_path XFS_IMETA_RTSUMMARY = {
-	.bogus = 1,
-};
-
-const struct xfs_imeta_path XFS_IMETA_USRQUOTA = {
-	.bogus = 2,
-};
-
-const struct xfs_imeta_path XFS_IMETA_GRPQUOTA = {
-	.bogus = 3,
-};
-
-const struct xfs_imeta_path XFS_IMETA_PRJQUOTA = {
-	.bogus = 4,
-};
+static const char *rtbitmap_path[]	= {"realtime", "bitmap"};
+static const char *rtsummary_path[]	= {"realtime", "summary"};
+static const char *usrquota_path[]	= {"quota", "user"};
+static const char *grpquota_path[]	= {"quota", "group"};
+static const char *prjquota_path[]	= {"quota", "project"};
+
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTBITMAP,	rtbitmap_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTSUMMARY,	rtsummary_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_USRQUOTA,	usrquota_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_GRPQUOTA,	grpquota_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_PRJQUOTA,	prjquota_path);
 
 /* Are these two paths equal? */
 STATIC bool
@@ -75,7 +66,20 @@ xfs_imeta_path_compare(
 	const struct xfs_imeta_path	*a,
 	const struct xfs_imeta_path	*b)
 {
-	return a == b;
+	unsigned int			i;
+
+	if (a == b)
+		return true;
+
+	if (a->im_depth != b->im_depth)
+		return false;
+
+	for (i = 0; i < a->im_depth; i++)
+		if (a->im_path[i] != b->im_path[i] &&
+		    strcmp(a->im_path[i], b->im_path[i]))
+			return false;
+
+	return true;
 }
 
 /* Is this path ok? */
@@ -83,7 +87,7 @@ static inline bool
 xfs_imeta_path_check(
 	const struct xfs_imeta_path	*path)
 {
-	return true;
+	return path->im_depth <= XFS_IMETA_MAX_DEPTH;
 }
 
 /* Functions for storing and retrieving superblock inode values. */
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index 312e3a6fdb9..631a88120a7 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
@@ -6,10 +6,23 @@
 #ifndef __XFS_IMETA_H__
 #define __XFS_IMETA_H__
 
+/* How deep can we nest metadata dirs? */
+#define XFS_IMETA_MAX_DEPTH	64
+
+/* Form an imeta path from a simple array of strings. */
+#define XFS_IMETA_DEFINE_PATH(name, path) \
+const struct xfs_imeta_path name = { \
+	.im_path = (path), \
+	.im_depth = ARRAY_SIZE(path), \
+}
+
 /* Key for looking up metadata inodes. */
 struct xfs_imeta_path {
-	/* Temporary: integer to keep the static imeta definitions unique */
-	int		bogus;
+	/* Array of string pointers. */
+	const char	**im_path;
+
+	/* Number of strings in path. */
+	unsigned int	im_depth;
 };
 
 /* Cleanup widget for metadata inode creation and deletion. */

