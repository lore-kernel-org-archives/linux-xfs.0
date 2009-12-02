Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2JZ8fq033194 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 13:35:08 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21B6911DC530
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 11:35:38 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Dx2Ao1iuDYBMUtSo for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 11:35:38 -0800 (PST)
Received: from liberator.sandeen.net (sandeen.net [209.173.210.139])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 3FF11A7DC0A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 13:35:38 -0600 (CST)
Message-ID: <4B16C181.4070601@sandeen.net>
Date: Wed, 02 Dec 2009 13:35:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix up aio-dio install & build
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

commit bd53c922 added src/aio-dio-regress to the top-level
Makefile so that it would get caught on make install, but
doing this unconditionally means that we tried to build that
subdir even if libaio headers weren't found.

Fix this up to do a properly chained make install through
the subdirs...

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/Makefile b/Makefile
index 4dcb779..b017580 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 	check.log check.time
 
 LIB_SUBDIRS = include lib
-TOOL_SUBDIRS = ltp src src/aio-dio-regress m4
+TOOL_SUBDIRS = ltp src m4
 
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
diff --git a/src/Makefile b/src/Makefile
index 7b01754..9f19605 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -135,8 +135,11 @@ open_unlink: open_unlink.o $(LIBHANDLE)
 
 endif
 
-install:
+install: $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src
 	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
 	$(INSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh $(PKG_LIB_DIR)/src
 	$(INSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src
+
+%-install:
+	$(MAKE) -C $* install

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
