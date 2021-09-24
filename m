Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0842C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A912F61211
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243765AbhIXB31 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243758AbhIXB30 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FA2D604E9;
        Fri, 24 Sep 2021 01:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446874;
        bh=/O/f61Bf8sClyzjeGb1YJkWgzE4+RlkiaqGygZwLdlU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ux6lQW0GwbnMwcNZmR39t/NJ6WpvgUOuDOV4XLU/RnZH0psf4Ef7kHWv9f5W6Vakp
         F/86/cs/j6rCmUCQX095DnPYe0yE7hVXioxcKpLPAe7uN7h3Vj5AQAjkbzD+24WB2+
         yOkY7RWJ7wFnxJ/ILOkafUeTvd0/aTqTW7CZQgrcRCUffo/+uiaIT6j/1cIu4E33xR
         yzJSbH4CQbHioX7gVrn50LswZfG39oIilggA88PcJul7Drs7AfFfgOhUmapw1M3Wn9
         lo0amnFPyvK72eTuL46HTpJWyBujjmaggKvVkXyAQX7I3WH3CuBrVVTpsko16pz/Yh
         dhpYS5+84+xLw==
Subject: [PATCH 3/4] xfs: check absolute maximum nlevels for each btree type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com,
        chandanrlinux@gmail.com, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:54 -0700
Message-ID: <163244687436.2701674.5377184817013946444.stgit@magnolia>
In-Reply-To: <163244685787.2701674.13029851795897591378.stgit@magnolia>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add code for all five btree types so that we can compute the absolute
maximum possible btree height for each btree type, and then check that
none of them exceed XFS_BTREE_CUR_ZONE_MAXLEVELS.  The code to do the
actual checking is a little excessive, but it sets us up for per-type
cursor zones in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   12 +++++++++
 fs/xfs/libxfs/xfs_alloc_btree.h    |    1 +
 fs/xfs/libxfs/xfs_bmap_btree.c     |   13 ++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h     |    1 +
 fs/xfs/libxfs/xfs_btree.c          |   48 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h          |   10 ++++++++
 fs/xfs/libxfs/xfs_fs.h             |    3 ++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   11 ++++++++
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    1 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   13 ++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |    1 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |   25 +++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h     |    1 +
 fs/xfs/libxfs/xfs_types.h          |    3 ++
 fs/xfs/xfs_super.c                 |   35 ++++++++++++++++++++++++++
 15 files changed, 178 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index c644b11132f6..7f8612e383ed 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -582,6 +582,18 @@ xfs_allocbt_maxrecs(
 	return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
 }
 
+unsigned int
+xfs_allocbt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+
+	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_alloc_rec_t),
+			sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
+
+	return xfs_btree_compute_maxlevels(minrecs,
+			(XFS_MAX_AG_BLOCKS + 1) / 2);
+}
+
 /* Calculate the freespace btree size for some records. */
 xfs_extlen_t
 xfs_allocbt_calc_size(
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 2f6b816aaf9f..0d5b9aeb78b2 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -59,5 +59,6 @@ extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 
 void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
+unsigned int xfs_allocbt_absolute_maxlevels(void);
 
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index a06987e36db5..976a324460b4 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -586,6 +586,19 @@ xfs_bmbt_maxrecs(
 	return blocklen / (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t));
 }
 
+unsigned int
+xfs_bmbt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+
+	xfs_btree_absolute_minrecs(minrecs, XFS_BTREE_LONG_PTRS,
+			sizeof(struct xfs_bmbt_rec),
+			sizeof(struct xfs_bmbt_key) +
+				sizeof(xfs_bmbt_ptr_t));
+
+	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+}
+
 /*
  * Calculate number of records in a bmap btree inode root.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 729e3bc569be..1c5168947b96 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -109,5 +109,6 @@ extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 
 extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
+unsigned int xfs_bmbt_absolute_maxlevels(void);
 
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 619319ff41e5..120280c998f8 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -27,6 +27,13 @@
  * Cursor allocation zone.
  */
 kmem_zone_t	*xfs_btree_cur_zone;
+struct xfs_btree_cur_zone xfs_btree_cur_zones[XFS_BTNUM_MAX] = {
+	[XFS_BTNUM_BNO]		= { .name = "xfs_alloc_btree_cur" },
+	[XFS_BTNUM_INO]		= { .name = "xfs_ialloc_btree_cur" },
+	[XFS_BTNUM_RMAP]	= { .name = "xfs_rmap_btree_cur" },
+	[XFS_BTNUM_REFC]	= { .name = "xfs_refc_btree_cur" },
+	[XFS_BTNUM_BMAP]	= { .name = "xfs_bmap_btree_cur" },
+};
 
 /*
  * Btree magic numbers.
@@ -5027,3 +5034,44 @@ xfs_btree_alloc_cursor(
 
 	return cur;
 }
+
+/*
+ * Compute absolute minrecs for leaf and node btree blocks.  Callers should set
+ * BTREE_LONG_PTRS and BTREE_OVERLAPPING as they would for regular cursors.
+ * Set BTREE_CRC_BLOCKS if the btree type is supported on V5 or newer
+ * filesystems.
+ */
+void
+xfs_btree_absolute_minrecs(
+	unsigned int		*minrecs,
+	unsigned int		bc_flags,
+	unsigned int		leaf_recbytes,
+	unsigned int		node_recbytes)
+{
+	unsigned int		min_recbytes;
+
+	/*
+	 * If this btree type is supported on V4, we use the smaller V4 min
+	 * block size along with the V4 header size.  If the btree type is only
+	 * supported on V5, use the (twice as large) V5 min block size along
+	 * with the V5 header size.
+	 */
+	if (!(bc_flags & XFS_BTREE_CRC_BLOCKS)) {
+		if (bc_flags & XFS_BTREE_LONG_PTRS)
+			min_recbytes = XFS_MIN_BLOCKSIZE -
+							XFS_BTREE_LBLOCK_LEN;
+		else
+			min_recbytes = XFS_MIN_BLOCKSIZE -
+							XFS_BTREE_SBLOCK_LEN;
+	} else if (bc_flags & XFS_BTREE_LONG_PTRS) {
+		min_recbytes = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+	} else {
+		min_recbytes = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN;
+	}
+
+	if (bc_flags & XFS_BTREE_OVERLAPPING)
+		node_recbytes <<= 1;
+
+	minrecs[0] = min_recbytes / (2 * leaf_recbytes);
+	minrecs[1] = min_recbytes / (2 * node_recbytes);
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 57b7aa3f6366..5bebd26f8b2c 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -583,4 +583,14 @@ struct xfs_btree_cur *xfs_btree_alloc_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, xfs_btnum_t btnum);
 unsigned int xfs_btree_maxlevels(struct xfs_mount *mp, xfs_btnum_t btnum);
 
+void xfs_btree_absolute_minrecs(unsigned int *minrecs, unsigned int bc_flags,
+		unsigned int leaf_recbytes, unsigned int node_recbytes);
+
+struct xfs_btree_cur_zone {
+	const char		*name;
+	unsigned int		maxlevels;
+};
+
+extern struct xfs_btree_cur_zone xfs_btree_cur_zones[XFS_BTNUM_MAX];
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index bde2b4c64dbe..33d323ddf6da 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -268,6 +268,9 @@ typedef struct xfs_fsop_resblks {
  */
 #define XFS_MIN_AG_BYTES	(1ULL << 24)	/* 16 MB */
 #define XFS_MAX_AG_BYTES	(1ULL << 40)	/* 1 TB */
+#define XFS_MAX_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_BLOCKSIZE)
+#define XFS_MAX_CRC_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_CRC_BLOCKSIZE)
+#define XFS_MAX_AG_INODES	(XFS_MAX_AG_BYTES / XFS_DINODE_MIN_SIZE)
 
 /* keep the maximum size under 2^31 by a small amount */
 #define XFS_MAX_LOG_BYTES \
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index c8fea6a464d5..ce428c98e7c4 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -541,6 +541,17 @@ xfs_inobt_maxrecs(
 	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
 }
 
+unsigned int
+xfs_inobt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+
+	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
+			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
+
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_AG_INODES);
+}
+
 /*
  * Convert the inode record holemask to an inode allocation bitmap. The inode
  * allocation bitmap is inode granularity and specifies whether an inode is
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 8a322d402e61..e29570b4d3b6 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -74,5 +74,6 @@ int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
 
 void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
+unsigned int xfs_inobt_absolute_maxlevels(void);
 
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 48c45e31d897..9d428c3d4d90 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -408,6 +408,19 @@ xfs_refcountbt_maxrecs(
 			   sizeof(xfs_refcount_ptr_t));
 }
 
+unsigned int
+xfs_refcountbt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+
+	xfs_btree_absolute_minrecs(minrecs, XFS_BTREE_CRC_BLOCKS,
+			sizeof(struct xfs_refcount_rec),
+			sizeof(struct xfs_refcount_key) +
+						sizeof(xfs_refcount_ptr_t));
+
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_CRC_AG_BLOCKS);
+}
+
 /* Compute the maximum height of a refcount btree. */
 void
 xfs_refcountbt_compute_maxlevels(
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index bd9ed9e1e41f..d7dad2dbac09 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -64,5 +64,6 @@ extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
 
 void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
+unsigned int xfs_refcountbt_absolute_maxlevels(void);
 
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 85caeb14e4db..d73768c7546f 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -534,6 +534,31 @@ xfs_rmapbt_maxrecs(
 		(2 * sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
 }
 
+unsigned int
+xfs_rmapbt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+
+	xfs_btree_absolute_minrecs(minrecs,
+			XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
+			sizeof(struct xfs_rmap_rec),
+			sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
+
+	/*
+	 * Compute the asymptotic maxlevels for an rmapbt on any reflink fs.
+	 *
+	 * On a reflink filesystem, each AG block can have up to 2^32 (per the
+	 * refcount record format) owners, which means that theoretically we
+	 * could face up to 2^64 rmap records.  However, we're likely to run
+	 * out of blocks in the AG long before that happens, which means that
+	 * we must compute the max height based on what the btree will look
+	 * like if it consumes almost all the blocks in the AG due to maximal
+	 * sharing factor.
+	 */
+	return xfs_btree_compute_maxlevels_size(XFS_MAX_CRC_AG_BLOCKS,
+			minrecs[1]);
+}
+
 /* Compute the maximum height of an rmap btree. */
 unsigned int
 xfs_rmapbt_compute_maxlevels(
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 5aaecf755abd..6d5001e92966 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -58,5 +58,6 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
 
 extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
+unsigned int xfs_rmapbt_absolute_maxlevels(void);
 
 #endif /* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b6da06b40989..6ce15a4f9f47 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -126,6 +126,9 @@ typedef enum {
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
+#define for_each_xfs_btnum(btnum) \
+	for((btnum) = XFS_BTNUM_BNOi; (btnum) < XFS_BTNUM_MAX; (btnum)++)
+
 #define XFS_BTNUM_STRINGS \
 	{ XFS_BTNUM_BNOi,	"bnobt" }, \
 	{ XFS_BTNUM_CNTi,	"cntbt" }, \
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 90c92a6a49e0..83abe9bfe3ef 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -37,6 +37,12 @@
 #include "xfs_reflink.h"
 #include "xfs_pwork.h"
 #include "xfs_ag.h"
+#include "xfs_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount_btree.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -1950,9 +1956,34 @@ static struct file_system_type xfs_fs_type = {
 };
 MODULE_ALIAS_FS("xfs");
 
+STATIC int __init
+xfs_init_btree_zones(void)
+{
+	struct xfs_btree_cur_zone	*z = xfs_btree_cur_zones;
+	xfs_btnum_t			btnum;
+
+	z[XFS_BTNUM_BNO].maxlevels	= xfs_allocbt_absolute_maxlevels();
+	z[XFS_BTNUM_RMAP].maxlevels	= xfs_rmapbt_absolute_maxlevels();
+	z[XFS_BTNUM_BMAP].maxlevels	= xfs_bmbt_absolute_maxlevels();
+	z[XFS_BTNUM_INO].maxlevels	= xfs_inobt_absolute_maxlevels();
+	z[XFS_BTNUM_REFC].maxlevels	= xfs_refcountbt_absolute_maxlevels();
+
+	for_each_xfs_btnum(btnum) {
+		ASSERT(z[btnum].maxlevels <= XFS_BTREE_CUR_ZONE_MAXLEVELS);
+	}
+
+	/* struct copies for btree types that share zones */
+	z[XFS_BTNUM_CNT] = z[XFS_BTNUM_BNO];
+	z[XFS_BTNUM_FINO] = z[XFS_BTNUM_INO];
+
+	return 0;
+}
+
 STATIC int __init
 xfs_init_zones(void)
 {
+	int			error;
+
 	xfs_log_ticket_zone = kmem_cache_create("xfs_log_ticket",
 						sizeof(struct xlog_ticket),
 						0, 0, NULL);
@@ -1965,6 +1996,10 @@ xfs_init_zones(void)
 	if (!xfs_bmap_free_item_zone)
 		goto out_destroy_log_ticket_zone;
 
+	error = xfs_init_btree_zones();
+	if (error)
+		goto out_destroy_bmap_free_item_zone;
+
 	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
 			xfs_btree_cur_sizeof(XFS_BTREE_CUR_ZONE_MAXLEVELS),
 			0, 0, NULL);

