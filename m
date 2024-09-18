Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CF61CB324
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 21:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726693211; cv=none; b=VNYFvOudRdenMdccwzhMEFxnVzcKCamio4qqmLiFGCzojkrZvaCjGQXSAY7s2c+GtNIN9cLSkcwR3eHAVTnEf94ZoNUq1DKweGuJmTDRumJWckGfaLFaN9K0l5gzZl+sJQ5Re+7h7K+F5/yHZGUsdXsbNG28f5zbGZ2hIQW58X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726693211; c=relaxed/simple;
	bh=RPmfzUqY32USML4gwB+/dtUIyNKokPHbkR+LsN2VPfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uxB1n1J4vRIWH8OeOJv+d9VTsIOxnm5+Q8uuT+aN2ozGuzSRDazutSeT/9d86lUqMM4XU5I885EputbWwQTKhUSlx7SHcWVdy18hMKSS3r7Z4lZnYonkUZGQgpwEZyvZ4zrM63B4jH0hrs+RlutrvbJMQ4uY8fThq0b1y7shJZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uI/lSzuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uI/lSzuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F47C4CEC2;
	Wed, 18 Sep 2024 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726693211;
	bh=RPmfzUqY32USML4gwB+/dtUIyNKokPHbkR+LsN2VPfQ=;
	h=Date:From:To:Cc:Subject:From;
	b=uI/lSzuyltkj3UKf8bi0jtAe7j6o1Im49W42zGXcBM2mXZx+r0C43LCuheNvYldsc
	 Dq/4pE06ZC4jaanHQXr8h0NCjRm+8u8+ql5Q6QMCtrordyRl/OJyBUyVlxZaid5tPE
	 LDv3+XtH8KoGI4+qsJIiIUe48b5kB/3sh+yuQHjkmxVWyshrhgjGgG5jOOcpEatCix
	 txZ7hSvdxi63Rl+rC0IXX/RgNqBFzxzt3ahCsphNa+UfkEdUxL43FAyt5+VSRDTbpW
	 YaVIUDEAG9sUAcGPBUR0d1XgK/OQFEk0cx+yIQf6t3NqoMhJz/sj7OPVGLZgIWiV8j
	 BZqpJDYCaUljw==
Date: Wed, 18 Sep 2024 14:00:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libfrog: emulate deprecated attrlist functionality in libattr
Message-ID: <20240918210010.GP182194@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Break our dependence on the (deprecated) libattr by emulating the
necessary pieces in libfrog.  It's a little sketchy to open-code these
symbols, but they're originally from XFS so we trust ourselves.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    2 --
 debian/control        |    2 +-
 include/builddefs.in  |    1 -
 libfrog/Makefile      |    8 +++-----
 libfrog/fakelibattr.h |   34 ++++++++++++++++++++++++++++++++++
 libfrog/fsprops.c     |   17 +++++++++--------
 m4/package_attr.m4    |   25 -------------------------
 scrub/Makefile        |    4 ----
 scrub/phase5.c        |   28 +++++++++++-----------------
 9 files changed, 58 insertions(+), 63 deletions(-)
 create mode 100644 libfrog/fakelibattr.h
 delete mode 100644 m4/package_attr.m4

diff --git a/configure.ac b/configure.ac
index 33b01399ae3b..d021c519d538 100644
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
index 3f05d4e3797c..66b0a47a36ee 100644
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
index 9900a0f858ad..57fa527b60ae 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -175,7 +175,6 @@ HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_MEMFD_CREATE = @have_memfd_create@
-HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
 HAVE_SYSTEMD = @have_systemd@
 SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
diff --git a/libfrog/Makefile b/libfrog/Makefile
index acddc894ee93..4da427789411 100644
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
index 000000000000..82b5c8a34d1a
--- /dev/null
+++ b/libfrog/fakelibattr.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBFROG_FAKELIBATTR_H__
+#define __LIBFROG_FAKELIBATTR_H__
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
index 88046b7a0738..eb15c3b9792c 100644
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
@@ -68,20 +67,22 @@ fsprops_walk_names(
 	fsprops_name_walk_fn	walk_fn,
 	void			*priv)
 {
-	struct attrlist_cursor	cur = { };
-	char			attrbuf[XFS_XATTR_LIST_MAX];
-	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
-	int			ret;
+	struct xfs_attrlist_cursor	cur = { };
+	char				attrbuf[XFS_XATTR_LIST_MAX];
+	struct xfs_attrlist		*attrlist =
+				(struct xfs_attrlist *)attrbuf;
+	int				ret;
 
 	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
 
-	while ((ret = attr_list_by_handle(fph->hanp, fph->hlen, attrbuf,
+	while ((ret = libfrog_attr_list_by_handle(fph->hanp, fph->hlen, attrbuf,
 				XFS_XATTR_LIST_MAX, XFS_IOC_ATTR_ROOT,
 				&cur)) == 0) {
 		unsigned int	i;
 
 		for (i = 0; i < attrlist->al_count; i++) {
-			struct attrlist_ent	*ent = ATTR_ENTRY(attrlist, i);
+			struct xfs_attrlist_ent	*ent =
+				libfrog_attr_entry(attrlist, i);
 			const char		*p =
 				attr_name_to_fsprop_name(ent->a_name);
 
diff --git a/m4/package_attr.m4 b/m4/package_attr.m4
deleted file mode 100644
index 05e02b38fb5a..000000000000
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
index 53e8cb02a926..1e1109048c2a 100644
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
index f6c295c64ada..0f8dc2de01ba 100644
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
 
@@ -190,11 +187,11 @@ check_xattr_ns_names(
 	struct xfs_bulkstat		*bstat,
 	const struct attrns_decode	*attr_ns)
 {
-	struct attrlist_cursor		cur;
+	struct xfs_attrlist_cursor	cur = { };
 	char				attrbuf[XFS_XATTR_LIST_MAX];
 	char				keybuf[XATTR_NAME_MAX + 1];
-	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
-	struct attrlist_ent		*ent;
+	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;
+	struct xfs_attrlist_ent		*ent;
 	struct unicrash			*uc = NULL;
 	int				i;
 	int				error;
@@ -206,14 +203,13 @@ check_xattr_ns_names(
 	}
 
 	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
-	memset(&cur, 0, sizeof(cur));
 	memset(keybuf, 0, XATTR_NAME_MAX + 1);
-	error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
+	error = libfrog_attr_list_by_handle(handle, sizeof(*handle), attrbuf,
 			XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
 	while (!error) {
 		/* Examine the xattrs. */
 		for (i = 0; i < attrlist->al_count; i++) {
-			ent = ATTR_ENTRY(attrlist, i);
+			ent = libfrog_attr_entry(attrlist, i);
 			snprintf(keybuf, XATTR_NAME_MAX, "%s.%s", attr_ns->name,
 					ent->a_name);
 			if (uc)
@@ -231,8 +227,9 @@ check_xattr_ns_names(
 
 		if (!attrlist->al_more)
 			break;
-		error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
-				XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
+		error = libfrog_attr_list_by_handle(handle, sizeof(*handle),
+				attrbuf, XFS_XATTR_LIST_MAX, attr_ns->flags,
+				&cur);
 	}
 	if (error) {
 		if (errno == ESTALE)
@@ -267,9 +264,6 @@ check_xattr_names(
 	}
 	return ret;
 }
-#else
-# define check_xattr_names(c, d, h, b)	(0)
-#endif /* HAVE_LIBATTR */
 
 static int
 render_ino_from_handle(
