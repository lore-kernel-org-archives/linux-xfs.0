Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B14C87F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 10:02:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92BEB304066
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 08:02:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2N0C2AMCCbc4cHFA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 08:02:34 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v4 03/11] xfsprogs: Add fls check into autoconf
Date: Mon, 17 Aug 2015 17:02:31 +0200
Message-Id: <1439823751-7335-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <117593154.2602203.1438690346097.JavaMail.zimbra@redhat.com>
References: <117593154.2602203.1438690346097.JavaMail.zimbra@redhat.com>
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

UPDATE: Autoconf change. Hopefully this is what Chris meant.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 configure.ac          |  1 +
 include/bitops.h      |  2 ++
 include/builddefs.in  |  4 ++++
 m4/package_libcdev.m4 | 12 ++++++++++++
 4 files changed, 19 insertions(+)

diff --git a/configure.ac b/configure.ac
index 0aba90c..abb7904 100644
--- a/configure.ac
+++ b/configure.ac
@@ -116,6 +116,7 @@ AC_HAVE_FIEMAP
 AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_MNTENT
+AC_HAVE_FLS
 AC_HAVE_BLKID_TOPO
 AC_HAVE_READDIR
 
diff --git a/include/bitops.h b/include/bitops.h
index 930f64a..44599a7 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -5,6 +5,7 @@
  * fls: find last bit set.
  */
 
+#ifndef HAVE_FLS
 static inline int fls(int x)
 {
 	int r = 32;
@@ -32,6 +33,7 @@ static inline int fls(int x)
 	}
 	return r;
 }
+#endif /* HAVE_FLS */
 
 static inline int fls64(__u64 x)
 {
diff --git a/include/builddefs.in b/include/builddefs.in
index e522243..8851956 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -104,6 +104,7 @@ HAVE_PREADV = @have_preadv@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_READDIR = @have_readdir@
 HAVE_MNTENT = @have_mntent@
+HAVE_FLS = @have_fls@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -131,6 +132,9 @@ PLDLIBS = -L/usr/local/lib -lintl
 PCFLAGS = -I/usr/local/include $(GCCFLAGS)
 DEPENDFLAGS = -D__FreeBSD__
 endif
+ifeq ($(HAVE_FLS),yes)
+LCFLAGS+= -DHAVE_FLS
+endif
 ifeq ($(HAVE_MNTENT),yes)
 PCFLAGS+= -DHAVE_MNTENT
 endif
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 75aa61e..4a96374 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -203,6 +203,18 @@ AC_DEFUN([AC_HAVE_READDIR],
   ])
 
 #
+# Check if we have a flc call (Mac OS X)
+#
+AC_DEFUN([AC_HAVE_FLS],
+  [ AC_CHECK_DECL([fls],
+       have_fls=yes,
+       [],
+       [#include <string.h>]
+       )
+    AC_SUBST(have_fls)
+  ])
+
+#
 # Check if there is mntent.h
 #
 AC_DEFUN([AC_HAVE_MNTENT],
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
