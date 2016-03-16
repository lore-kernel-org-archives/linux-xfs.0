Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F68C7CB1
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 17:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7EDC6AC005
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 15:20:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GDrkHlkFy5wuMSGM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 15:20:45 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v20 22/23] ext4: Add richacl support
Date: Wed, 16 Mar 2016 23:19:02 +0100
Message-Id: <1458166743-18488-23-git-send-email-agruenba@redhat.com>
In-Reply-To: <1458166743-18488-1-git-send-email-agruenba@redhat.com>
References: <1458166743-18488-1-git-send-email-agruenba@redhat.com>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

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
 fs/ext4/inode.c     |   5 +-
 fs/ext4/namei.c     |   5 ++
 fs/ext4/richacl.c   | 137 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/richacl.h   |  40 +++++++++++++++
 fs/ext4/xattr.c     |   7 +++
 include/linux/acl.h |  15 ++++++
 10 files changed, 231 insertions(+), 4 deletions(-)
 create mode 100644 fs/ext4/richacl.c
 create mode 100644 fs/ext4/richacl.h
 create mode 100644 include/linux/acl.h

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index b46e9fc..4e21c18 100644
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
index f52cf54..1fb7f11 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -14,3 +14,4 @@ ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
 ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+= crypto_policy.o crypto.o \
 		crypto_key.o crypto_fname.o
+ext4-$(CONFIG_EXT4_FS_RICHACL) 		+= richacl.o
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 4cd318f..92e35bc 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -30,6 +30,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 /*
  * Called when an inode is released. Note that this is different
@@ -749,6 +750,8 @@ const struct inode_operations ext4_file_inode_operations = {
 	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_richacl	= ext4_get_richacl,
+	.set_richacl	= ext4_set_richacl,
 	.fiemap		= ext4_fiemap,
 };
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index acc0ad5..f2d31c2 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -27,6 +27,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -729,6 +730,14 @@ out:
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
@@ -1093,7 +1102,7 @@ got:
 	if (err)
 		goto fail_drop;
 
-	err = ext4_init_acl(handle, inode, dir);
+	err = ext4_new_acl(handle, inode, dir);
 	if (err)
 		goto fail_free_drop;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index aee960b..1dbd4c2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -37,10 +37,10 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
+#include <linux/acl.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
-#include "acl.h"
 #include "truncate.h"
 
 #include <trace/events/ext4.h>
@@ -5025,8 +5025,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		ext4_orphan_del(NULL, inode);
 
 	if (!rc && (ia_valid & ATTR_MODE))
-		rc = posix_acl_chmod(inode, inode->i_mode);
-
+		rc = acl_chmod(inode);
 err_out:
 	ext4_std_error(inode->i_sb, error);
 	if (!error)
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 48e4b89..d86c5f2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -38,6 +38,7 @@
 
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 /*
@@ -3888,6 +3889,8 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_richacl	= ext4_get_richacl,
+	.set_richacl	= ext4_set_richacl,
 	.fiemap         = ext4_fiemap,
 };
 
@@ -3899,4 +3902,6 @@ const struct inode_operations ext4_special_inode_operations = {
 	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_richacl	= ext4_get_richacl,
+	.set_richacl	= ext4_set_richacl,
 };
diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
new file mode 100644
index 0000000..13a88e2
--- /dev/null
+++ b/fs/ext4/richacl.c
@@ -0,0 +1,137 @@
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
+	if (!IS_ERR(acl))
+		set_cached_richacl(inode, acl);
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
+		inode->i_ctime = ext4_current_time(inode);
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
index a95151e..ef76630 100644
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
@@ -97,6 +98,9 @@ static const struct xattr_handler *ext4_xattr_handler_map[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	[EXT4_XATTR_INDEX_SECURITY]	     = &ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	[EXT4_XATTR_INDEX_RICHACL]           = &richacl_xattr_handler,
+#endif
 };
 
 const struct xattr_handler *ext4_xattr_handlers[] = {
@@ -109,6 +113,9 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
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
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
