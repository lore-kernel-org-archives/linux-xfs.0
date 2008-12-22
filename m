Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGhxhJ006446 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:43:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9D901775787
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lc8d4wmVgYD6CGt0 for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:57 -0800 (PST)
Message-Id: <20081222164356.118030000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/20] build system: Make --enable-gettext actually enable
	gettext
Content-Disposition: inline; filename=xfsprogs-gettext-fix--enable-gettext
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

From: Arkadiusz Miskiewicz <arekm@maven.pl>                                        


ENABLE_GETTEXT wasn't defined when --enable-gettext was
passed as configure option. Now this is fixed.


Reviewed-by: Christoph Hellwig <hch@lst.de>

---
 xfsprogs/include/builddefs.in |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/xfsprogs/include/builddefs.in b/xfsprogs/include/builddefs.in
index f1b4340..f07d8d6 100644
--- a/xfsprogs/include/builddefs.in
+++ b/xfsprogs/include/builddefs.in
@@ -118,6 +118,10 @@ GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include
 
+ifeq ($(ENABLE_GETTEXT),yes)
+GCFLAGS += -DENABLE_GETTEXT
+endif
+
 # First, Global, Platform, Local CFLAGS
 CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
 
-- 
1.6.0.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
