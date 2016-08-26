Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF9A68433
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:00:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 562E6304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:19 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id zftTjPfGUEwxESiT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:17 -0700 (PDT)
Subject: [PATCH 14/29] xfs: wire up rmap map and unmap to the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:00:05 -0700
Message-ID: <147216960528.7022.7032026127533793722.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Connect the map and unmap reverse-mapping operations to the realtime
rmapbt via the deferred operation callbacks.  This enables us to
perform rmap operations against the correct btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/defer_item.c |    3 ++
 libxfs/xfs_rmap.c   |   63 +++++++++++++++++++++++++++++++++------------------
 libxfs/xfs_rmap.h   |    9 ++++---
 3 files changed, 48 insertions(+), 27 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d4cd876..58b646f 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -200,13 +200,14 @@ xfs_rmap_update_finish_item(
 	int				error;
 
 	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-	error = xfs_rmap_finish_one(tp,
+	error = xfs_rmap_finish_one(tp, dop,
 			rmap->ri_type,
 			rmap->ri_owner, rmap->ri_whichfork,
 			rmap->ri_bmap.br_startoff,
 			rmap->ri_bmap.br_startblock,
 			rmap->ri_bmap.br_blockcount,
 			rmap->ri_bmap.br_state,
+			rmap->ri_realtime,
 			(struct xfs_btree_cur **)state);
 	kmem_free(rmap);
 	return error;
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 4ed2f2e..55744b7 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -36,6 +36,7 @@
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_rtrmap_btree.h"
 
 /* By convention, the rtrmapbt's "AG" number is NULLAGNUMBER. */
 static xfs_agnumber_t
@@ -2060,13 +2061,14 @@ xfs_rmap_finish_one_cleanup(
 	struct xfs_btree_cur	*rcur,
 	int			error)
 {
-	struct xfs_buf		*agbp;
+	struct xfs_buf		*agbp = NULL;
 
 	if (rcur == NULL)
 		return;
-	agbp = rcur->bc_private.a.agbp;
+	if (!(rcur->bc_flags & XFS_BTREE_LONG_PTRS))
+		agbp = rcur->bc_private.a.agbp;
 	xfs_btree_del_cursor(rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
-	if (error)
+	if (error && agbp)
 		xfs_trans_brelse(tp, agbp);
 }
 
@@ -2080,6 +2082,7 @@ xfs_rmap_finish_one_cleanup(
 int
 xfs_rmap_finish_one(
 	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dfops,
 	enum xfs_rmap_intent_type	type,
 	__uint64_t			owner,
 	int				whichfork,
@@ -2087,6 +2090,7 @@ xfs_rmap_finish_one(
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
 	xfs_exntst_t			state,
+	bool				realtime,
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -2098,9 +2102,8 @@ xfs_rmap_finish_one(
 	xfs_fsblock_t			bno;
 	bool				unwritten;
 
-	agno = XFS_FSB_TO_AGNO(mp, startblock);
-	ASSERT(agno != NULLAGNUMBER);
-	bno = XFS_FSB_TO_AGBNO(mp, startblock);
+	agno = realtime ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, startblock);
+	bno = realtime ? startblock : XFS_FSB_TO_AGBNO(mp, startblock);
 
 	trace_xfs_rmap_deferred(mp, agno, type, bno, owner, whichfork,
 			startoff, blockcount, state);
@@ -2120,31 +2123,45 @@ xfs_rmap_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		/*
-		 * Refresh the freelist before we start changing the
-		 * rmapbt, because a shape change could cause us to
-		 * allocate blocks.
-		 */
-		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
-		if (error)
-			return error;
-		if (!agbp)
-			return -EFSCORRUPTED;
-
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
-		if (!rcur) {
-			error = -ENOMEM;
-			goto out_cur;
+		if (realtime) {
+			xfs_ilock(mp->m_rrmapip,
+					XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
+			xfs_trans_ijoin(tp, mp->m_rrmapip, XFS_ILOCK_EXCL);
+			rcur = xfs_rtrmapbt_init_cursor(mp, tp, mp->m_rrmapip);
+			if (!rcur) {
+				error = -ENOMEM;
+				goto out_cur;
+			}
+			rcur->bc_private.b.dfops = dfops;
+			rcur->bc_private.b.flags = 0;
+		} else {
+			/*
+			 * Refresh the freelist before we start changing the
+			 * rmapbt, because a shape change could cause us to
+			 * allocate blocks.
+			 */
+			error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+			if (error)
+				return error;
+			if (!agbp)
+				return -EFSCORRUPTED;
+
+			rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+			if (!rcur) {
+				error = -ENOMEM;
+				goto out_cur;
+			}
 		}
 	}
 	*pcur = rcur;
 
 	xfs_rmap_ino_owner(&oinfo, owner, whichfork, startoff);
 	unwritten = state == XFS_EXT_UNWRITTEN;
-	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, startblock);
 
 	switch (type) {
 	case XFS_RMAP_ALLOC:
+		ASSERT(!realtime);
+		/* fall through */
 	case XFS_RMAP_MAP:
 		error = xfs_rmap_map(rcur, bno, blockcount, unwritten, &oinfo);
 		break;
@@ -2153,6 +2170,8 @@ xfs_rmap_finish_one(
 				&oinfo);
 		break;
 	case XFS_RMAP_FREE:
+		ASSERT(!realtime);
+		/* fall through */
 	case XFS_RMAP_UNMAP:
 		error = xfs_rmap_unmap(rcur, bno, blockcount, unwritten,
 				&oinfo);
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 0850310..8d9c48f 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -202,10 +202,11 @@ int xfs_rmap_free_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
-int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
-		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
-		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_defer_ops *dfops,
+		enum xfs_rmap_intent_type type, __uint64_t owner, int whichfork,
+		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
+		xfs_filblks_t blockcount, xfs_exntst_t state, bool realtime,
+		struct xfs_btree_cur **pcur);
 
 int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
