Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC1007FDD
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:43:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FFD1AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:43:59 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id YE08eXwL6Ufw8ea6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:43:57 -0700 (PDT)
Subject: [PATCH 04/20] xfs: widen xfs_refcount_irec fields to handle
	realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:43:51 -0700
Message-ID: <147216863155.3688.8152957980694721928.stgit@birch.djwong.org>
In-Reply-To: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
References: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
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

Change the startblock and blockcount fields of xfs_refcount_irec to
be 64 bits wide.  This enables us to use the same high level rmap
code for either tree.  We'll also collect all the resulting breakage
fixes here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    4 ++-
 fs/xfs/libxfs/xfs_rmap.c   |   58 ++++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_rmap.h   |   20 ++++++++-------
 fs/xfs/xfs_trace.h         |   38 ++++++++++++++---------------
 4 files changed, 60 insertions(+), 60 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5703b57..62c19ce 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1436,8 +1436,8 @@ struct xfs_rmap_rec {
 					 XFS_RMAP_BMBT_BLOCK)
 #define XFS_RMAP_REC_FLAGS		(XFS_RMAP_UNWRITTEN)
 struct xfs_rmap_irec {
-	xfs_agblock_t	rm_startblock;	/* extent start block */
-	xfs_extlen_t	rm_blockcount;	/* extent length */
+	xfs_fsblock_t	rm_startblock;	/* extent start block */
+	xfs_filblks_t	rm_blockcount;	/* extent length */
 	__uint64_t	rm_owner;	/* extent owner */
 	__uint64_t	rm_offset;	/* offset within the owner */
 	unsigned int	rm_flags;	/* state flags */
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b22f93d..aa5052f 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -46,8 +46,8 @@
 int
 xfs_rmap_lookup_le(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -68,8 +68,8 @@ xfs_rmap_lookup_le(
 int
 xfs_rmap_lookup_eq(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -115,8 +115,8 @@ xfs_rmap_update(
 int
 xfs_rmap_insert(
 	struct xfs_btree_cur	*rcur,
-	xfs_agblock_t		agbno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		agbno,
+	xfs_filblks_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags)
@@ -151,8 +151,8 @@ done:
 STATIC int
 xfs_rmap_delete(
 	struct xfs_btree_cur	*rcur,
-	xfs_agblock_t		agbno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		agbno,
+	xfs_filblks_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags)
@@ -252,7 +252,7 @@ xfs_rmap_find_left_neighbor_helper(
 int
 xfs_rmap_find_left_neighbor(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		bno,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -330,7 +330,7 @@ xfs_rmap_lookup_le_range_helper(
 int
 xfs_rmap_lookup_le_range(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		bno,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -387,8 +387,8 @@ xfs_rmap_lookup_le_range(
 STATIC int
 xfs_rmap_unmap(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	bool			unwritten,
 	struct xfs_owner_info	*oinfo)
 {
@@ -528,7 +528,7 @@ xfs_rmap_unmap(
 		 * Result:  |rrrrr|         |rrrr|
 		 *               bno       len
 		 */
-		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+		xfs_filblks_t	orig_len = ltrec.rm_blockcount;
 
 		ltrec.rm_blockcount = bno - ltrec.rm_startblock;
 		error = xfs_rmap_update(cur, &ltrec);
@@ -638,8 +638,8 @@ xfs_rmap_is_mergeable(
 STATIC int
 xfs_rmap_map(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	bool			unwritten,
 	struct xfs_owner_info	*oinfo)
 {
@@ -862,8 +862,8 @@ out_error:
 STATIC int
 xfs_rmap_convert(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	bool			unwritten,
 	struct xfs_owner_info	*oinfo)
 {
@@ -1287,8 +1287,8 @@ done:
 STATIC int
 xfs_rmap_convert_shared(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	bool			unwritten,
 	struct xfs_owner_info	*oinfo)
 {
@@ -1674,8 +1674,8 @@ done:
 STATIC int
 xfs_rmap_unmap_shared(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	bool			unwritten,
 	struct xfs_owner_info	*oinfo)
 {
@@ -1792,7 +1792,7 @@ xfs_rmap_unmap_shared(
 		 * Result:  |rrrrr|         |rrrr|
 		 *               bno       len
 		 */
-		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+		xfs_filblks_t	orig_len = ltrec.rm_blockcount;
 
 		/* Shrink the left side of the rmap */
 		error = xfs_rmap_lookup_eq(cur, ltrec.rm_startblock,
@@ -1836,8 +1836,8 @@ out_error:
 STATIC int
 xfs_rmap_map_shared(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	bool			unwritten,
 	struct xfs_owner_info	*oinfo)
 {
@@ -2062,7 +2062,7 @@ xfs_rmap_finish_one(
 	int				error = 0;
 	xfs_agnumber_t			agno;
 	struct xfs_owner_info		oinfo;
-	xfs_agblock_t			bno;
+	xfs_fsblock_t			bno;
 	bool				unwritten;
 
 	agno = XFS_FSB_TO_AGNO(mp, startblock);
@@ -2251,8 +2251,8 @@ xfs_rmap_alloc_extent(
 	struct xfs_mount	*mp,
 	struct xfs_defer_ops	*dfops,
 	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	__uint64_t		owner)
 {
 	struct xfs_bmbt_irec	bmap;
@@ -2275,8 +2275,8 @@ xfs_rmap_free_extent(
 	struct xfs_mount	*mp,
 	struct xfs_defer_ops	*dfops,
 	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	__uint64_t		owner)
 {
 	struct xfs_bmbt_irec	bmap;
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index c5c5817..06f7e73 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -142,14 +142,14 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
 		  struct xfs_owner_info *oinfo);
 
-int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, uint64_t owner, uint64_t offset,
 		unsigned int flags, int *stat);
-int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, uint64_t owner, uint64_t offset,
 		unsigned int flags, int *stat);
-int xfs_rmap_insert(struct xfs_btree_cur *rcur, xfs_agblock_t agbno,
-		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+int xfs_rmap_insert(struct xfs_btree_cur *rcur, xfs_fsblock_t agbno,
+		xfs_filblks_t len, uint64_t owner, uint64_t offset,
 		unsigned int flags);
 int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
 		int *stat);
@@ -193,10 +193,10 @@ int xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
 int xfs_rmap_alloc_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
-		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		xfs_agnumber_t agno, xfs_fsblock_t bno, xfs_filblks_t len,
 		__uint64_t owner);
 int xfs_rmap_free_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
-		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		xfs_agnumber_t agno, xfs_fsblock_t bno, xfs_filblks_t len,
 		__uint64_t owner);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
@@ -206,10 +206,10 @@ int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
 		xfs_exntst_t state, struct xfs_btree_cur **pcur);
 
-int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
-int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
 union xfs_btree_rec;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 74963a1..8d916dd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2430,14 +2430,14 @@ DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
 /* rmap tracepoints */
 DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten,
+		 xfs_fsblock_t bno, xfs_filblks_t len, bool unwritten,
 		 struct xfs_owner_info *oinfo),
-	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo),
+	TP_ARGS(mp, agno, bno, len, unwritten, oinfo),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, bno)
+		__field(xfs_filblks_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
 		__field(unsigned long, flags)
@@ -2445,7 +2445,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
-		__entry->agbno = agbno;
+		__entry->bno = bno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
 		__entry->offset = oinfo->oi_offset;
@@ -2453,10 +2453,10 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%lx",
+	TP_printk("dev %d:%d agno %d bno %llu len %llu owner %lld offset %llu flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->bno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -2465,9 +2465,9 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 #define DEFINE_RMAP_EVENT(name) \
 DEFINE_EVENT(xfs_rmap_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten, \
+		 xfs_fsblock_t bno, xfs_filblks_t len, bool unwritten, \
 		 struct xfs_owner_info *oinfo), \
-	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo))
+	TP_ARGS(mp, agno, bno, len, unwritten, oinfo))
 
 /* simple AG-based error/%ip tracepoint class */
 DECLARE_EVENT_CLASS(xfs_ag_error_class,
@@ -2486,7 +2486,7 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u error %d caller %ps",
+	TP_printk("dev %d:%d agno %d error %d caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->error,
@@ -2512,14 +2512,14 @@ DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_state);
 
 DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 xfs_fsblock_t bno, xfs_filblks_t len,
 		 uint64_t owner, uint64_t offset, unsigned int flags),
-	TP_ARGS(mp, agno, agbno, len, owner, offset, flags),
+	TP_ARGS(mp, agno, bno, len, owner, offset, flags),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, bno)
+		__field(xfs_filblks_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
 		__field(unsigned int, flags)
@@ -2527,16 +2527,16 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
-		__entry->agbno = agbno;
+		__entry->bno = bno;
 		__entry->len = len;
 		__entry->owner = owner;
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno %d bno %llu len %llu owner %lld offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->bno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -2545,9 +2545,9 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 #define DEFINE_RMAPBT_EVENT(name) \
 DEFINE_EVENT(xfs_rmapbt_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 xfs_fsblock_t bno, xfs_filblks_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
-	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
+	TP_ARGS(mp, agno, bno, len, owner, offset, flags))
 
 #define DEFINE_RMAP_DEFERRED_EVENT DEFINE_MAP_EXTENT_DEFERRED_EVENT
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
