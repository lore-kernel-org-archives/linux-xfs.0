Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8340D7F58
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 06:07:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 601E9304039
	for <xfs@oss.sgi.com>; Sun,  1 Dec 2013 04:07:10 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id WLUuKfkeOR86iv6S (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Dec 2013 04:07:06 -0800 (PST)
Message-Id: <20131201120653.694912626@bombadil.infradead.org>
Date: Sun, 01 Dec 2013 03:59:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/18] reiserfs: prefix ACL symbols with reiserfs_
References: <20131201115903.910559036@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0001-reiserfs-prefix-ACL-symbols-with-reiserfs_.patch
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
To: viro@zeniv.linux.org.uk
Cc: xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/reiserfs/xattr_acl.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 06c04f7..6f721ea 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -16,7 +16,7 @@ static int reiserfs_set_acl(struct reiserfs_transaction_handle *th,
 			    struct posix_acl *acl);
 
 static int
-posix_acl_set(struct dentry *dentry, const char *name, const void *value,
+reiserfs_posix_acl_set(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags, int type)
 {
 	struct inode *inode = dentry->d_inode;
@@ -65,7 +65,7 @@ posix_acl_set(struct dentry *dentry, const char *name, const void *value,
 }
 
 static int
-posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
+reiserfs_posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
 		size_t size, int type)
 {
 	struct posix_acl *acl;
@@ -88,7 +88,7 @@ posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
 /*
  * Convert from filesystem to in-memory representation.
  */
-static struct posix_acl *posix_acl_from_disk(const void *value, size_t size)
+static struct posix_acl *reiserfs_posix_acl_from_disk(const void *value, size_t size)
 {
 	const char *end = (char *)value + size;
 	int n, count;
@@ -158,7 +158,7 @@ static struct posix_acl *posix_acl_from_disk(const void *value, size_t size)
 /*
  * Convert from in-memory to filesystem representation.
  */
-static void *posix_acl_to_disk(const struct posix_acl *acl, size_t * size)
+static void *reiserfs_posix_acl_to_disk(const struct posix_acl *acl, size_t * size)
 {
 	reiserfs_acl_header *ext_acl;
 	char *e;
@@ -257,7 +257,7 @@ struct posix_acl *reiserfs_get_acl(struct inode *inode, int type)
 	} else if (retval < 0) {
 		acl = ERR_PTR(retval);
 	} else {
-		acl = posix_acl_from_disk(value, retval);
+		acl = reiserfs_posix_acl_from_disk(value, retval);
 	}
 	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
@@ -307,7 +307,7 @@ reiserfs_set_acl(struct reiserfs_transaction_handle *th, struct inode *inode,
 	}
 
 	if (acl) {
-		value = posix_acl_to_disk(acl, &size);
+		value = reiserfs_posix_acl_to_disk(acl, &size);
 		if (IS_ERR(value))
 			return (int)PTR_ERR(value);
 	}
@@ -499,8 +499,8 @@ static size_t posix_acl_access_list(struct dentry *dentry, char *list,
 const struct xattr_handler reiserfs_posix_acl_access_handler = {
 	.prefix = POSIX_ACL_XATTR_ACCESS,
 	.flags = ACL_TYPE_ACCESS,
-	.get = posix_acl_get,
-	.set = posix_acl_set,
+	.get = reiserfs_posix_acl_get,
+	.set = reiserfs_posix_acl_set,
 	.list = posix_acl_access_list,
 };
 
@@ -519,7 +519,7 @@ static size_t posix_acl_default_list(struct dentry *dentry, char *list,
 const struct xattr_handler reiserfs_posix_acl_default_handler = {
 	.prefix = POSIX_ACL_XATTR_DEFAULT,
 	.flags = ACL_TYPE_DEFAULT,
-	.get = posix_acl_get,
-	.set = posix_acl_set,
+	.get = reiserfs_posix_acl_get,
+	.set = reiserfs_posix_acl_set,
 	.list = posix_acl_default_list,
 };
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
