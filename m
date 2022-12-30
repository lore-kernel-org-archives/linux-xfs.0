Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39091C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiL3Xtm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiL3Xtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:49:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8392D64FA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:49:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41050B81DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC075C433D2;
        Fri, 30 Dec 2022 23:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444178;
        bh=Md1YEWJmWr1FbTaZ3Qh6wfDSfBYE7nhl+F5m446f5tc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e4MgvYT+I9xF3RfuzdYe/aCXuIu1l9q3v9Ltzuk1Twgh5ZXQnzSvpjp+myRKCDVAu
         UlsBzScK9XaoObn+N9nFPuVsqg5TetRRJ6P+Br3m/YHiOJ1YJjN/gbwafXiqQ4I+RT
         RWQuk7aU0wyesvMzaPP56oW3u5jP2m7pC0Z8yrwN2K3XhQ4GIEwukdKrG54cW0jfSw
         6fsAx4+iP/0GB8sJPldPc4C0+U8ZDrSe6ooxZx24GBv7I+goOssKpkKlzbwl1R3bm8
         JKRK3FLtUstqLJ5uuBBoJX3KDuehzeCo/gXeWwiRcx+9KCghTvodQxeZkvE6/n/CyD
         wKmGZrJXMyalA==
Subject: [PATCH 1/3] xfs: move xfs_symlink_remote.c declarations to
 xfs_symlink_remote.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:51 -0800
Message-ID: <167243843152.699346.17415341288236150361.stgit@magnolia>
In-Reply-To: <167243843134.699346.594115796077510288.stgit@magnolia>
References: <167243843134.699346.594115796077510288.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_bmap.c           |    1 +
 fs/xfs/libxfs/xfs_inode_fork.c     |    1 +
 fs/xfs/libxfs/xfs_shared.h         |   14 --------------
 fs/xfs/libxfs/xfs_symlink_remote.c |    2 +-
 fs/xfs/libxfs/xfs_symlink_remote.h |   23 +++++++++++++++++++++++
 fs/xfs/scrub/inode_repair.c        |    1 +
 fs/xfs/scrub/symlink.c             |    1 +
 fs/xfs/xfs_symlink.c               |    1 +
 8 files changed, 29 insertions(+), 15 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_symlink_remote.h


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7433e1ecdabb..cf85f3896afa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index c2cc3c193ffc..ab1bc0e3a595 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -26,6 +26,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index eaabfa52eda6..5127fa88531f 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
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
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 7660a95b1ea9..3ea30adc8220 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -16,7 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
-
+#include "xfs_symlink_remote.h"
 
 /*
  * Each contiguous block has a header, so it is not just a simple pathlen
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
new file mode 100644
index 000000000000..a58d536c8b83
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
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
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index e5e3daf75fd1..6c889c21ddec 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -35,6 +35,7 @@
 #include "xfs_ag.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_log_priv.h"
+#include "xfs_symlink_remote.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index c1c99ffe7408..3c9900b242e4 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -12,6 +12,7 @@
 #include "xfs_log_format.h"
 #include "xfs_inode.h"
 #include "xfs_symlink.h"
+#include "xfs_symlink_remote.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 90de8991cd94..76f80f958381 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -24,6 +24,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 /* ----- Kernel only functions below ----- */
 int

