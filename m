Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LBVnN1068998 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 05:31:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C370317C452
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:32:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2BRwlkiIWAkgySJC for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:32:50 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NXvHO-0000xI-5y
	for xfs@oss.sgi.com; Thu, 21 Jan 2010 11:32:50 +0000
Date: Thu, 21 Jan 2010 06:32:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: simplify build of preallo_rw_pattern_reader/writer
Message-ID: <20100121113250.GA3580@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Instead of having complicated build system hacks just create two two-line
source files defining READ/WRITE and including iopat.c


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/src/Makefile
===================================================================
--- xfstests-dev.orig/src/Makefile	2010-01-21 11:24:43.000000000 +0000
+++ xfstests-dev/src/Makefile	2010-01-21 11:26:09.000000000 +0000
@@ -51,19 +51,9 @@ LDIRT = $(TARGETS)
 
 default: $(TARGETS) $(SUBDIRS)
 
-PREALLO_TARGETS = preallo_rw_pattern_reader preallo_rw_pattern_writer
-
 include $(BUILDRULES)
 
-preallo_rw_pattern_reader:
-	@echo "    [CC]    $@"
-	$(Q)$(LTLINK) iopat.c -DREAD -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
-
-preallo_rw_pattern_writer:
-	@echo "    [CC]    $@"
-	$(Q)$(LTLINK) iopat.c -DWRITE -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
-
-$(filter-out $(PREALLO_TARGETS), $(TARGETS)): $(LIBTEST)
+$(TARGETS): $(LIBTEST)
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
Index: xfstests-dev/src/preallo_rw_pattern_reader.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/src/preallo_rw_pattern_reader.c	2010-01-21 11:24:19.000000000 +0000
@@ -0,0 +1,2 @@
+#define READ
+#include "iopat.c"
Index: xfstests-dev/src/preallo_rw_pattern_writer.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/src/preallo_rw_pattern_writer.c	2010-01-21 11:24:30.000000000 +0000
@@ -0,0 +1,2 @@
+#define WRITE
+#include "iopat.c"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
