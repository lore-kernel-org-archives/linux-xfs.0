Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751266AbdJCSxX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 14:53:23 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 4/5] ext4: add fs freezing support on suspend/hibernation
Date: Tue,  3 Oct 2017 11:53:12 -0700
Message-Id: <20171003185313.1017-5-mcgrof@kernel.org>
In-Reply-To: <20171003185313.1017-1-mcgrof@kernel.org>
References: <20171003185313.1017-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

This also removes the superflous freezer calls as they are no longer
needed. We need to avoid sync call on thaw as otherwise we end up with
a stall on bio_submit().

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/ext4/super.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3cc5635d00cc..03d3bbd27dae 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -119,7 +119,8 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV |
+			  FS_FREEZE_ON_SUSPEND,
 };
 MODULE_ALIAS_FS("ext2");
 MODULE_ALIAS("ext2");
@@ -134,7 +135,8 @@ static struct file_system_type ext3_fs_type = {
 	.name		= "ext3",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV |
+			  FS_FREEZE_ON_SUSPEND,
 };
 MODULE_ALIAS_FS("ext3");
 MODULE_ALIAS("ext3");
@@ -2979,8 +2981,6 @@ static int ext4_lazyinit_thread(void *arg)
 		}
 		mutex_unlock(&eli->li_list_mtx);
 
-		try_to_freeze();
-
 		cur = jiffies;
 		if ((time_after_eq(cur, next_wakeup)) ||
 		    (MAX_JIFFY_OFFSET == next_wakeup)) {
@@ -4926,7 +4926,7 @@ static int ext4_unfreeze(struct super_block *sb)
 		ext4_set_feature_journal_needs_recovery(sb);
 	}
 
-	ext4_commit_super(sb, 1);
+	ext4_commit_super(sb, 0);
 	return 0;
 }
 
@@ -5771,7 +5771,8 @@ static struct file_system_type ext4_fs_type = {
 	.name		= "ext4",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV |
+			  FS_FREEZE_ON_SUSPEND,
 };
 MODULE_ALIAS_FS("ext4");
 
-- 
2.14.0

