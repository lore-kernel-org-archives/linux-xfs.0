Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbdJCSxY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 14:53:24 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 5/5] pm: remove kernel thread freezing
Date: Tue,  3 Oct 2017 11:53:13 -0700
Message-Id: <20171003185313.1017-6-mcgrof@kernel.org>
In-Reply-To: <20171003185313.1017-1-mcgrof@kernel.org>
References: <20171003185313.1017-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Now that all filesystems which used to rely on kthread
freezing have been converted to filesystem freeze/thawing
we can remove the kernel kthread freezer.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 Documentation/power/freezing-of-tasks.txt |  9 ------
 drivers/xen/manage.c                      |  6 ----
 include/linux/freezer.h                   |  4 ---
 kernel/power/hibernate.c                  | 10 ++-----
 kernel/power/power.h                      | 20 +------------
 kernel/power/process.c                    | 47 -------------------------------
 kernel/power/user.c                       |  9 ------
 tools/power/pm-graph/analyze_suspend.py   |  1 -
 8 files changed, 3 insertions(+), 103 deletions(-)

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index af005770e767..477559f57c95 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -71,15 +71,6 @@ Rationale behind the functions dealing with freezing and thawing of tasks:
 freeze_processes():
   - freezes only userspace tasks
 
-freeze_kernel_threads():
-  - freezes all tasks (including kernel threads) because we can't freeze
-    kernel threads without freezing userspace tasks
-
-thaw_kernel_threads():
-  - thaws only kernel threads; this is particularly useful if we need to do
-    anything special in between thawing of kernel threads and thawing of
-    userspace tasks, or if we want to postpone the thawing of userspace tasks
-
 thaw_processes():
   - thaws all tasks (including kernel threads) because we can't thaw userspace
     tasks without thawing kernel threads
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index c425d03d37d2..8ca0e0c9a7d5 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -109,12 +109,6 @@ static void do_suspend(void)
 		goto out;
 	}
 
-	err = freeze_kernel_threads();
-	if (err) {
-		pr_err("%s: freeze kernel threads failed %d\n", __func__, err);
-		goto out_thaw;
-	}
-
 	err = dpm_suspend_start(PMSG_FREEZE);
 	if (err) {
 		pr_err("%s: dpm_suspend_start %d\n", __func__, err);
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index dd03e837ebb7..037ef3f16173 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -43,9 +43,7 @@ extern void __thaw_task(struct task_struct *t);
 
 extern bool __refrigerator(bool check_kthr_stop);
 extern int freeze_processes(void);
-extern int freeze_kernel_threads(void);
 extern void thaw_processes(void);
-extern void thaw_kernel_threads(void);
 
 /*
  * DO NOT ADD ANY NEW CALLERS OF THIS FUNCTION
@@ -263,9 +261,7 @@ static inline void __thaw_task(struct task_struct *t) {}
 
 static inline bool __refrigerator(bool check_kthr_stop) { return false; }
 static inline int freeze_processes(void) { return -ENOSYS; }
-static inline int freeze_kernel_threads(void) { return -ENOSYS; }
 static inline void thaw_processes(void) {}
-static inline void thaw_kernel_threads(void) {}
 
 static inline bool try_to_freeze_nowarn(void) { return false; }
 static inline bool try_to_freeze(void) { return false; }
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a5c36e9c56a6..7c3af084b10a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -352,10 +352,6 @@ int hibernation_snapshot(int platform_mode)
 	if (error)
 		goto Close;
 
-	error = freeze_kernel_threads();
-	if (error)
-		goto Cleanup;
-
 	if (hibernation_test(TEST_FREEZER)) {
 
 		/*
@@ -363,13 +359,13 @@ int hibernation_snapshot(int platform_mode)
 		 * successful freezer test.
 		 */
 		freezer_test_done = true;
-		goto Thaw;
+		goto Cleanup;
 	}
 
 	error = dpm_prepare(PMSG_FREEZE);
 	if (error) {
 		dpm_complete(PMSG_RECOVER);
-		goto Thaw;
+		goto Cleanup;
 	}
 
 	suspend_console();
@@ -405,8 +401,6 @@ int hibernation_snapshot(int platform_mode)
 	platform_end(platform_mode);
 	return error;
 
- Thaw:
-	thaw_kernel_threads();
  Cleanup:
 	swsusp_free();
 	goto Close;
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 1d2d761e3c25..333bde062e42 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -253,25 +253,7 @@ extern int pm_test_level;
 #ifdef CONFIG_SUSPEND_FREEZER
 static inline int suspend_freeze_processes(void)
 {
-	int error;
-
-	error = freeze_processes();
-	/*
-	 * freeze_processes() automatically thaws every task if freezing
-	 * fails. So we need not do anything extra upon error.
-	 */
-	if (error)
-		return error;
-
-	error = freeze_kernel_threads();
-	/*
-	 * freeze_kernel_threads() thaws only kernel threads upon freezing
-	 * failure. So we have to thaw the userspace tasks ourselves.
-	 */
-	if (error)
-		thaw_processes();
-
-	return error;
+	return freeze_processes();
 }
 
 static inline void suspend_thaw_processes(void)
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 9d1277768312..2e223555b764 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -169,33 +169,6 @@ int freeze_processes(void)
 	return error;
 }
 
-/**
- * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
- *
- * On success, returns 0.  On failure, -errno and only the kernel threads are
- * thawed, so as to give a chance to the caller to do additional cleanups
- * (if any) before thawing the userspace tasks. So, it is the responsibility
- * of the caller to thaw the userspace tasks, when the time is right.
- */
-int freeze_kernel_threads(void)
-{
-	int error;
-
-	pr_info("Freezing remaining freezable tasks ... ");
-
-	pm_nosig_freezing = true;
-	error = try_to_freeze_tasks(false);
-	if (!error)
-		pr_cont("done.");
-
-	pr_cont("\n");
-	BUG_ON(in_atomic());
-
-	if (error)
-		thaw_kernel_threads();
-	return error;
-}
-
 void thaw_processes(void)
 {
 	struct task_struct *g, *p;
@@ -234,23 +207,3 @@ void thaw_processes(void)
 	pr_cont("done.\n");
 	trace_suspend_resume(TPS("thaw_processes"), 0, false);
 }
-
-void thaw_kernel_threads(void)
-{
-	struct task_struct *g, *p;
-
-	pm_nosig_freezing = false;
-	pr_info("Restarting kernel threads ... ");
-
-	thaw_workqueues();
-
-	read_lock(&tasklist_lock);
-	for_each_process_thread(g, p) {
-		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
-			__thaw_task(p);
-	}
-	read_unlock(&tasklist_lock);
-
-	schedule();
-	pr_cont("done.\n");
-}
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 22df9f7ff672..ebb2e6a8ddc8 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -277,15 +277,6 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		swsusp_free();
 		memset(&data->handle, 0, sizeof(struct snapshot_handle));
 		data->ready = false;
-		/*
-		 * It is necessary to thaw kernel threads here, because
-		 * SNAPSHOT_CREATE_IMAGE may be invoked directly after
-		 * SNAPSHOT_FREE.  In that case, if kernel threads were not
-		 * thawed, the preallocation of memory carried out by
-		 * hibernation_snapshot() might run into problems (i.e. it
-		 * might fail or even deadlock).
-		 */
-		thaw_kernel_threads();
 		break;
 
 	case SNAPSHOT_PREF_IMAGE_SIZE:
diff --git a/tools/power/pm-graph/analyze_suspend.py b/tools/power/pm-graph/analyze_suspend.py
index 1b60fe203741..545a5e2eafbe 100755
--- a/tools/power/pm-graph/analyze_suspend.py
+++ b/tools/power/pm-graph/analyze_suspend.py
@@ -138,7 +138,6 @@ class SystemValues:
 		'pm_prepare_console': dict(),
 		'pm_notifier_call_chain': dict(),
 		'freeze_processes': dict(),
-		'freeze_kernel_threads': dict(),
 		'pm_restrict_gfp_mask': dict(),
 		'acpi_suspend_begin': dict(),
 		'suspend_console': dict(),
-- 
2.14.0

