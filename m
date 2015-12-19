Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70CDB7FBE
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:57:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 376C9304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:51 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 7fH9MLAM6nO2zdId (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:48 -0800 (PST)
Subject: [PATCH 12/76] xfs: extend rmap extent operation stubs to take full
	owner info
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:57:42 -0800
Message-ID: <20151219085742.12713.73618.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

Extend the stubs to take full owner info.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |   25 +++++++++++++++----------
 fs/xfs/libxfs/xfs_rmap.c       |   16 ++++++++--------
 fs/xfs/libxfs/xfs_rmap_btree.h |    4 ++--
 fs/xfs/xfs_trace.h             |   22 +++++++++++++++-------
 4 files changed, 40 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 46a8906..6c82021 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -647,11 +647,13 @@ xfs_alloc_ag_vextent(
 	ASSERT(!args->wasfromfl || !args->isfl);
 	ASSERT(args->agbno % args->alignment == 0);
 
-	/* insert new block into the reverse map btree */
-	error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
-			       args->agbno, args->len, args->owner);
-	if (error)
-		return error;
+	/* if not file data, insert new block into the reverse map btree */
+	if (args->oinfo.oi_owner) {
+		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
+				       args->agbno, args->len, &args->oinfo);
+		if (error)
+			return error;
+	}
 
 	if (!args->wasfromfl) {
 		error = xfs_alloc_update_counters(args->tp, args->pag,
@@ -1619,16 +1621,19 @@ xfs_free_ag_extent(
 	xfs_extlen_t	nlen;		/* new length of freespace */
 	xfs_perag_t	*pag;		/* per allocation group data */
 
-	error = xfs_rmap_free(tp, agbp, agno, bno, len, owner);
-	if (error)
-		goto error0;
-
+	bno_cur = cnt_cur = NULL;
 	mp = tp->t_mountp;
+
+	if (oinfo->oi_owner) {
+		error = xfs_rmap_free(tp, agbp, agno, bno, len, oinfo);
+		if (error)
+			goto error0;
+	}
+
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
 	 */
 	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO);
-	cnt_cur = NULL;
 	/*
 	 * Look for a neighboring block on the left (lower block numbers)
 	 * that is contiguous with this space.
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3958cf8..3e17294 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -43,7 +43,7 @@ xfs_rmap_free(
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	uint64_t		owner)
+	struct xfs_owner_info	*oinfo)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	int			error = 0;
@@ -51,14 +51,14 @@ xfs_rmap_free(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	trace_xfs_rmap_free_extent(mp, agno, bno, len, owner);
+	trace_xfs_rmap_free_extent(mp, agno, bno, len, oinfo);
 	if (1)
 		goto out_error;
-	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, owner);
+	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, oinfo);
 	return 0;
 
 out_error:
-	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, owner);
+	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, oinfo);
 	return error;
 }
 
@@ -69,7 +69,7 @@ xfs_rmap_alloc(
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	uint64_t		owner)
+	struct xfs_owner_info	*oinfo)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	int			error = 0;
@@ -77,13 +77,13 @@ xfs_rmap_alloc(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, owner);
+	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, oinfo);
 	if (1)
 		goto out_error;
-	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, owner);
+	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, oinfo);
 	return 0;
 
 out_error:
-	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, owner);
+	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, oinfo);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index f1caa40..a3b8f90 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -22,9 +22,9 @@ struct xfs_buf;
 
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
 		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
-		   uint64_t owner);
+		   struct xfs_owner_info *oinfo);
 int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
-		  uint64_t owner);
+		  struct xfs_owner_info *oinfo);
 
 #endif	/* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f506396..d41b093 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1678,34 +1678,42 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
 
 DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner),
-	TP_ARGS(mp, agno, agbno, len, owner),
+		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 struct xfs_owner_info *oinfo),
+	TP_ARGS(mp, agno, agbno, len, oinfo),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
 		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned long, flags)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
-		__entry->owner = owner;
+		__entry->owner = oinfo->oi_owner;
+		__entry->offset = oinfo->oi_offset;
+		__entry->flags = oinfo->oi_flags;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u, owner 0x%llx",
+	TP_printk("dev %d:%d agno %u agbno %u len %u, owner 0x%llx, offset %llu, flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len,
-		  __entry->owner)
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
 );
 #define DEFINE_RMAP_EVENT(name) \
 DEFINE_EVENT(xfs_rmap_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner), \
-	TP_ARGS(mp, agno, agbno, len, owner))
+		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 struct xfs_owner_info *oinfo), \
+	TP_ARGS(mp, agno, agbno, len, oinfo))
 DEFINE_RMAP_EVENT(xfs_rmap_free_extent);
 DEFINE_RMAP_EVENT(xfs_rmap_free_extent_done);
 DEFINE_RMAP_EVENT(xfs_rmap_free_extent_error);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
