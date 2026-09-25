Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FA437AA79
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349698; cv=none; b=KN2vX+I4gKUXUV//CD3av46rv5N0D8YfU6TLbSs+cYqi5bI8lQERUD2MENPRd28Nl6ghMjhv2AewEz/9YMZJ/LyZQ/l7JIWeCwUJnG/o3n1tmumUenBNI4WaXQbGKioCoPCLomKQAswNYs/NjqwbddFYEMbLs2tGIQxIu4oWT3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349698; c=relaxed/simple;
	bh=zH1WtNjgkSD2mrVNE7Kwbvv1Us0rUjrw6m8lCpAgmcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDhoBmQy3M1mu8k5I4pq8SSqWieyZDrNwG+g4TwevaXKQWjn2dmNF5VGDDYu6+NkfqqMUiay9ZbDXONk8Jt855U5aZUNzwfOrz+YsLuvZtAhhYALih2s0HIzMlK4S93WRHc/NEA+CUl+4QH6xJUtjwVL+LVMcfkbpOY+V7CRKw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XtzLww1V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XtzLww1V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rD0JnWXsm2XIzjW824tsRxmQzx641ft6jniQ8WHZpbY=; b=XtzLww1VIOP5fGY9dnPMjMMWS4
	UWgMQ8OWt4FgnG+j8wilwMcmL4fOH/WG25WYuy9nJD2W83zPN0zK85NyN+UYiWMTmyt8N3bSRimVL
	97Jz4uApdInrGc8PDDxqBQPv0Ptzj5VZITU/KqulcPH+ve+7FM3mjaG23qyhdsdPrU00nI8EZhVpZ
	Fh9g8nT5ZCB++MZXvygnwnzP28aqTKDmgYfcZqcImPeXtGtu6MY+nAhyo4jBAU9EKFN1pxTVC1Tlo
	uuAjmi/prsTSILwnQdAc97PLF6UlasiWvq7MIKuqFqyzCEHeYMTVRSVpyVMyroFEoMswh16nqUPwJ
	JP4FDTdA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7k0-0000000Dled-021o;
	Fri, 25 Sep 2026 15:21:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 10/13] libxfs: use xfs_buf_item.h and xfs_inode_item.h from the kernel source
Date: Fri, 25 Sep 2026 17:20:29 +0200
Message-ID: <20260925152107.3386097-11-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925152107.3386097-1-hch@lst.de>
References: <20260925152107.3386097-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace the partial copy and paste in xfs_trans.h with full copies of
the kernel versions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/buf_mem.c            |  1 +
 libxfs/init.c               |  2 ++
 libxfs/inode.c              |  1 +
 libxfs/logitem.c            |  4 ++-
 libxfs/stubs/xfs_trans.h    | 24 -------------
 libxfs/trans.c              |  6 ++--
 libxfs/xfs_alloc.c          |  1 +
 libxfs/xfs_attr_leaf.c      |  1 +
 libxfs/xfs_bmap.c           |  1 +
 libxfs/xfs_btree.c          |  1 +
 libxfs/xfs_btree_mem.c      |  1 +
 libxfs/xfs_buf_item.h       | 71 +++++++++++++++++++++++++++++++++++++
 libxfs/xfs_da_btree.c       |  1 +
 libxfs/xfs_defer.c          |  2 ++
 libxfs/xfs_dir2_block.c     |  1 +
 libxfs/xfs_dir2_data.c      |  1 +
 libxfs/xfs_dir2_leaf.c      |  1 +
 libxfs/xfs_dir2_node.c      |  1 +
 libxfs/xfs_ialloc.c         |  1 +
 libxfs/xfs_inode_fork.c     |  1 +
 libxfs/xfs_inode_item.h     | 62 ++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.c     |  1 +
 libxfs/xfs_rtbitmap.c       |  1 +
 libxfs/xfs_rtgroup.c        |  1 +
 libxfs/xfs_sb.c             |  1 +
 libxfs/xfs_symlink_remote.c |  1 +
 libxfs/xfs_trans_inode.c    |  2 +-
 27 files changed, 164 insertions(+), 28 deletions(-)
 create mode 100644 libxfs/xfs_buf_item.h
 create mode 100644 libxfs/xfs_inode_item.h

diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
index 3c8452de9689..cb7e55129d18 100644
--- a/libxfs/buf_mem.c
+++ b/libxfs/buf_mem.c
@@ -6,6 +6,7 @@
 #include "xfs_platform.h"
 #include "libxfs.h"
 #include "xfs_buf_mem.h"
+#include "xfs_buf_item.h"
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/wait.h>
diff --git a/libxfs/init.c b/libxfs/init.c
index b89c9fe360d4..5f0b7dd6a9f2 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -19,6 +19,8 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_inode_item.h"
+#include "xfs_buf_item.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_metafile.h"
diff --git a/libxfs/inode.c b/libxfs/inode.c
index b6838d3d4bd3..482b2d4b55bb 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -19,6 +19,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 2e050ad92a1e..432dccbe5649 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -11,10 +11,12 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
-#include "xfs_trans.h"
+#include "xfs_inode_item.h"
+#include "xfs_buf_item.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
 
diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
index 9e8737f09d8e..aa4de91b43a9 100644
--- a/libxfs/stubs/xfs_trans.h
+++ b/libxfs/stubs/xfs_trans.h
@@ -33,30 +33,6 @@ struct xfs_log_item {
 
 #define XFS_LI_DIRTY	3	/* log item dirty in transaction */
 
-struct xfs_inode_log_item {
-	struct xfs_log_item	ili_item;		/* common portion */
-	struct xfs_inode	*ili_inode;		/* inode pointer */
-	unsigned short		ili_lock_flags;		/* lock flags */
-	unsigned int		ili_dirty_flags;	/* dirty in current tx */
-	unsigned int		ili_last_fields;	/* fields when flushed*/
-	unsigned int		ili_fields;		/* fields to be logged */
-	spinlock_t		ili_lock;
-};
-
- struct xfs_buf_log_item {
-	struct xfs_log_item	bli_item;	/* common item structure */
-	struct xfs_buf		*bli_buf;	/* real buffer pointer */
-	unsigned int		bli_flags;	/* misc flags */
-	unsigned int		bli_recur;	/* recursion count */
-	struct xfs_buf_log_format	__bli_format;	/* in-log header */
-};
-
-#define XFS_BLI_DIRTY			(1<<0)
-#define XFS_BLI_HOLD			(1<<1)
-#define XFS_BLI_STALE			(1<<2)
-#define XFS_BLI_INODE_ALLOC_BUF		(1<<3)
-#define XFS_BLI_ORDERED			(1<<4)
-
 typedef struct xfs_trans {
 	unsigned int		t_log_res;	/* amt of log space resvd */
 	unsigned int		t_log_count;	/* count for perm log res */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index f36c54b9c806..de7019e9051a 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -12,14 +12,16 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
-#include "xfs_trans.h"
+#include "xfs_inode_item.h"
 #include "xfs_sb.h"
 #include "xfs_defer.h"
 #include "xfs_trace.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_buf_item.h"
 
 static void xfs_trans_free_items(struct xfs_trans *tp);
 STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
@@ -339,7 +341,7 @@ libxfs_trans_cancel(
 	xfs_trans_free(tp);
 }
 
-static void
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 4cad09d8be61..13ec03c3b45a 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -21,6 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 0ac2ae28efa6..240864676aec 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -24,6 +24,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_buf_item.h"
 #include "xfs_dir2.h"
 #include "xfs_ag.h"
 #include "xfs_errortag.h"
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cfce4358e2bf..18308d65f92d 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -25,6 +25,7 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
+#include "xfs_buf_item.h"
 #include "xfs_trace.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_rmap.h"
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 425fbefc31ad..9fcb6c349523 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_btree.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
index c2fa836a2ae2..37136a70e56d 100644
--- a/libxfs/xfs_btree_mem.c
+++ b/libxfs/xfs_btree_mem.c
@@ -16,6 +16,7 @@
 #include "xfs_buf_mem.h"
 #include "xfs_btree_mem.h"
 #include "xfs_ag.h"
+#include "xfs_buf_item.h"
 #include "xfs_trace.h"
 #include "xfs_rtgroup.h"
 
diff --git a/libxfs/xfs_buf_item.h b/libxfs/xfs_buf_item.h
new file mode 100644
index 000000000000..3159325dd17b
--- /dev/null
+++ b/libxfs/xfs_buf_item.h
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_BUF_ITEM_H__
+#define	__XFS_BUF_ITEM_H__
+
+/* kernel only definitions */
+
+struct xfs_buf;
+struct xfs_mount;
+
+/* buf log item flags */
+#define	XFS_BLI_HOLD		(1u << 0)
+#define	XFS_BLI_DIRTY		(1u << 1)
+#define	XFS_BLI_STALE		(1u << 2)
+#define	XFS_BLI_LOGGED		(1u << 3)
+#define	XFS_BLI_INODE_ALLOC_BUF	(1u << 4)
+#define XFS_BLI_STALE_INODE	(1u << 5)
+#define	XFS_BLI_INODE_BUF	(1u << 6)
+#define	XFS_BLI_ORDERED		(1u << 7)
+
+#define XFS_BLI_FLAGS \
+	{ XFS_BLI_HOLD,		"HOLD" }, \
+	{ XFS_BLI_DIRTY,	"DIRTY" }, \
+	{ XFS_BLI_STALE,	"STALE" }, \
+	{ XFS_BLI_LOGGED,	"LOGGED" }, \
+	{ XFS_BLI_INODE_ALLOC_BUF, "INODE_ALLOC" }, \
+	{ XFS_BLI_STALE_INODE,	"STALE_INODE" }, \
+	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }, \
+	{ XFS_BLI_ORDERED,	"ORDERED" }
+
+/*
+ * This is the in core log item structure used to track information
+ * needed to log buffers.  It tracks how many times the lock has been
+ * locked, and which 128 byte chunks of the buffer are dirty.
+ */
+struct xfs_buf_log_item {
+	struct xfs_log_item	bli_item;	/* common item structure */
+	struct xfs_buf		*bli_buf;	/* real buffer pointer */
+	unsigned int		bli_flags;	/* misc flags */
+	unsigned int		bli_recur;	/* lock recursion count */
+	atomic_t		bli_refcount;	/* cnt of tp refs */
+	int			bli_format_count;	/* count of headers */
+	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
+	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
+};
+
+int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
+void	xfs_buf_item_done(struct xfs_buf *bp);
+void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
+void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
+bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
+void	xfs_buf_inode_iodone(struct xfs_buf *);
+#ifdef CONFIG_XFS_QUOTA
+void	xfs_buf_dquot_iodone(struct xfs_buf *);
+#else
+static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
+{
+}
+#endif /* CONFIG_XFS_QUOTA */
+void	xfs_buf_iodone(struct xfs_buf *);
+bool	xfs_buf_log_check_iovec(struct kvec *iovec);
+
+unsigned int xfs_buf_inval_log_space(unsigned int map_count,
+		unsigned int blocksize);
+
+extern struct kmem_cache	*xfs_buf_item_cache;
+
+#endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 9f25f1658b07..a3a3a1aa4c57 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -20,6 +20,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_buf_item.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
 
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index eae2397fbff8..28e8dcf14475 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -12,7 +12,9 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_inode.h"
+#include "xfs_inode_item.h"
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 0e9dd19eafae..54cb8b645c9c 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -14,6 +14,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
+#include "xfs_buf_item.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 0fafe7826ec9..23625d647da4 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -16,6 +16,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_health.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index ea8ab6d46c6c..bc909543eb74 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -18,6 +18,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_health.h"
 
 /*
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index a0aaa21b12cf..7641cbdb8e10 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -18,6 +18,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_health.h"
 
 /*
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index aa895c0decbc..07f6c0094281 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index df89ae420617..606a36526ce2 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_inode_item.h"
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
diff --git a/libxfs/xfs_inode_item.h b/libxfs/xfs_inode_item.h
new file mode 100644
index 000000000000..2ddcca41714f
--- /dev/null
+++ b/libxfs/xfs_inode_item.h
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_INODE_ITEM_H__
+#define	__XFS_INODE_ITEM_H__
+
+/* kernel only definitions */
+
+struct xfs_buf;
+struct xfs_bmbt_rec;
+struct xfs_inode;
+struct xfs_mount;
+
+struct xfs_inode_log_item {
+	struct xfs_log_item	ili_item;	   /* common portion */
+	struct xfs_inode	*ili_inode;	   /* inode ptr */
+	unsigned short		ili_lock_flags;	   /* inode lock flags */
+	unsigned int		ili_dirty_flags;   /* dirty in current tx */
+	/*
+	 * The ili_lock protects the interactions between the dirty state and
+	 * the flush state of the inode log item. This allows us to do atomic
+	 * modifications of multiple state fields without having to hold a
+	 * specific inode lock to serialise them.
+	 *
+	 * We need atomic changes between inode dirtying, inode flushing and
+	 * inode completion, but these all hold different combinations of
+	 * ILOCK and IFLUSHING and hence we need some other method of
+	 * serialising updates to the flush state.
+	 */
+	spinlock_t		ili_lock;	   /* flush state lock */
+	unsigned int		ili_last_fields;   /* fields when flushed */
+	unsigned int		ili_fields;	   /* fields to be logged */
+	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
+
+	/*
+	 * We record the sequence number for every inode modification, as
+	 * well as those that only require fdatasync operations for data
+	 * integrity. This allows optimisation of the O_DSYNC/fdatasync path
+	 * without needing to track what modifications the journal is currently
+	 * carrying for the inode. These are protected by the above ili_lock.
+	 */
+	xfs_csn_t		ili_commit_seq;	   /* last transaction commit */
+	xfs_csn_t		ili_datasync_seq;  /* for datasync optimisation */
+};
+
+static inline int xfs_inode_clean(struct xfs_inode *ip)
+{
+	return !ip->i_itemp || !(ip->i_itemp->ili_fields & XFS_ILOG_ALL);
+}
+
+extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
+extern void xfs_inode_item_destroy(struct xfs_inode *);
+extern void xfs_iflush_abort(struct xfs_inode *);
+extern void xfs_iflush_shutdown_abort(struct xfs_inode *);
+int xfs_inode_item_format_convert(struct kvec *buf,
+		struct xfs_inode_log_format *in_f);
+
+extern struct kmem_cache	*xfs_ili_cache;
+
+#endif	/* __XFS_INODE_ITEM_H__ */
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 9de455088568..6e45cc515847 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -21,6 +21,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "iunlink.h"
+#include "xfs_inode_item.h"
 
 uint16_t
 xfs_flags2diflags(
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 6a0fc1032753..d4b90548718c 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -21,6 +21,7 @@
 #include "xfs_health.h"
 #include "xfs_sb.h"
 #include "xfs_errortag.h"
+#include "xfs_buf_item.h"
 #include "xfs_extent_busy.h"
 
 /*
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index c1f8d2cb186a..2bbe651b773a 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -27,6 +27,7 @@
 #include "xfs_trans.h"
 #include "xfs_trace.h"
 #include "xfs_inode.h"
+#include "xfs_buf_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index cccbcd153316..696bafd2cc3e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -16,6 +16,7 @@
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_rmap_btree.h"
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index de487b1caa4b..008953d402f6 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -14,6 +14,7 @@
 #include "xfs_inode.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index ef404e7f0f6e..697671007561 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -12,7 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-
+#include "xfs_inode_item.h"
 
 /*
  * Add a locked inode to the transaction.
-- 
2.53.0

