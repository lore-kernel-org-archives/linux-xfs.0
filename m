Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SHSeCE126105 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 12:28:40 -0500
Received: from cxfsxe4.americas.sgi.com (cxfsxe4.americas.sgi.com
	[128.162.240.177])
	by estes.americas.sgi.com (Postfix) with ESMTP id A096B7001D34;
	Tue, 28 Aug 2012 12:29:29 -0500 (CDT)
Received: by cxfsxe4.americas.sgi.com (Postfix, from userid 48222)
	id 91E46CDA81; Tue, 28 Aug 2012 12:29:29 -0500 (CDT)
Message-Id: <20120828172929.413312035@sgi.com>
Date: Tue, 28 Aug 2012 12:26:09 -0500
From: Rich Johnston <rjohnston@sgi.com>
Subject: [PATCH 4/5] dmapi: Use installed libraries only
References: <20120828172605.607853317@sgi.com>
Content-Disposition: inline; filename=4-5-dmapi-remove-relative-lib-paths.patch
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

If a local library was found and not installed, libtool will create a wrapper
script to call the binary from the .libs directory.  This patch will remove
searching for local libraies so that the installed libraries are always used.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 m4/package_xfslibs.m4 |    6 ------
 1 file changed, 6 deletions(-)

Index: b/m4/package_xfslibs.m4
===================================================================
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -40,8 +40,6 @@ AC_DEFUN([AC_PACKAGE_NEED_LIBXFSINIT_LIB
         exit 1
     ])
     libxfs="-lxfs"
-    test -f `pwd`/../xfsprogs/libxfs/libxfs.la && \
-        libxfs="`pwd`/../xfsprogs/libxfs/libxfs.la"
     test -f ${libexecdir}${libdirsuffix}/libxfs.la && \
 	libxfs="${libexecdir}${libdirsuffix}/libxfs.la"
     AC_SUBST(libxfs)
@@ -56,8 +54,6 @@ AC_DEFUN([AC_PACKAGE_NEED_OPEN_BY_FSHAND
         exit 1
     ])
     libhdl="-lhandle"
-    test -f `pwd`/../xfsprogs/libhandle/libhandle.la && \
-        libhdl="`pwd`/../xfsprogs/libhandle/libhandle.la"
     test -f ${libexecdir}${libdirsuffix}/libhandle.la && \
 	libhdl="${libexecdir}${libdirsuffix}/libhandle.la"
     AC_SUBST(libhdl)
@@ -72,8 +68,6 @@ AC_DEFUN([AC_PACKAGE_NEED_ATTRLIST_LIBHA
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
