Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40570 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfAACYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:24:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012OFlP179003
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:43 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2pp1jqx46t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:24:43 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012Og5E000883
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:42 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012Og4U029618
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:42 GMT
Subject: [PATCH 03/20] xfs: widen xfs_rmap_irec fields to handle realtime
 rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:24:41 -0800
Message-ID: <154630948106.8108.7045016232249574637.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the startblock and blockcount fields of xfs_rmap_irec to be 64
bits wide.  This enables us to use the same high level rmap code for
either tree.  We'll also collect all the resulting breakage fixes here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h   |    4 +-
 fs/xfs/libxfs/xfs_refcount.c |    6 +--
 fs/xfs/libxfs/xfs_rmap.c     |   81 +++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_rmap.h     |   36 +++++++++----------
 fs/xfs/xfs_trace.h           |   38 ++++++++++----------
 5 files changed, 82 insertions(+), 83 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ab7db41b2163..232eeb020f72 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1456,8 +1456,8 @@ struct xfs_rmap_rec {
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
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 542aa1475b5f..198f0c96ccae 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1560,8 +1560,7 @@ xfs_refcount_alloc_cow_extent(
 		return error;
 
 	/* Add rmap entry */
-	return xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	return xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1578,8 +1577,7 @@ xfs_refcount_free_cow_extent(
 		return 0;
 
 	/* Remove rmap entry */
-	error = xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	error = xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 8ed885507dd8..4d37fd8ec5d5 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -36,8 +36,8 @@
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
@@ -58,8 +58,8 @@ xfs_rmap_lookup_le(
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
@@ -105,8 +105,8 @@ xfs_rmap_update(
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
@@ -141,8 +141,8 @@ xfs_rmap_insert(
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
@@ -197,6 +197,9 @@ xfs_rmap_get_rec(
 	union xfs_btree_rec	*rec;
 	int			error;
 
+	if (cur->bc_btnum != XFS_BTNUM_RMAP)
+		goto out_bad_rec;
+
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || !*stat)
 		return error;
@@ -234,7 +237,7 @@ xfs_rmap_get_rec(
 		"Reverse Mapping BTree record corruption in AG %d detected!",
 		agno);
 	xfs_warn(mp,
-		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
+		"Owner 0x%llx, flags 0x%x, start block 0x%llx block count 0x%llx",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
 		irec->rm_blockcount);
 	return -EFSCORRUPTED;
@@ -280,7 +283,7 @@ xfs_rmap_find_left_neighbor_helper(
 int
 xfs_rmap_find_left_neighbor(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		bno,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -358,7 +361,7 @@ xfs_rmap_lookup_le_range_helper(
 int
 xfs_rmap_lookup_le_range(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		bno,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -459,8 +462,8 @@ xfs_rmap_free_check_owner(
 STATIC int
 xfs_rmap_unmap(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -607,7 +610,7 @@ xfs_rmap_unmap(
 		 * Result:  |rrrrr|         |rrrr|
 		 *               bno       len
 		 */
-		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+		xfs_filblks_t	orig_len = ltrec.rm_blockcount;
 
 		ltrec.rm_blockcount = bno - ltrec.rm_startblock;
 		error = xfs_rmap_update(cur, &ltrec);
@@ -711,8 +714,8 @@ xfs_rmap_is_mergeable(
 STATIC int
 xfs_rmap_map(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -930,8 +933,8 @@ xfs_rmap_alloc(
 STATIC int
 xfs_rmap_convert(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -1355,8 +1358,8 @@ xfs_rmap_convert(
 STATIC int
 xfs_rmap_convert_shared(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -1744,8 +1747,8 @@ xfs_rmap_convert_shared(
 STATIC int
 xfs_rmap_unmap_shared(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -1862,7 +1865,7 @@ xfs_rmap_unmap_shared(
 		 * Result:  |rrrrr|         |rrrr|
 		 *               bno       len
 		 */
-		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+		xfs_filblks_t	orig_len = ltrec.rm_blockcount;
 
 		/* Shrink the left side of the rmap */
 		error = xfs_rmap_lookup_eq(cur, ltrec.rm_startblock,
@@ -1906,8 +1909,8 @@ xfs_rmap_unmap_shared(
 STATIC int
 xfs_rmap_map_shared(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -2174,7 +2177,7 @@ xfs_rmap_finish_one(
 	int				error = 0;
 	xfs_agnumber_t			agno;
 	struct xfs_owner_info		oinfo;
-	xfs_agblock_t			bno;
+	xfs_fsblock_t			bno;
 	bool				unwritten;
 
 	agno = XFS_FSB_TO_AGNO(mp, startblock);
@@ -2363,9 +2366,8 @@ xfs_rmap_convert_extent(
 int
 xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		len,
 	uint64_t		owner)
 {
 	struct xfs_bmbt_irec	bmap;
@@ -2373,7 +2375,7 @@ xfs_rmap_alloc_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return 0;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
@@ -2385,9 +2387,8 @@ xfs_rmap_alloc_extent(
 int
 xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		len,
 	uint64_t		owner)
 {
 	struct xfs_bmbt_irec	bmap;
@@ -2395,7 +2396,7 @@ xfs_rmap_free_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return 0;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
@@ -2435,8 +2436,8 @@ xfs_rmap_compare(
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
@@ -2460,8 +2461,8 @@ xfs_rmap_has_record(
 int
 xfs_rmap_record_exists(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	bool				*has_rmap)
 {
@@ -2528,8 +2529,8 @@ xfs_rmap_has_other_keys_helper(
 int
 xfs_rmap_has_other_keys(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	bool				*has_rmap)
 {
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index e21ed0294e5c..b536cdd596ec 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -118,14 +118,14 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
 		  const struct xfs_owner_info *oinfo);
 
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
@@ -168,10 +168,10 @@ int xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 int xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
-int xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
-int xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
+int xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_filblks_t len, uint64_t owner);
+int xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_filblks_t len, uint64_t owner);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
@@ -180,10 +180,10 @@ int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
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
@@ -191,13 +191,13 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
-int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, bool *exists);
-int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
+int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, bool *exists);
+int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		bool *has_rmap);
-int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
+int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		bool *has_rmap);
 int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 21dc5846dc2f..c2a94ff6ab35 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2438,14 +2438,14 @@ DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_deferred);
 /* rmap tracepoints */
 DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten,
+		 xfs_fsblock_t bno, xfs_filblks_t len, bool unwritten,
 		 const struct xfs_owner_info *oinfo),
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
@@ -2453,7 +2453,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
-		__entry->agbno = agbno;
+		__entry->bno = bno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
 		__entry->offset = oinfo->oi_offset;
@@ -2461,10 +2461,10 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
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
@@ -2473,9 +2473,9 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 #define DEFINE_RMAP_EVENT(name) \
 DEFINE_EVENT(xfs_rmap_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten, \
+		 xfs_fsblock_t bno, xfs_filblks_t len, bool unwritten, \
 		 const struct xfs_owner_info *oinfo), \
-	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo))
+	TP_ARGS(mp, agno, bno, len, unwritten, oinfo))
 
 /* simple AG-based error/%ip tracepoint class */
 DECLARE_EVENT_CLASS(xfs_ag_error_class,
@@ -2494,7 +2494,7 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u error %d caller %pS",
+	TP_printk("dev %d:%d agno %d error %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->error,
@@ -2520,14 +2520,14 @@ DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_state);
 
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
@@ -2535,16 +2535,16 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
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
@@ -2553,9 +2553,9 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
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
