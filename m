Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SHSb4R126081 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 12:28:37 -0500
Received: from cxfsxe4.americas.sgi.com (cxfsxe4.americas.sgi.com
	[128.162.240.177])
	by estes.americas.sgi.com (Postfix) with ESMTP id 738037001D32;
	Tue, 28 Aug 2012 12:29:29 -0500 (CDT)
Received: by cxfsxe4.americas.sgi.com (Postfix, from userid 48222)
	id 62AE6CDA81; Tue, 28 Aug 2012 12:29:29 -0500 (CDT)
Message-Id: <20120828172929.203767140@sgi.com>
Date: Tue, 28 Aug 2012 12:26:08 -0500
From: Rich Johnston <rjohnston@sgi.com>
Subject: [PATCH 3/5] xftests: Use installed libraries only
References: <20120828172605.607853317@sgi.com>
Content-Disposition: inline;
	filename=3-5-xfstests-remove-relative-lib-paths.patch
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

The xfstests autotools currently searches locally in
   ../{acl,attr,dmapi,xfsprogs}
for libraries that xfstests depends upon, in addition to searching for them in
their regular installed locations on a system, e.g. /usr/lib.  It appears this
feature was added (but not documented) so that xfs developers can build and run
xfstests without having to install the libraries.  This can lead to touble if
you expect that xfstests is using the versions of the libraries installed on
the system.

If a local library was found and not installed, libtool will create a wrapper
script to call the binary from the .libs directory.  This patch will remove
searching for local libraies so that the installed libraries are always used.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 m4/package_acldev.m4   |    2 --
 m4/package_attrdev.m4  |    4 ----
 m4/package_dmapidev.m4 |    2 --
 m4/package_xfslibs.m4  |    6 ------
 4 files changed, 14 deletions(-)

Index: b/m4/package_acldev.m4
===================================================================
--- a/m4/package_acldev.m4
+++ b/m4/package_acldev.m4
@@ -30,8 +30,6 @@ AC_DEFUN([AC_PACKAGE_NEED_ACLINIT_LIBACL
         exit 1
     ])
     libacl="-lacl"
-    test -f `pwd`/../acl/libacl/libacl.la && \
-        libacl="`pwd`/../acl/libacl/libacl.la"
     test -f ${libexecdir}${libdirsuffix}/libacl.la && \
 	libacl="${libexecdir}${libdirsuffix}/libacl.la"
     AC_SUBST(libacl)
Index: b/m4/package_attrdev.m4
===================================================================
--- a/m4/package_attrdev.m4
+++ b/m4/package_attrdev.m4
@@ -46,8 +46,6 @@ AC_DEFUN([AC_PACKAGE_NEED_GETXATTR_LIBAT
         exit 1
     ])
     libattr="-lattr"
-    test -f `pwd`/../attr/libattr/libattr.la && \
-        libattr="`pwd`/../attr/libattr/libattr.la"
     test -f ${libexecdir}${libdirsuffix}/libattr.la && \
 	libattr="${libexecdir}${libdirsuffix}/libattr.la"
     AC_SUBST(libattr)
@@ -62,8 +60,6 @@ AC_DEFUN([AC_PACKAGE_NEED_ATTRGET_LIBATT
         exit 1
     ])
     libattr="-lattr"
-    test -f `pwd`/../attr/libattr/libattr.la && \
-        libattr="`pwd`/../attr/libattr/libattr.la"
     test -f ${libexecdir}${libdirsuffix}/libattr.la && \
 	libattr="${libexecdir}${libdirsuffix}/libattr.la"
     AC_SUBST(libattr)
Index: b/m4/package_dmapidev.m4
===================================================================
--- a/m4/package_dmapidev.m4
+++ b/m4/package_dmapidev.m4
@@ -20,8 +20,6 @@ AC_DEFUN([AC_PACKAGE_WANT_DMAPI],
 	echo
     ])
     libdm="-ldm"
-    test -f `pwd`/../dmapi/libdm/libdm.la && \
-        libdm="`pwd`/../dmapi/libdm/libdm.la"
     test -f ${libexecdir}${libdirsuffix}/libdm.la && \
 	libdm="${libexecdir}${libdirsuffix}/libdm.la"
     AC_SUBST(libdm)
Index: b/m4/package_xfslibs.m4
===================================================================
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -51,8 +51,6 @@ AC_DEFUN([AC_PACKAGE_NEED_LIBXFSINIT_LIB
         exit 1
     ])
     libxfs="-lxfs"
-    test -f `pwd`/../xfsprogs/libxfs/libxfs.la && \
-        libxfs="`pwd`/../xfsprogs/libxfs/libxfs.la"
     test -f ${libexecdir}${libdirsuffix}/libxfs.la && \
 	libxfs="${libexecdir}${libdirsuffix}/libxfs.la"
     AC_SUBST(libxfs)
@@ -67,8 +65,6 @@ AC_DEFUN([AC_PACKAGE_NEED_OPEN_BY_FSHAND
         exit 1
     ])
     libhdl="-lhandle"
-    test -f `pwd`/../xfsprogs/libhandle/libhandle.la && \
-        libhdl="`pwd`/../xfsprogs/libhandle/libhandle.la"
     test -f ${libexecdir}${libdirsuffix}/libhandle.la && \
 	libhdl="${libexecdir}${libdirsuffix}/libhandle.la"
     AC_SUBST(libhdl)
@@ -83,8 +79,6 @@ AC_DEFUN([AC_PACKAGE_NEED_ATTRLIST_LIBHA
         exit 1
     ])
     libhdl="-lhandle"
-    test -f `pwd`/../xfsprogs/libhandle/libhandle.la && \
-        libhdl="`pwd`/../xfsprogs/libhandle/libhandle.la"
     test -f ${libexecdir}${libdirsuffix}/libhandle.la && \
 	libhdl="${libexecdir}${libdirsuffix}/libhandle.la"
     AC_SUBST(libhdl)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
