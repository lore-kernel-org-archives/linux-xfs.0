Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 696FB29DFC
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 14:17:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 578E930404E
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 12:17:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CPFT4Cd3IWmGmb3w (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2015 12:17:23 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4/4] xfs_repair: Validate richacl attributes
Date: Fri, 23 Oct 2015 21:17:08 +0200
Message-Id: <1445627828-14661-5-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445627828-14661-1-git-send-email-agruenba@redhat.com>
References: <1445627828-14661-1-git-send-email-agruenba@redhat.com>
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
To: xfs@oss.sgi.com, david@fromorbit.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

When we have the <sys/richacl.h> header and a working copy of librichacl.a (the
static version of the richacl library), use that to validate richacl attribute
values.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 configure.ac         | 22 ++++++++++++++++++++++
 include/builddefs.in |  5 +++++
 repair/Makefile      |  2 +-
 repair/attr_repair.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 7b57521..2584ea2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -101,6 +101,28 @@ AC_PACKAGE_GLOBALS(xfsprogs)
 AC_PACKAGE_UTILITIES(xfsprogs)
 AC_MULTILIB($enable_lib64)
 
+have_richacl=no
+librichacl=
+AC_CHECK_HEADERS([sys/richacl.h])
+if test "$ac_cv_header_sys_richacl_h" = yes; then
+    AC_CHECK_HEADERS([linux/xattr.h])
+    saved_LIBS=$LIBS
+    librichacl=-l:librichacl.a
+    LIBS="$LIBS $librichacl"
+    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
+	#include <sys/richacl.h>
+    ],[
+	int valid = richacl_valid((struct richacl *)0);
+    ])], [
+	have_richacl=yes
+    ], [
+	librichacl=
+    ])
+    LIBS=$saved_LIBS
+fi
+AC_SUBST([have_richacl])
+AC_SUBST([librichacl])
+
 AC_PACKAGE_NEED_AIO_H
 AC_PACKAGE_NEED_LIO_LISTIO
 
diff --git a/include/builddefs.in b/include/builddefs.in
index c1797fd..b64e027 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -34,6 +34,7 @@ LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
 LIBREADLINE = @libreadline@
 LIBBLKID = @libblkid@
+LIBRICHACL = @librichacl@
 LIBXFS = $(TOPDIR)/libxfs/libxfs.la
 LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
 LIBXLOG = $(TOPDIR)/libxlog/libxlog.la
@@ -108,6 +109,7 @@ HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
+HAVE_RICHACL = @have_richacl@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -147,6 +149,9 @@ endif
 ifeq ($(ENABLE_BLKID),yes)
 PCFLAGS+= -DENABLE_BLKID
 endif
+ifeq ($(HAVE_RICHACL),yes)
+PCFLAGS += -DHAVE_RICHACL
+endif
 
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) \
diff --git a/repair/Makefile b/repair/Makefile
index 251722b..032f453 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -20,7 +20,7 @@ CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
 	progress.c prefetch.c rt.c sb.c scan.c threads.c \
 	versions.c xfs_repair.c
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBRICHACL)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index e03f360..e7f03a8 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -26,6 +26,17 @@
 #include "dir2.h"
 #include "da_util.h"
 
+#ifdef HAVE_RICHACL
+# if HAVE_LINUX_XATTR_H
+#  include <linux/xattr.h>
+# endif
+# ifndef XATTR_RICHACL
+#  define XATTR_RICHACL "richacl"
+# endif
+
+# include <sys/richacl.h>
+#endif
+
 static int xfs_acl_valid(struct xfs_mount *mp, struct xfs_acl *daclp);
 static int xfs_mac_valid(xfs_mac_label_t *lp);
 
@@ -195,6 +206,35 @@ valuecheck(
 		if ( valuelen != sizeof(xfs_cap_set_t))
 			clearit = 1;
 	}
+#if HAVE_RICHACL
+	else if (namelen == strlen(XATTR_RICHACL) &&
+		 strncmp(namevalue, XATTR_RICHACL, strlen(XATTR_RICHACL)) == 0) {
+		struct richacl *acl;
+
+		if (value == NULL) {
+			valuep = malloc(valuelen);
+			if (!valuep)
+				do_error(_("No memory for ACL check!\n"));
+			memcpy(valuep, namevalue + namelen, valuelen);
+		} else
+			valuep = value;
+
+		acl = richacl_from_xattr(valuep, valuelen);
+		if (!acl) {
+			if (errno == ENOMEM)
+				do_error(_("No memory for ACL check!\n"));
+			else
+				clearit = 1;
+		} else {
+			if (richacl_valid(acl) != 0)
+				clearit = 1;
+			richacl_free(acl);
+		}
+
+		if (valuep != value)
+			free(valuep);
+	}
+#endif
 
 	if (clearit)
 		do_warn(_("entry contains illegal value in attribute named %.*s\n"),
@@ -202,7 +242,6 @@ valuecheck(
 	return(clearit);
 }
 
-
 /*
  * this routine validates the attributes in shortform format.
  * a non-zero return repair value means certain attributes are bogus
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
