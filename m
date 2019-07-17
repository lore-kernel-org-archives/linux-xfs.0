Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfGQGAB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 02:00:01 -0400
Subject: [PATCH 7/8] iomap: move the main iteration code into a separate file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 16 Jul 2019 22:59:41 -0700
Message-ID: <156334318185.360395.15234213428621441444.stgit@magnolia>
In-Reply-To: <156334313527.360395.511547592522547578.stgit@magnolia>
References: <156334313527.360395.511547592522547578.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, agruenba@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the main iteration code into a separate file so that we can group
related functions in a single file instead of having a single enormous
source file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/Makefile       |    1 -
 fs/iomap.c        |   91 -----------------------------------------------------
 fs/iomap/Makefile |    1 +
 fs/iomap/apply.c  |   76 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 92 deletions(-)
 delete mode 100644 fs/iomap.c
 create mode 100644 fs/iomap/apply.c


diff --git a/fs/Makefile b/fs/Makefile
index 8e61bdf9f330..d60089fd689b 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -52,7 +52,6 @@ obj-$(CONFIG_COREDUMP)		+= coredump.o
 obj-$(CONFIG_SYSCTL)		+= drop_caches.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
-obj-$(CONFIG_FS_IOMAP)		+= iomap.o
 obj-y				+= iomap/
 
 obj-y				+= quota/
diff --git a/fs/iomap.c b/fs/iomap.c
deleted file mode 100644
index 88a3144351a9..000000000000
--- a/fs/iomap.c
+++ /dev/null
@@ -1,91 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (C) 2010 Red Hat, Inc.
- * Copyright (c) 2016-2018 Christoph Hellwig.
- */
-#include <linux/module.h>
-#include <linux/compiler.h>
-#include <linux/fs.h>
-#include <linux/iomap.h>
-#include <linux/uaccess.h>
-#include <linux/gfp.h>
-#include <linux/migrate.h>
-#include <linux/mm.h>
-#include <linux/mm_inline.h>
-#include <linux/swap.h>
-#include <linux/pagemap.h>
-#include <linux/pagevec.h>
-#include <linux/file.h>
-#include <linux/uio.h>
-#include <linux/backing-dev.h>
-#include <linux/buffer_head.h>
-#include <linux/task_io_accounting_ops.h>
-#include <linux/dax.h>
-#include <linux/sched/signal.h>
-
-#include "internal.h"
-
-/*
- * Execute a iomap write on a segment of the mapping that spans a
- * contiguous range of pages that have identical block mapping state.
- *
- * This avoids the need to map pages individually, do individual allocations
- * for each page and most importantly avoid the need for filesystem specific
- * locking per page. Instead, all the operations are amortised over the entire
- * range of pages. It is assumed that the filesystems will lock whatever
- * resources they require in the iomap_begin call, and release them in the
- * iomap_end call.
- */
-loff_t
-iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
-		const struct iomap_ops *ops, void *data, iomap_actor_t actor)
-{
-	struct iomap iomap = { 0 };
-	loff_t written = 0, ret;
-
-	/*
-	 * Need to map a range from start position for length bytes. This can
-	 * span multiple pages - it is only guaranteed to return a range of a
-	 * single type of pages (e.g. all into a hole, all mapped or all
-	 * unwritten). Failure at this point has nothing to undo.
-	 *
-	 * If allocation is required for this range, reserve the space now so
-	 * that the allocation is guaranteed to succeed later on. Once we copy
-	 * the data into the page cache pages, then we cannot fail otherwise we
-	 * expose transient stale data. If the reserve fails, we can safely
-	 * back out at this point as there is nothing to undo.
-	 */
-	ret = ops->iomap_begin(inode, pos, length, flags, &iomap);
-	if (ret)
-		return ret;
-	if (WARN_ON(iomap.offset > pos))
-		return -EIO;
-	if (WARN_ON(iomap.length == 0))
-		return -EIO;
-
-	/*
-	 * Cut down the length to the one actually provided by the filesystem,
-	 * as it might not be able to give us the whole size that we requested.
-	 */
-	if (iomap.offset + iomap.length < pos + length)
-		length = iomap.offset + iomap.length - pos;
-
-	/*
-	 * Now that we have guaranteed that the space allocation will succeed.
-	 * we can do the copy-in page by page without having to worry about
-	 * failures exposing transient data.
-	 */
-	written = actor(inode, pos, length, data, &iomap);
-
-	/*
-	 * Now the data has been copied, commit the range we've copied.  This
-	 * should not fail unless the filesystem has had a fatal error.
-	 */
-	if (ops->iomap_end) {
-		ret = ops->iomap_end(inode, pos, length,
-				     written > 0 ? written : 0,
-				     flags, &iomap);
-	}
-
-	return written ? written : ret;
-}
diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
index 6f8dedae26cb..a24e8a0d47a5 100644
--- a/fs/iomap/Makefile
+++ b/fs/iomap/Makefile
@@ -6,6 +6,7 @@
 obj-$(CONFIG_FS_IOMAP)		+= iomap.o
 
 iomap-y				+= \
+					apply.o \
 					direct-io.o \
 					buffered-io.o \
 					fiemap.o \
diff --git a/fs/iomap/apply.c b/fs/iomap/apply.c
new file mode 100644
index 000000000000..9f956cf23867
--- /dev/null
+++ b/fs/iomap/apply.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2010 Red Hat, Inc.
+ * Copyright (c) 2016-2018 Christoph Hellwig.
+ */
+#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/fs.h>
+#include <linux/iomap.h>
+
+#include "../internal.h"
+
+/*
+ * Execute a iomap write on a segment of the mapping that spans a
+ * contiguous range of pages that have identical block mapping state.
+ *
+ * This avoids the need to map pages individually, do individual allocations
+ * for each page and most importantly avoid the need for filesystem specific
+ * locking per page. Instead, all the operations are amortised over the entire
+ * range of pages. It is assumed that the filesystems will lock whatever
+ * resources they require in the iomap_begin call, and release them in the
+ * iomap_end call.
+ */
+loff_t
+iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
+		const struct iomap_ops *ops, void *data, iomap_actor_t actor)
+{
+	struct iomap iomap = { 0 };
+	loff_t written = 0, ret;
+
+	/*
+	 * Need to map a range from start position for length bytes. This can
+	 * span multiple pages - it is only guaranteed to return a range of a
+	 * single type of pages (e.g. all into a hole, all mapped or all
+	 * unwritten). Failure at this point has nothing to undo.
+	 *
+	 * If allocation is required for this range, reserve the space now so
+	 * that the allocation is guaranteed to succeed later on. Once we copy
+	 * the data into the page cache pages, then we cannot fail otherwise we
+	 * expose transient stale data. If the reserve fails, we can safely
+	 * back out at this point as there is nothing to undo.
+	 */
+	ret = ops->iomap_begin(inode, pos, length, flags, &iomap);
+	if (ret)
+		return ret;
+	if (WARN_ON(iomap.offset > pos))
+		return -EIO;
+	if (WARN_ON(iomap.length == 0))
+		return -EIO;
+
+	/*
+	 * Cut down the length to the one actually provided by the filesystem,
+	 * as it might not be able to give us the whole size that we requested.
+	 */
+	if (iomap.offset + iomap.length < pos + length)
+		length = iomap.offset + iomap.length - pos;
+
+	/*
+	 * Now that we have guaranteed that the space allocation will succeed.
+	 * we can do the copy-in page by page without having to worry about
+	 * failures exposing transient data.
+	 */
+	written = actor(inode, pos, length, data, &iomap);
+
+	/*
+	 * Now the data has been copied, commit the range we've copied.  This
+	 * should not fail unless the filesystem has had a fatal error.
+	 */
+	if (ops->iomap_end) {
+		ret = ops->iomap_end(inode, pos, length,
+				     written > 0 ? written : 0,
+				     flags, &iomap);
+	}
+
+	return written ? written : ret;
+}
