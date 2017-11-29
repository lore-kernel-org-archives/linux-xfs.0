Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752815AbdK2XYC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:02 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 01/11] fs: provide unlocked helper for freeze_super()
Date: Wed, 29 Nov 2017 15:23:46 -0800
Message-Id: <20171129232356.28296-2-mcgrof@kernel.org>
In-Reply-To: <20171129232356.28296-1-mcgrof@kernel.org>
References: <20171129232356.28296-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

freeze_super() holds a write lock, however we wish to also enable
callers which already hold the write lock. To do this provide a helper
and make freeze_super() use it. This way, all that freeze_super() does
now is lock handling and active count management.

This change has no functional changes.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/super.c | 100 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 55 insertions(+), 45 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index d4e33e8f1e6f..a7650ff22f0e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1387,59 +1387,20 @@ static void sb_freeze_unlock(struct super_block *sb)
 		percpu_up_write(sb->s_writers.rw_sem + level);
 }
 
-/**
- * freeze_super - lock the filesystem and force it into a consistent state
- * @sb: the super to lock
- *
- * Syncs the super to make sure the filesystem is consistent and calls the fs's
- * freeze_fs.  Subsequent calls to this without first thawing the fs will return
- * -EBUSY.
- *
- * During this function, sb->s_writers.frozen goes through these values:
- *
- * SB_UNFROZEN: File system is normal, all writes progress as usual.
- *
- * SB_FREEZE_WRITE: The file system is in the process of being frozen.  New
- * writes should be blocked, though page faults are still allowed. We wait for
- * all writes to complete and then proceed to the next stage.
- *
- * SB_FREEZE_PAGEFAULT: Freezing continues. Now also page faults are blocked
- * but internal fs threads can still modify the filesystem (although they
- * should not dirty new pages or inodes), writeback can run etc. After waiting
- * for all running page faults we sync the filesystem which will clean all
- * dirty pages and inodes (no new dirty pages or inodes can be created when
- * sync is running).
- *
- * SB_FREEZE_FS: The file system is frozen. Now all internal sources of fs
- * modification are blocked (e.g. XFS preallocation truncation on inode
- * reclaim). This is usually implemented by blocking new transactions for
- * filesystems that have them and need this additional guard. After all
- * internal writers are finished we call ->freeze_fs() to finish filesystem
- * freezing. Then we transition to SB_FREEZE_COMPLETE state. This state is
- * mostly auxiliary for filesystems to verify they do not modify frozen fs.
- *
- * sb->s_writers.frozen is protected by sb->s_umount.
- */
-int freeze_super(struct super_block *sb)
+/* Caller takes lock and handles active count */
+static int freeze_locked_super(struct super_block *sb)
 {
 	int ret;
 
-	atomic_inc(&sb->s_active);
-	down_write(&sb->s_umount);
-	if (sb->s_writers.frozen != SB_UNFROZEN) {
-		deactivate_locked_super(sb);
+	if (sb->s_writers.frozen != SB_UNFROZEN)
 		return -EBUSY;
-	}
 
-	if (!(sb->s_flags & SB_BORN)) {
-		up_write(&sb->s_umount);
+	if (!(sb->s_flags & SB_BORN))
 		return 0;	/* sic - it's "nothing to do" */
-	}
 
 	if (sb_rdonly(sb)) {
 		/* Nothing to do really... */
 		sb->s_writers.frozen = SB_FREEZE_COMPLETE;
-		up_write(&sb->s_umount);
 		return 0;
 	}
 
@@ -1468,7 +1429,6 @@ int freeze_super(struct super_block *sb)
 			sb->s_writers.frozen = SB_UNFROZEN;
 			sb_freeze_unlock(sb);
 			wake_up(&sb->s_writers.wait_unfrozen);
-			deactivate_locked_super(sb);
 			return ret;
 		}
 	}
@@ -1478,9 +1438,59 @@ int freeze_super(struct super_block *sb)
 	 */
 	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
 	lockdep_sb_freeze_release(sb);
-	up_write(&sb->s_umount);
 	return 0;
 }
+
+/**
+ * freeze_super - lock the filesystem and force it into a consistent state
+ * @sb: the super to lock
+ *
+ * Syncs the super to make sure the filesystem is consistent and calls the fs's
+ * freeze_fs.  Subsequent calls to this without first thawing the fs will return
+ * -EBUSY.
+ *
+ * During this function, sb->s_writers.frozen goes through these values:
+ *
+ * SB_UNFROZEN: File system is normal, all writes progress as usual.
+ *
+ * SB_FREEZE_WRITE: The file system is in the process of being frozen.  New
+ * writes should be blocked, though page faults are still allowed. We wait for
+ * all writes to complete and then proceed to the next stage.
+ *
+ * SB_FREEZE_PAGEFAULT: Freezing continues. Now also page faults are blocked
+ * but internal fs threads can still modify the filesystem (although they
+ * should not dirty new pages or inodes), writeback can run etc. After waiting
+ * for all running page faults we sync the filesystem which will clean all
+ * dirty pages and inodes (no new dirty pages or inodes can be created when
+ * sync is running).
+ *
+ * SB_FREEZE_FS: The file system is frozen. Now all internal sources of fs
+ * modification are blocked (e.g. XFS preallocation truncation on inode
+ * reclaim). This is usually implemented by blocking new transactions for
+ * filesystems that have them and need this additional guard. After all
+ * internal writers are finished we call ->freeze_fs() to finish filesystem
+ * freezing. Then we transition to SB_FREEZE_COMPLETE state. This state is
+ * mostly auxiliary for filesystems to verify they do not modify frozen fs.
+ *
+ * sb->s_writers.frozen is protected by sb->s_umount.
+ */
+int freeze_super(struct super_block *sb)
+{
+	int error;
+
+	atomic_inc(&sb->s_active);
+
+	down_write(&sb->s_umount);
+	error = freeze_locked_super(sb);
+	if (error) {
+		deactivate_locked_super(sb);
+		goto out;
+	}
+	up_write(&sb->s_umount);
+
+out:
+	return error;
+}
 EXPORT_SYMBOL(freeze_super);
 
 /**
-- 
2.15.0

