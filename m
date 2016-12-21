Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935920AbcLURD7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:59 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 11/30] fs: new API for handling i_version
Date: Wed, 21 Dec 2016 12:03:28 -0500
Message-Id: <1482339827-7882-12-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

We already have inode_inc_iversion. Add inode_set_iversion,
inode_get_iversion, inode_cmp_iversion and inode_iversion_need_inc.

These should encompass how i_version is currently accessed and
manipulated so that we can later change the implementation.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 104 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2ba074328894..075c915fe2b1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1962,18 +1962,117 @@ static inline void inode_dec_link_count(struct inode *inode)
 }
 
 /**
+ * inode_set_iversion - set i_version to a particular value
+ * @inode: inode to set
+ * @new: new i_version value to set
+ *
+ * Set the inode's i_version. Should generally be called when initializing
+ * a new inode.
+ */
+static inline void
+inode_set_iversion(struct inode *inode, const u64 new)
+{
+	inode->i_version = new;
+}
+
+/**
+ * inode_inc_iversion_locked - increment i_version while protected
+ * @inode: inode to be updated
+ *
+ * Increment the i_version field in the inode. This version is usable
+ * when there is some other sort of lock in play that would prevent
+ * concurrent accessors.
+ */
+static inline void
+inode_inc_iversion_locked(struct inode *inode)
+{
+	inode->i_version++;
+}
+
+/**
+ * inode_set_iversion_read - set i_version to a particular value and flag
+ * 			     set flag to indicate that it has been viewed
+ * @inode: inode to set
+ * @new: new i_version value to set
+ *
+ * Set the inode's i_version, and flag the inode as if it has been viewed.
+ * Should generally be called when initializinga new inode in memory from
+ * from disk.
+ */
+static inline void
+inode_set_iversion_read(struct inode *inode, const u64 new)
+{
+	inode_set_iversion(inode, new);
+}
+
+/**
  * inode_inc_iversion - increments i_version
  * @inode: inode that need to be updated
  *
  * Every time the inode is modified, the i_version field will be incremented.
- * The filesystem has to be mounted with i_version flag
+ * The filesystem has to be mounted with MS_I_VERSION flag.
+ */
+static inline bool
+inode_inc_iversion(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	inode_inc_iversion_locked(inode);
+	spin_unlock(&inode->i_lock);
+	return true;
+}
+
+/**
+ * inode_get_iversion_raw - read i_version without "perturbing" it
+ * @inode: inode from which i_version should be read
+ *
+ * Read the inode i_version counter for an inode without registering it as a
+ * read. Should typically be used by local filesystems that need to store an
+ * i_version on disk.
+ */
+static inline u64
+inode_get_iversion_raw(const struct inode *inode)
+{
+	return inode->i_version;
+}
+
+/**
+ * inode_get_iversion - read i_version for later use
+ * @inode: inode from which i_version should be read
+ *
+ * Read the inode i_version counter. This should be used by callers that wish
+ * to store the returned i_version for later comparison.
+ */
+static inline u64
+inode_get_iversion(const struct inode *inode)
+{
+	return inode_get_iversion_raw(inode);
+}
+
+/**
+ * inode_cmp_iversion - check whether the i_version counter has changed
+ * @inode: inode to check
+ * @old: old value to check against its i_version
+ *
+ * Compare an i_version counter with a previous one. Returns 0 if they are
+ * the same or non-zero if they are different.
  */
+static inline s64
+inode_cmp_iversion(const struct inode *inode, const u64 old)
+{
+	return (s64)inode->i_version - (s64)old;
+}
 
-static inline void inode_inc_iversion(struct inode *inode)
+/**
+ * inode_iversion_need_inc - is the i_version in need of being incremented?
+ * @inode: inode to check
+ *
+ * Returns whether the inode->i_version counter needs incrementing on the next
+ * change.
+ */
+static inline bool
+inode_iversion_need_inc(struct inode *inode)
 {
-       spin_lock(&inode->i_lock);
-       inode->i_version++;
-       spin_unlock(&inode->i_lock);
+	return true;
 }
 
 enum file_time_flags {
-- 
2.7.4

