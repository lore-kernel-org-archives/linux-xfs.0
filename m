Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48030 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdHaUdr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:33:47 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKXk5h013798
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:33:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKXj2l009617
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:33:45 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKXjlT006360
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:33:45 GMT
Subject: [PATCH 03/19] xfs: widen xfs_refcount_irec fields to handle
 realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:33:43 -0700
Message-ID: <150421162324.17458.451388123098119519.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the startblock and blockcount fields of xfs_refcount_irec to
be 64 bits wide.  This enables us to use the same high level rmap
code for either tree.  We'll also collect all the resulting breakage
fixes here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    4 +--
 fs/xfs/libxfs/xfs_rmap.c   |   70 ++++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_rmap.h   |   32 ++++++++++----------
 fs/xfs/scrub/ialloc.c      |    2 +
 fs/xfs/xfs_trace.h         |   38 ++++++++++++------------
 5 files changed, 73 insertions(+), 73 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d4d9bef..294aa65 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1435,8 +1435,8 @@ struct xfs_rmap_rec {
 					 XFS_RMAP_BMBT_BLOCK)
 #define XFS_RMAP_REC_FLAGS		(XFS_RMAP_UNWRITTEN)
 struct xfs_rmap_irec {
-	xfs_agblock_t	rm_startblock;	/* extent start block */
-	xfs_extlen_t	rm_blockcount;	/* extent length */
+	xfs_fsblock_t	rm_startblock;	/* extent start block */
+	xfs_filblks_t	rm_blockcount;	/* extent length */
 	uint64_t	rm_owner;	/* extent owner */
 	uint64_t	rm_offset;	/* offset within the owner */
 	unsigned int	rm_flags;	/* state flags */
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index d14af8b..a3c2cc9 100644
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
@@ -151,8 +151,8 @@ xfs_rmap_insert(
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
@@ -862,8 +862,8 @@ xfs_rmap_alloc(
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
@@ -1287,8 +1287,8 @@ xfs_rmap_convert(
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
@@ -1674,8 +1674,8 @@ xfs_rmap_convert_shared(
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
@@ -1836,8 +1836,8 @@ xfs_rmap_unmap_shared(
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
@@ -2104,7 +2104,7 @@ xfs_rmap_finish_one(
 	int				error = 0;
 	xfs_agnumber_t			agno;
 	struct xfs_owner_info		oinfo;
-	xfs_agblock_t			bno;
+	xfs_fsblock_t			bno;
 	bool				unwritten;
 
 	agno = XFS_FSB_TO_AGNO(mp, startblock);
@@ -2292,8 +2292,8 @@ xfs_rmap_alloc_extent(
 	struct xfs_mount	*mp,
 	struct xfs_defer_ops	*dfops,
 	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	uint64_t		owner)
 {
 	struct xfs_bmbt_irec	bmap;
@@ -2316,8 +2316,8 @@ xfs_rmap_free_extent(
 	struct xfs_mount	*mp,
 	struct xfs_defer_ops	*dfops,
 	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	uint64_t		owner)
 {
 	struct xfs_bmbt_irec	bmap;
@@ -2366,8 +2366,8 @@ xfs_rmap_compare(
 int
 xfs_rmap_has_record(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	bool			*exists)
 {
 	union xfs_btree_irec	low;
@@ -2385,8 +2385,8 @@ xfs_rmap_has_record(
 int
 xfs_rmap_record_exists(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	struct xfs_owner_info	*oinfo,
 	bool			*has_rmap)
 {
@@ -2450,8 +2450,8 @@ xfs_rmap_has_other_keys_helper(
 int
 xfs_rmap_has_other_keys(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	struct xfs_owner_info		*oinfo,
 	bool				*has_rmap)
 {
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 180b127..6b32f65 100644
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
@@ -195,10 +195,10 @@ int xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
 int xfs_rmap_alloc_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
-		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		xfs_agnumber_t agno, xfs_fsblock_t bno, xfs_filblks_t len,
 		uint64_t owner);
 int xfs_rmap_free_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
-		xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		xfs_agnumber_t agno, xfs_fsblock_t bno, xfs_filblks_t len,
 		uint64_t owner);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
@@ -208,10 +208,10 @@ int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
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
 int xfs_rmap_compare(const struct xfs_rmap_irec *a,
@@ -219,13 +219,13 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
-int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, bool *exists);
-int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, struct xfs_owner_info *oinfo,
+int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, bool *exists);
+int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo,
 		bool *has_rmap);
-int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, struct xfs_owner_info *oinfo,
+int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo,
 		bool *has_rmap);
 int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 7503ade..c7228dc 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -565,7 +565,7 @@ xfs_repair_ialloc_extent_fn(
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
 	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
 
-	if (rec->rm_startblock % blks_per_cluster != 0)
+	if ((unsigned int)rec->rm_startblock % blks_per_cluster != 0)
 		return -EFSCORRUPTED;
 
 	trace_xfs_repair_ialloc_extent_fn(mp, cur->bc_private.a.agno,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bcc3cdf..0bc7494 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2426,14 +2426,14 @@ DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
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
@@ -2441,7 +2441,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
-		__entry->agbno = agbno;
+		__entry->bno = bno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
 		__entry->offset = oinfo->oi_offset;
@@ -2449,10 +2449,10 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
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
@@ -2461,9 +2461,9 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
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
@@ -2482,7 +2482,7 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u error %d caller %ps",
+	TP_printk("dev %d:%d agno %d error %d caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->error,
@@ -2508,14 +2508,14 @@ DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_state);
 
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
@@ -2523,16 +2523,16 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
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
@@ -2541,9 +2541,9 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
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

