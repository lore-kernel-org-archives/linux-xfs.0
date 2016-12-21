Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964946AbcLURER (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:17 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 30/30] fs: convert i_version counter over to an atomic64_t
Date: Wed, 21 Dec 2016 12:03:47 -0500
Message-Id: <1482339827-7882-31-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

The spinlock is only used to serialize callers that want to increment
the counter. We can achieve the same thing with an atomic64_t and
get the i_lock out of this codepath.

Drop the I_VERS_BUMP flag, and instead, borrow the most significant bit
in the counter to use as the flag. With this change, we can stop taking
the i_lock in this codepath, and can use atomics instead to manage the
thing.

On the query side, if the flag is already set, then we just return the
counter value. Otherwise, we set the flag in our in-memory copy and use
cmpxchg to swap it into place if it hasn't changed. If it has, then we
use the value from the cmpxchg as the new "old" value and try again.

When we go to bump the thing, we fetch the value and check the flag bit.
If it's clear then we don't need to do anything if the update isn't
being forced.

If we do need to update, then we clear the flag in our in-memory copy
and bump the counter (handling any overflow into the flag bit by
resetting the counter to zero). We then do a cmpxchg to swap the updated
value into place if it hasn't changed. If it has changed, then we use
the value we got back from cmpxchg to try again.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h | 82 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 34 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 917557faa8e8..401e38d76171 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -621,7 +621,7 @@ struct inode {
 		struct hlist_head	i_dentry;
 		struct rcu_head		i_rcu;
 	};
-	u64			i_version;
+	atomic64_t		i_version;
 	atomic_t		i_count;
 	atomic_t		i_dio_count;
 	atomic_t		i_writecount;
@@ -1909,9 +1909,6 @@ static inline bool HAS_UNMAPPED_ID(struct inode *inode)
  *			wb stat updates to grab mapping->tree_lock.  See
  *			inode_switch_wb_work_fn() for details.
  *
- * I_VERS_BUMP		inode->i_version counter must be bumped on the next
- * 			change. See the inode_*_iversion functions.
- *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
 #define I_DIRTY_SYNC		(1 << 0)
@@ -1932,7 +1929,6 @@ static inline bool HAS_UNMAPPED_ID(struct inode *inode)
 #define __I_DIRTY_TIME_EXPIRED	12
 #define I_DIRTY_TIME_EXPIRED	(1 << __I_DIRTY_TIME_EXPIRED)
 #define I_WB_SWITCH		(1 << 13)
-#define I_VERS_BUMP		(1 << 14)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
@@ -1965,6 +1961,14 @@ static inline void inode_dec_link_count(struct inode *inode)
 	mark_inode_dirty(inode);
 }
 
+/*
+ * We borrow the top bit in the i_version to use as a flag to tell us whether
+ * it has been queried since we last bumped it. If it has, then we must bump
+ * it and set the flag. Note that this means that we have to handle wrapping
+ * manually.
+ */
+#define INODE_I_VERSION_QUERIED		(1ULL<<63)
+
 /**
  * inode_set_iversion - set i_version to a particular value
  * @inode: inode to set
@@ -1976,7 +1980,7 @@ static inline void inode_dec_link_count(struct inode *inode)
 static inline void
 inode_set_iversion(struct inode *inode, const u64 new)
 {
-	inode->i_version = new;
+	atomic64_set(&inode->i_version, new);
 }
 
 /**
@@ -1992,10 +1996,7 @@ inode_set_iversion(struct inode *inode, const u64 new)
 static inline void
 inode_set_iversion_read(struct inode *inode, const u64 new)
 {
-	spin_lock(&inode->i_lock);
-	inode_set_iversion(inode, new);
-	inode->i_state |= I_VERS_BUMP;
-	spin_unlock(&inode->i_lock);
+	inode_set_iversion(inode, new | INODE_I_VERSION_QUERIED);
 }
 
 /**
@@ -2010,16 +2011,26 @@ inode_set_iversion_read(struct inode *inode, const u64 new)
 static inline bool
 inode_inc_iversion(struct inode *inode, bool force)
 {
-	bool ret = false;
+	u64 cur, old, new;
+
+	cur = (u64)atomic64_read(&inode->i_version);
+	for (;;) {
+		/* If flag is clear then we needn't do anything */
+		if (!force && !(cur & INODE_I_VERSION_QUERIED))
+			return false;
+
+		new = (cur & ~INODE_I_VERSION_QUERIED) + 1;
+
+		/* Did we overflow into flag bit? Reset to 0 if so. */
+		if (unlikely(new == INODE_I_VERSION_QUERIED))
+			new = 0;
 
-	spin_lock(&inode->i_lock);
-	if (force || (inode->i_state & I_VERS_BUMP)) {
-		inode->i_version++;
-		inode->i_state &= ~I_VERS_BUMP;
-		ret = true;
+		old = atomic64_cmpxchg(&inode->i_version, cur, new);
+		if (likely(old == cur))
+			break;
+		cur = old;
 	}
-	spin_unlock(&inode->i_lock);
-	return ret;
+	return true;
 }
 
 /**
@@ -2027,8 +2038,9 @@ inode_inc_iversion(struct inode *inode, bool force)
  * @inode: inode to be updated
  *
  * Increment the i_version field in the inode. This version is usable
- * when there is some other sort of lock in play that would prevent
- * concurrent increments (typically inode->i_rwsem for write).
+ * when there is some other sort of lock in play (e.g. i_rwsem for write)
+ * that would prevent concurrent incrementors, and is typically used on
+ * directories or other non-regular files.
  */
 static inline void
 inode_inc_iversion_locked(struct inode *inode)
@@ -2047,7 +2059,7 @@ inode_inc_iversion_locked(struct inode *inode)
 static inline u64
 inode_get_iversion_raw(const struct inode *inode)
 {
-	return inode->i_version;
+	return atomic64_read(&inode->i_version) & ~INODE_I_VERSION_QUERIED;
 }
 
 /**
@@ -2060,13 +2072,20 @@ inode_get_iversion_raw(const struct inode *inode)
 static inline u64
 inode_get_iversion(struct inode *inode)
 {
-	u64 ret;
+	u64 cur, old, new;
 
-	spin_lock(&inode->i_lock);
-	inode->i_state |= I_VERS_BUMP;
-	ret = inode->i_version;
-	spin_unlock(&inode->i_lock);
-	return ret;
+	cur = atomic64_read(&inode->i_version);
+	for (;;) {
+		if (cur & INODE_I_VERSION_QUERIED)
+			return (cur & ~INODE_I_VERSION_QUERIED);
+
+		new = (cur | INODE_I_VERSION_QUERIED);
+		old = atomic64_cmpxchg(&inode->i_version, cur, new);
+		if (old == cur)
+			break;
+		cur = old;
+	}
+	return cur;
 }
 
 /**
@@ -2080,7 +2099,7 @@ inode_get_iversion(struct inode *inode)
 static inline s64
 inode_cmp_iversion(const struct inode *inode, const u64 old)
 {
-	return (s64)inode->i_version - (s64)old;
+	return (s64)(atomic64_read(&inode->i_version) << 1) - (s64)(old << 1);
 }
 
 /**
@@ -2093,12 +2112,7 @@ inode_cmp_iversion(const struct inode *inode, const u64 old)
 static inline bool
 inode_iversion_need_inc(struct inode *inode)
 {
-	bool ret;
-
-	spin_lock(&inode->i_lock);
-	ret = inode->i_state & I_VERS_BUMP;
-	spin_unlock(&inode->i_lock);
-	return ret;
+	return atomic64_read(&inode->i_version) & INODE_I_VERSION_QUERIED;
 }
 
 enum file_time_flags {
-- 
2.7.4

