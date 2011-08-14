Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7E0EnYY172875 for <xfs@oss.sgi.com>; Sat, 13 Aug 2011 19:14:49 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 416A4D8B1F
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2011 17:14:47 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id GVgRN7AEpCOnC1Cu for <xfs@oss.sgi.com>;
	Sat, 13 Aug 2011 17:14:47 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
	(v2)
Date: Sun, 14 Aug 2011 02:16:26 +0200
References: <4E1C70AD.1010101@u-club.de> <201108062317.19033.rjw@sisk.pl>
	<20110807001446.GI3162@dastard>
In-Reply-To: <20110807001446.GI3162@dastard>
MIME-Version: 1.0
Message-Id: <201108140216.26340.rjw@sisk.pl>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph <cr2005@u-club.de>, Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, linux-ext4@vger.kernel.org

On Sunday, August 07, 2011, Dave Chinner wrote:
> On Sat, Aug 06, 2011 at 11:17:18PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
...
> > +	/*
> > +	 * Freeze in reverse order so filesystems depending on others are
> > +	 * frozen in the right order (eg. loopback on ext3).
> > +	 */
> > +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
> > +		if (!sb->s_root || !sb->s_bdev ||
> > +		    (sb->s_frozen == SB_FREEZE_TRANS) ||
> > +		    (sb->s_flags & MS_RDONLY))
> > +			continue;
> > +
> > +		freeze_bdev(sb->s_bdev);
> > +		sb->s_flags |= MS_FROZEN;
> > +	}
> 
> AFAIK, that won't work for btrfs - you have to call freeze_super()
> directly for btrfs because it has a special relationship with
> sb->s_bdev. And besides, all freeze_bdev does is get an active
> reference on the superblock and call freeze_super().
> 
> Also, that's traversing the list of superblock with locking and
> dereferencing the superblock without properly checking that the
> superblock is not being torn down. You should probably use
> iterate_supers (or at least copy the code), with a function that
> drops the s_umount read lock befor calling freeze_super() and then
> picks it back up afterwards.

So, what about the patch below?  It appears to work on my test boxes.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Freezer: Freeze filesystems while freezing processes (v3)

Freeze all filesystems during the freezing of tasks by calling
freeze_super() for all superblocks and thaw them during the thawing
of tasks with the help of thaw_super().

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

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/super.c             |   70 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h     |    3 ++
 kernel/power/process.c |    9 +++++-
 3 files changed, 81 insertions(+), 1 deletion(-)

Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -211,6 +211,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_FROZEN	(1<<25) /* Frozen filesystem */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
@@ -2497,6 +2498,8 @@ extern void drop_super(struct super_bloc
 extern void iterate_supers(void (*)(struct super_block *, void *), void *);
 extern void iterate_supers_type(struct file_system_type *,
 			        void (*)(struct super_block *, void *), void *);
+extern int freeze_supers(void);
+extern void thaw_supers(void);
 
 extern int dcache_dir_open(struct inode *, struct file *);
 extern int dcache_dir_close(struct inode *, struct file *);
Index: linux/kernel/power/process.c
===================================================================
--- linux.orig/kernel/power/process.c
+++ linux/kernel/power/process.c
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
@@ -147,6 +147,12 @@ int freeze_processes(void)
 		goto Exit;
 	printk("done.\n");
 
+	printk("Freezing filesystems ... ");
+	error = freeze_supers();
+	if (error)
+		goto Exit;
+	printk("done.\n");
+
 	printk("Freezing remaining freezable tasks ... ");
 	error = try_to_freeze_tasks(false);
 	if (error)
@@ -188,6 +194,7 @@ void thaw_processes(void)
 	printk("Restarting tasks ... ");
 	thaw_workqueues();
 	thaw_tasks(true);
+	thaw_supers();
 	thaw_tasks(false);
 	schedule();
 	printk("done.\n");
Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c
+++ linux/fs/super.c
@@ -590,6 +590,76 @@ void iterate_supers_type(struct file_sys
 EXPORT_SYMBOL(iterate_supers_type);
 
 /**
+ *	freeze_supers - call freeze_super() for all superblocks
+ */
+int freeze_supers(void)
+{
+	struct super_block *sb, *p = NULL;
+	int error = 0;
+
+	spin_lock(&sb_lock);
+	/*
+	 * Freeze in reverse order so filesystems depending on others are
+	 * frozen in the right order (eg. loopback on ext3).
+	 */
+	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
+		if (list_empty(&sb->s_instances))
+			continue;
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+
+		if (sb->s_root && sb->s_frozen != SB_FREEZE_TRANS
+		    && !(sb->s_flags & MS_RDONLY)) {
+			error = freeze_super(sb);
+			if (!error)
+				sb->s_flags |= MS_FROZEN;
+		}
+
+		spin_lock(&sb_lock);
+		if (error)
+			break;
+		if (p)
+			__put_super(p);
+		p = sb;
+	}
+	if (p)
+		__put_super(p);
+	spin_unlock(&sb_lock);
+
+	return error;
+}
+
+/**
+ *	thaw_supers - call thaw_super() for all superblocks
+ */
+void thaw_supers(void)
+{
+	struct super_block *sb, *p = NULL;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (list_empty(&sb->s_instances))
+			continue;
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+
+		if (sb->s_flags & MS_FROZEN) {
+			thaw_super(sb);
+			sb->s_flags &= ~MS_FROZEN;
+		}
+
+		spin_lock(&sb_lock);
+		if (p)
+			__put_super(p);
+		p = sb;
+	}
+	if (p)
+		__put_super(p);
+	spin_unlock(&sb_lock);
+}
+
+
+/**
  *	get_super - get the superblock of a device
  *	@bdev: device to get the superblock for
  *	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
