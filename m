Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A44248867
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205038; cv=none; b=UkcbyLVzjs/24oMAI+da5QD5mUdmtsENXYFvjOZGbExLNPftrJxOoi3ItkI6zrLCtiy+Ywk/MxHeoTxxfwMYeQF8HSoW8bLm+Ys7mUC+qjLWqC5nuDuMk3WUiMdfds9KwrJwIpw0yBzfd/YmSQOK6GAnfuiNmJKz6J8o/n+loL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205038; c=relaxed/simple;
	bh=4oRkRHENlcuH7kfk2jh/l7CyvEWbbOdgIKk9glxi9mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkGXy8NYf+FF9po473CVu+VbeGwuIE4v69Qkz4F/cA02eVSVOrd6YzTVQeCDd8eLIJbr4B/yXgKIrE8Q1TFP75ueepnFP9quXsiI7jbROPr7rcI/9M4VUncfq8GdmJIgFUEnBXZHs3rcHC7fLnM0X340UcamNwM/forOdBgAQE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RfwPyXRe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RfwPyXRe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=weqHTD09zSMj39zsafj87YnXu4JgSndYEexNVMw3bxg=; b=RfwPyXReuFleg5yT0DxqsKMsV5
	LmtMjxe+2TuspAjf0mklTz9WulNtBBF0Ujds/jTVfXePpokYSlb4RW2wlGJUNJiBGeFlx65IVoMqq
	8ptSCP1tjaxwXdud7fVDTyKny6xGnq5k3b92AlfsgdK2wz/8wWDDoFwaPsup30n18UjyCpXfL8hML
	H8Da4wE+BPEV71niKTPXgFD1MQ86/MRDtvDHgjwo2WTVD2WNNyBO6j0rX4KTpBCEtrIVXaAtjjV7/
	6Ps9ILwBAApnJgakJIZfcsErX9sdWf5fIAlyxKqhleOKWXnrgMSuA1De5Tpi6ThCJhRUgSCpxFyli
	2CYuCxJA==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFn-0000000GR8S-2e8g;
	Mon, 05 Oct 2026 12:57:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/13] libxfs: cleanup xfs_trans.h
Date: Mon,  5 Oct 2026 14:56:21 +0200
Message-ID: <20261005125637.1340355-12-hch@lst.de>
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

Add new xfs_trans_priv.h and xfs_log.h stubs for definitions that aren't
in xfs_trans.h in the kernel.  This prepares for pulling in the kernel
version of xfs_trans.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/Makefile               |  4 +++-
 libxfs/stubs/xfs_log.h        |  7 +++++++
 libxfs/stubs/xfs_trans.h      |  7 -------
 libxfs/stubs/xfs_trans_priv.h | 16 ++++++++++++++++
 libxfs/xfs_alloc.c            |  1 +
 libxfs/xfs_attr_leaf.c        |  1 +
 libxfs/xfs_btree.c            |  1 +
 libxfs/xfs_da_btree.c         |  1 +
 libxfs/xfs_defer.c            |  2 ++
 libxfs/xfs_dir2_block.c       |  1 +
 libxfs/xfs_dir2_data.c        |  1 +
 libxfs/xfs_dir2_node.c        |  1 +
 libxfs/xfs_ialloc.c           |  1 +
 libxfs/xfs_rtbitmap.c         |  1 +
 libxfs/xfs_sb.c               |  1 +
 libxfs/xfs_symlink_remote.c   |  1 +
 libxfs/xfs_trans_inode.c      |  1 +
 libxfs/xfs_trans_resv.c       |  1 +
 repair/phase2.c               |  1 +
 19 files changed, 42 insertions(+), 8 deletions(-)
 create mode 100644 libxfs/stubs/xfs_log.h
 create mode 100644 libxfs/stubs/xfs_trans_priv.h

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 722e99168f63..f64dd596b645 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -79,10 +79,12 @@ HFILES = \
 	stubs/xfs_error.h \
 	stubs/xfs_extent_busy.h \
 	stubs/xfs_inode.h \
+	stubs/xfs_log.h \
 	stubs/xfs_mount.h \
 	stubs/xfs_quota.h \
 	stubs/xfs_trace.h \
-	stubs/xfs_trans.h
+	stubs/xfs_trans.h \
+	stubs/xfs_trans_priv.h
 
 CFILES = buf_mem.c \
 	cache.c \
diff --git a/libxfs/stubs/xfs_log.h b/libxfs/stubs/xfs_log.h
new file mode 100644
index 000000000000..98251ee06688
--- /dev/null
+++ b/libxfs/stubs/xfs_log.h
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __XFS_LOG_H__
+#define __XFS_LOG_H__
+
+#define xfs_log_item_in_current_chkpt(lip)	(false)
+
+#endif /* __XFS_LOG_H__ */
diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
index aa4de91b43a9..2619347df923 100644
--- a/libxfs/stubs/xfs_trans.h
+++ b/libxfs/stubs/xfs_trans.h
@@ -52,7 +52,6 @@ typedef struct xfs_trans {
 	struct list_head	t_dfops;	/* deferred operations */
 } xfs_trans_t;
 
-void	xfs_trans_init(struct xfs_mount *);
 int	xfs_trans_roll(struct xfs_trans **);
 
 int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
@@ -130,10 +129,4 @@ libxfs_trans_read_buf(
 	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
 }
 
-#define xfs_log_item_in_current_chkpt(lip)	(false)
-
-/* Contorted mess to make gcc shut up about unused vars. */
-#define xfs_ail_get_push_target(ail)    \
-		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/stubs/xfs_trans_priv.h b/libxfs/stubs/xfs_trans_priv.h
new file mode 100644
index 000000000000..bab4e6c2b6c2
--- /dev/null
+++ b/libxfs/stubs/xfs_trans_priv.h
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#ifndef __XFS_TRANS_PRIV_H__
+#define __XFS_TRANS_PRIV_H__
+
+void	xfs_trans_init(struct xfs_mount *);
+
+/* Contorted mess to make gcc shut up about unused vars. */
+#define xfs_ail_get_push_target(ail)    \
+	((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
+
+#endif /* __XFS_TRANS_PRIV_H__ */
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
 
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 28e8dcf14475..ab1f81d8bcd2 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -12,10 +12,12 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
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
 
diff --git a/repair/phase2.c b/repair/phase2.c
index fc96f9c4223c..ee166e62a002 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -16,6 +16,7 @@
 #include "scan.h"
 #include "rt.h"
 #include "quotacheck.h"
+#include "xfs_trans_priv.h"
 
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
-- 
2.53.0

