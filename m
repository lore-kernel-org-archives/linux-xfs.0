Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58038 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752264AbeDDW5l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 18:57:41 -0400
Subject: [PATCH 2/2 V2] xfs: non-scrub - remove unused function parameters
References: <b2b1aa4b-9ba9-eb4d-c91c-889a25fdd61e@redhat.com>
 <da7a3431-7f62-1e00-9260-11917723d29e@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <774e0923-d119-4694-e99c-2885d3cb1383@sandeen.net>
Date: Wed, 4 Apr 2018 17:57:40 -0500
MIME-Version: 1.0
In-Reply-To: <da7a3431-7f62-1e00-9260-11917723d29e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: sorry, sliced & diced wrong; remove the scrub bits

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 39387bd..4bcc095 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1947,7 +1947,7 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 xfs_alloc_compute_maxlevels(
 	xfs_mount_t	*mp)	/* file system mount structure */
 {
-	mp->m_ag_maxlevels = xfs_btree_compute_maxlevels(mp, mp->m_alloc_mnr,
+	mp->m_ag_maxlevels = xfs_btree_compute_maxlevels(mp->m_alloc_mnr,
 			(mp->m_sb.sb_agblocks + 1) / 2);
 }
 
@@ -1959,7 +1959,6 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
  */
 xfs_extlen_t
 xfs_alloc_longest_free_extent(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	xfs_extlen_t		need,
 	xfs_extlen_t		reserved)
@@ -2038,8 +2037,7 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 
 	/* do we have enough contiguous free space for the allocation? */
 	alloc_len = args->minlen + (args->alignment - 1) + args->minalignslop;
-	longest = xfs_alloc_longest_free_extent(args->mp, pag, min_free,
-			reservation);
+	longest = xfs_alloc_longest_free_extent(pag, min_free, reservation);
 	if (longest < alloc_len)
 		return false;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index a311a24..cbf789e 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -116,9 +116,8 @@
 unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
 unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
 
-xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_mount *mp,
-		struct xfs_perag *pag, xfs_extlen_t need,
-		xfs_extlen_t reserved);
+xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
+		xfs_extlen_t need, xfs_extlen_t reserved);
 unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
 		struct xfs_perag *pag);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3b03d88..6a7c2f0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3225,7 +3225,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 		}
 	}
 
-	longest = xfs_alloc_longest_free_extent(mp, pag,
+	longest = xfs_alloc_longest_free_extent(pag,
 				xfs_alloc_min_freelist(mp, pag),
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 	if (*blen < longest)
@@ -5667,7 +5667,6 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	xfs_fileoff_t		*next_fsb,
 	xfs_fileoff_t		offset_shift_fsb,
 	bool			*done,
-	xfs_fileoff_t		stop_fsb,
 	xfs_fsblock_t		*firstblock,
 	struct xfs_defer_ops	*dfops)
 {
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f3be641..2b766b3 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -228,7 +228,7 @@ void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
-		bool *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock,
+		bool *done, xfs_fsblock_t *firstblock,
 		struct xfs_defer_ops *dfops);
 int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index edc0193..ac7d664 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4531,7 +4531,6 @@ struct xfs_btree_block_change_owner_info {
  */
 uint
 xfs_btree_compute_maxlevels(
-	struct xfs_mount	*mp,
 	uint			*limits,
 	unsigned long		len)
 {
@@ -4839,7 +4838,6 @@ struct xfs_btree_block_change_owner_info {
  */
 xfs_extlen_t
 xfs_btree_calc_size(
-	struct xfs_mount	*mp,
 	uint			*limits,
 	unsigned long long	len)
 {
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 58e30c0..9227159 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -481,10 +481,8 @@ xfs_failaddr_t xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp,
 xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
 
-uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
-				 unsigned long len);
-xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
-		unsigned long long len);
+uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
+xfs_extlen_t xfs_btree_calc_size(uint *limits, unsigned long long len);
 
 /* return codes */
 #define XFS_BTREE_QUERY_RANGE_CONTINUE	0	/* keep iterating */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0e2cf5f..de627fa 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2406,7 +2406,7 @@
 	uint		inodes;
 
 	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
-	mp->m_in_maxlevels = xfs_btree_compute_maxlevels(mp, mp->m_inobt_mnr,
+	mp->m_in_maxlevels = xfs_btree_compute_maxlevels(mp->m_inobt_mnr,
 							 inodes);
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index a2dd7f4..367e9a0 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -556,7 +556,7 @@ struct xfs_btree_cur *				/* new inode btree cursor */
 	if (mp->m_inobt_mxr[0] == 0)
 		return 0;
 
-	return xfs_btree_calc_size(mp, mp->m_inobt_mnr,
+	return xfs_btree_calc_size(mp->m_inobt_mnr,
 		(uint64_t)mp->m_sb.sb_agblocks * mp->m_sb.sb_inopblock /
 				XFS_INODES_PER_CHUNK);
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index bee68c2..560e284 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -351,7 +351,6 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 	struct xfs_refcount_irec	*center,
 	struct xfs_refcount_irec	*right,
 	unsigned long long		extlen,
-	xfs_agblock_t			*agbno,
 	xfs_extlen_t			*aglen)
 {
 	int				error;
@@ -471,7 +470,6 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 	struct xfs_btree_cur		*cur,
 	struct xfs_refcount_irec	*right,
 	struct xfs_refcount_irec	*cright,
-	xfs_agblock_t			*agbno,
 	xfs_extlen_t			*aglen)
 {
 	int				error;
@@ -749,7 +747,7 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 	    ulen < MAXREFCEXTLEN) {
 		*shape_changed = true;
 		return xfs_refcount_merge_center_extents(cur, &left, &cleft,
-				&right, ulen, agbno, aglen);
+				&right, ulen, aglen);
 	}
 
 	/* Try to merge left and cleft. */
@@ -778,7 +776,7 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 	    ulen < MAXREFCEXTLEN) {
 		*shape_changed = true;
 		return xfs_refcount_merge_right_extent(cur, &right, &cright,
-				agbno, aglen);
+				aglen);
 	}
 
 	return error;
@@ -1356,9 +1354,7 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen,
-	enum xfs_refc_adjust_op	adj,
-	struct xfs_defer_ops	*dfops,
-	struct xfs_owner_info	*oinfo)
+	enum xfs_refc_adjust_op	adj)
 {
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
@@ -1437,8 +1433,7 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen,
-	enum xfs_refc_adjust_op	adj,
-	struct xfs_defer_ops	*dfops)
+	enum xfs_refc_adjust_op	adj)
 {
 	bool			shape_changed;
 	int			error;
@@ -1465,8 +1460,7 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 		goto out_error;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
-	error = xfs_refcount_adjust_cow_extents(cur, agbno, aglen, adj,
-			dfops, NULL);
+	error = xfs_refcount_adjust_cow_extents(cur, agbno, aglen, adj);
 	if (error)
 		goto out_error;
 
@@ -1493,7 +1487,7 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 
 	/* Add refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
-			XFS_REFCOUNT_ADJUST_COW_ALLOC, dfops);
+			XFS_REFCOUNT_ADJUST_COW_ALLOC);
 }
 
 /*
@@ -1511,7 +1505,7 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 
 	/* Remove refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
-			XFS_REFCOUNT_ADJUST_COW_FREE, dfops);
+			XFS_REFCOUNT_ADJUST_COW_FREE);
 }
 
 /* Record a CoW staging extent in the refcount btree. */
@@ -1568,7 +1562,7 @@ struct xfs_refcount_recovery {
 /* Stuff an extent on the recovery list. */
 STATIC int
 xfs_refcount_recover_extent(
-	struct xfs_btree_cur		*cur,
+	struct xfs_btree_cur 		*cur,
 	union xfs_btree_rec		*rec,
 	void				*priv)
 {
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 265fdce..375abfe 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -373,7 +373,6 @@ struct xfs_btree_cur *
  */
 int
 xfs_refcountbt_maxrecs(
-	struct xfs_mount	*mp,
 	int			blocklen,
 	bool			leaf)
 {
@@ -390,7 +389,7 @@ struct xfs_btree_cur *
 xfs_refcountbt_compute_maxlevels(
 	struct xfs_mount		*mp)
 {
-	mp->m_refc_maxlevels = xfs_btree_compute_maxlevels(mp,
+	mp->m_refc_maxlevels = xfs_btree_compute_maxlevels(
 			mp->m_refc_mnr, mp->m_sb.sb_agblocks);
 }
 
@@ -400,7 +399,7 @@ struct xfs_btree_cur *
 	struct xfs_mount	*mp,
 	unsigned long long	len)
 {
-	return xfs_btree_calc_size(mp, mp->m_refc_mnr, len);
+	return xfs_btree_calc_size(mp->m_refc_mnr, len);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index 9db008b..2bc4694 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -60,8 +60,7 @@
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_agnumber_t agno,
 		struct xfs_defer_ops *dfops);
-extern int xfs_refcountbt_maxrecs(struct xfs_mount *mp, int blocklen,
-		bool leaf);
+extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 79822cf..fba8d27 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -376,7 +376,6 @@ struct xfs_find_left_neighbor_info {
 	struct xfs_mount	*mp,
 	uint64_t		ltoff,
 	struct xfs_rmap_irec	*rec,
-	xfs_fsblock_t		bno,
 	xfs_filblks_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
@@ -519,7 +518,7 @@ struct xfs_find_left_neighbor_info {
 			bno + len, out_error);
 
 	/* Check owner information. */
-	error = xfs_rmap_free_check_owner(mp, ltoff, &ltrec, bno, len, owner,
+	error = xfs_rmap_free_check_owner(mp, ltoff, &ltrec, len, owner,
 			offset, flags);
 	if (error)
 		goto out_error;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 8b0d0de..d756e0b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -499,7 +499,6 @@ struct xfs_btree_cur *
  */
 int
 xfs_rmapbt_maxrecs(
-	struct xfs_mount	*mp,
 	int			blocklen,
 	int			leaf)
 {
@@ -534,7 +533,7 @@ struct xfs_btree_cur *
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
 	else
-		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
+		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
 				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
 }
 
@@ -544,7 +543,7 @@ struct xfs_btree_cur *
 	struct xfs_mount	*mp,
 	unsigned long long	len)
 {
-	return xfs_btree_calc_size(mp, mp->m_rmap_mnr, len);
+	return xfs_btree_calc_size(mp->m_rmap_mnr, len);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 19c08e9..d68d96e 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -55,7 +55,7 @@
 struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_buf *bp,
 				xfs_agnumber_t agno);
-int xfs_rmapbt_maxrecs(struct xfs_mount *mp, int blocklen, int leaf);
+int xfs_rmapbt_maxrecs(int blocklen, int leaf);
 extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 53433cc..d9b94bd 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -756,15 +756,13 @@ struct xfs_perag *
 	mp->m_bmap_dmnr[0] = mp->m_bmap_dmxr[0] / 2;
 	mp->m_bmap_dmnr[1] = mp->m_bmap_dmxr[1] / 2;
 
-	mp->m_rmap_mxr[0] = xfs_rmapbt_maxrecs(mp, sbp->sb_blocksize, 1);
-	mp->m_rmap_mxr[1] = xfs_rmapbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_rmap_mxr[0] = xfs_rmapbt_maxrecs(sbp->sb_blocksize, 1);
+	mp->m_rmap_mxr[1] = xfs_rmapbt_maxrecs(sbp->sb_blocksize, 0);
 	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
 	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
 
-	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize,
-			true);
-	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize,
-			false);
+	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(sbp->sb_blocksize, true);
+	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(sbp->sb_blocksize, false);
 	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
 	mp->m_refc_mnr[1] = mp->m_refc_mxr[1] / 2;
 
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5f17641..3bccdf7 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -734,8 +734,7 @@
  *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
  */
 STATIC uint
-xfs_calc_qm_setqlim_reservation(
-	struct xfs_mount	*mp)
+xfs_calc_qm_setqlim_reservation(void)
 {
 	return xfs_calc_buf_res(1, sizeof(struct xfs_disk_dquot));
 }
@@ -772,8 +771,7 @@
  *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
  */
 STATIC uint
-xfs_calc_qm_quotaoff_end_reservation(
-	struct xfs_mount	*mp)
+xfs_calc_qm_quotaoff_end_reservation(void)
 {
 	return sizeof(struct xfs_qoff_logitem) * 2;
 }
@@ -877,14 +875,14 @@
 	 * The following transactions are logged in logical format with
 	 * a default log count.
 	 */
-	resp->tr_qm_setqlim.tr_logres = xfs_calc_qm_setqlim_reservation(mp);
+	resp->tr_qm_setqlim.tr_logres = xfs_calc_qm_setqlim_reservation();
 	resp->tr_qm_setqlim.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
 	resp->tr_qm_quotaoff.tr_logres = xfs_calc_qm_quotaoff_reservation(mp);
 	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
 	resp->tr_qm_equotaoff.tr_logres =
-		xfs_calc_qm_quotaoff_end_reservation(mp);
+		xfs_calc_qm_quotaoff_end_reservation();
 	resp->tr_qm_equotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
 	resp->tr_sb.tr_logres = xfs_calc_sb_reservation(mp);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 05dee8f..8cd8c41 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1326,7 +1326,6 @@
 	int			error;
 	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t		first_block;
-	xfs_fileoff_t		stop_fsb = XFS_B_TO_FSB(mp, VFS_I(ip)->i_size);
 	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
 	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
 	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
@@ -1361,7 +1360,7 @@
 
 		xfs_defer_init(&dfops, &first_block);
 		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
-				&done, stop_fsb, &first_block, &dfops);
+				&done, &first_block, &dfops);
 		if (error)
 			goto out_bmap_cancel;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ac669a1..55661cb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1754,7 +1754,6 @@ struct xfs_buf *
 
 void
 xfs_free_buftarg(
-	struct xfs_mount	*mp,
 	struct xfs_buftarg	*btp)
 {
 	unregister_shrinker(&btp->bt_shrinker);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 2f4c914..edced16 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -388,7 +388,7 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
  */
 extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
 			struct block_device *, struct dax_device *);
-extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
+extern void xfs_free_buftarg(struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
 
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 043ca380..7036083 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -198,7 +198,7 @@ enum xfs_fstrm_alloc {
 			goto next_ag;
 		}
 
-		longest = xfs_alloc_longest_free_extent(mp, pag,
+		longest = xfs_alloc_longest_free_extent(pag,
 				xfs_alloc_min_freelist(mp, pag),
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 		if (((minlen && longest >= minlen) ||
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3e3aab3..35d3785 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1309,7 +1309,6 @@
 int
 xfs_create_tmpfile(
 	struct xfs_inode	*dp,
-	struct dentry		*dentry,
 	umode_t			mode,
 	struct xfs_inode	**ipp)
 {
@@ -2903,7 +2902,7 @@
 	struct xfs_inode	*tmpfile;
 	int			error;
 
-	error = xfs_create_tmpfile(dp, NULL, S_IFCHR | WHITEOUT_MODE, &tmpfile);
+	error = xfs_create_tmpfile(dp, S_IFCHR | WHITEOUT_MODE, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 132d8aa..f16c0e8 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -393,8 +393,8 @@ int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct xfs_inode *dp, struct xfs_name *name,
 			   umode_t mode, dev_t rdev, struct xfs_inode **ipp);
-int		xfs_create_tmpfile(struct xfs_inode *dp, struct dentry *dentry,
-			   umode_t mode, struct xfs_inode **ipp);
+int		xfs_create_tmpfile(struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
 int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e0307fb..c45acf0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -177,7 +177,7 @@
 	if (!tmpfile) {
 		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
 	} else {
-		error = xfs_create_tmpfile(XFS_I(dir), dentry, mode, &ip);
+		error = xfs_create_tmpfile(XFS_I(dir), mode, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b9c9c84..2fcd9ed 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -560,7 +560,6 @@
  */
 int
 xfs_log_notify(
-	struct xfs_mount	*mp,
 	struct xlog_in_core	*iclog,
 	xfs_log_callback_t	*cb)
 {
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 7e2d629..fa8ad31 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -141,8 +141,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	  xfs_log_space_wake(struct xfs_mount *mp);
-int	  xfs_log_notify(struct xfs_mount	*mp,
-			 struct xlog_in_core	*iclog,
+int	  xfs_log_notify(struct xlog_in_core	*iclog,
 			 struct xfs_log_callback *callback_entry);
 int	  xfs_log_release_iclog(struct xfs_mount *mp,
 			 struct xlog_in_core	 *iclog);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index cb376ac..4668403 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -848,7 +848,7 @@
 	/* attach all the transactions w/ busy extents to iclog */
 	ctx->log_cb.cb_func = xlog_cil_committed;
 	ctx->log_cb.cb_arg = ctx;
-	error = xfs_log_notify(log->l_mp, commit_iclog, &ctx->log_cb);
+	error = xfs_log_notify(commit_iclog, &ctx->log_cb);
 	if (error)
 		goto out_abort;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 612c1d5..d714240 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -722,7 +722,7 @@ struct proc_xfs_info {
 		struct block_device *logdev = mp->m_logdev_targp->bt_bdev;
 		struct dax_device *dax_logdev = mp->m_logdev_targp->bt_daxdev;
 
-		xfs_free_buftarg(mp, mp->m_logdev_targp);
+		xfs_free_buftarg(mp->m_logdev_targp);
 		xfs_blkdev_put(logdev);
 		fs_put_dax(dax_logdev);
 	}
@@ -730,11 +730,11 @@ struct proc_xfs_info {
 		struct block_device *rtdev = mp->m_rtdev_targp->bt_bdev;
 		struct dax_device *dax_rtdev = mp->m_rtdev_targp->bt_daxdev;
 
-		xfs_free_buftarg(mp, mp->m_rtdev_targp);
+		xfs_free_buftarg(mp->m_rtdev_targp);
 		xfs_blkdev_put(rtdev);
 		fs_put_dax(dax_rtdev);
 	}
-	xfs_free_buftarg(mp, mp->m_ddev_targp);
+	xfs_free_buftarg(mp->m_ddev_targp);
 	fs_put_dax(dax_ddev);
 }
 
@@ -808,9 +808,9 @@ struct proc_xfs_info {
 
  out_free_rtdev_targ:
 	if (mp->m_rtdev_targp)
-		xfs_free_buftarg(mp, mp->m_rtdev_targp);
+		xfs_free_buftarg(mp->m_rtdev_targp);
  out_free_ddev_targ:
-	xfs_free_buftarg(mp, mp->m_ddev_targp);
+	xfs_free_buftarg(mp->m_ddev_targp);
  out_close_rtdev:
 	xfs_blkdev_put(rtdev);
 	fs_put_dax(dax_rtdev);
@@ -1247,7 +1247,6 @@ struct proc_xfs_info {
 STATIC int
 xfs_test_remount_options(
 	struct super_block	*sb,
-	struct xfs_mount	*mp,
 	char			*options)
 {
 	int			error = 0;
@@ -1278,7 +1277,7 @@ struct proc_xfs_info {
 	int			error;
 
 	/* First, check for complete junk; i.e. invalid options */
-	error = xfs_test_remount_options(sb, mp, options);
+	error = xfs_test_remount_options(sb, options);
 	if (error)
 		return error;
 


