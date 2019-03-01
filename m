Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfCAX2G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:28:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOOIT123090
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:05 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qtwkut916-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:28:04 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x21NS42n010696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:04 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NS4pg021111
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:04 GMT
Subject: [PATCH 11/23] xfs_scrub: check label for misleading characters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:28:03 -0800
Message-ID: <155148288327.16677.4796655865947441541.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that we can retrieve the label and that it doesn't contain
anything potentially misleading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    1 +
 include/builddefs.in  |    1 +
 m4/package_libcdev.m4 |   17 +++++++++++++++
 scrub/Makefile        |    4 ++++
 scrub/phase5.c        |   55 +++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/unicrash.c      |   24 +++++++++++++++++++++
 scrub/unicrash.h      |    5 ++++
 7 files changed, 107 insertions(+)


diff --git a/configure.ac b/configure.ac
index ccc6e292..c64742b7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -197,6 +197,7 @@ AC_HAVE_SG_IO
 AC_HAVE_HDIO_GETGEO
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
 AC_CONFIG_CROND_DIR
+AC_HAVE_GETFSLABEL
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index c5b38b07..b4839d9a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -117,6 +117,7 @@ HAVE_SYSTEMD = @have_systemd@
 SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
 HAVE_CROND = @have_crond@
 CROND_DIR = @crond_dir@
+HAVE_GETFSLABEL = @have_getfslabel@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 2c0c72ce..6f8e3811 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -429,3 +429,20 @@ AC_DEFUN([AC_PACKAGE_CHECK_LTO],
     AC_SUBST(lto_cflags)
     AC_SUBST(lto_ldflags)
   ])
+
+#
+# Check if we have the GETFSLABEL ioctl
+#
+AC_DEFUN([AC_HAVE_GETFSLABEL],
+  [ AC_MSG_CHECKING([for FS_IOC_GETFSLABEL])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#include <linux/fs.h>
+    ], [
+         char label[FSLABEL_MAX];
+         ioctl(0, FS_IOC_GETFSLABEL, &label);
+    ], have_getfslabel=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_getfslabel)
+  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index 6e155c2c..04921888 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -99,6 +99,10 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
 LCFLAGS += -DHAVE_HDIO_GETGEO
 endif
 
+ifeq ($(HAVE_GETFSLABEL),yes)
+LCFLAGS += -DHAVE_GETFSLABEL
+endif
+
 LDIRT = $(XFS_SCRUB_ALL_PROG) *.service *.cron
 
 default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 6ffcec2d..331492b7 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -11,6 +11,9 @@
 #ifdef HAVE_LIBATTR
 # include <attr/attributes.h>
 #endif
+#ifdef HAVE_GETFSLABEL
+# include <linux/fs.h>
+#endif
 #include "handle.h"
 #include "list.h"
 #include "path.h"
@@ -282,6 +285,54 @@ xfs_scrub_connections(
 	return *pmoveon ? 0 : XFS_ITERATE_INODES_ABORT;
 }
 
+#ifdef HAVE_GETFSLABEL
+/*
+ * Check the filesystem label for Unicode normalization problems or misleading
+ * sequences.
+ */
+static bool
+xfs_scrub_fs_label(
+	struct scrub_ctx		*ctx)
+{
+	char				label[FSLABEL_MAX];
+	struct unicrash			*uc = NULL;
+	bool				moveon = true;
+	int				error;
+
+	moveon = unicrash_fs_label_init(&uc, ctx);
+	if (!moveon)
+		return false;
+
+	/* Retrieve label; quietly bail if we don't support that. */
+	error = ioctl(ctx->mnt_fd, FS_IOC_GETFSLABEL, &label);
+	if (error) {
+		if (errno != EOPNOTSUPP && errno != ENOTTY) {
+			moveon = false;
+			perror(ctx->mntpoint);
+		}
+		goto out;
+	}
+
+	/* Ignore empty labels. */
+	if (label[0] == 0)
+		goto out;
+
+	/* Otherwise check for weirdness. */
+	if (uc)
+		moveon = unicrash_check_fs_label(uc, ctx->mntpoint, label);
+	else
+		moveon = xfs_scrub_check_name(ctx, ctx->mntpoint,
+				_("filesystem label"), label);
+	if (!moveon)
+		goto out;
+out:
+	unicrash_free(uc);
+	return moveon;
+}
+#else
+# define xfs_scrub_fs_label(c)	(true)
+#endif /* HAVE_GETFSLABEL */
+
 /* Check directory connectivity. */
 bool
 xfs_scan_connections(
@@ -296,6 +347,10 @@ _("Filesystem has errors, skipping connectivity checks."));
 		return true;
 	}
 
+	moveon = xfs_scrub_fs_label(ctx);
+	if (!moveon)
+		return false;
+
 	ret = xfs_scan_all_inodes(ctx, xfs_scrub_connections, &moveon);
 	if (!ret)
 		moveon = false;
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index a95fc305..121eedbc 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -465,6 +465,15 @@ unicrash_xattr_init(
 			is_only_root_writable(bstat));
 }
 
+/* Initialize the collision detector for a filesystem label. */
+bool
+unicrash_fs_label_init(
+	struct unicrash		**ucp,
+	struct scrub_ctx	*ctx)
+{
+	return unicrash_init(ucp, ctx, false, 16, true);
+}
+
 /* Free the crash detector. */
 void
 unicrash_free(
@@ -698,3 +707,18 @@ unicrash_check_xattr_name(
 	return __unicrash_check_name(uc, descr, _("extended attribute"),
 			attrname, 0);
 }
+
+/*
+ * Check the fs label for unicode normalization problems or misleading bits.
+ */
+bool
+unicrash_check_fs_label(
+	struct unicrash		*uc,
+	const char		*descr,
+	const char		*label)
+{
+	if (!uc)
+		return true;
+	return __unicrash_check_name(uc, descr, _("filesystem label"),
+			label, 0);
+}
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
index 7d7276a8..85fcabc6 100644
--- a/scrub/unicrash.h
+++ b/scrub/unicrash.h
@@ -17,17 +17,22 @@ bool unicrash_dir_init(struct unicrash **ucp, struct scrub_ctx *ctx,
 		struct xfs_bstat *bstat);
 bool unicrash_xattr_init(struct unicrash **ucp, struct scrub_ctx *ctx,
 		struct xfs_bstat *bstat);
+bool unicrash_fs_label_init(struct unicrash **ucp, struct scrub_ctx *ctx);
 void unicrash_free(struct unicrash *uc);
 bool unicrash_check_dir_name(struct unicrash *uc, const char *descr,
 		struct dirent *dirent);
 bool unicrash_check_xattr_name(struct unicrash *uc, const char *descr,
 		const char *attrname);
+bool unicrash_check_fs_label(struct unicrash *uc, const char *descr,
+		const char *label);
 #else
 # define unicrash_dir_init(u, c, b)		(true)
 # define unicrash_xattr_init(u, c, b)		(true)
+# define unicrash_label_init(u, c)		(true)
 # define unicrash_free(u)			do {(u) = (u);} while (0)
 # define unicrash_check_dir_name(u, d, n)	(true)
 # define unicrash_check_xattr_name(u, d, n)	(true)
+# define unicrash_check_fs_label(u, d, n)	(true)
 #endif /* HAVE_LIBICU */
 
 #endif /* XFS_SCRUB_UNICRASH_H_ */
