Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 96C2A7CA7
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 06:51:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5362230404E
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 04:51:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xzqPRbNkNr9fl8VB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 04:51:10 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v22 01/22] vfs: Add IS_ACL() and IS_RICHACL() tests
Date: Tue, 31 May 2016 13:50:33 +0200
Message-Id: <1464695454-18557-2-git-send-email-agruenba@redhat.com>
In-Reply-To: <1464695454-18557-1-git-send-email-agruenba@redhat.com>
References: <1464695454-18557-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

The vfs does not apply the umask for file systems that support acls.
The test used for this used to be called IS_POSIXACL().  Switch to a new
IS_ACL() test to check for either posix acls or richacls instead.  Add a
new MS_RICHACL flag and IS_RICHACL() test for richacls alone.  The
IS_POSIXACL() test is still needed in some places like nfsd.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Steve French <steve.french@primarydata.com>
---
 fs/Kconfig              |  3 +++
 fs/namei.c              |  6 +++---
 include/linux/fs.h      | 12 ++++++++++++
 include/uapi/linux/fs.h |  3 ++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index b8fcb41..de6de55 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -64,6 +64,9 @@ endif # BLOCK
 config FS_POSIX_ACL
 	def_bool n
 
+config FS_RICHACL
+	def_bool n
+
 config EXPORTFS
 	tristate
 
diff --git a/fs/namei.c b/fs/namei.c
index 4c4f95a..113e3f2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3076,7 +3076,7 @@ static int lookup_open(struct nameidata *nd, struct path *path,
 	 * O_EXCL open we want to return EEXIST not EROFS).
 	 */
 	if (open_flag & O_CREAT) {
-		if (!IS_POSIXACL(dir->d_inode))
+		if (!IS_ACL(dir->d_inode))
 			mode &= ~current_umask();
 		if (unlikely(!got_write)) {
 			create_error = -EROFS;
@@ -3705,7 +3705,7 @@ retry:
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
+	if (!IS_ACL(path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mknod(&path, dentry, mode, dev);
 	if (error)
@@ -3776,7 +3776,7 @@ retry:
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
+	if (!IS_ACL(path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mkdir(&path, dentry, mode);
 	if (!error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd28814..4ad130c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1850,6 +1850,12 @@ struct super_operations {
 #define IS_IMMUTABLE(inode)	((inode)->i_flags & S_IMMUTABLE)
 #define IS_POSIXACL(inode)	__IS_FLG(inode, MS_POSIXACL)
 
+#ifdef CONFIG_FS_RICHACL
+#define IS_RICHACL(inode)	__IS_FLG(inode, MS_RICHACL)
+#else
+#define IS_RICHACL(inode)	0
+#endif
+
 #define IS_DEADDIR(inode)	((inode)->i_flags & S_DEAD)
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
@@ -1863,6 +1869,12 @@ struct super_operations {
 				 (inode)->i_rdev == WHITEOUT_DEV)
 
 /*
+ * IS_ACL() tells the VFS to not apply the umask
+ * and use check_acl for acl permission checks when defined.
+ */
+#define IS_ACL(inode)		__IS_FLG(inode, MS_POSIXACL | MS_RICHACL)
+
+/*
  * Inode state bits.  Protected by inode->i_lock
  *
  * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3b00f7c..f9c41ef 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -120,7 +120,7 @@ struct inodes_stat_t {
 #define MS_VERBOSE	32768	/* War is peace. Verbosity is silence.
 				   MS_VERBOSE is deprecated. */
 #define MS_SILENT	32768
-#define MS_POSIXACL	(1<<16)	/* VFS does not apply the umask */
+#define MS_POSIXACL	(1<<16)	/* Supports POSIX ACLs */
 #define MS_UNBINDABLE	(1<<17)	/* change to unbindable */
 #define MS_PRIVATE	(1<<18)	/* change to private */
 #define MS_SLAVE	(1<<19)	/* change to slave */
@@ -130,6 +130,7 @@ struct inodes_stat_t {
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 #define MS_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily */
+#define MS_RICHACL	(1<<26) /* Supports richacls */
 
 /* These sb flags are internal to the kernel */
 #define MS_NOSEC	(1<<28)
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
