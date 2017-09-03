Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdICHaS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:30:18 -0400
Received: from [91.114.64.3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1doPMI-0006w2-1Y
        for linux-xfs@vger.kernel.org; Sun, 03 Sep 2017 07:30:18 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/17] xfs: move some more code into xfs_bmap_del_extent_real
Date: Sun,  3 Sep 2017 09:29:45 +0200
Message-Id: <20170903072956.3175-7-hch@lst.de>
In-Reply-To: <20170903072956.3175-1-hch@lst.de>
References: <20170903072956.3175-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e6feb71298ba..add690cb19a3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5080,7 +5080,7 @@ xfs_bmap_del_extent_real(
 	int			do_fx;	/* free extent at end of routine */
 	xfs_bmbt_rec_host_t	*ep;	/* current extent entry pointer */
 	int			error;	/* error return value */
-	int			flags;	/* inode logging flags */
+	int			flags = 0;/* inode logging flags */
 	xfs_bmbt_irec_t		got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -5112,10 +5112,25 @@ xfs_bmap_del_extent_real(
 	got_endoff = got.br_startoff + got.br_blockcount;
 	ASSERT(got_endoff >= del_endoff);
 	ASSERT(!isnullstartblock(got.br_startblock));
-	flags = XFS_ILOG_CORE;
 	qfield = 0;
 	error = 0;
 
+	/*
+	 * If it's the case where the directory code is running with no block
+	 * reservation, and the deleted block is in the middle of its extent,
+	 * and the resulting insert of an extent would cause transformation to
+	 * btree format, then reject it.  The calling code will then swap blocks
+	 * around instead.  We have to do this now, rather than waiting for the
+	 * conversion to btree format, since the transaction will be dirty then.
+	 */
+	if (tp->t_blk_res == 0 &&
+	    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_NEXTENTS(ip, whichfork) >=
+			XFS_IFORK_MAXEXT(ip, whichfork) &&
+	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
+		return -ENOSPC;
+
+	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
 		xfs_fsblock_t	bno;
 		xfs_filblks_t	len;
@@ -5601,28 +5616,6 @@ __xfs_bunmapi(
 			error = xfs_bmap_del_extent_delay(ip, whichfork, &lastx,
 					&got, &del);
 		} else {
-			/*
-			 * If it's the case where the directory code is running
-			 * with no block reservation, and the deleted block is
-			 * in the middle of its extent, and the resulting insert
-			 * of an extent would cause transformation to btree
-			 * format, then reject it.  The calling code will then
-			 * swap blocks around instead.  We have to do this now,
-			 * rather than waiting for the conversion to btree
-			 * format, since the transaction will be dirty.
-			 */
-			if (tp->t_blk_res == 0 &&
-			    XFS_IFORK_FORMAT(ip, whichfork) ==
-					XFS_DINODE_FMT_EXTENTS &&
-			    XFS_IFORK_NEXTENTS(ip, whichfork) >=
-					XFS_IFORK_MAXEXT(ip, whichfork) &&
-			    del.br_startoff > got.br_startoff &&
-			    del.br_startoff + del.br_blockcount <
-			    got.br_startoff + got.br_blockcount) {
-				error = -ENOSPC;
-				goto error0;
-			}
-
 			error = xfs_bmap_del_extent_real(ip, tp, &lastx, dfops,
 					cur, &del, &tmp_logflags, whichfork,
 					flags);
-- 
2.11.0

