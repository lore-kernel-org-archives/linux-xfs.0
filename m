Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58291 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752386AbdJKUGV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 16:06:21 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 17/19] ext4: Add support for MAP_SYNC flag
Date: Wed, 11 Oct 2017 22:06:01 +0200
Message-Id: <20171011200603.27442-18-jack@suse.cz>
In-Reply-To: <20171011200603.27442-1-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>

Now when everything is prepared, add support in ext4 to accept MAP_SYNC
as an mmap(2) flag.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 61a8788168f3..f013cda84b3d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -364,6 +364,25 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+#define EXT4_SUPPORTED_MAP_FLAGS (LEGACY_MAP_MASK | MAP_SYNC)
+
+static int ext4_file_mmap_validate(struct file *file,
+				   struct vm_area_struct *vma,
+				   unsigned long map_flags)
+{
+	if (map_flags & ~EXT4_SUPPORTED_MAP_FLAGS)
+		return -EOPNOTSUPP;
+
+	/*
+	 * We don't support synchronous mappings for non-DAX files. At least
+	 * until someone comes with a sensible use case.
+	 */
+	if (!IS_DAX(file_inode(file)) && (map_flags & MAP_SYNC))
+		return -EOPNOTSUPP;
+
+	return ext4_file_mmap(file, vma);
+}
+
 static int ext4_file_open(struct inode * inode, struct file * filp)
 {
 	struct super_block *sb = inode->i_sb;
@@ -723,6 +742,7 @@ const struct file_operations ext4_file_operations = {
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
 	.mmap		= ext4_file_mmap,
+	.mmap_validate	= ext4_file_mmap_validate,
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
-- 
2.12.3

