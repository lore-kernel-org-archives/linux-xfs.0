Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFZCho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:37:44 -0400
Subject: [PATCH 08/10] xfs_db: remove db/convert.h
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Jun 2019 19:37:40 -0700
Message-ID: <156151666004.2286979.13481028354802408933.stgit@magnolia>
In-Reply-To: <156151660523.2286979.13694849827562044045.stgit@magnolia>
References: <156151660523.2286979.13694849827562044045.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

db/convert.h conflicts with include/convert.h and since the former only
has one declaration in it anyway, just get rid of it.  We'll need this
in the next patch to avoid an ugly include mess.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile  |    4 ++--
 db/command.c |    1 -
 db/command.h |    1 +
 db/convert.c |    1 -
 db/convert.h |    7 -------
 5 files changed, 3 insertions(+), 11 deletions(-)
 delete mode 100644 db/convert.h


diff --git a/db/Makefile b/db/Makefile
index 8fecfc1c..0941b32e 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -8,13 +8,13 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_db
 
 HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
-	btblock.h bmroot.h check.h command.h convert.h crc.h debug.h \
+	btblock.h bmroot.h check.h command.h crc.h debug.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c info.c
+CFILES = $(HFILES:.h=.c) btdump.c convert.c info.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/db/command.c b/db/command.c
index c7c52342..89a78f03 100644
--- a/db/command.c
+++ b/db/command.c
@@ -11,7 +11,6 @@
 #include "bmap.h"
 #include "check.h"
 #include "command.h"
-#include "convert.h"
 #include "debug.h"
 #include "type.h"
 #include "echo.h"
diff --git a/db/command.h b/db/command.h
index eacfd465..2f9a7e16 100644
--- a/db/command.h
+++ b/db/command.h
@@ -28,5 +28,6 @@ extern int		command(int argc, char **argv);
 extern const cmdinfo_t	*find_command(const char *cmd);
 extern void		init_commands(void);
 
+extern void		convert_init(void);
 extern void		btdump_init(void);
 extern void		info_init(void);
diff --git a/db/convert.c b/db/convert.c
index 01a08823..e1466057 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -6,7 +6,6 @@
 
 #include "libxfs.h"
 #include "command.h"
-#include "convert.h"
 #include "output.h"
 #include "init.h"
 
diff --git a/db/convert.h b/db/convert.h
deleted file mode 100644
index 3660cabe..00000000
--- a/db/convert.h
+++ /dev/null
@@ -1,7 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-extern void	convert_init(void);
