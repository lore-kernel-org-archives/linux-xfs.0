Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435DCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiLaBNC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiLaBNB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:13:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C159B16588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:12:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B40ACE1923
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58450C433D2;
        Sat, 31 Dec 2022 01:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449176;
        bh=a8MjIBxbRvCG9ezUbe1kp4iv7MeCDzvq3pRTX4iRsZ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=crrnfj870cPstV45aphsLL09z9mNjb8zV0d0iv0eo4UmgnbEuUaBeIOCdLd122u+h
         ZLt7rvNjW5AuOwIPCtPtNmy0Xqmv5pON8U3DKJ1kHQJFwJjuBju+IwmTJfr8n+2N4D
         LocQfyl/j5KMW4jrLPYZBHbJflh93iQ6GI84N9A9h8POdXmlGsx9QAdUaqeeZPyYzv
         aAfPu7cPkRxqxyyC6yfgeg9UIyhxLhQD5PmTRVE3RG4gzPDqRCYawbXlmHX4UpPiDZ
         Y6848E6xxIxSv6YoUxgvlksFBzVrbgoeGnUuL/qSYKcac6P0c7KHTGqbGIUro8rv8i
         gwa6LGNIQ+8Ow==
Subject: [PATCH 10/23] xfs: convert metadata inode lookup keys to use paths
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:26 -0800
Message-ID: <167243864597.708110.2122034559953518621.stgit@magnolia>
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

Convert the magic metadata inode lookup keys to use actual strings
for paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_imeta.c |   48 ++++++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_imeta.h |   17 ++++++++++++++--
 2 files changed, 41 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index f14b7892f50d..f35ed01320b3 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -49,26 +49,17 @@
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
@@ -76,7 +67,20 @@ xfs_imeta_path_compare(
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
@@ -84,7 +88,7 @@ static inline bool
 xfs_imeta_path_check(
 	const struct xfs_imeta_path	*path)
 {
-	return true;
+	return path->im_depth <= XFS_IMETA_MAX_DEPTH;
 }
 
 /* Functions for storing and retrieving superblock inode values. */
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 312e3a6fdb96..631a88120a70 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
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

