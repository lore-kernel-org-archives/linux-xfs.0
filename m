Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGiDu7006572 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 748063F8E3
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IPeHxn0lNVfpJXGh for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:12 -0800 (PST)
Message-Id: <20081222164411.347208000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 19/20] xfsdump: add support for building with sparse
Content-Disposition: inline; filename=xfsdump-sparse
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


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfsdump/include/buildmacros
===================================================================
--- xfs-cmds.orig/xfsdump/include/buildmacros	2008-11-13 18:31:57.000000000 +0100
+++ xfs-cmds/xfsdump/include/buildmacros	2008-11-13 18:58:13.000000000 +0100
@@ -42,10 +42,10 @@ LIBNAME = $(basename $(LTLIBRARY))
 LTOBJECTS = $(OBJECTS:.o=.lo)
 LTVERSION = $(LT_CURRENT):$(LT_REVISION):$(LT_AGE)
 
-LTLINK = $(LIBTOOL) --mode=link $(CC)
+LTLINK = $(LIBTOOL) --tag=CC --mode=link $(CC)
 LTEXEC = $(LIBTOOL) --mode=execute
 LTINSTALL = $(LIBTOOL) --mode=install $(INSTALL)
-LTCOMPILE = $(LIBTOOL) --mode=compile $(CCF)
+LTCOMPILE = $(LIBTOOL) --tag=CC --mode=compile $(CCF)
 
 ifeq ($(ENABLE_SHARED),yes)
 LTLDFLAGS += -rpath $(PKG_LIB_DIR)

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
