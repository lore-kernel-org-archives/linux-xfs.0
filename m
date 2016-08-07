Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A487C7CEA
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0AB08AC003
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:47 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id AgzXUUHhDukGgEPF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:46 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 40C1220A78
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:44 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQR4RCXz104R
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:43 +0200 (CEST)
Message-Id: <b68fd1777f0e0a4b24ef48a0c6643ce51fa1d8bf.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sun, 7 Aug 2016 07:28:16 +0200
Subject: [PATCH xfsprogs 02/14] remove unecessary definitions of
	_FILE_OFFSET_BITS
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

now that we use AC_SYS_LARGEFILE, there is no need to explicitly
define _FILE_OFFSET_BITS.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/builddefs.in  | 2 +-
 m4/package_libcdev.m4 | 9 ---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index 7153d7a..d406615 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -114,7 +114,7 @@ GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
 ifeq ($(PKG_PLATFORM),linux)
-PCFLAGS = -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)
+PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
 ifeq ($(HAVE_UMODE_T),yes)
 PCFLAGS += -DHAVE_UMODE_T
 endif
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 7a847e9..9ef6f80 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -5,7 +5,6 @@ AC_DEFUN([AC_HAVE_FADVISE],
   [ AC_MSG_CHECKING([for fadvise ])
     AC_TRY_COMPILE([
 #define _GNU_SOURCE
-#define _FILE_OFFSET_BITS 64
 #include <fcntl.h>
     ], [
 	posix_fadvise(0, 1, 0, POSIX_FADV_NORMAL);
@@ -22,7 +21,6 @@ AC_DEFUN([AC_HAVE_MADVISE],
   [ AC_MSG_CHECKING([for madvise ])
     AC_TRY_COMPILE([
 #define _GNU_SOURCE
-#define _FILE_OFFSET_BITS 64
 #include <sys/mman.h>
     ], [
 	posix_madvise(0, 0, MADV_NORMAL);
@@ -39,7 +37,6 @@ AC_DEFUN([AC_HAVE_MINCORE],
   [ AC_MSG_CHECKING([for mincore ])
     AC_TRY_COMPILE([
 #define _GNU_SOURCE
-#define _FILE_OFFSET_BITS 64
 #include <sys/mman.h>
     ], [
 	mincore(0, 0, 0);
@@ -56,7 +53,6 @@ AC_DEFUN([AC_HAVE_SENDFILE],
   [ AC_MSG_CHECKING([for sendfile ])
     AC_TRY_COMPILE([
 #define _GNU_SOURCE
-#define _FILE_OFFSET_BITS 64
 #include <sys/sendfile.h>
     ], [
          sendfile(0, 0, 0, 0);
@@ -106,7 +102,6 @@ AC_DEFUN([AC_HAVE_FALLOCATE],
   [ AC_MSG_CHECKING([for fallocate])
     AC_TRY_LINK([
 #define _GNU_SOURCE
-#define _FILE_OFFSET_BITS 64
 #include <fcntl.h>
 #include <linux/falloc.h>
     ], [
@@ -124,7 +119,6 @@ AC_DEFUN([AC_HAVE_FIEMAP],
   [ AC_MSG_CHECKING([for fiemap])
     AC_TRY_LINK([
 #define _GNU_SOURCE
-#define _FILE_OFFSET_BITS 64
 #include <linux/fs.h>
 #include <linux/fiemap.h>
     ], [
@@ -142,7 +136,6 @@ AC_DEFUN([AC_HAVE_FIEMAP],
 AC_DEFUN([AC_HAVE_PREADV],
   [ AC_MSG_CHECKING([for preadv])
     AC_TRY_LINK([
-#define _FILE_OFFSET_BITS 64
 #define _BSD_SOURCE
 #include <sys/uio.h>
     ], [
@@ -177,7 +170,6 @@ AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
   [ AC_MSG_CHECKING([for sync_file_range])
     AC_TRY_LINK([
 #define _GNU_SOURCE
-#define _FILE_OFFSET_BITS 64
 #include <fcntl.h>
     ], [
          sync_file_range(0, 0, 0, 0);
@@ -194,7 +186,6 @@ AC_DEFUN([AC_HAVE_SYNCFS],
   [ AC_MSG_CHECKING([for syncfs])
     AC_TRY_LINK([
 #define _GNU_SOURCE
-#define _FILE_OFFSET_BITS 64
 #include <unistd.h>
     ], [
          syncfs(0);
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
