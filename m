Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73LETbl181205 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 16:14:30 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24B10F03193
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 14:15:17 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id Jhsp3qq7YjuH9s7T for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 14:15:17 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC][PATCH] PM / Freezer: Freeze filesystems along with freezing
	processes (was: Re: PM / hibernate xfs lock up /
	xfs_reclaim_inodes_ag)
Date: Wed, 3 Aug 2011 23:15:05 +0200
References: <4E1C70AD.1010101@u-club.de> <20110727103308.GA20805@infradead.org>
	<4E300317.7090108@tuxonice.net>
In-Reply-To: <4E300317.7090108@tuxonice.net>
MIME-Version: 1.0
Message-Id: <201108032315.06012.rjw@sisk.pl>
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
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Christoph <cr2005@u-club.de>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Pavel Machek <pavel@ucw.cz>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>

On Wednesday, July 27, 2011, Nigel Cunningham wrote:
> Hi.
> 
> On 27/07/11 20:33, Christoph Hellwig wrote:
> > On Wed, Jul 27, 2011 at 11:35:13AM +0200, Rafael J. Wysocki wrote:
> >> The Pavel's objection, if I remember it correctly, was that some
> >> (or the majority of?) filesystems didn't implement the freezing operation,
> >> so they would be more vulnerable to data loss in case of a failing hibernation
> >> after this change.  However, that's better than actively causing pain to XFS
> >> users.
> > 
> > The objection never made sense and only means he never read the code.
> > freeze_super (or freeze_bdev back then) always does a sync_filesystem
> > before even checking if we have a freeze method, and sync_filesystem is
> > what we iterate over for each superblock in sync().
> 
> I've had freezing supers in TOI for a couple of years now and it has
> only ever helped. To be honest, if you have a ton of dirty pages, it
> does result in a big delay, but that's the worst of it.

OK, so below is the revived patch.

To be precise, we don't call sys_sync() from the freezer an more
(evidently, I'd removed in myself, but later forgot about that), so
it only adds freeze_filesystems() and thaw_filesystems().

Comments welcome.

Thanks,
Rafael

---

Freeze all filesystems during the freezing of tasks by calling
freeze_bdev() for each of them and thaw them during the thawing
of tasks with the help of thaw_bdev().

This is needed by hibernation, because some filesystems (e.g. XFS)
deadlock with the preallocation of memory used by it if the memory
pressure caused by it is too heavy.

The additional benefit of this change is that, if something goes
wrong after filesystems have been frozen, they will stay in a
consistent state and journal replays won't be necessary (e.g. after
a failing suspend or resume).  In particular, this should help to
solve a long-standing issue that in some cases during resume from
hibernation the boot loader causes the journal to be replied for the
filesystem containing the kernel image and initrd causing it to
become inconsistent with the information stored in the hibernation
image.

This change is based on earlier work by Nigel Cunningham.

Not-really-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/block_dev.c         |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h     |    6 ++++++
 kernel/power/process.c |    7 ++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -211,6 +211,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_FROZEN	(1<<25) /* bdev has been frozen */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
@@ -2047,6 +2048,8 @@ extern struct super_block *freeze_bdev(s
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
+extern void freeze_filesystems(void);
+extern void thaw_filesystems(void);
 #else
 static inline void bd_forget(struct inode *inode) {}
 static inline int sync_blockdev(struct block_device *bdev) { return 0; }
@@ -2061,6 +2064,9 @@ static inline int thaw_bdev(struct block
 {
 	return 0;
 }
+
+static inline void freeze_filesystems(void) {}
+static inline void thaw_filesystems(void) {}
 #endif
 extern int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c
+++ linux-2.6/fs/block_dev.c
@@ -314,6 +314,49 @@ out:
 }
 EXPORT_SYMBOL(thaw_bdev);
 
+/**
+ * freeze_filesystems - Force all filesystems into a consistent state.
+ */
+void freeze_filesystems(void)
+{
+	struct super_block *sb;
+
+	lockdep_off();
+	/*
+	 * Freeze in reverse order so filesystems dependant upon others are
+	 * frozen in the right order (eg. loopback on ext3).
+	 */
+	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
+		if (!sb->s_root || !sb->s_bdev ||
+		    (sb->s_frozen == SB_FREEZE_TRANS) ||
+		    (sb->s_flags & MS_RDONLY) ||
+		    (sb->s_flags & MS_FROZEN))
+			continue;
+
+		freeze_bdev(sb->s_bdev);
+		sb->s_flags |= MS_FROZEN;
+	}
+	lockdep_on();
+}
+
+/**
+ * thaw_filesystems - Make all filesystems active again.
+ */
+void thaw_filesystems(void)
+{
+	struct super_block *sb;
+
+	lockdep_off();
+
+	list_for_each_entry(sb, &super_blocks, s_list)
+		if (sb->s_flags & MS_FROZEN) {
+			sb->s_flags &= ~MS_FROZEN;
+			thaw_bdev(sb->s_bdev, sb);
+		}
+
+	lockdep_on();
+}
+
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 {
 	return block_write_full_page(page, blkdev_get_block, wbc);
Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c
+++ linux-2.6/kernel/power/process.c
@@ -12,10 +12,10 @@
 #include <linux/oom.h>
 #include <linux/suspend.h>
 #include <linux/module.h>
-#include <linux/syscalls.h>
 #include <linux/freezer.h>
 #include <linux/delay.h>
 #include <linux/workqueue.h>
+#include <linux/fs.h>
 
 /* 
  * Timeout for stopping processes
@@ -147,6 +147,10 @@ int freeze_processes(void)
 		goto Exit;
 	printk("done.\n");
 
+	pr_info("Freezing filesystems ... ");
+	freeze_filesystems();
+	pr_info("done.\n");
+
 	printk("Freezing remaining freezable tasks ... ");
 	error = try_to_freeze_tasks(false);
 	if (error)
@@ -188,6 +192,7 @@ void thaw_processes(void)
 	printk("Restarting tasks ... ");
 	thaw_workqueues();
 	thaw_tasks(true);
+	thaw_filesystems();
 	thaw_tasks(false);
 	schedule();
 	printk("done.\n");

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
