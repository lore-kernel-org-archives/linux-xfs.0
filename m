Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MM5Ufu115253 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 16:05:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04275185007F
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 14:04:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rykDBsEC7GB8CMLc for
	<xfs@oss.sgi.com>; Thu, 22 Jan 2009 14:04:46 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LQ7fK-0003Xj-KE
	for xfs@oss.sgi.com; Thu, 22 Jan 2009 22:04:46 +0000
Date: Thu, 22 Jan 2009 17:04:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: fix 122 for removed btree types
Message-ID: <20090122220446.GA8723@infradead.org>
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

With the the btree refactoring various btree trypes have been removed,
so remove them from the golden output for 122.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/122.out
===================================================================
--- xfstests-dev.orig/122.out	2009-01-04 19:22:15.000000000 +0000
+++ xfstests-dev/122.out	2009-01-04 19:22:31.000000000 +0000
@@ -65,10 +65,6 @@
 sizeof( xfs_bmbt_rec_64_t ) = 16
 sizeof( xfs_bmdr_block_t ) = 4
 sizeof( xfs_btnum_t ) = 4
-sizeof( xfs_btree_block_t ) = 24
-sizeof( xfs_btree_hdr_t ) = 8
-sizeof( xfs_btree_lblock_t ) = 24
-sizeof( xfs_btree_sblock_t ) = 16
 sizeof( xfs_buf_log_format_t ) = 24
 sizeof( xfs_da_blkinfo_t ) = 12
 sizeof( xfs_da_intnode_t ) = 24

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
