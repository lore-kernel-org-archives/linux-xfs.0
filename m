Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfFZCep (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:34:45 -0400
Subject: [PATCH 2/5] vfs: flush and wait for io when setting the immutable
 flag via SETFLAGS
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Jun 2019 19:33:08 -0700
Message-ID: <156151638826.2283603.17232416684567376466.stgit@magnolia>
In-Reply-To: <156151637248.2283603.8458727861336380714.stgit@magnolia>
References: <156151637248.2283603.8458727861336380714.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
Cc: reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're using FS_IOC_SETFLAGS to set the immutable flag on a file, we
need to ensure that userspace can't continue to write the file after the
file becomes immutable.  To make that happen, we have to flush all the
dirty pagecache pages to disk to ensure that we can fail a page fault on
a mmap'd region, wait for pending directio to complete, and hope the
caller locked out any new writes by holding the inode lock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/inode.c         |   21 +++++++++++++++++++--
 include/linux/fs.h |   11 +++++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/fs/inode.c b/fs/inode.c
index f08711b34341..65a412af3ffb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2193,7 +2193,8 @@ EXPORT_SYMBOL(current_time);
 
 /*
  * Generic function to check FS_IOC_SETFLAGS values and reject any invalid
- * configurations.
+ * configurations.  Once we're done, prepare the inode for whatever changes
+ * are coming down the pipeline.
  *
  * Note: the caller should be holding i_mutex, or else be sure that they have
  * exclusive access to the inode structure.
@@ -2201,6 +2202,8 @@ EXPORT_SYMBOL(current_time);
 int vfs_ioc_setflags_prepare(struct inode *inode, unsigned int oldflags,
 			     unsigned int flags)
 {
+	int ret;
+
 	/*
 	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
 	 * the relevant capability.
@@ -2211,7 +2214,21 @@ int vfs_ioc_setflags_prepare(struct inode *inode, unsigned int oldflags,
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
-	return 0;
+	/*
+	 * Now that we're done checking the new flags, flush all pending IO and
+	 * dirty mappings before setting S_IMMUTABLE on an inode via
+	 * FS_IOC_SETFLAGS.  If the flush fails we'll clear the flag before
+	 * returning error.
+	 */
+	if (!S_ISREG(inode->i_mode) || IS_IMMUTABLE(inode) ||
+	    !(flags & FS_IMMUTABLE_FL))
+		return 0;
+
+	inode_set_flags(inode, S_IMMUTABLE, S_IMMUTABLE);
+	ret = inode_drain_writes(inode);
+	if (ret)
+		inode_set_flags(inode, 0, S_IMMUTABLE);
+	return ret;
 }
 EXPORT_SYMBOL(vfs_ioc_setflags_prepare);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 48322bfd7299..51266c9dbadc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3561,4 +3561,15 @@ int vfs_ioc_setflags_prepare(struct inode *inode, unsigned int oldflags,
 int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 			     struct fsxattr *fa);
 
+/*
+ * Flush file data before changing attributes.  Caller must hold any locks
+ * required to prevent further writes to this file until we're done setting
+ * flags.
+ */
+static inline int inode_drain_writes(struct inode *inode)
+{
+	inode_dio_wait(inode);
+	return filemap_write_and_wait(inode->i_mapping);
+}
+
 #endif /* _LINUX_FS_H */
