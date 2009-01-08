Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08IiV6C021253 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 12:44:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 253AF715A6
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 10:44:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1VVly5S3GsIYZWGD for
	<xfs@oss.sgi.com>; Thu, 08 Jan 2009 10:44:30 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LKzrp-00061c-TV
	for xfs@oss.sgi.com; Thu, 08 Jan 2009 18:44:30 +0000
Message-Id: <20090108184429.823470000@bombadil.infradead.org>
References: <20090108184222.244013000@bombadil.infradead.org>
Date: Thu, 08 Jan 2009 13:42:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: fix compile of xfs_btree_readahead_lblock on m68k
Content-Disposition: inline;
	filename=xfs-fix-xfs_btree_readahead_lblock-compile
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

Change the left/right variables to the proper always 64bit xfs_dfsbo_t
type because otherwise compilation fails for Geert on m68k without
CONFIG_LBD:

| fs/xfs/xfs_btree.c: In function 'xfs_btree_readahead_lblock':
| fs/xfs/xfs_btree.c:736: warning: comparison is always true due to limited range of data type
| fs/xfs/xfs_btree.c:741: warning: comparison is always true due to limited range of data type


Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_btree.c	2009-01-01 15:57:04.606547140 +0100
+++ linux-2.6/fs/xfs/xfs_btree.c	2009-01-01 15:57:24.780673454 +0100
@@ -730,8 +730,8 @@ xfs_btree_readahead_lblock(
 	struct xfs_btree_block	*block)
 {
 	int			rval = 0;
-	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
-	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+	xfs_dfsbno_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
+	xfs_dfsbno_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLDFSBNO) {
 		xfs_btree_reada_bufl(cur->bc_mp, left, 1);

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
