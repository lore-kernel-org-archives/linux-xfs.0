Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751714AbeA3Rb3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Jan 2018 12:31:29 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] iversion: make inode_cmp_iversion{+raw} return bool instead of s64
Date: Tue, 30 Jan 2018 12:31:26 -0500
Message-Id: <20180130173126.2806-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, tytso@mit.edu, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-integrity@vger.kernel.org, linux-xfs@vger.kernel.org, akpm@linux-foundation.org, linux-btrfs@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

As Linus points out:

    The inode_cmp_iversion{+raw}() functions are pure and utter crap.

    Why?

    You say that they return 0/negative/positive, but they do so in a
    completely broken manner. They return that ternary value as the
    sequence number difference in a 's64', which means that if you
    actually care about that ternary value, and do the *sane* thing that
    the kernel-doc of the function implies is the right thing, you would
    do

        int cmp = inode_cmp_iversion(inode, old);
        if (cmp < 0 ...

    and as a result you get code that looks sane, but that doesn't
    actually *WORK* right.

Since none of the callers actually care about the ternary value here,
convert the inode_cmp_iversion{+raw} functions to just return a boolean
value (false for matching, true for non-matching).

This matches the existing use of these functions just fine, and makes it
simple to convert them to return a ternary value in the future if we
grow callers that need it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/iversion.h | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/linux/iversion.h b/include/linux/iversion.h
index 858463fca249..ace32775c5f0 100644
--- a/include/linux/iversion.h
+++ b/include/linux/iversion.h
@@ -309,13 +309,13 @@ inode_query_iversion(struct inode *inode)
  * @inode: inode to check
  * @old: old value to check against its i_version
  *
- * Compare the current raw i_version counter with a previous one. Returns 0 if
- * they are the same or non-zero if they are different.
+ * Compare the current raw i_version counter with a previous one. Returns false
+ * if they are the same or true if they are different.
  */
-static inline s64
+static inline bool
 inode_cmp_iversion_raw(const struct inode *inode, u64 old)
 {
-	return (s64)inode_peek_iversion_raw(inode) - (s64)old;
+	return inode_peek_iversion_raw(inode) != old;
 }
 
 /**
@@ -323,19 +323,17 @@ inode_cmp_iversion_raw(const struct inode *inode, u64 old)
  * @inode: inode to check
  * @old: old value to check against its i_version
  *
- * Compare an i_version counter with a previous one. Returns 0 if they are
- * the same, a positive value if the one in the inode appears newer than @old,
- * and a negative value if @old appears to be newer than the one in the
- * inode.
+ * Compare an i_version counter with a previous one. Returns false if they are
+ * the same, and true if they are different.
  *
  * Note that we don't need to set the QUERIED flag in this case, as the value
  * in the inode is not being recorded for later use.
  */
 
-static inline s64
+static inline bool
 inode_cmp_iversion(const struct inode *inode, u64 old)
 {
-	return (s64)(inode_peek_iversion_raw(inode) & ~I_VERSION_QUERIED) -
-	       (s64)(old << I_VERSION_QUERIED_SHIFT);
+	return (inode_peek_iversion_raw(inode) & ~I_VERSION_QUERIED) !=
+			(old << I_VERSION_QUERIED_SHIFT);
 }
 #endif
-- 
2.14.3

