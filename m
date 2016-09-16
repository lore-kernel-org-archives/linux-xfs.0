Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40490 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932447AbcIPL10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Sep 2016 07:27:26 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/12] iomap: expose iomap_apply outside iomap.c
Date: Fri, 16 Sep 2016 13:27:04 +0200
Message-Id: <1474025234-13804-3-git-send-email-hch@lst.de>
In-Reply-To: <1474025234-13804-1-git-send-email-hch@lst.de>
References: <1474025234-13804-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com

This allows the DAX code to use it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/internal.h | 11 +++++++++++
 fs/iomap.c    |  5 +----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index ba07376..8591786 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -12,6 +12,7 @@
 struct super_block;
 struct file_system_type;
 struct iomap;
+struct iomap_ops;
 struct linux_binprm;
 struct path;
 struct mount;
@@ -164,3 +165,13 @@ extern struct dentry_operations ns_dentry_operations;
 extern int do_vfs_ioctl(struct file *file, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
 extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+
+/*
+ * iomap support:
+ */
+typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
+		void *data, struct iomap *iomap);
+
+loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
+		unsigned flags, struct iomap_ops *ops, void *data,
+		iomap_actor_t actor);
diff --git a/fs/iomap.c b/fs/iomap.c
index 706270f..f4df9c6 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -27,9 +27,6 @@
 #include <linux/dax.h>
 #include "internal.h"
 
-typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
-		void *data, struct iomap *iomap);
-
 /*
  * Execute a iomap write on a segment of the mapping that spans a
  * contiguous range of pages that have identical block mapping state.
@@ -41,7 +38,7 @@ typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
  * resources they require in the iomap_begin call, and release them in the
  * iomap_end call.
  */
-static loff_t
+loff_t
 iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 		struct iomap_ops *ops, void *data, iomap_actor_t actor)
 {
-- 
2.1.4

