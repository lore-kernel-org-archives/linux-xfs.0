Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58305 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752580AbdJKUGU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 16:06:20 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 19/19] xfs: Add support for MAP_SYNC flag
Date: Wed, 11 Oct 2017 22:06:03 +0200
Message-Id: <20171011200603.27442-20-jack@suse.cz>
In-Reply-To: <20171011200603.27442-1-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>

Now when everything is prepared, add support in xfs to accept MAP_SYNC
as an mmap(2) flag.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c    |  1 +
 fs/xfs/xfs_file.c | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f013cda84b3d..6b597cc6b29d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -26,6 +26,7 @@
 #include <linux/quotaops.h>
 #include <linux/pagevec.h>
 #include <linux/uio.h>
+#include <linux/mman.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "xattr.h"
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c45f24ffab22..fb135224476d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -44,6 +44,7 @@
 #include <linux/falloc.h>
 #include <linux/pagevec.h>
 #include <linux/backing-dev.h>
+#include <linux/mman.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1142,6 +1143,27 @@ xfs_file_mmap(
 	return 0;
 }
 
+#define XFS_MAP_SUPPORTED (LEGACY_MAP_MASK | MAP_SYNC)
+
+static int
+xfs_file_mmap_validate(
+	struct file		*filp,
+	struct vm_area_struct	*vma,
+	unsigned long		map_flags)
+{
+	if (map_flags & ~XFS_MAP_SUPPORTED)
+		return -EOPNOTSUPP;
+
+	/*
+	 * We don't support synchronous mappings for non-DAX files. At least
+	 * until someone comes with a sensible use case.
+	 */
+	if (!IS_DAX(file_inode(filp)) && (map_flags & MAP_SYNC))
+		return -EOPNOTSUPP;
+
+	return xfs_file_mmap(filp, vma);
+}
+
 const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
 	.read_iter	= xfs_file_read_iter,
@@ -1153,6 +1175,7 @@ const struct file_operations xfs_file_operations = {
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
 	.mmap		= xfs_file_mmap,
+	.mmap_validate	= xfs_file_mmap_validate,
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
-- 
2.12.3

