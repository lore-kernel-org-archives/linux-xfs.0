Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TE3ds9104731 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:03:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56A89E4B577
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 07:03:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DYGFMs3MMYVuN92v for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 07:03:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QbvMf-0008CU-Eo
	for xfs@oss.sgi.com; Wed, 29 Jun 2011 14:03:37 +0000
Message-Id: <20110629140337.417478423@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 10:01:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/27] xfs: work around bogus gcc warning in
	xfs_allocbt_init_cursor
References: <20110629140109.003209430@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-xfs_allocbt_init_cursor-warning
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

GCC 4.6 complains about an array subscript is above array bounds when
using the btree index to index into the agf_levels array.  The only
two indices passed in are 0 and 1, and we have an assert insuring that.

Replace the trick of using the array index directly with using constants
in the already existing branch for assigning the XFS_BTREE_LASTREC_UPDATE
flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2011-06-17 14:16:27.929065669 +0200
+++ xfs/fs/xfs/xfs_alloc_btree.c	2011-06-17 14:17:22.145729599 +0200
@@ -427,13 +427,16 @@ xfs_allocbt_init_cursor(
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
-	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[btnum]);
 	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-
 	cur->bc_ops = &xfs_allocbt_ops;
-	if (btnum == XFS_BTNUM_CNT)
+
+	if (btnum == XFS_BTNUM_CNT) {
+		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
 		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
+	} else {
+		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+	}
 
 	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
