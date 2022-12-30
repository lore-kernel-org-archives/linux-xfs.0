Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8D8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbiLaBJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbiLaBJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:09:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07091573A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:09:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9097561D03
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0151AC433D2;
        Sat, 31 Dec 2022 01:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448942;
        bh=sQSx26lEfcOUAq6gf+Zr2B8YjYWL/lTwiiUxDkC1Dqg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o0YU5gHNYciaYodl2eGYJse8ETaitiUSePzw09igJ6jABqIcZ0J1w/x4xdmyUdjxz
         0K0UrPE0uUELR6EK32EAohoMo+VYL3qk7csS9zKXUVKGafdxqh5adKs6QwKrNE/3X5
         i8jMuX0EeHILwmJROTzlwPj7d6cREf+MOtoHWUuFZd+gCRVk0rCpb0htC/0I4UD2DR
         t3wR9cegRv+HpjvS2SvyiDhNMWGPu/8oMEz6SNTg8/R9bqp6GlI57z7TeYI5ASP6YJ
         Jl3HSZylCdfs5PccRpVJvDdtuIdN/wpsZUZCxZGRddEAFc2uDyee4b+ejqMbffnLGB
         1zMzLizh2SQIQ==
Subject: [PATCH 15/20] xfs: create libxfs helper to link an existing inode
 into a directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:20 -0800
Message-ID: <167243864045.707335.4412916251763797944.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new libxfs function to link an existing inode into a directory.
The upcoming metadata directory feature will need this to create a
metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    3 +++
 fs/xfs/xfs_inode.c       |   26 +----------------------
 3 files changed, 55 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index bca493a2da8d..e14464712eff 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -21,6 +21,7 @@
 #include "xfs_health.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
+#include "xfs_ag.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -825,3 +826,53 @@ xfs_dir_create_new_child(
 	xfs_bumplink(tp, dp);
 	return 0;
 }
+
+/*
+ * Given a directory @dp, an existing non-directory inode @ip, and a @name,
+ * link @ip into @dp under the given @name.  Both inodes must have the ILOCK
+ * held.
+ */
+int
+xfs_dir_link_existing_child(
+	struct xfs_trans	*tp,
+	uint			resblks,
+	struct xfs_inode	*dp,
+	struct xfs_name		*name,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
+	ASSERT(!S_ISDIR(VFS_I(ip)->i_mode));
+
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, dp, name);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Handle initial link state of O_TMPFILE inode
+	 */
+	if (VFS_I(ip)->i_nlink == 0) {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+		error = xfs_iunlink_remove(tp, pag, ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+	}
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	xfs_bumplink(tp, ip);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d3e7607c0e9d..4afade8b0877 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -256,5 +256,8 @@ bool xfs_dir2_namecheck(const void *name, size_t length);
 int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b66a9cf66055..e2563401b27d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1062,33 +1062,9 @@ xfs_link(
 		goto error_return;
 	}
 
-	if (!resblks) {
-		error = xfs_dir_canenter(tp, tdp, target_name);
-		if (error)
-			goto error_return;
-	}
-
-	/*
-	 * Handle initial link state of O_TMPFILE inode
-	 */
-	if (VFS_I(sip)->i_nlink == 0) {
-		struct xfs_perag	*pag;
-
-		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, sip->i_ino));
-		error = xfs_iunlink_remove(tp, pag, sip);
-		xfs_perag_put(pag);
-		if (error)
-			goto error_return;
-	}
-
-	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+	error = xfs_dir_link_existing_child(tp, resblks, tdp, target_name, sip);
 	if (error)
 		goto error_return;
-	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
-
-	xfs_bumplink(tp, sip);
 	xfs_nlink_dirent_delta(tdp, sip, 1, target_name);
 
 	/*

