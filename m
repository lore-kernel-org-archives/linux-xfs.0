Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6222E7D01
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 08:49:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2538A8F8054
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 06:49:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZxGXe2P54DRsvoBv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Jun 2016 06:49:35 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v23 19/22] richacl: Add richacl xattr handler
Date: Thu, 30 Jun 2016 15:47:10 +0200
Message-Id: <1467294433-3222-20-git-send-email-agruenba@redhat.com>
In-Reply-To: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
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

Add richacl xattr handler implementing the xattr operations based on the
get_richacl and set_richacl inode operations.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/richacl.c                  | 22 ++++++++++++++++
 fs/richacl_xattr.c            | 61 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h       |  1 +
 include/linux/richacl_xattr.h |  2 ++
 4 files changed, 86 insertions(+)

diff --git a/fs/richacl.c b/fs/richacl.c
index 40e4af9..b7d7104 100644
--- a/fs/richacl.c
+++ b/fs/richacl.c
@@ -549,6 +549,28 @@ out:
 EXPORT_SYMBOL_GPL(richacl_permission);
 
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
index a442372..e7db066 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -206,5 +206,6 @@ extern int richacl_chmod(struct inode *, umode_t);
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
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
