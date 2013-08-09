Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 740477FA8
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 10:58:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11BD3AC001
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 08:58:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DVkGdXKixgQ3UDjF for <xfs@oss.sgi.com>;
	Fri, 09 Aug 2013 08:58:30 -0700 (PDT)
Message-ID: <520511A4.1070302@sandeen.net>
Date: Fri, 09 Aug 2013 10:58:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/2] xfstest btrfs/316: test send / receive
References: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
In-Reply-To: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Schmidt <list.xfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, sbehrens@giantdisaster.de, xfs@oss.sgi.com

On 8/8/13 3:17 AM, Jan Schmidt wrote:
> These two patches add the announced tests for btrfs send / receive. As
> requested, the fssum tool is now included.
> 
> One drawback is that I'm unable to edit configure.ac or whatever needs
> to be modified in an autotools preferred way. Any hints appreciated,
> preferrably hints containing all the modifications required to introduce
> something like HAVE_SEEK_HOLE.

Here's how I'd fix all that up.

I guess the local defines are a little crummy but that's what's done
everywhere else.

After that, use the autoconf stuff to figure out if the ssl headers
are available, and built fssum conditionally on that; libcrypto doesn't
actually seem to be required?

-Eric


diff --git a/src/fssum.c b/src/fssum.c
index ecddb6a..5d4433a 100644
--- a/src/fssum.c
+++ b/src/fssum.c
@@ -37,6 +37,11 @@
 #include <inttypes.h>
 #include <assert.h>
 
+#ifndef SEEK_DATA
+#define SEEK_DATA      3
+#define SEEK_HOLE      4
+#endif
+
 #define CS_SIZE 16
 #define CHUNKS	128
 
diff --git a/aclocal.m4 b/aclocal.m4
index 5739004..f3412e1 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -44,6 +44,7 @@ m4_include([m4/package_attrdev.m4])
 m4_include([m4/package_dmapidev.m4])
 m4_include([m4/package_gdbmdev.m4])
 m4_include([m4/package_globals.m4])
+m4_include([m4/package_ssldev.m4])
 m4_include([m4/package_utilies.m4])
 m4_include([m4/package_uuiddev.m4])
 m4_include([m4/package_xfslibs.m4])
diff --git a/configure.ac b/configure.ac
index bfae106..bd48fd9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -70,6 +70,7 @@ in
 		AC_PACKAGE_WANT_FALLOCATE
 		AC_PACKAGE_WANT_LINUX_PRCTL_H
 		AC_PACKAGE_WANT_LINUX_FS_H
+		AC_PACKAGE_WANT_SSL
 		;;
 esac
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 6519c13..c899cfc 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -65,6 +65,7 @@ HAVE_DMAPI = @have_dmapi@
 HAVE_ATTR_LIST = @have_attr_list@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_FALLOCATE = @have_fallocate@
+HAVE_SSL = @have_ssl@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 
diff --git a/m4/Makefile b/m4/Makefile
index 6c1d0e4..7c2ecdd 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -16,6 +16,7 @@ LSRCFILES = \
 	package_libcdev.m4 \
 	package_ncurses.m4 \
 	package_pthread.m4 \
+	package_ssl.m4 \
 	package_types.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
diff --git a/src/Makefile b/src/Makefile
index 10a4d3c..228f5ff 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -20,14 +20,10 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester
 
-OPT_TARGETS = fssum
-
 SUBDIRS =
 
 LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
 
-OPT_LDLIBS = -lssl -lcrypto
-
 ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
 LINUX_TARGETS += loggen
 endif
@@ -40,6 +36,11 @@ ifeq ($(HAVE_FALLOCATE), true)
 LCFLAGS += -DHAVE_FALLOCATE
 endif
 
+ifeq ($(HAVE_SSL), true)
+LINUX_TARGETS += fssum
+LLDLIBS += -lssl
+endif
+
 IRIX_TARGETS = open_unlink
 
 ifeq ($(PKG_PLATFORM),linux)
@@ -64,7 +65,7 @@ CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS)
 
 
-default: depend $(TARGETS) $(OPT_TARGETS) $(SUBDIRS)
+default: depend $(TARGETS) $(SUBDIRS)
 
 depend: .dep
 
@@ -74,16 +75,11 @@ $(TARGETS): $(LIBTEST)
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
-$(OPT_TARGETS): $(LIBTEST)
-	@echo "    [CC]    $@"
-	-$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(OPT_LDLIBS) $(LIBTEST)
-
 LINKTEST = $(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS)
 
 install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src
 	$(LTINSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
-	-$(LTINSTALL) -m 755 $(OPT_TARGETS) $(PKG_LIB_DIR)/src
 	$(LTINSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh $(PKG_LIB_DIR)/src
 	$(LTINSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
