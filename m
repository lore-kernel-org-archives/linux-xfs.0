Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204DAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiLaATr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiLaATb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:19:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338A3193DB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:19:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C47F661D12
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFACC433D2;
        Sat, 31 Dec 2022 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445969;
        bh=XmDyXDhvlaatBX1AA9vYky3E1vCZaiWmtXi1EyQBS2Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sPRvLhX3JVDeT/dfqBHFYxUguHjpvfuo+6VUM+1WmvRNNLc64Yg+S2bBE7f3qBIQb
         Y5iPwgUkr3Qi0gRb6AjWoMNKLrVPqQo81+/h3h8z5Vk44bsWdnkg887/2nT3YWaG8f
         dx0FksK+tZ3oV09Pbq66aFTP0gW2OYf6p6pHpDewDFxJo9Ujax8hBt+2eJZa6VWGx4
         aP3P+bkxAvc7NEYLCOXOvvowG7QbrLb/wj4M6g7hkFct8yQsonFsI2lqANVUAqOvGJ
         yL3cuMYHMLvsGRcKzgZ90aSjh+M4axxvPDH3Y1uC7LJ6tkMe39XrdTci9nZ40UDsmU
         50KlOBKJeAddg==
Subject: [PATCH 03/19] xfs: create a log incompat flag for atomic extent
 swapping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:59 -0800
Message-ID: <167243867977.713817.9466397262393076049.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a log incompat flag so that we only attempt to process swap
extent log items if the filesystem supports it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h             |    1 +
 libxfs/xfs_fs.h                 |    1 +
 libxfs/xfs_sb.c                 |    3 +++
 libxfs/xfs_swapext.h            |   24 ++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 5 files changed, 32 insertions(+)
 create mode 100644 libxfs/xfs_swapext.h


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 817adb36cb1..1424976ec95 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -391,6 +391,7 @@ xfs_sb_has_incompat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT  (1U << 31)	/* file extent swap */
 #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
 	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 210c17f5a16..a39fd65e6ee 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP	(1U << 31) /* atomic file extent swap */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 11b922789fe..10f699b4e99 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -23,6 +23,7 @@
 #include "xfs_da_format.h"
 #include "xfs_health.h"
 #include "xfs_ag.h"
+#include "xfs_swapext.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1195,6 +1196,8 @@ xfs_fs_geometry(
 	}
 	if (xfs_has_large_extent_counts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
+	if (xfs_swapext_supported(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
diff --git a/libxfs/xfs_swapext.h b/libxfs/xfs_swapext.h
new file mode 100644
index 00000000000..316323339d7
--- /dev/null
+++ b/libxfs/xfs_swapext.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SWAPEXT_H_
+#define __XFS_SWAPEXT_H_ 1
+
+/*
+ * Decide if this filesystem supports using log items to swap file extents and
+ * restart the operation if the system fails before the operation completes.
+ *
+ * This can be done to individual file extents by using the block mapping log
+ * intent items introduced with reflink and rmap; or to entire file ranges
+ * using swapext log intent items to track the overall progress across multiple
+ * extent mappings.  Realtime is not supported yet.
+ */
+static inline bool xfs_swapext_supported(struct xfs_mount *mp)
+{
+	return (xfs_has_reflink(mp) || xfs_has_rmapbt(mp)) &&
+	       !xfs_has_realtime(mp);
+}
+
+#endif /* __XFS_SWAPEXT_H_ */
diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index f59a6e8a6a2..7c563ca0454 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -211,6 +211,9 @@ Filesystem stores reverse mappings of blocks to owners.
 .TP
 .B XFS_FSOP_GEOM_FLAGS_REFLINK
 Filesystem supports sharing blocks between files.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_ATOMICSWAP
+Filesystem can exchange file contents atomically via FIEXCHANGE_RANGE.
 .RE
 .SH XFS METADATA HEALTH REPORTING
 .PP

