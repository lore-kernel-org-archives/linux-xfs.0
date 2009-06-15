Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5FJgZUI121781 for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 14:42:36 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C15452F9AE7
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 12:42:59 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 8awP7hnASOBBKKWI for
	<xfs@oss.sgi.com>; Mon, 15 Jun 2009 12:42:59 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 13F149A2F8B
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 14:42:57 -0500 (CDT)
Message-ID: <4A36A448.4060406@sandeen.net>
Date: Mon, 15 Jun 2009 14:43:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: xfs_io: fix test for fallocate on 32bit boxes
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

xfs_io: fix test for fallocate on 32bit boxes

As per Red Hat bug 500487, fallocate64 is missing in glibc,
so attempts to build with fallocate and _FILE_OFFSET_BITS=64
will fail.

So, change the config to test the way we will build, and
it'll fail properly on x86 until glibc gets fixed.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 1ac4666..1c1859d 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -105,6 +105,9 @@ AC_DEFUN([AC_HAVE_GETMNTINFO],
 AC_DEFUN([AC_HAVE_FALLOCATE],
   [ AC_MSG_CHECKING([for fallocate])
     AC_TRY_LINK([
+#define _GNU_SOURCE
+#define _FILE_OFFSET_BITS 64
+#include <fcntl.h>
 #include <linux/falloc.h>
     ], [
          fallocate(0, 0, 0, 0);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
