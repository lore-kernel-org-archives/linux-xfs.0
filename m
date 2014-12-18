Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4DD227F3F
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 06:49:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C8D730407E
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 04:49:21 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id dbBdg0xlCnoYAa5r (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 04:49:19 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/5] fs: Rename file_remove_suid() to file_remove_privs()
Date: Thu, 18 Dec 2014 13:49:03 +0100
Message-Id: <1418906946-30695-3-git-send-email-jack@suse.cz>
In-Reply-To: <1418906946-30695-1-git-send-email-jack@suse.cz>
References: <1418906946-30695-1-git-send-email-jack@suse.cz>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

file_remove_suid() is a misnomer since it removes also security related
xattrs and sets S_NOSEC flag. Also should_remove_suid() tells something
else than whether file_remove_suid() call is necessary which leads to
bugs.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/file.c    |  2 +-
 fs/ceph/file.c     |  2 +-
 fs/fuse/file.c     |  2 +-
 fs/inode.c         | 13 ++++++++-----
 fs/ntfs/file.c     |  2 +-
 fs/xfs/xfs_file.c  |  2 +-
 include/linux/fs.h |  2 +-
 mm/filemap.c       |  2 +-
 mm/filemap_xip.c   |  2 +-
 9 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a18ceabd99a8..123795de7103 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1752,7 +1752,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 
 	iov_iter_truncate(from, count);
 
-	err = file_remove_suid(file);
+	err = file_remove_privs(file);
 	if (err) {
 		mutex_unlock(&inode->i_mutex);
 		goto out;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d7e0da8366e6..566c04d7ce68 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -901,7 +901,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 	iov_iter_truncate(from, count);
 
-	err = file_remove_suid(file);
+	err = file_remove_privs(file);
 	if (err)
 		goto out;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index caa8d95b24e8..dca9311e628f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1214,7 +1214,7 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 
 	iov_iter_truncate(from, count);
-	err = file_remove_suid(file);
+	err = file_remove_privs(file);
 	if (err)
 		goto out;
 
diff --git a/fs/inode.c b/fs/inode.c
index f5e01704a5c8..fcc0886c5824 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1610,7 +1610,11 @@ static int __remove_suid(struct dentry *dentry, int kill)
 	return notify_change(dentry, &newattrs, NULL);
 }
 
-int file_remove_suid(struct file *file)
+/*
+ * Remove special file priviledges (suid, security tags) when file is written
+ * to or truncated.
+ */
+int file_remove_privs(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
@@ -1637,7 +1641,7 @@ int file_remove_suid(struct file *file)
 
 	return error;
 }
-EXPORT_SYMBOL(file_remove_suid);
+EXPORT_SYMBOL(file_remove_privs);
 
 /**
  *	file_update_time	-	update mtime and ctime time
@@ -1906,9 +1910,8 @@ EXPORT_SYMBOL(inode_dio_done);
  * inode is being instantiated).  The reason for the cmpxchg() loop
  * --- which wouldn't be necessary if all code paths which modify
  * i_flags actually followed this rule, is that there is at least one
- * code path which doesn't today --- for example,
- * __generic_file_aio_write() calls file_remove_suid() without holding
- * i_mutex --- so we use cmpxchg() out of an abundance of caution.
+ * code path which doesn't today so we use cmpxchg() out of an abundance
+ * of caution.
  *
  * In the long run, i_mutex is overkill, and we should probably look
  * at using the i_lock spinlock to protect i_flags, and then make sure
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 643faa44f22b..d9b8f3d953a9 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2098,7 +2098,7 @@ static ssize_t ntfs_file_aio_write_nolock(struct kiocb *iocb,
 		goto out;
 	if (!count)
 		goto out;
-	err = file_remove_suid(file);
+	err = file_remove_privs(file);
 	if (err)
 		goto out;
 	err = file_update_time(file);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index eb596b419942..5c9e8296ebb3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -557,7 +557,7 @@ restart:
 	 * setgid bits if the process is not being run by root.  This keeps
 	 * people from modifying setuid and setgid binaries.
 	 */
-	return file_remove_suid(file);
+	return file_remove_privs(file);
 }
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9ab779e8a63c..96b2d6a9a6cb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2428,7 +2428,7 @@ extern struct inode *new_inode_pseudo(struct super_block *sb);
 extern struct inode *new_inode(struct super_block *sb);
 extern void free_inode_nonrcu(struct inode *inode);
 extern int should_remove_suid(struct dentry *);
-extern int file_remove_suid(struct file *);
+extern int file_remove_privs(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 static inline void insert_inode_hash(struct inode *inode)
diff --git a/mm/filemap.c b/mm/filemap.c
index 14b4642279f1..da23d6fc102c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2580,7 +2580,7 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	iov_iter_truncate(from, count);
 
-	err = file_remove_suid(file);
+	err = file_remove_privs(file);
 	if (err)
 		goto out;
 
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index d8d9fe3f685c..8c0425b20b8a 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -423,7 +423,7 @@ xip_file_write(struct file *filp, const char __user *buf, size_t len,
 	if (count == 0)
 		goto out_backing;
 
-	ret = file_remove_suid(filp);
+	ret = file_remove_privs(filp);
 	if (ret)
 		goto out_backing;
 
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
