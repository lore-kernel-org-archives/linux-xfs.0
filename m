Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E859BC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjEZBaZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjEZBaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FA1125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 700D561553
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17E5C433D2;
        Fri, 26 May 2023 01:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064621;
        bh=ChKk5j71KZbtWSwxvQ3aM6feLTAV5/z5gs7WZ+PYqV0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=MStGswJg08znq9IZHNuTRWZeXKm3GCrUHhLIzrDVlZKnaT/JOQa5FYTdxTZD0kCWm
         9gwJ9ePapE4L+HbPZsVBNgOBEwmUPSRftBT3I4zYp0Fq6CqbbouKDTWABaIjTWoA9n
         KiX9eMq3jYMycqalsOyK2a3tihX22V6qG75v6LQR+CzpZzrZ16KUgQqI8AQ/+actNM
         gIUKs+967CYveDEc/6gODi2MCGwfijuqYc1SV6R+1rsDTif9tpw+UFpkvtvYt3Lj6O
         1C1yUFe5wvifhCOfQGTuYjqEXmPFpxVAAhOPT1pRs9xUz+IWZEh7jJJ3FrykAAINRu
         ixz1LagOzH8Pw==
Date:   Thu, 25 May 2023 18:30:21 -0700
Subject: [PATCH 3/3] xfs: online repair of realtime summaries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066054.3735250.10894397556258007700.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066008.3735250.5566316565558388079.stgit@frogsfrogsfrogs>
References: <168506066008.3735250.5566316565558388079.stgit@frogsfrogsfrogs>
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
index 3f0b2bd87f7d..9e3d2fdfb9d7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -209,6 +209,7 @@ xfs-y				+= $(addprefix scrub/, \
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rtbitmap_repair.o \
+				   rtsummary_repair.o \
 				   )
 
 xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 6f505e9fb07f..bdb4089911d8 100644
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
index c289855c615d..2af25ad31fc7 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -81,6 +81,8 @@ int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 bool xrep_set_nlink(struct xfs_inode *ip, uint64_t nlink);
 int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
 int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
+int xrep_setup_rtsummary(struct xfs_scrub *sc, unsigned int *resblks,
+		size_t *bufsize);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -118,8 +120,10 @@ int xrep_fscounters(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
+int xrep_rtsummary(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
+# define xrep_rtsummary			xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -187,6 +191,15 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
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
 
@@ -208,6 +221,7 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_quotacheck			xrep_notsupported
 #define xrep_nlinks			xrep_notsupported
 #define xrep_fscounters			xrep_notsupported
+#define xrep_rtsummary			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 9da732698d2e..fc8a93c3a26b 100644
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
index 000000000000..8c61fda80830
--- /dev/null
+++ b/fs/xfs/scrub/rtsummary.h
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020-2023 Oracle.  All Rights Reserved.
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
index 000000000000..28527454d67a
--- /dev/null
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -0,0 +1,169 @@
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
index 0bfa9a076582..17d93bea6d64 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -20,6 +20,7 @@
 #include "xfs_buf_xfile.h"
 #include "xfs_rmap.h"
 #include "xfs_xchgrange.h"
+#include "xfs_swapext.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -360,7 +361,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rtsummary,
 		.scrub	= xchk_rtsummary,
 		.has	= xfs_has_realtime,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtsummary,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
 		.type	= ST_FS,

