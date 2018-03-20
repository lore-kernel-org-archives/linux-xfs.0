Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:56937 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753158AbeCTMWP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 08:22:15 -0400
From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] xfs_scrub: fix cross compile with libunistring
Date: Tue, 20 Mar 2018 14:21:56 +0200
Message-Id: <45d9ba0f01cceb75f72d157a9e4d9aaeb753a9c4.1521548516.git.baruch@tkos.co.il>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>, "Darrick J . Wong" <darrick.wong@oracle.com>

Commit 4bbed4ecc2a (xfs_scrub: warn about normalized Unicode name collisions)
added -lunistring to the list of the xfs_scrub dependencies. When cross
compiling make fails to find the library on the target sysroot:

make[3]: *** No rule to make target `-lunistring', needed by `xfs_scrub'.  Stop.

Remove -lunistring from make dependencies of xfs_scrub to fix that.

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 scrub/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scrub/Makefile b/scrub/Makefile
index 949f6fd8ba94..979603f524ff 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -69,7 +69,7 @@ vfs.c \
 xfs_scrub.c
 
 LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUNISTRING) $(LIBRT)
-LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG) $(LIBUNISTRING) $(LIBRT)
+LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG) $(LIBRT)
 LLDFLAGS = -static-libtool-libs
 
 ifeq ($(HAVE_MALLINFO),yes)
-- 
2.16.2

