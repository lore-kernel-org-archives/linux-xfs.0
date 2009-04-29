Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TDo2qq163963 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 08:50:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24C83145B8C6
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 06:53:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Dr94Hne1638zZDVA for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 06:53:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LzAAi-0004sF-QW
	for xfs@oss.sgi.com; Wed, 29 Apr 2009 13:50:00 +0000
Date: Wed, 29 Apr 2009 09:50:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] dmapi: add .gitignore
Message-ID: <20090429135000.GB30808@infradead.org>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: dmapi-dev/.gitignore
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ dmapi-dev/.gitignore	2009-04-29 15:37:28.128650851 +0200
@@ -0,0 +1,39 @@
+# object files
+*.o
+
+# build system
+.census
+Logs/
+include/builddefs
+install-sh
+
+# magic diretory symlinks
+include/xfs
+
+# Makepgs
+build/src-manifest
+build/dmapi-*.tar.gz
+doc/CHANGES.gz
+dmapi-*
+
+# autoconf generated files
+aclocal.m4
+autom4te.cache/
+config.guess
+config.log
+config.status
+config.sub
+configure
+
+# libtool
+libtool
+ltmain.sh
+*.lo
+*.la
+.libs
+
+# quilt stuff
+.pc/
+patches/
+
+# binaries

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
