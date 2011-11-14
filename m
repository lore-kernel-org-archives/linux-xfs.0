Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEG2J1N217516 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 10:02:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A88D1D082A2
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 08:02:17 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1FFHAeASN8nIF8VZ for <xfs@oss.sgi.com>;
	Mon, 14 Nov 2011 08:02:17 -0800 (PST)
Message-Id: <20111114160217.591812422@bombadil.infradead.org>
Date: Mon, 14 Nov 2011 10:57:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfsprogs: allow linking against libtcmalloc
References: <20111114155742.285135418@bombadil.infradead.org>
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
--- xfsprogs-dev.orig/configure.in	2011-08-14 17:00:02.000000000 +0000
+++ xfsprogs-dev/configure.in	2011-11-14 12:47:05.000000000 +0000
@@ -31,6 +31,21 @@ AC_ARG_ENABLE(editline,
 AC_SUBST(libeditline)
 AC_SUBST(enable_editline)
 
+AC_ARG_ENABLE(tcmalloc,
+[ --enable-tcmalloc=[yes/no] Enable tcmalloc [default=no]],,
+	enable_tcmalloc=no)
+AC_SUBST(enable_tcmalloc)
+
+if test "$enable_tcmalloc" = "yes"; then
+    AC_CHECK_LIB(tcmalloc, malloc,, [
+	echo 'FATAL ERROR: could not find a valid tcmalloc library.'
+	echo 'Install libtcmalloc or configure with --enable-tcmalloc=no.'
+	exit 1])
+
+    libtcmalloc="-ltcmalloc"
+    AC_SUBST(libtcmalloc)
+fi
+
 AC_ARG_ENABLE(termcap,
 [ --enable-termcap=[yes/no] Enable terminal capabilities library [default=no]],
 	test $enable_termcap = yes && libtermcap="-ltermcap",)
Index: xfsprogs-dev/include/builddefs.in
===================================================================
--- xfsprogs-dev.orig/include/builddefs.in	2011-08-14 17:00:02.000000000 +0000
+++ xfsprogs-dev/include/builddefs.in	2011-11-14 12:09:52.000000000 +0000
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
