Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Aug 2008 19:18:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7B2Hbwt007856
	for <xfs@oss.sgi.com>; Sun, 10 Aug 2008 19:17:38 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E142F24196
	for <xfs@oss.sgi.com>; Sun, 10 Aug 2008 19:18:52 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Jfuk96FiTwOLNEtE for <xfs@oss.sgi.com>; Sun, 10 Aug 2008 19:18:52 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m7B2IqIF021074
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 04:18:52 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m7B2IqOU021072
	for xfs@oss.sgi.com; Mon, 11 Aug 2008 04:18:52 +0200
Date: Mon, 11 Aug 2008 04:18:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfsprogs: sparse support
Message-ID: <20080811021852.GA21003@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Allow to compile xfsprogs using the sparse gcc wrapper cgcc and
check for endianess warnings.  First this patch adds explicit --tag=CC
arguments to the libtool invocations because it can't auto-detect
cgcc as a C compiler.  Second add endianess annotations to the __be*
types and the macros operating on them.  And last but not least add
a new doc/sparse.txt describing how to invoke sparse on xfsprogs.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs/include/platform_defs.h.in
===================================================================
--- xfsprogs.orig/include/platform_defs.h.in	2008-08-10 23:04:36.000000000 -0300
+++ xfsprogs/include/platform_defs.h.in	2008-08-10 23:04:39.000000000 -0300
@@ -45,9 +45,17 @@ typedef unsigned long long int	__u64;
 typedef signed long long int	__s64;
 #endif
 
-typedef __u16			__be16;
-typedef __u32			__be32;
-typedef __u64			__be64;
+#ifdef __CHECKER__
+#define __bitwise	__attribute__((bitwise))
+#define __force		__attribute__((force))
+#else
+#define __bitwise
+#define __force
+#endif
+
+typedef __u16 __bitwise		__be16;
+typedef __u32 __bitwise		__be32;
+typedef __u64 __bitwise		__be64;
 
 #if defined(__linux__)
 #include <xfs/linux.h>
Index: xfsprogs/include/xfs_arch.h
===================================================================
--- xfsprogs.orig/include/xfs_arch.h	2008-08-09 16:55:08.000000000 -0300
+++ xfsprogs/include/xfs_arch.h	2008-08-10 23:04:39.000000000 -0300
@@ -41,19 +41,19 @@
 #endif
 
 #ifdef XFS_NATIVE_HOST
-#define cpu_to_be16(val)	((__be16)(val))
-#define cpu_to_be32(val)	((__be32)(val))
-#define cpu_to_be64(val)	((__be64)(val))
-#define be16_to_cpu(val)	((__uint16_t)(val))
-#define be32_to_cpu(val)	((__uint32_t)(val))
-#define be64_to_cpu(val)	((__uint64_t)(val))
+#define cpu_to_be16(val)	((__force __be16)(__u16)(val))
+#define cpu_to_be32(val)	((__force __be32)(__u32)(val))
+#define cpu_to_be64(val)	((__force __be64)(__u64)(val))
+#define be16_to_cpu(val)	((__force __u16)(__be16)(val))
+#define be32_to_cpu(val)	((__force __u32)(__be32)(val))
+#define be64_to_cpu(val)	((__force __u64)(__be64)(val))
 #else
-#define cpu_to_be16(val)	(__swab16((__uint16_t)(val)))
-#define cpu_to_be32(val)	(__swab32((__uint32_t)(val)))
-#define cpu_to_be64(val)	(__swab64((__uint64_t)(val)))
-#define be16_to_cpu(val)	(__swab16((__be16)(val)))
-#define be32_to_cpu(val)	(__swab32((__be32)(val)))
-#define be64_to_cpu(val)	(__swab64((__be64)(val)))
+#define cpu_to_be16(val)	((__force __be16)__swab16((__u16)(val)))
+#define cpu_to_be32(val)	((__force __be32)__swab32((__u32)(val)))
+#define cpu_to_be64(val)	((__force __be64)__swab64((__u64)(val)))
+#define be16_to_cpu(val)	(__swab16((__force __u16)(__be16)(val)))
+#define be32_to_cpu(val)	(__swab32((__force __u32)(__be32)(val)))
+#define be64_to_cpu(val)	(__swab64((__force __u64)(__be64)(val)))
 #endif
 
 #endif	/* __KERNEL__ */
Index: xfsprogs/include/buildmacros
===================================================================
--- xfsprogs.orig/include/buildmacros	2008-08-09 16:55:08.000000000 -0300
+++ xfsprogs/include/buildmacros	2008-08-10 23:04:39.000000000 -0300
@@ -42,10 +42,10 @@ LIBNAME = $(basename $(LTLIBRARY))
 LTOBJECTS = $(OBJECTS:.o=.lo)
 LTVERSION = $(LT_CURRENT):$(LT_REVISION):$(LT_AGE)
 
-LTLINK = $(LIBTOOL) --mode=link $(CC)
+LTLINK = $(LIBTOOL) --tag=CC --mode=link $(CC)
 LTEXEC = $(LIBTOOL) --mode=execute
 LTINSTALL = $(LIBTOOL) --mode=install $(INSTALL)
-LTCOMPILE = $(LIBTOOL) --mode=compile $(CCF)
+LTCOMPILE = $(LIBTOOL) --tag=CC --mode=compile $(CCF)
 
 ifeq ($(ENABLE_SHARED),yes)
 LTLDFLAGS += -rpath $(PKG_LIB_DIR)
Index: xfsprogs/doc/sparse.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs/doc/sparse.txt	2008-08-10 23:15:58.000000000 -0300
@@ -0,0 +1,24 @@
+This document describes how to use the sparse source code checking tool
+to check the source code of the open source XFS commands and utilites
+("xfsprogs").
+
+First you need to install sparse, either from your distribution or from
+source as provided at http://www.kernel.org/pub/software/devel/sparse/.
+
+To simply build the xfsprogs source code while checking the source using
+sparse just set the compiler to cgcc, which is a wrapper that calls both
+sparse and gcc using:
+
+	CC=cgcc ./configure
+
+Now that default warnings from sparse are a little bit verbose checking
+for various not that important things and also complaining about the
+glibc system headers.  It does however not check for bitwise annotation
+which are very important for xfsprogs to verify the endianess handling
+of the on-disk structures is correct.  To get a more reasonable set
+of warnings build xfsprogs using:
+
+	LCFLAGS="-Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl" make
+
+You are of course free to experiment with the warnings flags documented
+in the sparse manpage to check xfsprogs for other issues.
