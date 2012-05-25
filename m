Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4P7IoXb044138 for <xfs@oss.sgi.com>; Fri, 25 May 2012 02:18:50 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id kmqiZwhw8CjPGB3J (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 00:18:48 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/6] build: remove home-baked long/ptr size detection
Date: Fri, 25 May 2012 09:18:40 +0200
Message-Id: <1337930323-575-4-git-send-email-jengelh@inai.de>
In-Reply-To: <1337930323-575-1-git-send-email-jengelh@inai.de>
References: <1337930323-575-1-git-send-email-jengelh@inai.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jengelh@inai.de

autoconf can do this for us.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac               |    3 ++-
 include/platform_defs.h.in |   28 ++++++++++------------------
 m4/package_types.m4        |   23 -----------------------
 3 files changed, 12 insertions(+), 42 deletions(-)

diff --git a/configure.ac b/configure.ac
index c1181f4..e0237ba 100644
--- a/configure.ac
+++ b/configure.ac
@@ -111,10 +111,11 @@ AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_BLKID_TOPO($enable_blkid)
 
+AC_CHECK_SIZEOF([long])
+AC_CHECK_SIZEOF([char *])
 AC_TYPE_PSINT
 AC_TYPE_PSUNSIGNED
 AC_TYPE_U32
-AC_SIZEOF_POINTERS_AND_LONG
 AC_MANUAL_FORMAT
 
 AC_CONFIG_FILES([include/builddefs])
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 0196cc4..4e1e0c4 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -33,6 +33,7 @@
 #include <pthread.h>
 #include <ctype.h>
 #include <sys/types.h>
+#include <limits.h>
 
 #undef HAVE___U32
 #ifdef HAVE___U32
@@ -77,26 +78,17 @@ typedef struct filldir		filldir_t;
 #endif
 
 /* long and pointer must be either 32 bit or 64 bit */
-#undef HAVE_32BIT_LONG
-#undef HAVE_64BIT_LONG
-#undef HAVE_32BIT_PTR
-#undef HAVE_64BIT_PTR
-
-#if defined(HAVE_32BIT_LONG)
-# define BITS_PER_LONG	32
-#elif defined(HAVE_64BIT_LONG)
-# define BITS_PER_LONG	64
-#else
-# error Unknown long size
-#endif
+#undef SIZEOF_LONG
+#undef SIZEOF_CHAR_P
+#define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
 
 /* Check if __psint_t is set to something meaningful */
 #undef HAVE___PSINT_T
 #ifndef HAVE___PSINT_T
-# ifdef HAVE_32BIT_PTR
+# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
 typedef int __psint_t;
-# elif defined HAVE_64BIT_PTR
-#  ifdef HAVE_64BIT_LONG
+# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
+#  if BITS_PER_LONG == 64
 typedef long __psint_t;
 #  else
 /* This is a very strange architecture, which has 64 bit pointers but */
@@ -111,10 +103,10 @@ typedef long long __psint_t;
 /* Check if __psunsigned_t is set to something meaningful */
 #undef HAVE___PSUNSIGNED_T
 #ifndef HAVE___PSUNSIGNED_T
-# ifdef HAVE_32BIT_PTR
+# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
 typedef unsigned int __psunsigned_t;
-# elif defined HAVE_64BIT_PTR
-#  ifdef HAVE_64BIT_LONG
+# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
+#  if BITS_PER_LONG == 64
 typedef long __psunsigned_t;
 #  else
 /* This is a very strange architecture, which has 64 bit pointers but */
diff --git a/m4/package_types.m4 b/m4/package_types.m4
index 0a0e087..dfcb0d9 100644
--- a/m4/package_types.m4
+++ b/m4/package_types.m4
@@ -39,26 +39,3 @@ AC_DEFUN([AC_TYPE_U32],
          __u32  u32;
     ], AC_DEFINE(HAVE___U32) AC_MSG_RESULT(yes) , AC_MSG_RESULT(no))
   ])
-
-# 
-# Check type sizes
-# 
-AC_DEFUN([AC_SIZEOF_POINTERS_AND_LONG],
-  [ if test "$cross_compiling" = yes -a -z "$ac_cv_sizeof_long"; then
-      AC_MSG_WARN([Cross compiling; assuming 32bit long and 32bit pointers])
-    fi
-    AC_CHECK_SIZEOF(long, 4)
-    AC_CHECK_SIZEOF(char *, 4)
-    if test $ac_cv_sizeof_long -eq 4 -o $ac_cv_sizeof_long -eq 0; then
-      AC_DEFINE(HAVE_32BIT_LONG)
-    fi
-    if test $ac_cv_sizeof_long -eq 8; then
-      AC_DEFINE(HAVE_64BIT_LONG)
-    fi
-    if test $ac_cv_sizeof_char_p -eq 4 -o $ac_cv_sizeof_char_p -eq 0; then
-      AC_DEFINE(HAVE_32BIT_PTR)
-    fi
-    if test $ac_cv_sizeof_char_p -eq 8; then
-      AC_DEFINE(HAVE_64BIT_PTR)
-    fi
-  ])
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
