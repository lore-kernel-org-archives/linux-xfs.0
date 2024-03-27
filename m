Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D6C1F614
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504715; cv=none; b=BLm3bHV2HOmnhBMvZv4iPtDT8al+JU8+Z1ilbw/Ph4/XU0fVVBn69bNdcyczOHxzIB+HwO3wqhKkptJYmNPriNb2kk5DjOcwEnIqyFJ7HEfKfuuH/BEJhXO3nDdCnFJlFH4BjPTy9q9PuuJaHlo13hyzz7bwM3H32hAGA42naS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504715; c=relaxed/simple;
	bh=tBbphwxVZrYiIO1eKmdHd8RGAibykv4kvpT3oMKMh1k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fvZHRX2pnaXh6OsvSSQ15MrdDvfblVentpJSnJQnIxsthJM/9y8MqeyGFZ0Fb9/EKcBV5y54kw16nU2AFHl4y7rxubKVJmQTS0VeC8vDS8vOmZpdpnlqASVC9QQdVjLxAKtvu3swrR8CfWVbDAzr0WByutXGGE85Px3jjiNa7Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I5rEDYVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I5rEDYVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9C1C433C7;
	Wed, 27 Mar 2024 01:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504715;
	bh=tBbphwxVZrYiIO1eKmdHd8RGAibykv4kvpT3oMKMh1k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I5rEDYVk2Cv43d2a39TVmnanh1IbUbD1UFZwF/eIsOdkKlOt6Wj/RBE/PcKqW0NZj
	 5XU9mSUy1wZiq8gJPLAHliNify0NgDzPxFY+equpcG/QidNCDrr5Cxs88CteIioIeo
	 3soNA7aP1s2dfrlG1TOnSGko6Hqqu7w/KO5dXt/Oj+PnSkg2Az/QEjWPDiogM23yJD
	 9vtsFT40FlOQlAxHcj0uX3FKA0pE09qeU12qwugo7AsXc8Pz7qk3VKUynEvy2nqA6h
	 XAPhNanXkKC3Yc6E8daX9faqKXdB+2jKfxYeex8C8O89GbWXY7mqn8LgxuckOCrXji
	 aoi9hFEkvsiJA==
Date: Tue, 26 Mar 2024 18:58:34 -0700
Subject: [PATCH 3/3] xfs: online repair of realtime summaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171150381736.3217242.4323532338029040508.stgit@frogsfrogsfrogs>
In-Reply-To: <171150381678.3217242.16606238202905878098.stgit@frogsfrogsfrogs>
References: <171150381678.3217242.16606238202905878098.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Repair the realtime summary data by constructing a new rtsummary file in
the scrub temporary file, then atomically swapping the contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/scrub/common.c           |    1 
 fs/xfs/scrub/repair.h           |    3 +
 fs/xfs/scrub/rtsummary.c        |   33 ++++---
 fs/xfs/scrub/rtsummary.h        |   37 ++++++++
 fs/xfs/scrub/rtsummary_repair.c |  177 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c            |    3 -
 7 files changed, 239 insertions(+), 16 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.h
 create mode 100644 fs/xfs/scrub/rtsummary_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ae8488ab4d6b5..5e3ac7ec8fa5b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -212,6 +212,7 @@ xfs-y				+= $(addprefix scrub/, \
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rtbitmap_repair.o \
+				   rtsummary_repair.o \
 				   )
 
 xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index abff79a77c72b..4afaa0a0760c6 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -31,6 +31,7 @@
 #include "xfs_ag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
+#include "xfs_exchmaps.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index ce082d941459f..0e2b695ab8f66 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -126,8 +126,10 @@ int xrep_fscounters(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
+int xrep_rtsummary(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
+# define xrep_rtsummary			xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -212,6 +214,7 @@ xrep_setup_nothing(
 #define xrep_quotacheck			xrep_notsupported
 #define xrep_nlinks			xrep_notsupported
 #define xrep_fscounters			xrep_notsupported
+#define xrep_rtsummary			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 5055092bd9e85..3fee603f52441 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -17,10 +17,14 @@
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
 #include "xfs_sb.h"
+#include "xfs_exchmaps.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/xfile.h"
+#include "scrub/repair.h"
+#include "scrub/tempexch.h"
+#include "scrub/rtsummary.h"
 
 /*
  * Realtime Summary
@@ -32,18 +36,6 @@
  * (potentially large) amount of data in pageable memory.
  */
 
-struct xchk_rtsummary {
-	struct xfs_rtalloc_args	args;
-
-	uint64_t		rextents;
-	uint64_t		rbmblocks;
-	uint64_t		rsumsize;
-	unsigned int		rsumlevels;
-
-	/* Memory buffer for the summary comparison. */
-	union xfs_suminfo_raw	words[];
-};
-
 /* Set us up to check the rtsummary file. */
 int
 xchk_setup_rtsummary(
@@ -60,6 +52,12 @@ xchk_setup_rtsummary(
 		return -ENOMEM;
 	sc->buf = rts;
 
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_rtsummary(sc, rts);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Create an xfile to construct a new rtsummary file.  The xfile allows
 	 * us to avoid pinning kernel memory for this purpose.
@@ -70,7 +68,7 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
-	error = xchk_trans_alloc(sc, 0);
+	error = xchk_trans_alloc(sc, rts->resblks);
 	if (error)
 		return error;
 
@@ -135,7 +133,7 @@ xfsum_store(
 			sumoff << XFS_WORDLOG);
 }
 
-static inline int
+inline int
 xfsum_copyout(
 	struct xfs_scrub	*sc,
 	xfs_rtsumoff_t		sumoff,
@@ -362,7 +360,12 @@ xchk_rtsummary(
 	error = xchk_rtsum_compare(sc);
 
 out_rbm:
-	/* Unlock the rtbitmap since we're done with it. */
+	/*
+	 * Unlock the rtbitmap since we're done with it.  All other writers of
+	 * the rt free space metadata grab the bitmap and summary ILOCKs in
+	 * that order, so we're still protected against allocation activities
+	 * even if we continue on to the repair function.
+	 */
 	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	return error;
 }
diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
new file mode 100644
index 0000000000000..e1d50304d8d48
--- /dev/null
+++ b/fs/xfs/scrub/rtsummary.h
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_RTSUMMARY_H__
+#define __XFS_SCRUB_RTSUMMARY_H__
+
+struct xchk_rtsummary {
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	struct xrep_tempexch	tempexch;
+#endif
+	struct xfs_rtalloc_args	args;
+
+	uint64_t		rextents;
+	uint64_t		rbmblocks;
+	uint64_t		rsumsize;
+	unsigned int		rsumlevels;
+	unsigned int		resblks;
+
+	/* suminfo position of xfile as we write buffers to disk. */
+	xfs_rtsumoff_t		prep_wordoff;
+
+	/* Memory buffer for the summary comparison. */
+	union xfs_suminfo_raw	words[];
+};
+
+int xfsum_copyout(struct xfs_scrub *sc, xfs_rtsumoff_t sumoff,
+		union xfs_suminfo_raw *rawinfo, unsigned int nr_words);
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+int xrep_setup_rtsummary(struct xfs_scrub *sc, struct xchk_rtsummary *rts);
+#else
+# define xrep_setup_rtsummary(sc, rts)	(0)
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif /* __XFS_SCRUB_RTSUMMARY_H__ */
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
new file mode 100644
index 0000000000000..c8bb6c4f15d05
--- /dev/null
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
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
+#include "xfs_exchmaps.h"
+#include "xfs_rtbitmap.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempexch.h"
+#include "scrub/reap.h"
+#include "scrub/xfile.h"
+#include "scrub/rtsummary.h"
+
+/* Set us up to repair the rtsummary file. */
+int
+xrep_setup_rtsummary(
+	struct xfs_scrub	*sc,
+	struct xchk_rtsummary	*rts)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned long long	blocks;
+	int			error;
+
+	error = xrep_tempfile_create(sc, S_IFREG);
+	if (error)
+		return error;
+
+	/*
+	 * If we're doing a repair, we reserve enough blocks to write out a
+	 * completely new summary file, plus twice as many blocks as we would
+	 * need if we can only allocate one block per data fork mapping.  This
+	 * should cover the preallocation of the temporary file and exchanging
+	 * the extent mappings.
+	 *
+	 * We cannot use xfs_exchmaps_estimate because we have not yet
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
+	rts->resblks += blocks;
+
+	/*
+	 * Grab support for atomic file content exchanges before we allocate
+	 * any transactions or grab ILOCKs.
+	 */
+	return xrep_tempexch_enable(sc);
+}
+
+static int
+xrep_rtsummary_prep_buf(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*bp,
+	void			*data)
+{
+	struct xchk_rtsummary	*rts = data;
+	struct xfs_mount	*mp = sc->mp;
+	union xfs_suminfo_raw	*ondisk;
+	int			error;
+
+	rts->args.mp = sc->mp;
+	rts->args.tp = sc->tp;
+	rts->args.sumbp = bp;
+	ondisk = xfs_rsumblock_infoptr(&rts->args, 0);
+	rts->args.sumbp = NULL;
+
+	bp->b_ops = &xfs_rtbuf_ops;
+
+	error = xfsum_copyout(sc, rts->prep_wordoff, ondisk, mp->m_blockwsize);
+	if (error)
+		return error;
+
+	rts->prep_wordoff += mp->m_blockwsize;
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTSUMMARY_BUF);
+	return 0;
+}
+
+/* Repair the realtime summary. */
+int
+xrep_rtsummary(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_rtsummary	*rts = sc->buf;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_filblks_t		rsumblocks;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_has_rmapbt(mp))
+		return -EOPNOTSUPP;
+
+	/* Walk away if we disagree on the size of the rt bitmap. */
+	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks)
+		return 0;
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
+	rsumblocks = XFS_B_TO_FSB(mp, rts->rsumsize);
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
+			xrep_rtsummary_prep_buf, rts);
+	if (error)
+		return error;
+	error = xrep_tempfile_set_isize(sc, rts->rsumsize);
+	if (error)
+		return error;
+
+	/*
+	 * Now exchange the contents.  Nothing in repair uses the temporary
+	 * buffer, so we can reuse it for the tempfile exchrange information.
+	 */
+	error = xrep_tempexch_trans_reserve(sc, XFS_DATA_FORK, &rts->tempexch);
+	if (error)
+		return error;
+
+	error = xrep_tempexch_contents(sc, &rts->tempexch);
+	if (error)
+		return error;
+
+	/* Reset incore state and blow out the summary cache. */
+	if (mp->m_rsum_cache)
+		memset(mp->m_rsum_cache, 0xFF, mp->m_sb.sb_rbmblocks);
+
+	mp->m_rsumlevels = rts->rsumlevels;
+	mp->m_rsumsize = rts->rsumsize;
+
+	/* Free the old rtsummary blocks if they're not in use. */
+	return xrep_reap_ifork(sc, sc->tempip, XFS_DATA_FORK);
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ff156edf49a08..62a064c1a5d34 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -18,6 +18,7 @@
 #include "xfs_buf_mem.h"
 #include "xfs_rmap.h"
 #include "xfs_exchrange.h"
+#include "xfs_exchmaps.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -354,7 +355,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_rtsummary,
 		.scrub	= xchk_rtsummary,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtsummary,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
 		.type	= ST_FS,

