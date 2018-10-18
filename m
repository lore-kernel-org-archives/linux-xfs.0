Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727633AbeJRVSS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Oct 2018 17:18:18 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] vfs: Provide function to grab superblock reference
Date: Thu, 18 Oct 2018 15:17:08 +0200
Message-Id: <20181018131709.11976-2-jack@suse.cz>
In-Reply-To: <20181018131709.11976-1-jack@suse.cz>
References: <20181018131709.11976-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

Provide function to hold superblock reference when we are sure the
superblock is active. This function will get used by code reading
/proc/mounts and friends.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/internal.h |  1 +
 fs/super.c    | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/fs/internal.h b/fs/internal.h
index d410186bc369..608f4f276ba5 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -104,6 +104,7 @@ extern bool trylock_super(struct super_block *sb);
 extern struct dentry *mount_fs(struct file_system_type *,
 			       int, const char *, void *);
 extern struct super_block *user_get_super(dev_t);
+extern void hold_sb(struct super_block *sb);
 
 /*
  * open.c
diff --git a/fs/super.c b/fs/super.c
index f3a8c008e164..f60a07f794cc 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -775,6 +775,22 @@ struct super_block *get_super_exclusive_thawed(struct block_device *bdev)
 }
 EXPORT_SYMBOL(get_super_exclusive_thawed);
 
+/**
+ *	hold_sb - get superblock reference for active superblock
+ *	@sb: superblock to get reference for
+ *
+ *	Get reference to superblock. The caller must make sure the superblock
+ *	is currently active by other means (e.g. holding an active reference
+ * 	itself or holding namespace_sem preventing unmount).
+ */
+void hold_sb(struct super_block *sb)
+{
+	spin_lock(&sb_lock);
+	WARN_ON_ONCE(!atomic_read(&sb->s_active));
+	sb->s_count++;
+	spin_unlock(&sb_lock);
+}
+
 /**
  * get_active_super - get an active reference to the superblock of a device
  * @bdev: device to get the superblock for
-- 
2.16.4
