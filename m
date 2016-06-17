Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E5E58080
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:32:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F0278F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:10 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OrXQr9DxezIaQxTw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:08 -0700 (PDT)
Subject: [PATCH 012/145] xfs: separate freelist fixing into a separate helper
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:32:00 -0700
Message-ID: <146612712023.16048.11958690424572913723.stgit@birch.djwong.org>
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

From: Dave Chinner <david@fromorbit.com>

Break up xfs_free_extent() into a helper that fixes the freelist.
This helper will be used subsequently to ensure the freelist during
deferred rmap processing.

Signed-off-by: Dave Chinner <david@fromorbit.com>
[darrick: refactor to put this at the head of the patchset]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |   82 ++++++++++++++++++++++++++++++++++------------------
 libxfs/xfs_alloc.h |    2 +
 2 files changed, 55 insertions(+), 29 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 8520f31..2998af8 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2656,55 +2656,79 @@ error0:
 	return error;
 }
 
-/*
- * Free an extent.
- * Just break up the extent address and hand off to xfs_free_ag_extent
- * after fixing up the freelist.
- */
-int				/* error */
-xfs_free_extent(
-	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len)	/* length of extent */
+/* Ensure that the freelist is at full capacity. */
+int
+xfs_free_extent_fix_freelist(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		**agbp)
 {
-	xfs_alloc_arg_t	args;
-	int		error;
+	xfs_alloc_arg_t		args;
+	int			error;
 
-	ASSERT(len != 0);
 	memset(&args, 0, sizeof(xfs_alloc_arg_t));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
+	args.agno = agno;
 
 	/*
 	 * validate that the block number is legal - the enables us to detect
 	 * and handle a silent filesystem corruption rather than crashing.
 	 */
-	args.agno = XFS_FSB_TO_AGNO(args.mp, bno);
 	if (args.agno >= args.mp->m_sb.sb_agcount)
 		return -EFSCORRUPTED;
 
-	args.agbno = XFS_FSB_TO_AGBNO(args.mp, bno);
-	if (args.agbno >= args.mp->m_sb.sb_agblocks)
-		return -EFSCORRUPTED;
-
 	args.pag = xfs_perag_get(args.mp, args.agno);
 	ASSERT(args.pag);
 
 	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
 	if (error)
-		goto error0;
+		goto out;
+
+	*agbp = args.agbp;
+out:
+	xfs_perag_put(args.pag);
+	return error;
+}
+
+/*
+ * Free an extent.
+ * Just break up the extent address and hand off to xfs_free_ag_extent
+ * after fixing up the freelist.
+ */
+int				/* error */
+xfs_free_extent(
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_fsblock_t		bno,	/* starting block number of extent */
+	xfs_extlen_t		len)	/* length of extent */
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, bno);
+	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	int			error;
+
+	ASSERT(len != 0);
+
+	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+	if (error)
+		return error;
+
+	XFS_WANT_CORRUPTED_GOTO(mp, agbno < mp->m_sb.sb_agblocks, err);
 
 	/* validate the extent size is legal now we have the agf locked */
-	if (args.agbno + len >
-			be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length)) {
-		error = -EFSCORRUPTED;
-		goto error0;
-	}
+	XFS_WANT_CORRUPTED_GOTO(mp,
+			agbno + len <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length),
+			err);
 
-	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
-	if (!error)
-		xfs_extent_busy_insert(tp, args.agno, args.agbno, len, 0);
-error0:
-	xfs_perag_put(args.pag);
+	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, 0);
+	if (error)
+		goto err;
+
+	xfs_extent_busy_insert(tp, agno, agbno, len, 0);
+	return 0;
+
+err:
+	xfs_trans_brelse(tp, agbp);
 	return error;
 }
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 92a66ba..cf268b2 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -229,5 +229,7 @@ xfs_alloc_get_rec(
 int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
+int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
+		struct xfs_buf **agbp);
 
 #endif	/* __XFS_ALLOC_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
