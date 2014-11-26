Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 285C17F62
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 04:24:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECFCA8F8050
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 02:24:08 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 6EZiAGjJi4uVBWoJ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 02:24:07 -0800 (PST)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v4 7/7] btrfs: add an is_readonly() so btrfs can use common
	code for update_time()
Date: Wed, 26 Nov 2014 05:23:57 -0500
Message-Id: <1416997437-26092-8-git-send-email-tytso@mit.edu>
In-Reply-To: <1416997437-26092-1-git-send-email-tytso@mit.edu>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

The only reason btrfs cloned code from the VFS layer was so it could
add a check to see if a subvolume is read-ony.  Instead of doing that,
let's add a new inode operation which allows a file system to return
an error if the inode is read-only, and use that in update_time().
There may be other places where the VFS layer may want to know that
btrfs would want to treat an inode is read-only.

With this commit, there are no remaining users of update_time() in the
inode operations structure, so we can remove it and simply things
further.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: linux-btrfs@vger.kernel.org
Reviewed-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/inode.c   | 26 ++++++--------------------
 fs/inode.c         | 22 +++++++++++-----------
 include/linux/fs.h |  2 +-
 3 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a5e0d0d..0bfe3a4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5554,26 +5554,12 @@ static int btrfs_dirty_inode(struct inode *inode)
 	return ret;
 }
 
-/*
- * This is a copy of file_update_time.  We need this so we can return error on
- * ENOSPC for updating the inode in the case of file write and mmap writes.
- */
-static int btrfs_update_time(struct inode *inode, struct timespec *now,
-			     int flags)
+static int btrfs_is_readonly(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
-
-	if (flags & S_VERSION)
-		inode_inc_iversion(inode);
-	if (flags & S_CTIME)
-		inode->i_ctime = *now;
-	if (flags & S_MTIME)
-		inode->i_mtime = *now;
-	if (flags & S_ATIME)
-		inode->i_atime = *now;
 	return 0;
 }
 
@@ -9466,8 +9452,8 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 	.tmpfile        = btrfs_tmpfile,
 };
 static const struct inode_operations btrfs_dir_ro_inode_operations = {
@@ -9475,8 +9461,8 @@ static const struct inode_operations btrfs_dir_ro_inode_operations = {
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 };
 
 static const struct file_operations btrfs_dir_file_operations = {
@@ -9546,8 +9532,8 @@ static const struct inode_operations btrfs_file_inode_operations = {
 	.fiemap		= btrfs_fiemap,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 };
 static const struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
@@ -9559,8 +9545,8 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.removexattr	= btrfs_removexattr,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 };
 static const struct inode_operations btrfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
@@ -9573,8 +9559,8 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.getxattr	= btrfs_getxattr,
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 };
 
 const struct dentry_operations btrfs_dentry_operations = {
diff --git a/fs/inode.c b/fs/inode.c
index 0b4c6ae..e29bd2d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1554,20 +1554,20 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 	unsigned short days_since_boot;
 	int ret;
 
-	if (inode->i_op->update_time) {
-		ret = inode->i_op->update_time(inode, time, flags);
+	if (inode->i_op->is_readonly) {
+		ret = inode->i_op->is_readonly(inode);
 		if (ret)
 			return ret;
-	} else {
-		if (flags & S_ATIME)
-			inode->i_atime = *time;
-		if (flags & S_VERSION)
-			inode_inc_iversion(inode);
-		if (flags & S_CTIME)
-			inode->i_ctime = *time;
-		if (flags & S_MTIME)
-			inode->i_mtime = *time;
 	}
+	if (flags & S_ATIME)
+		inode->i_atime = *time;
+	if (flags & S_VERSION)
+		inode_inc_iversion(inode);
+	if (flags & S_CTIME)
+		inode->i_ctime = *time;
+	if (flags & S_MTIME)
+		inode->i_mtime = *time;
+
 	/*
 	 * If i_ts_dirty_day is zero, then either we have not deferred
 	 * timestamp updates, or the system has been up for less than
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dc615ec..6e41107 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1545,8 +1545,8 @@ struct inode_operations {
 	int (*removexattr) (struct dentry *, const char *);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
-	int (*update_time)(struct inode *, struct timespec *, int);
 	int (*write_time)(struct inode *);
+	int (*is_readonly)(struct inode *);
 	int (*atomic_open)(struct inode *, struct dentry *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode, int *opened);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
