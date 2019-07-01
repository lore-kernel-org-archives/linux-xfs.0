Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59562 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729822AbfGARDH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 13:03:07 -0400
Subject: [PATCH 09/11] iomap: move the page migration code into a separate
 file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Jul 2019 10:02:59 -0700
Message-ID: <156200057959.1790352.8764969968089533689.stgit@magnolia>
In-Reply-To: <156200051933.1790352.5147420943973755350.stgit@magnolia>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the page migration code into a separate file so that we can group
related functions in a single file instead of having a single enormous
source file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c         |   29 -----------------------------
 fs/iomap/Makefile  |    1 +
 fs/iomap/migrate.c |   40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 29 deletions(-)
 create mode 100644 fs/iomap/migrate.c


diff --git a/fs/iomap.c b/fs/iomap.c
index b946418cb8b4..885e2021b4d0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -96,32 +96,3 @@ iomap_sector(struct iomap *iomap, loff_t pos)
 {
 	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
 }
-
-#ifdef CONFIG_MIGRATION
-int
-iomap_migrate_page(struct address_space *mapping, struct page *newpage,
-		struct page *page, enum migrate_mode mode)
-{
-	int ret;
-
-	ret = migrate_page_move_mapping(mapping, newpage, page, mode, 0);
-	if (ret != MIGRATEPAGE_SUCCESS)
-		return ret;
-
-	if (page_has_private(page)) {
-		ClearPagePrivate(page);
-		get_page(newpage);
-		set_page_private(newpage, page_private(page));
-		set_page_private(page, 0);
-		put_page(page);
-		SetPagePrivate(newpage);
-	}
-
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		migrate_page_copy(newpage, page);
-	else
-		migrate_page_states(newpage, page);
-	return MIGRATEPAGE_SUCCESS;
-}
-EXPORT_SYMBOL_GPL(iomap_migrate_page);
-#endif /* CONFIG_MIGRATION */
diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
index 754eea00ac79..c88888795e12 100644
--- a/fs/iomap/Makefile
+++ b/fs/iomap/Makefile
@@ -16,4 +16,5 @@ iomap-y				+= \
 					seek.o \
 					write.o
 
+iomap-$(CONFIG_MIGRATION)	+= migrate.o
 iomap-$(CONFIG_SWAP)		+= swapfile.o
diff --git a/fs/iomap/migrate.c b/fs/iomap/migrate.c
new file mode 100644
index 000000000000..5fd58a868c80
--- /dev/null
+++ b/fs/iomap/migrate.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2010 Red Hat, Inc.
+ * Copyright (c) 2016-2018 Christoph Hellwig.
+ */
+#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/fs.h>
+#include <linux/iomap.h>
+#include <linux/migrate.h>
+
+#include "internal.h"
+#include "iomap_internal.h"
+
+int
+iomap_migrate_page(struct address_space *mapping, struct page *newpage,
+		struct page *page, enum migrate_mode mode)
+{
+	int ret;
+
+	ret = migrate_page_move_mapping(mapping, newpage, page, mode, 0);
+	if (ret != MIGRATEPAGE_SUCCESS)
+		return ret;
+
+	if (page_has_private(page)) {
+		ClearPagePrivate(page);
+		get_page(newpage);
+		set_page_private(newpage, page_private(page));
+		set_page_private(page, 0);
+		put_page(page);
+		SetPagePrivate(newpage);
+	}
+
+	if (mode != MIGRATE_SYNC_NO_COPY)
+		migrate_page_copy(newpage, page);
+	else
+		migrate_page_states(newpage, page);
+	return MIGRATEPAGE_SUCCESS;
+}
+EXPORT_SYMBOL_GPL(iomap_migrate_page);
