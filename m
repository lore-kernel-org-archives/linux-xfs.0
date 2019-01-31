Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56660 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfAaHzp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 02:55:45 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/11] xfs: factor out two helpers from xfs_bmapi_write
Date: Thu, 31 Jan 2019 08:55:19 +0100
Message-Id: <20190131075524.4769-7-hch@lst.de>
In-Reply-To: <20190131075524.4769-1-hch@lst.de>
References: <20190131075524.4769-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

We want to be able to reuse them for the upcoming dedidcated delalloc
convert routine.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 78 ++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a0443158a40e..d75f45d9b7d1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4194,6 +4194,44 @@ xfs_bmapi_convert_unwritten(
 	return 0;
 }
 
+static inline xfs_extlen_t
+xfs_bmapi_minleft(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			fork)
+{
+	if (tp && tp->t_firstblock != NULLFSBLOCK)
+		return 0;
+	if (XFS_IFORK_FORMAT(ip, fork) != XFS_DINODE_FMT_BTREE)
+		return 1;
+	return be16_to_cpu(XFS_IFORK_PTR(ip, fork)->if_broot->bb_level) + 1;
+}
+
+/*
+ * Log whatever the flags say, even if error.  Otherwise we might miss detecting
+ * a case where the data is changed, there's an error, and it's not logged so we
+ * don't shutdown when we should.  Don't bother logging extents/btree changes if
+ * we converted to the other format.
+ */
+static void
+xfs_bmapi_finish(
+	struct xfs_bmalloca	*bma,
+	int			whichfork,
+	int			error)
+{
+	if ((bma->logflags & xfs_ilog_fext(whichfork)) &&
+	    XFS_IFORK_FORMAT(bma->ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
+		bma->logflags &= ~xfs_ilog_fext(whichfork);
+	else if ((bma->logflags & xfs_ilog_fbroot(whichfork)) &&
+		 XFS_IFORK_FORMAT(bma->ip, whichfork) != XFS_DINODE_FMT_BTREE)
+		bma->logflags &= ~xfs_ilog_fbroot(whichfork);
+
+	if (bma->logflags)
+		xfs_trans_log_inode(bma->tp, bma->ip, bma->logflags);
+	if (bma->cur)
+		xfs_btree_del_cursor(bma->cur, error);
+}
+
 /*
  * Map file blocks to filesystem blocks, and allocate blocks or convert the
  * extent state if necessary.  Details behaviour is controlled by the flags
@@ -4273,15 +4311,6 @@ xfs_bmapi_write(
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
 
-	if (!tp || tp->t_firstblock == NULLFSBLOCK) {
-		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
-			bma.minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
-		else
-			bma.minleft = 1;
-	} else {
-		bma.minleft = 0;
-	}
-
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
 		if (error)
@@ -4296,6 +4325,7 @@ xfs_bmapi_write(
 	bma.ip = ip;
 	bma.total = total;
 	bma.datatype = 0;
+	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	/*
 	 * The delalloc flag means the caller wants to allocate the entire
@@ -4434,32 +4464,12 @@ xfs_bmapi_write(
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE ||
 	       XFS_IFORK_NEXTENTS(ip, whichfork) >
 		XFS_IFORK_MAXEXT(ip, whichfork));
-	error = 0;
+	xfs_bmapi_finish(&bma, whichfork, 0);
+	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
+		orig_nmap, *nmap);
+	return 0;
 error0:
-	/*
-	 * Log everything.  Do this after conversion, there's no point in
-	 * logging the extent records if we've converted to btree format.
-	 */
-	if ((bma.logflags & xfs_ilog_fext(whichfork)) &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-		bma.logflags &= ~xfs_ilog_fext(whichfork);
-	else if ((bma.logflags & xfs_ilog_fbroot(whichfork)) &&
-		 XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
-		bma.logflags &= ~xfs_ilog_fbroot(whichfork);
-	/*
-	 * Log whatever the flags say, even if error.  Otherwise we might miss
-	 * detecting a case where the data is changed, there's an error,
-	 * and it's not logged so we don't shutdown when we should.
-	 */
-	if (bma.logflags)
-		xfs_trans_log_inode(tp, ip, bma.logflags);
-
-	if (bma.cur) {
-		xfs_btree_del_cursor(bma.cur, error);
-	}
-	if (!error)
-		xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
-			orig_nmap, *nmap);
+	xfs_bmapi_finish(&bma, whichfork, error);
 	return error;
 }
 
-- 
2.20.1
