Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1273413FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995772; cv=none; b=R2KziC/PKOcj+vlupIYjE9iazmGK0OS+m+H2pNSIUktKSOw4TwVwft/3Y4xBofMrtt+U5xD6Bh0jSdjGLicYSeRMnjW5A0OMQBXdJZ/9wMuAc9MT9hqzc0C1B7NyCdh5WQA3+xoo+CzpKk/kPPt2/uc1KgeEm8nfXoH33CAhUt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995772; c=relaxed/simple;
	bh=KrhceEEF88kH0EsL+4vhISSo4eFG5AeSgY7uNd/+kQU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJ7XcjyoxSbfYBWLGv7Rn84i0fIM6t6xYArdHeKzF+zsdNTgPF9pX2BDFbGWkZdrtb8yjOwoCnfhESxbniuui2wnubjpRv0NaDvSghtVu0u16n9uqTqXoKLNmk5rtUNsKisEUWppnGH9x8AuWy5Fg0DoEEfdKzgP+wKtgYyHPNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnpIbJAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnpIbJAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C56C4CED3;
	Mon, 23 Dec 2024 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995771;
	bh=KrhceEEF88kH0EsL+4vhISSo4eFG5AeSgY7uNd/+kQU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mnpIbJAwqYoS/hFEl/WR6zP+m3oFQXBrYlg1GQ6L/lGPE8dD9RYBlrImNQmFGNIKx
	 bgIU8FTMIk6U6mBUYdHwu3nociELXEVqFxtuIrkbhbCCrapVvCLbjPkxWkthkNUiiF
	 6w6vv9Cc3VkrqaFd3VKbw9aAtvMV14IqG+I4K18+5cY4Pe1mKgQ7gGVMFwQESFGk8Q
	 Wm7hpaIV3i49nnXl/o5JYrIAk/X1sBnuaCY2BY1FIEdj6oqeGpVAMhYR3bcmNK6QmR
	 ioDlzUnpBRMTZCMyWGRAW/zUeWVAmD+qVnu1Br8o+cjQEYxq8KmrwI7JVIG8/dM08T
	 So6EBMWKG3NEA==
Date: Mon, 23 Dec 2024 15:16:11 -0800
Subject: [PATCH 38/43] xfs: capture realtime CoW staging extents when
 rebuilding rt rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420588.2381378.14487972570841058160.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.h        |    1 
 fs/xfs/scrub/rgb_bitmap.h    |   37 +++++++++++++++
 fs/xfs/scrub/rtrmap_repair.c |  103 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)
 create mode 100644 fs/xfs/scrub/rgb_bitmap.h


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index ac5962732d269d..77343813205375 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -50,6 +50,7 @@ xrep_trans_commit(
 
 struct xbitmap;
 struct xagb_bitmap;
+struct xrgb_bitmap;
 struct xfsb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, int alloc_flags);
diff --git a/fs/xfs/scrub/rgb_bitmap.h b/fs/xfs/scrub/rgb_bitmap.h
new file mode 100644
index 00000000000000..4c3126b66dcb96
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
+#endif /* __XFS_SCRUB_RGB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 49de8bc2dd17f5..f2fdd7a9fc2483 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -30,6 +30,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_ag.h"
 #include "xfs_rtgroup.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -38,6 +39,7 @@
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
 #include "scrub/fsb_bitmap.h"
+#include "scrub/rgb_bitmap.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
@@ -423,6 +425,100 @@ xrep_rtrmap_scan_ag(
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
@@ -460,6 +556,13 @@ xrep_rtrmap_find_rmaps(
 			return error;
 	}
 
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

