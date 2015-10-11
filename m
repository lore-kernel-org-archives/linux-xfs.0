Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4151729DF6
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:04:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 228B68F8040
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 16:04:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wyijx5DdTUpou4S7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2015 16:04:32 -0700 (PDT)
From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: [PATCH v10 46/46] richacl: uapi header split
Date: Mon, 12 Oct 2015 00:58:57 +0200
Message-Id: <1444604337-17651-47-git-send-email-andreas.gruenbacher@gmail.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>

From: Andreas Gruenbacher <agruenba@redhat.com>

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/richacl.h            | 119 +++++--------------------------------
 include/linux/richacl_xattr.h      |  17 +-----
 include/uapi/linux/Kbuild          |   2 +
 include/uapi/linux/richacl.h       | 111 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/richacl_xattr.h |  43 ++++++++++++++
 5 files changed, 173 insertions(+), 119 deletions(-)
 create mode 100644 include/uapi/linux/richacl.h
 create mode 100644 include/uapi/linux/richacl_xattr.h

diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 95f22e5..de0b327 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -17,9 +17,7 @@
 #ifndef __RICHACL_H
 #define __RICHACL_H
 
-#define RICHACE_OWNER_SPECIAL_ID	0
-#define RICHACE_GROUP_SPECIAL_ID	1
-#define RICHACE_EVERYONE_SPECIAL_ID	2
+#include <uapi/linux/richacl.h>
 
 struct richace {
 	unsigned short	e_type;
@@ -44,43 +42,12 @@ struct richacl {
 	struct richace	a_entries[0];
 };
 
-#define richacl_for_each_entry(_ace, _acl) \
-	for (_ace = (_acl)->a_entries; \
-	     _ace != (_acl)->a_entries + (_acl)->a_count; \
-	     _ace++)
-
-#define richacl_for_each_entry_reverse(_ace, _acl) \
-	for (_ace = (_acl)->a_entries + (_acl)->a_count - 1; \
-	     _ace != (_acl)->a_entries - 1; \
-	     _ace--)
-
-/* a_flags values */
-#define RICHACL_AUTO_INHERIT			0x01
-#define RICHACL_PROTECTED			0x02
-#define RICHACL_DEFAULTED			0x04
-#define RICHACL_WRITE_THROUGH			0x40
-#define RICHACL_MASKED				0x80
-
 #define RICHACL_VALID_FLAGS (					\
-		RICHACL_AUTO_INHERIT |				\
-		RICHACL_PROTECTED |				\
-		RICHACL_DEFAULTED |				\
-		RICHACL_WRITE_THROUGH |				\
-		RICHACL_MASKED)
-
-/* e_type values */
-#define RICHACE_ACCESS_ALLOWED_ACE_TYPE		0x0000
-#define RICHACE_ACCESS_DENIED_ACE_TYPE		0x0001
-
-/* e_flags bitflags */
-#define RICHACE_FILE_INHERIT_ACE		0x0001
-#define RICHACE_DIRECTORY_INHERIT_ACE		0x0002
-#define RICHACE_NO_PROPAGATE_INHERIT_ACE	0x0004
-#define RICHACE_INHERIT_ONLY_ACE		0x0008
-#define RICHACE_IDENTIFIER_GROUP		0x0040
-#define RICHACE_INHERITED_ACE			0x0080
-#define RICHACE_UNMAPPED_WHO			0x2000
-#define RICHACE_SPECIAL_WHO			0x4000
+	RICHACL_AUTO_INHERIT |					\
+	RICHACL_PROTECTED |					\
+	RICHACL_DEFAULTED |					\
+	RICHACL_WRITE_THROUGH |					\
+	RICHACL_MASKED)
 
 #define RICHACE_VALID_FLAGS (					\
 	RICHACE_FILE_INHERIT_ACE |				\
@@ -99,27 +66,6 @@ struct richacl {
 	RICHACE_INHERIT_ONLY_ACE |				\
 	RICHACE_INHERITED_ACE )
 
-/* e_mask bitflags */
-#define RICHACE_READ_DATA			0x00000001
-#define RICHACE_LIST_DIRECTORY			0x00000001
-#define RICHACE_WRITE_DATA			0x00000002
-#define RICHACE_ADD_FILE			0x00000002
-#define RICHACE_APPEND_DATA			0x00000004
-#define RICHACE_ADD_SUBDIRECTORY		0x00000004
-#define RICHACE_READ_NAMED_ATTRS		0x00000008
-#define RICHACE_WRITE_NAMED_ATTRS		0x00000010
-#define RICHACE_EXECUTE				0x00000020
-#define RICHACE_DELETE_CHILD			0x00000040
-#define RICHACE_READ_ATTRIBUTES			0x00000080
-#define RICHACE_WRITE_ATTRIBUTES		0x00000100
-#define RICHACE_WRITE_RETENTION			0x00000200
-#define RICHACE_WRITE_RETENTION_HOLD		0x00000400
-#define RICHACE_DELETE				0x00010000
-#define RICHACE_READ_ACL			0x00020000
-#define RICHACE_WRITE_ACL			0x00040000
-#define RICHACE_WRITE_OWNER			0x00080000
-#define RICHACE_SYNCHRONIZE			0x00100000
-
 /* Valid RICHACE_* flags for directories and non-directories */
 #define RICHACE_VALID_MASK (					\
 	RICHACE_READ_DATA | RICHACE_LIST_DIRECTORY |		\
@@ -139,49 +85,16 @@ struct richacl {
 	RICHACE_WRITE_OWNER |					\
 	RICHACE_SYNCHRONIZE)
 
-/*
- * The POSIX permissions are supersets of the following NFSv4 permissions:
- *
- *  - MAY_READ maps to READ_DATA or LIST_DIRECTORY, depending on the type
- *    of the file system object.
- *
- *  - MAY_WRITE maps to WRITE_DATA or RICHACE_APPEND_DATA for files, and to
- *    ADD_FILE, RICHACE_ADD_SUBDIRECTORY, or RICHACE_DELETE_CHILD for directories.
- *
- *  - MAY_EXECUTE maps to RICHACE_EXECUTE.
- *
- *  (Some of these NFSv4 permissions have the same bit values.)
- */
-#define RICHACE_POSIX_MODE_READ (			\
-		RICHACE_READ_DATA |		\
-		RICHACE_LIST_DIRECTORY)
-#define RICHACE_POSIX_MODE_WRITE (			\
-		RICHACE_WRITE_DATA |		\
-		RICHACE_ADD_FILE |			\
-		RICHACE_APPEND_DATA |		\
-		RICHACE_ADD_SUBDIRECTORY |		\
-		RICHACE_DELETE_CHILD)
-#define RICHACE_POSIX_MODE_EXEC RICHACE_EXECUTE
-#define RICHACE_POSIX_MODE_ALL (			\
-		RICHACE_POSIX_MODE_READ |		\
-		RICHACE_POSIX_MODE_WRITE |		\
-		RICHACE_POSIX_MODE_EXEC)
-/*
- * These permissions are always allowed
- * no matter what the acl says.
- */
-#define RICHACE_POSIX_ALWAYS_ALLOWED (	\
-		RICHACE_SYNCHRONIZE |	\
-		RICHACE_READ_ATTRIBUTES |	\
-		RICHACE_READ_ACL)
-/*
- * The owner is implicitly granted
- * these permissions under POSIX.
- */
-#define RICHACE_POSIX_OWNER_ALLOWED (		\
-		RICHACE_WRITE_ATTRIBUTES |		\
-		RICHACE_WRITE_OWNER |		\
-		RICHACE_WRITE_ACL)
+#define richacl_for_each_entry(_ace, _acl) \
+	for (_ace = (_acl)->a_entries; \
+	     _ace != (_acl)->a_entries + (_acl)->a_count; \
+	     _ace++)
+
+#define richacl_for_each_entry_reverse(_ace, _acl) \
+	for (_ace = (_acl)->a_entries + (_acl)->a_count - 1; \
+	     _ace != (_acl)->a_entries - 1; \
+	     _ace--)
+
 /**
  * richacl_get  -  grab another reference to a richacl handle
  */
diff --git a/include/linux/richacl_xattr.h b/include/linux/richacl_xattr.h
index dac4e32..4ba54bd 100644
--- a/include/linux/richacl_xattr.h
+++ b/include/linux/richacl_xattr.h
@@ -17,24 +17,9 @@
 #ifndef __RICHACL_XATTR_H
 #define __RICHACL_XATTR_H
 
+#include <uapi/linux/richacl_xattr.h>
 #include <linux/richacl.h>
 
-struct richace_xattr {
-	__le16		e_type;
-	__le16		e_flags;
-	__le32		e_mask;
-	__le32		e_id;
-};
-
-struct richacl_xattr {
-	unsigned char	a_version;
-	unsigned char	a_flags;
-	__le16		a_count;
-	__le32		a_owner_mask;
-	__le32		a_group_mask;
-	__le32		a_other_mask;
-};
-
 #define RICHACL_XATTR_VERSION	0
 #define RICHACL_XATTR_MAX_COUNT \
 	((XATTR_SIZE_MAX - sizeof(struct richacl_xattr)) / \
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index f7b2db4..18ad070 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -348,6 +348,8 @@ header-y += reboot.h
 header-y += reiserfs_fs.h
 header-y += reiserfs_xattr.h
 header-y += resource.h
+header-y += richacl.h
+header-y += richacl_xattr.h
 header-y += rfkill.h
 header-y += romfs_fs.h
 header-y += rose.h
diff --git a/include/uapi/linux/richacl.h b/include/uapi/linux/richacl.h
new file mode 100644
index 0000000..6887f88
--- /dev/null
+++ b/include/uapi/linux/richacl.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright (C) 2006, 2010  Novell, Inc.
+ * Copyright (C) 2015  Red Hat, Inc.
+ * Written by Andreas Gruenbacher <agruen@kernel.org>
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
+#ifndef __UAPI_RICHACL_H
+#define __UAPI_RICHACL_H
+
+/* a_flags values */
+#define RICHACL_AUTO_INHERIT			0x01
+#define RICHACL_PROTECTED			0x02
+#define RICHACL_DEFAULTED			0x04
+#define RICHACL_WRITE_THROUGH			0x40
+#define RICHACL_MASKED				0x80
+
+/* e_type values */
+#define RICHACE_ACCESS_ALLOWED_ACE_TYPE		0x0000
+#define RICHACE_ACCESS_DENIED_ACE_TYPE		0x0001
+
+/* e_flags bitflags */
+#define RICHACE_FILE_INHERIT_ACE		0x0001
+#define RICHACE_DIRECTORY_INHERIT_ACE		0x0002
+#define RICHACE_NO_PROPAGATE_INHERIT_ACE	0x0004
+#define RICHACE_INHERIT_ONLY_ACE		0x0008
+#define RICHACE_IDENTIFIER_GROUP		0x0040
+#define RICHACE_INHERITED_ACE			0x0080
+#define RICHACE_UNMAPPED_WHO			0x2000
+#define RICHACE_SPECIAL_WHO			0x4000
+
+/* e_mask bitflags */
+#define RICHACE_READ_DATA			0x00000001
+#define RICHACE_LIST_DIRECTORY			0x00000001
+#define RICHACE_WRITE_DATA			0x00000002
+#define RICHACE_ADD_FILE			0x00000002
+#define RICHACE_APPEND_DATA			0x00000004
+#define RICHACE_ADD_SUBDIRECTORY		0x00000004
+#define RICHACE_READ_NAMED_ATTRS		0x00000008
+#define RICHACE_WRITE_NAMED_ATTRS		0x00000010
+#define RICHACE_EXECUTE				0x00000020
+#define RICHACE_DELETE_CHILD			0x00000040
+#define RICHACE_READ_ATTRIBUTES			0x00000080
+#define RICHACE_WRITE_ATTRIBUTES		0x00000100
+#define RICHACE_WRITE_RETENTION			0x00000200
+#define RICHACE_WRITE_RETENTION_HOLD		0x00000400
+#define RICHACE_DELETE				0x00010000
+#define RICHACE_READ_ACL			0x00020000
+#define RICHACE_WRITE_ACL			0x00040000
+#define RICHACE_WRITE_OWNER			0x00080000
+#define RICHACE_SYNCHRONIZE			0x00100000
+
+/* e_id values */
+#define RICHACE_OWNER_SPECIAL_ID		0
+#define RICHACE_GROUP_SPECIAL_ID		1
+#define RICHACE_EVERYONE_SPECIAL_ID		2
+
+/*
+ * The POSIX permissions are supersets of the following richacl permissions:
+ *
+ *  - MAY_READ maps to READ_DATA or LIST_DIRECTORY, depending on the type
+ *    of the file system object.
+ *
+ *  - MAY_WRITE maps to WRITE_DATA or RICHACE_APPEND_DATA for files, and to
+ *    ADD_FILE, RICHACE_ADD_SUBDIRECTORY, or RICHACE_DELETE_CHILD for directories.
+ *
+ *  - MAY_EXECUTE maps to RICHACE_EXECUTE.
+ *
+ *  (Some of these richacl permissions have the same bit values.)
+ */
+#define RICHACE_POSIX_MODE_READ (			\
+		RICHACE_READ_DATA |			\
+		RICHACE_LIST_DIRECTORY)
+#define RICHACE_POSIX_MODE_WRITE (			\
+		RICHACE_WRITE_DATA |			\
+		RICHACE_ADD_FILE |			\
+		RICHACE_APPEND_DATA |			\
+		RICHACE_ADD_SUBDIRECTORY |		\
+		RICHACE_DELETE_CHILD)
+#define RICHACE_POSIX_MODE_EXEC RICHACE_EXECUTE
+#define RICHACE_POSIX_MODE_ALL (			\
+		RICHACE_POSIX_MODE_READ |		\
+		RICHACE_POSIX_MODE_WRITE |		\
+		RICHACE_POSIX_MODE_EXEC)
+
+/*
+ * These permissions are always allowed no matter what the acl says.
+ */
+#define RICHACE_POSIX_ALWAYS_ALLOWED (			\
+		RICHACE_SYNCHRONIZE |			\
+		RICHACE_READ_ATTRIBUTES |		\
+		RICHACE_READ_ACL)
+
+/*
+ * The owner is implicitly granted these permissions under POSIX.
+ */
+#define RICHACE_POSIX_OWNER_ALLOWED (			\
+		RICHACE_WRITE_ATTRIBUTES |		\
+		RICHACE_WRITE_OWNER |			\
+		RICHACE_WRITE_ACL)
+
+#endif /* __UAPI_RICHACL_H */
diff --git a/include/uapi/linux/richacl_xattr.h b/include/uapi/linux/richacl_xattr.h
new file mode 100644
index 0000000..6f96bc0
--- /dev/null
+++ b/include/uapi/linux/richacl_xattr.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2006, 2010  Novell, Inc.
+ * Copyright (C) 2015  Red Hat, Inc.
+ * Written by Andreas Gruenbacher <agruen@kernel.org>
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
+#ifndef __UAPI_RICHACL_XATTR_H
+#define __UAPI_RICHACL_XATTR_H
+
+#include <linux/types.h>
+#include <linux/xattr.h>
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
+#define RICHACL_XATTR_MAX_COUNT \
+	((XATTR_SIZE_MAX - sizeof(struct richacl_xattr)) / \
+	 sizeof(struct richace_xattr))
+
+#endif  /* __UAPI_RICHACL_XATTR_H */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
