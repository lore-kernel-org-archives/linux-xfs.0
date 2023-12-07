Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E58137F
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tUC7Ql+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0AAC433C7;
	Thu,  7 Dec 2023 02:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916824;
	bh=jry+iCI7ktm12dh+wkZe1izWMlWNYJb6Nohds7cBCgc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tUC7Ql+qLvPJN2FaRbYFZ9YYm77W3mpGoMXsoU9A2OmNNa5sYO/JI9nAaI1hL2Nlr
	 q2MoE+lZAyaFA8FdPjmNzZpsvWr/wLT6veBgNUloZ4q+Po4k3ClRMCeBix6oYucH0K
	 Bht8d4NxHbE/7dCdv5QnZj42gaqeO9WVISFfLp0yRDON3P+4qy309HIdqVdWxIsmk4
	 Jrif+POfMFVPY6li/Zn5y4o0enKpfFq5tVIxguyIabEG65yDLrDBnoWTbq0lBy3SwI
	 yZ0JqbWN8BMOwxiEidwmtswRJ0U8d033+YhFC2pMOtRy/9XWj7JTlYITz5CE9zx3GC
	 ZBVwm7X/pRRNg==
Date: Wed, 06 Dec 2023 18:40:23 -0800
Subject: [PATCH 2/7] xfs: move the per-AG datatype bitmaps to separate files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191665649.1181880.7564445102317360980.stgit@frogsfrogsfrogs>
In-Reply-To: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
References: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
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

Move struct xagb_bitmap to its own pair of C and header files per
request of Christoph.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/scrub/agb_bitmap.c      |  103 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/agb_bitmap.h      |   68 ++++++++++++++++++++++++++
 fs/xfs/scrub/agheader_repair.c |    1 
 fs/xfs/scrub/bitmap.c          |   91 -----------------------------------
 fs/xfs/scrub/bitmap.h          |   59 -----------------------
 fs/xfs/scrub/reap.c            |    1 
 fs/xfs/scrub/rmap.c            |    1 
 8 files changed, 175 insertions(+), 150 deletions(-)
 create mode 100644 fs/xfs/scrub/agb_bitmap.c
 create mode 100644 fs/xfs/scrub/agb_bitmap.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 1537d66e5ab01..eb557dca93730 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -145,6 +145,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 
 xfs-y				+= $(addprefix scrub/, \
 				   trace.o \
+				   agb_bitmap.o \
 				   agheader.o \
 				   alloc.o \
 				   attr.o \
diff --git a/fs/xfs/scrub/agb_bitmap.c b/fs/xfs/scrub/agb_bitmap.c
new file mode 100644
index 0000000000000..573e4e0627546
--- /dev/null
+++ b/fs/xfs/scrub/agb_bitmap.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_bit.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "bitmap.h"
+#include "scrub/agb_bitmap.h"
+
+/*
+ * Record all btree blocks seen while iterating all records of a btree.
+ *
+ * We know that the btree query_all function starts at the left edge and walks
+ * towards the right edge of the tree.  Therefore, we know that we can walk up
+ * the btree cursor towards the root; if the pointer for a given level points
+ * to the first record/key in that block, we haven't seen this block before;
+ * and therefore we need to remember that we saw this block in the btree.
+ *
+ * So if our btree is:
+ *
+ *    4
+ *  / | \
+ * 1  2  3
+ *
+ * Pretend for this example that each leaf block has 100 btree records.  For
+ * the first btree record, we'll observe that bc_levels[0].ptr == 1, so we
+ * record that we saw block 1.  Then we observe that bc_levels[1].ptr == 1, so
+ * we record block 4.  The list is [1, 4].
+ *
+ * For the second btree record, we see that bc_levels[0].ptr == 2, so we exit
+ * the loop.  The list remains [1, 4].
+ *
+ * For the 101st btree record, we've moved onto leaf block 2.  Now
+ * bc_levels[0].ptr == 1 again, so we record that we saw block 2.  We see that
+ * bc_levels[1].ptr == 2, so we exit the loop.  The list is now [1, 4, 2].
+ *
+ * For the 102nd record, bc_levels[0].ptr == 2, so we continue.
+ *
+ * For the 201st record, we've moved on to leaf block 3.
+ * bc_levels[0].ptr == 1, so we add 3 to the list.  Now it is [1, 4, 2, 3].
+ *
+ * For the 300th record we just exit, with the list being [1, 4, 2, 3].
+ */
+
+/* Mark a btree block to the agblock bitmap. */
+STATIC int
+xagb_bitmap_visit_btblock(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*priv)
+{
+	struct xagb_bitmap	*bitmap = priv;
+	struct xfs_buf		*bp;
+	xfs_fsblock_t		fsbno;
+	xfs_agblock_t		agbno;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
+	agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
+
+	return xagb_bitmap_set(bitmap, agbno, 1);
+}
+
+/* Mark all (per-AG) btree blocks in the agblock bitmap. */
+int
+xagb_bitmap_set_btblocks(
+	struct xagb_bitmap	*bitmap,
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_btree_visit_blocks(cur, xagb_bitmap_visit_btblock,
+			XFS_BTREE_VISIT_ALL, bitmap);
+}
+
+/*
+ * Record all the buffers pointed to by the btree cursor.  Callers already
+ * engaged in a btree walk should call this function to capture the list of
+ * blocks going from the leaf towards the root.
+ */
+int
+xagb_bitmap_set_btcur_path(
+	struct xagb_bitmap	*bitmap,
+	struct xfs_btree_cur	*cur)
+{
+	int			i;
+	int			error;
+
+	for (i = 0; i < cur->bc_nlevels && cur->bc_levels[i].ptr == 1; i++) {
+		error = xagb_bitmap_visit_btblock(cur, i, bitmap);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/agb_bitmap.h b/fs/xfs/scrub/agb_bitmap.h
new file mode 100644
index 0000000000000..ed08f76ff4f3a
--- /dev/null
+++ b/fs/xfs/scrub/agb_bitmap.h
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_AGB_BITMAP_H__
+#define __XFS_SCRUB_AGB_BITMAP_H__
+
+/* Bitmaps, but for type-checked for xfs_agblock_t */
+
+struct xagb_bitmap {
+	struct xbitmap32	agbitmap;
+};
+
+static inline void xagb_bitmap_init(struct xagb_bitmap *bitmap)
+{
+	xbitmap32_init(&bitmap->agbitmap);
+}
+
+static inline void xagb_bitmap_destroy(struct xagb_bitmap *bitmap)
+{
+	xbitmap32_destroy(&bitmap->agbitmap);
+}
+
+static inline int xagb_bitmap_clear(struct xagb_bitmap *bitmap,
+		xfs_agblock_t start, xfs_extlen_t len)
+{
+	return xbitmap32_clear(&bitmap->agbitmap, start, len);
+}
+static inline int xagb_bitmap_set(struct xagb_bitmap *bitmap,
+		xfs_agblock_t start, xfs_extlen_t len)
+{
+	return xbitmap32_set(&bitmap->agbitmap, start, len);
+}
+
+static inline bool xagb_bitmap_test(struct xagb_bitmap *bitmap,
+		xfs_agblock_t start, xfs_extlen_t *len)
+{
+	return xbitmap32_test(&bitmap->agbitmap, start, len);
+}
+
+static inline int xagb_bitmap_disunion(struct xagb_bitmap *bitmap,
+		struct xagb_bitmap *sub)
+{
+	return xbitmap32_disunion(&bitmap->agbitmap, &sub->agbitmap);
+}
+
+static inline uint32_t xagb_bitmap_hweight(struct xagb_bitmap *bitmap)
+{
+	return xbitmap32_hweight(&bitmap->agbitmap);
+}
+static inline bool xagb_bitmap_empty(struct xagb_bitmap *bitmap)
+{
+	return xbitmap32_empty(&bitmap->agbitmap);
+}
+
+static inline int xagb_bitmap_walk(struct xagb_bitmap *bitmap,
+		xbitmap32_walk_fn fn, void *priv)
+{
+	return xbitmap32_walk(&bitmap->agbitmap, fn, priv);
+}
+
+int xagb_bitmap_set_btblocks(struct xagb_bitmap *bitmap,
+		struct xfs_btree_cur *cur);
+int xagb_bitmap_set_btcur_path(struct xagb_bitmap *bitmap,
+		struct xfs_btree_cur *cur);
+
+#endif	/* __XFS_SCRUB_AGB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 4000bdc8b500e..52956c0b8f79a 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -26,6 +26,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
+#include "scrub/agb_bitmap.h"
 #include "scrub/reap.h"
 
 /* Superblock */
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 503b79010002d..1449bb5262d95 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -566,94 +566,3 @@ xbitmap32_test(
 	*len = bn->bn_start - start;
 	return false;
 }
-
-/* xfs_agblock_t bitmap */
-
-/*
- * Record all btree blocks seen while iterating all records of a btree.
- *
- * We know that the btree query_all function starts at the left edge and walks
- * towards the right edge of the tree.  Therefore, we know that we can walk up
- * the btree cursor towards the root; if the pointer for a given level points
- * to the first record/key in that block, we haven't seen this block before;
- * and therefore we need to remember that we saw this block in the btree.
- *
- * So if our btree is:
- *
- *    4
- *  / | \
- * 1  2  3
- *
- * Pretend for this example that each leaf block has 100 btree records.  For
- * the first btree record, we'll observe that bc_levels[0].ptr == 1, so we
- * record that we saw block 1.  Then we observe that bc_levels[1].ptr == 1, so
- * we record block 4.  The list is [1, 4].
- *
- * For the second btree record, we see that bc_levels[0].ptr == 2, so we exit
- * the loop.  The list remains [1, 4].
- *
- * For the 101st btree record, we've moved onto leaf block 2.  Now
- * bc_levels[0].ptr == 1 again, so we record that we saw block 2.  We see that
- * bc_levels[1].ptr == 2, so we exit the loop.  The list is now [1, 4, 2].
- *
- * For the 102nd record, bc_levels[0].ptr == 2, so we continue.
- *
- * For the 201st record, we've moved on to leaf block 3.
- * bc_levels[0].ptr == 1, so we add 3 to the list.  Now it is [1, 4, 2, 3].
- *
- * For the 300th record we just exit, with the list being [1, 4, 2, 3].
- */
-
-/* Mark a btree block to the agblock bitmap. */
-STATIC int
-xagb_bitmap_visit_btblock(
-	struct xfs_btree_cur	*cur,
-	int			level,
-	void			*priv)
-{
-	struct xagb_bitmap	*bitmap = priv;
-	struct xfs_buf		*bp;
-	xfs_fsblock_t		fsbno;
-	xfs_agblock_t		agbno;
-
-	xfs_btree_get_block(cur, level, &bp);
-	if (!bp)
-		return 0;
-
-	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
-	agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-
-	return xagb_bitmap_set(bitmap, agbno, 1);
-}
-
-/* Mark all (per-AG) btree blocks in the agblock bitmap. */
-int
-xagb_bitmap_set_btblocks(
-	struct xagb_bitmap	*bitmap,
-	struct xfs_btree_cur	*cur)
-{
-	return xfs_btree_visit_blocks(cur, xagb_bitmap_visit_btblock,
-			XFS_BTREE_VISIT_ALL, bitmap);
-}
-
-/*
- * Record all the buffers pointed to by the btree cursor.  Callers already
- * engaged in a btree walk should call this function to capture the list of
- * blocks going from the leaf towards the root.
- */
-int
-xagb_bitmap_set_btcur_path(
-	struct xagb_bitmap	*bitmap,
-	struct xfs_btree_cur	*cur)
-{
-	int			i;
-	int			error;
-
-	for (i = 0; i < cur->bc_nlevels && cur->bc_levels[i].ptr == 1; i++) {
-		error = xagb_bitmap_visit_btblock(cur, i, bitmap);
-		if (error)
-			return error;
-	}
-
-	return 0;
-}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 231b27c09b4ed..2df8911606d6d 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -62,63 +62,4 @@ int xbitmap32_walk(struct xbitmap32 *bitmap, xbitmap32_walk_fn fn,
 bool xbitmap32_empty(struct xbitmap32 *bitmap);
 bool xbitmap32_test(struct xbitmap32 *bitmap, uint32_t start, uint32_t *len);
 
-/* Bitmaps, but for type-checked for xfs_agblock_t */
-
-struct xagb_bitmap {
-	struct xbitmap32	agbitmap;
-};
-
-static inline void xagb_bitmap_init(struct xagb_bitmap *bitmap)
-{
-	xbitmap32_init(&bitmap->agbitmap);
-}
-
-static inline void xagb_bitmap_destroy(struct xagb_bitmap *bitmap)
-{
-	xbitmap32_destroy(&bitmap->agbitmap);
-}
-
-static inline int xagb_bitmap_clear(struct xagb_bitmap *bitmap,
-		xfs_agblock_t start, xfs_extlen_t len)
-{
-	return xbitmap32_clear(&bitmap->agbitmap, start, len);
-}
-static inline int xagb_bitmap_set(struct xagb_bitmap *bitmap,
-		xfs_agblock_t start, xfs_extlen_t len)
-{
-	return xbitmap32_set(&bitmap->agbitmap, start, len);
-}
-
-static inline bool xagb_bitmap_test(struct xagb_bitmap *bitmap,
-		xfs_agblock_t start, xfs_extlen_t *len)
-{
-	return xbitmap32_test(&bitmap->agbitmap, start, len);
-}
-
-static inline int xagb_bitmap_disunion(struct xagb_bitmap *bitmap,
-		struct xagb_bitmap *sub)
-{
-	return xbitmap32_disunion(&bitmap->agbitmap, &sub->agbitmap);
-}
-
-static inline uint32_t xagb_bitmap_hweight(struct xagb_bitmap *bitmap)
-{
-	return xbitmap32_hweight(&bitmap->agbitmap);
-}
-static inline bool xagb_bitmap_empty(struct xagb_bitmap *bitmap)
-{
-	return xbitmap32_empty(&bitmap->agbitmap);
-}
-
-static inline int xagb_bitmap_walk(struct xagb_bitmap *bitmap,
-		xbitmap32_walk_fn fn, void *priv)
-{
-	return xbitmap32_walk(&bitmap->agbitmap, fn, priv);
-}
-
-int xagb_bitmap_set_btblocks(struct xagb_bitmap *bitmap,
-		struct xfs_btree_cur *cur);
-int xagb_bitmap_set_btcur_path(struct xagb_bitmap *bitmap,
-		struct xfs_btree_cur *cur);
-
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index c8c8e3f9bc7a4..80032065d700b 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -37,6 +37,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
+#include "scrub/agb_bitmap.h"
 #include "scrub/reap.h"
 
 /*
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index d29a26ecddd60..c99d1714f283b 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -24,6 +24,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/bitmap.h"
+#include "scrub/agb_bitmap.h"
 
 /*
  * Set us up to scrub reverse mapping btrees.

