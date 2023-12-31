Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E009F9CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0old2M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDD1C433C7;
	Sun, 31 Dec 2023 21:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059684;
	bh=63KsGTUQmtVOV0315Krqy30xUHhFdvQrjj0iiOwAh/I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U0old2M0xhLXRuzV5aT6uPYejyvIBQJbvTHmOq5j1XJUDo/l1yBQbfDZ1gkKHuewZ
	 5SN1RBp+Btas/WHC4B0ISVtFHSw+VGCB/UNp1ur1lUApzu06IYM4pRUircX5RN9SRP
	 R1Cpwksnvp2akT+7CrCzs8lnILwFzJ0nWhffNoAtSpepks6gVc2UBoPDkqlqUUqvrK
	 30fWxM5hz7ouYe+hEWpH/zgMayetYLEmmnUVEDEHUOMaRu8y4/6mgc7u3eL2ym8G6D
	 WCbVcNmMhyrptShjfXWdHnnmlt87/SGEZV+mUitKZO5Lv3fiLDMsCbP6VDTtS12lZn
	 Y2Otzxik3HPtg==
Date: Sun, 31 Dec 2023 13:54:44 -0800
Subject: [PATCH 39/44] xfs: capture realtime CoW staging extents when
 rebuilding rt rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852207.1766284.3176388270914377798.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Walk the realtime refcount btree to find the CoW staging extents when
we're rebuilding the realtime rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.h        |    1 
 fs/xfs/scrub/rgb_bitmap.h    |   37 +++++++++++++++
 fs/xfs/scrub/rtrmap_repair.c |  103 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)
 create mode 100644 fs/xfs/scrub/rgb_bitmap.h


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index a382ba0478aa0..61c6bc31a266b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -49,6 +49,7 @@ xrep_trans_commit(
 
 struct xbitmap;
 struct xagb_bitmap;
+struct xrgb_bitmap;
 struct xfsb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, int alloc_flags);
diff --git a/fs/xfs/scrub/rgb_bitmap.h b/fs/xfs/scrub/rgb_bitmap.h
new file mode 100644
index 0000000000000..47a5caf3a230d
--- /dev/null
+++ b/fs/xfs/scrub/rgb_bitmap.h
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_RGB_BITMAP_H__
+#define __XFS_SCRUB_RGB_BITMAP_H__
+
+/* Bitmaps, but for type-checked for xfs_rgblock_t */
+
+struct xrgb_bitmap {
+	struct xbitmap32	rgbitmap;
+};
+
+static inline void xrgb_bitmap_init(struct xrgb_bitmap *bitmap)
+{
+	xbitmap32_init(&bitmap->rgbitmap);
+}
+
+static inline void xrgb_bitmap_destroy(struct xrgb_bitmap *bitmap)
+{
+	xbitmap32_destroy(&bitmap->rgbitmap);
+}
+
+static inline int xrgb_bitmap_set(struct xrgb_bitmap *bitmap,
+		xfs_rgblock_t start, xfs_extlen_t len)
+{
+	return xbitmap32_set(&bitmap->rgbitmap, start, len);
+}
+
+static inline int xrgb_bitmap_walk(struct xrgb_bitmap *bitmap,
+		xbitmap32_walk_fn fn, void *priv)
+{
+	return xbitmap32_walk(&bitmap->rgbitmap, fn, priv);
+}
+
+#endif	/* __XFS_SCRUB_RGB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 42df1cf45ae0b..a40afa571b981 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -29,6 +29,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_ag.h"
 #include "xfs_rtgroup.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -37,6 +38,7 @@
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
 #include "scrub/fsb_bitmap.h"
+#include "scrub/rgb_bitmap.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
@@ -436,6 +438,100 @@ xrep_rtrmap_scan_ag(
 	return error;
 }
 
+struct xrep_rtrmap_stash_run {
+	struct xrep_rtrmap	*rr;
+	uint64_t		owner;
+};
+
+static int
+xrep_rtrmap_stash_run(
+	uint32_t			start,
+	uint32_t			len,
+	void				*priv)
+{
+	struct xrep_rtrmap_stash_run	*rsr = priv;
+	struct xrep_rtrmap		*rr = rsr->rr;
+	xfs_rgblock_t			rgbno = start;
+
+	return xrep_rtrmap_stash(rr, rgbno, len, rsr->owner, 0, 0);
+}
+
+/*
+ * Emit rmaps for every extent of bits set in the bitmap.  Caller must ensure
+ * that the ranges are in units of FS blocks.
+ */
+STATIC int
+xrep_rtrmap_stash_bitmap(
+	struct xrep_rtrmap		*rr,
+	struct xrgb_bitmap		*bitmap,
+	const struct xfs_owner_info	*oinfo)
+{
+	struct xrep_rtrmap_stash_run	rsr = {
+		.rr			= rr,
+		.owner			= oinfo->oi_owner,
+	};
+
+	return xrgb_bitmap_walk(bitmap, xrep_rtrmap_stash_run, &rsr);
+}
+
+/* Record a CoW staging extent. */
+STATIC int
+xrep_rtrmap_walk_cowblocks(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*irec,
+	void				*priv)
+{
+	struct xrgb_bitmap		*bitmap = priv;
+
+	if (!xfs_refcount_check_domain(irec) ||
+	    irec->rc_domain != XFS_REFC_DOMAIN_COW)
+		return -EFSCORRUPTED;
+
+	return xrgb_bitmap_set(bitmap, irec->rc_startblock,
+			irec->rc_blockcount);
+}
+
+/*
+ * Collect rmaps for the blocks containing the refcount btree, and all CoW
+ * staging extents.
+ */
+STATIC int
+xrep_rtrmap_find_refcount_rmaps(
+	struct xrep_rtrmap	*rr)
+{
+	struct xrgb_bitmap	cow_blocks;		/* COWBIT */
+	struct xfs_refcount_irec low = {
+		.rc_startblock	= 0,
+		.rc_domain	= XFS_REFC_DOMAIN_COW,
+	};
+	struct xfs_refcount_irec high = {
+		.rc_startblock	= -1U,
+		.rc_domain	= XFS_REFC_DOMAIN_COW,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	int			error;
+
+	if (!xfs_has_rtreflink(sc->mp))
+		return 0;
+
+	xrgb_bitmap_init(&cow_blocks);
+
+	/* Collect rmaps for CoW staging extents. */
+	error = xfs_refcount_query_range(sc->sr.refc_cur, &low, &high,
+			xrep_rtrmap_walk_cowblocks, &cow_blocks);
+	if (error)
+		goto out_bitmap;
+
+	/* Generate rmaps for everything. */
+	error = xrep_rtrmap_stash_bitmap(rr, &cow_blocks, &XFS_RMAP_OINFO_COW);
+	if (error)
+		goto out_bitmap;
+
+out_bitmap:
+	xrgb_bitmap_destroy(&cow_blocks);
+	return error;
+}
+
 /* Count and check all collected records. */
 STATIC int
 xrep_rtrmap_check_record(
@@ -483,6 +579,13 @@ xrep_rtrmap_find_rmaps(
 	if (error)
 		return error;
 
+	/* Find CoW staging extents. */
+	xrep_rtgroup_btcur_init(sc, &sc->sr);
+	error = xrep_rtrmap_find_refcount_rmaps(rr);
+	xchk_rtgroup_btcur_free(&sc->sr);
+	if (error)
+		return error;
+
 	/*
 	 * Set up for a potentially lengthy filesystem scan by reducing our
 	 * transaction resource usage for the duration.  Specifically:

