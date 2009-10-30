Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9UDFDkU206136 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 08:15:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 796B4C8F431
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 06:15:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id t7eLzhOb68jSB3In for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2009 06:15:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N3rK1-0005c5-9D
	for xfs@oss.sgi.com; Fri, 30 Oct 2009 13:15:17 +0000
Date: Fri, 30 Oct 2009 09:15:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] libdisk: do not install libdisk.a
Message-ID: <20091030131517.GB18462@infradead.org>
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

Since xfsprogs 3.0 libdisk is intended to be private to xfsprogs and we do
not install the headers anymore.  But we kept installing the static library,
which doesn't make sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/libdisk/Makefile
===================================================================
--- xfsprogs-dev.orig/libdisk/Makefile	2009-10-30 13:12:03.000000000 +0000
+++ xfsprogs-dev/libdisk/Makefile	2009-10-30 13:12:08.000000000 +0000
@@ -27,6 +27,5 @@ include $(BUILDRULES)
 install: default
 
 install-dev: default
-	$(INSTALL_LTLIB_STATIC)
 
 install-qa: install-dev

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
