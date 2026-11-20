Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190313;
	b=zwdhdtBvJCqBSY/AdcXHBFeRwIApkEquj/Il/Lz7eufunae+3IHmofhwpy55Ihzoi17t
	 NGMqVb3s/pFQP115Eav4KjvqqMXchTpwmyQQjMENb5CyZxx81kXuGIP8pXal8XAiYHQP7
	 FI4XcauYIVb83DZOdkAe/WSBDNlgJRRtvoIR9PZ/lGbEVWDBvUcsL/ukZtZI2T7b21c76
	 vEXyihq31O4w9u+D2qDg9SSmbz7dp9oN0v9XKpdiC+YcjHoKejPhLlG2A8otws/pA18ci
	 oFnslDFYJtF77zDy94aEbxVU1pzydVa7I+huD6iCM77EvD9iQeX6rhNRNHQy+P3Tnyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JE9ujSNsAqeJi6Hc+4eJZGififmNBU70VxWRP6D9upE=;
	b=CpHwku4UwZV6v7KMr7RVoc20vYR5LNG1ipGK+//LwpkjcN03/DSXO8l0oys+SbGhTXc6
	 R4qquKcjT5NC0C78rQ8De2RL2gM6MXhlo/BLJ2BWJeVW/gm+Tg7gLLHxhl+XU1Q/QyOE+
	 83IqngKT2LH8RwgB6ojEsvkGO5eqLl9Y+OCtadqX3LZi/fJMYLz/+Bxc+8OYXDNmGTqx0
	 j97EkT/axNiEEJyPd1rdOBJUyWyoc38LYsgMOsJIRFeRshYtl29gpOu3KqECoqbVY2/cK
	 MGWJbI2wGYQxapaRrI7LI0wiwzAwOzRxRJsAx7uR5hFFC6Wfdlj3slJFGsdQMwCOsBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=crICGwDc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875ED606A335;
	Fri, 20 Nov 2026 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=crICGwDc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB561F0156B;
	Fri, 20 Nov 2026 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190312;
	bh=JE9ujSNsAqeJi6Hc+4eJZGififmNBU70VxWRP6D9upE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crICGwDc6dRtrbszG8F/lBUI/Q8iYAmAe/1ITcDLFb7sg2zmH24jEs4fpbXLFJamZ
	 ZZvQVDJM7S5ef49gPfrQUK9eUguXlXqwP+8yvfQsLXXGPLUAHyCMuq1UcyXQ0+d1sw
	 rXUBhb3fvUQtyuTV02ZocOea3XVVIRvLOCttyNtf31ThDBroPw1dZM2h1KF419Mb6l
	 EdOaQ2+9aMY+DsP5EXH3OY1aosxAOvEFvocMVVpTNUiho8Q87m83DrS7O0NBpWX0AG
	 030mWCTXHl0Tt1AvCoxcvB2Cx8UgdFQnsrR/jUqL3HUmyHBVU7fmESBGWHp7Cv5vIz
	 qEojKmFKIRqXw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com
Subject: [PATCH v19 06/15] xfs: use read ioend for fsverity data verification
Date: Fri, 20 Nov 2026 16:57:40 +0100
Message-ID: <20261120155752.192025-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile       |  1 +
 fs/xfs/xfs_aops.c     | 13 +++++++----
 fs/xfs/xfs_file.c     |  3 ++-
 fs/xfs/xfs_fsverity.c | 46 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h | 40 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioend.c    | 53 ++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_ioend.h    |  4 +++-
 fs/xfs/xfs_super.c    | 25 +++++++++++++++++++-
 8 files changed, 171 insertions(+), 14 deletions(-)
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
index b9728997f944..971be3c09731 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -24,6 +24,7 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
 #include "xfs_verity.h"
+#include "xfs_fsverity.h"
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -587,7 +588,7 @@ xfs_bio_submit_read(
 {
 	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
 			ctx->read_ctx_file_offset,
-			iomap_ioend_flags(&iter->iomap));
+			iomap_ioend_flags(&iter->iomap), ctx->vi);
 	ctx->read_ctx = NULL;
 }
 
@@ -599,11 +600,13 @@ static const struct iomap_read_ops xfs_iomap_read_ops = {
 
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
@@ -615,7 +618,7 @@ xfs_vm_read_folio(
 {
 	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
 
-	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
+	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
 	iomap_read_folio(xfs_read_iomap_next, &ctx, NULL);
 	return 0;
 }
@@ -626,7 +629,7 @@ xfs_vm_readahead(
 {
 	struct iomap_read_folio_ctx	ctx = { .rac = rac };
 
-	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
+	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
 	iomap_readahead(xfs_read_iomap_next, &ctx, NULL);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1171712d3e5b..94cdc3166805 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -182,7 +182,8 @@ xfs_dio_read_bounce_submit_io(
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
index 7f4a4a95afe5..61f211a3b805 100644
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
index 5a06132aa384..532bf304a921 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -50,6 +50,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_healthmon.h"
+#include "xfs_fsverity.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -2516,8 +2517,20 @@ xfs_init_caches(void)
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
@@ -2580,6 +2593,9 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+#ifdef CONFIG_FS_VERITY
+	kmem_cache_destroy(xfs_fsverity_ioend_cache);
+#endif
 	kmem_cache_destroy(xfs_parent_args_cache);
 	kmem_cache_destroy(xfs_xmd_cache);
 	kmem_cache_destroy(xfs_xmi_cache);
@@ -2660,10 +2676,14 @@ init_xfs_fs(void)
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
@@ -2740,6 +2760,8 @@ init_xfs_fs(void)
 	xfs_mru_cache_uninit();
  out_destroy_wq:
 	xfs_destroy_workqueues();
+ out_fsverity_exit:
+	xfs_fsverity_exit();
  out_destroy_caches:
 	xfs_destroy_caches();
  out:
@@ -2763,6 +2785,7 @@ exit_xfs_fs(void)
 	xfs_cleanup_procfs();
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
+	xfs_fsverity_exit();
 	xfs_destroy_caches();
 	xfs_uuid_table_free();
 }
-- 
2.54.0

