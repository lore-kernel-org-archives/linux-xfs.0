Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC56263CB
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831270; cv=none; b=d8gAcNSnFX6k3lZmlddO02a157xHLW5QcbdwZuTTWHXJel5tkQbNJIsVRx0PqQDzxmyPFbrqD6wYPNgjDOEQKO35PCCzEUsBLjLdhPsPw/+ZsjzkvDgNawyoaHA8eg96tQ7i7CKRKRqcCvxwiaIFZpPHGbVyrveoRUOokjqw2wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831270; c=relaxed/simple;
	bh=9F+EIT7bLAiqR92wu7L4ZFjDKT7IFlntdLFD96n6I1o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1bqDCqtvl0xwNI79Nk9ixaiCczVgJaESIuisB07E3iCsep1PffI/5aCuNpupVtV2XbxgQl1m6fXFE9xFA7/n8oqaW7FtlfkdMvW8A47ekUTuMUBO3/h4YmL1g2Oljztcj2b9IKq1FjWMwUMhvt0sjJzN4L5iikoEXJm+5dRIaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nR02LhbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nR02LhbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B30FC4CEC6;
	Wed,  2 Oct 2024 01:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831270;
	bh=9F+EIT7bLAiqR92wu7L4ZFjDKT7IFlntdLFD96n6I1o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nR02LhbQgh1JYBtb2othKPuvj1UYWcqZvd0U8jCKbvGCmR7OZXYLQ7XLIGAejGTrz
	 K2SBX+ZYmYawvY+6pzKeVEuLs0dMJuwvTPjPdMjOywPP51rQOsWH3+3bUXLdgvV8nX
	 xed9IaZfY1UMK60L+OD4lVooWei10YzoidIiAYSnn/4xKwJqE2uIB388HHHL3wyAtf
	 WcfJn8hc+DA510Y337jvXcSJbp1pn+lPH0IiwaT8fBqE/lArKVwkQtGjqjjQYsQvmM
	 ie9TdLNmoHHlFXPD9I2WjiFGfCgp0pGdGs+Z+U8e8tf1KugAIy3P3mldHbR3Yxxkxx
	 XeNg1sf6jhwfg==
Date: Tue, 01 Oct 2024 18:07:49 -0700
Subject: [PATCH 2/2] libfrog: emulate deprecated attrlist functionality in
 libattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <172783101370.4035924.5216902512305230335.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101339.4035924.6880384393728950920.stgit@frogsfrogsfrogs>
References: <172783101339.4035924.6880384393728950920.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Break our dependence on the (deprecated) libattr by emulating the
necessary pieces in libfrog.  It's a little sketchy to open-code these
symbols, but they're originally from XFS so we trust ourselves.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 configure.ac          |    2 --
 debian/control        |    2 +-
 include/builddefs.in  |    1 -
 libfrog/Makefile      |    8 +++-----
 libfrog/fakelibattr.h |   36 ++++++++++++++++++++++++++++++++++++
 libfrog/fsprops.c     |   16 ++++++++--------
 m4/package_attr.m4    |   25 -------------------------
 scrub/Makefile        |    4 ----
 scrub/phase5.c        |   23 +++++++++--------------
 9 files changed, 57 insertions(+), 60 deletions(-)
 create mode 100644 libfrog/fakelibattr.h
 delete mode 100644 m4/package_attr.m4


diff --git a/configure.ac b/configure.ac
index 33b01399a..d021c519d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -152,8 +152,6 @@ AC_HAVE_DEVMAPPER
 AC_HAVE_MALLINFO
 AC_HAVE_MALLINFO2
 AC_HAVE_MEMFD_CREATE
-AC_PACKAGE_WANT_ATTRIBUTES_H
-AC_HAVE_LIBATTR
 if test "$enable_scrub" = "yes"; then
         if test "$enable_libicu" = "yes" || test "$enable_libicu" = "probe"; then
                 AC_HAVE_LIBICU
diff --git a/debian/control b/debian/control
index 3f05d4e37..66b0a47a3 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
-Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev, systemd-dev | systemd (<< 253-2~)
+Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libicu-dev, pkg-config, liburcu-dev, systemd-dev | systemd (<< 253-2~)
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 1647d2cd1..07c4a43f7 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,7 +102,6 @@ HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_MEMFD_CREATE = @have_memfd_create@
-HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
 HAVE_SYSTEMD = @have_systemd@
 SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
diff --git a/libfrog/Makefile b/libfrog/Makefile
index acddc894e..4da427789 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -21,6 +21,7 @@ crc32.c \
 file_exchange.c \
 fsgeom.c \
 fsproperties.c \
+fsprops.c \
 getparents.c \
 histogram.c \
 list_sort.c \
@@ -46,9 +47,11 @@ crc32defs.h \
 crc32table.h \
 dahashselftest.h \
 div64.h \
+fakelibattr.h \
 file_exchange.h \
 fsgeom.h \
 fsproperties.h \
+fsprops.h \
 getparents.h \
 histogram.h \
 logging.h \
@@ -62,11 +65,6 @@ workqueue.h
 
 LSRCFILES += gen_crc32table.c
 
-ifeq ($(HAVE_LIBATTR),yes)
-CFILES+=fsprops.c
-HFILES+=fsprops.h
-endif
-
 LDIRT = gen_crc32table crc32table.h
 
 default: ltdepend $(LTLIBRARY)
diff --git a/libfrog/fakelibattr.h b/libfrog/fakelibattr.h
new file mode 100644
index 000000000..30e0e5146
--- /dev/null
+++ b/libfrog/fakelibattr.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBFROG_FAKELIBATTR_H__
+#define __LIBFROG_FAKELIBATTR_H__
+
+/* This file emulates APIs from the deprecated libattr. */
+
+struct attrlist_cursor;
+
+static inline struct xfs_attrlist_ent *
+libfrog_attr_entry(
+	struct xfs_attrlist	*list,
+	unsigned int		index)
+{
+	char			*buffer = (char *)list;
+
+	return (struct xfs_attrlist_ent *)&buffer[list->al_offset[index]];
+}
+
+static inline int
+libfrog_attr_list_by_handle(
+	void				*hanp,
+	size_t				hlen,
+	void				*buf,
+	size_t				bufsize,
+	int				flags,
+	struct xfs_attrlist_cursor	*cursor)
+{
+	return attr_list_by_handle(hanp, hlen, buf, bufsize, flags,
+			(struct attrlist_cursor *)cursor);
+}
+
+#endif /* __LIBFROG_FAKELIBATTR_H__ */
diff --git a/libfrog/fsprops.c b/libfrog/fsprops.c
index a25c2726c..f59fbd9c2 100644
--- a/libfrog/fsprops.c
+++ b/libfrog/fsprops.c
@@ -10,8 +10,7 @@
 #include "libfrog/bulkstat.h"
 #include "libfrog/fsprops.h"
 #include "libfrog/fsproperties.h"
-
-#include <attr/attributes.h>
+#include "libfrog/fakelibattr.h"
 
 /*
  * Given an xfd and a mount table path, get us the handle for the root dir so
@@ -68,21 +67,22 @@ fsprops_walk_names(
 	fsprops_name_walk_fn	walk_fn,
 	void			*priv)
 {
-	struct attrlist_cursor	cur = { };
-	struct attrlist		*attrlist;
+	struct xfs_attrlist_cursor cur = { };
+	struct xfs_attrlist	*attrlist;
 	int			ret;
 
 	attrlist = calloc(XFS_XATTR_LIST_MAX, 1);
 	if (!attrlist)
 		return -1;
 
-	while ((ret = attr_list_by_handle(fph->hanp, fph->hlen, attrlist,
-				XFS_XATTR_LIST_MAX, XFS_IOC_ATTR_ROOT,
-				&cur)) == 0) {
+	while ((ret = libfrog_attr_list_by_handle(fph->hanp, fph->hlen,
+				attrlist, XFS_XATTR_LIST_MAX,
+				XFS_IOC_ATTR_ROOT, &cur)) == 0) {
 		unsigned int	i;
 
 		for (i = 0; i < attrlist->al_count; i++) {
-			struct attrlist_ent	*ent = ATTR_ENTRY(attrlist, i);
+			struct xfs_attrlist_ent	*ent =
+				libfrog_attr_entry(attrlist, i);
 			const char		*p =
 				attr_name_to_fsprop_name(ent->a_name);
 
diff --git a/m4/package_attr.m4 b/m4/package_attr.m4
deleted file mode 100644
index 05e02b38f..000000000
--- a/m4/package_attr.m4
+++ /dev/null
@@ -1,25 +0,0 @@
-AC_DEFUN([AC_PACKAGE_WANT_ATTRIBUTES_H],
-  [
-    AC_CHECK_HEADERS(attr/attributes.h)
-  ])
-
-#
-# Check if we have a ATTR_ROOT flag and libattr structures
-#
-AC_DEFUN([AC_HAVE_LIBATTR],
-  [ AC_MSG_CHECKING([for struct attrlist_cursor])
-    AC_COMPILE_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#include <sys/types.h>
-#include <attr/attributes.h>
-	]], [[
-struct attrlist_cursor *cur;
-struct attrlist *list;
-struct attrlist_ent *ent;
-int flags = ATTR_ROOT;
-	]])
-    ], have_libattr=yes
-          AC_MSG_RESULT(yes),
-          AC_MSG_RESULT(no))
-    AC_SUBST(have_libattr)
-  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index 53e8cb02a..1e1109048 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -100,10 +100,6 @@ ifeq ($(HAVE_MALLINFO2),yes)
 LCFLAGS += -DHAVE_MALLINFO2
 endif
 
-ifeq ($(HAVE_LIBATTR),yes)
-LCFLAGS += -DHAVE_LIBATTR
-endif
-
 ifeq ($(HAVE_LIBICU),yes)
 CFILES += unicrash.c
 LCFLAGS += -DHAVE_LIBICU $(LIBICU_CFLAGS)
diff --git a/scrub/phase5.c b/scrub/phase5.c
index d298d628a..e1d94f9a3 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -8,9 +8,6 @@
 #include <dirent.h>
 #include <sys/types.h>
 #include <sys/statvfs.h>
-#ifdef HAVE_LIBATTR
-# include <attr/attributes.h>
-#endif
 #include <linux/fs.h>
 #include "handle.h"
 #include "list.h"
@@ -20,6 +17,7 @@
 #include "libfrog/scrub.h"
 #include "libfrog/bitmap.h"
 #include "libfrog/bulkstat.h"
+#include "libfrog/fakelibattr.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
@@ -164,7 +162,6 @@ check_dirent_names(
 	return ret;
 }
 
-#ifdef HAVE_LIBATTR
 /* Routines to scan all of an inode's xattrs for name problems. */
 struct attrns_decode {
 	int			flags;
@@ -173,8 +170,8 @@ struct attrns_decode {
 
 static const struct attrns_decode attr_ns[] = {
 	{0,			"user"},
-	{ATTR_ROOT,		"system"},
-	{ATTR_SECURE,		"secure"},
+	{XFS_IOC_ATTR_ROOT,	"system"},
+	{XFS_IOC_ATTR_SECURE,	"secure"},
 	{0, NULL},
 };
 
@@ -190,9 +187,9 @@ check_xattr_ns_names(
 	struct xfs_bulkstat		*bstat,
 	const struct attrns_decode	*attr_ns)
 {
-	struct attrlist_cursor		cur = { };
+	struct xfs_attrlist_cursor	cur = { };
 	char				*keybuf;
-	struct attrlist			*attrlist;
+	struct xfs_attrlist		*attrlist;
 	struct unicrash			*uc = NULL;
 	int				i;
 	int				error;
@@ -217,12 +214,13 @@ check_xattr_ns_names(
 		goto out_keybuf;
 	}
 
-	while ((error = attr_list_by_handle(handle, sizeof(*handle), attrlist,
-				XFS_XATTR_LIST_MAX, attr_ns->flags,
+	while ((error = libfrog_attr_list_by_handle(handle, sizeof(*handle),
+				attrlist, XFS_XATTR_LIST_MAX, attr_ns->flags,
 				&cur)) == 0) {
 		/* Examine the xattrs. */
 		for (i = 0; i < attrlist->al_count; i++) {
-			struct attrlist_ent	*ent = ATTR_ENTRY(attrlist, i);
+			struct xfs_attrlist_ent	*ent =
+					libfrog_attr_entry(attrlist, i);
 
 			snprintf(keybuf, XATTR_NAME_MAX, "%s.%s", attr_ns->name,
 					ent->a_name);
@@ -279,9 +277,6 @@ check_xattr_names(
 	}
 	return ret;
 }
-#else
-# define check_xattr_names(c, d, h, b)	(0)
-#endif /* HAVE_LIBATTR */
 
 static int
 render_ino_from_handle(

