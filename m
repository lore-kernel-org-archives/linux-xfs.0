Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F1DF7F58
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:01:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D61648F804B
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 16:01:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hT68jiXiyHVQynaD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2015 16:01:30 -0700 (PDT)
From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: [PATCH v10 20/46] ext4: Add richacl support
Date: Mon, 12 Oct 2015 00:58:31 +0200
Message-Id: <1444604337-17651-21-git-send-email-andreas.gruenbacher@gmail.com>
In-Reply-To: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andreas Gruenbacher <agruenba@redhat.com>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Support the richacl permission model in ext4.  The richacls are stored
in "system.richacl" xattrs.  Richacls need to be enabled by tune2fs or
at file system create time.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/ext4/Kconfig   |  11 +++++
 fs/ext4/Makefile  |   1 +
 fs/ext4/file.c    |   3 ++
 fs/ext4/ialloc.c  |   7 ++-
 fs/ext4/inode.c   |  10 +++--
 fs/ext4/namei.c   |   5 +++
 fs/ext4/richacl.c | 129 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/richacl.h |  43 ++++++++++++++++++
 fs/ext4/xattr.c   |   7 +++
 9 files changed, 212 insertions(+), 4 deletions(-)
 create mode 100644 fs/ext4/richacl.c
 create mode 100644 fs/ext4/richacl.h

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 47728da..3ec0843 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -22,6 +22,17 @@ config EXT3_FS_POSIX_ACL
 	  This config option is here only for backward compatibility. ext3
 	  filesystem is now handled by the ext4 driver.
 
+config EXT4_FS_RICHACL
+	bool "Ext4 Rich Access Control Lists (EXPERIMENTAL)"
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
index 75285ea..ea0d539 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -14,3 +14,4 @@ ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
 ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+= crypto_policy.o crypto.o \
 		crypto_key.o crypto_fname.o
+ext4-$(CONFIG_EXT4_FS_RICHACL) 		+= richacl.o
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 113837e..a03b4a5 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -30,6 +30,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 /*
  * Called when an inode is released. Note that this is different
@@ -719,6 +720,8 @@ const struct inode_operations ext4_file_inode_operations = {
 	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_richacl	= ext4_get_richacl,
+	.set_richacl	= ext4_set_richacl,
 	.fiemap		= ext4_fiemap,
 };
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 619bfc1..f279725 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -27,6 +27,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -1052,7 +1053,11 @@ got:
 	if (err)
 		goto fail_drop;
 
-	err = ext4_init_acl(handle, inode, dir);
+	if (EXT4_IS_RICHACL(dir))
+		err = ext4_init_richacl(handle, inode, dir);
+	else
+		err = ext4_init_acl(handle, inode, dir);
+
 	if (err)
 		goto fail_free_drop;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 612fbcf..d8a48a3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -42,6 +42,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "truncate.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -4805,9 +4806,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (orphan && inode->i_nlink)
 		ext4_orphan_del(NULL, inode);
 
-	if (!rc && (ia_valid & ATTR_MODE))
-		rc = posix_acl_chmod(inode, inode->i_mode);
-
+	if (!rc && (ia_valid & ATTR_MODE)) {
+		if (EXT4_IS_RICHACL(inode))
+			rc = richacl_chmod(inode, inode->i_mode);
+		else
+			rc = posix_acl_chmod(inode, inode->i_mode);
+	}
 err_out:
 	ext4_std_error(inode->i_sb, error);
 	if (!error)
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9f61e76..9b6e8b9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -38,6 +38,7 @@
 
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 /*
@@ -3854,6 +3855,8 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_richacl	= ext4_get_richacl,
+	.set_richacl	= ext4_set_richacl,
 	.fiemap         = ext4_fiemap,
 };
 
@@ -3865,4 +3868,6 @@ const struct inode_operations ext4_special_inode_operations = {
 	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_richacl	= ext4_get_richacl,
+	.set_richacl	= ext4_set_richacl,
 };
diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
new file mode 100644
index 0000000..b46ac60
--- /dev/null
+++ b/fs/ext4/richacl.c
@@ -0,0 +1,129 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Copyright (C) 2015  Red Hat, Inc.
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
+	struct richacl *acl;
+	int retval;
+
+	retval = ext4_xattr_get(inode, name_index, "", NULL, 0);
+	if (retval > 0) {
+		value = kmalloc(retval, GFP_NOFS);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		retval = ext4_xattr_get(inode, name_index, "", value, retval);
+	}
+	if (retval > 0) {
+		acl = richacl_from_xattr(&init_user_ns, value, retval);
+		if (acl == ERR_PTR(-EINVAL))
+			acl = ERR_PTR(-EIO);
+	} else if (retval == -ENODATA || retval == -ENOSYS)
+		acl = NULL;
+	else
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
+__ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
+{
+	const int name_index = EXT4_XATTR_INDEX_RICHACL;
+	umode_t mode = inode->i_mode;
+	int retval;
+
+	if (acl) {
+		if (richacl_equiv_mode(acl, &mode) == 0) {
+			inode->i_ctime = ext4_current_time(inode);
+			inode->i_mode = mode;
+			ext4_mark_inode_dirty(handle, inode);
+			acl = NULL;
+		}
+	}
+	if (acl) {
+		void *value;
+		size_t size = richacl_xattr_size(acl);
+
+		mode &= ~S_IRWXUGO;
+		mode |= richacl_masks_to_mode(acl);
+
+		value = kmalloc(size, GFP_NOFS);
+		if (!value)
+			return -ENOMEM;
+		richacl_to_xattr(&init_user_ns, acl, value, size);
+		inode->i_mode = mode;
+		retval = ext4_xattr_set_handle(handle, inode, name_index, "",
+					       value, size, 0);
+		kfree(value);
+	} else
+		retval = ext4_xattr_set_handle(handle, inode, name_index, "",
+					       NULL, 0, 0);
+	if (!retval)
+		set_cached_richacl(inode, acl);
+
+	return retval;
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
+	retval = __ext4_set_richacl(handle, inode, acl);
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
+	if (IS_ERR(acl))
+		return error;
+	if (acl) {
+		error = __ext4_set_richacl(handle, inode, acl);
+		richacl_put(acl);
+	}
+	return error;
+}
diff --git a/fs/ext4/richacl.h b/fs/ext4/richacl.h
new file mode 100644
index 0000000..fc7826f
--- /dev/null
+++ b/fs/ext4/richacl.h
@@ -0,0 +1,43 @@
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
+#define EXT4_IS_RICHACL(inode) IS_RICHACL(inode)
+
+extern struct richacl *ext4_get_richacl(struct inode *);
+extern int ext4_set_richacl(struct inode *, struct richacl *);
+
+extern int ext4_init_richacl(handle_t *, struct inode *, struct inode *);
+
+#else  /* CONFIG_EXT4_FS_RICHACL */
+
+#define EXT4_IS_RICHACL(inode) (0)
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
index 16e28c0..4d79adb 100644
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
@@ -99,6 +100,9 @@ static const struct xattr_handler *ext4_xattr_handler_map[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	[EXT4_XATTR_INDEX_SECURITY]	     = &ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	[EXT4_XATTR_INDEX_RICHACL]           = &richacl_xattr_handler,
+#endif
 };
 
 const struct xattr_handler *ext4_xattr_handlers[] = {
@@ -111,6 +115,9 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	&ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	&richacl_xattr_handler,
+#endif
 	NULL
 };
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
