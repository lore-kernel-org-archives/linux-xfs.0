Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47222 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761980AbdKQVB4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:01:56 -0500
Subject: [PATCH 17/27] xfs_scrub: warn about suspicious characters in
 directory/xattr names
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:01:51 -0800
Message-ID: <151095251153.4825.17916982314632749590.stgit@magnolia>
In-Reply-To: <151095240950.4825.6375172010231614655.stgit@magnolia>
References: <151095240950.4825.6375172010231614655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Look for control characters and punctuation that interfere with shell
globbing in directory entry names and extended attribute key names.
Technically these aren't filesystem corruptions because names are
arbitrary sequences of bytes, but they've been known to cause problems
in the Unix environment so warn if we see them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac         |    2 +
 debian/control       |    2 -
 include/builddefs.in |    1 
 m4/Makefile          |    1 
 m4/package_attr.m4   |   23 ++++++
 scrub/Makefile       |    6 ++
 scrub/common.c       |   54 ++++++++++++++
 scrub/common.h       |    4 +
 scrub/phase5.c       |  192 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.h    |    1 
 10 files changed, 285 insertions(+), 1 deletion(-)
 create mode 100644 m4/package_attr.m4


diff --git a/configure.ac b/configure.ac
index 960a40a..58dc9e8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -163,6 +163,8 @@ AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
 AC_HAVE_GETFSMAP
 AC_HAVE_MALLINFO
+AC_PACKAGE_WANT_ATTRIBUTES_H
+AC_HAVE_LIBATTR
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/debian/control b/debian/control
index ad81662..1ef0b97 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev
+Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, libattr1-dev
 Standards-Version: 3.9.1
 Homepage: http://xfs.org/
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 4be2efb..7964599 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -116,6 +116,7 @@ HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 HAVE_GETFSMAP = @have_getfsmap@
 HAVE_MALLINFO = @have_mallinfo@
+HAVE_LIBATTR = @have_libattr@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/Makefile b/m4/Makefile
index 4706121..100c8f5 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -16,6 +16,7 @@ LSRCFILES = \
 	manual_format.m4 \
 	package_blkid.m4 \
 	package_globals.m4 \
+	package_attr.m4 \
 	package_libcdev.m4 \
 	package_pthread.m4 \
 	package_sanitizer.m4 \
diff --git a/m4/package_attr.m4 b/m4/package_attr.m4
new file mode 100644
index 0000000..4324923
--- /dev/null
+++ b/m4/package_attr.m4
@@ -0,0 +1,23 @@
+AC_DEFUN([AC_PACKAGE_WANT_ATTRIBUTES_H],
+  [
+    AC_CHECK_HEADERS(attr/attributes.h)
+  ])
+
+#
+# Check if we have a ATTR_ROOT flag and libattr structures
+#
+AC_DEFUN([AC_HAVE_LIBATTR],
+  [ AC_MSG_CHECKING([for struct attrlist_cursor])
+    AC_TRY_COMPILE([
+#include <sys/types.h>
+#include <attr/attributes.h>
+       ], [
+struct attrlist_cursor *cur;
+struct attrlist *list;
+struct attrlist_ent *ent;
+int flags = ATTR_ROOT;
+       ], have_libattr=yes
+          AC_MSG_RESULT(yes),
+          AC_MSG_RESULT(no))
+    AC_SUBST(have_libattr)
+  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index ca08bd5..d7c24a1 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -53,8 +53,14 @@ ifeq ($(HAVE_SYNCFS),yes)
 LCFLAGS += -DHAVE_SYNCFS
 endif
 
+ifeq ($(HAVE_LIBATTR),yes)
+LCFLAGS += -DHAVE_LIBATTR
+endif
+
 default: depend $(LTCOMMAND)
 
+phase5.o: $(TOPDIR)/include/builddefs
+
 include $(BUILDRULES)
 
 install: default $(INSTALL_SCRUB)
diff --git a/scrub/common.c b/scrub/common.c
index 18c060d..ceb80bc 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -339,3 +339,57 @@ background_sleep(void)
 	tv.tv_nsec = time % 1000000;
 	nanosleep(&tv, NULL);
 }
+
+/*
+ * Return the input string with non-printing bytes escaped.
+ * Caller must free the buffer.
+ */
+char *
+string_escape(
+	const char		*in)
+{
+	char			*str;
+	const char		*p;
+	char			*q;
+	int			x;
+
+	str = malloc(strlen(in) * 4);
+	if (!str)
+		return NULL;
+	for (p = in, q = str; *p != '\0'; p++) {
+		if (isprint(*p)) {
+			*q = *p;
+			q++;
+		} else {
+			x = sprintf(q, "\\x%02x", *p);
+			q += x;
+		}
+	}
+	*q = '\0';
+	return str;
+}
+
+/*
+ * Record another naming warning, and decide if it's worth
+ * complaining about.
+ */
+bool
+should_warn_about_name(
+	struct scrub_ctx	*ctx)
+{
+	bool			whine;
+	bool			res;
+
+	pthread_mutex_lock(&ctx->lock);
+	ctx->naming_warnings++;
+	whine = ctx->naming_warnings == TOO_MANY_NAME_WARNINGS;
+	res = ctx->naming_warnings < TOO_MANY_NAME_WARNINGS;
+	pthread_mutex_unlock(&ctx->lock);
+
+	if (whine && !(debug || verbose))
+		str_info(ctx, ctx->mntpoint,
+_("More than %u naming warnings, shutting up."),
+				TOO_MANY_NAME_WARNINGS);
+
+	return debug || verbose || res;
+}
diff --git a/scrub/common.h b/scrub/common.h
index e63f711..3bb2524 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -72,5 +72,9 @@ static inline int syncfs(int fd)
 
 bool find_mountpoint(char *mtab, struct scrub_ctx *ctx);
 void background_sleep(void);
+char *string_escape(const char *in);
+
+#define TOO_MANY_NAME_WARNINGS	10000
+bool should_warn_about_name(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 7cc0496..a248c59 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -20,10 +20,15 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <stdbool.h>
+#include <dirent.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/statvfs.h>
+#ifdef HAVE_LIBATTR
+# include <attr/attributes.h>
+#endif
 #include "xfs.h"
+#include "handle.h"
 #include "path.h"
 #include "workqueue.h"
 #include "xfs_scrub.h"
@@ -34,6 +39,181 @@
 /* Phase 5: Check directory connectivity. */
 
 /*
+ * Warn about problematic bytes in a directory/attribute name.  That means
+ * terminal control characters and escape sequences, since that could be used
+ * to do something naughty to the user's computer and/or break scripts.  XFS
+ * doesn't consider any byte sequence invalid, so don't flag these as errors.
+ */
+static bool
+xfs_scrub_check_name(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	const char		*namedescr,
+	const char		*name)
+{
+	const char		*p;
+	bool			bad = false;
+	char			*errname;
+
+	/* Complain about zero length names. */
+	if (*name == '\0' && should_warn_about_name(ctx)) {
+		str_warn(ctx, descr, _("Zero length name found."));
+		return true;
+	}
+
+	/* control characters */
+	for (p = name; *p; p++) {
+		if ((*p >= 1 && *p <= 31) || *p == 127) {
+			bad = true;
+			break;
+		}
+	}
+
+	if (bad && should_warn_about_name(ctx)) {
+		errname = string_escape(name);
+		if (!errname) {
+			str_errno(ctx, descr);
+			return false;
+		}
+		str_info(ctx, descr,
+_("Control character found in %s name \"%s\"."),
+				namedescr, errname);
+		free(errname);
+	}
+
+	return true;
+}
+
+/*
+ * Iterate a directory looking for filenames with problematic
+ * characters.
+ */
+static bool
+xfs_scrub_scan_dirents(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			*fd)
+{
+	DIR			*dir;
+	struct dirent		*dentry;
+	bool			moveon = true;
+
+	dir = fdopendir(*fd);
+	if (!dir) {
+		str_errno(ctx, descr);
+		goto out;
+	}
+	*fd = -1; /* closedir will close *fd for us */
+
+	dentry = readdir(dir);
+	while (dentry) {
+		moveon = xfs_scrub_check_name(ctx, descr, _("directory"),
+				dentry->d_name);
+		if (!moveon)
+			break;
+		dentry = readdir(dir);
+	}
+
+	closedir(dir);
+out:
+	return moveon;
+}
+
+#ifdef HAVE_LIBATTR
+/* Routines to scan all of an inode's xattrs for name problems. */
+struct xfs_attr_ns {
+	int			flags;
+	const char		*name;
+};
+
+static const struct xfs_attr_ns attr_ns[] = {
+	{0,			"user"},
+	{ATTR_ROOT,		"system"},
+	{ATTR_SECURE,		"secure"},
+	{0, NULL},
+};
+
+/*
+ * Check all the xattr names in a particular namespace of a file handle
+ * for Unicode normalization problems or collisions.
+ */
+static bool
+xfs_scrub_scan_fhandle_namespace_xattrs(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	struct xfs_handle		*handle,
+	const struct xfs_attr_ns	*attr_ns)
+{
+	struct attrlist_cursor		cur;
+	char				attrbuf[XFS_XATTR_LIST_MAX];
+	char				keybuf[NAME_MAX + 1];
+	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
+	struct attrlist_ent		*ent;
+	bool				moveon = true;
+	int				i;
+	int				error;
+
+	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
+	memset(&cur, 0, sizeof(cur));
+	memset(keybuf, 0, NAME_MAX + 1);
+	error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
+			XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
+	while (!error) {
+		/* Examine the xattrs. */
+		for (i = 0; i < attrlist->al_count; i++) {
+			ent = ATTR_ENTRY(attrlist, i);
+			snprintf(keybuf, NAME_MAX, "%s.%s", attr_ns->name,
+					ent->a_name);
+			moveon = xfs_scrub_check_name(ctx, descr,
+					_("extended attribute"), keybuf);
+			if (!moveon)
+				goto out;
+		}
+
+		if (!attrlist->al_more)
+			break;
+		error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
+				XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
+	}
+	if (error && errno != ESTALE)
+		str_errno(ctx, descr);
+out:
+	return moveon;
+}
+
+/*
+ * Check all the xattr names in all the xattr namespaces for problematic
+ * characters.
+ */
+static bool
+xfs_scrub_scan_fhandle_xattrs(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	struct xfs_handle		*handle)
+{
+	const struct xfs_attr_ns	*ns;
+	bool				moveon = true;
+
+	for (ns = attr_ns; ns->name; ns++) {
+		moveon = xfs_scrub_scan_fhandle_namespace_xattrs(ctx, descr,
+				handle, ns);
+		if (!moveon)
+			break;
+	}
+	return moveon;
+}
+#else
+static inline bool
+xfs_scrub_scan_fhandle_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct xfs_handle	*handle)
+{
+	return true;
+}
+#endif /* HAVE_LIBATTR */
+
+/*
  * Verify the connectivity of the directory tree.
  * We know that the kernel's open-by-handle function will try to reconnect
  * parents of an opened directory, so we'll accept that as sufficient.
@@ -58,6 +238,11 @@ xfs_scrub_connections(
 			(uint64_t)bstat->bs_ino, agno, agino);
 	background_sleep();
 
+        /* Warn about naming problems in xattrs. */
+        moveon = xfs_scrub_scan_fhandle_xattrs(ctx, descr, handle);
+        if (!moveon)
+                goto out;
+
 	/* Open the dir, let the kernel try to reconnect it to the root. */
 	if (S_ISDIR(bstat->bs_mode)) {
 		fd = xfs_open_handle(handle);
@@ -69,6 +254,13 @@ xfs_scrub_connections(
 		}
 	}
 
+        /* Warn about naming problems in the directory entries. */
+        if (fd >= 0 && S_ISDIR(bstat->bs_mode)) {
+                moveon = xfs_scrub_scan_dirents(ctx, descr, &fd);
+                if (!moveon)
+                        goto out;
+        }
+
 out:
 	if (fd >= 0)
 		close(fd);
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 373901e..c7e8e8e 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -90,6 +90,7 @@ struct scrub_ctx {
 	unsigned long long	errors_found;
 	unsigned long long	warnings_found;
 	unsigned long long	inodes_checked;
+	unsigned long long	naming_warnings;
 	bool			need_repair;
 	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
 };

