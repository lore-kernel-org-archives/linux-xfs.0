Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1221i8u148270 for <xfs@oss.sgi.com>; Mon, 1 Feb 2010 20:01:55 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AB711A3D7E
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2010 18:02:39 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	jHLs40rkYbdGyUr6 for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2010 18:02:39 -0800 (PST)
Received: by ewy27 with SMTP id 27so918342ewy.18
	for <xfs@oss.sgi.com>; Mon, 01 Feb 2010 18:02:38 -0800 (PST)
From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: [patch 5/7] VFS: add super operation writeback_inodes
Date: Tue, 2 Feb 2010 02:56:21 +0100
MIME-Version: 1.0
Message-Id: <201002020256.21266.edward.shishkin@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

. add ->writeback_inodes() super operation.

    This patch adds new operation to struct super_operations -
    writeback_inodes, generic implementaion and changes
    fs-writeback.c:writeback_inodes_wb() to call filesystem's
    writeback_inodes if it is defined or generic implementaion
    otherwise. This new operation allows filesystem to decide
    itself what to flush.

    Reiser4 flushes dirty pages on basic of atoms, not of inodes.
    writeback_inodes_wb used to call address space flushing
    method (writepages) for every dirty inode. For reiser4 it
    caused having to commit atoms unnecessarily often.  This
    turned into substantial slowdown.  Having this method helped
    to fix that problem.

. add vfs library function writeback_skip_sb_inodes()

   This function is for file systems which have their own means
   of periodical writeout of old data.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
---
 fs/fs-writeback.c         |   47 ++++++++++++++++++++++++++++++++++++++++++----
 include/linux/fs.h        |   10 +++++++++
 include/linux/writeback.h |    6 +++++
 3 files changed, 59 insertions(+), 4 deletions(-)

Index: linux-2.6.33-rc5-mm1/include/linux/fs.h
===================================================================
--- linux-2.6.33-rc5-mm1.orig/include/linux/fs.h
+++ linux-2.6.33-rc5-mm1/include/linux/fs.h
@@ -514,6 +514,7 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct bdi_writeback;
 
 struct iov_iter {
 	const struct iovec *iov;
@@ -1565,6 +1566,9 @@ struct super_operations {
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct super_block *);
+	int (*writeback_inodes)(struct super_block *sb,
+				struct bdi_writeback *wb,
+				struct writeback_control *wbc);
 
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
@@ -2073,6 +2077,12 @@ extern int invalidate_inode_pages2(struc
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
 extern int write_inode_now(struct inode *, int);
+extern void writeback_skip_sb_inodes(struct super_block *sb,
+				     struct bdi_writeback *wb);
+extern void writeback_inodes_wbc(struct writeback_control *wbc);
+extern int generic_writeback_sb_inodes(struct super_block *sb,
+				       struct bdi_writeback *wb,
+				       struct writeback_control *wbc);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait(struct address_space *);
Index: linux-2.6.33-rc5-mm1/include/linux/writeback.h
===================================================================
--- linux-2.6.33-rc5-mm1.orig/include/linux/writeback.h
+++ linux-2.6.33-rc5-mm1/include/linux/writeback.h
@@ -13,6 +13,12 @@ extern spinlock_t inode_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
+static inline int is_flush_bd_task(struct task_struct *task)
+{
+       return task->flags & PF_FLUSHER;
+}
+#define current_is_flush_bd_task()  is_flush_bd_task(current)
+
 /*
  * fs/fs-writeback.c
  */
Index: linux-2.6.33-rc5-mm1/fs/fs-writeback.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.33-rc5-mm1/fs/fs-writeback.c
@@ -605,9 +605,9 @@ static enum sb_pin_state pin_sb_for_writ
  * Return 1, if the caller writeback routine should be
  * interrupted. Otherwise return 0.
  */
-static int writeback_sb_inodes(struct super_block *sb,
-			       struct bdi_writeback *wb,
-			       struct writeback_control *wbc)
+int generic_writeback_sb_inodes(struct super_block *sb,
+				struct bdi_writeback *wb,
+				struct writeback_control *wbc)
 {
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
@@ -658,6 +658,32 @@ static int writeback_sb_inodes(struct su
 	/* b_io is empty */
 	return 1;
 }
+EXPORT_SYMBOL(generic_writeback_sb_inodes);
+
+/*
+ * This function is for file systems which have their
+ * own means of periodical write-out of old data.
+ * NOTE: inode_lock should be hold.
+ *
+ * Skip a portion of b_io inodes which belong to @sb
+ * and go sequentially in reverse order.
+ */
+void writeback_skip_sb_inodes(struct super_block *sb,
+			      struct bdi_writeback *wb)
+{
+	while (1) {
+		struct inode *inode;
+
+		if (list_empty(&wb->b_io))
+			break;
+		inode = list_entry(wb->b_io.prev, struct inode, i_list);
+		if (sb != inode->i_sb)
+			break;
+		redirty_tail(inode);
+	}
+}
+EXPORT_SYMBOL(writeback_skip_sb_inodes);
+
 
 static void writeback_inodes_wb(struct bdi_writeback *wb,
 				struct writeback_control *wbc)
@@ -687,7 +713,10 @@ static void writeback_inodes_wb(struct b
 			requeue_io(inode);
 			continue;
 		}
-		ret = writeback_sb_inodes(sb, wb, wbc);
+		if (sb->s_op->writeback_inodes)
+			ret = sb->s_op->writeback_inodes(sb, wb, wbc);
+		else
+			ret = generic_writeback_sb_inodes(sb, wb, wbc);
 
 		if (state == SB_PINNED)
 			unpin_sb_for_writeback(sb);
@@ -704,6 +733,7 @@ void writeback_inodes_wbc(struct writeba
 
 	writeback_inodes_wb(&bdi->wb, wbc);
 }
+EXPORT_SYMBOL(writeback_inodes_wbc);
 
 /*
  * The maximum number of pages to writeout in a single bdi flush/kupdate
@@ -1289,3 +1319,12 @@ int sync_inode(struct inode *inode, stru
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
+/*
+ * Local variables:
+ * c-indentation-style: "K&R"
+ * mode-name: "LC"
+ * c-basic-offset: 8
+ * tab-width: 8
+ * fill-column: 79
+ * End:
+ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
