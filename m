Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BF7D6i128048 for <xfs@oss.sgi.com>; Wed, 11 May 2011 10:07:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E02A714CA448
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2ThvtI3tQwTqOzj2 for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QKB0K-0005fT-8g
	for xfs@oss.sgi.com; Wed, 11 May 2011 15:07:12 +0000
Message-Id: <20110511150712.222802741@bombadil.infradead.org>
Date: Wed, 11 May 2011 11:04:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/9] xfs: do not use unchecked extent indices in xfs_bmapi
References: <20110511150402.258164661@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-ep-access-2
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

Make sure to only call xfs_iext_get_ext after we've validate the extent index
when moving on to the next index in xfs_bmapi.

Based on an earlier patch from Lachlan McIlroy.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-05-11 10:16:58.831733512 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-05-11 10:16:58.847733078 +0200
@@ -4827,12 +4827,13 @@ xfs_bmapi(
 		/*
 		 * Else go on to the next record.
 		 */
-		ep = xfs_iext_get_ext(ifp, ++lastx);
 		prev = got;
-		if (lastx >= nextents)
-			eof = 1;
-		else
+		if (++lastx < nextents) {
+			ep = xfs_iext_get_ext(ifp, lastx);
 			xfs_bmbt_get_all(ep, &got);
+		} else {
+			eof = 1;
+		}
 	}
 	*nmap = n;
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
