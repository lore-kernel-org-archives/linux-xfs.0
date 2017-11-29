Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752815AbdK2XYI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:08 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 06/11] fs: freeze on suspend and thaw on resume
Date: Wed, 29 Nov 2017 15:23:51 -0800
Message-Id: <20171129232356.28296-7-mcgrof@kernel.org>
In-Reply-To: <20171129232356.28296-1-mcgrof@kernel.org>
References: <20171129232356.28296-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

This uses the existing filesystem freeze and thaw callbacks to
freeze each filesystem on suspend/hibernation and thaw upon resume.

This is needed so that we properly really stop IO in flight without
races after userspace has been frozen. Without this we rely on
kthread freezing and its semantics are loose and error prone.
For instance, even though a kthread may use try_to_freeze() and end
up being frozen we have no way of being sure that everything that
has been spawned asynchronously from it (such as timers) have also
been stopped as well.

A long term advantage of also adding filesystem freeze / thawing
supporting durign suspend / hibernation is that long term we may
be able to eventually drop the kernel's thread freezing completely
as it was originally added to stop disk IO in flight as we hibernate
or suspend.

This also implies that many kthread users exist which have been
adding freezer semantics onto its kthreads without need. These also
will need to be reviewed later.

This is based on prior work originally by Rafael Wysocki and later by
Jiri Kosina.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/super.c             | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h     | 13 ++++++++
 kernel/power/process.c | 15 ++++++++-
 3 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 885711c1d35b..c3a2842e5690 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1648,3 +1648,88 @@ int thaw_super(struct super_block *sb)
 	return error;
 }
 EXPORT_SYMBOL(thaw_super);
+
+#ifdef CONFIG_PM_SLEEP
+static bool super_should_freeze(struct super_block *sb)
+{
+	if (!sb->s_root)
+		return false;
+	if (!(sb->s_flags & MS_BORN))
+		return false;
+	/*
+	 * We don't freeze virtual filesystems, we skip those filesystems with
+	 * no backing device.
+	 */
+	if (sb->s_bdi == &noop_backing_dev_info)
+		return false;
+	/* No need to freeze read-only filesystems */
+	if (sb->s_flags & MS_RDONLY)
+		return false;
+
+	return true;
+}
+
+static int fs_suspend_freeze_sb(struct super_block *sb, void *priv)
+{
+	int error = 0;
+
+	spin_lock(&sb_lock);
+	if (!super_should_freeze(sb))
+		goto out;
+
+	pr_info("%s (%s): freezing\n", sb->s_type->name, sb->s_id);
+
+	spin_unlock(&sb_lock);
+
+	atomic_inc(&sb->s_active);
+	error = freeze_locked_super(sb, false);
+	if (error)
+		atomic_dec(&sb->s_active);
+
+	spin_lock(&sb_lock);
+	if (error && error != -EBUSY)
+		pr_notice("%s (%s): Unable to freeze, error=%d",
+			  sb->s_type->name, sb->s_id, error);
+
+out:
+	spin_unlock(&sb_lock);
+	return error;
+}
+
+int fs_suspend_freeze(void)
+{
+	return iterate_supers_reverse_excl(fs_suspend_freeze_sb, NULL);
+}
+
+static int fs_suspend_thaw_sb(struct super_block *sb, void *priv)
+{
+	int error = 0;
+
+	spin_lock(&sb_lock);
+	if (!super_should_freeze(sb))
+		goto out;
+
+	pr_info("%s (%s): thawing\n", sb->s_type->name, sb->s_id);
+
+	spin_unlock(&sb_lock);
+
+	error = thaw_locked_super(sb, false);
+	if (!error)
+		atomic_dec(&sb->s_active);
+
+	spin_lock(&sb_lock);
+	if (error && error != -EBUSY)
+		pr_notice("%s (%s): Unable to unfreeze, error=%d",
+			  sb->s_type->name, sb->s_id, error);
+
+out:
+	spin_unlock(&sb_lock);
+	return error;
+}
+
+int fs_resume_unfreeze(void)
+{
+	return iterate_supers_excl(fs_suspend_thaw_sb, NULL);
+}
+
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fe90b6542697..dbaa69c3a4cf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2237,6 +2237,19 @@ extern int user_statfs(const char __user *, struct kstatfs *);
 extern int fd_statfs(int, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
+#ifdef CONFIG_PM_SLEEP
+int fs_suspend_freeze(void);
+int fs_resume_unfreeze(void);
+#else
+static inline int fs_suspend_freeze(void)
+{
+	return 0;
+}
+static inline int fs_resume_unfreeze(void)
+{
+	return 0;
+}
+#endif
 extern bool our_mnt(struct vfsmount *mnt);
 extern __printf(2, 3)
 int super_setup_bdi_name(struct super_block *sb, char *fmt, ...);
diff --git a/kernel/power/process.c b/kernel/power/process.c
index c326d7235c5f..7a44f8310968 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -145,6 +145,16 @@ int freeze_processes(void)
 	pr_cont("\n");
 	BUG_ON(in_atomic());
 
+	pr_info("Freezing filesystems ... ");
+	error = fs_suspend_freeze();
+	if (error) {
+		pr_cont("failed\n");
+		fs_resume_unfreeze();
+		thaw_processes();
+		return error;
+	}
+	pr_cont("done.\n");
+
 	/*
 	 * Now that the whole userspace is frozen we need to disbale
 	 * the OOM killer to disallow any further interference with
@@ -154,8 +164,10 @@ int freeze_processes(void)
 	if (!error && !oom_killer_disable(msecs_to_jiffies(freeze_timeout_msecs)))
 		error = -EBUSY;
 
-	if (error)
+	if (error) {
+		fs_resume_unfreeze();
 		thaw_processes();
+	}
 	return error;
 }
 
@@ -198,6 +210,7 @@ void thaw_processes(void)
 	pm_nosig_freezing = false;
 
 	oom_killer_enable();
+	fs_resume_unfreeze();
 
 	pr_info("Restarting tasks ... ");
 
-- 
2.15.0

