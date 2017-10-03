Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbdJCSxV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 14:53:21 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 2/5] fs: freeze on suspend and thaw on resume
Date: Tue,  3 Oct 2017 11:53:10 -0700
Message-Id: <20171003185313.1017-3-mcgrof@kernel.org>
In-Reply-To: <20171003185313.1017-1-mcgrof@kernel.org>
References: <20171003185313.1017-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

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
 fs/super.c             | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h     | 13 +++++++++
 kernel/power/process.c | 14 ++++++++-
 3 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index d45e92d9a38f..ce8da8b187b1 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1572,3 +1572,82 @@ int thaw_super(struct super_block *sb)
 	return 0;
 }
 EXPORT_SYMBOL(thaw_super);
+
+#ifdef CONFIG_PM_SLEEP
+static bool super_allows_freeze(struct super_block *sb)
+{
+	return !!(sb->s_type->fs_flags & FS_FREEZE_ON_SUSPEND);
+}
+
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
+	if (!super_allows_freeze(sb))
+		return false;
+
+	return true;
+}
+
+int fs_suspend_freeze_sb(struct super_block *sb, void *priv)
+{
+	int error = 0;
+
+	spin_lock(&sb_lock);
+	if (!super_should_freeze(sb))
+		goto out;
+
+	up_read(&sb->s_umount);
+	pr_info("%s (%s): freezing\n", sb->s_type->name, sb->s_id);
+	error = freeze_super(sb);
+	down_read(&sb->s_umount);
+out:
+	if (error && error != -EBUSY)
+		pr_notice("%s (%s): Unable to freeze, error=%d",
+			  sb->s_type->name, sb->s_id, error);
+	spin_unlock(&sb_lock);
+	return error;
+}
+
+int fs_suspend_freeze(void)
+{
+	return iterate_supers_reverse(fs_suspend_freeze_sb, NULL);
+}
+
+void fs_resume_unfreeze_sb(struct super_block *sb, void *priv)
+{
+	int error = 0;
+
+	spin_lock(&sb_lock);
+	if (!super_should_freeze(sb))
+		goto out;
+
+	up_read(&sb->s_umount);
+	pr_info("%s (%s): thawing\n", sb->s_type->name, sb->s_id);
+	error = thaw_super(sb);
+	down_read(&sb->s_umount);
+out:
+	if (error && error != -EBUSY)
+		pr_notice("%s (%s): Unable to unfreeze, error=%d",
+			  sb->s_type->name, sb->s_id, error);
+	spin_unlock(&sb_lock);
+}
+
+void fs_resume_unfreeze(void)
+{
+	iterate_supers(fs_resume_unfreeze_sb, NULL);
+}
+
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cd084792cf39..7754230d6afc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2071,6 +2071,7 @@ struct file_system_type {
 #define FS_BINARY_MOUNTDATA	2
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
+#define FS_FREEZE_ON_SUSPEND   16      /* should filesystem freeze on suspend? */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
@@ -2172,6 +2173,18 @@ extern int fd_statfs(int, struct kstatfs *);
 extern int vfs_ustat(dev_t, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
+#ifdef CONFIG_PM_SLEEP
+int fs_suspend_freeze(void);
+void fs_resume_unfreeze(void);
+#else
+static inline int fs_suspend_freeze(void)
+{
+	return 0;
+}
+static inline void fs_resume_unfreeze(void)
+{
+}
+#endif
 extern bool our_mnt(struct vfsmount *mnt);
 extern __printf(2, 3)
 int super_setup_bdi_name(struct super_block *sb, char *fmt, ...);
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 50f25cb370c6..9d1277768312 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -144,6 +144,15 @@ int freeze_processes(void)
 	pr_cont("\n");
 	BUG_ON(in_atomic());
 
+	pr_info("Freezing filesystems ... ");
+	error = fs_suspend_freeze();
+	if (error) {
+		pr_cont("failed\n");
+		fs_resume_unfreeze();
+		return error;
+	}
+	pr_cont("done.\n");
+
 	/*
 	 * Now that the whole userspace is frozen we need to disbale
 	 * the OOM killer to disallow any further interference with
@@ -153,8 +162,10 @@ int freeze_processes(void)
 	if (!error && !oom_killer_disable(msecs_to_jiffies(freeze_timeout_msecs)))
 		error = -EBUSY;
 
-	if (error)
+	if (error) {
 		thaw_processes();
+		fs_resume_unfreeze();
+	}
 	return error;
 }
 
@@ -197,6 +208,7 @@ void thaw_processes(void)
 	pm_nosig_freezing = false;
 
 	oom_killer_enable();
+	fs_resume_unfreeze();
 
 	pr_info("Restarting tasks ... ");
 
-- 
2.14.0

