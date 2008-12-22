Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGiQtj006624 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:28 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2AF8177579D
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FvXIkHLxtKSvurm9 for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:24 -0800 (PST)
Message-Id: <20081222164353.220867000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/20] fix up xfs-cmds build after the parallel-fest
Content-Disposition: inline; filename=xfs-cmds-fix-configure
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: Eric Sandeen <sandeen@sandeen.net>

From: Eric Sandeen <sandeen@sandeen.net>

My big parallel build patch lost the "make configure" target.
This broke Makepkgs...

Now, IMHO, running configure from make is a little bass-ackwards;
I'd probably prefer to have Makepkgs explicitly run:

 autoconf; configure --myoptions; make

but for now, this adds back in a workable "make configure" target.

Also fixed "make install-lib" for acl, which was failing
in the man subdir.


Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/acl/Makefile
===================================================================
--- xfs-cmds.orig/acl/Makefile	2008-12-22 09:54:24.347372730 +0100
+++ xfs-cmds/acl/Makefile	2008-12-22 10:06:10.819372446 +0100
@@ -38,7 +38,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/acl/man/Makefile
===================================================================
--- xfs-cmds.orig/acl/man/Makefile	2008-12-22 09:54:24.352372110 +0100
+++ xfs-cmds/acl/man/Makefile	2008-12-22 10:06:10.819372446 +0100
@@ -13,10 +13,15 @@ install : $(addsuffix -install,$(SUBDIRS
 
 install-dev : $(addsuffix -install-dev,$(SUBDIRS))
 
+install-lib: $(addsuffix -install-lib,$(SUBDIRS))
+
 %-install:
 	$(MAKE) -C $* install
 
 %-install-dev:
 	$(MAKE) -C $* install-dev
 
+%-install-lib:
+	$(MAKE) -C $* install-lib
+
 include $(BUILDRULES)
Index: xfs-cmds/dmapi/Makefile
===================================================================
--- xfs-cmds.orig/dmapi/Makefile	2008-12-22 09:54:24.362371988 +0100
+++ xfs-cmds/dmapi/Makefile	2008-12-22 10:06:10.823372607 +0100
@@ -36,7 +36,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/xfsprogs/Makefile
===================================================================
--- xfs-cmds.orig/xfsprogs/Makefile	2008-12-22 09:54:24.367371856 +0100
+++ xfs-cmds/xfsprogs/Makefile	2008-12-22 10:06:10.827371929 +0100
@@ -44,7 +44,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/xfsdump/Makefile
===================================================================
--- xfs-cmds.orig/xfsdump/Makefile	2008-12-22 09:54:24.372372074 +0100
+++ xfs-cmds/xfsdump/Makefile	2008-12-22 10:33:52.896372798 +0100
@@ -37,7 +37,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/nfs4acl/Makefile
===================================================================
--- xfs-cmds.orig/nfs4acl/Makefile	2008-12-22 09:54:24.377371943 +0100
+++ xfs-cmds/nfs4acl/Makefile	2008-12-22 10:06:10.835372599 +0100
@@ -39,7 +39,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/xfstests/Makefile
===================================================================
--- xfs-cmds.orig/xfstests/Makefile	2008-12-22 09:54:24.382372022 +0100
+++ xfs-cmds/xfstests/Makefile	2008-12-22 10:06:10.844247263 +0100
@@ -42,7 +42,7 @@ else
 clean:  # if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoheader
 	autoconf
 	./configure \
Index: xfs-cmds/attr/Makefile
===================================================================
--- xfs-cmds.orig/attr/Makefile	2008-12-22 09:54:24.289373093 +0100
+++ xfs-cmds/attr/Makefile	2008-12-22 10:06:16.433373009 +0100
@@ -39,7 +39,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
