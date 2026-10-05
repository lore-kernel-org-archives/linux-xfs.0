Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA45D481241
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205045; cv=none; b=u3mC3GCSMVoxyiFvYN1C1HpBymX0nQx4wiSMtlUsRZKKI3Kf8/3PDelE+m8XXjKR6dkeOFzyZ2PhmV1RlvSnjtz5HheruSBecR/aaY8/Ka05JJlHzvZ1FsJ+oMtBz3ALUhOXU6v7yIcaOS1XA5k/F77RkYcBl3PvPM6vH8dNuX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205045; c=relaxed/simple;
	bh=ckCAMdNtRlxwEnCrrk2bL9PzxpmNRjdrCFIvhBUcczw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lW1ZN5ozqDbDUWx5q19VkmVWBTgF286cKl3qJRVswWBoR0hZSy8cdWx0Ovejg1KRGveeelGb27wG3HULLReC22drTMxlVmOwYlC+zzSkKU/gs/HmKTq7ABFQm6rbpOb4d5e1ADxCSF/KrrF26UCRbVl2r5jWizHfD1MHlKEYZYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ItbXV/o4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ItbXV/o4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NQp1QN+dJYOSDwwB4vp0Km4D2b34oIEa1Y6FTV4Uryk=; b=ItbXV/o4hhhV5LA8JwphKRv4be
	LZMerbLpVIf8sQFneRr78g+kxYHn6ilH7IxZ6aVg2XiXpyQI3IMZ7kfZKXKgH0eanPdrv7mRRbrCe
	hNvWbgKBOXsNsnyV0Hrn3e6Ygyvwo+t2NP+9Ge9XczyrXvbuOHm2tlIuxRcVXNUKdlT7u3VIaUgiP
	18VYpRQ+NKF5b+tXzWmmuvmBueQxTOZQ5dkLzlImub7MGSTKBRMqPcno+IlW6AhhvHtnLCjisZdug
	j75pfo1+N7A1UEliaX9c3LEU+5VI6Tj3KS1jWI0zXwlUHVVdvEhLL9/hzcNhQw2AL/aEwHioCI1uu
	KPoI0bLw==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFt-0000000GR9U-3MUz;
	Mon, 05 Oct 2026 12:57:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/13] libxfs: use all log item headers from the kernel
Date: Mon,  5 Oct 2026 14:56:23 +0200
Message-ID: <20261005125637.1340355-14-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005125637.1340355-1-hch@lst.de>
References: <20261005125637.1340355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Wire up all the xfs_*_item.h headers from the kernel instead of
duplicating the definitions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/logformat.c                           |   4 +
 include/atomic.h                         |   1 +
 include/libxfs.h                         |   1 -
 libxfs/Makefile                          |  10 ++-
 libxfs/defer_item.c                      |   3 +-
 libxfs/defer_item.h                      |  56 -------------
 libxfs/iunlink.c                         |  10 +--
 libxfs/stubs/xfs_inode.h                 |   8 ++
 libxfs/trans.c                           |  12 +++
 libxfs/xfs_alloc.c                       |   2 +-
 libxfs/xfs_attr.c                        |   2 +-
 libxfs/xfs_attr_item.h                   |  64 +++++++++++++++
 libxfs/xfs_bmap.c                        |   2 +-
 libxfs/xfs_bmap_item.h                   |  78 ++++++++++++++++++
 libxfs/xfs_exchmaps.c                    |   2 +-
 libxfs/xfs_exchmaps_item.h               |  64 +++++++++++++++
 libxfs/xfs_extfree_item.h                | 100 +++++++++++++++++++++++
 libxfs/xfs_ialloc.c                      |   1 +
 libxfs/xfs_icreate_item.h                |  22 +++++
 libxfs/xfs_inode_util.c                  |   3 +-
 libxfs/{iunlink.h => xfs_iunlink_item.h} |  17 ++--
 libxfs/xfs_parent.c                      |   2 +-
 libxfs/xfs_platform.h                    |   1 -
 libxfs/xfs_refcount.c                    |   2 +-
 libxfs/xfs_refcount_item.h               |  82 +++++++++++++++++++
 libxfs/xfs_rmap.c                        |   2 +-
 libxfs/xfs_rmap_item.h                   |  81 ++++++++++++++++++
 libxfs/xfs_trans_resv.c                  |   7 +-
 28 files changed, 551 insertions(+), 88 deletions(-)
 delete mode 100644 libxfs/defer_item.h
 create mode 100644 libxfs/xfs_attr_item.h
 create mode 100644 libxfs/xfs_bmap_item.h
 create mode 100644 libxfs/xfs_exchmaps_item.h
 create mode 100644 libxfs/xfs_extfree_item.h
 create mode 100644 libxfs/xfs_icreate_item.h
 rename libxfs/{iunlink.h => xfs_iunlink_item.h} (61%)
 create mode 100644 libxfs/xfs_refcount_item.h
 create mode 100644 libxfs/xfs_rmap_item.h

diff --git a/db/logformat.c b/db/logformat.c
index aba5b0b1b050..5d3d818d5575 100644
--- a/db/logformat.c
+++ b/db/logformat.c
@@ -10,6 +10,10 @@
 #include "output.h"
 #include "libxlog.h"
 #include "logformat.h"
+#include "xfs_extfree_item.h"
+#include "xfs_bmap_item.h"
+#include "xfs_rmap_item.h"
+#include "xfs_refcount_item.h"
 
 #define MAX_LSUNIT	256 * 1024	/* max log buf. size */
 
diff --git a/include/atomic.h b/include/atomic.h
index 3b7eabd0faa7..ee2161fdf9cc 100644
--- a/include/atomic.h
+++ b/include/atomic.h
@@ -18,6 +18,7 @@
 #include <urcu/uatomic.h>
 #include "spinlock.h"
 
+typedef	int32_t	refcount_t;
 typedef	int32_t	atomic_t;
 typedef	int64_t	atomic64_t;
 
diff --git a/include/libxfs.h b/include/libxfs.h
index 549176cf0b2c..e28b79d80143 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -105,7 +105,6 @@ struct iomap;
 #include "xfs_rtbitmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_ag_resv.h"
-#include "defer_item.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/Makefile b/libxfs/Makefile
index ac7ddac5acec..df11c119c465 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -20,12 +20,10 @@ PKGHFILES = xfs_fs.h \
 	xfs_log_format.h
 
 HFILES = \
-	defer_item.h \
 	libxfs_io.h \
 	libxfs_api_defs.h \
 	listxattr.h \
 	init.h \
-	iunlink.h \
 	xfs_platform.h \
 	linux-err.h \
 	topology.h \
@@ -35,10 +33,12 @@ HFILES = \
 	xfs_alloc.h \
 	xfs_alloc_btree.h \
 	xfs_attr_leaf.h \
+	xfs_attr_item.h \
 	xfs_attr_sf.h \
 	xfs_bit.h \
 	xfs_buf_item.h \
 	xfs_bmap.h \
+	xfs_bmap_item.h \
 	xfs_bmap_btree.h \
 	xfs_btree.h \
 	xfs_btree_mem.h \
@@ -50,13 +50,17 @@ HFILES = \
 	xfs_dir2_priv.h \
 	xfs_errortag.h \
 	xfs_exchmaps.h \
+	xfs_exchmaps_item.h \
+	xfs_extfree_item.h \
 	xfs_group.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
+	xfs_icreate_item.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_inode_item.h \
 	xfs_inode_util.h \
+	xfs_iunlink_item.h \
 	xfs_log_recover.h \
 	xfs_metadir.h \
 	xfs_metafile.h \
@@ -64,9 +68,11 @@ HFILES = \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
 	xfs_refcount_btree.h \
+	xfs_refcount_item.h \
 	xfs_rtrefcount_btree.h \
 	xfs_rmap.h \
 	xfs_rmap_btree.h \
+	xfs_rmap_item.h \
 	xfs_rtbitmap.h \
 	xfs_rtgroup.h \
 	xfs_rtrmap_btree.h \
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index fada5b6db2a6..72d79b10d820 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -25,12 +25,11 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "libxfs.h"
-#include "defer_item.h"
 #include "xfs_ag.h"
 #include "xfs_exchmaps.h"
-#include "defer_item.h"
 #include "xfs_group.h"
 #include "xfs_rtgroup.h"
+#include "xfs_attr_item.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
deleted file mode 100644
index 325a6f7b2dcb..000000000000
--- a/libxfs/defer_item.h
+++ /dev/null
@@ -1,56 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <djwong@kernel.org>
- */
-#ifndef	__LIBXFS_DEFER_ITEM_H_
-#define	__LIBXFS_DEFER_ITEM_H_
-
-struct xfs_bmap_intent;
-
-void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
-
-enum xfs_attr_defer_op {
-	XFS_ATTR_DEFER_SET,
-	XFS_ATTR_DEFER_REMOVE,
-	XFS_ATTR_DEFER_REPLACE,
-};
-
-void xfs_attr_defer_add(struct xfs_da_args *args, enum xfs_attr_defer_op op);
-
-struct xfs_exchmaps_intent;
-
-void xfs_exchmaps_defer_add(struct xfs_trans *tp,
-		struct xfs_exchmaps_intent *xmi);
-
-struct xfs_extent_free_item;
-struct xfs_defer_pending;
-
-void xfs_extent_free_defer_add(struct xfs_trans *tp,
-		struct xfs_extent_free_item *xefi,
-		struct xfs_defer_pending **dfpp);
-
-struct xfs_rmap_intent;
-
-void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
-
-struct xfs_refcount_intent;
-
-void xfs_refcount_defer_add(struct xfs_trans *tp,
-		struct xfs_refcount_intent *ri);
-
-/* log intent size calculations */
-
-unsigned int xfs_efi_log_space(unsigned int nr);
-unsigned int xfs_efd_log_space(unsigned int nr);
-
-unsigned int xfs_rui_log_space(unsigned int nr);
-unsigned int xfs_rud_log_space(void);
-
-unsigned int xfs_bui_log_space(unsigned int nr);
-unsigned int xfs_bud_log_space(void);
-
-unsigned int xfs_cui_log_space(unsigned int nr);
-unsigned int xfs_cud_log_space(void);
-
-#endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
index 875e0caae988..8008c24a87a5 100644
--- a/libxfs/iunlink.c
+++ b/libxfs/iunlink.c
@@ -17,17 +17,9 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
-#include "iunlink.h"
+#include "xfs_iunlink_item.h"
 #include "xfs_trace.h"
 
-/* in memory log item structure */
-struct xfs_iunlink_item {
-	struct xfs_inode	*ip;
-	struct xfs_perag	*pag;
-	xfs_agino_t		next_agino;
-	xfs_agino_t		old_agino;
-};
-
 /*
  * Look up the inode cluster buffer and log the on-disk unlinked inode change
  * we need to make.
diff --git a/libxfs/stubs/xfs_inode.h b/libxfs/stubs/xfs_inode.h
index 0292beecf903..e6cfdd22c323 100644
--- a/libxfs/stubs/xfs_inode.h
+++ b/libxfs/stubs/xfs_inode.h
@@ -442,4 +442,12 @@ extern void	libxfs_irele(struct xfs_inode *ip);
 #define xfs_inherit_nosymlinks		(false)
 #define xfs_inherit_nodefrag		(false)
 
+static inline struct xfs_inode *
+xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino)
+{
+	return NULL;
+}
+int xfs_iunlink_reload_next(struct xfs_trans *tp, struct xfs_buf *agibp,
+		xfs_agino_t prev_agino, xfs_agino_t next_agino);
+
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 25015ad2795c..c71c9111187f 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -1315,3 +1315,15 @@ out_blocks:
 
 	return error;
 }
+
+void
+xfs_icreate_log(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	unsigned int		count,
+	unsigned int		inode_size,
+	xfs_agblock_t		length,
+	unsigned int		generation)
+{
+}
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 8feaa0edace1..d99602bcc16f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -27,7 +27,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_extfree_item.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 57a0a175c286..aaf1f9f83c20 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -24,7 +24,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
-#include "defer_item.h"
+#include "xfs_attr_item.h"
 #include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
diff --git a/libxfs/xfs_attr_item.h b/libxfs/xfs_attr_item.h
new file mode 100644
index 000000000000..d108a11b55ae
--- /dev/null
+++ b/libxfs/xfs_attr_item.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Allison Henderson <allison.henderson@oracle.com>
+ */
+#ifndef	__XFS_ATTR_ITEM_H__
+#define	__XFS_ATTR_ITEM_H__
+
+/* kernel only ATTRI/ATTRD definitions */
+
+struct xfs_mount;
+struct kmem_zone;
+
+struct xfs_attri_log_nameval {
+	struct kvec		name;
+	struct kvec		new_name;	/* PPTR_REPLACE only */
+	struct kvec		value;
+	struct kvec		new_value;	/* PPTR_REPLACE only */
+	refcount_t		refcount;
+
+	/* name and value follow the end of this struct */
+};
+
+/*
+ * This is the "attr intention" log item.  It is used to log the fact that some
+ * extended attribute operations need to be processed.  An operation is
+ * currently either a set or remove.  Set or remove operations are described by
+ * the xfs_attr_intent which may be logged to this intent.
+ *
+ * During a normal attr operation, name and value point to the name and value
+ * fields of the caller's xfs_da_args structure.  During a recovery, the name
+ * and value buffers are copied from the log, and stored in a trailing buffer
+ * attached to the xfs_attr_intent until they are committed.  They are freed
+ * when the xfs_attr_intent itself is freed when the work is done.
+ */
+struct xfs_attri_log_item {
+	struct xfs_log_item		attri_item;
+	atomic_t			attri_refcount;
+	struct xfs_attri_log_nameval	*attri_nameval;
+	struct xfs_attri_log_format	attri_format;
+};
+
+/*
+ * This is the "attr done" log item.  It is used to log the fact that some attrs
+ * earlier mentioned in an attri item have been freed.
+ */
+struct xfs_attrd_log_item {
+	struct xfs_log_item		attrd_item;
+	struct xfs_attri_log_item	*attrd_attrip;
+	struct xfs_attrd_log_format	attrd_format;
+};
+
+extern struct kmem_cache	*xfs_attri_cache;
+extern struct kmem_cache	*xfs_attrd_cache;
+
+enum xfs_attr_defer_op {
+	XFS_ATTR_DEFER_SET,
+	XFS_ATTR_DEFER_REMOVE,
+	XFS_ATTR_DEFER_REPLACE,
+};
+
+void xfs_attr_defer_add(struct xfs_da_args *args, enum xfs_attr_defer_op op);
+
+#endif	/* __XFS_ATTR_ITEM_H__ */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 18308d65f92d..148d036bab67 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -33,7 +33,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_bmap_item.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
 #include "xfs_rtgroup.h"
diff --git a/libxfs/xfs_bmap_item.h b/libxfs/xfs_bmap_item.h
new file mode 100644
index 000000000000..b42fee06899d
--- /dev/null
+++ b/libxfs/xfs_bmap_item.h
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef	__XFS_BMAP_ITEM_H__
+#define	__XFS_BMAP_ITEM_H__
+
+/*
+ * There are (currently) two pairs of bmap btree redo item types: map & unmap.
+ * The common abbreviations for these are BUI (bmap update intent) and BUD
+ * (bmap update done).  The redo item type is encoded in the flags field of
+ * each xfs_map_extent.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same transaction
+ * that records the associated bmbt updates.
+ *
+ * Should the system crash after the commit of the first transaction but
+ * before the commit of the final transaction in a series, log recovery will
+ * use the redo information recorded by the intent items to replay the
+ * bmbt metadata updates in the non-first transaction.
+ */
+
+/* kernel only BUI/BUD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_BUI_MAX_FAST_EXTENTS	1
+
+/*
+ * This is the "bmap update intent" log item.  It is used to log the fact that
+ * some reverse mappings need to change.  It is used in conjunction with the
+ * "bmap update done" log item described below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item; see the
+ * comments about that structure (in xfs_extfree_item.h) for more details.
+ */
+struct xfs_bui_log_item {
+	struct xfs_log_item		bui_item;
+	atomic_t			bui_refcount;
+	atomic_t			bui_next_extent;
+	struct xfs_bui_log_format	bui_format;
+};
+
+static inline size_t
+xfs_bui_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_bui_log_item, bui_format) +
+			xfs_bui_log_format_sizeof(nr);
+}
+
+/*
+ * This is the "bmap update done" log item.  It is used to log the fact that
+ * some bmbt updates mentioned in an earlier bui item have been performed.
+ */
+struct xfs_bud_log_item {
+	struct xfs_log_item		bud_item;
+	struct xfs_bui_log_item		*bud_buip;
+	struct xfs_bud_log_format	bud_format;
+};
+
+extern struct kmem_cache	*xfs_bui_cache;
+extern struct kmem_cache	*xfs_bud_cache;
+
+struct xfs_bmap_intent;
+
+void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
+
+unsigned int xfs_bui_log_space(unsigned int nr);
+unsigned int xfs_bud_log_space(void);
+
+#endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 7d6f949aa1f3..114463c101d6 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -22,7 +22,7 @@
 #include "xfs_error.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_exchmaps_item.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr_leaf.h"
diff --git a/libxfs/xfs_exchmaps_item.h b/libxfs/xfs_exchmaps_item.h
new file mode 100644
index 000000000000..efa368d25d09
--- /dev/null
+++ b/libxfs/xfs_exchmaps_item.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef	__XFS_EXCHMAPS_ITEM_H__
+#define	__XFS_EXCHMAPS_ITEM_H__
+
+/*
+ * The file mapping exchange intent item helps us exchange multiple file
+ * mappings between two inode forks.  It does this by tracking the range of
+ * file block offsets that still need to be exchanged, and relogs as progress
+ * happens.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same transaction
+ * that records the associated bmbt updates.
+ *
+ * Should the system crash after the commit of the first transaction but
+ * before the commit of the final transaction in a series, log recovery will
+ * use the redo information recorded by the intent items to replay the
+ * rest of the mapping exchanges.
+ */
+
+/* kernel only XMI/XMD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * This is the incore file mapping exchange intent log item.  It is used to log
+ * the fact that we are exchanging mappings between two files.  It is used in
+ * conjunction with the incore file mapping exchange done log item described
+ * below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item; see the
+ * comments about that structure (in xfs_extfree_item.h) for more details.
+ */
+struct xfs_xmi_log_item {
+	struct xfs_log_item		xmi_item;
+	atomic_t			xmi_refcount;
+	struct xfs_xmi_log_format	xmi_format;
+};
+
+/*
+ * This is the incore file mapping exchange done log item.  It is used to log
+ * the fact that an exchange mentioned in an earlier xmi item have been
+ * performed.
+ */
+struct xfs_xmd_log_item {
+	struct xfs_log_item		xmd_item;
+	struct xfs_xmi_log_item		*xmd_intent_log_item;
+	struct xfs_xmd_log_format	xmd_format;
+};
+
+extern struct kmem_cache	*xfs_xmi_cache;
+extern struct kmem_cache	*xfs_xmd_cache;
+
+struct xfs_exchmaps_intent;
+
+void xfs_exchmaps_defer_add(struct xfs_trans *tp,
+		struct xfs_exchmaps_intent *xmi);
+
+#endif	/* __XFS_EXCHMAPS_ITEM_H__ */
diff --git a/libxfs/xfs_extfree_item.h b/libxfs/xfs_extfree_item.h
new file mode 100644
index 000000000000..af1b0331f7af
--- /dev/null
+++ b/libxfs/xfs_extfree_item.h
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_EXTFREE_ITEM_H__
+#define	__XFS_EXTFREE_ITEM_H__
+
+/* kernel only EFI/EFD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_EFI_MAX_FAST_EXTENTS	16
+
+/*
+ * This is the "extent free intention" log item.  It is used to log the fact
+ * that some extents need to be free.  It is used in conjunction with the
+ * "extent free done" log item described below.
+ *
+ * The EFI is reference counted so that it is not freed prior to both the EFI
+ * and EFD being committed and unpinned. This ensures the EFI is inserted into
+ * the AIL even in the event of out of order EFI/EFD processing. In other words,
+ * an EFI is born with two references:
+ *
+ * 	1.) an EFI held reference to track EFI AIL insertion
+ * 	2.) an EFD held reference to track EFD commit
+ *
+ * On allocation, both references are the responsibility of the caller. Once the
+ * EFI is added to and dirtied in a transaction, ownership of reference one
+ * transfers to the transaction. The reference is dropped once the EFI is
+ * inserted to the AIL or in the event of failure along the way (e.g., commit
+ * failure, log I/O error, etc.). Note that the caller remains responsible for
+ * the EFD reference under all circumstances to this point. The caller has no
+ * means to detect failure once the transaction is committed, however.
+ * Therefore, an EFD is required after this point, even in the event of
+ * unrelated failure.
+ *
+ * Once an EFD is allocated and dirtied in a transaction, reference two
+ * transfers to the transaction. The EFD reference is dropped once it reaches
+ * the unpin handler. Similar to the EFI, the reference also drops in the event
+ * of commit failure or log I/O errors. Note that the EFD is not inserted in the
+ * AIL, so at this point both the EFI and EFD are freed.
+ */
+struct xfs_efi_log_item {
+	struct xfs_log_item	efi_item;
+	atomic_t		efi_refcount;
+	atomic_t		efi_next_extent;
+	struct xfs_efi_log_format efi_format;
+};
+
+static inline size_t
+xfs_efi_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_efi_log_item, efi_format) +
+			xfs_efi_log_format_sizeof(nr);
+}
+
+/*
+ * This is the "extent free done" log item.  It is used to log
+ * the fact that some extents earlier mentioned in an efi item
+ * have been freed.
+ */
+struct xfs_efd_log_item {
+	struct xfs_log_item	efd_item;
+	struct xfs_efi_log_item *efd_efip;
+	uint			efd_next_extent;
+	struct xfs_efd_log_format efd_format;
+};
+
+static inline size_t
+xfs_efd_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_efd_log_item, efd_format) +
+			xfs_efd_log_format_sizeof(nr);
+}
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_EFD_MAX_FAST_EXTENTS	16
+
+extern struct kmem_cache	*xfs_efi_cache;
+extern struct kmem_cache	*xfs_efd_cache;
+
+struct xfs_extent_free_item;
+
+void xfs_extent_free_defer_add(struct xfs_trans *tp,
+		struct xfs_extent_free_item *xefi,
+		struct xfs_defer_pending **dfpp);
+
+unsigned int xfs_efi_log_space(unsigned int nr);
+unsigned int xfs_efd_log_space(unsigned int nr);
+
+#endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 91f4cdf2e4f3..a064289e1634 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
+#include "xfs_icreate_item.h"
 #include "xfs_buf_item.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/libxfs/xfs_icreate_item.h b/libxfs/xfs_icreate_item.h
new file mode 100644
index 000000000000..64992823108a
--- /dev/null
+++ b/libxfs/xfs_icreate_item.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2008-2010, Dave Chinner
+ * All Rights Reserved.
+ */
+#ifndef XFS_ICREATE_ITEM_H
+#define XFS_ICREATE_ITEM_H	1
+
+/* in memory log item structure */
+struct xfs_icreate_item {
+	struct xfs_log_item	ic_item;
+	struct xfs_icreate_log	ic_format;
+};
+
+extern struct kmem_cache *xfs_icreate_cache;	/* inode create item */
+
+void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
+			xfs_agblock_t agbno, unsigned int count,
+			unsigned int inode_size, xfs_agblock_t length,
+			unsigned int generation);
+
+#endif	/* XFS_ICREATE_ITEM_H */
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index b4f556df64ed..16c4c2ccdbb8 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -20,8 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
-#include "xfs_inode_item.h"
-#include "iunlink.h"
+#include "xfs_iunlink_item.h"
 #include "xfs_inode_item.h"
 
 uint16_t
diff --git a/libxfs/iunlink.h b/libxfs/xfs_iunlink_item.h
similarity index 61%
rename from libxfs/iunlink.h
rename to libxfs/xfs_iunlink_item.h
index 8d8032cf9326..c793cdcaccde 100644
--- a/libxfs/iunlink.h
+++ b/libxfs/xfs_iunlink_item.h
@@ -10,15 +10,18 @@ struct xfs_trans;
 struct xfs_inode;
 struct xfs_perag;
 
-static inline struct xfs_inode *
-xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino)
-{
-	return NULL;
-}
+/* in memory log item structure */
+struct xfs_iunlink_item {
+	struct xfs_log_item	item;
+	struct xfs_inode	*ip;
+	struct xfs_perag	*pag;
+	xfs_agino_t		next_agino;
+	xfs_agino_t		old_agino;
+};
+
+extern struct kmem_cache *xfs_iunlink_cache;
 
 int xfs_iunlink_log_inode(struct xfs_trans *tp, struct xfs_inode *ip,
 			struct xfs_perag *pag, xfs_agino_t next_agino);
-int xfs_iunlink_reload_next(struct xfs_trans *tp, struct xfs_buf *agibp,
-		xfs_agino_t prev_agino, xfs_agino_t next_agino);
 
 #endif	/* XFS_IUNLINK_ITEM_H */
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 9420d8089e8c..992263f810f8 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -25,7 +25,7 @@
 #include "xfs_defer.h"
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
-#include "defer_item.h"
+#include "xfs_attr_item.h"
 #include "xfs_health.h"
 #include "xfs_attr_leaf.h"
 
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 4b0069fd70d7..4f4990a20dad 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -350,7 +350,6 @@ xfs_buf_readahead(
 #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
 
-#define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
 #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
 #define xlog_calc_iovec_len(len)		roundup(len, sizeof(uint32_t))
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 3615f747f82a..6b67308fa594 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -24,7 +24,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_refcount_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrefcount_btree.h"
 
diff --git a/libxfs/xfs_refcount_item.h b/libxfs/xfs_refcount_item.h
new file mode 100644
index 000000000000..0fc3f493342b
--- /dev/null
+++ b/libxfs/xfs_refcount_item.h
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef	__XFS_REFCOUNT_ITEM_H__
+#define	__XFS_REFCOUNT_ITEM_H__
+
+/*
+ * There are (currently) two pairs of refcount btree redo item types:
+ * increase and decrease.  The log items for these are CUI (refcount
+ * update intent) and CUD (refcount update done).  The redo item type
+ * is encoded in the flags field of each xfs_map_extent.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same
+ * transaction that records the associated refcountbt updates.
+ *
+ * Should the system crash after the commit of the first transaction
+ * but before the commit of the final transaction in a series, log
+ * recovery will use the redo information recorded by the intent items
+ * to replay the refcountbt metadata updates.
+ */
+
+/* kernel only CUI/CUD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_CUI_MAX_FAST_EXTENTS	16
+
+/*
+ * This is the "refcount update intent" log item.  It is used to log
+ * the fact that some reverse mappings need to change.  It is used in
+ * conjunction with the "refcount update done" log item described
+ * below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item;
+ * see the comments about that structure (in xfs_extfree_item.h) for
+ * more details.
+ */
+struct xfs_cui_log_item {
+	struct xfs_log_item		cui_item;
+	atomic_t			cui_refcount;
+	atomic_t			cui_next_extent;
+	struct xfs_cui_log_format	cui_format;
+};
+
+static inline size_t
+xfs_cui_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_cui_log_item, cui_format) +
+			xfs_cui_log_format_sizeof(nr);
+}
+
+/*
+ * This is the "refcount update done" log item.  It is used to log the
+ * fact that some refcountbt updates mentioned in an earlier cui item
+ * have been performed.
+ */
+struct xfs_cud_log_item {
+	struct xfs_log_item		cud_item;
+	struct xfs_cui_log_item		*cud_cuip;
+	struct xfs_cud_log_format	cud_format;
+};
+
+extern struct kmem_cache	*xfs_cui_cache;
+extern struct kmem_cache	*xfs_cud_cache;
+
+struct xfs_refcount_intent;
+
+void xfs_refcount_defer_add(struct xfs_trans *tp,
+		struct xfs_refcount_intent *ri);
+
+unsigned int xfs_cui_log_space(unsigned int nr);
+unsigned int xfs_cud_log_space(void);
+
+#endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 74600c99172d..34d218de21a9 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -24,7 +24,7 @@
 #include "xfs_inode.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
-#include "defer_item.h"
+#include "xfs_rmap_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 
diff --git a/libxfs/xfs_rmap_item.h b/libxfs/xfs_rmap_item.h
new file mode 100644
index 000000000000..3a99f0117f2d
--- /dev/null
+++ b/libxfs/xfs_rmap_item.h
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef	__XFS_RMAP_ITEM_H__
+#define	__XFS_RMAP_ITEM_H__
+
+/*
+ * There are (currently) three pairs of rmap btree redo item types: map, unmap,
+ * and convert.  The common abbreviations for these are RUI (rmap update
+ * intent) and RUD (rmap update done).  The redo item type is encoded in the
+ * flags field of each xfs_map_extent.
+ *
+ * *I items should be recorded in the *first* of a series of rolled
+ * transactions, and the *D items should be recorded in the same transaction
+ * that records the associated rmapbt updates.  Typically, the first
+ * transaction will record a bmbt update, followed by some number of
+ * transactions containing rmapbt updates, and finally transactions with any
+ * bnobt/cntbt updates.
+ *
+ * Should the system crash after the commit of the first transaction but
+ * before the commit of the final transaction in a series, log recovery will
+ * use the redo information recorded by the intent items to replay the
+ * (rmapbt/bnobt/cntbt) metadata updates in the non-first transaction.
+ */
+
+/* kernel only RUI/RUD definitions */
+
+struct xfs_mount;
+struct kmem_cache;
+
+/*
+ * Max number of extents in fast allocation path.
+ */
+#define	XFS_RUI_MAX_FAST_EXTENTS	16
+
+/*
+ * This is the "rmap update intent" log item.  It is used to log the fact that
+ * some reverse mappings need to change.  It is used in conjunction with the
+ * "rmap update done" log item described below.
+ *
+ * These log items follow the same rules as struct xfs_efi_log_item; see the
+ * comments about that structure (in xfs_extfree_item.h) for more details.
+ */
+struct xfs_rui_log_item {
+	struct xfs_log_item		rui_item;
+	atomic_t			rui_refcount;
+	atomic_t			rui_next_extent;
+	struct xfs_rui_log_format	rui_format;
+};
+
+static inline size_t
+xfs_rui_log_item_sizeof(
+	unsigned int		nr)
+{
+	return offsetof(struct xfs_rui_log_item, rui_format) +
+			xfs_rui_log_format_sizeof(nr);
+}
+
+/*
+ * This is the "rmap update done" log item.  It is used to log the fact that
+ * some rmapbt updates mentioned in an earlier rui item have been performed.
+ */
+struct xfs_rud_log_item {
+	struct xfs_log_item		rud_item;
+	struct xfs_rui_log_item		*rud_ruip;
+	struct xfs_rud_log_format	rud_format;
+};
+
+extern struct kmem_cache	*xfs_rui_cache;
+extern struct kmem_cache	*xfs_rud_cache;
+
+struct xfs_rmap_intent;
+
+void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
+
+unsigned int xfs_rui_log_space(unsigned int nr);
+unsigned int xfs_rud_log_space(void);
+
+#endif	/* __XFS_RMAP_ITEM_H__ */
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index d15ca0427584..3a87ab154bb5 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -19,9 +19,14 @@
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_attr_item.h"
 #include "xfs_log.h"
+#include "xfs_defer.h"
+#include "xfs_bmap_item.h"
+#include "xfs_extfree_item.h"
+#include "xfs_rmap_item.h"
+#include "xfs_refcount_item.h"
 #include "xfs_trace.h"
-#include "defer_item.h"
 
 #define _ALLOC	true
 #define _FREE	false
-- 
2.53.0

