Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752838AbdK2XYD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:03 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 02/11] fs: provide unlocked helper thaw_super()
Date: Wed, 29 Nov 2017 15:23:47 -0800
Message-Id: <20171129232356.28296-3-mcgrof@kernel.org>
In-Reply-To: <20171129232356.28296-1-mcgrof@kernel.org>
References: <20171129232356.28296-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

thaw_super() hold a write lock, however we wish to also enable
callers which already hold the write lock. To do this provide a helper
and make thaw_super() use it. This way, all that thaw_super() does
now is lock handling and active count management.

This change has no functional changes.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/super.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index a7650ff22f0e..cecc279beecd 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1493,21 +1493,13 @@ int freeze_super(struct super_block *sb)
 }
 EXPORT_SYMBOL(freeze_super);
 
-/**
- * thaw_super -- unlock filesystem
- * @sb: the super to thaw
- *
- * Unlocks the filesystem and marks it writeable again after freeze_super().
- */
-int thaw_super(struct super_block *sb)
+/* Caller takes lock and handles active count */
+static int thaw_locked_super(struct super_block *sb)
 {
 	int error;
 
-	down_write(&sb->s_umount);
-	if (sb->s_writers.frozen != SB_FREEZE_COMPLETE) {
-		up_write(&sb->s_umount);
+	if (sb->s_writers.frozen != SB_FREEZE_COMPLETE)
 		return -EINVAL;
-	}
 
 	if (sb_rdonly(sb)) {
 		sb->s_writers.frozen = SB_UNFROZEN;
@@ -1522,7 +1514,6 @@ int thaw_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem thaw failed\n");
 			lockdep_sb_freeze_release(sb);
-			up_write(&sb->s_umount);
 			return error;
 		}
 	}
@@ -1531,7 +1522,29 @@ int thaw_super(struct super_block *sb)
 	sb_freeze_unlock(sb);
 out:
 	wake_up(&sb->s_writers.wait_unfrozen);
-	deactivate_locked_super(sb);
 	return 0;
 }
+
+/**
+ * thaw_super -- unlock filesystem
+ * @sb: the super to thaw
+ *
+ * Unlocks the filesystem and marks it writeable again after freeze_super().
+ */
+int thaw_super(struct super_block *sb)
+{
+	int error;
+
+	down_write(&sb->s_umount);
+	error = thaw_locked_super(sb);
+	if (error) {
+		up_write(&sb->s_umount);
+		goto out;
+	}
+
+	deactivate_locked_super(sb);
+
+out:
+	return error;
+}
 EXPORT_SYMBOL(thaw_super);
-- 
2.15.0

