Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1155D33F360
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801515; cv=none; b=HjHR7UCnKfmdlpPdI6NYIOYjBoew+BTEcK7U44gUvy3fFu+eekz1E6s/42s8A6xqtSHcQ/Q3UlLWkUZVISqk4gtOGFvetIsyFwueOiVF5HpvsiGnGv3XzH3SwwM1Oau5MC94dTh7jTZg32dENVqxVtLO/8GmdZdrTdoFEyZavKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801515; c=relaxed/simple;
	bh=0EAtZY5XEg7gIHFHibC4GuKIqxAu0gVvnldWyaVDUq4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oXRrPwPCJ/JESl7SQbwsOf6556Q9wOsPetPI04FGGqwEjPFr8ruNue9AlrAQeJuLHjBvEA09Xh/BDGvc2VQor+efY0QfJBCLVCQcB1ayDevWMbqKLx87lQcQuZlFmIFvhkUmVdFAfAkGfQk35zg3HZnxi9qLi0DXJrVD5X9Pios=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGwYtRKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGwYtRKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E182FC19421;
	Fri, 10 Apr 2026 06:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801514;
	bh=0EAtZY5XEg7gIHFHibC4GuKIqxAu0gVvnldWyaVDUq4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BGwYtRKg1YQ38IepYaZf1J47reiWLhPonF4QdRp8O3FOAgWQmgQTxEcKyP9bCu3Q3
	 5u0fx+0M3ubLjcy1GOmflB2nNN2iRSpcaPd1gET7L/DA8gchRhQv7PVrWZFFIIUqO1
	 8hR3mT1VlecxG9xWnlG5+zAShhGsuo7DT/87WolcNGZNUM6pQuE1PjSK3MvNGK0idC
	 szGNavIZI6VdhCjNlAQ0+AjdDCl3FhiUJcLnBJ0O/zDB/iOGtVbkcZqIA+E+gnUCcy
	 h/ww9YSgGWaoo2RvYWmhIu/QEJUGab1WO+GKfOFBz0zKXbTrVU45vAaJgBAkBIvJ+w
	 nDwIFM8AT5OyA==
Date: Thu, 09 Apr 2026 23:11:54 -0700
Subject: [PATCH 05/26] libfrog: add wrappers for listmount and statmount
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384323.2089237.16373201695530035026.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add some wrappers for listmount and statmount so that we don't have to
open-code the kernel ABI quirks in every utility program that uses it.
Note that glibc seems to have discussed providing a wrapper in late 2023
but took no action; and the listmount manpage says that there is no
glibc wrapper.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux.h       |    8 +++-
 libfrog/statmount.h   |  104 +++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac          |    5 ++
 include/builddefs.in  |    7 +++
 libfrog/Makefile      |    9 ++++
 libfrog/statmount.c   |   76 ++++++++++++++++++++++++++++++++++++
 m4/package_libcdev.m4 |   86 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 294 insertions(+), 1 deletion(-)
 create mode 100644 libfrog/statmount.h
 create mode 100644 libfrog/statmount.c


diff --git a/include/linux.h b/include/linux.h
index 3ea9016272e688..8972c9596c75f5 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -32,7 +32,13 @@
 #ifdef OVERRIDE_SYSTEM_FSXATTR
 # define fsxattr sys_fsxattr
 #endif
-#include <linux/fs.h> /* fsxattr defintion for new kernels */
+#ifdef OVERRIDE_SYSTEM_STATMOUNT
+# define statmount sys_statmount
+#endif
+#include <linux/fs.h> /* fsxattr/statmount defintion for new kernels */
+#ifdef OVERRIDE_SYSTEM_STATMOUNT
+# undef statmount
+#endif
 #ifdef OVERRIDE_SYSTEM_FSXATTR
 # undef fsxattr
 #endif
diff --git a/libfrog/statmount.h b/libfrog/statmount.h
new file mode 100644
index 00000000000000..7e281ce93029ff
--- /dev/null
+++ b/libfrog/statmount.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2026 Oracle.  All rights reserved.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_STATMOUNT_H__
+#define __LIBFROG_STATMOUNT_H__
+
+/* This is the path to the current process' mount namespace file */
+#define DEFAULT_MOUNTNS_FILE	"/proc/self/ns/mnt"
+
+/*
+ * Believe it or not, listmount and statmount treat a zero value for mnt_ns_fd
+ * as if that means "use the current process' mount namespace" even though
+ * Linus Torvalds roared about that with the BPF people.
+ */
+#define DEFAULT_MOUNTNS_FD	(0)
+
+#ifdef OVERRIDE_SYSTEM_STATMOUNT
+struct statmount {
+	__u32 size;		/* Total size, including strings */
+	__u32 mnt_opts;		/* [str] Options (comma separated, escaped) */
+	__u64 mask;		/* What results were written */
+	__u32 sb_dev_major;	/* Device ID */
+	__u32 sb_dev_minor;
+	__u64 sb_magic;		/* ..._SUPER_MAGIC */
+	__u32 sb_flags;		/* SB_{RDONLY,SYNCHRONOUS,DIRSYNC,LAZYTIME} */
+	__u32 fs_type;		/* [str] Filesystem type */
+	__u64 mnt_id;		/* Unique ID of mount */
+	__u64 mnt_parent_id;	/* Unique ID of parent (for root == mnt_id) */
+	__u32 mnt_id_old;	/* Reused IDs used in proc/.../mountinfo */
+	__u32 mnt_parent_id_old;
+	__u64 mnt_attr;		/* MOUNT_ATTR_... */
+	__u64 mnt_propagation;	/* MS_{SHARED,SLAVE,PRIVATE,UNBINDABLE} */
+	__u64 mnt_peer_group;	/* ID of shared peer group */
+	__u64 mnt_master;	/* Mount receives propagation from this ID */
+	__u64 propagate_from;	/* Propagation from in current namespace */
+	__u32 mnt_root;		/* [str] Root of mount relative to root of fs */
+	__u32 mnt_point;	/* [str] Mountpoint relative to current root */
+	__u64 mnt_ns_id;	/* ID of the mount namespace */
+	__u32 fs_subtype;	/* [str] Subtype of fs_type (if any) */
+	__u32 sb_source;	/* [str] Source string of the mount */
+	__u32 opt_num;		/* Number of fs options */
+	__u32 opt_array;	/* [str] Array of nul terminated fs options */
+	__u32 opt_sec_num;	/* Number of security options */
+	__u32 opt_sec_array;	/* [str] Array of nul terminated security options */
+	__u64 supported_mask;	/* Mask flags that this kernel supports */
+	__u64 __spare2[45];
+	char str[];		/* Variable size part containing strings */
+};
+#endif
+
+/* all the new flags added since the beginning of statmount */
+
+#ifndef STATMOUNT_MNT_NS_ID
+#define STATMOUNT_MNT_NS_ID		0x00000040U	/* Want/got mnt_ns_id */
+#endif
+
+#ifndef STATMOUNT_MNT_OPTS
+#define STATMOUNT_MNT_OPTS		0x00000080U	/* Want/got mnt_opts */
+#endif
+
+#ifndef STATMOUNT_FS_SUBTYPE
+#define STATMOUNT_FS_SUBTYPE		0x00000100U	/* Want/got fs_subtype */
+#endif
+
+#ifndef STATMOUNT_SB_SOURCE
+#define STATMOUNT_SB_SOURCE		0x00000200U	/* Want/got sb_source */
+#endif
+
+#ifndef STATMOUNT_OPT_ARRAY
+#define STATMOUNT_OPT_ARRAY		0x00000400U	/* Want/got opt_... */
+#endif
+
+#ifndef STATMOUNT_OPT_SEC_ARRAY
+#define STATMOUNT_OPT_SEC_ARRAY		0x00000800U	/* Want/got opt_sec... */
+#endif
+
+#ifndef STATMOUNT_SUPPORTED_MASK
+#define STATMOUNT_SUPPORTED_MASK	0x00001000U	/* Want/got supported mask flags */
+#endif
+
+/* flag bits for statmount */
+#ifndef STATMOUNT_BY_FD
+#define STATMOUNT_BY_FD		0x00000001U	/* want mountinfo for given fd */
+#endif
+
+#define LISTMOUNT_INIT_CURSOR		(0ULL)
+
+int libfrog_listmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t *cursor,
+		uint64_t *mnt_ids, size_t nr_mnt_ids);
+
+int libfrog_statmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t statmount_flags,
+		struct statmount *smbuf, size_t smbuf_size);
+
+int libfrog_fstatmount(int fd, uint64_t statmount_flags,
+		struct statmount *smbuf, size_t smbuf_size);
+
+static inline size_t libfrog_statmount_sizeof(size_t strings_bytes)
+{
+	return sizeof(struct statmount) + strings_bytes;
+}
+
+#endif /* __LIBFROG_STATMOUNT_H__ */
diff --git a/configure.ac b/configure.ac
index a9febabc71cfc7..cffcaf373cfa5e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -183,6 +183,11 @@ AC_HAVE_BLKID_TOPO
 AC_HAVE_TRIVIAL_AUTO_VAR_INIT
 AC_STRERROR_R_RETURNS_STRING
 AC_HAVE_CLOSE_RANGE
+AC_HAVE_LISTMOUNT
+if test "$have_listmount" = "yes"; then
+	AC_HAVE_LISTMOUNT_NS_FD
+	AC_HAVE_STATMOUNT_SUPPORTED_MASK
+fi
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/include/builddefs.in b/include/builddefs.in
index 4a2cb757c0bdb3..d2d25c8a0ed676 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -119,6 +119,10 @@ UDEV_RULE_DIR = @udev_rule_dir@
 HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
 STRERROR_R_RETURNS_STRING = @strerror_r_returns_string@
 HAVE_CLOSE_RANGE = @have_close_range@
+HAVE_LISTMOUNT = @have_listmount@
+HAVE_LISTMOUNT_NS_FD = @have_listmount_ns_fd@
+HAVE_STATMOUNT_SUPPORTED_MASK = @have_statmount_supported_mask@
+NEED_INTERNAL_STATMOUNT = @need_internal_statmount@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -141,6 +145,9 @@ endif
 ifeq ($(NEED_INTERNAL_STATX),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_STATX
 endif
+ifeq ($(NEED_INTERNAL_STATMOUNT),yes)
+PCFLAGS+= -DOVERRIDE_SYSTEM_STATMOUNT
+endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 89a0332ae85372..22668212f22b93 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -96,6 +96,15 @@ ifeq ($(HAVE_CLOSE_RANGE),yes)
 CFLAGS += -DHAVE_CLOSE_RANGE
 endif
 
+ifeq ($(HAVE_LISTMOUNT),yes)
+CFILES += statmount.c
+HFILES += statmount.h
+endif
+
+ifeq ($(HAVE_LISTMOUNT_NS_FD),yes)
+CFLAGS+=-DHAVE_LISTMOUNT_NS_FD
+endif
+
 default: ltdepend $(LTLIBRARY) $(GETTEXT_PY)
 
 crc32table.h: gen_crc32table.c crc32defs.h
diff --git a/libfrog/statmount.c b/libfrog/statmount.c
new file mode 100644
index 00000000000000..edf17d6080ea42
--- /dev/null
+++ b/libfrog/statmount.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2026 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+
+#include <libfrog/statmount.h>
+
+int
+libfrog_listmount(
+	uint64_t		mnt_id,
+	int			mnt_ns_fd,
+	uint64_t		*cursor,
+	uint64_t		*mnt_ids,
+	size_t			nr_mnt_ids)
+{
+	struct mnt_id_req	req = {
+		.size		= sizeof(req),
+		.mnt_id		= mnt_id,
+#ifdef HAVE_LISTMOUNT_NS_FD
+		.mnt_ns_fd	= mnt_ns_fd,
+#else
+		.spare		= mnt_ns_fd,
+#endif
+		.param		= *cursor,
+	};
+	int ret = syscall(SYS_listmount, &req, mnt_ids, nr_mnt_ids, 0);
+
+	if (ret > 0)
+		*cursor = mnt_ids[ret - 1];
+
+	return ret;
+}
+
+int
+libfrog_statmount(
+	uint64_t		mnt_id,
+	int			mnt_ns_fd,
+	uint64_t		statmount_flags,
+	struct statmount	*smbuf,
+	size_t			smbuf_size)
+{
+	struct mnt_id_req	req = {
+		.size		= sizeof(req),
+		.mnt_id		= mnt_id,
+#ifdef HAVE_LISTMOUNT_NS_FD
+		.mnt_ns_fd	= mnt_ns_fd,
+#else
+		.spare		= mnt_ns_fd,
+#endif
+		.param		= statmount_flags,
+	};
+
+	return syscall(SYS_statmount, &req, smbuf, smbuf_size, 0);
+}
+
+int
+libfrog_fstatmount(
+	int			fd,
+	uint64_t		statmount_flags,
+	struct statmount	*smbuf,
+	size_t			smbuf_size)
+{
+	struct mnt_id_req	req = {
+		.size		= sizeof(req),
+#ifdef HAVE_LISTMOUNT_NS_FD
+		.mnt_ns_fd	= fd,
+#else
+		.spare		= fd,
+#endif
+		.param		= statmount_flags,
+	};
+
+	return syscall(SYS_statmount, &req, smbuf, smbuf_size, STATMOUNT_BY_FD);
+}
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index b3d87229d3367a..ec4a3ef444b705 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -366,3 +366,89 @@ close_range(0, 0, 0);
        AC_MSG_RESULT(no))
     AC_SUBST(have_close_range)
   ])
+
+#
+# Check if listmount and statmount exist.  Note that statmount came first (6.8)
+# and listmount came later (6.9), so we'll refuse both if either is missing.
+#
+AC_DEFUN([AC_HAVE_LISTMOUNT],
+  [AC_MSG_CHECKING([for listmount])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <unistd.h>
+#include <linux/mount.h>
+#include <sys/syscall.h>
+#include <alloca.h>
+  ]], [[
+	struct mnt_id_req	req = {
+		.size		= sizeof(req),
+	};
+	struct statmount	smbuf;
+
+	syscall(SYS_statmount, &req, &smbuf, 0, 0);
+	syscall(SYS_listmount, &req, NULL, 0, 0);
+  ]])
+    ], have_listmount=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_listmount)
+  ])
+
+#
+# Check if mnt_id_req::mnt_ns_fd exists.  This replaced mnt_id_req::spare in
+# 6.18, though earlier kernels allowed userspace to assign to spare.
+#
+AC_DEFUN([AC_HAVE_LISTMOUNT_NS_FD],
+  [AC_MSG_CHECKING([for struct mnt_id_req::mnt_ns_fd])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <unistd.h>
+#include <linux/mount.h>
+#include <sys/syscall.h>
+#include <alloca.h>
+  ]], [[
+	struct mnt_id_req	req = {
+		.mnt_ns_fd	= 555,
+	};
+
+	syscall(SYS_listmount, &req, NULL, 0, 0);
+  ]])
+    ], have_listmount_ns_fd=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_listmount_ns_fd)
+  ])
+
+#
+# Check if statmount::supported_mask (and hence sb_source) exists.  We need
+# sb_source for xfs_healer_start; and supported_mask for the xfs_io wrapper.
+# sb_source was added in 6.13 and supported_mask in 6.15.
+#
+AC_DEFUN([AC_HAVE_STATMOUNT_SUPPORTED_MASK],
+  [AC_MSG_CHECKING([for struct statmount::supported_mask])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <unistd.h>
+#include <linux/mount.h>
+#include <sys/syscall.h>
+#include <alloca.h>
+  ]], [[
+	struct mnt_id_req	req = {
+		.mnt_ns_fd	= 555,
+	};
+	struct statmount	smbuf = {
+		.supported_mask	= 1,
+	};
+
+	syscall(SYS_statmount, &req, &smbuf, 0, 0);
+  ]])
+    ], have_statmount_supported_mask=yes
+       AC_MSG_RESULT(yes),
+       need_internal_statmount=yes
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_statmount_supported_mask)
+    AC_SUBST(need_internal_statmount)
+  ])

