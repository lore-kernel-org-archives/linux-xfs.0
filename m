Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41160 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964997AbcJQTNv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 15:13:51 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] mkfs.xfs: fix static-lib build
Date: Mon, 17 Oct 2016 15:13:27 -0400
Message-Id: <20161017191327.16838-1-tytso@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, Theodore Ts'o <tytso@mit.edu>

From: Dmitry Monakhov <dmonakhov@openvz.org>

Order is important for static libraries, libblkid depends on libuuid.
We have to pass libuuid after libblkid, otherwise it fails like this:
#make mkfs.xfs
    [LD]     mkfs.xfs
    /bin/bash ../libtool --quiet --tag=CC --mode=link gcc -o mkfs.xfs -static -L/devel/xfstests-bld.git/bld/lib -static-libtool-libs  maxtrres.o proto.o xfs_mkfs.o   ../libxfs/libxfs.la ../libxcmd/libxcmd.la -luuid -lrt -lpthread -lblkid
    /devel/xfstests-bld.git/bld/lib/libblkid.a(probe.o): In function `set_uuid':
    /devel/xfstests-bld.git/e2fsprogs-libs/lib/blkid/probe.c:132: undefined reference to `uuid_is_null'
    /devel/xfstests-bld.git/e2fsprogs-libs/lib/blkid/probe.c:133: undefined reference to `uuid_unparse'
    /devel/xfstests-bld.git/bld/lib/libblkid.a(probe.o): In function `get_ext2_info':
    /devel/xfstests-bld.git/e2fsprogs-libs/lib/blkid/probe.c:156: undefined reference to `uuid_is_null'
    collect2: error: ld returned 1 exit status
    ../include/buildrules:45: recipe for target 'mkfs.xfs' failed
    make: *** [mkfs.xfs] Error 1

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 mkfs/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/Makefile b/mkfs/Makefile
index 170e3c1..c13b903 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -10,7 +10,7 @@ LTCOMMAND = mkfs.xfs
 HFILES =
 CFILES = maxtrres.c proto.c xfs_mkfs.c
 
-LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID)
+LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) $(LIBUUID)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD)
 LLDFLAGS = -static-libtool-libs
 
-- 
2.9.3

