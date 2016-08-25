Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 600517ED5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:40:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 32C678F8037
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:38 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id WsHstpAlZlwiD9jK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:36 -0700 (PDT)
Subject: [PATCH 03/25] xfs: have getfsmap fall back to the freesp btrees
	when rmap is not present
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:40:31 -0700
Message-ID: <147216843188.3108.6702587672062077831.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
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

If the reverse-mapping btree isn't available, fall back to the
free space btrees to provide partial reverse mapping information.
The online scrub tool can make use of even partial information to
speed up the data block scan.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   42 +++++++++++++
 fs/xfs/libxfs/xfs_alloc.h |   10 +++
 fs/xfs/xfs_fsmap.c        |  151 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 200 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6e81b27..8b3e6b3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2932,3 +2932,45 @@ err:
 	xfs_trans_brelse(tp, agbp);
 	return error;
 }
+
+struct xfs_alloc_query_range_info {
+	xfs_alloc_query_range_fn	fn;
+	void				*priv;
+};
+
+/* Format btree record and pass to our callback. */
+STATIC int
+xfs_alloc_query_range_helper(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_alloc_query_range_info	*query = priv;
+	struct xfs_alloc_rec_incore		irec;
+
+	irec.ar_startblock = be32_to_cpu(rec->alloc.ar_startblock);
+	irec.ar_blockcount = be32_to_cpu(rec->alloc.ar_blockcount);
+	return query->fn(cur, &irec, query->priv);
+}
+
+/* Find all rmaps between two keys. */
+int
+xfs_alloc_query_range(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*low_rec,
+	struct xfs_alloc_rec_incore	*high_rec,
+	xfs_alloc_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_irec		low_brec;
+	union xfs_btree_irec		high_brec;
+	struct xfs_alloc_query_range_info	query;
+
+	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
+	low_brec.a = *low_rec;
+	high_brec.a = *high_rec;
+	query.priv = priv;
+	query.fn = fn;
+	return xfs_btree_query_range(cur, &low_brec, &high_brec,
+			xfs_alloc_query_range_helper, &query);
+}
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index f7c5201..0b00de0 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -210,4 +210,14 @@ int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 
 xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
 
+typedef int (*xfs_alloc_query_range_fn)(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*rec,
+	void				*priv);
+
+int xfs_alloc_query_range(struct xfs_btree_cur *cur,
+		struct xfs_alloc_rec_incore *low_rec,
+		struct xfs_alloc_rec_incore *high_rec,
+		xfs_alloc_query_range_fn fn, void *priv);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 2eca7b9..eb54884 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -39,6 +39,7 @@
 #include "xfs_fsmap.h"
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_alloc_btree.h"
 
 /* getfsmap query state */
 struct xfs_getfsmap_info {
@@ -314,6 +315,32 @@ xfs_getfsmap_rtdev_helper(
 	return xfs_getfsmap_helper(mp, info, rec, rec_daddr);
 }
 
+/* Transform a bnobt irec into a fsmap */
+STATIC int
+xfs_getfsmap_datadev_bnobt_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_getfsmap_info	*info = priv;
+	struct xfs_rmap_irec		irec;
+	xfs_fsblock_t			fsb;
+	xfs_daddr_t			rec_daddr;
+
+	fsb = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+			rec->ar_startblock);
+	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
+
+	irec.rm_startblock = rec->ar_startblock;
+	irec.rm_blockcount = rec->ar_blockcount;
+	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
+	irec.rm_offset = 0;
+	irec.rm_flags = 0;
+
+	return xfs_getfsmap_helper(mp, info, &irec, rec_daddr);
+}
+
 /* Set rmap flags based on the getfsmap flags */
 static void
 xfs_getfsmap_set_irec_flags(
@@ -492,6 +519,123 @@ err:
 	return error;
 }
 
+/* Execute a getfsmap query against the regular data device's bnobt. */
+STATIC int
+xfs_getfsmap_datadev_bnobt(
+	struct xfs_mount		*mp,
+	struct getfsmap			*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_btree_cur		*bt_cur = NULL;
+	struct getfsmap			*lowkey;
+	struct getfsmap			*highkey;
+	struct xfs_alloc_rec_incore	alow;
+	struct xfs_alloc_rec_incore	ahigh;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	xfs_agnumber_t			start_ag;
+	xfs_agnumber_t			end_ag;
+	xfs_daddr_t			eofs;
+	int				error = 0;
+
+	lowkey = keys;
+	highkey = keys + 1;
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (lowkey->fmv_block >= eofs)
+		return 0;
+	if (highkey->fmv_block >= eofs)
+		highkey->fmv_block = eofs - 1;
+	start_fsb = XFS_DADDR_TO_FSB(mp, lowkey->fmv_block);
+	end_fsb = XFS_DADDR_TO_FSB(mp, highkey->fmv_block);
+
+	/* Set up search keys */
+	info->low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, lowkey->fmv_offset);
+	info->low.rm_owner = lowkey->fmv_owner;
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, lowkey);
+
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+
+	info->missing_owner = FMV_OWN_UNKNOWN;
+
+	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
+	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
+
+	/* Query each AG */
+	for (info->agno = start_ag; info->agno <= end_ag; info->agno++) {
+		if (info->agno == end_ag) {
+			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
+					end_fsb);
+			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
+					highkey->fmv_offset);
+			info->high.rm_owner = highkey->fmv_owner;
+			xfs_getfsmap_set_irec_flags(&info->high, highkey);
+		}
+
+		if (bt_cur) {
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			xfs_buf_relse(info->agbp);
+			bt_cur = NULL;
+			info->agbp = NULL;
+		}
+
+		error = xfs_alloc_read_agf(mp, NULL, info->agno, 0,
+				&info->agbp);
+		if (error)
+			goto err;
+
+		trace_xfs_fsmap_low_key(mp, info->dev, info->agno,
+				info->low.rm_startblock,
+				info->low.rm_blockcount,
+				info->low.rm_owner,
+				info->low.rm_offset);
+
+		trace_xfs_fsmap_high_key(mp, info->dev, info->agno,
+				info->high.rm_startblock,
+				info->high.rm_blockcount,
+				info->high.rm_owner,
+				info->high.rm_offset);
+
+		bt_cur = xfs_allocbt_init_cursor(mp, NULL, info->agbp,
+				info->agno, XFS_BTNUM_BNO);
+		alow.ar_startblock = info->low.rm_startblock;
+		ahigh.ar_startblock = info->high.rm_startblock;
+		error = xfs_alloc_query_range(bt_cur, &alow, &ahigh,
+				xfs_getfsmap_datadev_bnobt_helper, info);
+		if (error)
+			goto err;
+
+		if (info->agno == start_ag) {
+			info->low.rm_startblock = 0;
+			info->low.rm_owner = 0;
+			info->low.rm_offset = 0;
+			info->low.rm_flags = 0;
+		}
+	}
+
+	/* Report any free space at the end of the AG */
+	info->last = true;
+	error = xfs_getfsmap_datadev_bnobt_helper(bt_cur, &ahigh, info);
+	if (error)
+		goto err;
+
+err:
+	if (bt_cur)
+		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+							 XFS_BTREE_NOERROR);
+	if (info->agbp) {
+		xfs_buf_relse(info->agbp);
+		info->agbp = NULL;
+	}
+
+	return error;
+}
+
 /* Do we recognize the device? */
 STATIC bool
 xfs_getfsmap_is_valid_device(
@@ -529,8 +673,6 @@ xfs_getfsmap(
 	int				i;
 	int				error = 0;
 
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
-		return -EOPNOTSUPP;
 	if (fmv_low->fmv_count < 2)
 		return -EINVAL;
 	if (fmv_low->fmv_iflags & (~FMV_HIF_VALID))
@@ -549,7 +691,10 @@ xfs_getfsmap(
 	/* Set up our device handlers. */
 	memset(handlers, 0, sizeof(handlers));
 	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
-	handlers[0].fn = xfs_getfsmap_datadev;
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		handlers[0].fn = xfs_getfsmap_datadev;
+	else
+		handlers[0].fn = xfs_getfsmap_datadev_bnobt;
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
 		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
 		handlers[1].fn = xfs_getfsmap_logdev;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
