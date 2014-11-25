Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DACA57F4E
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 23:34:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C97568F8040
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 21:34:50 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id rw9kCBmWubwngIdK (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 21:34:48 -0800 (PST)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v3 2/6] vfs: add support for a lazytime mount option
Date: Tue, 25 Nov 2014 00:34:30 -0500
Message-Id: <1416893674-419-3-git-send-email-tytso@mit.edu>
In-Reply-To: <1416893674-419-1-git-send-email-tytso@mit.edu>
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

Add a new mount option which enables a new "lazytime" mode.  This mode
causes atime, mtime, and ctime updates to only be made to the
in-memory version of the inode.  The on-disk times will only get
updated when (a) if the inode needs to be updated for some non-time
related change, (b) if userspace calls fsync(), syncfs() or sync(), or
(c) just before an undeleted inode is evicted from memory.

This is OK according to POSIX because there are no guarantees after a
crash unless userspace explicitly requests via a fsync(2) call.

For workloads which feature a large number of random write to a
preallocated file, the lazytime mount option significantly reduces
writes to the inode table.  The repeated 4k writes to a single block
will result in undesirable stress on flash devices and SMR disk
drives.  Even on conventional HDD's, the repeated writes to the inode
table block will trigger Adjacent Track Interference (ATI) remediation
latencies, which very negatively impact 99.9 percentile latencies ---
which is a very big deal for web serving tiers (for example).

Google-Bug-Id: 18297052

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/fs-writeback.c       | 38 +++++++++++++++++++++++++++++++++++++-
 fs/inode.c              | 21 +++++++++++++++++++++
 fs/proc_namespace.c     |  1 +
 fs/sync.c               |  7 +++++++
 include/linux/fs.h      |  1 +
 include/uapi/linux/fs.h |  1 +
 6 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ef9bef1..ce7de22 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -483,7 +483,7 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		inode->i_state &= ~I_DIRTY_PAGES;
 	dirty = inode->i_state & I_DIRTY;
-	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
+	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_TIME);
 	spin_unlock(&inode->i_lock);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
@@ -1277,6 +1277,41 @@ static void wait_sb_inodes(struct super_block *sb)
 	iput(old_inode);
 }
 
+/*
+ * This works like wait_sb_inodes(), but it is called *before* we kick
+ * the bdi so the inodes can get written out.
+ */
+static void flush_sb_dirty_time(struct super_block *sb)
+{
+	struct inode *inode, *old_inode = NULL;
+
+	WARN_ON(!rwsem_is_locked(&sb->s_umount));
+	spin_lock(&inode_sb_list_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		int dirty_time;
+
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+		dirty_time = inode->i_state & I_DIRTY_TIME;
+		__iget(inode);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&inode_sb_list_lock);
+
+		iput(old_inode);
+		old_inode = inode;
+
+		if (dirty_time)
+			mark_inode_dirty(inode);
+		cond_resched();
+		spin_lock(&inode_sb_list_lock);
+	}
+	spin_unlock(&inode_sb_list_lock);
+	iput(old_inode);
+}
+
 /**
  * writeback_inodes_sb_nr -	writeback dirty inodes from given super_block
  * @sb: the superblock
@@ -1388,6 +1423,7 @@ void sync_inodes_sb(struct super_block *sb)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
+	flush_sb_dirty_time(sb);
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
 
diff --git a/fs/inode.c b/fs/inode.c
index 8f5c4b5..2093a84 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -534,6 +534,18 @@ static void evict(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(!list_empty(&inode->i_lru));
 
+	if (inode->i_nlink && inode->i_state & I_DIRTY_TIME) {
+		if (inode->i_op->write_time)
+			inode->i_op->write_time(inode);
+		else if (inode->i_sb->s_op->write_inode) {
+			struct writeback_control wbc = {
+				.sync_mode = WB_SYNC_NONE,
+			};
+			mark_inode_dirty(inode);
+			inode->i_sb->s_op->write_inode(inode, &wbc);
+		}
+	}
+
 	if (!list_empty(&inode->i_wb_list))
 		inode_wb_list_del(inode);
 
@@ -1515,6 +1527,15 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 		if (flags & S_MTIME)
 			inode->i_mtime = *time;
 	}
+	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
+	    !(flags & S_VERSION)) {
+		if (inode->i_state & I_DIRTY_TIME)
+			return 0;
+		spin_lock(&inode->i_lock);
+		inode->i_state |= I_DIRTY_TIME;
+		spin_unlock(&inode->i_lock);
+		return 0;
+	}
 	if (inode->i_op->write_time)
 		return inode->i_op->write_time(inode);
 	mark_inode_dirty_sync(inode);
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 73ca174..f98234a 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -44,6 +44,7 @@ static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 		{ MS_SYNCHRONOUS, ",sync" },
 		{ MS_DIRSYNC, ",dirsync" },
 		{ MS_MANDLOCK, ",mand" },
+		{ MS_LAZYTIME, ",lazytime" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
diff --git a/fs/sync.c b/fs/sync.c
index bdc729d..3a35506a 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -177,8 +177,15 @@ SYSCALL_DEFINE1(syncfs, int, fd)
  */
 int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 {
+	struct inode *inode = file->f_mapping->host;
+
 	if (!file->f_op->fsync)
 		return -EINVAL;
+	if (!datasync && (inode->i_state & I_DIRTY_TIME)) {
+		spin_lock(&inode->i_lock);
+		inode->i_state |= I_DIRTY_SYNC;
+		spin_unlock(&inode->i_lock);
+	}
 	return file->f_op->fsync(file, start, end, datasync);
 }
 EXPORT_SYMBOL(vfs_fsync_range);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3633239..489b2f2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1721,6 +1721,7 @@ struct super_operations {
 #define __I_DIO_WAKEUP		9
 #define I_DIO_WAKEUP		(1 << I_DIO_WAKEUP)
 #define I_LINKABLE		(1 << 10)
+#define I_DIRTY_TIME		(1 << 11)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3735fa0..cc9713a 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -90,6 +90,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily */
 
 /* These sb flags are internal to the kernel */
 #define MS_NOSEC	(1<<28)
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
