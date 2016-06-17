Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 69CF682F2
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:40:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1DF1AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:40:22 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 0AJk6vZEUu7LnhIQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:40:21 -0700 (PDT)
Subject: [PATCH 090/145] xfs: return work remaining at the end of a bunmapi
	operation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:40:17 -0700
Message-ID: <146612761750.16048.7128549085400683099.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Return the range of file blocks that bunmapi didn't free.  This hint
is used by CoW and reflink to figure out what part of an extent
actually got freed so that it can set up the appropriate atomic
remapping of just the freed range.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.c |   36 ++++++++++++++++++++++++++++++------
 libxfs/xfs_bmap.h |    4 ++++
 2 files changed, 34 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index dff4b7b..f0c0871 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5157,17 +5157,16 @@ done:
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
@@ -5189,6 +5188,7 @@ xfs_bunmapi(
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
 	xfs_fsblock_t		sum;
+	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
@@ -5215,7 +5215,7 @@ xfs_bunmapi(
 		return error;
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	if (nextents == 0) {
-		*done = 1;
+		*rlen = 0;
 		return 0;
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
@@ -5484,7 +5484,10 @@ nodelete:
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
@@ -5540,6 +5543,27 @@ error0:
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
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 394a22c..97828c5 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
