Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A001183DD
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:59:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0361EAC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:08 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id fzGP7c4YBFqJQpVf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:06 -0700 (PDT)
Subject: [PATCH 04/29] xfs: widen xfs_refcount_irec fields to handle
	realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:59:01 -0700
Message-ID: <147216954146.7022.15337347958538680244.stgit@birch.djwong.org>
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

Change the startblock and blockcount fields of xfs_refcount_irec to
be 64 bits wide.  This enables us to use the same high level rmap
code for either tree.  We'll also collect all the resulting breakage
fixes here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_format.h |    4 ++--
 libxfs/xfs_rmap.c   |   58 ++++++++++++++++++++++++++-------------------------
 libxfs/xfs_rmap.h   |   20 +++++++++---------
 repair/rmap.c       |   26 +++++++++++------------
 4 files changed, 54 insertions(+), 54 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index ed36809..c336f7a 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 62096cd..5f84f20 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -44,8 +44,8 @@
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
@@ -66,8 +66,8 @@ xfs_rmap_lookup_le(
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
@@ -113,8 +113,8 @@ xfs_rmap_update(
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
@@ -149,8 +149,8 @@ done:
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
@@ -250,7 +250,7 @@ xfs_rmap_find_left_neighbor_helper(
 int
 xfs_rmap_find_left_neighbor(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		bno,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -328,7 +328,7 @@ xfs_rmap_lookup_le_range_helper(
 int
 xfs_rmap_lookup_le_range(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		bno,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -385,8 +385,8 @@ xfs_rmap_lookup_le_range(
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
@@ -526,7 +526,7 @@ xfs_rmap_unmap(
 		 * Result:  |rrrrr|         |rrrr|
 		 *               bno       len
 		 */
-		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+		xfs_filblks_t	orig_len = ltrec.rm_blockcount;
 
 		ltrec.rm_blockcount = bno - ltrec.rm_startblock;
 		error = xfs_rmap_update(cur, &ltrec);
@@ -636,8 +636,8 @@ xfs_rmap_is_mergeable(
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
@@ -860,8 +860,8 @@ out_error:
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
@@ -1285,8 +1285,8 @@ done:
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
@@ -1672,8 +1672,8 @@ done:
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
@@ -1790,7 +1790,7 @@ xfs_rmap_unmap_shared(
 		 * Result:  |rrrrr|         |rrrr|
 		 *               bno       len
 		 */
-		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+		xfs_filblks_t	orig_len = ltrec.rm_blockcount;
 
 		/* Shrink the left side of the rmap */
 		error = xfs_rmap_lookup_eq(cur, ltrec.rm_startblock,
@@ -1834,8 +1834,8 @@ out_error:
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
@@ -2060,7 +2060,7 @@ xfs_rmap_finish_one(
 	int				error = 0;
 	xfs_agnumber_t			agno;
 	struct xfs_owner_info		oinfo;
-	xfs_agblock_t			bno;
+	xfs_fsblock_t			bno;
 	bool				unwritten;
 
 	agno = XFS_FSB_TO_AGNO(mp, startblock);
@@ -2249,8 +2249,8 @@ xfs_rmap_alloc_extent(
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
@@ -2273,8 +2273,8 @@ xfs_rmap_free_extent(
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
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index c5c5817..06f7e73 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
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
diff --git a/repair/rmap.c b/repair/rmap.c
index 597655b..3b3a195 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1025,12 +1025,12 @@ rmaps_verify_btree(
 		}
 		if (!have) {
 			do_warn(
-_("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \
+_("Missing reverse-mapping record for (%u/%llu) %slen %llu owner %"PRId64" \
 %s%soff %"PRIu64"\n"),
-				agno, rm_rec->rm_startblock,
+				agno, (unsigned long long)rm_rec->rm_startblock,
 				(rm_rec->rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
-				rm_rec->rm_blockcount,
+				(unsigned long long)rm_rec->rm_blockcount,
 				rm_rec->rm_owner,
 				(rm_rec->rm_flags & XFS_RMAP_ATTR_FORK) ?
 					_("attr ") : "",
@@ -1043,22 +1043,22 @@ _("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \
 		/* Compare each refcount observation against the btree's */
 		if (!rmap_is_good(rm_rec, &tmp)) {
 			do_warn(
-_("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
-%"PRIu64"; should be (%u/%u) %slen %u owner %"PRId64" %s%soff %"PRIu64"\n"),
-				agno, tmp.rm_startblock,
+_("Incorrect reverse-mapping: saw (%u/%llu) %slen %llu owner %"PRId64" %s%soff \
+%"PRIu64"; should be (%u/%llu) %slen %llu owner %"PRId64" %s%soff %"PRIu64"\n"),
+				agno, (unsigned long long)tmp.rm_startblock,
 				(tmp.rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
-				tmp.rm_blockcount,
+				(unsigned long long)tmp.rm_blockcount,
 				tmp.rm_owner,
 				(tmp.rm_flags & XFS_RMAP_ATTR_FORK) ?
 					_("attr ") : "",
 				(tmp.rm_flags & XFS_RMAP_BMBT_BLOCK) ?
 					_("bmbt ") : "",
 				tmp.rm_offset,
-				agno, rm_rec->rm_startblock,
+				agno, (unsigned long long)rm_rec->rm_startblock,
 				(rm_rec->rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
-				rm_rec->rm_blockcount,
+				(unsigned long long)rm_rec->rm_blockcount,
 				rm_rec->rm_owner,
 				(rm_rec->rm_flags & XFS_RMAP_ATTR_FORK) ?
 					_("attr ") : "",
@@ -1091,7 +1091,6 @@ rmap_diffkeys(
 {
 	__u64			oa;
 	__u64			ob;
-	__int64_t		d;
 	struct xfs_rmap_irec	tmp;
 
 	tmp = *kp1;
@@ -1101,9 +1100,10 @@ rmap_diffkeys(
 	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
 	ob = libxfs_rmap_irec_offset_pack(&tmp);
 
-	d = (__int64_t)kp1->rm_startblock - kp2->rm_startblock;
-	if (d)
-		return d;
+	if (kp1->rm_startblock > kp2->rm_startblock)
+		return 1;
+	else if (kp2->rm_startblock > kp1->rm_startblock)
+		return -1;
 
 	if (kp1->rm_owner > kp2->rm_owner)
 		return 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
