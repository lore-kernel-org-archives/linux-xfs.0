Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42402 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755913AbcI3DI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:08:27 -0400
Subject: [PATCH 25/63] xfs: return work remaining at the end of a bunmapi
 operation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:08:23 -0700
Message-ID: <147520490339.29434.11775509253578580319.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Return the range of file blocks that bunmapi didn't free.  This hint
is used by CoW and reflink to figure out what part of an extent
actually got freed so that it can set up the appropriate atomic
remapping of just the freed range.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   36 ++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_bmap.h |    4 ++++
 2 files changed, 34 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a5e429e..1e4f1a1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5093,17 +5093,16 @@ xfs_bmap_del_extent(
  * *done is set.
  */
 int						/* error */
-xfs_bunmapi(
+__xfs_bunmapi(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* incore inode */
 	xfs_fileoff_t		bno,		/* starting offset to unmap */
-	xfs_filblks_t		len,		/* length to unmap in file */
+	xfs_filblks_t		*rlen,		/* i/o: amount remaining */
 	int			flags,		/* misc flags */
 	xfs_extnum_t		nexts,		/* number of extents max */
 	xfs_fsblock_t		*firstblock,	/* first allocated block
 						   controls a.g. for allocs */
-	struct xfs_defer_ops	*dfops,		/* i/o: list extents to free */
-	int			*done)		/* set if not done yet */
+	struct xfs_defer_ops	*dfops)		/* i/o: deferred updates */
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
 	xfs_bmbt_irec_t		del;		/* extent being deleted */
@@ -5125,6 +5124,7 @@ xfs_bunmapi(
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
 	xfs_fsblock_t		sum;
+	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
@@ -5151,7 +5151,7 @@ xfs_bunmapi(
 		return error;
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	if (nextents == 0) {
-		*done = 1;
+		*rlen = 0;
 		return 0;
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
@@ -5422,7 +5422,10 @@ xfs_bunmapi(
 			extno++;
 		}
 	}
-	*done = bno == (xfs_fileoff_t)-1 || bno < start || lastx < 0;
+	if (bno == (xfs_fileoff_t)-1 || bno < start || lastx < 0)
+		*rlen = 0;
+	else
+		*rlen = bno - start + 1;
 
 	/*
 	 * Convert to a btree if necessary.
@@ -5478,6 +5481,27 @@ xfs_bunmapi(
 	return error;
 }
 
+/* Unmap a range of a file. */
+int
+xfs_bunmapi(
+	xfs_trans_t		*tp,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		bno,
+	xfs_filblks_t		len,
+	int			flags,
+	xfs_extnum_t		nexts,
+	xfs_fsblock_t		*firstblock,
+	struct xfs_defer_ops	*dfops,
+	int			*done)
+{
+	int			error;
+
+	error = __xfs_bunmapi(tp, ip, bno, &len, flags, nexts, firstblock,
+			dfops);
+	*done = (len == 0);
+	return error;
+}
+
 /*
  * Determine whether an extent shift can be accomplished by a merge with the
  * extent that precedes the target hole of the shift.
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 53970b1..48ba3ed 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -197,6 +197,10 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fsblock_t *firstblock, xfs_extlen_t total,
 		struct xfs_bmbt_irec *mval, int *nmap,
 		struct xfs_defer_ops *dfops);
+int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t bno, xfs_filblks_t *rlen, int flags,
+		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
+		struct xfs_defer_ops *dfops);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,

