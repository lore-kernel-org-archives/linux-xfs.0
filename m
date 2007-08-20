Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Aug 2007 13:53:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7KKrXbm006662
	for <xfs@oss.sgi.com>; Mon, 20 Aug 2007 13:53:36 -0700
Date: Mon, 20 Aug 2007 16:53:15 -0400
Message-Id: <200708202053.l7KKrFVx017758@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 1/4] VFS: move ATTR_KILL handling from notify_change into helper function
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com, nfs@lists.sourceforge.net

Separate the handling of the local ia_valid bitmask from the one in
attr->ia_valid. This allows us to hand off the actual handling of the
ATTR_KILL_* flags to the .setattr i_op when one is defined.

notify_change still needs to process those flags for the local ia_valid
variable, since it uses that to decide whether to return early, and to pass
a (hopefully) appropriate bitmask to fsnotify_change.

Also, check the ia_valid after the setattr op returns and see if either
ATTR_KILL_* bit is set. If so, then throw a warning and try to clear the
bits in the "standard" way. This should help us to catch filesystems that
don't handle these bits correctly without breaking them outright.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/attr.c          |   91 ++++++++++++++++++++++++++++++++++++++++-----------
 include/linux/fs.h |    1 +
 2 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index ae58bd3..50c8ce4 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -100,15 +100,53 @@ int inode_setattr(struct inode * inode, struct iattr * attr)
 }
 EXPORT_SYMBOL(inode_setattr);
 
+/**
+ * generic_attrkill - helper to convert ATTR_KILL_* bits into mode change
+ * @mode: current mode of inode
+ * @attr: inode attribute changes requested by VFS
+ * Context: anywhere
+ *
+ * This is a helper function to convert ATTR_KILL_SUID and ATTR_KILL_SGID
+ * into a mode change. Filesystems should call this from their setattr
+ * inode op when they want "conventional" setuid-clearing behavior.
+ *
+ * Filesystems that declare a setattr inode operation are now expected to
+ * handle the ATTR_KILL_SUID and ATTR_KILL_SGID bits appropriately. The VFS
+ * no longer automatically converts these bits to a mode change for
+ * inodes that have their own setattr operation.
+ **/
+void generic_attrkill(mode_t mode, struct iattr *attr)
+{
+	if (attr->ia_valid & ATTR_KILL_SUID) {
+		attr->ia_valid &= ~ATTR_KILL_SUID;
+		if (mode & S_ISUID) {
+			if (!(attr->ia_valid & ATTR_MODE)) {
+				attr->ia_valid |= ATTR_MODE;
+				attr->ia_mode = mode;
+			}
+			attr->ia_mode &= ~S_ISUID;
+		}
+	}
+	if (attr->ia_valid & ATTR_KILL_SGID) {
+		attr->ia_valid &= ~ATTR_KILL_SGID;
+		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
+			if (!(attr->ia_valid & ATTR_MODE)) {
+				attr->ia_valid |= ATTR_MODE;
+				attr->ia_mode = mode;
+			}
+			attr->ia_mode &= ~S_ISGID;
+		}
+	}
+}
+EXPORT_SYMBOL(generic_attrkill);
+
 int notify_change(struct dentry * dentry, struct iattr * attr)
 {
 	struct inode *inode = dentry->d_inode;
-	mode_t mode;
-	int error;
+	int error, once = 0;
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
-	mode = inode->i_mode;
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
@@ -126,36 +164,49 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 			return error;
 	}
 	if (ia_valid & ATTR_KILL_SUID) {
-		attr->ia_valid &= ~ATTR_KILL_SUID;
-		if (mode & S_ISUID) {
-			if (!(ia_valid & ATTR_MODE)) {
-				ia_valid = attr->ia_valid |= ATTR_MODE;
-				attr->ia_mode = inode->i_mode;
-			}
-			attr->ia_mode &= ~S_ISUID;
-		}
+		ia_valid &= ~ATTR_KILL_SUID;
+		if (inode->i_mode & S_ISUID)
+			ia_valid |= ATTR_MODE;
 	}
 	if (ia_valid & ATTR_KILL_SGID) {
-		attr->ia_valid &= ~ ATTR_KILL_SGID;
-		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
-			if (!(ia_valid & ATTR_MODE)) {
-				ia_valid = attr->ia_valid |= ATTR_MODE;
-				attr->ia_mode = inode->i_mode;
-			}
-			attr->ia_mode &= ~S_ISGID;
-		}
+		ia_valid &= ~ATTR_KILL_SGID;
+		if ((inode->i_mode & (S_ISGID | S_IXGRP)) ==
+		    (S_ISGID | S_IXGRP))
+			ia_valid |= ATTR_MODE;
 	}
-	if (!attr->ia_valid)
+	if (!ia_valid)
 		return 0;
 
 	if (ia_valid & ATTR_SIZE)
 		down_write(&dentry->d_inode->i_alloc_sem);
 
 	if (inode->i_op && inode->i_op->setattr) {
+retry:
 		error = security_inode_setattr(dentry, attr);
 		if (!error)
 			error = inode->i_op->setattr(dentry, attr);
+		/*
+		 * if ATTR_KILL_SUID or ATTR_KILL_SGID is still set, then
+		 * assume that the setattr inode op didn't handle them
+		 * correctly. Try to clear these bits the standard way
+		 * with a second setattr call and printk a warning.
+		 */
+		if (!error && !once && unlikely(attr->ia_valid &
+					(ATTR_KILL_SUID|ATTR_KILL_SGID))) {
+			attr->ia_valid &=
+				(ATTR_FORCE|ATTR_KILL_SUID|ATTR_KILL_SGID);
+			generic_attrkill(inode->i_mode, attr);
+			++once;
+			if (printk_ratelimit())
+				printk(KERN_ERR "%s: %s doesn't seem to "
+					"handle setuid/setgid bit killing "
+					"correctly. Report this to filesystem "
+					"maintainer.\n", __func__,
+					inode->i_sb->s_type->name);
+			goto retry;
+		}
 	} else {
+		generic_attrkill(inode->i_mode, attr);
 		error = inode_change_ok(inode, attr);
 		if (!error)
 			error = security_inode_setattr(dentry, attr);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 30eb32f..6ba6830 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1679,6 +1679,7 @@ extern int do_remount_sb(struct super_block *sb, int flags,
 #ifdef CONFIG_BLOCK
 extern sector_t bmap(struct inode *, sector_t);
 #endif
+extern void generic_attrkill(mode_t mode, struct iattr *attr);
 extern int notify_change(struct dentry *, struct iattr *);
 extern int permission(struct inode *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
-- 
1.5.2.2
