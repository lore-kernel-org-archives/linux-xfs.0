Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB523C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbiLaASA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbiLaAR5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:17:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CB31CB3F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:17:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AE8361D1C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B16CC4332B;
        Sat, 31 Dec 2022 00:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445875;
        bh=OsNTwKmyPt/6sX/Y24yyL+dkkwQjblrRxSBJGns/kj4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oiB3vSZvunjckl5ygGzjCZocEMdKprVGy5XW3yEp37TDMTeqTeCn4cfuFzmW0GGpP
         Gqy70v354AiUUTnzMZxXPAFtoEtY+B+kcJE0ZhsEpopEXOHn8qHIObGjJ7GYTdo+WP
         vFyVuEnd/uQrDVLG4LbS27e3/fhouV+kITkTs0GHoFNFfswnioUnaLjhr7s9H58nrC
         Mv+gsIc1mjBEgHmd+Z5K/mBKp9enlKKjEKCSK5LVmZ21l6zFL9G5kK3eh9LmAN11P0
         aYz1GbUofmI2iRFr6amxWIcXH/bAZCtvBPszkJd1Za6AWluVkZg73vklAi9MBIOZXO
         F8MVzktR+R8VQ==
Subject: [PATCH 1/4] xfs: move xfs_symlink_remote.c declarations to
 xfs_symlink_remote.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:56 -0800
Message-ID: <167243867601.713532.6540985468566213398.stgit@magnolia>
In-Reply-To: <167243867587.713532.17037228277541976894.stgit@magnolia>
References: <167243867587.713532.17037228277541976894.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move declarations for libxfs symlink functions into a separate header
file like we do for most everything else.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h            |    1 +
 libxfs/xfs_bmap.c           |    1 +
 libxfs/xfs_inode_fork.c     |    1 +
 libxfs/xfs_shared.h         |   14 --------------
 libxfs/xfs_symlink_remote.c |    2 +-
 libxfs/xfs_symlink_remote.h |   23 +++++++++++++++++++++++
 6 files changed, 27 insertions(+), 15 deletions(-)
 create mode 100644 libxfs/xfs_symlink_remote.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 887f57b6171..d4b5d8e564d 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -79,6 +79,7 @@ struct iomap;
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
+#include "xfs_symlink_remote.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index edd3e81fd04..983eb7641fc 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -30,6 +30,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 9b0c786fab6..9d76a6b5c65 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -24,6 +24,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index eaabfa52eda..5127fa88531 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -138,20 +138,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
 #define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
 
-
-/*
- * Symlink decoding/encoding functions
- */
-int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
-int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
-			uint32_t size, struct xfs_buf *bp);
-bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
-			uint32_t size, struct xfs_buf *bp);
-void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
-xfs_failaddr_t xfs_symlink_sf_verify_struct(void *sfp, int64_t size);
-xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
-
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
 	/* Maximum inode count in this filesystem. */
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index b9d446fba9a..e036a8f46fe 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -13,7 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-
+#include "xfs_symlink_remote.h"
 
 /*
  * Each contiguous block has a header, so it is not just a simple pathlen
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
new file mode 100644
index 00000000000..a58d536c8b8
--- /dev/null
+++ b/libxfs/xfs_symlink_remote.h
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_SYMLINK_REMOTE_H
+#define __XFS_SYMLINK_REMOTE_H
+
+/*
+ * Symlink decoding/encoding functions
+ */
+int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
+int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
+				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+xfs_failaddr_t xfs_symlink_sf_verify_struct(void *sfp, int64_t size);
+xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
+
+#endif /* __XFS_SYMLINK_REMOTE_H */

