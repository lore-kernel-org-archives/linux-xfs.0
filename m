Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C9857CA6
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 17:03:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5194430404E
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 15:03:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0v93xmAbMEUlfdto (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 15:03:12 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v21 01/22] vfs: Add IS_ACL() and IS_RICHACL() tests
Date: Tue, 10 May 2016 00:02:34 +0200
Message-Id: <1462831375-23017-2-git-send-email-agruenba@redhat.com>
In-Reply-To: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
References: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
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

The vfs does not apply the umask for file systems that support acls. The
test used for this used to be called IS_POSIXACL(). Switch to a new
IS_ACL() test to check for either posix acls or richacls instead. Add a new
MS_RICHACL flag and IS_RICHACL() test for richacls alone. The IS_POSIXACL()
test is still needed by nfsd.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Steve French <steve.french@primarydata.com>
---
 fs/Kconfig              |  3 +++
 fs/namei.c              |  8 ++++----
 include/linux/fs.h      | 12 ++++++++++++
 include/uapi/linux/fs.h |  3 ++-
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 6725f59..8ad4e53 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -63,6 +63,9 @@ endif # BLOCK
 config FS_POSIX_ACL
 	def_bool n
 
+config FS_RICHACL
+	def_bool n
+
 config EXPORTFS
 	tristate
 
diff --git a/fs/namei.c b/fs/namei.c
index 3498d53..a986e09 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2833,7 +2833,7 @@ static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 	}
 
 	mode = op->mode;
-	if ((open_flag & O_CREAT) && !IS_POSIXACL(dir))
+	if ((open_flag & O_CREAT) && !IS_ACL(dir))
 		mode &= ~current_umask();
 
 	excl = (open_flag & (O_EXCL | O_CREAT)) == (O_EXCL | O_CREAT);
@@ -3023,7 +3023,7 @@ static int lookup_open(struct nameidata *nd, struct path *path,
 	/* Negative dentry, just create the file */
 	if (!dentry->d_inode && (op->open_flag & O_CREAT)) {
 		umode_t mode = op->mode;
-		if (!IS_POSIXACL(dir->d_inode))
+		if (!IS_ACL(dir->d_inode))
 			mode &= ~current_umask();
 		/*
 		 * This write is needed to ensure that a
@@ -3598,7 +3598,7 @@ retry:
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
+	if (!IS_ACL(path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mknod(&path, dentry, mode, dev);
 	if (error)
@@ -3667,7 +3667,7 @@ retry:
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
+	if (!IS_ACL(path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mkdir(&path, dentry, mode);
 	if (!error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 329ed37..c47de30 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1820,6 +1820,12 @@ struct super_operations {
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
@@ -1833,6 +1839,12 @@ struct super_operations {
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
index a079d50..c454cf5 100644
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
