Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUHfqVq030152 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 11:41:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72B6852F89
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 09:41:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mQtUVp26RayDhUHN for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 09:41:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LHibI-00067I-70
	for xfs@oss.sgi.com; Tue, 30 Dec 2008 17:41:52 +0000
Date: Tue, 30 Dec 2008 12:41:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: make install-qa should only install additional
	headers
Message-ID: <20081230174152.GA18469@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

make install-qa should only install the headers a normal install-dev
doesn't install instead of repeating the whole game.

That way the additional headers for xfsqa can be installed manually
while using dpkg / rpm for the normal package. 


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs/Makefile
===================================================================
--- xfsprogs/Makefile	2008-12-30 13:03:06.000000000 +0000
+++ xfsprogs/Makefile	2008-12-30 13:03:15.000000000 +0000
@@ -76,7 +76,7 @@
 
 install-dev: default $(addsuffix -install-dev,$(SUBDIRS))
 
-install-qa: install $(addsuffix -install-qa,$(SUBDIRS))
+install-qa: default $(addsuffix -install-qa,$(SUBDIRS))
 
 %-install:
 	$(MAKE) -C $* install
Index: xfsprogs/include/Makefile
===================================================================
--- xfsprogs/include/Makefile	2008-12-30 13:02:05.000000000 +0000
+++ xfsprogs/include/Makefile	2008-12-30 13:02:31.000000000 +0000
@@ -54,5 +54,5 @@
 	$(INSTALL) -m 755 -d $(DK_INC_DIR)
 	$(INSTALL) -m 644 $(DKHFILES) $(DK_INC_DIR)
 
-install-qa: install-dev
+install-qa: default
 	$(INSTALL) -m 644 $(QAHFILES) $(PKG_INC_DIR)
Index: xfsprogs/libdisk/Makefile
===================================================================
--- xfsprogs/libdisk/Makefile	2008-12-30 13:00:53.000000000 +0000
+++ xfsprogs/libdisk/Makefile	2008-12-30 13:01:39.000000000 +0000
@@ -29,4 +29,4 @@
 install-dev: default
 	$(INSTALL_LTLIB_STATIC)
 
-install-qa: install-dev
+install-qa: default
Index: xfsprogs/libhandle/Makefile
===================================================================
--- xfsprogs/libhandle/Makefile	2008-12-30 13:01:09.000000000 +0000
+++ xfsprogs/libhandle/Makefile	2008-12-30 13:01:34.000000000 +0000
@@ -22,4 +22,4 @@
 install-dev: default
 	$(INSTALL_LTLIB_DEV)
 
-install-qa: install-dev
+install-qa: default

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
