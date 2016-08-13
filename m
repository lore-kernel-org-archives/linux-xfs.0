Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 669C17CAF
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:26:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38B45304048
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:26:34 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id mTjhqz4UGalIFF8z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:26:32 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 1D9C320449
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:26:30 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTFK4SNBz104L
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:26:29 +0200 (CEST)
Resent-Message-ID: <20160813172533.GM3858@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <ee6222efd5b5b46e61b25bc9bd4ea222d3d3b188.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 13 Aug 2016 18:50:28 +0200
Subject: [PATCHv2 xfsprogs 02/14] configure: error out when LFS does not work
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

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 configure.ac          |  1 +
 m4/package_libcdev.m4 | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/configure.ac b/configure.ac
index 8fa96a5..ed75d62 100644
--- a/configure.ac
+++ b/configure.ac
@@ -108,6 +108,7 @@ AC_MULTILIB($enable_lib64)
 AC_RT($enable_librt)
 
 AC_SYS_LARGEFILE
+AC_NEED_LFS
 
 AC_PACKAGE_NEED_UUID_H
 AC_PACKAGE_NEED_UUIDCOMPARE
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 7a847e9..6c94475 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -265,3 +265,19 @@ AC_DEFUN([AC_HAVE_MREMAP],
        )
     AC_SUBST(have_mremap)
   ])
+
+#
+# Check if transparent LFS is enabled
+#
+AC_DEFUN([AC_NEED_LFS],
+  [ AC_MSG_CHECKING([whether large file support works])
+    AC_TRY_COMPILE([
+#include <unistd.h>
+    ], [
+         int i[sizeof(off_t)-8];
+    ], AC_MSG_RESULT(yes),
+       [AC_MSG_RESULT(no)
+       echo
+       echo 'FATAL ERROR: C library does not support transparent LFS.'
+       exit 1])
+  ])
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
