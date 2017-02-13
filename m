Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753202AbdBMPeH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Feb 2017 10:34:07 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v28 20/21] ext4: Add richacl support
Date: Mon, 13 Feb 2017 16:32:36 +0100
Message-Id: <1486999957-2381-21-git-send-email-agruenba@redhat.com>
In-Reply-To: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
References: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Support the richacl permission model in ext4.  The richacls are stored
in "system.richacl" xattrs.  Richacls need to be enabled by tune2fs or
at file system create time.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/Kconfig     |  11 +++++
 fs/ext4/Makefile    |   1 +
 fs/ext4/file.c      |   3 ++
 fs/ext4/ialloc.c    |  11 ++++-
 fs/ext4/inode.c     |   4 +-
 fs/ext4/namei.c     |   5 ++
 fs/ext4/richacl.c   | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/richacl.h   |  40 ++++++++++++++++
 fs/ext4/xattr.c     |   7 +++
 include/linux/acl.h |  15 ++++++
 10 files changed, 228 insertions(+), 3 deletions(-)
 create mode 100644 fs/ext4/richacl.c
 create mode 100644 fs/ext4/richacl.h
 create mode 100644 include/linux/acl.h

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index e38039f..72acd01 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -22,6 +22,17 @@ config EXT3_FS_POSIX_ACL
 	  This config option is here only for backward compatibility. ext3
 	  filesystem is now handled by the ext4 driver.
 
+config EXT4_FS_RICHACL
+	bool "Ext4 Rich Access Control Lists"
+	depends on EXT4_FS
+	select FS_RICHACL
+	help
+	  Richacls are an implementation of NFSv4 ACLs, extended by file masks
+	  to cleanly integrate into the POSIX file permission model.  To learn
+	  more about them, see http://www.bestbits.at/richacl/.
+
+	  If you don't know what Richacls are, say N.
+
 config EXT3_FS_SECURITY
 	bool "Ext3 Security Labels"
 	depends on EXT3_FS
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 354103f..c65d2675 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -12,3 +12,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
+ext4-$(CONFIG_EXT4_FS_RICHACL) 		+= richacl.o
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index d663d3d..bc0928b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -30,6 +30,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 #ifdef CONFIG_FS_DAX
 static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
@@ -761,6 +762,8 @@ const struct inode_operations ext4_file_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_richacl	= ext4_get_richacl,
+	.set_richacl	= ext4_set_richacl,
 	.fiemap		= ext4_fiemap,
 };
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index e57e8d9..95d2553c 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -27,6 +27,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -729,6 +730,14 @@ static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
 	return ret;
 }
 
+static inline int
+ext4_new_acl(handle_t *handle, struct inode *inode, struct inode *dir)
+{
+	if (IS_RICHACL(dir))
+		return ext4_init_richacl(handle, inode, dir);
+	return ext4_init_acl(handle, inode, dir);
+}
+
 /*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
@@ -1093,7 +1102,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	if (err)
 		goto fail_drop;
 
-	err = ext4_init_acl(handle, inode, dir);
+	err = ext4_new_acl(handle, inode, dir);
 	if (err)
 		goto fail_free_drop;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 88d57af..4babd9c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -38,10 +38,10 @@
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include <linux/iomap.h>
+#include <linux/acl.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
-#include "acl.h"
 #include "truncate.h"
 
 #include <trace/events/ext4.h>
@@ -5339,7 +5339,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		ext4_orphan_del(NULL, inode);
 
 	if (!error && (ia_valid & ATTR_MODE))
-		rc = posix_acl_chmod(inode, inode->i_mode);
+		rc = acl_chmod(inode);
 
 err_out:
 	ext4_std_error(inode->i_sb, error);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eadba91..f3e8fe6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -38,6 +38,7 @@
 
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 /*
@@ -3887,6 +3888,8 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_richacl	= ext4_get_richacl,
+	.set_richacl	= ext4_set_richacl,
 	.fiemap         = ext4_fiemap,
 };
 
@@ -3895,4 +3898,6 @@ const struct inode_operations ext4_special_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_richacl	= ext4_get_richacl,
+	.set_richacl	= ext4_set_richacl,
 };
diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
new file mode 100644
index 0000000..08e5b1d
--- /dev/null
+++ b/fs/ext4/richacl.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Copyright (C) 2015  Red Hat, Inc.
+ * Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>,
+ * 	   Andreas Gruenbacher <agruenba@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/richacl_xattr.h>
+
+#include "ext4.h"
+#include "ext4_jbd2.h"
+#include "xattr.h"
+#include "acl.h"
+#include "richacl.h"
+
+struct richacl *
+ext4_get_richacl(struct inode *inode)
+{
+	const int name_index = EXT4_XATTR_INDEX_RICHACL;
+	void *value = NULL;
+	struct richacl *acl = NULL;
+	int retval;
+
+	retval = ext4_xattr_get(inode, name_index, "", NULL, 0);
+	if (retval > 0) {
+		value = kmalloc(retval, GFP_NOFS);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		retval = ext4_xattr_get(inode, name_index, "", value, retval);
+	}
+	if (retval > 0)
+		acl = richacl_from_xattr(&init_user_ns, value, retval, -EIO);
+	else if (retval != -ENODATA && retval != -ENOSYS)
+		acl = ERR_PTR(retval);
+	kfree(value);
+
+	return acl;
+}
+
+static int
+__ext4_remove_richacl(handle_t *handle, struct inode *inode)
+{
+	const int name_index = EXT4_XATTR_INDEX_RICHACL;
+	int retval;
+
+	retval = ext4_xattr_set_handle(handle, inode, name_index, "",
+				       NULL, 0, 0);
+	if (!retval)
+		set_cached_richacl(inode, NULL);
+	return retval;
+}
+
+static int
+__ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
+{
+	const int name_index = EXT4_XATTR_INDEX_RICHACL;
+	umode_t mode = inode->i_mode;
+	int retval, size;
+	void *value;
+
+	if (richacl_equiv_mode(acl, &mode) == 0) {
+		inode->i_ctime = current_time(inode);
+		inode->i_mode = mode;
+		ext4_mark_inode_dirty(handle, inode);
+		return __ext4_remove_richacl(handle, inode);
+	}
+
+	mode &= ~S_IRWXUGO;
+	mode |= richacl_masks_to_mode(acl);
+
+	size = richacl_xattr_size(acl);
+	value = kmalloc(size, GFP_NOFS);
+	if (!value)
+		return -ENOMEM;
+	richacl_to_xattr(&init_user_ns, acl, value, size);
+	inode->i_mode = mode;
+	retval = ext4_xattr_set_handle(handle, inode, name_index, "",
+				       value, size, 0);
+	kfree(value);
+	if (retval)
+		return retval;
+
+	set_cached_richacl(inode, acl);
+
+	return 0;
+}
+
+int
+ext4_set_richacl(struct inode *inode, struct richacl *acl)
+{
+	handle_t *handle;
+	int retval, retries = 0;
+
+retry:
+	handle = ext4_journal_start(inode, EXT4_HT_XATTR,
+				    ext4_jbd2_credits_xattr(inode));
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	if (acl)
+		retval = __ext4_set_richacl(handle, inode, acl);
+	else
+		retval = __ext4_remove_richacl(handle, inode);
+
+	ext4_journal_stop(handle);
+	if (retval == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+	return retval;
+}
+
+int
+ext4_init_richacl(handle_t *handle, struct inode *inode, struct inode *dir)
+{
+	struct richacl *acl = richacl_create(&inode->i_mode, dir);
+	int error;
+
+	error = PTR_ERR(acl);
+	if (!IS_ERR_OR_NULL(acl)) {
+		error = __ext4_set_richacl(handle, inode, acl);
+		richacl_put(acl);
+	}
+	return error;
+}
diff --git a/fs/ext4/richacl.h b/fs/ext4/richacl.h
new file mode 100644
index 0000000..6fe9a92
--- /dev/null
+++ b/fs/ext4/richacl.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Copyright (C)  2015 Red Hat, Inc.
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#ifndef __FS_EXT4_RICHACL_H
+#define __FS_EXT4_RICHACL_H
+
+#include <linux/richacl.h>
+
+#ifdef CONFIG_EXT4_FS_RICHACL
+
+extern struct richacl *ext4_get_richacl(struct inode *);
+extern int ext4_set_richacl(struct inode *, struct richacl *);
+
+extern int ext4_init_richacl(handle_t *, struct inode *, struct inode *);
+
+#else  /* CONFIG_EXT4_FS_RICHACL */
+
+#define ext4_get_richacl NULL
+#define ext4_set_richacl NULL
+
+static inline int
+ext4_init_richacl(handle_t *handle, struct inode *inode, struct inode *dir)
+{
+	return 0;
+}
+
+#endif  /* CONFIG_EXT4_FS_RICHACL */
+#endif  /* __FS_EXT4_RICHACL_H */
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5a94fa52..0f8cf0ff 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -55,6 +55,7 @@
 #include <linux/slab.h>
 #include <linux/mbcache.h>
 #include <linux/quotaops.h>
+#include <linux/richacl_xattr.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
 #include "xattr.h"
@@ -91,6 +92,9 @@ static const struct xattr_handler *ext4_xattr_handler_map[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	[EXT4_XATTR_INDEX_SECURITY]	     = &ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	[EXT4_XATTR_INDEX_RICHACL]           = &richacl_xattr_handler,
+#endif
 };
 
 const struct xattr_handler *ext4_xattr_handlers[] = {
@@ -103,6 +107,9 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	&ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	&richacl_xattr_handler,
+#endif
 	NULL
 };
 
diff --git a/include/linux/acl.h b/include/linux/acl.h
new file mode 100644
index 0000000..3c3b5ce
--- /dev/null
+++ b/include/linux/acl.h
@@ -0,0 +1,15 @@
+#ifndef __LINUX_ACL_H
+#define __LINUX_ACL_H
+
+#include <linux/posix_acl.h>
+#include <linux/richacl.h>
+
+static inline int
+acl_chmod(struct inode *inode)
+{
+	if (IS_RICHACL(inode))
+		return richacl_chmod(inode, inode->i_mode);
+	return posix_acl_chmod(inode, inode->i_mode);
+}
+
+#endif
-- 
2.7.4

