Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EH4lrV248370 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 12:04:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9754953B649
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 10:04:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vzahdbSN28Wi4VF8 for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 10:04:46 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qse7B-00051S-Qs
	for xfs@oss.sgi.com; Sun, 14 Aug 2011 17:04:45 +0000
Date: Sun, 14 Aug 2011 13:04:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix loggen compile against recent xfsprogs headers
Message-ID: <20110814170445.GA19307@infradead.org>
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

The XFS_BLI_CANCEL flag got rename to XFS_BLF_CANCEL, allow loggen compile
with both versions.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfstests-dev/src/loggen.c
===================================================================
--- xfstests-dev.orig/src/loggen.c	2011-08-13 20:10:45.000000000 +0000
+++ xfstests-dev/src/loggen.c	2011-08-13 20:11:05.000000000 +0000
@@ -239,7 +239,11 @@ loggen_empty(int count)
     /* an empty buffer too */
     blfs.blf_type       = XFS_LI_BUF;
     blfs.blf_size       = 2;
+#ifdef XFS_BLF_CANCEL
+    blfs.blf_flags      = XFS_BLF_CANCEL;
+#else
     blfs.blf_flags      = XFS_BLI_CANCEL;
+#endif
     blfs.blf_len        = 0;
     blfs.blf_blkno      = 1;
     blfs.blf_map_size   = 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
