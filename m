Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0F08185F
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OK3jor4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52EAC433C7;
	Wed, 13 Dec 2023 22:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508152;
	bh=PoED5LagyWtSKyKkb1QZKbRw409cq3ie7U3IIkJjhkY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OK3jor4hoiGU3LRVjUdW0tdIEW+TRcmowhzklKw0VmR4ueSQvlLb0sgvRHov1+7QF
	 5umlCTknSchN9voIiVq6hmXz96wRmLBRA+t8FFVePN8RjE39UsBjW6/yX9N502h9Ak
	 INs5hp9/fyYAV3heIfmDyhuQfTOEE7UYrGY6exS0Gs4Pu5gcaJgIuBu4Pl/fTP9eRc
	 rvfkI2Oi/nBIH/7IxkCRVDmXBWFlVcYCXw7gsU3+V4tMeXT7fe6mb++xhsiXTJcohN
	 13p3tO3lSdchzY6NhoL7qzufJdcKenXA05BJ1CJc0iYq9+dQDWWGVlKn7fNkjN8HUS
	 qCc5Qw6TFTiNw==
Date: Wed, 13 Dec 2023 14:55:52 -0800
Subject: [PATCH 1/5] xfs: reintroduce reaping of file metadata blocks to
 xrep_reap_extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783956.1399452.12449607495766249768.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783929.1399452.16224631770180304352.stgit@frogsfrogsfrogs>
References: <170250783929.1399452.16224631770180304352.stgit@frogsfrogsfrogs>
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

Back in commit a55e07308831b ("xfs: only allow reaping of per-AG
blocks in xrep_reap_extents"), we removed from the reaping code the
ability to handle bmbt blocks.  At the time, the reaping code only
walked single blocks, didn't correctly detect crosslinked blocks, and
the special casing made the function hard to understand.  It was easier
to remove unneeded functionality prior to fixing all the bugs.

Now that we've fixed the problems, we want again the ability to reap
file metadata blocks.  Reintroduce the per-file reaping functionality
atop the current implementation.  We require that sc->sa is
uninitialized, so that we can use it to hold all the per-AG context for
a given extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/fsb_bitmap.h |   37 ++++++++++++++
 fs/xfs/scrub/reap.c       |  121 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/reap.h       |    5 ++
 fs/xfs/scrub/repair.h     |    1 
 4 files changed, 160 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/fsb_bitmap.h


diff --git a/fs/xfs/scrub/fsb_bitmap.h b/fs/xfs/scrub/fsb_bitmap.h
new file mode 100644
index 000000000000..40b462c1dd0d
--- /dev/null
+++ b/fs/xfs/scrub/fsb_bitmap.h
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_FSB_BITMAP_H__
+#define __XFS_SCRUB_FSB_BITMAP_H__
+
+/* Bitmaps, but for type-checked for xfs_fsblock_t */
+
+struct xfsb_bitmap {
+	struct xbitmap64	fsbitmap;
+};
+
+static inline void xfsb_bitmap_init(struct xfsb_bitmap *bitmap)
+{
+	xbitmap64_init(&bitmap->fsbitmap);
+}
+
+static inline void xfsb_bitmap_destroy(struct xfsb_bitmap *bitmap)
+{
+	xbitmap64_destroy(&bitmap->fsbitmap);
+}
+
+static inline int xfsb_bitmap_set(struct xfsb_bitmap *bitmap,
+		xfs_fsblock_t start, xfs_filblks_t len)
+{
+	return xbitmap64_set(&bitmap->fsbitmap, start, len);
+}
+
+static inline int xfsb_bitmap_walk(struct xfsb_bitmap *bitmap,
+		xbitmap64_walk_fn fn, void *priv)
+{
+	return xbitmap64_walk(&bitmap->fsbitmap, fn, priv);
+}
+
+#endif	/* __XFS_SCRUB_FSB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 80032065d700..b9069c6e57a0 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -38,6 +38,7 @@
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
 #include "scrub/agb_bitmap.h"
+#include "scrub/fsb_bitmap.h"
 #include "scrub/reap.h"
 
 /*
@@ -75,10 +76,10 @@
  * with only the same rmap owner but the block is not owned by something with
  * the same rmap owner, the block will be freed.
  *
- * The caller is responsible for locking the AG headers for the entire rebuild
- * operation so that nothing else can sneak in and change the AG state while
- * we're not looking.  We must also invalidate any buffers associated with
- * @bitmap.
+ * The caller is responsible for locking the AG headers/inode for the entire
+ * rebuild operation so that nothing else can sneak in and change the incore
+ * state while we're not looking.  We must also invalidate any buffers
+ * associated with @bitmap.
  */
 
 /* Information about reaping extents after a repair. */
@@ -501,3 +502,115 @@ xrep_reap_agblocks(
 
 	return 0;
 }
+
+/*
+ * Break a file metadata extent into sub-extents by fate (crosslinked, not
+ * crosslinked), and dispose of each sub-extent separately.  The extent must
+ * not cross an AG boundary.
+ */
+STATIC int
+xreap_fsmeta_extent(
+	uint64_t		fsbno,
+	uint64_t		len,
+	void			*priv)
+{
+	struct xreap_state	*rs = priv;
+	struct xfs_scrub	*sc = rs->sc;
+	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
+	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+	xfs_agblock_t		agbno_next = agbno + len;
+	int			error = 0;
+
+	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
+	ASSERT(sc->ip != NULL);
+	ASSERT(!sc->sa.pag);
+
+	/*
+	 * We're reaping blocks after repairing file metadata, which means that
+	 * we have to init the xchk_ag structure ourselves.
+	 */
+	sc->sa.pag = xfs_perag_get(sc->mp, agno);
+	if (!sc->sa.pag)
+		return -EFSCORRUPTED;
+
+	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &sc->sa.agf_bp);
+	if (error)
+		goto out_pag;
+
+	while (agbno < agbno_next) {
+		xfs_extlen_t	aglen;
+		bool		crosslinked;
+
+		error = xreap_agextent_select(rs, agbno, agbno_next,
+				&crosslinked, &aglen);
+		if (error)
+			goto out_agf;
+
+		error = xreap_agextent_iter(rs, agbno, &aglen, crosslinked);
+		if (error)
+			goto out_agf;
+
+		if (xreap_want_defer_finish(rs)) {
+			/*
+			 * Holds the AGF buffer across the deferred chain
+			 * processing.
+			 */
+			error = xrep_defer_finish(sc);
+			if (error)
+				goto out_agf;
+			xreap_defer_finish_reset(rs);
+		} else if (xreap_want_roll(rs)) {
+			/*
+			 * Hold the AGF buffer across the transaction roll so
+			 * that we don't have to reattach it to the scrub
+			 * context.
+			 */
+			xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
+			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+			xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
+			if (error)
+				goto out_agf;
+			xreap_reset(rs);
+		}
+
+		agbno += aglen;
+	}
+
+out_agf:
+	xfs_trans_brelse(sc->tp, sc->sa.agf_bp);
+	sc->sa.agf_bp = NULL;
+out_pag:
+	xfs_perag_put(sc->sa.pag);
+	sc->sa.pag = NULL;
+	return error;
+}
+
+/*
+ * Dispose of every block of every fs metadata extent in the bitmap.
+ * Do not use this to dispose of the mappings in an ondisk inode fork.
+ */
+int
+xrep_reap_fsblocks(
+	struct xfs_scrub		*sc,
+	struct xfsb_bitmap		*bitmap,
+	const struct xfs_owner_info	*oinfo)
+{
+	struct xreap_state		rs = {
+		.sc			= sc,
+		.oinfo			= oinfo,
+		.resv			= XFS_AG_RESV_NONE,
+	};
+	int				error;
+
+	ASSERT(xfs_has_rmapbt(sc->mp));
+	ASSERT(sc->ip != NULL);
+
+	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
+	if (error)
+		return error;
+
+	if (xreap_dirty(&rs))
+		return xrep_defer_finish(sc);
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index fe24626af164..0b69f16dd98f 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -6,7 +6,12 @@
 #ifndef __XFS_SCRUB_REAP_H__
 #define __XFS_SCRUB_REAP_H__
 
+struct xagb_bitmap;
+struct xfsb_bitmap;
+
 int xrep_reap_agblocks(struct xfs_scrub *sc, struct xagb_bitmap *bitmap,
 		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
+int xrep_reap_fsblocks(struct xfs_scrub *sc, struct xfsb_bitmap *bitmap,
+		const struct xfs_owner_info *oinfo);
 
 #endif /* __XFS_SCRUB_REAP_H__ */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index a513b84f5330..d4ef740c878f 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -48,6 +48,7 @@ xrep_trans_commit(
 
 struct xbitmap;
 struct xagb_bitmap;
+struct xfsb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
 

