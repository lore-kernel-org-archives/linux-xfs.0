Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 672907F3F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 07:27:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46D5F8F8037
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 05:27:55 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id mLuFRq6og32Icq4b (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 05:27:53 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/5] fs: Remove security attributes on truncate
Date: Thu,  4 Dec 2014 14:27:38 +0100
Message-Id: <1417699659-14284-5-git-send-email-jack@suse.cz>
In-Reply-To: <1417699659-14284-1-git-send-email-jack@suse.cz>
References: <1417699659-14284-1-git-send-email-jack@suse.cz>
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

Similarly as we remove suid bit on truncate, we also want to remove
security extended attributes.

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
index 6807a2707828..8595c7b8841c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1603,9 +1603,8 @@ EXPORT_SYMBOL(should_remove_suid);
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
@@ -1621,7 +1620,7 @@ int file_needs_remove_privs(struct file *file)
 		mask |= ATTR_KILL_PRIV;
 	return mask;
 }
-EXPORT_SYMBOL(file_needs_remove_privs);
+EXPORT_SYMBOL(dentry_needs_remove_privs);
 
 static int __remove_privs(struct dentry *dentry, int kill)
 {
diff --git a/fs/open.c b/fs/open.c
index de92c13b58be..e4e0863855d0 100644
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
index aac707cced66..c5ccc311e8fb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2429,7 +2429,11 @@ extern struct inode *new_inode(struct super_block *sb);
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
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
