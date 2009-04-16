Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3GGTTGS079278 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 11:29:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F35B142875F
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 09:31:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OMG4CcIAt4DasWbR for
	<xfs@oss.sgi.com>; Thu, 16 Apr 2009 09:31:29 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LuUSf-0004tO-MK
	for xfs@oss.sgi.com; Thu, 16 Apr 2009 16:29:13 +0000
Date: Thu, 16 Apr 2009 12:29:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: set default prefix to /usr
Message-ID: <20090416162913.GA493@infradead.org>
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

Make sure the installation defaults to /usr like all the other xfs
tools.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/configure.in
===================================================================
--- xfsprogs-dev.orig/configure.in	2009-04-16 18:27:53.870074796 +0200
+++ xfsprogs-dev/configure.in	2009-04-16 18:27:57.850950773 +0200
@@ -2,6 +2,7 @@ AC_INIT(include/libxfs.h)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER(include/platform_defs.h)
+AC_PREFIX_DEFAULT(/usr)
 
 AC_PROG_LIBTOOL
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
