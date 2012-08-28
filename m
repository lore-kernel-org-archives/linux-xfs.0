Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SHSfuu126118 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 12:28:41 -0500
Received: from cxfsxe4.americas.sgi.com (cxfsxe4.americas.sgi.com
	[128.162.240.177])
	by estes.americas.sgi.com (Postfix) with ESMTP id EB3307001AB0;
	Tue, 28 Aug 2012 12:29:29 -0500 (CDT)
Received: by cxfsxe4.americas.sgi.com (Postfix, from userid 48222)
	id C32EFCDA81; Tue, 28 Aug 2012 12:29:29 -0500 (CDT)
Message-Id: <20120828172929.623554040@sgi.com>
Date: Tue, 28 Aug 2012 12:26:10 -0500
From: Rich Johnston <rjohnston@sgi.com>
Subject: [PATCH 5/5] xfsdump: Use installed libraries only
References: <20120828172605.607853317@sgi.com>
Content-Disposition: inline;
	filename=5-5-xfsdump-remove-relative-lib-paths.patch
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
 m4/package_attrdev.m4 |    4 ----
 1 file changed, 4 deletions(-)

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
