Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752787AbdK2XYF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:05 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 04/11] fs: distinguish between user initiated freeze and kernel initiated freeze
Date: Wed, 29 Nov 2017 15:23:49 -0800
Message-Id: <20171129232356.28296-5-mcgrof@kernel.org>
In-Reply-To: <20171129232356.28296-1-mcgrof@kernel.org>
References: <20171129232356.28296-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Userspace can initiate a freeze call using ioctls. If the kernel decides
to freeze a filesystem later it must be able to distinguish if userspace
had initiated the freeze, so that it does not unfreeze it later
automatically on resume.

Likewise if the kernel is initiating a freeze on its own it should *not*
fail to freeze a filesystem if a user had already frozen it on our behalf.
This same concept applies to thawing, even if its not possible for
userspace to beat the kernel in thawing a filesystem. This logic however
has never applied to userspace freezing and thawing, two consecutive
userspace freeze calls will results in only the first one succeeding, so
we must retain the same behaviour in userspace.

This doesn't implement yet kernel initiated filesystem freeze calls,
this will be done in subsequent calls. This change should introduce
no functional changes, it just extends the definitions a frozen
filesystem to account for future kernel initiated filesystem freeze.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/super.c         | 19 ++++++++++++++-----
 include/linux/fs.h | 17 +++++++++++++++--
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index e8f5a7139b8f..a63513d187e8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1388,10 +1388,13 @@ static void sb_freeze_unlock(struct super_block *sb)
 }
 
 /* Caller takes lock and handles active count */
-static int freeze_locked_super(struct super_block *sb)
+static int freeze_locked_super(struct super_block *sb, bool usercall)
 {
 	int ret;
 
+	if (!usercall && sb_is_frozen(sb))
+		return 0;
+
 	if (!sb_is_unfrozen(sb))
 		return -EBUSY;
 
@@ -1436,7 +1439,10 @@ static int freeze_locked_super(struct super_block *sb)
 	 * For debugging purposes so that fs can warn if it sees write activity
 	 * when frozen is set to SB_FREEZE_COMPLETE, and for thaw_super().
 	 */
-	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
+	if (usercall)
+		sb->s_writers.frozen = SB_FREEZE_COMPLETE;
+	else
+		sb->s_writers.frozen = SB_FREEZE_COMPLETE_AUTO;
 	lockdep_sb_freeze_release(sb);
 	return 0;
 }
@@ -1481,7 +1487,7 @@ int freeze_super(struct super_block *sb)
 	atomic_inc(&sb->s_active);
 
 	down_write(&sb->s_umount);
-	error = freeze_locked_super(sb);
+	error = freeze_locked_super(sb, true);
 	if (error) {
 		deactivate_locked_super(sb);
 		goto out;
@@ -1494,10 +1500,13 @@ int freeze_super(struct super_block *sb)
 EXPORT_SYMBOL(freeze_super);
 
 /* Caller takes lock and handles active count */
-static int thaw_locked_super(struct super_block *sb)
+static int thaw_locked_super(struct super_block *sb, bool usercall)
 {
 	int error;
 
+	if (!usercall && sb_is_unfrozen(sb))
+		return 0;
+
 	if (!sb_is_frozen(sb))
 		return -EINVAL;
 
@@ -1536,7 +1545,7 @@ int thaw_super(struct super_block *sb)
 	int error;
 
 	down_write(&sb->s_umount);
-	error = thaw_locked_super(sb);
+	error = thaw_locked_super(sb, true);
 	if (error) {
 		up_write(&sb->s_umount);
 		goto out;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1e10239c1d3b..107725b20fad 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1324,9 +1324,10 @@ enum {
 	SB_FREEZE_FS = 3,		/* For internal FS use (e.g. to stop
 					 * internal threads if needed) */
 	SB_FREEZE_COMPLETE = 4,		/* ->freeze_fs finished successfully */
+	SB_FREEZE_COMPLETE_AUTO = 5,	/* same but initiated automatically */
 };
 
-#define SB_FREEZE_LEVELS (SB_FREEZE_COMPLETE - 1)
+#define SB_FREEZE_LEVELS (SB_FREEZE_COMPLETE_AUTO - 1)
 
 struct sb_writers {
 	int				frozen;		/* Is sb frozen? */
@@ -1601,6 +1602,18 @@ static inline bool sb_is_frozen_by_user(struct super_block *sb)
 	return sb->s_writers.frozen == SB_FREEZE_COMPLETE;
 }
 
+/**
+ * sb_is_frozen_by_kernel - is superblock frozen by the kernel automatically
+ * @sb: the super to check
+ *
+ * Returns true if the super freeze was initiated by the kernel, automatically,
+ * for instance during system sleep or hibernation.
+ */
+static inline bool sb_is_frozen_by_kernel(struct super_block *sb)
+{
+	return sb->s_writers.frozen == SB_FREEZE_COMPLETE_AUTO;
+}
+
 /**
  * sb_is_frozen - is superblock frozen
  * @sb: the super to check
@@ -1609,7 +1622,7 @@ static inline bool sb_is_frozen_by_user(struct super_block *sb)
  */
 static inline bool sb_is_frozen(struct super_block *sb)
 {
-	return sb_is_frozen_by_user(sb);
+	return sb_is_frozen_by_user(sb) || sb_is_frozen_by_kernel(sb);
 }
 
 /**
-- 
2.15.0

