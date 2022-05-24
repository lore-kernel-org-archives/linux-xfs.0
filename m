Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B0BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiEXFgr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiEXFgq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:36:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABA065D05
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B97F061383
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE79C385AA;
        Tue, 24 May 2022 05:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370603;
        bh=qqnkrng2SIT8O3jO2q59Qz0HZUJ3AExUl2g3peC9jy4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Um1CdjuEKBSg8YRb2Bvf4xRW2J5+cDYrQYWGXX0dVCSLGoFJnwVu+l7I89E0MbGLC
         OPYsYEIfRxkuF2re4OasgulZDZUvhzrtltKXnmxd9YpRtS4uwE/XZfBjZjBhJZ6DSS
         5tMNCKlwCthwANqThB9PM0DgwP6x1AtMNQQeYumiMFqRC3xHgJcBnBin2iiSCZwJAw
         9Y1EV6FBopf//7Mvr0/Qw080Tt0R6VUO1K8Vr/giCu4Sh6XG7KOUMJ9vvBbpahRVYi
         tb0NARGn990aI5CVqswIpRG7bS50E3sJgNR1r2g5NvkNGJdr4s3iEMFJo21GaZVoTz
         NneDEIpNPacZA==
Subject: [PATCH 4/5] xfs: move xfs_attr_use_log_assist out of xfs_log.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Mon, 23 May 2022 22:36:42 -0700
Message-ID: <165337060268.994444.12050011484802879913.stgit@magnolia>
In-Reply-To: <165337058023.994444.12794741176651030531.stgit@magnolia>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The LARP patchset added an awkward coupling point between libxfs and
what would be libxlog, if the XFS log were actually its own library.
Move the code that enables logged xattr updates out of "lib"xlog and into
xfs_xattr.c so that it no longer has to know about xlog_* functions.

While we're at it, give xfs_xattr.c its own header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    6 +++---
 fs/xfs/xfs_log.c         |   41 --------------------------------------
 fs/xfs/xfs_super.c       |    1 +
 fs/xfs/xfs_super.h       |    1 -
 fs/xfs/xfs_xattr.c       |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_xattr.h       |   14 +++++++++++++
 6 files changed, 67 insertions(+), 45 deletions(-)
 create mode 100644 fs/xfs/xfs_xattr.h


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9f14aca29ec4..24fa213715c1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -25,7 +25,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
-#include "xfs_log.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1028,7 +1028,7 @@ xfs_attr_set(
 	}
 
 	if (use_logging) {
-		error = xfs_attr_use_log_assist(mp);
+		error = xfs_attr_grab_log_assist(mp);
 		if (error)
 			return error;
 	}
@@ -1102,7 +1102,7 @@ xfs_attr_set(
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 drop_incompat:
 	if (use_logging)
-		xlog_drop_incompat_feat(mp->m_log);
+		xfs_attr_rele_log_assist(mp);
 	return error;
 
 out_trans_cancel:
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a75f4ffc75f9..1e972f884a81 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3877,44 +3877,3 @@ xlog_drop_incompat_feat(
 {
 	up_read(&log->l_incompat_users);
 }
-
-/*
- * Get permission to use log-assisted atomic exchange of file extents.
- *
- * Callers must not be running any transactions or hold any inode locks, and
- * they must release the permission by calling xlog_drop_incompat_feat
- * when they're done.
- */
-int
-xfs_attr_use_log_assist(
-	struct xfs_mount	*mp)
-{
-	int			error = 0;
-
-	/*
-	 * Protect ourselves from an idle log clearing the logged xattrs log
-	 * incompat feature bit.
-	 */
-	xlog_use_incompat_feat(mp->m_log);
-
-	/*
-	 * If log-assisted xattrs are already enabled, the caller can use the
-	 * log assisted swap functions with the log-incompat reference we got.
-	 */
-	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
-		return 0;
-
-	/* Enable log-assisted xattrs. */
-	error = xfs_add_incompat_log_feature(mp,
-			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
-	if (error)
-		goto drop_incompat;
-
-	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_LARP,
- "EXPERIMENTAL logged extended attributes feature in use. Use at your own risk!");
-
-	return 0;
-drop_incompat:
-	xlog_drop_incompat_feat(mp->m_log);
-	return error;
-}
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 51ce127a0cc6..a6e7b4176faf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -39,6 +39,7 @@
 #include "xfs_ag.h"
 #include "xfs_defer.h"
 #include "xfs_attr_item.h"
+#include "xfs_xattr.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 167d23f92ffe..3cd5a51bace1 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -91,7 +91,6 @@ extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
 					   xfs_agnumber_t agcount);
 
 extern const struct export_operations xfs_export_operations;
-extern const struct xattr_handler *xfs_xattr_handlers[];
 extern const struct quotactl_ops xfs_quotactl_operations;
 
 extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 7a044afd4c46..fc6acf7021a7 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -15,9 +15,58 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_acl.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
 
 #include <linux/posix_acl_xattr.h>
 
+/*
+ * Get permission to use log-assisted atomic exchange of file extents.
+ *
+ * Callers must not be running any transactions or hold any inode locks, and
+ * they must release the permission by calling xlog_drop_incompat_feat
+ * when they're done.
+ */
+int
+xfs_attr_grab_log_assist(
+	struct xfs_mount	*mp)
+{
+	int			error = 0;
+
+	/*
+	 * Protect ourselves from an idle log clearing the logged xattrs log
+	 * incompat feature bit.
+	 */
+	xlog_use_incompat_feat(mp->m_log);
+
+	/*
+	 * If log-assisted xattrs are already enabled, the caller can use the
+	 * log assisted swap functions with the log-incompat reference we got.
+	 */
+	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return 0;
+
+	/* Enable log-assisted xattrs. */
+	error = xfs_add_incompat_log_feature(mp,
+			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+	if (error)
+		goto drop_incompat;
+
+	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_LARP,
+ "EXPERIMENTAL logged extended attributes feature in use. Use at your own risk!");
+
+	return 0;
+drop_incompat:
+	xlog_drop_incompat_feat(mp->m_log);
+	return error;
+}
+
+void
+xfs_attr_rele_log_assist(
+	struct xfs_mount	*mp)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+}
 
 static int
 xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
new file mode 100644
index 000000000000..d34ef1835541
--- /dev/null
+++ b/fs/xfs/xfs_xattr.h
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_XATTR_H__
+#define __XFS_XATTR_H__
+
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
+void xfs_attr_rele_log_assist(struct xfs_mount *mp);
+
+extern const struct xattr_handler *xfs_xattr_handlers[];
+
+#endif /* __XFS_XATTR_H__ */

