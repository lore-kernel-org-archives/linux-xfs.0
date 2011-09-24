Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8OMs6BL028183 for <xfs@oss.sgi.com>; Sat, 24 Sep 2011 17:54:07 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67F591C3F0D3
	for <xfs@oss.sgi.com>; Sat, 24 Sep 2011 15:54:04 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id mq9Hn6HaZfcp9Om4 for <xfs@oss.sgi.com>;
	Sat, 24 Sep 2011 15:54:04 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
	(v2)
Date: Sun, 25 Sep 2011 00:56:12 +0200
References: <4E1C70AD.1010101@u-club.de> <201108062317.19033.rjw@sisk.pl>
	<20110807001446.GI3162@dastard>
In-Reply-To: <20110807001446.GI3162@dastard>
MIME-Version: 1.0
Message-Id: <201109250056.12545.rjw@sisk.pl>
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
> > 
> > Freeze all filesystems during the freezing of tasks by calling
> > freeze_bdev() for each of them and thaw them during the thawing
> > of tasks with the help of thaw_bdev().
> > 
> > This is needed by hibernation, because some filesystems (e.g. XFS)
> > deadlock with the preallocation of memory used by it if the memory
> > pressure caused by it is too heavy.
> > 
> > The additional benefit of this change is that, if something goes
> > wrong after filesystems have been frozen, they will stay in a
> > consistent state and journal replays won't be necessary (e.g. after
> > a failing suspend or resume).  In particular, this should help to
> > solve a long-standing issue that in some cases during resume from
> > hibernation the boot loader causes the journal to be replied for the
> > filesystem containing the kernel image and initrd causing it to
> > become inconsistent with the information stored in the hibernation
> > image.
> > 
> > This change is based on earlier work by Nigel Cunningham.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---

Below is an alternative fix, the changelog pretty much explains the idea.

I've tested it on Toshiba Portege R500, but I don't have an XFS partition
to verify that it really helps, so I'd appreciate it if someone able to
reproduce the original issue could test it and report back.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Freeze kernel threads after preallocating memory

There is a problem with the current ordering of hibernate code which
leads to deadlocks in some filesystems' memory shrinkers.  Namely,
some filesystems use freezable kernel threads that are inactive when
the hibernate memory preallocation is carried out.  Those same
filesystems use memory shrinkers that may be triggered by the
hibernate memory preallocation.  If those memory shrinkers wait for
the frozen kernel threads, the hibernate process deadlocks (this
happens with XFS, for one example).

Apparently, it is not technically viable to redesign the filesystems
in question to avoid the situation described above, so the only
possible solution of this issue is to defer the freezing of kernel
threads until the hibernate memory preallocation is done, which is
implemented by this change.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h  |    4 +++-
 kernel/power/hibernate.c |   12 ++++++++----
 kernel/power/power.h     |    3 ++-
 kernel/power/process.c   |   30 ++++++++++++++++++++----------
 4 files changed, 33 insertions(+), 16 deletions(-)

Index: linux/kernel/power/process.c
===================================================================
--- linux.orig/kernel/power/process.c
+++ linux/kernel/power/process.c
@@ -135,7 +135,7 @@ static int try_to_freeze_tasks(bool sig_
 }
 
 /**
- *	freeze_processes - tell processes to enter the refrigerator
+ * freeze_processes - Signal user space processes to enter the refrigerator.
  */
 int freeze_processes(void)
 {
@@ -143,20 +143,30 @@ int freeze_processes(void)
 
 	printk("Freezing user space processes ... ");
 	error = try_to_freeze_tasks(true);
-	if (error)
-		goto Exit;
-	printk("done.\n");
+	if (!error) {
+		printk("done.");
+		oom_killer_disable();
+	}
+	printk("\n");
+	BUG_ON(in_atomic());
+
+	return error;
+}
+
+/**
+ * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
+ */
+int freeze_kernel_threads(void)
+{
+	int error;
 
 	printk("Freezing remaining freezable tasks ... ");
 	error = try_to_freeze_tasks(false);
-	if (error)
-		goto Exit;
-	printk("done.");
+	if (!error)
+		printk("done.");
 
-	oom_killer_disable();
- Exit:
-	BUG_ON(in_atomic());
 	printk("\n");
+	BUG_ON(in_atomic());
 
 	return error;
 }
Index: linux/include/linux/freezer.h
===================================================================
--- linux.orig/include/linux/freezer.h
+++ linux/include/linux/freezer.h
@@ -49,6 +49,7 @@ extern int thaw_process(struct task_stru
 
 extern void refrigerator(void);
 extern int freeze_processes(void);
+extern int freeze_kernel_threads(void);
 extern void thaw_processes(void);
 
 static inline int try_to_freeze(void)
@@ -171,7 +172,8 @@ static inline void clear_freeze_flag(str
 static inline int thaw_process(struct task_struct *p) { return 1; }
 
 static inline void refrigerator(void) {}
-static inline int freeze_processes(void) { BUG(); return 0; }
+static inline int freeze_processes(void) { return -ENOSYS; }
+static inline int freeze_kernel_threads(void) { return -ENOSYS; }
 static inline void thaw_processes(void) {}
 
 static inline int try_to_freeze(void) { return 0; }
Index: linux/kernel/power/power.h
===================================================================
--- linux.orig/kernel/power/power.h
+++ linux/kernel/power/power.h
@@ -228,7 +228,8 @@ extern int pm_test_level;
 #ifdef CONFIG_SUSPEND_FREEZER
 static inline int suspend_freeze_processes(void)
 {
-	return freeze_processes();
+	int error = freeze_processes();
+	return error ? : freeze_kernel_threads();
 }
 
 static inline void suspend_thaw_processes(void)
Index: linux/kernel/power/hibernate.c
===================================================================
--- linux.orig/kernel/power/hibernate.c
+++ linux/kernel/power/hibernate.c
@@ -334,13 +334,17 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		goto Close;
 
-	error = dpm_prepare(PMSG_FREEZE);
-	if (error)
-		goto Complete_devices;
-
 	/* Preallocate image memory before shutting down devices. */
 	error = hibernate_preallocate_memory();
 	if (error)
+		goto Close;
+
+	error = freeze_kernel_threads();
+	if (error)
+		goto Close;
+
+	error = dpm_prepare(PMSG_FREEZE);
+	if (error)
 		goto Complete_devices;
 
 	suspend_console();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
