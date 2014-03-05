Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3DD17F5F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 09:52:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71867AC007
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 07:52:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lquyMoilus7fptzy for
	<xfs@oss.sgi.com>; Wed, 05 Mar 2014 07:52:00 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 4/8] xfstests: Move fallocate include into global.h
Date: Wed,  5 Mar 2014 16:51:35 +0100
Message-Id: <1394034699-21187-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, lczerner@redhat.com, xfs@oss.sgi.com

Move the inclusion of falloc.h with all it's possible defines for the
fallocate mode into global.h header file so we do not have to include
and define it manually in every tool using fallocate.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 configure.ac   |  3 ++-
 ltp/fsstress.c | 11 ++---------
 ltp/fsx.c      | 11 ++++-------
 src/global.h   | 25 +++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6fba3ad..2f95c4c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -25,7 +25,8 @@ AC_HEADER_STDC
 			sys/wait.h		\
 			sys/types.h		\
 			strings.h		\
-			err.h
+			err.h			\
+			linux/falloc.h
     ])
     AC_CHECK_HEADERS([	sys/fs/xfs_fsops.h	\
 			sys/fs/xfs_itable.h	\
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index c56f168..7dec7c6 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -27,13 +27,6 @@
 #ifdef HAVE_LINUX_FIEMAP_H
 #include <linux/fiemap.h>
 #endif
-#ifdef FALLOCATE
-#include <linux/falloc.h>
-#ifndef FALLOC_FL_PUNCH_HOLE
-/* Copy-paste from linux/falloc.h */
-#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
-#endif
-#endif
 #ifndef HAVE_ATTR_LIST
 #define attr_list(path, buf, size, flags, cursor) (errno = -ENOSYS, -1)
 #endif
@@ -2085,7 +2078,7 @@ dwrite_f(int opno, long r)
 void
 fallocate_f(int opno, long r)
 {
-#ifdef FALLOCATE
+#ifdef HAVE_LINUX_FALLOC_H
 	int		e;
 	pathname_t	f;
 	int		fd;
@@ -2507,7 +2500,7 @@ mknod_f(int opno, long r)
 void
 punch_f(int opno, long r)
 {
-#ifdef FALLOCATE
+#ifdef HAVE_LINUX_FALLOC_H
 	int		e;
 	pathname_t	f;
 	int		fd;
diff --git a/ltp/fsx.c b/ltp/fsx.c
index 2f1e3e8..c36a038 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -33,9 +33,6 @@
 #ifdef AIO
 #include <libaio.h>
 #endif
-#ifdef FALLOCATE
-#include <linux/falloc.h>
-#endif
 
 #ifndef MAP_FILE
 # define MAP_FILE 0
@@ -882,7 +879,7 @@ do_punch_hole(unsigned offset, unsigned length)
 }
 #endif
 
-#ifdef FALLOCATE
+#ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
 do_preallocate(unsigned offset, unsigned length)
@@ -1139,7 +1136,7 @@ usage(void)
 "	-A: Use the AIO system calls\n"
 #endif
 "	-D startingop: debug output starting at specified operation\n"
-#ifdef FALLOCATE
+#ifdef HAVE_LINUX_FALLOC_H
 "	-F: Do not use fallocate (preallocation) calls\n"
 #endif
 #ifdef FALLOC_FL_PUNCH_HOLE
@@ -1296,7 +1293,7 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
 void
 test_fallocate()
 {
-#ifdef FALLOCATE
+#ifdef HAVE_LINUX_FALLOC_H
 	if (!lite && fallocate_calls) {
 		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
 			if(!quiet)
@@ -1306,7 +1303,7 @@ test_fallocate()
 			ftruncate(fd, 0);
 		}
 	}
-#else /* ! FALLOCATE */
+#else /* ! HAVE_LINUX_FALLOC_H */
 	fallocate_calls = 0;
 #endif
 
diff --git a/src/global.h b/src/global.h
index e6a2c2b..8180f66 100644
--- a/src/global.h
+++ b/src/global.h
@@ -149,4 +149,29 @@
 #include <sys/param.h>
 #endif
 
+#ifdef HAVE_LINUX_FALLOC_H
+#include <linux/falloc.h>
+
+#ifndef FALLOC_FL_KEEP_SIZE
+#define FALLOC_FL_KEEP_SIZE		0x01
+#endif
+
+#ifndef FALLOC_FL_PUNCH_HOLE
+#define FALLOC_FL_PUNCH_HOLE		0x02
 #endif
+
+#ifndef FALLOC_FL_NO_HIDE_STALE
+#define FALLOC_FL_NO_HIDE_STALE		0x04
+#endif
+
+#ifndef FALLOC_FL_COLLAPSE_RANGE
+#define FALLOC_FL_COLLAPSE_RANGE	0x08
+#endif
+
+#ifndef FALLOC_FL_ZERO_RANGE
+#define FALLOC_FL_ZERO_RANGE		0x10
+#endif
+
+#endif /* HAVE_LINUX_FALLOC_H */
+
+#endif /* GLOBAL_H */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
