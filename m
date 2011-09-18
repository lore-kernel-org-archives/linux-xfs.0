Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfh8M200866 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57A4A17205B
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XYf7PRetx1h6X79Q for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OBK-0004e3-M7
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:41:42 +0000
Message-Id: <20110918204142.636946737@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/27] xfs: remove the first extent special case in
	xfs_bmap_add_extent
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmap_add_extent-remove-special-cases
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

Both xfs_bmap_add_extent_hole_delay and xfs_bmap_add_extent_hole_real
already contain code to handle the case where there is no extent to
merge with, which is effectively the same as the code duplicated here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-07-13 09:14:14.375340664 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-07-13 09:16:07.041396967 +0200
@@ -466,26 +466,9 @@ xfs_bmap_add_extent(
 	ASSERT(*idx <= nextents);
 
 	/*
-	 * This is the first extent added to a new/empty file.
-	 * Special case this one, so other routines get to assume there are
-	 * already extents in the list.
-	 */
-	if (nextents == 0) {
-		xfs_iext_insert(ip, *idx, 1, new,
-				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
-
-		ASSERT(cur == NULL);
-
-		if (!isnullstartblock(new->br_startblock)) {
-			XFS_IFORK_NEXT_SET(ip, whichfork, 1);
-			logflags = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
-		} else
-			logflags = 0;
-	}
-	/*
 	 * Any kind of new delayed allocation goes here.
 	 */
-	else if (isnullstartblock(new->br_startblock)) {
+	if (isnullstartblock(new->br_startblock)) {
 		if (cur)
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
