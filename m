Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5197AE7F14C
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjI0AUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbjI0ASC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:18:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA8E4EC0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:39:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24F4C433C7;
        Tue, 26 Sep 2023 23:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771554;
        bh=Rk4u0P5G7UpNQ1YtVPAtnWZfbtvNyzi84HyRHRgoztQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=BdXO7SsxaxwMcEY/bU93tfgaA1WO3AG5y8wc0pxs7yqxZw+a1tmHCOH1Sm8mOFora
         emIDHldtmpLNNQaE+Mp4i0si4ixKzKujU04XI3cvoWWSKxxSkVR6Nj47Wll/yn385M
         UX98VpmHfgUJgLzh59CLMledAgMKMiX1BaEUA1/I0E6zyXd1z9ud9F/Pb+dzbEgBga
         v4XsO4GRsaIpQKlhgZ8Lk1Uh6C8yEh0WvWqNm8BPWE5nkeI8Sm6uF4cUIWvXqeI6sv
         PGyp166zz8uwFCi79sa/Yrpjr4BeQJrz6SRgD3/jcjjyrBbj1RKHgJ2zZbFeBr2J2K
         agh6x6Yydj6hw==
Date:   Tue, 26 Sep 2023 16:39:13 -0700
Subject: [PATCH 4/4] xfs: online repair of realtime bitmaps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577061246.3315493.16212837042710054329.stgit@frogsfrogsfrogs>
In-Reply-To: <169577061183.3315493.6171012860982301231.stgit@frogsfrogsfrogs>
References: <169577061183.3315493.6171012860982301231.stgit@frogsfrogsfrogs>
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
index 71a76f8ac5e47..36e7bc7d147e2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -191,5 +191,9 @@ xfs-y				+= $(addprefix scrub/, \
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
index b7ddd35e753eb..4b9fe3d47bb24 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -90,6 +90,7 @@ int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
 
 struct xfs_imap;
 int xrep_setup_inode(struct xfs_scrub *sc, struct xfs_imap *imap);
+int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *resblks);
 
 void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag,
@@ -115,6 +116,12 @@ int xrep_bmap_data(struct xfs_scrub *sc);
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
 
@@ -162,6 +169,11 @@ xrep_setup_nothing(
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
+static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
+{
+	return 0;
+}
+
 #define xrep_revalidate_allocbt		(NULL)
 #define xrep_revalidate_iallocbt	(NULL)
 
@@ -177,6 +189,7 @@ xrep_setup_nothing(
 #define xrep_bmap_data			xrep_notsupported
 #define xrep_bmap_attr			xrep_notsupported
 #define xrep_bmap_cow			xrep_notsupported
+#define xrep_rtbitmap			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 7a64489fe9c54..19808f1f5872d 100644
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
index 0000000000000..24cd4d058629c
--- /dev/null
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020-2023 Oracle.  All Rights Reserved.
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
index 89ce6d2f9ad14..9982b626bfc33 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -330,7 +330,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_rtbitmap,
 		.scrub	= xchk_rtbitmap,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtbitmap,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,

