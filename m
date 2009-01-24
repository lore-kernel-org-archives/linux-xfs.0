Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0OEJk2m015898 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 08:19:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22E60B46B2
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 06:19:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EXlpQUXSjvajCJQ5 for
	<xfs@oss.sgi.com>; Sat, 24 Jan 2009 06:19:03 -0800 (PST)
Date: Sat, 24 Jan 2009 09:19:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: add xfs_fsr to the gettext machinery
Message-ID: <20090124141902.GA32331@infradead.org>
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
Cc: Jakub Bogusz <qboosh@pld-linux.org>

When removing fsr from xfsdump I noticed it was tied up to gettext,
so we should make sure it still is in xfsprogs.

Jakub, any chance you could submit an update of the Polish translations
that takes the move into account?


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/po/Makefile
===================================================================
--- xfsprogs-dev.orig/po/Makefile	2009-01-24 15:17:00.847134077 +0100
+++ xfsprogs-dev/po/Makefile	2009-01-24 15:17:14.246285604 +0100
@@ -14,6 +14,7 @@ LDIRT = $(POTHEAD)
 XGETTEXTFILES =	\
 		$(TOPDIR)/copy/xfs_copy.c \
 		$(TOPDIR)/estimate/xfs_estimate.c \
+		$(TOPDIR)/fsr/xfs_fsr.c \
 		$(TOPDIR)/growfs/xfs_growfs.c \
 		$(TOPDIR)/io/attr.c \
 		$(TOPDIR)/io/bmap.c \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
