Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07C097F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 07:04:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A99FAC006
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:04:47 -0700 (PDT)
Received: from mail-qa0-f47.google.com (mail-qa0-f47.google.com
	[209.85.216.47]) by cuda.sgi.com with ESMTP id igBrOaL2TcGS6jUv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 May 2014 05:04:45 -0700 (PDT)
Received: by mail-qa0-f47.google.com with SMTP id s7so221689qap.34
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:04:45 -0700 (PDT)
From: Jeff Layton <jlayton@poochiereds.net>
Subject: [xfstests PATCH v2] loggen: fix build vs. newer xfsprogs headers
Date: Tue, 13 May 2014 08:04:39 -0400
Message-Id: <1399982679-15544-1-git-send-email-jlayton@poochiereds.net>
In-Reply-To: <1399982043-8693-1-git-send-email-jlayton@poochiereds.net>
References: <1399982043-8693-1-git-send-email-jlayton@poochiereds.net>
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

v2: just include xfs/libxfs.h for the conftest prerequisites

commit cc085d770adb in xfsprogs removed some header files that are
included by loggen.c. Add an autoconf test that checks to see whether
xfs_log_format.h is present. If it is, include that instead of the
deprecated headers and add an alias for XFS_TRANS_MAGIC since that
value no longer exists.

With this patch, xfstests builds on both f20 and rawhide (f21) boxes.

Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
---
 configure.ac | 7 ++++---
 src/loggen.c | 7 +++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 43e6029193a6..53459d87f930 100644
--- a/configure.ac
+++ b/configure.ac
@@ -26,14 +26,15 @@ AC_HEADER_STDC
 			sys/types.h		\
 			strings.h		\
 			err.h			\
-			linux/falloc.h
-    ])
-    AC_CHECK_HEADERS([	sys/fs/xfs_fsops.h	\
+			linux/falloc.h		\
+			sys/fs/xfs_fsops.h	\
 			sys/fs/xfs_itable.h	\
 			xfs/platform_defs.h	\
 			btrfs/ioctl.h		\
     ])
 
+AC_CHECK_HEADERS([xfs/xfs_log_format.h],,,[#include <xfs/libxfs.h>])
+
 AC_PACKAGE_NEED_UUIDCOMPARE
 
 case $pkg_platform
diff --git a/src/loggen.c b/src/loggen.c
index 522c9178ee26..a3d99f8c915f 100644
--- a/src/loggen.c
+++ b/src/loggen.c
@@ -25,9 +25,16 @@
  *                                                  - dxm 29/09/00
  */
 
+#include <config.h>
+
 #include <xfs/libxfs.h>
+#ifdef HAVE_XFS_XFS_LOG_FORMAT_H
+#include <xfs/xfs_log_format.h>
+#define XFS_TRANS_MAGIC	XFS_TRANS_HEADER_MAGIC
+#else /* HAVE_XFS_XFS_LOG_FORMAT_H */
 #include <xfs/xfs_log.h>
 #include <xfs/xfs_log_priv.h>
+#endif /* HAVE_XFS_XFS_LOG_FORMAT_H */
 
 #ifndef ASSIGN_ANY_LSN_DISK
 #define ASSIGN_ANY_LSN_DISK(lsn,cycle,block)  \
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
