Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE823C4555;
	Fri,  2 Oct 2026 22:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980676; cv=none; b=gjtZkzxnDmINhbl3uu2b/Kmmvcqm7MtHq2Cb98/dDnQeYAyJGLk4tJMmNpKuE1OuSy/mXx1TFs62YkTuo5w6yTfvfU0/mU85YJG8yQdUXxdbSTDRYolO0T8MmFX1SzIl9IUl98PMwaioIbP4HoCSZBLiI6ExK140xulzqgCH+s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980676; c=relaxed/simple;
	bh=V9LsR+xUxqfxtRUI5SQXStQEBBgTlyjr2YvBEYvMV7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWFVV+vTcmg7f8FNM4JdYjGUJZSn41+B/RZJoaJYPJ1cq5Qtoz8JRFNTiDBt8rj23UvLsiBreDg0jdLSUD+gEHotYU3pgQCkJNuZootXpdnqXs4OvsEKXGJaqRxGp6JfNuwJDWY7LdhZXx3s+jqM9A4HdqCfWCLXlTi6Af0sb64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgWjCDUP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgWjCDUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7A41F000FF;
	Fri,  2 Oct 2026 22:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980675;
	bh=ioSMxM3XsVn6ilFgBGbSjQd+ABy2K7sVn2gY80y7yTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgWjCDUPJGcoAgBBi20AW1gv2/oEwxzI0aiujc52M6AU8Erlfz1Z3dRXv7j0D9LcV
	 u1nH3aPQFShm9rGun02VYmatrtDPg1TRTp7ZHSNGKftrO1XOAHeME66fF52k0n/ie0
	 0NZclbs3zsf/2Xg66eRe3bSlUzH3ZJwCtDedvlPAH5FmM5ZdmXOz8kXfv5Og/k0z9y
	 5PbPaU9Unm0lRmzSPXwvq4h39Xsi3wn1hLl/xoOQY4JYEYUEOhQDwQaMFeyvkR/ySh
	 jvtglcAMi9b8PzT1W1mJ+0KWosTO8vdQ+QZhBxfdHP2KdtCtjnnzMPrnszRC89LOGR
	 qvwckEQR/8NXw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 12/21] xfs: use read ioend for fsverity data verification
Date: Sat,  3 Oct 2026 00:36:53 +0200
Message-ID: <20261002223705.2175542-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use read ioends for fsverity verification. Do not issue fsverity
metadata I/O through the same workqueue due to risk of a deadlock by a
filled workqueue.

Pass fsverity_info from iomap context down to the ioend as hashtable
lookups are expensive.

Add a simple helper to check that this is not fsverity metadata but file
data that needs verification.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_aops.c     | 13 +++++++----
 fs/xfs/xfs_file.c     |  3 ++-
 fs/xfs/xfs_fsverity.c | 31 +++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h | 25 ++++++++++++++++++++
 fs/xfs/xfs_ioend.c    | 53 ++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_ioend.h    |  4 +++-
 fs/xfs/xfs_super.c    | 24 +++++++++++++++++++-
 7 files changed, 139 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 19640e4e3ed1..a36f840884b4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -24,6 +24,7 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
 #include "xfs_fsverity.h"
+#include <linux/fsverity.h>
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -611,7 +612,7 @@ xfs_bio_submit_read(
 {
 	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
 			ctx->read_ctx_file_offset,
-			iomap_ioend_flags(&iter->iomap));
+			iomap_ioend_flags(&iter->iomap), ctx->vi);
 	ctx->read_ctx = NULL;
 }
 
@@ -623,11 +624,13 @@ static const struct iomap_read_ops xfs_iomap_read_ops = {
 
 static inline const struct iomap_read_ops *
 xfs_get_iomap_read_ops(
-	const struct address_space	*mapping)
+	const struct address_space	*mapping,
+	loff_t				pos)
 {
 	struct xfs_inode		*ip = XFS_I(mapping->host);
 
-	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
+	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
+	    xfs_fsverity_is_file_data(ip, pos))
 		return &xfs_iomap_read_ops;
 	return &iomap_bio_read_ops;
 }
@@ -639,7 +642,7 @@ xfs_vm_read_folio(
 {
 	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
 
-	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
+	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
 	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
 	return 0;
 }
@@ -650,7 +653,7 @@ xfs_vm_readahead(
 {
 	struct iomap_read_folio_ctx	ctx = { .rac = rac };
 
-	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
+	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
 	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 07abf6e8783f..578ca6fb8292 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -225,7 +225,8 @@ xfs_dio_read_bounce_submit_io(
 	loff_t			file_offset)
 {
 	xfs_ioend_submit_read(iter->inode, bio, file_offset,
-			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
+			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT,
+			NULL);
 }
 
 static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index e30021c22683..976e05257bf9 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -14,9 +14,40 @@
 #include <linux/fsverity.h>
 #include <linux/iomap.h>
 
+struct kmem_cache *xfs_fsverity_ioend_cache;
+mempool_t xfs_fsverity_ioend_pool;
+
+#define XFS_FSVERITY_IOEND_POOL_MIN	128
+
+/*
+ * Back the fsverity ioend allocations with a mempool so that read I/O
+ * completion always makes forward progress and cannot deadlock
+ */
+int
+xfs_fsverity_init(void)
+{
+	return mempool_init_slab_pool(&xfs_fsverity_ioend_pool,
+			XFS_FSVERITY_IOEND_POOL_MIN, xfs_fsverity_ioend_cache);
+}
+
+void
+xfs_fsverity_exit(void)
+{
+	mempool_exit(&xfs_fsverity_ioend_pool);
+}
+
 loff_t
 xfs_fsverity_metadata_offset(
 	const struct xfs_inode	*ip)
 {
 	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
 }
+
+bool
+xfs_fsverity_is_file_data(
+	const struct xfs_inode	*ip,
+	loff_t			offset)
+{
+	return fsverity_active(VFS_IC(ip)) &&
+			offset < xfs_fsverity_metadata_offset(ip);
+}
diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
index c2ab5af89370..01269a828fc0 100644
--- a/fs/xfs/xfs_fsverity.h
+++ b/fs/xfs/xfs_fsverity.h
@@ -6,15 +6,40 @@
 #define __XFS_FSVERITY_H__
 
 #include "xfs_platform.h"
+#include <linux/iomap.h>
+#include <linux/mempool.h>
 
 #ifdef CONFIG_FS_VERITY
+int xfs_fsverity_init(void);
+void xfs_fsverity_exit(void);
 loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
+bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
 #else
+static inline int xfs_fsverity_init(void)
+{
+	return 0;
+}
+static inline void xfs_fsverity_exit(void)
+{
+}
 static inline loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip)
 {
 	WARN_ON_ONCE(1);
 	return ULLONG_MAX;
 }
+static inline bool xfs_fsverity_is_file_data(const struct xfs_inode *ip,
+					    loff_t offset)
+{
+	return false;
+}
 #endif	/* CONFIG_FS_VERITY */
 
+struct xfs_fsverity_ioend {
+	struct iomap_ioend	*ioend;
+	struct work_struct	work;
+};
+
+extern struct kmem_cache *xfs_fsverity_ioend_cache;
+extern mempool_t xfs_fsverity_ioend_pool;
+
 #endif	/* __XFS_FSVERITY_H__ */
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index e70be5b86f0b..f4c1bbc03714 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -18,7 +18,26 @@
 #include "xfs_ioend.h"
 #include "xfs_error.h"
 #include "xfs_errortag.h"
+#include "xfs_fsverity.h"
 #include <linux/bio-integrity.h>
+#include <linux/fsverity.h>
+
+static void
+xfs_end_fsverity_io_read(
+	struct work_struct		*work)
+{
+	struct xfs_fsverity_ioend	*fsv_ioend =
+			container_of(work, struct xfs_fsverity_ioend, work);
+	struct iomap_ioend		*ioend = fsv_ioend->ioend;
+	struct bio			*bio = &ioend->io_bio;
+
+	mempool_free(fsv_ioend, &xfs_fsverity_ioend_pool);
+
+	if (!bio->bi_status)
+		fsverity_verify_bio(ioend->io_vi, bio);
+
+	iomap_finish_ioends(ioend, blk_status_to_errno(bio->bi_status));
+}
 
 static void
 xfs_dio_bounce_end_io(
@@ -93,12 +112,14 @@ xfs_read_bounce_and_resubmit(
 
 static void
 xfs_end_io_read(
-	struct bio		*bio)
+	struct bio			*bio)
 {
-	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	int			error = blk_status_to_errno(bio->bi_status);
+	struct iomap_ioend		*ioend = iomap_ioend_from_bio(bio);
+	struct xfs_inode		*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount		*mp = ip->i_mount;
+	int				error =
+			blk_status_to_errno(bio->bi_status);
+	struct xfs_fsverity_ioend	*fsv_ioend;
 
 	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY)) {
 		error = iomap_ioend_integrity_verify(ioend);
@@ -117,6 +138,24 @@ xfs_end_io_read(
 		}
 	}
 
+	/*
+	 * If we have fsverity on this bio, we need to run fsverity verification
+	 * of data folios from a separate fsverity workqueue. This is necessary
+	 * to avoid deadlocking due to fsverity issuing more reads of fsverity
+	 * metadata which would be processed by the same worker in the BIO
+	 * completion workqueue.
+	 */
+	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
+			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
+		fsv_ioend = mempool_alloc(&xfs_fsverity_ioend_pool,
+				GFP_NOFS);
+		fsv_ioend->ioend = ioend;
+		INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
+
+		fsverity_enqueue_verify_work(&fsv_ioend->work);
+		return;
+	}
+
 	iomap_finish_ioends(ioend, error);
 }
 
@@ -125,13 +164,15 @@ xfs_ioend_submit_read(
 	struct inode		*inode,
 	struct bio		*bio,
 	loff_t			file_offset,
-	u16			ioend_flags)
+	u16			ioend_flags,
+	struct fsverity_info	*vi)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct iomap_ioend	*ioend;
 
 	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
+	ioend->io_vi = vi;
 	if ((ioend_flags & IOMAP_IOEND_DIRECT) &&
 	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_ALWAYS) {
 		iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
diff --git a/fs/xfs/xfs_ioend.h b/fs/xfs/xfs_ioend.h
index 7c2a1ea3e6ed..992c248a693a 100644
--- a/fs/xfs/xfs_ioend.h
+++ b/fs/xfs/xfs_ioend.h
@@ -2,6 +2,8 @@
 #ifndef __XFS_IOEND_H
 #define __XFS_IOEND_H
 
+#include <linux/fsverity.h>
+
 /*
  * Fast and loose check if this write could update the on-disk inode size.
  */
@@ -13,6 +15,6 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
 
 void xfs_end_bio(struct bio *bio);
 void xfs_ioend_submit_read(struct inode *inode, struct bio *bio,
-		loff_t file_offset, u16 ioend_flags);
+		loff_t file_offset, u16 ioend_flags, struct fsverity_info *vi);
 
 #endif /* __XFS_IOEND_H */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fce1d2905c94..7a8d071dbe56 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2516,8 +2516,20 @@ xfs_init_caches(void)
 	if (!xfs_parent_args_cache)
 		goto out_destroy_xmi_cache;
 
+#ifdef CONFIG_FS_VERITY
+	xfs_fsverity_ioend_cache = kmem_cache_create("xfs_fsverity_ioend",
+					     sizeof(struct xfs_fsverity_ioend),
+					     0, 0, NULL);
+	if (!xfs_fsverity_ioend_cache)
+		goto out_destroy_parent_args_cache;
+#endif
+
 	return 0;
 
+#ifdef CONFIG_FS_VERITY
+ out_destroy_parent_args_cache:
+	kmem_cache_destroy(xfs_parent_args_cache);
+#endif
  out_destroy_xmi_cache:
 	kmem_cache_destroy(xfs_xmi_cache);
  out_destroy_xmd_cache:
@@ -2580,6 +2592,9 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+#ifdef CONFIG_FS_VERITY
+	kmem_cache_destroy(xfs_fsverity_ioend_cache);
+#endif
 	kmem_cache_destroy(xfs_parent_args_cache);
 	kmem_cache_destroy(xfs_xmd_cache);
 	kmem_cache_destroy(xfs_xmi_cache);
@@ -2660,10 +2675,14 @@ init_xfs_fs(void)
 	if (error)
 		goto out;
 
-	error = xfs_init_workqueues();
+	error = xfs_fsverity_init();
 	if (error)
 		goto out_destroy_caches;
 
+	error = xfs_init_workqueues();
+	if (error)
+		goto out_fsverity_exit;
+
 	error = xfs_mru_cache_init();
 	if (error)
 		goto out_destroy_wq;
@@ -2740,6 +2759,8 @@ init_xfs_fs(void)
 	xfs_mru_cache_uninit();
  out_destroy_wq:
 	xfs_destroy_workqueues();
+ out_fsverity_exit:
+	xfs_fsverity_exit();
  out_destroy_caches:
 	xfs_destroy_caches();
  out:
@@ -2763,6 +2784,7 @@ exit_xfs_fs(void)
 	xfs_cleanup_procfs();
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
+	xfs_fsverity_exit();
 	xfs_destroy_caches();
 	xfs_uuid_table_free();
 }
-- 
2.54.0

