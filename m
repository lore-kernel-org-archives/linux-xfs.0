Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC27BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbiL3Xcw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbiL3Xcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:32:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6672212D20
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:32:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B485B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35EAC433D2;
        Fri, 30 Dec 2022 23:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443166;
        bh=j/xuhVUq/Onzb9Rziznh4A9rj/zOKbUXQAVBq5oSak0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lFNXL+9Tkmx3nnpIdMdoRGiasfYGo4wKUJqeWHOFkSvLWIhfKLzlaoOp2votJBjYo
         ktRfnnjGeGrj+LRNbdhX9y0w+bywF2E4cTKteZL7dmmmzV/P/ue3SRsLqLfnJGLmJW
         1bs4SYUkq/exD2E6FTH2jTvdVvalahlH0sK7msfGKvW7p9aFjyzKonH0LSjFarLcFJ
         RXRK6sgpYG3UM6BldhRyQ1DDGmeytVpHJ4EDG0zjSs57vQPucx9uf5gcjMEF0GNqp5
         JMIqqkQheSKZERRb67yLgZpsSAYxWVO4Tq/6xKDyJkt98687aIfe462Ic7YjcJgU+O
         syLTKy6VpPv6A==
Subject: [PATCH 3/4] xfs: online repair of realtime bitmaps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:00 -0800
Message-ID: <167243838035.695277.8646550280841210602.stgit@magnolia>
In-Reply-To: <167243837989.695277.12249962882609806700.stgit@magnolia>
References: <167243837989.695277.12249962882609806700.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rebuild the realtime bitmap from the realtime rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                |    4 +++
 fs/xfs/scrub/repair.h          |   13 +++++++++
 fs/xfs/scrub/rtbitmap.c        |   10 ++++++-
 fs/xfs/scrub/rtbitmap_repair.c |   56 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c           |    2 +
 5 files changed, 83 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rtbitmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b0a36ebb0a3b..74fcf2b4dc86 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -187,5 +187,9 @@ xfs-y				+= $(addprefix scrub/, \
 				   refcount_repair.o \
 				   repair.o \
 				   )
+
+xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rtbitmap_repair.o \
+				   )
 endif
 endif
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 69cb6b38bc55..74325131f3ca 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -80,6 +80,7 @@ int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
 
 struct xfs_imap;
 int xrep_setup_inode(struct xfs_scrub *sc, struct xfs_imap *imap);
+int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *resblks);
 
 void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag,
@@ -105,6 +106,12 @@ int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_bmap_cow(struct xfs_scrub *sc);
 
+#ifdef CONFIG_XFS_RT
+int xrep_rtbitmap(struct xfs_scrub *sc);
+#else
+# define xrep_rtbitmap			xrep_notsupported
+#endif /* CONFIG_XFS_RT */
+
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
 
@@ -151,6 +158,11 @@ xrep_setup_nothing(
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
+static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
+{
+	return 0;
+}
+
 #define xrep_revalidate_allocbt		(NULL)
 #define xrep_revalidate_iallocbt	(NULL)
 
@@ -166,6 +178,7 @@ xrep_setup_nothing(
 #define xrep_bmap_data			xrep_notsupported
 #define xrep_bmap_attr			xrep_notsupported
 #define xrep_bmap_cow			xrep_notsupported
+#define xrep_rtbitmap			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index c22427012a11..1d84a9eed67c 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -16,15 +16,23 @@
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/repair.h"
 
 /* Set us up with the realtime metadata locked. */
 int
 xchk_setup_rtbitmap(
 	struct xfs_scrub	*sc)
 {
+	unsigned int		resblks = 0;
 	int			error;
 
-	error = xchk_trans_alloc(sc, 0);
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_rtbitmap(sc, &resblks);
+		if (error)
+			return error;
+	}
+
+	error = xchk_trans_alloc(sc, resblks);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
new file mode 100644
index 000000000000..c88c49b03e86
--- /dev/null
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -0,0 +1,56 @@
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
+#include "xfs_btree.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_bit.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/xfile.h"
+
+/* Set up to repair the realtime bitmap file metadata. */
+int
+xrep_setup_rtbitmap(
+	struct xfs_scrub	*sc,
+	unsigned int		*resblks)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned long long	blocks = 0;
+
+	/*
+	 * Reserve enough blocks to write out a completely new bmbt for the
+	 * bitmap file.
+	 */
+	blocks = xfs_bmbt_calc_size(mp, mp->m_sb.sb_rbmblocks);
+	if (blocks > UINT_MAX)
+		return -EOPNOTSUPP;
+
+	*resblks += blocks;
+	return 0;
+}
+
+/* Repair the realtime bitmap file metadata. */
+int
+xrep_rtbitmap(
+	struct xfs_scrub	*sc)
+{
+	/*
+	 * The only thing we know how to fix right now is problems with the
+	 * inode or its fork data.
+	 */
+	return xrep_metadata_inode_forks(sc);
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1fed319b4f7a..06da054bf9e4 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -330,7 +330,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rtbitmap,
 		.scrub	= xchk_rtbitmap,
 		.has	= xfs_has_realtime,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtbitmap,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,

