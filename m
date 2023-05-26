Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E05CC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjEZAzs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEZAzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C87012E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A87BB61B75
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1497CC433D2;
        Fri, 26 May 2023 00:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062545;
        bh=VRP1zBFoWBI3997pIeRxBdf6s0rKkbk+kZ1gwX37bBI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=c22AFxKVXBvhqh10MxDv7/Devjj5uCIrdOiXEMEfppqOQyiZKO9BR8LjZNtTc5l4X
         Ml6D9PExdKFHPX5UxZy5HNvS8hqOhPVM/d7aKWSegqfRsr7Y/iuvuFuf6zPtHlsBnY
         KGRs2ALYYwvaskZNoJL4XjSV7KtvUg0mFRT4T7rbyCr0AMuc5YQwM3gYU2AkTiSFzp
         c+pyVzSlZkhy7s3wFvh9APSDpbbZHcYQq2Oy6u3OoH4Y9f15OGvWf6HHZY85cSM2be
         N2OMohWVi2/8bV+lOahwqhKTnhLaonhO6V2ctoIo9DKX24tz8bipwGTq5u8unzapyA
         G5BbZwiCFXz8g==
Date:   Thu, 25 May 2023 17:55:44 -0700
Subject: [PATCH 3/4] xfs: online repair of realtime bitmaps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059143.3730797.15513613095209946178.stgit@frogsfrogsfrogs>
In-Reply-To: <168506059095.3730797.12158750493561425588.stgit@frogsfrogsfrogs>
References: <168506059095.3730797.12158750493561425588.stgit@frogsfrogsfrogs>
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
index d3da47be96d4..d0d6d52c7ff7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -189,5 +189,9 @@ xfs-y				+= $(addprefix scrub/, \
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
index 6a1b6cefbfec..1775d396b5fc 100644
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
index 7a64489fe9c5..19808f1f5872 100644
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
index 000000000000..24cd4d058629
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
index 00bf8d2dfa43..5cd028dfbc29 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -328,7 +328,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rtbitmap,
 		.scrub	= xchk_rtbitmap,
 		.has	= xfs_has_realtime,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtbitmap,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,

