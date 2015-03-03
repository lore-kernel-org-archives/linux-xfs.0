Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A5807F67
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 04:38:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37E738F8081
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 02:38:53 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id zTkx0TQ8GkTmzs4P (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 02:38:47 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/5] fs: Call security_ops->inode_killpriv on truncate
Date: Tue,  3 Mar 2015 11:38:38 +0100
Message-Id: <1425379119-3773-5-git-send-email-jack@suse.cz>
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

Comment in include/linux/security.h says that ->inode_killpriv() should
be called when setuid bit is being removed and that similar security
labels should be removed at this time as well. However we don't call
->inode_killpriv() when we remove suid bit on truncate.

We fix the problem by calling ->inode_need_killpriv() and subsequently
->inode_killpriv() on truncate the same way as we do it on file write.

After this patch there's only one user of should_remove_suid() - ocfs2 -
and indeed it's buggy because it doesn't clear security attributes on
write. However fixing it is difficult because of special locking
constraints.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 5 ++---
 fs/open.c          | 6 ++++--
 include/linux/fs.h | 6 +++++-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 3407bedc1c7b..7f4eabd72bd6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1665,9 +1665,8 @@ EXPORT_SYMBOL(should_remove_suid);
  * response to write or truncate. Return 0 if nothing has to be changed.
  * Negative value on error (change should be denied).
  */
-int file_needs_remove_privs(struct file *file)
+int dentry_needs_remove_privs(struct dentry *dentry)
 {
-	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	int mask = 0;
 	int ret;
@@ -1683,7 +1682,7 @@ int file_needs_remove_privs(struct file *file)
 		mask |= ATTR_KILL_PRIV;
 	return mask;
 }
-EXPORT_SYMBOL(file_needs_remove_privs);
+EXPORT_SYMBOL(dentry_needs_remove_privs);
 
 static int __remove_privs(struct dentry *dentry, int kill)
 {
diff --git a/fs/open.c b/fs/open.c
index 33f9cbf2610b..14e2aeea4cee 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -51,8 +51,10 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 		newattrs.ia_valid |= ATTR_FILE;
 	}
 
-	/* Remove suid/sgid on truncate too */
-	ret = should_remove_suid(dentry);
+	/* Remove suid/sgid and security markings on truncate too */
+	ret = dentry_needs_remove_privs(dentry);
+	if (ret < 0)
+		return ret;
 	if (ret)
 		newattrs.ia_valid |= ret | ATTR_FORCE;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 78ff19f0c323..ddaceede20ad 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2518,7 +2518,11 @@ extern struct inode *new_inode(struct super_block *sb);
 extern void free_inode_nonrcu(struct inode *inode);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_privs(struct file *);
-extern int file_needs_remove_privs(struct file *file);
+extern int dentry_needs_remove_privs(struct dentry *dentry);
+static inline int file_needs_remove_privs(struct file *file)
+{
+	return dentry_needs_remove_privs(file->f_path.dentry);
+}
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 static inline void insert_inode_hash(struct inode *inode)
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
