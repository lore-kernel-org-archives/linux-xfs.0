Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965179AbdKQTwh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 14:52:37 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 744E8ADBF
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 19:52:36 +0000 (UTC)
From: jeffm@suse.com
Subject: [PATCH 2/2] xfs_io: stat: treat statfs.f_flags as optional
Date: Fri, 17 Nov 2017 14:54:57 -0500
Message-Id: <20171117195457.16218-2-jeffm@suse.com>
In-Reply-To: <20171117195457.16218-1-jeffm@suse.com>
References: <20171117195457.16218-1-jeffm@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

Kernels prior to 2.6.36 didn't contain statfs.f_flags.  Distros with
initial releases with kernels prior to this may not have updated
headers with this member.  Only attempt to print it if we have the
header with the member defined.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 configure.ac          |  1 +
 include/builddefs.in  |  1 +
 io/stat.c             |  2 ++
 m4/package_libcdev.m4 | 14 ++++++++++++++
 4 files changed, 18 insertions(+)

diff --git a/configure.ac b/configure.ac
index 4161c3b4..939d802b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -143,6 +143,7 @@ AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
 AC_HAVE_GETFSMAP
+AC_HAVE_STATFS_FLAGS
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index ec630bd9..13756d79 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -113,6 +113,7 @@ HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 HAVE_GETFSMAP = @have_getfsmap@
+HAVE_STATFS_FLAGS = @have_statfs_flags@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/io/stat.c b/io/stat.c
index 6ab10abf..1ca5b0d6 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -199,7 +199,9 @@ statfs_f(
 		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
 		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
 		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
+#ifdef HAVE_STATFS_FLAGS
 		printf(_("statfs.f_flags = 0x%llx\n"), (long long) st.f_flags);
+#endif
 	}
 	if (file->flags & IO_FOREIGN)
 		return 0;
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index fa5b6397..bc395acd 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -297,3 +297,17 @@ AC_DEFUN([AC_HAVE_GETFSMAP],
        AC_MSG_RESULT(no))
     AC_SUBST(have_getfsmap)
   ])
+
+AC_DEFUN([AC_HAVE_STATFS_FLAGS],
+  [
+    AC_CHECK_TYPE(struct statfs,
+      [
+        AC_CHECK_MEMBER(struct statfs.f_flags,
+          have_statfs_flags=yes,,
+          [#include <sys/vfs.h>]
+        )
+      ],,
+      [#include <sys/vfs.h>]
+    )
+    AC_SUBST(have_statfs_flags)
+  ])
-- 
2.14.2

