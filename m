Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J8wiQi177980 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 02:58:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80643173460
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 00:59:42 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	LUasShtDQAavuhbj for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 00:59:42 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11709898-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:29:41 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX9w3-0003fM-DB
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 19:59:39 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX9w2-00080z-K6
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 19:59:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfstests: Use common rules to build binaries
Date: Tue, 19 Jan 2010 19:59:34 +1100
Message-Id: <1263891574-30762-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263891574-30762-1-git-send-email-david@fromorbit.com>
References: <1263891574-30762-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove explicit target-per-file rules in the subdirectories being
built and replace them with target based rules using the buildrules
hooks for doing this.  This results in the makefiles being simpler,
smaller and more consistent. It does mean that all binaries are
linked against the common set of libraries but this does not cause
any harm.

This patch does not address the dmapi subdirectory of the xfstests
build system.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 ltp/Makefile                 |   31 +++----------
 src/Makefile                 |  101 +++++++-----------------------------------
 src/aio-dio-regress/Makefile |    7 ++-
 3 files changed, 29 insertions(+), 110 deletions(-)

diff --git a/ltp/Makefile b/ltp/Makefile
index bcdac84..fee10f5 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -10,47 +10,32 @@ CFILES = $(TARGETS:=.c)
 HFILES = doio.h
 LDIRT = $(TARGETS)
 LCFLAGS = -DXFS
-IFLAG = -I$(TOPDIR)/src #Used for including $(TOPDIR)/src/global.h
+LCFLAGS += -I$(TOPDIR)/src #Used for including $(TOPDIR)/src/global.h
 
 ifeq ($(HAVE_ATTR_LIST), true)
 LCFLAGS += -DHAVE_ATTR_LIST
+LLDLIBS += $(LIBATTR)
 endif
 ifeq ($(PKG_PLATFORM),irix)
 LCFLAGS += -DHAVE_ATTR_LIST
+LLDLIBS += $(LIBATTR)
 endif
 
 ifeq ($(HAVE_AIO), true)
 TARGETS += aio-stress
 LCFLAGS += -DAIO
-LIBAIO = -laio -lpthread
+LLDLIBS += -laio -lpthread
 endif
 
 default: $(TARGETS)
 
 include $(BUILDRULES)
-LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS)
 
-doio: doio.c $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(IFLAG)
+$(TARGETS): $(LIBTEST)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
-fsstress: fsstress.c $(LIBATTR) $(LIBTEST)
-	$(LINKTEST) $(LIBATTR) $(LIBTEST) $(LDLIBS)  $(IFLAG)
-
-fsx: fsx.c
-	$(LINKTEST) $(LIBAIO) $(LDLIBS)  $(IFLAG)
-
-growfiles: growfiles.c $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LDLIBS)  $(IFLAG)
-
-iogen: iogen.c $(LIBTEST)
-	$(LINKTEST) $(LIBTEST)  $(IFLAG)
-
-ifeq ($(HAVE_AIO), true)
-aio-stress: aio-stress.c
-	$(LINKTEST) $(LIBAIO) $(LDLIBS)
-endif
-
-install:
+install: default
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/ltp
 	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/ltp
 
diff --git a/src/Makefile b/src/Makefile
index 71a32c9..e2a42ce 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,6 +18,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize \
 	bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset \
 	t_futimens
 
+LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
+
 ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
 LINUX_TARGETS += loggen
 endif
@@ -26,18 +28,17 @@ IRIX_TARGETS = open_unlink
 
 ifeq ($(PKG_PLATFORM),linux)
 TARGETS += $(LINUX_TARGETS)
+TARGETS += t_immutable
 endif
 
 ifeq ($(PKG_PLATFORM),irix)
 TARGETS += $(IRIX_TARGETS)
+LLDLIBS += -lgen
 endif
 
 ifeq ($(HAVE_DB), true)
 TARGETS += dbtest
-endif
-
-ifeq ($(PKG_PLATFORM),linux)
-TARGETS += t_immutable
+LLDLIBS += $(LIBGDBM)
 endif
 
 ifeq ($(HAVE_AIO), true)
@@ -47,96 +48,28 @@ endif
 CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS)
 
-default: $(TARGETS) $(SUBDIRS)
-
-include $(BUILDRULES)
-LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS)
-
-randholes: randholes.o $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LDLIBS)
-
-truncfile: truncfile.o $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LDLIBS)
-
-dbtest:	dbtest.o $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LIBGDBM) $(LDLIBS)
-
-genhashnames: genhashnames.o
-	$(LINKTEST)
-
-nametest: nametest.o $(LIBTEST)
-	$(LINKTEST) $(LIBTEST) $(LDLIBS)
-
-bstat: bstat.o
-	$(LINKTEST) $(LIBHANDLE) $(LDLIBS)
-
-t_immutable: t_immutable.o
-	$(LINKTEST) $(LIBACL) $(LIBHANDLE) $(LDLIBS)
-
-loggen:	loggen.o
-	$(LINKTEST) $(LDLIBS)
 
-fstest:	fstest.o
-	$(LINKTEST)
-
-resvtest: resvtest.o
-	$(LINKTEST)
-
-itrash:	itrash.o
-	$(LINKTEST)
-
-multi_open_unlink: multi_open_unlink.o
-	$(LINKTEST) $(LIBATTR) $(LDLIBS)
-
-#scaleread: scaleread.o $(LDLIBS)
-#	$(LINKTEST)
+default: $(TARGETS) $(SUBDIRS)
 
-acl_get: acl_get.o
-	$(LINKTEST) $(LIBACL) $(LIBATTR) $(LDLIBS)
+PREALLO_TARGETS = preallo_rw_pattern_reader preallo_rw_pattern_writer
 
-dmiperf: dmiperf.o
-	$(LINKTEST) $(LIBATTR) $(LDLIBS)
+include $(BUILDRULES)
 
 preallo_rw_pattern_reader:
-	$(CC) $(GCFLAGS) $(LDFLAGS) -DREAD iopat.c -o preallo_rw_pattern_reader
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) iopat.c -DREAD -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
 preallo_rw_pattern_writer:
-	$(CC) $(GCFLAGS) $(LDFLAGS) -DWRITE iopat.c -o preallo_rw_pattern_writer
-
-ftrunc: ftrunc.o
-	$(LINKTEST)
-
-trunc: trunc.o
-	$(LINKTEST)
-
-fs_perms: fs_perms.o
-	$(LINKTEST)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) iopat.c -DWRITE -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
-testx: testx.o
-	$(LINKTEST)
+$(filter-out $(PREALLO_TARGETS), $(TARGETS)): $(LIBTEST)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
-looptest: looptest.o
-	$(LINKTEST)
-
-locktest: locktest.o
-	$(LINKTEST)
-
-unwritten_sync: unwritten_sync.o
-	$(LINKTEST)
-
-ifeq ($(PKG_PLATFORM),irix)
-fill2: fill2.o
-	$(LINKTEST)  -lgen
-
-runas: runas.o
-	$(LINKTEST)  -lgen
-
-open_unlink: open_unlink.o $(LIBHANDLE)
-	$(LINKTEST) $(LIBHANDLE) $(LDLIBS)
-
-endif
+LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS)
 
-install: $(addsuffix -install,$(SUBDIRS))
+install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src
 	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
 	$(INSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh $(PKG_LIB_DIR)/src
diff --git a/src/aio-dio-regress/Makefile b/src/aio-dio-regress/Makefile
index 9968093..f0e4d15 100644
--- a/src/aio-dio-regress/Makefile
+++ b/src/aio-dio-regress/Makefile
@@ -6,14 +6,15 @@ TARGETS = $(basename $(wildcard *.c))
 CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS)
 
-LIBAIO = -laio -lpthread
+LLDLIBS = -laio -lpthread
 
 default: $(TARGETS)
 
 include $(BUILDRULES)
 
-$(TARGETS): %: %.c
-	$(CC) -g -Wall $(LIBAIO) -o $@ $*.c
+$(TARGETS):
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
 install:
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src/aio-dio-regress
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
