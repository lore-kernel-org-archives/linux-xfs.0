Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933389AbdCaRcE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:32:04 -0400
Subject: [PATCH 5/8] ext4: Add statx support
From: David Howells <dhowells@redhat.com>
Date: Fri, 31 Mar 2017 18:31:56 +0100
Message-ID: <149098151634.28108.16470351314686633302.stgit@warthog.procyon.org.uk>
In-Reply-To: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
References: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

Return enhanced file attributes from the Ext4 filesystem.  This includes
the following:

 (1) The inode creation time (i_crtime) as stx_btime, setting STATX_BTIME.

 (2) Certain FS_xxx_FL flags are mapped to stx_attribute flags.

This requires that all ext4 inodes have a getattr call, not just some of
them, so to this end, split the ext4_getattr() function and only call part
of it where appropriate.

Example output:

	[root@andromeda ~]# touch foo
	[root@andromeda ~]# chattr +ai foo
	[root@andromeda ~]# /tmp/test-statx foo
	statx(foo) = 0
	results=fff
	  Size: 0               Blocks: 0          IO Block: 4096    regular file
	Device: 08:12           Inode: 2101950     Links: 1
	Access: (0644/-rw-r--r--)  Uid:     0   Gid:     0
	Access: 2016-02-11 17:08:29.031795451+0000
	Modify: 2016-02-11 17:08:29.031795451+0000
	Change: 2016-02-11 17:11:11.987790114+0000
	 Birth: 2016-02-11 17:08:29.031795451+0000
	Attributes: 0000000000000030 (-------- -------- -------- -------- -------- -------- -------- --ai----)

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext4/ext4.h    |    1 +
 fs/ext4/file.c    |    2 +-
 fs/ext4/inode.c   |   35 ++++++++++++++++++++++++++++++++---
 fs/ext4/namei.c   |    2 ++
 fs/ext4/symlink.c |    3 +++
 5 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f493af666591..fb69ee2388db 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2466,6 +2466,7 @@ extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(const struct path *, struct kstat *, u32, unsigned int);
 extern void ext4_evict_inode(struct inode *);
 extern void ext4_clear_inode(struct inode *);
+extern int  ext4_file_getattr(const struct path *, struct kstat *, u32, unsigned int);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
 extern void ext4_dirty_inode(struct inode *, int);
 extern int ext4_change_inode_journal_flag(struct inode *, int);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8210c1f43556..cefa9835f275 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -744,7 +744,7 @@ const struct file_operations ext4_file_operations = {
 
 const struct inode_operations ext4_file_inode_operations = {
 	.setattr	= ext4_setattr,
-	.getattr	= ext4_getattr,
+	.getattr	= ext4_file_getattr,
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4247d8d25687..5d02b922afa3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5390,11 +5390,40 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 int ext4_getattr(const struct path *path, struct kstat *stat,
 		 u32 request_mask, unsigned int query_flags)
 {
-	struct inode *inode;
-	unsigned long long delalloc_blocks;
+	struct inode *inode = d_inode(path->dentry);
+	struct ext4_inode *raw_inode;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int flags;
+
+	if (EXT4_FITS_IN_INODE(raw_inode, ei, i_crtime)) {
+		stat->result_mask |= STATX_BTIME;
+		stat->btime.tv_sec = ei->i_crtime.tv_sec;
+		stat->btime.tv_nsec = ei->i_crtime.tv_nsec;
+	}
+
+	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
+	if (flags & EXT4_APPEND_FL)
+		stat->attributes |= STATX_ATTR_APPEND;
+	if (flags & EXT4_COMPR_FL)
+		stat->attributes |= STATX_ATTR_COMPRESSED;
+	if (flags & EXT4_ENCRYPT_FL)
+		stat->attributes |= STATX_ATTR_ENCRYPTED;
+	if (flags & EXT4_IMMUTABLE_FL)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (flags & EXT4_NODUMP_FL)
+		stat->attributes |= STATX_ATTR_NODUMP;
 
-	inode = d_inode(path->dentry);
 	generic_fillattr(inode, stat);
+	return 0;
+}
+
+int ext4_file_getattr(const struct path *path, struct kstat *stat,
+		      u32 request_mask, unsigned int query_flags)
+{
+	struct inode *inode = d_inode(path->dentry);
+	u64 delalloc_blocks;
+
+	ext4_getattr(path, stat, request_mask, query_flags);
 
 	/*
 	 * If there is inline data in the inode, the inode will normally not
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6ad612c576fc..07e5e1405771 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3912,6 +3912,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.tmpfile	= ext4_tmpfile,
 	.rename		= ext4_rename2,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
@@ -3920,6 +3921,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 
 const struct inode_operations ext4_special_inode_operations = {
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 73b184d161fc..5c8fc53cb0e5 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -85,17 +85,20 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.get_link	= ext4_encrypted_get_link,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 };
 
 const struct inode_operations ext4_symlink_inode_operations = {
 	.get_link	= page_get_link,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 };
 
 const struct inode_operations ext4_fast_symlink_inode_operations = {
 	.get_link	= simple_get_link,
 	.setattr	= ext4_setattr,
+	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
 };

