Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HDCHb4119928 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 08:12:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 537CE51E04B
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 06:12:14 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	oYH7PBWyycuC7JH3 for <xfs@oss.sgi.com>;
	Fri, 17 Jun 2011 06:12:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QXYqM-0000f7-H5
	for xfs@oss.sgi.com; Fri, 17 Jun 2011 13:12:14 +0000
Date: Fri, 17 Jun 2011 09:12:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: work around bogus gcc warning in xfs_allocbt_init_cursor
Message-ID: <20110617131214.GA2141@infradead.org>
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

GCC 4.6 complains about an array subscript is above array bounds when
using the btree index to index into the agf_levels array.  The only
two indices passed in are 0 and 1, and we have an assert insuring that.

Replace the trick of using the array index directly with using constants
in the already existing branch for assigning the XFS_BTREE_LASTREC_UPDATE
flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>

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
