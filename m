Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8736AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbiLaBcm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiLaBcl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:32:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1C9DECF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:32:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77ACC61CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76E6C433D2;
        Sat, 31 Dec 2022 01:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450359;
        bh=ntyEQBUMZOoYePgbavHf9Ga0DUgoAabAeItp0cdz5GM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pFVFt/cnFe0tuCQsd/u2iigLJCxhRKPjIU0owvyr9ZSl9o49xugqFFqcuc7tUw5hC
         YPuALeZlIHG4a63B1G4Q2TLeJsXc/V80plqppx1QHeEPcAlrSougO6vWz5wnjVXrxW
         N1Z3XD0rW/CPsrWoRtw9lLaF+kLYlWovSIDmboBhGAc/rX0I7LKK2wB1MRRbx/Fxbl
         aNbk8nWyK5Qmz0Oh8CLxYWyk1doIBYi1nKY5MiuAnCC8LIt08BImunHuX65YbNN01f
         jiauQaCaKwoN6v3K+zSbVK7RpFsqPM4uiUql8Br074Un8vxj+hTCjEq8sHTJQ+OwVJ
         qb8pQK2rXg16g==
Subject: [PATCH 20/22] xfs: repair secondary realtime group superblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:55 -0800
Message-ID: <167243867553.712847.11659815081440228135.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Repair secondary realtime group superblocks.  They're not critical for
anything, but some consistency would be a good idea.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile               |    1 +
 fs/xfs/libxfs/xfs_rtgroup.c   |    2 +-
 fs/xfs/libxfs/xfs_rtgroup.h   |    3 +++
 fs/xfs/scrub/repair.h         |    3 +++
 fs/xfs/scrub/rgsuper_repair.c |   48 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c          |    2 +-
 6 files changed, 57 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rgsuper_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a02fb09fed64..4bf6d663272b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -217,6 +217,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rgsuper_repair.o \
 				   rtbitmap_repair.o \
 				   rtsummary_repair.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index a428dff81888..4d9e2c0f2fd3 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -384,7 +384,7 @@ xfs_rtgroup_log_super(
 }
 
 /* Initialize a secondary realtime superblock. */
-static int
+int
 xfs_rtgroup_init_secondary_super(
 	struct xfs_mount	*mp,
 	xfs_rgnumber_t		rgno,
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 1fec49c496d4..3c9572677f79 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -210,6 +210,8 @@ void xfs_rtgroup_update_super(struct xfs_buf *rtsb_bp,
 		const struct xfs_buf *sb_bp);
 void xfs_rtgroup_log_super(struct xfs_trans *tp, const struct xfs_buf *sb_bp);
 int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
+int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		struct xfs_buf **bpp);
 
 /* Lock the rt bitmap inode in exclusive mode */
 #define XFS_RTGLOCK_BITMAP		(1U << 0)
@@ -230,6 +232,7 @@ int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
 # define xfs_rtgroup_log_super(tp, sb_bp)	((void)0)
 # define xfs_rtgroup_update_secondary_sbs(mp)	(0)
+# define xfs_rtgroup_init_secondary_super(mp, rgno, bpp)	(-EOPNOTSUPP)
 # define xfs_rtgroup_lock(tp, rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index c6461acd1112..292e252efae3 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -131,9 +131,11 @@ int xrep_symlink(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
 int xrep_rtsummary(struct xfs_scrub *sc);
+int xrep_rgsuperblock(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
 # define xrep_rtsummary			xrep_notsupported
+# define xrep_rgsuperblock		xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -248,6 +250,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_directory			xrep_notsupported
 #define xrep_parent			xrep_notsupported
 #define xrep_symlink			xrep_notsupported
+#define xrep_rgsuperblock		xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rgsuper_repair.c b/fs/xfs/scrub/rgsuper_repair.c
new file mode 100644
index 000000000000..9dc379c593ba
--- /dev/null
+++ b/fs/xfs/scrub/rgsuper_repair.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_inode.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_rtgroup.h"
+#include "xfs_sb.h"
+#include "scrub/scrub.h"
+#include "scrub/repair.h"
+
+int
+xrep_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	/*
+	 * If this is the primary rtgroup superblock, log a superblock update
+	 * to force both to disk.
+	 */
+	if (sc->sr.rtg->rtg_rgno == 0) {
+		xfs_log_sb(sc->tp);
+		return 0;
+	}
+
+	/* Otherwise just write a new secondary to disk directly. */
+	error = xfs_rtgroup_init_secondary_super(sc->mp, sc->sr.rtg->rtg_rgno,
+			&bp);
+	if (error)
+		return error;
+
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6c54f00b516c..5e07150e8f14 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -414,7 +414,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rgsuperblock,
 		.scrub	= xchk_rgsuperblock,
 		.has	= xfs_has_rtgroups,
-		.repair = xrep_notsupported,
+		.repair = xrep_rgsuperblock,
 	},
 };
 

