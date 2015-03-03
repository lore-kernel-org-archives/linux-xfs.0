Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70E717F6A
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 04:38:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4FBA1304048
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 02:38:50 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 9PVE5OkvUYCSTXGf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 02:38:47 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/5] fs: Provide function telling whether file_remove_privs()
	will do anything
Date: Tue,  3 Mar 2015 11:38:37 +0100
Message-Id: <1425379119-3773-4-git-send-email-jack@suse.cz>
In-Reply-To: <1425379119-3773-1-git-send-email-jack@suse.cz>
References: <1425379119-3773-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Provide function telling whether file_remove_privs() will do anything.
Currently we only have should_remove_suid() and that does something
slightly different.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 44 ++++++++++++++++++++++++++++++++------------
 include/linux/fs.h |  1 +
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index bc5fe06b8784..3407bedc1c7b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1660,7 +1660,32 @@ int should_remove_suid(struct dentry *dentry)
 }
 EXPORT_SYMBOL(should_remove_suid);
 
-static int __remove_suid(struct dentry *dentry, int kill)
+/*
+ * Return mask of changes for notify_change() that need to be done as a
+ * response to write or truncate. Return 0 if nothing has to be changed.
+ * Negative value on error (change should be denied).
+ */
+int file_needs_remove_privs(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+	int mask = 0;
+	int ret;
+
+	if (IS_NOSEC(inode))
+		return 0;
+
+	mask = should_remove_suid(dentry);
+	ret = security_inode_need_killpriv(dentry);
+	if (ret < 0)
+		return ret;
+	if (ret)
+		mask |= ATTR_KILL_PRIV;
+	return mask;
+}
+EXPORT_SYMBOL(file_needs_remove_privs);
+
+static int __remove_privs(struct dentry *dentry, int kill)
 {
 	struct iattr newattrs;
 
@@ -1680,23 +1705,18 @@ int file_remove_privs(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	int killsuid;
-	int killpriv;
+	int kill;
 	int error = 0;
 
 	/* Fast path for nothing security related */
 	if (IS_NOSEC(inode))
 		return 0;
 
-	killsuid = should_remove_suid(dentry);
-	killpriv = security_inode_need_killpriv(dentry);
-
-	if (killpriv < 0)
-		return killpriv;
-	if (killpriv)
-		error = security_inode_killpriv(dentry);
-	if (!error && killsuid)
-		error = __remove_suid(dentry, killsuid);
+	kill = file_needs_remove_privs(file);
+	if (kill < 0)
+		return kill;
+	if (kill)
+		error = __remove_privs(dentry, kill);
 	if (!error && (inode->i_sb->s_flags & MS_NOSEC) &&
 	    !is_sxid(inode->i_mode))
 		inode->i_flags |= S_NOSEC;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 676e431247bd..78ff19f0c323 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2518,6 +2518,7 @@ extern struct inode *new_inode(struct super_block *sb);
 extern void free_inode_nonrcu(struct inode *inode);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_privs(struct file *);
+extern int file_needs_remove_privs(struct file *file);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 static inline void insert_inode_hash(struct inode *inode)
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
