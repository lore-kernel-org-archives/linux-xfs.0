Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JvU4k185849 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:57:31 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103042000.p24K0MS1005563@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 14:00:22 -0600
Subject: [PATCH] xfstests: rework "dmapi" subtree build mechanism
MIME-Version: 1.0
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

Well that didn't work so well...  Turns out there was over a
megabyte of deleted stuff here, and that didn't fly on the mailing
list.

Here's a new version of the patch, where I've basically cut off the
majority of it, leaving only the "Index" lines for the files that
got deleted.  This ought to make it through the mailer just fine...

					-Alex

			---------------

The "dmapi" subtree was developed separate from and sort of wedged
into the rest of the "xfstests" code.  As a result, it has a lot of
build infrastructure that's just different from the unified way used
for everything else.

This patch changes all that, making the "dmapi" subtree be a more
normal component of "xfstests" with respect to its build process.

This involves removing all the cruft needed and used by the dmapi
"configure" script, and replacing each "Makefile.am" file with a
proper "Makefile" that includes a simple set of rules that are
compatible with the broader "xfstests" build.

The result is a much cleaner, consistent build.  It also deletes
a considerable amount of code.

Note:
    My patches normally keep files in sorted order, but in this case
    I have rearranged them so all the *new* and *changed* files are
    first, leaving deleted files at the end (starting with
    "dmapi/Makefile.am").

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 .gitignore                       |   21 
 Makefile                         |   19 
 dmapi/Makefile                   |   16 
 dmapi/Makefile.am                |    7 
 dmapi/Makefile.in                |  577 -
 dmapi/README.build               |   11 
 dmapi/aclocal.m4                 | 7227 -------------
 dmapi/config.guess               | 1460 --
 dmapi/config.sub                 | 1549 --
 dmapi/configure                  |20709 ---------------------------------------
 dmapi/configure.ac               |   42 
 dmapi/depcomp                    |  522 
 dmapi/install-sh                 |  322 
 dmapi/ltmain.sh                  | 6402 ------------
 dmapi/missing                    |  360 
 dmapi/src/Makefile               |   21 
 dmapi/src/Makefile.am            |    8 
 dmapi/src/Makefile.in            |  459 
 dmapi/src/common/Makefile        |   22 
 dmapi/src/common/Makefile.am     |    3 
 dmapi/src/common/Makefile.in     |  453 
 dmapi/src/common/cmd/Makefile    |   30 
 dmapi/src/common/cmd/Makefile.am |    9 
 dmapi/src/common/cmd/Makefile.in |  473 
 dmapi/src/common/lib/Makefile    |   30 
 dmapi/src/common/lib/Makefile.am |   10 
 dmapi/src/common/lib/Makefile.in |  453 
 dmapi/src/sample_hsm/Makefile    |   31 
 dmapi/src/sample_hsm/Makefile.am |   11 
 dmapi/src/sample_hsm/Makefile.in |  487 
 dmapi/src/simple/Makefile        |   32 
 dmapi/src/simple/Makefile.am     |    8 
 dmapi/src/simple/Makefile.in     |  482 
 dmapi/src/suite1/Makefile        |   18 
 dmapi/src/suite1/Makefile.am     |    3 
 dmapi/src/suite1/Makefile.in     |  453 
 dmapi/src/suite1/cmd/Makefile    |   55 
 dmapi/src/suite1/cmd/Makefile.am |   64 
 dmapi/src/suite1/cmd/Makefile.in |  940 -
 dmapi/src/suite2/Makefile        |   18 
 dmapi/src/suite2/Makefile.am     |    3 
 dmapi/src/suite2/Makefile.in     |  453 
 dmapi/src/suite2/src/Makefile    |   38 
 dmapi/src/suite2/src/Makefile.am |   26 
 dmapi/src/suite2/src/Makefile.in |  579 -
 include/builddefs.in             |    1 
 46 files changed, 316 insertions(+), 44601 deletions(-)

Index: b/.gitignore
===================================================================
--- a/.gitignore
+++ b/.gitignore
@@ -12,27 +12,6 @@ include/config.h
 include/config.h.in
 lib/.libs
 
-dmapi/Makefile
-dmapi/config.log
-dmapi/config.status
-dmapi/libtool
-dmapi/src/Makefile
-dmapi/src/common/Makefile
-dmapi/src/common/cmd/.deps
-dmapi/src/common/cmd/Makefile
-dmapi/src/common/lib/.deps
-dmapi/src/common/lib/Makefile
-dmapi/src/sample_hsm/.deps
-dmapi/src/sample_hsm/Makefile
-dmapi/src/simple/.deps
-dmapi/src/simple/Makefile
-dmapi/src/suite1/Makefile
-dmapi/src/suite1/cmd/.deps
-dmapi/src/suite1/cmd/Makefile
-dmapi/src/suite2/Makefile
-dmapi/src/suite2/src/.deps
-dmapi/src/suite2/src/Makefile
-
 ltp/aio-stress
 ltp/doio
 ltp/fsstress
Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -30,25 +30,19 @@ LSRCFILES = configure configure.in acloc
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* check.log check.time
 
-ifeq ($(HAVE_DMAPI), true)
-DMAPI_MAKEFILE = dmapi/Makefile
-endif
-
 LIB_SUBDIRS = include lib
 TOOL_SUBDIRS = ltp src m4
+ifeq ($(HAVE_DMAPI), true)
+TOOL_SUBDIRS += dmapi
+endif
 
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
-default: include/builddefs include/config.h $(DMAPI_MAKEFILE) new remake check $(TESTS)
+default: include/builddefs include/config.h new remake check $(TESTS)
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) $@
 else
 	$(Q)$(MAKE) $(MAKEOPTS) $(SUBDIRS)
-ifeq ($(HAVE_DMAPI), true)
-	# automake doesn't always support "default" target 
-	# so do dmapi make explicitly with "all"
-	$(Q)$(MAKE) $(MAKEOPTS) -C $(TOPDIR)/dmapi all
-endif
 endif
 
 # tool/lib dependencies
@@ -69,11 +63,6 @@ include/builddefs include/config.h: conf
                 --libexecdir=/usr/lib \
                 --enable-lib64=yes
 
-ifeq ($(HAVE_DMAPI), true)
-$(DMAPI_MAKEFILE):
-	$(Q)cd $(TOPDIR)/dmapi && ./configure
-endif
-
 aclocal.m4::
 	aclocal --acdir=`pwd`/m4 --output=$@
 
Index: b/dmapi/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/Makefile
@@ -0,0 +1,16 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ..
+
+include $(TOPDIR)/include/builddefs
+
+SUBDIRS = src
+
+default: $(SUBDIRS)
+
+include $(BUILDRULES)
+
+install: default
+
Index: b/dmapi/src/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/Makefile
@@ -0,0 +1,21 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../..
+
+include $(TOPDIR)/include/builddefs
+
+LIB_SUBDIRS = common
+TOOL_SUBDIRS = sample_hsm simple suite1 suite2
+
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+
+default: $(SUBDIRS)
+
+$(TOOL_SUBDIRS): $(LIB_SUBDIRS)
+
+include $(BUILDRULES)
+
+install: default
+
Index: b/dmapi/src/common/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/common/Makefile
@@ -0,0 +1,22 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../../..
+
+include $(TOPDIR)/include/builddefs
+
+LIB_SUBDIRS = lib
+TOOL_SUBDIRS = cmd
+
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+
+default: $(SUBDIRS)
+
+$(TOOL_SUBDIRS): $(LIB_SUBDIRS)
+
+include $(BUILDRULES)
+
+install: default
+
+install-dev:
Index: b/dmapi/src/common/cmd/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/common/cmd/Makefile
@@ -0,0 +1,30 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../../../..
+
+include $(TOPDIR)/include/builddefs
+
+TARGETS = read_invis set_region set_return_on_destroy write_invis
+
+CFILES = $(TARGETS:=.c)
+LDIRT = $(TARGETS)
+
+CFLAGS += -I.. -I/usr/include/xfs
+
+LLDLIBS = $(TOPDIR)/dmapi/src/common/lib/libdmtest.la $(LIBDM)
+
+default: depend $(TARGETS)
+
+depend: .dep
+
+include $(BUILDRULES)
+
+install install-dev: default
+
+$(TARGETS): $(LLDLIBS)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
+
+-include .dep
Index: b/dmapi/src/common/lib/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/common/lib/Makefile
@@ -0,0 +1,30 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../../../..
+
+include $(TOPDIR)/include/builddefs
+
+LTLIBRARY = libdmtest.la
+
+LTLDFLAGS = -static
+
+LT_CURRENT = 1
+LT_REVISION = 0
+LT_AGE = 0
+
+CFILES = find_session.c print.c stubs.c util.c
+HFILES = hsm.h dmport.h
+
+CFLAGS += -I$(TOPDIR)/dmapi/src/common -I/usr/include/xfs
+
+default: depend $(LTLIBRARY)
+
+depend: .ltdep
+
+include $(BUILDRULES)
+
+install install-dev: default
+
+-include .ltdep
Index: b/dmapi/src/sample_hsm/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/sample_hsm/Makefile
@@ -0,0 +1,31 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../../..
+
+include $(TOPDIR)/include/builddefs
+
+TARGETS = migfind migin migout mls mrmean wbee
+
+CFILES = $(TARGETS:=.c)
+LDIRT = $(TARGETS)
+
+CFLAGS += -I$(TOPDIR)/dmapi/src/common -I/usr/include/xfs
+
+LLDLIBS = $(TOPDIR)/dmapi/src/common/lib/libdmtest.la $(LIBDM)
+
+default: depend $(TARGETS)
+
+depend: .dep
+
+include $(BUILDRULES)
+
+install install-dev: default
+
+$(TARGETS): $(LLDLIBS)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
+
+-include .dep
+
Index: b/dmapi/src/simple/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/simple/Makefile
@@ -0,0 +1,32 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../../..
+
+include $(TOPDIR)/include/builddefs
+
+TARGETS = dm_create_session dm_destroy_session dm_find_eventmsg \
+		dm_getall_sessions dm_getall_tokens dm_query_session
+
+CFILES = $(TARGETS:=.c)
+LDIRT = $(TARGETS)
+
+CFLAGS += -I$(TOPDIR)/dmapi/src/common -I/usr/include/xfs
+
+LLDLIBS = $(LIBDM)
+
+default: depend $(TARGETS)
+
+depend: .dep
+
+include $(BUILDRULES)
+
+install install-dev: default
+
+$(TARGETS):
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
+
+-include .dep
+
Index: b/dmapi/src/suite1/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/suite1/Makefile
@@ -0,0 +1,18 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../../..
+
+include $(TOPDIR)/include/builddefs
+
+SUBDIRS = cmd
+
+default: $(SUBDIRS)
+
+include $(BUILDRULES)
+
+install: default
+
+install-dev:
+
Index: b/dmapi/src/suite1/cmd/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/suite1/cmd/Makefile
@@ -0,0 +1,55 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../../../..
+
+include $(TOPDIR)/include/builddefs
+
+# things needing -ldm -lhandle -ldmtest
+DM_TARGS = test_assumption get_eventlist set_eventlist set_disp \
+		get_region get_dmattr set_dmattr remove_dmattr \
+		probe_hole probe_punch_xfsctl_hole punch_hole \
+		get_fileattr sync_by_handle getall_dmattr \
+		set_fileattr path_to_handle path_to_fshandle \
+		get_mountinfo getall_disp get_events dm_handle \
+		handle_to_fshandle get_config_events get_allocinfo \
+		create_userevent request_right release_right \
+		upgrade_right query_right downgrade_right \
+		obj_ref_hold obj_ref_rele obj_ref_query print_event \
+		get_dirattrs
+
+# things needing -ldm -lhandle
+NT_TARGS = fd_to_handle handle_to_path init_service pending \
+		print_fshandle respond_event
+
+# things needing -ldm -ldmtest
+NTDM_TARGS = make_sparse randomize_file rwt struct_test
+
+# things left out for some reason...
+UNUSED_TARGS = make_rt_sparse security_hole2 security_hole
+
+TARGETS = $(DM_TARGS) $(NT_TARGS) $(NTDM_TARGS) link_test
+
+CFILES = $(TARGETS:=.c)
+LDIRT = $(TARGETS)
+
+CFLAGS += -I$(TOPDIR)/dmapi/src/common -I/usr/include/xfs
+
+LLDLIBS = $(TOPDIR)/dmapi/src/common/lib/libdmtest.la $(LIBDM)
+
+default: depend $(TARGETS)
+
+depend: .dep
+
+include $(BUILDRULES)
+
+install install-dev: default
+
+$(TARGETS): $(LLDLIBS)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
+
+-include .dep
+
+
Index: b/dmapi/src/suite2/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/suite2/Makefile
@@ -0,0 +1,18 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../../..
+
+include $(TOPDIR)/include/builddefs
+
+SUBDIRS = src
+
+default: $(SUBDIRS)
+
+include $(BUILDRULES)
+
+install: default
+
+install-dev:
+
Index: b/dmapi/src/suite2/src/Makefile
===================================================================
--- /dev/null
+++ b/dmapi/src/suite2/src/Makefile
@@ -0,0 +1,38 @@
+#
+# Copyright (c) 2011 SGI  All Rights Reserved.
+#
+
+TOPDIR = ../../../..
+
+include $(TOPDIR)/include/builddefs
+
+TARGETS = test_rights test_fileattr test_hole test_dmattr \
+		test_eventlist test_region test_bulkall \
+		test_bulkattr send_msg dm_test_daemon test_invis \
+		invis_test region_test test_efault mmap
+
+# things left out for some reason...
+UNUSED_TARGS = check_dmapi.c mmap_cp.c mm_fill.c
+
+CFILES = $(TARGETS:=.c)
+LDIRT = $(TARGETS)
+
+CFLAGS += -I.. -I$(TOPDIR)/dmapi/src/common -I/usr/include/xfs
+
+LLDLIBS = $(TOPDIR)/dmapi/src/common/lib/libdmtest.la $(LIBDM)
+
+default: depend $(TARGETS)
+
+depend: .dep
+
+include $(BUILDRULES)
+
+install install-dev: default
+
+$(TARGETS): $(LLDLIBS)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
+
+-include .dep
+
+
Index: b/include/builddefs.in
===================================================================
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -22,6 +22,7 @@ LIBATTR = @libattr@
 LIBGDBM = @libgdbm@
 LIBUUID = @libuuid@
 LIBHANDLE = @libhdl@
+LIBDM = @libdm@
 LIBTEST = $(TOPDIR)/lib/libtest.la
 
 PKG_NAME        = @pkg_name@
Index: b/dmapi/Makefile.am			(deleted)
Index: b/dmapi/Makefile.in			(deleted)
Index: b/dmapi/README.build			(deleted)
Index: b/dmapi/aclocal.m4			(deleted)
Index: b/dmapi/config.guess			(deleted)
Index: b/dmapi/config.sub			(deleted)
Index: b/dmapi/configure			(deleted)
Index: b/dmapi/configure.ac			(deleted)
Index: b/dmapi/depcomp				(deleted)
Index: b/dmapi/install-sh			(deleted)
Index: b/dmapi/ltmain.sh			(deleted)
Index: b/dmapi/missing				(deleted)
Index: b/dmapi/src/Makefile.am			(deleted)
Index: b/dmapi/src/Makefile.in			(deleted)
Index: b/dmapi/src/common/Makefile.am		(deleted)
Index: b/dmapi/src/common/Makefile.in		(deleted)
Index: b/dmapi/src/common/cmd/Makefile.am	(deleted)
Index: b/dmapi/src/common/cmd/Makefile.in	(deleted)
Index: b/dmapi/src/common/lib/Makefile.am	(deleted)
Index: b/dmapi/src/common/lib/Makefile.in	(deleted)
Index: b/dmapi/src/sample_hsm/Makefile.am	(deleted)
Index: b/dmapi/src/sample_hsm/Makefile.in	(deleted)
Index: b/dmapi/src/simple/Makefile.am		(deleted)
Index: b/dmapi/src/simple/Makefile.in		(deleted)
Index: b/dmapi/src/suite1/Makefile.am		(deleted)
Index: b/dmapi/src/suite1/Makefile.in		(deleted)
Index: b/dmapi/src/suite1/cmd/Makefile.am	(deleted)
Index: b/dmapi/src/suite1/cmd/Makefile.in	(deleted)
Index: b/dmapi/src/suite2/Makefile.am		(deleted)
Index: b/dmapi/src/suite2/Makefile.in		(deleted)
Index: b/dmapi/src/suite2/src/Makefile.am	(deleted)
Index: b/dmapi/src/suite2/src/Makefile.in	(deleted)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
