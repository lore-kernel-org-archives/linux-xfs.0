Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMEx8Is028090 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:59:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AEAC1770339
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 06:59:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lOXn2AZvQZCCan8Q for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 06:59:06 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LEmFO-0004vQ-3V
	for xfs@oss.sgi.com; Mon, 22 Dec 2008 14:59:06 +0000
Date: Mon, 22 Dec 2008 09:59:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] handle unaligned data in xfs_bmbt_disk_get_all
Message-ID: <20081222145906.GA18859@infradead.org>
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

In libxfs xfs_bmbt_disk_get_all needs to handle unaligned data and thus
has been updated to use get_unaligned_be64.  In kernelspace we don't strictly
need it as the routine is only used for tracing and xfsidbg, but let's keep
the two implementations in sync.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap_btree.c
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-12-19 15:02:53.998907997 +0100
+++ xfs/fs/xfs/xfs_bmap_btree.c	2008-12-22 14:43:41.507247175 +0100
@@ -208,7 +208,8 @@ xfs_bmbt_disk_get_all(
 	xfs_bmbt_rec_t	*r,
 	xfs_bmbt_irec_t *s)
 {
-	__xfs_bmbt_get_all(be64_to_cpu(r->l0), be64_to_cpu(r->l1), s);
+	__xfs_bmbt_get_all(get_unaligned_be64(&r->l0),
+				get_unaligned_be64(&r->l1), s);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
