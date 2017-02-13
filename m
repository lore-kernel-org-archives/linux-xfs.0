Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753549AbdBMPdt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Feb 2017 10:33:49 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v28 17/21] richacl: Add richacl xattr handler
Date: Mon, 13 Feb 2017 16:32:33 +0100
Message-Id: <1486999957-2381-18-git-send-email-agruenba@redhat.com>
In-Reply-To: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
References: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

Add richacl xattr handler implementing the xattr operations based on the
get_richacl and set_richacl inode operations.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
---
 fs/richacl.c                  | 22 ++++++++++++++++
 fs/richacl_xattr.c            | 61 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h       |  1 +
 include/linux/richacl_xattr.h |  2 ++
 4 files changed, 86 insertions(+)

diff --git a/fs/richacl.c b/fs/richacl.c
index 4edce8b..1945691 100644
--- a/fs/richacl.c
+++ b/fs/richacl.c
@@ -543,6 +543,28 @@ void richacl_compute_max_masks(struct richacl *acl)
 EXPORT_SYMBOL_GPL(richacl_compute_max_masks);
 
 /**
+ * set_richacl  -  set the richacl of an inode
+ * @inode:	inode whose richacl to set
+ * @acl:	access control list
+ */
+int
+set_richacl(struct inode *inode, struct richacl *acl)
+{
+	if (!IS_RICHACL(inode))
+		return -EOPNOTSUPP;
+	if (!inode->i_op->set_richacl)
+		return -EOPNOTSUPP;
+
+	if (!uid_eq(current_fsuid(), inode->i_uid) &&
+	    inode_permission(inode, MAY_CHMOD) &&
+	    !capable(CAP_FOWNER))
+		return -EPERM;
+
+	return inode->i_op->set_richacl(inode, acl);
+}
+EXPORT_SYMBOL(set_richacl);
+
+/**
  * __richacl_chmod  -  update the file masks to reflect the new mode
  * @acl:	access control list
  * @mode:	new file permission bits including the file type
diff --git a/fs/richacl_xattr.c b/fs/richacl_xattr.c
index dc1ad36..5eb4aba 100644
--- a/fs/richacl_xattr.c
+++ b/fs/richacl_xattr.c
@@ -18,7 +18,9 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/xattr.h>
 #include <linux/richacl_xattr.h>
+#include <uapi/linux/xattr.h>
 
 /**
  * richacl_from_xattr  -  convert a richacl xattr into the in-memory representation
@@ -159,3 +161,62 @@ richacl_to_xattr(struct user_namespace *user_ns,
 	return real_size;
 }
 EXPORT_SYMBOL_GPL(richacl_to_xattr);
+
+static bool
+richacl_xattr_list(struct dentry *dentry)
+{
+	return IS_RICHACL(d_backing_inode(dentry));
+}
+
+static int
+richacl_xattr_get(const struct xattr_handler *handler,
+		  struct dentry *unused, struct inode *inode,
+		  const char *name, void *buffer, size_t buffer_size)
+{
+	struct richacl *acl;
+	int error;
+
+	if (*name)
+		return -EINVAL;
+	if (!IS_RICHACL(inode))
+		return -EOPNOTSUPP;
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	acl = get_richacl(inode);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+	error = richacl_to_xattr(current_user_ns(), acl, buffer, buffer_size);
+	richacl_put(acl);
+	return error;
+}
+
+static int
+richacl_xattr_set(const struct xattr_handler *handler,
+		  struct dentry *unused, struct inode *inode,
+		  const char *name, const void *value, size_t size,
+		  int flags)
+{
+	struct richacl *acl = NULL;
+	int ret;
+
+	if (value) {
+		acl = richacl_from_xattr(current_user_ns(), value, size,
+					 -EINVAL);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+	}
+
+	ret = set_richacl(inode, acl);
+	richacl_put(acl);
+	return ret;
+}
+
+struct xattr_handler richacl_xattr_handler = {
+	.name = XATTR_NAME_RICHACL,
+	.list = richacl_xattr_list,
+	.get = richacl_xattr_get,
+	.set = richacl_xattr_set,
+};
+EXPORT_SYMBOL(richacl_xattr_handler);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 737513b..7530920 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -205,5 +205,6 @@ extern int richacl_chmod(struct inode *, umode_t);
 extern int richacl_equiv_mode(const struct richacl *, umode_t *);
 extern struct richacl *richacl_inherit(const struct richacl *, int);
 extern struct richacl *richacl_create(umode_t *, struct inode *);
+extern int set_richacl(struct inode *, struct richacl *);
 
 #endif /* __RICHACL_H */
diff --git a/include/linux/richacl_xattr.h b/include/linux/richacl_xattr.h
index 0efa14b..6c6adb1 100644
--- a/include/linux/richacl_xattr.h
+++ b/include/linux/richacl_xattr.h
@@ -26,4 +26,6 @@ extern size_t richacl_xattr_size(const struct richacl *);
 extern int richacl_to_xattr(struct user_namespace *, const struct richacl *,
 			    void *, size_t);
 
+extern struct xattr_handler richacl_xattr_handler;
+
 #endif /* __RICHACL_XATTR_H */
-- 
2.7.4

