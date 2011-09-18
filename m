Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfn6q201025 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37C811DA9C3D
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:48 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NYZnSInVOsCXuEfV for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OBP-0004rR-Of
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:41:47 +0000
Message-Id: <20110918204147.718308826@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:41:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 26/27] xfs: dont ignore error code from xfs_bmbt_update
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-xfs_bmap_add_extent_unwritten_real-fix-error-handling
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

Fix a case in xfs_bmap_add_extent_unwritten_real where we aren't passing
the returned error on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-10 14:51:08.181546087 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-10 14:51:21.154879343 -0400
@@ -1217,10 +1217,11 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			if (xfs_bmbt_update(cur, LEFT.br_startoff,
+			error = xfs_bmbt_update(cur, LEFT.br_startoff,
 				LEFT.br_startblock,
 				LEFT.br_blockcount + new->br_blockcount,
-				LEFT.br_state))
+				LEFT.br_state);
+			if (error)
 				goto done;
 		}
 		break;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
