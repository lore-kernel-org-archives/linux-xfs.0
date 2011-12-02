Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2HlhNg092670 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 11:47:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3EB74D4EE5
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 09:47:42 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	298yrxIxJE0IcmcK for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 09:47:42 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RWXD3-0000jg-OF
	for xfs@oss.sgi.com; Fri, 02 Dec 2011 17:47:41 +0000
Message-Id: <20111202174741.685796560@bombadil.infradead.org>
Date: Fri, 02 Dec 2011 12:46:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/12] xfsprogs: allow linking against libtcmalloc
References: <20111202174619.179530033@bombadil.infradead.org>
Content-Disposition: inline; filename=xfsprogs-use-tcmalloc
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

Allow linking against the libtcmalloc library from Google's performance
tools, which at least for repair reduces the memory usage dramatically.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/configure.in
===================================================================
--- xfsprogs-dev.orig/configure.in	2011-11-14 13:54:28.000000000 +0000
+++ xfsprogs-dev/configure.in	2011-11-20 19:21:26.000000000 +0000
@@ -31,6 +31,26 @@ AC_ARG_ENABLE(editline,
 AC_SUBST(libeditline)
 AC_SUBST(enable_editline)
 
+AC_ARG_ENABLE(tcmalloc,
+[ --enable-tcmalloc=[yes/no] Enable tcmalloc [default=no]],,
+	enable_tcmalloc=check)
+
+if test x$enable_tcmalloc != xno; then
+    saved_CPPFLAGS="$CPPFLAGS"
+    CPPFLAGS="$CPPFLAGS -fno-builtin-malloc"
+    AC_CHECK_LIB([tcmalloc_minimal], [malloc], [libtcmalloc="-ltcmalloc_minimal"],
+        [AC_CHECK_LIB([tcmalloc], [malloc], [libtcmalloc="-ltcmalloc"], [
+         if test x$enable_tcmalloc = xyes; then
+            AC_MSG_ERROR([libtcmalloc_minimal or libtcmalloc library not found], 1)
+         fi]
+        )]
+    )
+    if test x$libtcmalloc = x; then
+        CPPFLAGS="$saved_CPPFLAGS"
+    fi
+fi
+AC_SUBST(libtcmalloc)
+
 AC_ARG_ENABLE(termcap,
 [ --enable-termcap=[yes/no] Enable terminal capabilities library [default=no]],
 	test $enable_termcap = yes && libtermcap="-ltermcap",)
Index: xfsprogs-dev/include/builddefs.in
===================================================================
--- xfsprogs-dev.orig/include/builddefs.in	2011-11-14 13:54:28.000000000 +0000
+++ xfsprogs-dev/include/builddefs.in	2011-11-14 13:57:55.000000000 +0000
@@ -22,7 +22,7 @@ _BUILDDEFS_INCLUDED_ = 1
 
 DEBUG = @debug_build@
 OPTIMIZER = @opt_build@
-MALLOCLIB = @malloc_lib@
+MALLOCLIB = @malloc_lib@ @libtcmalloc@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
 CFLAGS = @CFLAGS@

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
