Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD14C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiL3X5a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbiL3X52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:57:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960DE1E3C5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:57:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35A14B81DD1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA91C433D2;
        Fri, 30 Dec 2022 23:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444645;
        bh=J3WCx5kihU5kYTvkD/CUFzixZdMHJzshsBTdfiaU4Lg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QirIcVUDfcm7QW3mOHIe1vti/fPV0o+dtLYBZy+2F5QPrHRNmM9GuI+k8UZU8PWSa
         TMpDhiWUNcNPg+ouqosQTO7kP2unebTk3NY2aIDS3s3mCIf0j4yy/ALCLa0z94M9in
         hbFVPN49gQkuGpVD/wozeBPrw189gaRNWe5NEBQeYlxHMWISgqljo8ogjn2XUuM9Bp
         Za/ZD7EILQAQS6Tt+ImegJO24cjU4781lq1xNIt2aY3PXfl2u4O3jDixV2F+CC1x1E
         mupHWu50/rTVhfdpS+s1ML6p8R/Y+br33uLG5w/HpZovEeRx+SZFXYsIz8jM6UJ4Y1
         ubk/0HP/yg0tQ==
Subject: [PATCH 3/3] xfs: online repair of realtime summaries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:05 -0800
Message-ID: <167243844519.700124.14532389095888627394.stgit@magnolia>
In-Reply-To: <167243844474.700124.6546659007531232200.stgit@magnolia>
References: <167243844474.700124.6546659007531232200.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Repair the realtime summary data by constructing a new rtsummary file in
the scrub temporary file, then atomically swapping the contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/scrub/common.c           |    1 
 fs/xfs/scrub/repair.h           |   14 +++
 fs/xfs/scrub/rtsummary.c        |   18 +++-
 fs/xfs/scrub/rtsummary.h        |   14 +++
 fs/xfs/scrub/rtsummary_repair.c |  169 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c            |    3 -
 7 files changed, 214 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.h
 create mode 100644 fs/xfs/scrub/rtsummary_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6df1cd3b46ca..0abdcc69cd7f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -207,6 +207,7 @@ xfs-y				+= $(addprefix scrub/, \
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rtbitmap_repair.o \
+				   rtsummary_repair.o \
 				   )
 
 xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 7eade2567af6..2fbd8aa01ef7 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -32,6 +32,7 @@
 #include "xfs_ag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
+#include "xfs_swapext.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 3b25f2fa629e..086e8e739264 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -80,6 +80,8 @@ int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
 int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
 int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
+int xrep_setup_rtsummary(struct xfs_scrub *sc, unsigned int *resblks,
+		size_t *bufsize);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -117,8 +119,10 @@ int xrep_fscounters(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
+int xrep_rtsummary(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
+# define xrep_rtsummary			xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -186,6 +190,15 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 	return 0;
 }
 
+static inline int
+xrep_setup_rtsummary(
+	struct xfs_scrub	*sc,
+	unsigned int		*whatever,
+	size_t			*dontcare)
+{
+	return 0;
+}
+
 #define xrep_revalidate_allocbt		(NULL)
 #define xrep_revalidate_iallocbt	(NULL)
 
@@ -207,6 +220,7 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_quotacheck			xrep_notsupported
 #define xrep_nlinks			xrep_notsupported
 #define xrep_fscounters			xrep_notsupported
+#define xrep_rtsummary			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 73c75d41ef3c..7d1bc49fb3dd 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -20,6 +20,8 @@
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/xfile.h"
+#include "scrub/repair.h"
+#include "scrub/rtsummary.h"
 
 /*
  * Realtime Summary
@@ -37,8 +39,16 @@ xchk_setup_rtsummary(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	size_t			bufsize = mp->m_sb.sb_blocksize;
+	unsigned int		resblks = 0;
 	int			error;
 
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_rtsummary(sc, &resblks, &bufsize);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Create an xfile to construct a new rtsummary file.  The xfile allows
 	 * us to avoid pinning kernel memory for this purpose.
@@ -48,12 +58,12 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
-	error = xchk_trans_alloc(sc, 0);
+	error = xchk_trans_alloc(sc, resblks);
 	if (error)
 		return error;
 
 	/* Allocate a memory buffer for the summary comparison. */
-	sc->buf = kvmalloc(mp->m_sb.sb_blocksize, XCHK_GFP_FLAGS);
+	sc->buf = kvmalloc(bufsize, XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
 
@@ -78,8 +88,6 @@ xchk_setup_rtsummary(
 
 /* Helper functions to record suminfo words in an xfile. */
 
-typedef unsigned int xchk_rtsumoff_t;
-
 static inline int
 xfsum_load(
 	struct xfs_scrub	*sc,
@@ -100,7 +108,7 @@ xfsum_store(
 			sumoff << XFS_WORDLOG);
 }
 
-static inline int
+inline int
 xfsum_copyout(
 	struct xfs_scrub	*sc,
 	xchk_rtsumoff_t		sumoff,
diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
new file mode 100644
index 000000000000..e5f3c69c4cbf
--- /dev/null
+++ b/fs/xfs/scrub/rtsummary.h
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_RTSUMMARY_H__
+#define __XFS_SCRUB_RTSUMMARY_H__
+
+typedef unsigned int xchk_rtsumoff_t;
+
+int xfsum_copyout(struct xfs_scrub *sc, xchk_rtsumoff_t sumoff,
+		xfs_suminfo_t *info, unsigned int nr_words);
+
+#endif /* __XFS_SCRUB_RTSUMMARY_H__ */
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
new file mode 100644
index 000000000000..f5c14c50ebf3
--- /dev/null
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -0,0 +1,169 @@
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
+#include "xfs_rtalloc.h"
+#include "xfs_inode.h"
+#include "xfs_bit.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_swapext.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempswap.h"
+#include "scrub/reap.h"
+#include "scrub/xfile.h"
+#include "scrub/rtsummary.h"
+
+struct xrep_rtsummary {
+	/* suminfo position of xfile as we write buffers to disk. */
+	xchk_rtsumoff_t		prep_wordoff;
+};
+
+/* Set us up to repair the rtsummary file. */
+int
+xrep_setup_rtsummary(
+	struct xfs_scrub	*sc,
+	unsigned int		*resblks,
+	size_t			*bufsize)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned long long	blocks;
+	int			error;
+
+	*bufsize = max(*bufsize, sizeof(struct xrep_tempswap));
+
+	error = xrep_tempfile_create(sc, S_IFREG);
+	if (error)
+		return error;
+
+	/*
+	 * If we're doing a repair, we reserve enough blocks to write out a
+	 * completely new summary file, plus twice as many blocks as we would
+	 * need if we can only allocate one block per data fork mapping.  This
+	 * should cover the preallocation of the temporary file and swapping
+	 * the extent mappings.
+	 *
+	 * We cannot use xfs_swapext_estimate because we have not yet
+	 * constructed the replacement rtsummary and therefore do not know how
+	 * many extents it will use.  By the time we do, we will have a dirty
+	 * transaction (which we cannot drop because we cannot drop the
+	 * rtsummary ILOCK) and cannot ask for more reservation.
+	 */
+	blocks = XFS_B_TO_FSB(mp, mp->m_rsumsize);
+	blocks += xfs_bmbt_calc_size(mp, blocks) * 2;
+	if (blocks > UINT_MAX)
+		return -EOPNOTSUPP;
+
+	*resblks += blocks;
+
+	/*
+	 * Grab support for atomic extent swapping before we allocate any
+	 * transactions or grab ILOCKs.
+	 */
+	return xrep_tempswap_grab_log_assist(sc);
+}
+
+static int
+xrep_rtsummary_prep_buf(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*bp,
+	void			*data)
+{
+	struct xrep_rtsummary	*rs = data;
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	bp->b_ops = &xfs_rtbuf_ops;
+
+	error = xfsum_copyout(sc, rs->prep_wordoff, bp->b_addr,
+			mp->m_blockwsize);
+	if (error)
+		return error;
+
+	rs->prep_wordoff += mp->m_blockwsize;
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTSUMMARY_BUF);
+	return 0;
+}
+
+/* Repair the realtime summary. */
+int
+xrep_rtsummary(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_rtsummary	rs = { .prep_wordoff = 0, };
+	struct xrep_tempswap	*ti = NULL;
+	xfs_filblks_t		rsumblocks;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_has_rmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
+	/* Make sure any problems with the fork are fixed. */
+	error = xrep_metadata_inode_forks(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Try to take ILOCK_EXCL of the temporary file.  We had better be the
+	 * only ones holding onto this inode, but we can't block while holding
+	 * the rtsummary file's ILOCK_EXCL.
+	 */
+	while (!xrep_tempfile_ilock_nowait(sc)) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+		delay(1);
+	}
+
+	/* Make sure we have space allocated for the entire summary file. */
+	rsumblocks = XFS_B_TO_FSB(sc->mp, sc->mp->m_rsumsize);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+	error = xrep_tempfile_prealloc(sc, 0, rsumblocks);
+	if (error)
+		return error;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	/* Copy the rtsummary file that we generated. */
+	error = xrep_tempfile_copyin(sc, 0, rsumblocks,
+			xrep_rtsummary_prep_buf, &rs);
+	if (error)
+		return error;
+	error = xrep_tempfile_set_isize(sc, sc->mp->m_rsumsize);
+	if (error)
+		return error;
+
+	/*
+	 * Now swap the extents.  Nothing in repair uses the temporary buffer,
+	 * so we can reuse it for the tempfile swapext information.
+	 */
+	ti = sc->buf;
+	error = xrep_tempswap_trans_reserve(sc, XFS_DATA_FORK, ti);
+	if (error)
+		return error;
+
+	error = xrep_tempswap_contents(sc, ti);
+	if (error)
+		return error;
+	ti = NULL;
+
+	/* Free the old rtsummary blocks if they're not in use. */
+	return xrep_reap_ifork(sc, sc->tempip, XFS_DATA_FORK);
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a994710d99ae..a9030603b424 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -19,6 +19,7 @@
 #include "xfs_btree_staging.h"
 #include "xfs_rmap.h"
 #include "xfs_xchgrange.h"
+#include "xfs_swapext.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -358,7 +359,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rtsummary,
 		.scrub	= xchk_rtsummary,
 		.has	= xfs_has_realtime,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtsummary,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
 		.type	= ST_FS,

