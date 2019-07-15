Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729237AbfGOSAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 14:00:22 -0400
Subject: [PATCH 7/9] iomap: move the page migration code into a separate file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Jul 2019 11:00:05 -0700
Message-ID: <156321360519.148361.2779156857011152900.stgit@magnolia>
In-Reply-To: <156321356040.148361.7463881761568794395.stgit@magnolia>
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the page migration code into a separate file so that we can group
related functions in a single file instead of having a single enormous
source file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c         |   29 -----------------------------
 fs/iomap/Makefile  |    1 +
 fs/iomap/migrate.c |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 29 deletions(-)
 create mode 100644 fs/iomap/migrate.c


diff --git a/fs/iomap.c b/fs/iomap.c
index ab658a4b97d3..88a3144351a9 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -89,32 +89,3 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 
 	return written ? written : ret;
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
index d2a81819ae01..04cbeed44248 100644
--- a/fs/iomap/Makefile
+++ b/fs/iomap/Makefile
@@ -14,4 +14,5 @@ iomap-y				+= \
 					fiemap.o \
 					seek.o
 
+iomap-$(CONFIG_MIGRATION)	+= migrate.o
 iomap-$(CONFIG_SWAP)		+= swapfile.o
diff --git a/fs/iomap/migrate.c b/fs/iomap/migrate.c
new file mode 100644
index 000000000000..d8116d35f819
--- /dev/null
+++ b/fs/iomap/migrate.c
@@ -0,0 +1,39 @@
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
