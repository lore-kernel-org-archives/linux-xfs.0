Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JG4Ogj216151 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:04:34 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0C711BDBCA8
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 09:04:48 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id 8EA3mqV7BCKAbp5Z for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2009 09:04:48 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/17] vfs: Introduce new helpers for syncing after writing to
	O_SYNC file or IS_SYNC inode
Date: Wed, 19 Aug 2009 18:04:34 +0200
Message-Id: <1250697884-22288-8-git-send-email-jack@suse.cz>
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>, linux-ntfs-dev@lists.sourceforge.net, Joel Becker <joel.becker@oracle.com>, xfs@oss.sgi.com, hch@infradead.org, Anton Altaparmakov <aia21@cantab.net>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Evgeniy Polyakov <zbr@ioremap.net>, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Introduce new function for generic inode syncing (generic_sync_file) and use
it from fsync() path. Introduce also new helper for syncing after a sync
write (generic_write_sync) using the generic function.

Use these new helpers for syncing from generic VFS functions.

CC: Evgeniy Polyakov <zbr@ioremap.net>
CC: ocfs2-devel@oss.oracle.com
CC: Joel Becker <joel.becker@oracle.com>
CC: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com
CC: Anton Altaparmakov <aia21@cantab.net>
CC: linux-ntfs-dev@lists.sourceforge.net
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: linux-ext4@vger.kernel.org
CC: tytso@mit.edu
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/splice.c        |   22 ++++----------
 fs/sync.c          |   81 +++++++++++++++++++++++++++++++++++++++++++---------
 include/linux/fs.h |    7 ++++
 mm/filemap.c       |   16 ++++------
 4 files changed, 86 insertions(+), 40 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 73766d2..8190237 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -976,25 +976,15 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
 	if (ret > 0) {
 		unsigned long nr_pages;
+		int err;
 
-		*ppos += ret;
 		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
-		/*
-		 * If file or inode is SYNC and we actually wrote some data,
-		 * sync it.
-		 */
-		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			int err;
-
-			mutex_lock(&inode->i_mutex);
-			err = generic_osync_inode(inode, mapping,
-						  OSYNC_METADATA|OSYNC_DATA);
-			mutex_unlock(&inode->i_mutex);
-
-			if (err)
-				ret = err;
-		}
+		err = generic_write_sync(out, *ppos, ret);
+		if (err)
+			ret = err;
+		else
+			*ppos += ret;
 		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
 	}
 
diff --git a/fs/sync.c b/fs/sync.c
index 3422ba6..fc320aa 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -176,23 +176,30 @@ int file_fsync(struct file *filp, struct dentry *dentry, int datasync)
 }
 
 /**
- * vfs_fsync - perform a fsync or fdatasync on a file
+ * generic_sync_file - helper to sync data & metadata to disk
  * @file:		file to sync
  * @dentry:		dentry of @file
- * @data:		only perform a fdatasync operation
+ * @start:		offset in bytes of the beginning of data range to sync
+ * @end:		offset in bytes of the end of data range (inclusive)
+ * @what:		what should be synced
  *
- * Write back data and metadata for @file to disk.  If @datasync is
- * set only metadata needed to access modified file data is written.
+ * What the function exactly does is controlled by the @what parameter:
  *
- * In case this function is called from nfsd @file may be %NULL and
- * only @dentry is set.  This can only happen when the filesystem
- * implements the export_operations API.
+ * If SYNC_SUBMIT_DATA is set, the function submits all pages in the given
+ * range to disk.
+ *
+ * The function always calls ->fsync() callback of the filesystem. If
+ * SYNC_INODE is not set, we pass down the fact that it is just a datasync.
+ *
+ * If SYNC_WAIT_DATA is set, the function waits for writeback to finish
+ * in the given range.
  */
-int vfs_fsync(struct file *file, struct dentry *dentry, int datasync)
+int generic_sync_file(struct file *file, struct dentry *dentry, loff_t start,
+		      loff_t end, int what)
 {
 	const struct file_operations *fop;
 	struct address_space *mapping;
-	int err, ret;
+	int err, ret = 0;
 
 	/*
 	 * Get mapping and operations from the file in case we have
@@ -212,23 +219,50 @@ int vfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 		goto out;
 	}
 
-	ret = filemap_fdatawrite(mapping);
+	if (what & SYNC_SUBMIT_DATA)
+		ret = filemap_fdatawrite_range(mapping, start, end);
 
 	/*
 	 * We need to protect against concurrent writers, which could cause
 	 * livelocks in fsync_buffers_list().
 	 */
 	mutex_lock(&mapping->host->i_mutex);
-	err = fop->fsync(file, dentry, datasync);
+	err = fop->fsync(file, dentry, !(what & SYNC_INODE));
 	if (!ret)
 		ret = err;
 	mutex_unlock(&mapping->host->i_mutex);
-	err = filemap_fdatawait(mapping);
-	if (!ret)
-		ret = err;
+
+	if (what & SYNC_WAIT_DATA) {
+		err = filemap_fdatawait_range(mapping, start, end);
+		if (!ret)
+			ret = err;
+	}
 out:
 	return ret;
 }
+EXPORT_SYMBOL(generic_sync_file);
+
+/**
+ * vfs_fsync - perform a fsync or fdatasync on a file
+ * @file:		file to sync
+ * @dentry:		dentry of @file
+ * @datasync:		only perform a fdatasync operation
+ *
+ * Write back data and metadata for @file to disk.  If @datasync is
+ * set only metadata needed to access modified file data is written.
+ *
+ * In case this function is called from nfsd @file may be %NULL and
+ * only @dentry is set.  This can only happen when the filesystem
+ * implements the export_operations API.
+ */
+int vfs_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int what = SYNC_SUBMIT_DATA | SYNC_WAIT_DATA;
+
+	if (!datasync)
+		what |= SYNC_INODE;
+	return generic_sync_file(file, dentry, 0, LLONG_MAX, what);
+}
 EXPORT_SYMBOL(vfs_fsync);
 
 static int do_fsync(unsigned int fd, int datasync)
@@ -254,6 +288,25 @@ SYSCALL_DEFINE1(fdatasync, unsigned int, fd)
 	return do_fsync(fd, 1);
 }
 
+/**
+ * generic_write_sync - perform syncing after a write if file / inode is sync
+ * @file:	file to which the write happened
+ * @pos:	offset where the write started
+ * @count:	length of the write
+ *
+ * This is just a simple wrapper about our general syncing function.
+ * FIXME: Make it inline?
+ */
+int generic_write_sync(struct file *file, loff_t pos, loff_t count)
+{
+	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
+		return 0;
+	return generic_sync_file(file, file->f_path.dentry, pos,
+				 pos + count - 1,
+				 SYNC_SUBMIT_DATA | SYNC_WAIT_DATA);
+}
+EXPORT_SYMBOL(generic_write_sync);
+
 /*
  * sys_sync_file_range() permits finely controlled syncing over a segment of
  * a file in the range offset .. (offset+nbytes-1) inclusive.  If nbytes is
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1edd159..0f13049 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2088,7 +2088,14 @@ extern int __filemap_fdatawrite_range(struct address_space *mapping,
 extern int filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end);
 
+/* Flags for generic_sync_file */
+#define SYNC_INODE		1
+#define SYNC_SUBMIT_DATA	2
+#define SYNC_WAIT_DATA		4
+extern int generic_sync_file(struct file *file, struct dentry *dentry,
+			   loff_t start, loff_t end, int what);
 extern int vfs_fsync(struct file *file, struct dentry *dentry, int datasync);
+extern int generic_write_sync(struct file *file, loff_t pos, loff_t count);
 extern void sync_supers(void);
 extern void emergency_sync(void);
 extern void emergency_remount(void);
diff --git a/mm/filemap.c b/mm/filemap.c
index dffdc60..a29b35b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -39,11 +39,10 @@
 /*
  * FIXME: remove all knowledge of the buffer layer from the core VM
  */
-#include <linux/buffer_head.h> /* for generic_osync_inode */
+#include <linux/buffer_head.h> /* for try_to_free_buffers */
 
 #include <asm/mman.h>
 
-
 /*
  * Shared mappings implemented 30.11.1994. It's not fully working yet,
  * though.
@@ -2452,18 +2451,16 @@ ssize_t generic_file_aio_write_nolock(struct kiocb *iocb,
 		const struct iovec *iov, unsigned long nr_segs, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
 	ssize_t ret;
 
 	BUG_ON(iocb->ki_pos != pos);
 
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 
-	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
+	if (ret > 0) {
 		ssize_t err;
 
-		err = sync_page_range(inode, mapping, pos, ret);
+		err = generic_write_sync(file, pos, ret);
 		if (err < 0)
 			ret = err;
 	}
@@ -2486,8 +2483,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
+	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
 	BUG_ON(iocb->ki_pos != pos);
@@ -2496,10 +2492,10 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
+	if (ret > 0) {
 		ssize_t err;
 
-		err = sync_page_range(inode, mapping, pos, ret);
+		err = generic_write_sync(file, pos, ret);
 		if (err < 0)
 			ret = err;
 	}
-- 
1.6.0.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
