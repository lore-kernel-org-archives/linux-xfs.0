Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Aug 2007 06:54:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l76DsAbm028500
	for <xfs@oss.sgi.com>; Mon, 6 Aug 2007 06:54:12 -0700
Date: Mon, 6 Aug 2007 09:54:06 -0400
Message-Id: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 01/25] VFS: move attr_kill logic from notify_change into helper function
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org, dhowells@redhat.com, linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com

Separate the handling of the local ia_valid bitmask from the one in
attr->ia_valid. This allows us to hand off the actual handling of the
ATTR_KILL_* flags to the .setattr i_op when one is defined.

notify_change still needs to process those flags for the local ia_valid
variable, since it uses that to decide whether to return early, and to pass
a (hopefully) appropriate bitmask to fsnotify_change.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/attr.c          |   54 +++++++++++++++++++++++++++++++++------------------
 include/linux/fs.h |    1 +
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index f8dfc22..47015e0 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -100,15 +100,39 @@ int inode_setattr(struct inode * inode, struct iattr * attr)
 }
 EXPORT_SYMBOL(inode_setattr);
 
+void attr_kill_to_mode(struct inode *inode, struct iattr *attr)
+{
+	if (attr->ia_valid & ATTR_KILL_SUID) {
+		attr->ia_valid &= ~ATTR_KILL_SUID;
+		if (inode->i_mode & S_ISUID) {
+			if (!(attr->ia_valid & ATTR_MODE)) {
+				attr->ia_valid |= ATTR_MODE;
+				attr->ia_mode = inode->i_mode;
+			}
+			attr->ia_mode &= ~S_ISUID;
+		}
+	}
+	if (attr->ia_valid & ATTR_KILL_SGID) {
+		attr->ia_valid &= ~ATTR_KILL_SGID;
+		if ((inode->i_mode & (S_ISGID | S_IXGRP)) ==
+		    (S_ISGID | S_IXGRP)) {
+			if (!(attr->ia_valid & ATTR_MODE)) {
+				attr->ia_valid |= ATTR_MODE;
+				attr->ia_mode = inode->i_mode;
+			}
+			attr->ia_mode &= ~S_ISGID;
+		}
+	}
+}
+EXPORT_SYMBOL(attr_kill_to_mode);
+
 int notify_change(struct dentry * dentry, struct iattr * attr)
 {
 	struct inode *inode = dentry->d_inode;
-	mode_t mode;
 	int error;
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
-	mode = inode->i_mode;
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
@@ -117,26 +141,17 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
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
@@ -147,6 +162,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 		if (!error)
 			error = inode->i_op->setattr(dentry, attr);
 	} else {
+		attr_kill_to_mode(inode, attr);
 		error = inode_change_ok(inode, attr);
 		if (!error)
 			error = security_inode_setattr(dentry, attr);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d33bead..f617b23 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1561,6 +1561,7 @@ extern int do_remount_sb(struct super_block *sb, int flags,
 #ifdef CONFIG_BLOCK
 extern sector_t bmap(struct inode *, sector_t);
 #endif
+extern void attr_kill_to_mode(struct inode *inode, struct iattr *attr);
 extern int notify_change(struct dentry *, struct iattr *);
 extern int permission(struct inode *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
-- 
1.5.2.2
