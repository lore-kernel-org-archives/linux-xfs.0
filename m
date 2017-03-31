Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933217AbdCaRb2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:31:28 -0400
Subject: [PATCH 1/8] Documentation/filesystems: fix documentation for
 ->getattr()
From: David Howells <dhowells@redhat.com>
Date: Fri, 31 Mar 2017 18:31:25 +0100
Message-ID: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@google.com>, linux-kernel@vger.kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Following the recent merge of statx, correct the documented prototype
for the ->getattr() inode operation, and add an entry to the porting
file.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/Locking |    3 +--
 Documentation/filesystems/porting |    6 ++++++
 Documentation/filesystems/vfs.txt |    3 +--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index fdcfdd79682a..fe25787ff6d4 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -58,8 +58,7 @@ prototypes:
 	int (*permission) (struct inode *, int, unsigned int);
 	int (*get_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
-	int (*getattr) (const struct path *, struct dentry *, struct kstat *,
-			u32, unsigned int);
+	int (*getattr) (const struct path *, struct kstat *, u32, unsigned int);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
 	void (*update_time)(struct inode *, struct timespec *, int);
diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 95280079c0b3..5fb17f49f7a2 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -600,3 +600,9 @@ in your dentry operations instead.
 [recommended]
 	->readlink is optional for symlinks.  Don't set, unless filesystem needs
 	to fake something for readlink(2).
+--
+[mandatory]
+	->getattr() is now passed a struct path rather than a vfsmount and
+	dentry separately, and it now has request_mask and query_flags arguments
+	to specify the fields and sync type requested by statx.  Filesystems not
+	supporting any statx-specific features may ignore the new arguments.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 569211703721..94dd27ef4a76 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -382,8 +382,7 @@ struct inode_operations {
 	int (*permission) (struct inode *, int);
 	int (*get_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
-	int (*getattr) (const struct path *, struct dentry *, struct kstat *,
-			u32, unsigned int);
+	int (*getattr) (const struct path *, struct kstat *, u32, unsigned int);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	void (*update_time)(struct inode *, struct timespec *, int);
 	int (*atomic_open)(struct inode *, struct dentry *, struct file *,

