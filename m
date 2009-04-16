Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3GJrSJU088203 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 14:53:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB7EB1CC83D7
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 12:53:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iA5ejtbewvU6WH9o for
	<xfs@oss.sgi.com>; Thu, 16 Apr 2009 12:53:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LuXe3-0008Tq-Hf
	for xfs@oss.sgi.com; Thu, 16 Apr 2009 19:53:11 +0000
Date: Thu, 16 Apr 2009 15:53:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: add .gitignore file
Message-ID: <20090416195311.GA22431@infradead.org>
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

Index: xfsprogs-dev/.gitignore
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/.gitignore	2009-04-16 21:50:04.101077123 +0200
@@ -0,0 +1,58 @@
+# object files
+*.o
+
+# build system
+.census
+Logs/
+include/platform_defs.h
+include/builddefs
+install-sh
+
+# magic diretory symlinks
+include/disk
+include/xfs
+
+# Makepgs
+build/src-manifest
+build/xfsprogs-*.tar.gz
+doc/CHANGES.gz
+xfsprogs-*
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
+# gettext
+po/pl.mo
+po/xfsprogs.pot
+
+# quilt stuff
+.pc/
+patches/
+
+# binaries
+copy/xfs_copy
+db/xfs_db
+estimate/xfs_estimate
+fsr/xfs_fsr
+growfs/xfs_growfs
+io/xfs_io
+logprint/xfs_logprint
+mdrestore/xfs_mdrestore
+mkfs/fstyp
+mkfs/mkfs.xfs
+quota/xfs_quota
+repair/xfs_repair
+rtcp/xfs_rtcp

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
