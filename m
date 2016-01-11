Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAEAA29DFE
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 09:24:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF3058F8040
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 07:24:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h7irRA52WtGtAllL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 07:24:03 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v17 18/22] richacl: xattr mapping functions
Date: Mon, 11 Jan 2016 16:21:49 +0100
Message-Id: <1452525713-11348-19-git-send-email-agruenba@redhat.com>
In-Reply-To: <1452525713-11348-1-git-send-email-agruenba@redhat.com>
References: <1452525713-11348-1-git-send-email-agruenba@redhat.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Map between "system.richacl" xattrs and the in-kernel representation.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/Makefile                        |   2 +-
 fs/richacl_xattr.c                 | 162 +++++++++++++++++++++++++++++++++++++
 fs/xattr.c                         |  29 +++++--
 include/linux/richacl_xattr.h      |  29 +++++++
 include/uapi/linux/Kbuild          |   1 +
 include/uapi/linux/richacl_xattr.h |  44 ++++++++++
 include/uapi/linux/xattr.h         |   2 +
 7 files changed, 262 insertions(+), 7 deletions(-)
 create mode 100644 fs/richacl_xattr.c
 create mode 100644 include/linux/richacl_xattr.h
 create mode 100644 include/uapi/linux/richacl_xattr.h

diff --git a/fs/Makefile b/fs/Makefile
index d5b45ca..2d6d224 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_SYSCTL)		+= drop_caches.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
 obj-$(CONFIG_FS_RICHACL)	+= richacl.o
-richacl-y			:= richacl_base.o richacl_inode.o
+richacl-y			:= richacl_base.o richacl_inode.o richacl_xattr.o
 
 obj-y				+= quota/
 
diff --git a/fs/richacl_xattr.c b/fs/richacl_xattr.c
new file mode 100644
index 0000000..a273139
--- /dev/null
+++ b/fs/richacl_xattr.c
@@ -0,0 +1,162 @@
+/*
+ * Copyright (C) 2006, 2010  Novell, Inc.
+ * Copyright (C) 2015  Red Hat, Inc.
+ * Written by Andreas Gruenbacher <agruenba@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/richacl_xattr.h>
+
+MODULE_LICENSE("GPL");
+
+/**
+ * richacl_from_xattr  -  convert a richacl xattr into the in-memory representation
+ */
+struct richacl *
+richacl_from_xattr(struct user_namespace *user_ns,
+		   const void *value, size_t size)
+{
+	const struct richacl_xattr *xattr_acl = value;
+	const struct richace_xattr *xattr_ace = (void *)(xattr_acl + 1);
+	struct richacl *acl;
+	struct richace *ace;
+	int count;
+
+	if (size < sizeof(*xattr_acl) ||
+	    xattr_acl->a_version != RICHACL_XATTR_VERSION ||
+	    (xattr_acl->a_flags & ~RICHACL_VALID_FLAGS))
+		return ERR_PTR(-EINVAL);
+	size -= sizeof(*xattr_acl);
+	count = le16_to_cpu(xattr_acl->a_count);
+	if (count > RICHACL_XATTR_MAX_COUNT)
+		return ERR_PTR(-EINVAL);
+	if (size != count * sizeof(*xattr_ace))
+		return ERR_PTR(-EINVAL);
+
+	acl = richacl_alloc(count, GFP_NOFS);
+	if (!acl)
+		return ERR_PTR(-ENOMEM);
+
+	acl->a_flags = xattr_acl->a_flags;
+	acl->a_owner_mask = le32_to_cpu(xattr_acl->a_owner_mask);
+	if (acl->a_owner_mask & ~RICHACE_VALID_MASK)
+		goto fail_einval;
+	acl->a_group_mask = le32_to_cpu(xattr_acl->a_group_mask);
+	if (acl->a_group_mask & ~RICHACE_VALID_MASK)
+		goto fail_einval;
+	acl->a_other_mask = le32_to_cpu(xattr_acl->a_other_mask);
+	if (acl->a_other_mask & ~RICHACE_VALID_MASK)
+		goto fail_einval;
+
+	richacl_for_each_entry(ace, acl) {
+		ace->e_type  = le16_to_cpu(xattr_ace->e_type);
+		ace->e_flags = le16_to_cpu(xattr_ace->e_flags);
+		ace->e_mask  = le32_to_cpu(xattr_ace->e_mask);
+
+		if (ace->e_flags & ~RICHACE_VALID_FLAGS)
+			goto fail_einval;
+		if (ace->e_flags & RICHACE_SPECIAL_WHO) {
+			ace->e_id.special = le32_to_cpu(xattr_ace->e_id);
+			if (ace->e_id.special > RICHACE_EVERYONE_SPECIAL_ID)
+				goto fail_einval;
+		} else if (ace->e_flags & RICHACE_IDENTIFIER_GROUP) {
+			u32 id = le32_to_cpu(xattr_ace->e_id);
+
+			ace->e_id.gid = make_kgid(user_ns, id);
+			if (!gid_valid(ace->e_id.gid))
+				goto fail_einval;
+		} else {
+			u32 id = le32_to_cpu(xattr_ace->e_id);
+
+			ace->e_id.uid = make_kuid(user_ns, id);
+			if (!uid_valid(ace->e_id.uid))
+				goto fail_einval;
+		}
+		if (ace->e_type > RICHACE_ACCESS_DENIED_ACE_TYPE ||
+		    (ace->e_mask & ~RICHACE_VALID_MASK))
+			goto fail_einval;
+
+		xattr_ace++;
+	}
+
+	return acl;
+
+fail_einval:
+	richacl_put(acl);
+	return ERR_PTR(-EINVAL);
+}
+EXPORT_SYMBOL_GPL(richacl_from_xattr);
+
+/**
+ * richacl_xattr_size  -  compute the size of the xattr representation of @acl
+ */
+size_t
+richacl_xattr_size(const struct richacl *acl)
+{
+	size_t size = sizeof(struct richacl_xattr);
+
+	size += sizeof(struct richace_xattr) * acl->a_count;
+	return size;
+}
+EXPORT_SYMBOL_GPL(richacl_xattr_size);
+
+/**
+ * richacl_to_xattr  -  convert @acl into its xattr representation
+ * @acl:	the richacl to convert
+ * @buffer:	buffer for the result
+ * @size:	size of @buffer
+ */
+int
+richacl_to_xattr(struct user_namespace *user_ns,
+		 const struct richacl *acl, void *buffer, size_t size)
+{
+	struct richacl_xattr *xattr_acl = buffer;
+	struct richace_xattr *xattr_ace;
+	const struct richace *ace;
+	size_t real_size;
+
+	real_size = richacl_xattr_size(acl);
+	if (!buffer)
+		return real_size;
+	if (real_size > size)
+		return -ERANGE;
+
+	xattr_acl->a_version = RICHACL_XATTR_VERSION;
+	xattr_acl->a_flags = acl->a_flags;
+	xattr_acl->a_count = cpu_to_le16(acl->a_count);
+
+	xattr_acl->a_owner_mask = cpu_to_le32(acl->a_owner_mask);
+	xattr_acl->a_group_mask = cpu_to_le32(acl->a_group_mask);
+	xattr_acl->a_other_mask = cpu_to_le32(acl->a_other_mask);
+
+	xattr_ace = (void *)(xattr_acl + 1);
+	richacl_for_each_entry(ace, acl) {
+		xattr_ace->e_type = cpu_to_le16(ace->e_type);
+		xattr_ace->e_flags = cpu_to_le16(ace->e_flags);
+		xattr_ace->e_mask = cpu_to_le32(ace->e_mask);
+		if (ace->e_flags & RICHACE_SPECIAL_WHO)
+			xattr_ace->e_id = cpu_to_le32(ace->e_id.special);
+		else if (ace->e_flags & RICHACE_IDENTIFIER_GROUP)
+			xattr_ace->e_id =
+				cpu_to_le32(from_kgid(user_ns, ace->e_id.gid));
+		else
+			xattr_ace->e_id =
+				cpu_to_le32(from_kuid(user_ns, ace->e_id.uid));
+		xattr_ace++;
+	}
+	return real_size;
+}
+EXPORT_SYMBOL_GPL(richacl_to_xattr);
diff --git a/fs/xattr.c b/fs/xattr.c
index d7f5037..58df156 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -295,6 +295,16 @@ out:
 }
 EXPORT_SYMBOL_GPL(vfs_removexattr);
 
+static void
+fix_xattr_from_user(const char *kname, void *kvalue, size_t size)
+{
+	if (strncmp(kname, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return;
+	kname += XATTR_SYSTEM_PREFIX_LEN;
+	if (!strcmp(kname, XATTR_POSIX_ACL_ACCESS) ||
+	    !strcmp(kname, XATTR_POSIX_ACL_DEFAULT))
+		posix_acl_fix_xattr_from_user(kvalue, size);
+}
 
 /*
  * Extended attribute SET operations
@@ -331,9 +341,7 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
 			error = -EFAULT;
 			goto out;
 		}
-		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(kvalue, size);
+		fix_xattr_from_user(kname, kvalue, size);
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
@@ -400,6 +408,17 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 	return error;
 }
 
+static void
+fix_xattr_to_user(const char *kname, void *kvalue, size_t size)
+{
+	if (strncmp(kname, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return;
+	kname += XATTR_SYSTEM_PREFIX_LEN;
+	if (!strcmp(kname, XATTR_POSIX_ACL_ACCESS) ||
+	    !strcmp(kname, XATTR_POSIX_ACL_DEFAULT))
+		posix_acl_fix_xattr_to_user(kvalue, size);
+}
+
 /*
  * Extended attribute GET operations
  */
@@ -432,9 +451,7 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 
 	error = vfs_getxattr(d, kname, kvalue, size);
 	if (error > 0) {
-		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_to_user(kvalue, size);
+		fix_xattr_to_user(kname, kvalue, size);
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
 	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
diff --git a/include/linux/richacl_xattr.h b/include/linux/richacl_xattr.h
new file mode 100644
index 0000000..ab67af2
--- /dev/null
+++ b/include/linux/richacl_xattr.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2006, 2010  Novell, Inc.
+ * Copyright (C) 2015  Red Hat, Inc.
+ * Written by Andreas Gruenbacher <agruenba@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __RICHACL_XATTR_H
+#define __RICHACL_XATTR_H
+
+#include <uapi/linux/richacl_xattr.h>
+#include <linux/richacl.h>
+
+extern struct richacl *richacl_from_xattr(struct user_namespace *, const void *,
+					  size_t);
+extern size_t richacl_xattr_size(const struct richacl *);
+extern int richacl_to_xattr(struct user_namespace *, const struct richacl *,
+			    void *, size_t);
+
+#endif /* __RICHACL_XATTR_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 55699fa..f45190f 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -351,6 +351,7 @@ header-y += reiserfs_fs.h
 header-y += reiserfs_xattr.h
 header-y += resource.h
 header-y += richacl.h
+header-y += richacl_xattr.h
 header-y += rfkill.h
 header-y += romfs_fs.h
 header-y += rose.h
diff --git a/include/uapi/linux/richacl_xattr.h b/include/uapi/linux/richacl_xattr.h
new file mode 100644
index 0000000..5178ca6
--- /dev/null
+++ b/include/uapi/linux/richacl_xattr.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2006, 2010  Novell, Inc.
+ * Copyright (C) 2015  Red Hat, Inc.
+ * Written by Andreas Gruenbacher <agruenba@redhat.com>
+ *
+ * This file is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; either
+ * version 2.1 of the License, or (at your option) any later version.
+ *
+ * This file is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ */
+
+#ifndef __UAPI_RICHACL_XATTR_H
+#define __UAPI_RICHACL_XATTR_H
+
+#include <linux/types.h>
+#include <linux/limits.h>
+
+struct richace_xattr {
+	__le16		e_type;
+	__le16		e_flags;
+	__le32		e_mask;
+	__le32		e_id;
+};
+
+struct richacl_xattr {
+	unsigned char	a_version;
+	unsigned char	a_flags;
+	__le16		a_count;
+	__le32		a_owner_mask;
+	__le32		a_group_mask;
+	__le32		a_other_mask;
+};
+
+#define RICHACL_XATTR_VERSION 0
+#define RICHACL_XATTR_MAX_COUNT \
+	((XATTR_SIZE_MAX - sizeof(struct richacl_xattr)) / \
+	 sizeof(struct richace_xattr))
+
+#endif  /* __UAPI_RICHACL_XATTR_H */
diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index 1590c49..1996903 100644
--- a/include/uapi/linux/xattr.h
+++ b/include/uapi/linux/xattr.h
@@ -73,5 +73,7 @@
 #define XATTR_POSIX_ACL_DEFAULT  "posix_acl_default"
 #define XATTR_NAME_POSIX_ACL_DEFAULT XATTR_SYSTEM_PREFIX XATTR_POSIX_ACL_DEFAULT
 
+#define XATTR_RICHACL "richacl"
+#define XATTR_NAME_RICHACL XATTR_SYSTEM_PREFIX XATTR_RICHACL
 
 #endif /* _UAPI_LINUX_XATTR_H */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
