Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B287C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbjEZBOC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbjEZBN7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8EE125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B2B564C27
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E52C433EF;
        Fri, 26 May 2023 01:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063637;
        bh=ek+Ka25x4mx2gpWZe1/mT31e1MAKnjoNu+LQM1vAqnI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pGPR6Ij4gKHPDwmh5wKG3iWEs2C/hBV+1v8QuyF2/YYxw+S1drE6oNEUIBzYZLkje
         Dw2eGWfV9APS8+ZAfpEDlLDUm/sLDl54wRmaFscFqr0jEFyz5buJUZCpyQk4IR7ynu
         S+IhM7zWEdtaLDDZPe3MOMZkJDQfvp956Cbo8LuDnBkupOmRRqkkf24t64s/3uB61I
         zsHdqh7MYMRHH4jQSibI6XJxikUonpHFajzvVosx03W4CFFbpqqu/Cbhz7BpVCA8VO
         QBJELViuf6soo9gWPxvsijFIn43BV25lSN5I/C5Jg+uJs65WbvU7qzDnJTRQdW6NbX
         VM3r8+AX5d1Kg==
Date:   Thu, 25 May 2023 18:13:57 -0700
Subject: [PATCH 1/3] xfs: move xfs_symlink_remote.c declarations to
 xfs_symlink_remote.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506064580.3734314.2548620491576095012.stgit@frogsfrogsfrogs>
In-Reply-To: <168506064562.3734314.9065396398319098452.stgit@frogsfrogsfrogs>
References: <168506064562.3734314.9065396398319098452.stgit@frogsfrogsfrogs>
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
index 5d9e0af35017..52861349632e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f295fba3a61a..32542caece47 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -26,6 +26,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index d1b3f210326e..7509c1406a35 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -137,20 +137,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
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
index 42ec3b38c826..6d301c84270f 100644
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
index 38708fb9a5d7..c519f73cecdb 100644
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
index b1d39e7e64cf..cc90a6cb6d83 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -24,6 +24,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 /* ----- Kernel only functions below ----- */
 int

