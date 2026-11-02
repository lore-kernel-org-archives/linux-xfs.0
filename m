Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630545;
	b=azXKvMV7+3Zv83lnW5idXpT/QXR3Lo9KPa8nNUzKNUeXxKZa1Sko8+nCzMqXiFIDdmG2
	 2+F+pea6dyOk0DeCw6zWjbi09Gw1QGa5YlcrjbiwCBT33QSPn9MCYpn5oMOozSNy3UGT6
	 HuoPYxnetw2/sTxc9y8plQJyIqy8CqsZXdxUsKj5qbSdSMHw7GmPKqWKr9XoFuR/oQz2t
	 swG+Z9AUjELgxTqgfkBCGpK2IoRShh7QsuhmTJcNPGWBdlh0hUW+jkXJscIZXjEtzbYF0
	 iMcdoDiNybDGZuRC6wJfKt6B203h0uam3zTviUw/YqY5AcPQ67bByQTe5ISnE0j+2WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3mfthim6t/9Luqs9z+ujzLicqyfxQWHUrgDd4CgjuFc=;
	b=Mo7MPFCVeAX6cprGEre482TbFohTrd80iIuAo979tGfo688AnDnY+c8BK22Yiw4xv5eK
	 LjB9nkHVSo1q9PpQMCNiMlkDG8C4hFV3b4picVQjPCOxasKWH8W/pD1JuXH7Y2n5wKh88
	 kq6RJEL1P1TG+mf846WdhmwaTl57HQyI0QUvbETpPpZjEB28OvBo46HdpGNcV73vX7mn5
	 PMakc7csViXr6l70W6QMBiBMwSLST8kXk79MjVdAVXpR4Z9nQgRkwdEwfiZ+tALt25GBv
	 HNSvs5BqLRHGueMx4Rc6J9SdYXRCXevXQWEDYjPje93WrG0LAtUPUOoBVBFycATBK5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FHBUrfHj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09706606F23B;
	Mon,  2 Nov 2026 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FHBUrfHj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0169E1F00A16;
	Mon,  2 Nov 2026 14:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630544;
	bh=3mfthim6t/9Luqs9z+ujzLicqyfxQWHUrgDd4CgjuFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHBUrfHjQqpUQRXfNXw1Q/xJJgviV/OildY9dzJTeLLpqkXucQg/wR4HBdkRNGu+Q
	 Q0EXeJ9xdFCt34NPzPsGhBHThXUIRRl4fOiTTw1FCE6u0bk5tOBWJmbm4bGOo0oVm7
	 /T25B4qu92FUvT5qsHR/fWl2yw7YQJTLSHQ1xG61Nc2dZaIP48vIlFFK0FCUp6rqOX
	 F+8kP8lF04bCCs0T66V2pvmu06fNH8+yzcF8nWDlimpJFb/tgCx0SKUAgIc+hLxtyY
	 tZhu75yEPL+UqRGSYVzLPB6r7kC+iUgdsyr8UmGcdXUDWysbk4MgEnNyPf8RPRY1CH
	 KLnvar19rQgAQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v18 06/15] xfs: use read ioend for fsverity data verification
Date: Mon,  2 Nov 2026 15:41:36 +0100
Message-ID: <20261102144147.2393369-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
 fs/xfs/Makefile       |  1 +
 fs/xfs/xfs_aops.c     | 12 ++++++----
 fs/xfs/xfs_file.c     |  3 ++-
 fs/xfs/xfs_fsverity.c | 46 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h | 40 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioend.c    | 53 ++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_ioend.h    |  4 +++-
 fs/xfs/xfs_super.c    | 24 +++++++++++++++++++-
 8 files changed, 169 insertions(+), 14 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index cb7f71457ee9..9edb2850f094 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -151,6 +151,7 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
 xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
+xfs-$(CONFIG_FS_VERITY)		+= xfs_fsverity.o
 
 # notify failure
 ifeq ($(CONFIG_MEMORY_FAILURE),y)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 19640e4e3ed1..2f6e87991d83 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -611,7 +611,7 @@ xfs_bio_submit_read(
 {
 	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
 			ctx->read_ctx_file_offset,
-			iomap_ioend_flags(&iter->iomap));
+			iomap_ioend_flags(&iter->iomap), ctx->vi);
 	ctx->read_ctx = NULL;
 }
 
@@ -623,11 +623,13 @@ static const struct iomap_read_ops xfs_iomap_read_ops = {
 
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
@@ -639,7 +641,7 @@ xfs_vm_read_folio(
 {
 	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
 
-	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
+	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
 	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
 	return 0;
 }
@@ -650,7 +652,7 @@ xfs_vm_readahead(
 {
 	struct iomap_read_folio_ctx	ctx = { .rac = rac };
 
-	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
+	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
 	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f0d000272521..dbb5f8f59678 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -224,7 +224,8 @@ xfs_dio_read_bounce_submit_io(
 	loff_t			file_offset)
 {
 	xfs_ioend_submit_read(iter->inode, bio, file_offset,
-			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
+			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT,
+			NULL);
 }
 
 static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
new file mode 100644
index 000000000000..8fc3e763c017
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Red Hat, Inc.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_fsverity.h"
+#include <linux/fsverity.h>
+#include <linux/iomap.h>
+
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
+bool
+xfs_fsverity_is_file_data(
+	const struct xfs_inode	*ip,
+	loff_t			offset)
+{
+	return fsverity_active(VFS_IC(ip)) &&
+			offset < xfs_fsverity_metadata_offset(ip);
+}
diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
new file mode 100644
index 000000000000..44f7bc7831f2
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.h
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Red Hat, Inc.
+ */
+#ifndef __XFS_FSVERITY_H__
+#define __XFS_FSVERITY_H__
+
+#include "xfs_platform.h"
+#include "xfs_verity.h"
+#include <linux/iomap.h>
+#include <linux/mempool.h>
+
+#ifdef CONFIG_FS_VERITY
+int xfs_fsverity_init(void);
+void xfs_fsverity_exit(void);
+bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
+#else
+static inline int xfs_fsverity_init(void)
+{
+	return 0;
+}
+static inline void xfs_fsverity_exit(void)
+{
+}
+static inline bool xfs_fsverity_is_file_data(const struct xfs_inode *ip,
+					    loff_t offset)
+{
+	return false;
+}
+#endif	/* CONFIG_FS_VERITY */
+
+struct xfs_fsverity_ioend {
+	struct iomap_ioend	*ioend;
+	struct work_struct	work;
+};
+
+extern struct kmem_cache *xfs_fsverity_ioend_cache;
+extern mempool_t xfs_fsverity_ioend_pool;
+
+#endif	/* __XFS_FSVERITY_H__ */
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 48becc3bf608..d30aee973a87 100644
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
index 5a06132aa384..3a7d7334e9a6 100644
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

