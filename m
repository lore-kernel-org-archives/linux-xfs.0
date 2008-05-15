Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 10:15:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4FHFcFR018438
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:15:40 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FFD61730A5
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:16:26 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id zf2In3NbV23Zkwv4 for <xfs@oss.sgi.com>; Thu, 15 May 2008 10:16:26 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4FHGJF3010177
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 19:16:19 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4FHGJ8B010175
	for xfs@oss.sgi.com; Thu, 15 May 2008 19:16:19 +0200
Date: Thu, 15 May 2008 19:16:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC] re-enable test 010
Message-ID: <20080515171619.GA10094@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The dbtest program required for testcase 010 hasn't been build for ages
due to various crufty autofoo magic.  The patch below just builds it
unconditionally for Linux as all distros should have the ndbm compat
bits for libgdbm in the same place.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/src/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfstests/src/Makefile,v
retrieving revision 1.43
diff -u -p -r1.43 Makefile
--- xfstests/src/Makefile	3 Oct 2007 16:23:57 -0000	1.43
+++ xfstests/src/Makefile	15 May 2008 17:13:50 -0000
@@ -15,7 +15,7 @@ TARGETS = dirstress fill fill2 getpagesi
 LINUX_TARGETS = loggen xfsctl bstat t_mtab getdevicesize \
 	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
 	fs_perms testx looptest locktest unwritten_mmap \
-	bulkstat_unlink_test bulkstat_unlink_test_modified
+	bulkstat_unlink_test bulkstat_unlink_test_modified dbtest t_immutable
 
 IRIX_TARGETS = open_unlink
 
@@ -27,14 +27,6 @@ ifeq ($(PKG_PLATFORM),irix)
 TARGETS += $(IRIX_TARGETS)
 endif
 
-ifeq ($(HAVE_DB), true)
-TARGETS += dbtest
-endif
-
-ifeq ($(PKG_PLATFORM),linux)
-TARGETS += t_immutable
-endif
-
 CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS)
 
@@ -50,7 +42,7 @@ truncfile: truncfile.o $(LIBTEST)
 	$(LINKTEST) $(LIBTEST) $(LDLIBS)
 
 dbtest:	dbtest.o $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LIBGDBM) $(LDLIBS)
+	$(LINKTEST) $(LIBTEST) -lgdbm_compat $(LDLIBS)
 
 nametest: nametest.o $(LIBTEST)
 	$(LINKTEST) $(LIBTEST) $(LDLIBS)
Index: xfstests/src/dbtest.c
===================================================================
RCS file: /cvs/xfs-cmds/xfstests/src/dbtest.c,v
retrieving revision 1.6
diff -u -p -r1.6 dbtest.c
--- xfstests/src/dbtest.c	9 Nov 2005 02:50:19 -0000	1.6
+++ xfstests/src/dbtest.c	15 May 2008 17:13:51 -0000
@@ -17,20 +17,7 @@
  */
  
 #include "global.h"
-
-#ifdef HAVE_GDBM_NDBM_H
-#include <gdbm/ndbm.h>
-#else
-#ifdef HAVE_GDBM_H
-#include <gdbm.h>
-#else
-#ifdef HAVE_NDBM_H
-#include <ndbm.h>
-#else
-bozo!
-#endif
-#endif
-#endif
+#include <gdbm-ndbm.h>
 
 
 /* #define WorkDir	"/xfs" */
