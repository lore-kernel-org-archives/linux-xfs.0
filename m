Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965012AbcLUREV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:21 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 29/30] fs: track whether the i_version has been queried with an i_state flag
Date: Wed, 21 Dec 2016 12:03:46 -0500
Message-Id: <1482339827-7882-30-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

NFSv4 has some pretty relaxed rules for the i_version counter that
we can exploit for our own (performance) gain. The rules basically
boil down to:

1) it must steadily increase so that a client can discard change
   attributes that are older than ones it has already seen.

2) the value must be different from the last time we checked it if
   there was a data or metadata change.

This last bit is important, as we don't necessarily need to bump the
counter when no one is querying for it. On a write-intensive workload
this can add up to the metadata being written a lot less.

Add a new I_VERS_BUMP i_state flag that we can use to track when the
i_version has been queried. When it's queried we take the i_lock,
get the value and set the flag and then drop the lock and return it.

When we would go to bump it, we check the flag and only bump the
the counter if it's set and we weren't requested to forcibly bump it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h | 66 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 20 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 75323e7b6954..917557faa8e8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1909,6 +1909,9 @@ static inline bool HAS_UNMAPPED_ID(struct inode *inode)
  *			wb stat updates to grab mapping->tree_lock.  See
  *			inode_switch_wb_work_fn() for details.
  *
+ * I_VERS_BUMP		inode->i_version counter must be bumped on the next
+ * 			change. See the inode_*_iversion functions.
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
 #define I_DIRTY_SYNC		(1 << 0)
@@ -1929,6 +1932,7 @@ static inline bool HAS_UNMAPPED_ID(struct inode *inode)
 #define __I_DIRTY_TIME_EXPIRED	12
 #define I_DIRTY_TIME_EXPIRED	(1 << __I_DIRTY_TIME_EXPIRED)
 #define I_WB_SWITCH		(1 << 13)
+#define I_VERS_BUMP		(1 << 14)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
@@ -1976,20 +1980,6 @@ inode_set_iversion(struct inode *inode, const u64 new)
 }
 
 /**
- * inode_inc_iversion_locked - increment i_version while protected
- * @inode: inode to be updated
- *
- * Increment the i_version field in the inode. This version is usable
- * when there is some other sort of lock in play that would prevent
- * concurrent accessors.
- */
-static inline void
-inode_inc_iversion_locked(struct inode *inode)
-{
-	inode->i_version++;
-}
-
-/**
  * inode_set_iversion_read - set i_version to a particular value and flag
  * 			     set flag to indicate that it has been viewed
  * @inode: inode to set
@@ -2002,7 +1992,10 @@ inode_inc_iversion_locked(struct inode *inode)
 static inline void
 inode_set_iversion_read(struct inode *inode, const u64 new)
 {
+	spin_lock(&inode->i_lock);
 	inode_set_iversion(inode, new);
+	inode->i_state |= I_VERS_BUMP;
+	spin_unlock(&inode->i_lock);
 }
 
 /**
@@ -2011,14 +2004,36 @@ inode_set_iversion_read(struct inode *inode, const u64 new)
  *
  * Every time the inode is modified, the i_version field will be incremented.
  * The filesystem has to be mounted with MS_I_VERSION flag.
+ *
+ * Returns true if counter was bumped, and false if it wasn't necessary.
  */
 static inline bool
 inode_inc_iversion(struct inode *inode, bool force)
 {
+	bool ret = false;
+
 	spin_lock(&inode->i_lock);
-	inode_inc_iversion_locked(inode);
+	if (force || (inode->i_state & I_VERS_BUMP)) {
+		inode->i_version++;
+		inode->i_state &= ~I_VERS_BUMP;
+		ret = true;
+	}
 	spin_unlock(&inode->i_lock);
-	return true;
+	return ret;
+}
+
+/**
+ * inode_inc_iversion_locked - increment i_version while protected
+ * @inode: inode to be updated
+ *
+ * Increment the i_version field in the inode. This version is usable
+ * when there is some other sort of lock in play that would prevent
+ * concurrent increments (typically inode->i_rwsem for write).
+ */
+static inline void
+inode_inc_iversion_locked(struct inode *inode)
+{
+	inode_inc_iversion(inode, true);
 }
 
 /**
@@ -2043,9 +2058,15 @@ inode_get_iversion_raw(const struct inode *inode)
  * to store the returned i_version for later comparison.
  */
 static inline u64
-inode_get_iversion(const struct inode *inode)
+inode_get_iversion(struct inode *inode)
 {
-	return inode_get_iversion_raw(inode);
+	u64 ret;
+
+	spin_lock(&inode->i_lock);
+	inode->i_state |= I_VERS_BUMP;
+	ret = inode->i_version;
+	spin_unlock(&inode->i_lock);
+	return ret;
 }
 
 /**
@@ -2054,7 +2075,7 @@ inode_get_iversion(const struct inode *inode)
  * @old: old value to check against its i_version
  *
  * Compare an i_version counter with a previous one. Returns 0 if they are
- * the same or non-zero if they are different.
+ * the same, greater than zero if the inode's is "later" than the old value.
  */
 static inline s64
 inode_cmp_iversion(const struct inode *inode, const u64 old)
@@ -2072,7 +2093,12 @@ inode_cmp_iversion(const struct inode *inode, const u64 old)
 static inline bool
 inode_iversion_need_inc(struct inode *inode)
 {
-	return true;
+	bool ret;
+
+	spin_lock(&inode->i_lock);
+	ret = inode->i_state & I_VERS_BUMP;
+	spin_unlock(&inode->i_lock);
+	return ret;
 }
 
 enum file_time_flags {
-- 
2.7.4

