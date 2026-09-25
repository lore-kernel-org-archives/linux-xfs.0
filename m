Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6A439060A
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349704; cv=none; b=qgPrZE6CDcGP09vW685dZdN+JiHtNEXrtkSawm1VgJmME8YqnWNFC69tI5IScr3DAq6PHaf+oYVB6h7i9QnCb7D1HnbKlfFPmgRHdtd+MQhQLwlomzGpcQAgkV4w+HvwUPfg90/UXtMifigq1lsYvJ61YY5LLJk12CvQVHn1KO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349704; c=relaxed/simple;
	bh=IF0Gal0XfcmNlae8c5TLwkKyk6GtgYkl5SbjP3pMmCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nedUQHLS4ndOtF9K4fzayicpY1B8OR9TGmZdH9/iTiW5flk/doOUvmPUlWplzULOxL36eSahDLm6KiE+loRGV3Lj7LkimjtIdx30Xd9kNksV63PRLwlHLvHTZ9msC+r4/mlD6pUiFNd+iFitT/XK5DWPZFgC2MY1bZiSu2OZgjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CK7e/npz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CK7e/npz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HbUgtsBtlNg1imqhXDskmRnDG+Rz3A3Ut7kAMi+jR7Y=; b=CK7e/npzlNyjwC+oqDywg+8KX9
	7tcBVrjnVIi6hZM7DSwFLnV5sOzA5A5SlSh6oou8hPWdjI/m3pLAZwmWmOC/m9Ui1ij4IgVdGRY4l
	PHwvN30/3tbqohJ+JpF6YWXJ3NXYVJZ94BiAyRC7B097zfAHCIUctHTcNxcpKkfW3o/lPJ6lRBwtL
	0RJhKNe4CgyJ1kP/eElgBFj9JPB9JYO9nITc1qsDQXgX84zRjezG2TEsWQlQzNkFMIL6uiHqfJCNX
	ykyfWeA6UT6wjQ3gem1gccgcrwtjddMM99nM88a68AvGmFwfbnzPpEmdrgQnO9QBT+j1bzgSsviu7
	lvdYPkPQ==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7k5-0000000DlfX-14p6;
	Fri, 25 Sep 2026 15:21:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/13] libxfs: use xfs_trans.h from the kernel source
Date: Fri, 25 Sep 2026 17:20:31 +0200
Message-ID: <20260925152107.3386097-13-hch@lst.de>
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

Replace the the existing xfs_trans.h with a copy of the kernel versions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/Makefile             |   8 +-
 libxfs/init.c               |   1 +
 libxfs/inode.c              |   1 +
 libxfs/libxfs_api_defs.h    |   1 +
 libxfs/logitem.c            |   1 +
 libxfs/trans.c              |  23 +++
 libxfs/xfs_alloc.c          |   1 +
 libxfs/xfs_attr_leaf.c      |   1 +
 libxfs/xfs_btree.c          |   1 +
 libxfs/xfs_da_btree.c       |   1 +
 libxfs/xfs_dir2_block.c     |   1 +
 libxfs/xfs_dir2_data.c      |   1 +
 libxfs/xfs_dir2_node.c      |   1 +
 libxfs/xfs_ialloc.c         |   1 +
 libxfs/xfs_inode_util.c     |   1 +
 libxfs/xfs_platform.h       |  19 ---
 libxfs/xfs_rtbitmap.c       |   1 +
 libxfs/xfs_sb.c             |   1 +
 libxfs/xfs_symlink_remote.c |   1 +
 libxfs/xfs_trans.h          | 283 ++++++++++++++++++++++++++++++++++++
 libxfs/xfs_trans_inode.c    |   1 +
 libxfs/xfs_trans_resv.c     |   1 +
 22 files changed, 329 insertions(+), 22 deletions(-)
 create mode 100644 libxfs/xfs_trans.h

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 9795982b0e83..c655d092d79e 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -37,6 +37,7 @@ HFILES = \
 	xfs_attr_leaf.h \
 	xfs_attr_sf.h \
 	xfs_bit.h \
+	xfs_buf_item.h \
 	xfs_bmap.h \
 	xfs_bmap_btree.h \
 	xfs_btree.h \
@@ -46,6 +47,7 @@ HFILES = \
 	xfs_cksum.h \
 	xfs_da_btree.h \
 	xfs_dir2.h \
+	xfs_dir2_priv.h \
 	xfs_errortag.h \
 	xfs_exchmaps.h \
 	xfs_group.h \
@@ -53,6 +55,7 @@ HFILES = \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
+	xfs_inode_item.h \
 	xfs_inode_util.h \
 	xfs_log_recover.h \
 	xfs_metadir.h \
@@ -71,7 +74,7 @@ HFILES = \
 	xfs_shared.h \
 	xfs_trans_resv.h \
 	xfs_trans_space.h \
-	xfs_dir2_priv.h \
+	xfs_trans.h \
 	xfs_zones.h \
 	stubs/xfs_buf_mem.h \
 	stubs/xfs_error.h \
@@ -79,8 +82,7 @@ HFILES = \
 	stubs/xfs_inode.h \
 	stubs/xfs_mount.h \
 	stubs/xfs_quota.h \
-	stubs/xfs_trace.h \
-	stubs/xfs_trans.h
+	stubs/xfs_trace.h
 
 CFILES = buf_mem.c \
 	cache.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index 5f0b7dd6a9f2..9b2157dd2237 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -15,6 +15,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
+#include "xfs_trans.h"
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 482b2d4b55bb..cf6830aed49a 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -15,6 +15,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
+#include "xfs_trans.h"
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 4f542ae7267e..300135fcac8b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -391,6 +391,7 @@
 #define xfs_trans_ordered_buf		libxfs_trans_ordered_buf
 #define xfs_trans_read_buf		libxfs_trans_read_buf
 #define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
+#define xfs_trans_reserve_more		libxfs_trans_reserve_more
 #define xfs_trans_resv_calc		libxfs_trans_resv_calc
 #define xfs_trans_roll_inode		libxfs_trans_roll_inode
 #define xfs_trans_roll			libxfs_trans_roll
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 432dccbe5649..8e81c338e0ab 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -14,6 +14,7 @@
 #include "xfs_trans.h"
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
+#include "xfs_trans.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_buf_item.h"
diff --git a/libxfs/trans.c b/libxfs/trans.c
index de7019e9051a..8db8ba9ac670 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -17,6 +17,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
+#include "xfs_buf_item.h"
 #include "xfs_sb.h"
 #include "xfs_defer.h"
 #include "xfs_trace.h"
@@ -353,6 +354,21 @@ xfs_buf_item_put(
 
 /* from xfs_trans_buf.c */
 
+void
+xfs_trans_buf_set_type(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	enum xfs_blft		type)
+{
+}
+
+void
+xfs_trans_buf_copy_type(
+	struct xfs_buf		*dst_bp,
+	struct xfs_buf		*src_bp)
+{
+}
+
 /*
  * Add the locked buffer to the transaction.
  *
@@ -765,6 +781,13 @@ libxfs_trans_binval(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
+void
+xfs_trans_inode_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+}
+
 /*
  * Mark the buffer as being one which contains newly allocated
  * inodes.  We need to make sure that even if this buffer is
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 13ec03c3b45a..8feaa0edace1 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 240864676aec..86c5c09a5db4 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_dir2.h"
+#include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 9fcb6c349523..60ef7f08b1d3 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -19,6 +19,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_alloc.h"
+#include "xfs_log.h"
 #include "xfs_btree_staging.h"
 #include "xfs_ag.h"
 #include "xfs_alloc_btree.h"
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index a3a3a1aa4c57..9debb95d86fa 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -21,6 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
 
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 54cb8b645c9c..6d70e6b429e7 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -19,6 +19,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 #include "xfs_health.h"
 
 /*
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 23625d647da4..aecbab61014c 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -17,6 +17,7 @@
 #include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 #include "xfs_health.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 7641cbdb8e10..19cb536e53ef 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 #include "xfs_health.h"
 
 /*
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 07f6c0094281..91f4cdf2e4f3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -22,6 +22,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 6e45cc515847..b4f556df64ed 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
+#include "xfs_inode_item.h"
 #include "iunlink.h"
 #include "xfs_inode_item.h"
 
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 2e3d323505c5..4b0069fd70d7 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -314,16 +314,6 @@ xfs_buf_incore(
 void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
-/* mount stuff */
-#define xfs_trans_set_sync(tp)		((void) 0)
-#define xfs_trans_buf_set_type(tp, bp, t)	({	\
-	int __t = (t);					\
-	__t = __t; /* no set-but-unused warning */	\
-	tp = tp;  /* no set-but-unused warning */	\
-})
-
-#define xfs_trans_buf_copy_type(dbp, sbp)
-
 static inline void
 xfs_buf_readahead(
 	struct xfs_buftarg	*target,
@@ -357,8 +347,6 @@ xfs_buf_readahead(
 #define xfs_filestream_new_ag(ip,ag)		(0)
 #define xfs_filestream_select_ag(...)		(-ENOSYS)
 
-#define xfs_trans_inode_buf(tp, bp)		((void) 0)
-
 #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
 
@@ -404,13 +392,6 @@ int xfs_trans_roll(struct xfs_trans **);
 void xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void xfs_trans_del_item(struct xfs_log_item *);
 
-/* xfs_inode_item.c */
-void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
-
-/* xfs_buf_item.c */
-int xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
-void xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
-
 /* xfs_trans_buf.c */
 struct xfs_buf *xfs_trans_buf_item_match(struct xfs_trans *,
 			struct xfs_buftarg *, struct xfs_buf_map *, int);
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index d4b90548718c..590e0641ff0d 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -21,6 +21,7 @@
 #include "xfs_health.h"
 #include "xfs_sb.h"
 #include "xfs_errortag.h"
+#include "xfs_log.h"
 #include "xfs_buf_item.h"
 #include "xfs_extent_busy.h"
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 696bafd2cc3e..aae63ccdb6b5 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -19,6 +19,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
+#include "xfs_log.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_da_format.h"
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 008953d402f6..b0dc3888bf1b 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -15,6 +15,7 @@
 #include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
diff --git a/libxfs/xfs_trans.h b/libxfs/xfs_trans.h
new file mode 100644
index 000000000000..eb83c5dac032
--- /dev/null
+++ b/libxfs/xfs_trans.h
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_TRANS_H__
+#define	__XFS_TRANS_H__
+
+/* kernel only transaction subsystem defines */
+
+struct xlog;
+struct xlog_format_buf;
+struct xfs_buf;
+struct xfs_buftarg;
+struct xfs_efd_log_item;
+struct xfs_efi_log_item;
+struct xfs_inode;
+struct xfs_item_ops;
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_trans_res;
+struct xfs_dquot_acct;
+struct xfs_rud_log_item;
+struct xfs_rui_log_item;
+struct xfs_btree_cur;
+struct xfs_cui_log_item;
+struct xfs_cud_log_item;
+struct xfs_bui_log_item;
+struct xfs_bud_log_item;
+
+struct xfs_log_item {
+	struct list_head		li_ail;		/* AIL pointers */
+	struct list_head		li_trans;	/* transaction list */
+	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
+	struct xlog			*li_log;
+	struct xfs_ail			*li_ailp;	/* ptr to AIL */
+	uint				li_type;	/* item type */
+	unsigned long			li_flags;	/* misc flags */
+	struct xfs_buf			*li_buf;	/* real buffer pointer */
+	struct list_head		li_bio_list;	/* buffer item list */
+	const struct xfs_item_ops	*li_ops;	/* function list */
+
+	/* delayed logging */
+	struct list_head		li_cil;		/* CIL pointers */
+	struct xfs_log_vec		*li_lv;		/* active log vector */
+	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
+	xfs_csn_t			li_seq;		/* CIL commit seq */
+	uint32_t			li_order_id;	/* CIL commit order */
+};
+
+/*
+ * li_flags use the (set/test/clear)_bit atomic interfaces because updates can
+ * race with each other and we don't want to have to use the AIL lock to
+ * serialise all updates.
+ */
+#define	XFS_LI_IN_AIL	0
+#define	XFS_LI_ABORTED	1
+#define	XFS_LI_FAILED	2
+#define	XFS_LI_DIRTY	3
+#define	XFS_LI_WHITEOUT	4
+#define	XFS_LI_FLUSHING	5
+
+#define XFS_LI_FLAGS \
+	{ (1u << XFS_LI_IN_AIL),	"IN_AIL" }, \
+	{ (1u << XFS_LI_ABORTED),	"ABORTED" }, \
+	{ (1u << XFS_LI_FAILED),	"FAILED" }, \
+	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
+	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }, \
+	{ (1u << XFS_LI_FLUSHING),	"FLUSHING" }
+
+struct xfs_item_ops {
+	unsigned flags;
+	void (*iop_size)(struct xfs_log_item *, int *, int *);
+	void (*iop_format)(struct xfs_log_item *lip,
+			struct xlog_format_buf *lfb);
+	void (*iop_pin)(struct xfs_log_item *);
+	void (*iop_unpin)(struct xfs_log_item *, int remove);
+	uint64_t (*iop_sort)(struct xfs_log_item *lip);
+	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
+	void (*iop_committing)(struct xfs_log_item *lip, xfs_csn_t seq);
+	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
+	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
+	void (*iop_release)(struct xfs_log_item *);
+	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
+	struct xfs_log_item *(*iop_intent)(struct xfs_log_item *intent_done);
+};
+
+/*
+ * Log item ops flags
+ */
+/*
+ * Release the log item when the journal commits instead of inserting into the
+ * AIL for writeback tracking and/or log tail pinning.
+ */
+#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
+#define XFS_ITEM_INTENT			(1 << 1)
+#define XFS_ITEM_INTENT_DONE		(1 << 2)
+
+static inline bool
+xlog_item_is_intent(struct xfs_log_item *lip)
+{
+	return lip->li_ops->flags & XFS_ITEM_INTENT;
+}
+
+static inline bool
+xlog_item_is_intent_done(struct xfs_log_item *lip)
+{
+	return lip->li_ops->flags & XFS_ITEM_INTENT_DONE;
+}
+
+void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
+			  int type, const struct xfs_item_ops *ops);
+
+/*
+ * Return values for the iop_push() routines.
+ */
+#define XFS_ITEM_SUCCESS	0
+#define XFS_ITEM_PINNED		1
+#define XFS_ITEM_LOCKED		2
+#define XFS_ITEM_FLUSHING	3
+
+/*
+ * This is the structure maintained for every active transaction.
+ */
+typedef struct xfs_trans {
+	unsigned int		t_log_res;	/* amt of log space resvd */
+	unsigned int		t_log_count;	/* count for perm log res */
+	unsigned int		t_blk_res;	/* # of blocks resvd */
+	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
+	unsigned int		t_rtx_res;	/* # of rt extents resvd */
+	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
+	unsigned int		t_flags;	/* misc flags */
+	xfs_agnumber_t		t_highest_agno;	/* highest AGF locked */
+	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
+	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
+	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
+	int64_t			t_icount_delta;	/* superblock icount change */
+	int64_t			t_ifree_delta;	/* superblock ifree change */
+	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
+	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
+	int64_t			t_frextents_delta;/* superblock freextents chg*/
+	int64_t			t_res_frextents_delta; /* on-disk only chg */
+	int64_t			t_dblocks_delta;/* superblock dblocks change */
+	int64_t			t_agcount_delta;/* superblock agcount change */
+	int64_t			t_imaxpct_delta;/* superblock imaxpct change */
+	int64_t			t_rextsize_delta;/* superblock rextsize chg */
+	int64_t			t_rbmblocks_delta;/* superblock rbmblocks chg */
+	int64_t			t_rblocks_delta;/* superblock rblocks change */
+	int64_t			t_rextents_delta;/* superblocks rextents chg */
+	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
+	int64_t			t_rgcount_delta; /* realtime group count */
+	struct list_head	t_items;	/* log item descriptors */
+	struct list_head	t_busy;		/* list of busy extents */
+	struct list_head	t_dfops;	/* deferred operations */
+	unsigned long		t_pflags;	/* saved process flags state */
+} xfs_trans_t;
+
+/*
+ * XFS transaction mechanism exported interfaces that are
+ * actually macros.
+ */
+#define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
+
+/*
+ * XFS transaction mechanism exported interfaces.
+ */
+int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
+			uint blocks, uint rtextents, uint flags,
+			struct xfs_trans **tpp);
+int		xfs_trans_reserve_more(struct xfs_trans *tp,
+			unsigned int blocks, unsigned int rtextents);
+struct xfs_trans *xfs_trans_alloc_empty(struct xfs_mount *mp);
+void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
+
+int xfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *target,
+		struct xfs_buf_map *map, int nmaps, xfs_buf_flags_t flags,
+		struct xfs_buf **bpp);
+
+static inline int
+xfs_trans_get_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	int			numblks,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
+{
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	return xfs_trans_get_buf_map(tp, target, &map, 1, flags, bpp);
+}
+
+int		xfs_trans_read_buf_map(struct xfs_mount *mp,
+				       struct xfs_trans *tp,
+				       struct xfs_buftarg *target,
+				       struct xfs_buf_map *map, int nmaps,
+				       xfs_buf_flags_t flags,
+				       struct xfs_buf **bpp,
+				       const struct xfs_buf_ops *ops);
+
+static inline int
+xfs_trans_read_buf(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	int			numblks,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops)
+{
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	return xfs_trans_read_buf_map(mp, tp, target, &map, 1,
+				      flags, bpp, ops);
+}
+
+struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
+struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
+
+void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
+void		xfs_trans_bhold(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_bhold_release(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_binval(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
+bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
+void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
+void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
+				  uint);
+void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
+bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
+void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
+
+int		xfs_trans_commit(struct xfs_trans *);
+int		xfs_trans_roll(struct xfs_trans **);
+int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
+void		xfs_trans_cancel(xfs_trans_t *);
+int		xfs_trans_ail_init(struct xfs_mount *);
+void		xfs_trans_ail_destroy(struct xfs_mount *);
+
+void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
+				       enum xfs_blft);
+void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
+					struct xfs_buf *src_bp);
+
+extern struct kmem_cache	*xfs_trans_cache;
+
+struct xfs_dquot;
+
+int xfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
+		unsigned int dblocks, unsigned int rblocks, bool force,
+		struct xfs_trans **tpp);
+int xfs_trans_reserve_more_inode(struct xfs_trans *tp, struct xfs_inode *ip,
+		unsigned int dblocks, unsigned int rblocks, bool force_quota);
+int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int dblocks,
+		struct xfs_trans **tpp);
+int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
+		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
+		struct xfs_trans **tpp);
+int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
+		struct xfs_inode *ip, unsigned int *dblocks,
+		struct xfs_trans **tpp, int *nospace_error);
+
+static inline void
+xfs_trans_set_context(
+	struct xfs_trans	*tp)
+{
+	tp->t_pflags = memalloc_nofs_save();
+}
+
+static inline void
+xfs_trans_clear_context(
+	struct xfs_trans	*tp)
+{
+	memalloc_nofs_restore(tp->t_pflags);
+}
+
+#endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 697671007561..e3dca0652d26 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -12,6 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
 
 /*
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 5b7660b1cd8a..d15ca0427584 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -19,6 +19,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_log.h"
 #include "xfs_trace.h"
 #include "defer_item.h"
 
-- 
2.53.0

