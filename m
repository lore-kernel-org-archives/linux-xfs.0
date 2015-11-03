Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1335729E1E
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 09:19:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71DCEAC002
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:19:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UeIfUm6BHnIMXjQN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 07:19:34 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v13 17/51] richacl: xattr mapping functions
Date: Tue,  3 Nov 2015 16:16:53 +0100
Message-Id: <1446563847-14005-18-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
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
 fs/richacl_xattr.c                 | 220 +++++++++++++++++++++++++++++++++++++
 fs/xattr.c                         |  34 +++++-
 include/linux/richacl_xattr.h      |  42 +++++++
 include/uapi/linux/Kbuild          |   1 +
 include/uapi/linux/richacl_xattr.h |  44 ++++++++
 include/uapi/linux/xattr.h         |   2 +
 7 files changed, 338 insertions(+), 7 deletions(-)
 create mode 100644 fs/richacl_xattr.c
 create mode 100644 include/linux/richacl_xattr.h
 create mode 100644 include/uapi/linux/richacl_xattr.h

diff --git a/fs/Makefile b/fs/Makefile
index ec665fd..35e640d 100644
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
index 0000000..38473b6
--- /dev/null
+++ b/fs/richacl_xattr.c
@@ -0,0 +1,220 @@
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
+
+/*
+ * Fix up the uids and gids in richacl extended attributes in place.
+ */
+static void richacl_fix_xattr_userns(
+	struct user_namespace *to, struct user_namespace *from,
+	void *value, size_t size)
+{
+	struct richacl_xattr *xattr_acl = value;
+	struct richace_xattr *xattr_ace =
+		(struct richace_xattr *)(xattr_acl + 1);
+	unsigned int count;
+
+	if (!value)
+		return;
+	if (size < sizeof(*xattr_acl))
+		return;
+	if (xattr_acl->a_version != cpu_to_le32(RICHACL_XATTR_VERSION))
+		return;
+	size -= sizeof(*xattr_acl);
+	if (size % sizeof(*xattr_ace))
+		return;
+	count = size / sizeof(*xattr_ace);
+	for (; count; count--, xattr_ace++) {
+		if (xattr_ace->e_flags & cpu_to_le16(RICHACE_SPECIAL_WHO))
+			continue;
+		if (xattr_ace->e_flags &
+		    cpu_to_le16(RICHACE_IDENTIFIER_GROUP)) {
+			u32 id = le32_to_cpu(xattr_ace->e_id);
+			kgid_t gid = make_kgid(from, id);
+
+			xattr_ace->e_id = cpu_to_le32(from_kgid(to, gid));
+		} else {
+			u32 id = le32_to_cpu(xattr_ace->e_id);
+			kuid_t uid = make_kuid(from, id);
+
+			xattr_ace->e_id = cpu_to_le32(from_kuid(to, uid));
+		}
+	}
+}
+
+void richacl_fix_xattr_from_user(void *value, size_t size)
+{
+	struct user_namespace *user_ns = current_user_ns();
+
+	if (user_ns == &init_user_ns)
+		return;
+	richacl_fix_xattr_userns(&init_user_ns, user_ns, value, size);
+}
+
+void richacl_fix_xattr_to_user(void *value, size_t size)
+{
+	struct user_namespace *user_ns = current_user_ns();
+
+	if (user_ns == &init_user_ns)
+		return;
+	richacl_fix_xattr_userns(user_ns, &init_user_ns, value, size);
+}
diff --git a/fs/xattr.c b/fs/xattr.c
index 072fee1..f2313c6 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/vmalloc.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/richacl_xattr.h>
 
 #include <asm/uaccess.h>
 
@@ -314,6 +315,18 @@ out:
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
+	else if (!strcmp(kname, XATTR_RICHACL))
+		richacl_fix_xattr_from_user(kvalue, size);
+}
 
 /*
  * Extended attribute SET operations
@@ -350,9 +363,7 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
 			error = -EFAULT;
 			goto out;
 		}
-		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(kvalue, size);
+		fix_xattr_from_user(kname, kvalue, size);
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
@@ -419,6 +430,19 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
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
+	else if (!strcmp(kname, XATTR_RICHACL))
+		richacl_fix_xattr_to_user(kvalue, size);
+}
+
 /*
  * Extended attribute GET operations
  */
@@ -451,9 +475,7 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 
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
index 0000000..7fc5ca8
--- /dev/null
+++ b/include/linux/richacl_xattr.h
@@ -0,0 +1,42 @@
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
+#ifdef CONFIG_FS_RICHACL
+extern void richacl_fix_xattr_from_user(void *, size_t);
+extern void richacl_fix_xattr_to_user(void *, size_t);
+#else
+static inline void richacl_fix_xattr_from_user(void *value, size_t size)
+{
+}
+
+static inline void richacl_fix_xattr_to_user(void *value, size_t size)
+{
+}
+#endif
+
+#endif /* __RICHACL_XATTR_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 8c82010..18ad070 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -349,6 +349,7 @@ header-y += reiserfs_fs.h
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
