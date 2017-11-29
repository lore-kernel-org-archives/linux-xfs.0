Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752908AbdK2XYE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 18:24:04 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 03/11] fs: add frozen sb state helpers
Date: Wed, 29 Nov 2017 15:23:48 -0800
Message-Id: <20171129232356.28296-4-mcgrof@kernel.org>
In-Reply-To: <20171129232356.28296-1-mcgrof@kernel.org>
References: <20171129232356.28296-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

The question of whether or not a superblock is frozen needs to be
augmented in the future to account for differences between a user
initiated freeze and a kernel initiated freeze done automatically
on behalf of the kernel.

Provide helpers so that these can be used instead so that we don't
have to expand checks later in these same call sites as we expand
the definition of a frozen superblock.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/ext4/ext4_jbd2.c |  2 +-
 fs/super.c          |  4 ++--
 fs/xfs/xfs_trans.c  |  2 +-
 include/linux/fs.h  | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 2d593201cf7a..090b8cd4551a 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -50,7 +50,7 @@ static int ext4_journal_check_start(struct super_block *sb)
 
 	if (sb_rdonly(sb))
 		return -EROFS;
-	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
+	WARN_ON(sb_is_frozen(sb));
 	journal = EXT4_SB(sb)->s_journal;
 	/*
 	 * Special case here: if the journal has aborted behind our
diff --git a/fs/super.c b/fs/super.c
index cecc279beecd..e8f5a7139b8f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1392,7 +1392,7 @@ static int freeze_locked_super(struct super_block *sb)
 {
 	int ret;
 
-	if (sb->s_writers.frozen != SB_UNFROZEN)
+	if (!sb_is_unfrozen(sb))
 		return -EBUSY;
 
 	if (!(sb->s_flags & SB_BORN))
@@ -1498,7 +1498,7 @@ static int thaw_locked_super(struct super_block *sb)
 {
 	int error;
 
-	if (sb->s_writers.frozen != SB_FREEZE_COMPLETE)
+	if (!sb_is_frozen(sb))
 		return -EINVAL;
 
 	if (sb_rdonly(sb)) {
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a87f657f59c9..b1180c26d902 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -241,7 +241,7 @@ xfs_trans_alloc(
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
 
-	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
+	WARN_ON(sb_is_frozen(mp->m_super));
 	atomic_inc(&mp->m_active_trans);
 
 	tp = kmem_zone_zalloc(xfs_trans_zone,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 511fbaabf624..1e10239c1d3b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1589,6 +1589,39 @@ static inline void sb_start_intwrite(struct super_block *sb)
 	__sb_start_write(sb, SB_FREEZE_FS, true);
 }
 
+/**
+ * sb_is_frozen_by_user - is superblock frozen by a user call
+ * @sb: the super to check
+ *
+ * Returns true if the super freeze was initiated by userspace, for instance,
+ * an ioctl call.
+ */
+static inline bool sb_is_frozen_by_user(struct super_block *sb)
+{
+	return sb->s_writers.frozen == SB_FREEZE_COMPLETE;
+}
+
+/**
+ * sb_is_frozen - is superblock frozen
+ * @sb: the super to check
+ *
+ * Returns true if the super is frozen.
+ */
+static inline bool sb_is_frozen(struct super_block *sb)
+{
+	return sb_is_frozen_by_user(sb);
+}
+
+/**
+ * sb_is_unfrozen - is superblock unfrozen
+ * @sb: the super to check
+ *
+ * Returns true if the super is unfrozen.
+ */
+static inline bool sb_is_unfrozen(struct super_block *sb)
+{
+	return sb->s_writers.frozen == SB_UNFROZEN;
+}
 
 extern bool inode_owner_or_capable(const struct inode *inode);
 
-- 
2.15.0

