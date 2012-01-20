Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KKZ1lJ125569 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 14:35:01 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 3XRWkfXC5cUYYKZv for <xfs@oss.sgi.com>;
	Fri, 20 Jan 2012 12:34:59 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/8] fs: Improve filesystem freezing handling
Date: Fri, 20 Jan 2012 21:34:39 +0100
Message-Id: <1327091686-23177-2-git-send-email-jack@suse.cz>
In-Reply-To: <1327091686-23177-1-git-send-email-jack@suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org

vfs_check_frozen() tests are racy since the filesystem can be frozen just after
the test is performed. Thus in write paths we can end up marking some pages or
inodes dirty even though filesystem is already frozen. This creates problems
with flusher thread hanging on frozen filesystem.

Another problem is that exclusion between ->page_mkwrite() and filesystem
freezing has been handled by setting page dirty and then verifying s_frozen.
This guaranteed that either the freezing code sees the faulted page, writes it,
and writeprotects it again or we see s_frozen set and bail out of page fault.
This works to protect from page being marked writeable while filesystem
freezing is running but has an unpleasant artefact of leaving dirty (although
unmodified and writeprotected) pages on frozen filesystem resulting in similar
problems with flusher thread as the first problem.

This patch aims at providing exclusion between write paths and filesystem
freezing. We implement a writer-freeze read-write semaphores in the superblock
for each freezing level (currently there are two - SB_FREEZE_WRITE for data and
SB_FREEZE_TRANS for metadata). Write paths which should block freezing on given
level (e.g. ->block_page_mkwrite(), ->aio_write() for SB_FREEZE_WRITE level;
transaction lifetime for SB_FREEZE_TRANS level) hold reader side of the
semaphore. Code freezing the filesystem to a given level takes the writer side.

Only that we don't really want to bounce cachelines of the semaphore between
CPUs for each write happening. So we implement the reader side of the semaphore
as a per-cpu counter and the writer side is implemented using s_frozen
superblock field.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c         |  204 ++++++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/fs.h |   41 ++++++++---
 2 files changed, 220 insertions(+), 25 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index afd0f1a..4aaad7e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -32,12 +32,15 @@
 #include <linux/backing-dev.h>
 #include <linux/rculist_bl.h>
 #include <linux/cleancache.h>
+#include <linux/lockdep.h>
 #include "internal.h"
 
 
 LIST_HEAD(super_blocks);
 DEFINE_SPINLOCK(sb_lock);
 
+static struct lock_class_key sb_writers_key[SB_FREEZE_LEVELS-1];
+
 /*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
@@ -101,6 +104,24 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 	return total_objects;
 }
 
+static int init_sb_writers(struct super_block *s, int level, char *lockname)
+{
+	struct sb_writers_level *sl = &s->s_writers[level-1];
+	int err;
+
+	err = percpu_counter_init(&sl->counter, 0);
+	if (err < 0)
+		return err;
+	init_waitqueue_head(&sl->wait);
+	lockdep_init_map(&sl->lock_map, lockname, &sb_writers_key[level-1], 0);
+	return 0;
+}
+
+static void destroy_sb_writers(struct super_block *s, int level)
+{
+	percpu_counter_destroy(&s->s_writers[level-1].counter);
+}
+
 /**
  *	alloc_super	-	create new superblock
  *	@type:	filesystem type superblock should belong to
@@ -115,18 +136,19 @@ static struct super_block *alloc_super(struct file_system_type *type)
 
 	if (s) {
 		if (security_sb_alloc(s)) {
+			/*
+			 * We cannot call security_sb_free() without
+			 * security_sb_alloc() succeeding. So bail out manually
+			 */
 			kfree(s);
 			s = NULL;
 			goto out;
 		}
 #ifdef CONFIG_SMP
 		s->s_files = alloc_percpu(struct list_head);
-		if (!s->s_files) {
-			security_sb_free(s);
-			kfree(s);
-			s = NULL;
-			goto out;
-		} else {
+		if (!s->s_files)
+			goto err_out;
+		else {
 			int i;
 
 			for_each_possible_cpu(i)
@@ -135,6 +157,11 @@ static struct super_block *alloc_super(struct file_system_type *type)
 #else
 		INIT_LIST_HEAD(&s->s_files);
 #endif
+		if (init_sb_writers(s, SB_FREEZE_WRITE, "sb_writers_write"))
+			goto err_out;
+		if (init_sb_writers(s, SB_FREEZE_TRANS, "sb_writers_trans"))
+			goto err_out;
+
 		s->s_bdi = &default_backing_dev_info;
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
@@ -186,6 +213,17 @@ static struct super_block *alloc_super(struct file_system_type *type)
 	}
 out:
 	return s;
+err_out:
+	security_sb_free(s);
+#ifdef CONFIG_SMP
+	if (s->s_files)
+		free_percpu(s->s_files);
+#endif
+	destroy_sb_writers(s, SB_FREEZE_WRITE);
+	destroy_sb_writers(s, SB_FREEZE_TRANS);
+	kfree(s);
+	s = NULL;
+	goto out;
 }
 
 /**
@@ -1126,6 +1164,148 @@ out:
 }
 
 /**
+ * sb_end_write - drop write access to a superblock
+ * @sb: the super we wrote to
+ * @level: the lowest level of freezing which we blocked
+ *
+ * Decrement number of writers to the filesystem preventing freezing of
+ * given level. Wake up possible waiters wanting to freeze the filesystem.
+ */
+void sb_end_write(struct super_block *sb, int level)
+{
+	struct sb_writers_level *sl = &sb->s_writers[level-1];
+
+	percpu_counter_dec(&sl->counter);
+	/*
+	 * Make sure s_writers are updated before we wake up waiters in
+	 * freeze_super().
+	 */
+	smp_mb();
+	if (waitqueue_active(&sl->wait))
+		wake_up(&sl->wait);
+	rwsem_release(&sl->lock_map, 1, _RET_IP_);
+}
+EXPORT_SYMBOL(sb_end_write);
+
+/**
+ * sb_start_write - get write access to a superblock
+ * @sb: the super we write to
+ * @level: the lowest level of freezing which we block
+ *
+ * When a process wants to write data to a filesystem (i.e. dirty a page), it
+ * should embed the operation in a sb_start_write() - sb_end_write() pair to
+ * get exclusion against filesystem freezing. This function increments number
+ * of writers preventing freezing of given level to proceed.  If the file
+ * system is already frozen it waits until it is thawed.
+ *
+ * The lock orderding constraints of sb_start_write() for level SB_FREEZE_WRITE
+ * are following:
+ * mmap_sem			(page-fault)
+ *   -> s_writers		(block_page_mkwrite or equivalent)
+ *
+ * i_mutex			(do_truncate, __generic_file_aio_write)
+ *   -> s_writers
+ *
+ * s_umount			(freeze_super)
+ *   -> s_writers
+ *
+ * For level SB_FREEZE_TRANS lock constraints are rather file system dependent,
+ * in most cases equivalent to constraints for starting a fs transaction.
+ */
+void sb_start_write(struct super_block *sb, int level)
+{
+retry:
+	rwsem_acquire_read(&sb->s_writers[level-1].lock_map, 0, 0, _RET_IP_);
+	vfs_check_frozen(sb, level);
+	percpu_counter_inc(&sb->s_writers[level-1].counter);
+	/*
+	 * Make sure s_writers are updated before we check s_frozen.
+	 * freeze_super() first sets s_frozen and then checks s_writers.
+	 */
+	smp_mb();
+	if (sb->s_frozen >= level) {
+		sb_end_write(sb, level);
+		goto retry;
+	}
+}
+EXPORT_SYMBOL(sb_start_write);
+
+/**
+ * sb_dup_write - get write access to a superblock without blocking
+ * @sb: the super we write to
+ * @level: the lowest level of freezing which we block
+ *
+ * This function is like sb_start_write() only that it does not check s_frozen
+ * in the superblock. The caller can call this function only when it already
+ * holds write access to the superblock at this level (i.e., called
+ * sb_start_write(sb, level) previously).
+ */
+void sb_dup_write(struct super_block *sb, int level)
+{
+	/*
+	 * Trick lockdep into acquiring read lock again without complaining
+	 * about lock recursion
+	 */
+	rwsem_acquire_read(&sb->s_writers[level-1].lock_map, 0, 1, _RET_IP_);
+	percpu_counter_inc(&sb->s_writers[level-1].counter);
+}
+EXPORT_SYMBOL(sb_dup_write);
+
+/**
+ * sb_wait_write - wait until all writers at given level finish
+ * @sb: the super for which we wait
+ * @level: the level at which we wait for writers
+ *
+ * This function waits until there are no writers at given level. Caller
+ * of this function should make sure there can be no new writers at required
+ * level before calling this function. Otherwise this function can livelock.
+ */
+void sb_wait_write(struct super_block *sb, int level)
+{
+	s64 writers;
+	struct sb_writers_level *sl = &sb->s_writers[level-1];
+
+	do {
+		DEFINE_WAIT(wait);
+
+		/*
+		 * We use a barrier in prepare_to_wait() to separate setting
+		 * of s_frozen and checking of s_writers
+		 */
+		prepare_to_wait(&sl->wait, &wait, TASK_UNINTERRUPTIBLE);
+
+		writers = percpu_counter_sum(&sl->counter);
+		if (writers)
+			schedule();
+
+		finish_wait(&sl->wait, &wait);
+	} while (writers);
+}
+EXPORT_SYMBOL(sb_wait_write);
+
+/*
+ * Freeze superblock to given level, wait for writers at given level
+ * to finish.
+ */
+static void sb_freeze_to_level(struct super_block *sb, int level)
+{
+	sb->s_frozen = level;
+
+	/*
+	 * We just cycle-through lockdep here so that it does not complain
+	 * about returning with lock to userspace
+	 */
+	rwsem_acquire(&sb->s_writers[level-1].lock_map, 0, 0, _THIS_IP_);
+	rwsem_release(&sb->s_writers[level-1].lock_map, 1, _THIS_IP_);
+
+	/*
+	 * Now wait for writers to finish. As s_frozen is already set to
+	 * 'level' we are guaranteed there are no new writers at given level.
+	 */
+	sb_wait_write(sb, level);
+}
+
+/**
  * freeze_super - lock the filesystem and force it into a consistent state
  * @sb: the super to lock
  *
@@ -1151,21 +1331,19 @@ int freeze_super(struct super_block *sb)
 		return 0;
 	}
 
-	sb->s_frozen = SB_FREEZE_WRITE;
-	smp_wmb();
-
+	sb_freeze_to_level(sb, SB_FREEZE_WRITE);
 	sync_filesystem(sb);
-
-	sb->s_frozen = SB_FREEZE_TRANS;
-	smp_wmb();
-
+	sb_freeze_to_level(sb, SB_FREEZE_TRANS);
 	sync_blockdev(sb->s_bdev);
+
 	if (sb->s_op->freeze_fs) {
 		ret = sb->s_op->freeze_fs(sb);
 		if (ret) {
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_frozen = SB_UNFROZEN;
+			smp_wmb();
+			wake_up(&sb->s_wait_unfrozen);
 			deactivate_locked_super(sb);
 			return ret;
 		}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e313022..93ce5af 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -395,6 +395,7 @@ struct inodes_stat_t {
 #include <linux/rculist_bl.h>
 #include <linux/shrinker.h>
 #include <linux/atomic.h>
+#include <linux/lockdep.h>
 
 #include <asm/byteorder.h>
 
@@ -1385,6 +1386,24 @@ extern pid_t f_getown(struct file *filp);
 extern int send_sigurg(struct fown_struct *fown);
 
 /*
+ * Snapshotting support.
+ */
+enum {
+	SB_UNFROZEN = 0,
+	SB_FREEZE_WRITE	= 1,
+	SB_FREEZE_TRANS = 2,
+	SB_FREEZE_LEVELS	/* Number of freezing states */
+};
+
+#define vfs_check_frozen(sb, level) \
+	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
+
+void sb_end_write(struct super_block *sb, int level);
+void sb_start_write(struct super_block *sb, int level);
+void sb_dup_write(struct super_block *sb, int level);
+void sb_wait_write(struct super_block *sb, int level);
+
+/*
  *	Umount options
  */
 
@@ -1397,6 +1416,15 @@ extern int send_sigurg(struct fown_struct *fown);
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
+struct sb_writers_level {
+	struct percpu_counter	counter;	/* counter of running writes */
+	wait_queue_head_t	wait;		/* queue for waiting for
+						   writers to finish */
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	lock_map;
+#endif
+};
+
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
@@ -1445,6 +1473,7 @@ struct super_block {
 
 	int			s_frozen;
 	wait_queue_head_t	s_wait_unfrozen;
+	struct sb_writers_level	s_writers[SB_FREEZE_LEVELS - 1];
 
 	char s_id[32];				/* Informational name */
 	u8 s_uuid[16];				/* UUID */
@@ -1490,18 +1519,6 @@ extern void prune_dcache_sb(struct super_block *sb, int nr_to_scan);
 extern struct timespec current_fs_time(struct super_block *sb);
 
 /*
- * Snapshotting support.
- */
-enum {
-	SB_UNFROZEN = 0,
-	SB_FREEZE_WRITE	= 1,
-	SB_FREEZE_TRANS = 2,
-};
-
-#define vfs_check_frozen(sb, level) \
-	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
-
-/*
  * until VFS tracks user namespaces for inodes, just make all files
  * belong to init_user_ns
  */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
