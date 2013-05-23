Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A27AD7F3F
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 10:37:59 -0500 (CDT)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CEA9AC004
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 08:37:59 -0700 (PDT)
Message-Id: <20130523143005.713972968@sgi.com>
From: rjohnston@sgi.com
Subject: [PATCH V3] xfsprogs: libhandle/Makefile - fix make install-dev
References: <20130522205819.586978467@gulag1.americas.sgi.com>
Date: Thu, 23 May 2013 10:37:59 -0500 (CDT)
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

Both make install and make install-dev are required to install all the
pieces of libhandle.

  # rm -f /lib64/libhandle* /usr/lib64/libhandle*
  # make install    
  # ls -l /lib64/libhandle* /usr/lib64/libhandle*
  ls: cannot access /usr/lib64/libhandle*: No such file or directory
  lrwxrwxrwx 1 root root /lib64/libhandle.so.1 -> libhandle.so.1.0.3
  -rwxr-xr-x 1 root root /lib64/libhandle.so.1.0.3

  # rm -f /lib64/libhandle* /usr/lib64/libhandle*
  # make install-dev    
  # ls -l /lib64/libhandle* /usr/lib64/libhandle*
  lrwxrwxrwx 1 root root /lib64/libhandle.a -> /usr/lib64/libhandle.a
  lrwxrwxrwx 1 root root /lib64/libhandle.la -> /usr/lib64/libhandle.la
  lrwxrwxrwx 1 root root /lib64/libhandle.so -> libhandle.so.1
  -rw-r--r-- 1 root root /usr/lib64/libhandle.a
  -rw-r--r-- 1 root root /usr/lib64/libhandle.la
  lrwxrwxrwx 1 root root /usr/lib64/libhandle.so -> /lib64/libhandle.so

Fix the libtool macros INSTALL_LTLIB and INSTALL_LTLIB_DEV.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
--
V1->V2
As Dave pointed out removing the ltdepend would prevent proper rebuilds.
Don't just make the install work ;) correct the dependancy for install-dev.

V2->V3
Not a libtool expert, make the change to the libtool macros instead of
cluttering up the Makefile.

diff --git a/include/buildmacros b/include/buildmacros
index 7a01880..98d25af 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -54,13 +54,7 @@ LTLDFLAGS += -rpath $(PKG_ROOT_LIB_DIR)
 LTLDFLAGS += -version-info $(LTVERSION)
 endif
 
-ifeq ($(ENABLE_SHARED),yes)
-INSTALL_LTLIB = \
-       cd $(TOPDIR)/$(LIBNAME)/.libs; \
-       ../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
-       ../$(INSTALL) -m 755 -T so_dot_version $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
-       ../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_ROOT_LIB_DIR)
-endif
+INSTALL_LTLIB = $(INSTALL_LTLIB_DEV)
 
 # Libtool thinks the static and shared libs should be in the same dir, so
 # make the static lib appear in the place we chose as rpath (using the two
@@ -75,6 +69,8 @@ INSTALL_LTLIB_DEV = \
        ../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_LIB_DIR); \
        ../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_LIB_DIR)/$(LIBNAME).la ; \
        ../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
+       ../$(INSTALL) -m 755 -T so_dot_version $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
+       ../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
        ../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
        if test "x$(PKG_LIB_DIR)" != "x$(PKG_ROOT_LIB_DIR)" ; then \
        ../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIBNAME).a; \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
