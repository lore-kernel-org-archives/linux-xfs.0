Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52384 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfGOSAl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 14:00:41 -0400
Subject: [PATCH 9/9] iomap: move internal declarations into fs/iomap/
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Jul 2019 11:00:18 -0700
Message-ID: <156321361878.148361.6616574884425585291.stgit@magnolia>
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

Move internal function declarations out of fs/internal.h into
include/linux/iomap.h so that our transition is complete.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/dax.c              |    1 -
 fs/internal.h         |   10 ----------
 fs/iomap/apply.c      |    2 --
 fs/iomap/fiemap.c     |    2 --
 fs/iomap/migrate.c    |    2 --
 fs/iomap/seek.c       |    2 --
 fs/iomap/swapfile.c   |    2 --
 include/linux/iomap.h |   10 ++++++++++
 8 files changed, 10 insertions(+), 21 deletions(-)


diff --git a/fs/dax.c b/fs/dax.c
index fe5e33810cd4..cb53f9bd6fd7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -26,7 +26,6 @@
 #include <linux/mmu_notifier.h>
 #include <linux/iomap.h>
 #include <asm/pgalloc.h>
-#include "internal.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/fs_dax.h>
diff --git a/fs/internal.h b/fs/internal.h
index 2f3c3de51fad..2b0bebd67904 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -182,15 +182,5 @@ extern const struct dentry_operations ns_dentry_operations;
 extern int do_vfs_ioctl(struct file *file, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
 
-/*
- * iomap support:
- */
-typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
-		void *data, struct iomap *iomap);
-
-loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
-		unsigned flags, const struct iomap_ops *ops, void *data,
-		iomap_actor_t actor);
-
 /* direct-io.c: */
 int sb_init_dio_done_wq(struct super_block *sb);
diff --git a/fs/iomap/apply.c b/fs/iomap/apply.c
index 844e56612dd2..54c02aecf3cd 100644
--- a/fs/iomap/apply.c
+++ b/fs/iomap/apply.c
@@ -8,8 +8,6 @@
 #include <linux/fs.h>
 #include <linux/iomap.h>
 
-#include "internal.h"
-
 /*
  * Execute a iomap write on a segment of the mapping that spans a
  * contiguous range of pages that have identical block mapping state.
diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index 1f43315468b7..f26fdd36e383 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -7,8 +7,6 @@
 #include <linux/fs.h>
 #include <linux/iomap.h>
 
-#include "internal.h"
-
 struct fiemap_ctx {
 	struct fiemap_extent_info *fi;
 	struct iomap prev;
diff --git a/fs/iomap/migrate.c b/fs/iomap/migrate.c
index d8116d35f819..12130e3a1825 100644
--- a/fs/iomap/migrate.c
+++ b/fs/iomap/migrate.c
@@ -9,8 +9,6 @@
 #include <linux/iomap.h>
 #include <linux/migrate.h>
 
-#include "internal.h"
-
 int
 iomap_migrate_page(struct address_space *mapping, struct page *newpage,
 		struct page *page, enum migrate_mode mode)
diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index 0c36bef46522..ece71fd3519a 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -10,8 +10,6 @@
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
 
-#include "internal.h"
-
 /*
  * Seek for SEEK_DATA / SEEK_HOLE within @page, starting at @lastoff.
  * Returns true if found and updates @lastoff to the offset in file.
diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
index 0bd578b580bb..152a230f668d 100644
--- a/fs/iomap/swapfile.c
+++ b/fs/iomap/swapfile.c
@@ -9,8 +9,6 @@
 #include <linux/iomap.h>
 #include <linux/swap.h>
 
-#include "internal.h"
-
 /* Swapfile activation */
 
 struct iomap_swapfile_info {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index baa1e2d31f05..bc499ceae392 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -122,6 +122,16 @@ struct iomap_ops {
 			ssize_t written, unsigned flags, struct iomap *iomap);
 };
 
+/*
+ * Main iomap iterator function.
+ */
+typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
+		void *data, struct iomap *iomap);
+
+loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
+		unsigned flags, const struct iomap_ops *ops, void *data,
+		iomap_actor_t actor);
+
 /*
  * Structure allocate for each page when block size < PAGE_SIZE to track
  * sub-page uptodate status and I/O completions.
