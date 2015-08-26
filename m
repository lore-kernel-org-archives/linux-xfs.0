Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC7E37F54
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0DC8304051
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PlS72pZC848csnLU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:46 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 04/11] xfsprogs: Add autoconf check for fsetxattr call
Date: Wed, 26 Aug 2015 14:02:28 +0200
Message-Id: <1440590555-20463-4-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590555-20463-1-git-send-email-jtulak@redhat.com>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

OS X has fsetxattr() in another header and with different arguments.
For now, check for the Linux variant and if not available, skip
the code using the call.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 configure.ac          |  1 +
 fsr/xfs_fsr.c         |  2 ++
 include/builddefs.in  |  4 ++++
 m4/package_libcdev.m4 | 13 +++++++++++++
 4 files changed, 20 insertions(+)

diff --git a/configure.ac b/configure.ac
index 0446620..13aa308 100644
--- a/configure.ac
+++ b/configure.ac
@@ -123,6 +123,7 @@ AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_MNTENT
 AC_HAVE_FLS
 AC_HAVE_READDIR
+AC_HAVE_FSETXATTR
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index b673761..e1b7bd6 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1025,6 +1025,7 @@ fsr_setup_attr_fork(
 	int		tfd,
 	xfs_bstat_t	*bstatp)
 {
+#ifdef HAVE_FSETXATTR
 	struct stat64	tstatbuf;
 	int		i;
 	int		diff = 0;
@@ -1199,6 +1200,7 @@ out:
 	if (dflag && diff)
 		fsrprintf(_("failed to match fork offset\n"));;
 
+#endif /* HAVE_FSETXATTR */
 	return 0;
 }
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 6c16a65..25b8816 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -106,6 +106,7 @@ HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_READDIR = @have_readdir@
 HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
+HAVE_FSETXATTR = @have_fsetxattr@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -139,6 +140,9 @@ endif
 ifeq ($(HAVE_MNTENT),yes)
 PCFLAGS+= -DHAVE_MNTENT
 endif
+ifeq ($(HAVE_FSETXATTR),yes)
+PCFLAGS+= -DHAVE_FSETXATTR
+endif
 ifeq ($(ENABLE_BLKID),yes)
 PCFLAGS+= -DENABLE_BLKID
 endif
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 4a96374..5e900ab 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -215,6 +215,19 @@ AC_DEFUN([AC_HAVE_FLS],
   ])
 
 #
+# Check if we have a fsetxattr call (Mac OS X)
+#
+AC_DEFUN([AC_HAVE_FSETXATTR],
+  [ AC_CHECK_DECL([fsetxattr],
+       have_fsetxattr=yes,
+       [],
+       [#include <sys/types.h>
+        #include <attr/xattr.h>]
+       )
+    AC_SUBST(have_fsetxattr)
+  ])
+
+#
 # Check if there is mntent.h
 #
 AC_DEFUN([AC_HAVE_MNTENT],
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
