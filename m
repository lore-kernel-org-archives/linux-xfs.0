Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D0C708069
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:45:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95986304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:27 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id NC2f6O7egEhC1Fb3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:24 -0700 (PDT)
Subject: [PATCH 18/20] xfs: scrub the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:45:20 -0700
Message-ID: <147216872000.3688.2076878295318596902.stgit@birch.djwong.org>
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

Check the realtime reverse mapping btree against the rtbitmap, and
modify the rtbitmap scrub to check against the rtrmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    3 +
 fs/xfs/xfs_scrub.c     |  103 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 90 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index f273e76..d1accde 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -551,7 +551,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTC	13	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_RTBITMAP	14	/* realtime bitmap */
 #define XFS_SCRUB_TYPE_RTSUM	15	/* realtime summary */
-#define XFS_SCRUB_TYPE_MAX	15
+#define XFS_SCRUB_TYPE_RTRMAPBT	16	/* realtime reverse mapping btree */
+#define XFS_SCRUB_TYPE_MAX	16
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 590bef8..f1f4a2f 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -42,6 +42,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
 #include "xfs_rtalloc.h"
 #include "xfs_icache.h"
 #include "xfs_itable.h"
@@ -128,6 +129,7 @@ static const char * const btree_types[] = {
 	[XFS_BTNUM_BNO]		= "bnobt",
 	[XFS_BTNUM_CNT]		= "cntbt",
 	[XFS_BTNUM_RMAP]	= "rmapbt",
+	[XFS_BTNUM_RTRMAP]	= "rtrmapbt",
 	[XFS_BTNUM_BMAP]	= "bmapbt",
 	[XFS_BTNUM_INO]		= "inobt",
 	[XFS_BTNUM_FINO]	= "finobt",
@@ -925,6 +927,7 @@ xfs_scrub_sb(
         XFS_SCRUB_SB_FEAT(rmapbt);
         XFS_SCRUB_SB_FEAT(reflink);
         XFS_SCRUB_SB_FEAT(realtime);
+        XFS_SCRUB_SB_FEAT(rtrmapbt);
 #undef XFS_SCRUB_SB_FEAT
 
 	if (error)
@@ -1912,12 +1915,12 @@ xfs_scrub_rmapbt(
 
 /* Reference count btree scrubber. */
 
-struct xfs_refcountbt_scrub_fragment {
+struct xfs_scrub_refcountbt_fragment {
 	struct xfs_rmap_irec		rm;
 	struct list_head		list;
 };
 
-struct xfs_refcountbt_scrub_rmap_check_info {
+struct xfs_scrub_refcountbt_rmap_check_info {
 	struct xfs_scrub_btree		*bs;
 	xfs_nlink_t			nr;
 	struct xfs_refcount_irec	rc;
@@ -1932,13 +1935,13 @@ struct xfs_refcountbt_scrub_rmap_check_info {
  * fragments as the refcountbt says we should have.
  */
 STATIC int
-xfs_refcountbt_scrub_rmap_check(
+xfs_scrub_refcountbt_rmap_check(
 	struct xfs_btree_cur		*cur,
 	struct xfs_rmap_irec		*rec,
 	void				*priv)
 {
-	struct xfs_refcountbt_scrub_rmap_check_info	*rsrci = priv;
-	struct xfs_refcountbt_scrub_fragment		*frag;
+	struct xfs_scrub_refcountbt_rmap_check_info	*rsrci = priv;
+	struct xfs_scrub_refcountbt_fragment		*frag;
 	xfs_agblock_t			rm_last;
 	xfs_agblock_t			rc_last;
 
@@ -1949,7 +1952,7 @@ xfs_refcountbt_scrub_rmap_check(
 	if (rec->rm_startblock <= rsrci->rc.rc_startblock && rm_last >= rc_last)
 		rsrci->nr++;
 	else {
-		frag = kmem_zalloc(sizeof(struct xfs_refcountbt_scrub_fragment),
+		frag = kmem_zalloc(sizeof(struct xfs_scrub_refcountbt_fragment),
 				KM_SLEEP);
 		frag->rm = *rec;
 		list_add_tail(&frag->list, &rsrci->fragments);
@@ -1968,11 +1971,11 @@ xfs_refcountbt_scrub_rmap_check(
 STATIC void
 xfs_refcountbt_process_rmap_fragments(
 	struct xfs_mount				*mp,
-	struct xfs_refcountbt_scrub_rmap_check_info	*rsrci)
+	struct xfs_scrub_refcountbt_rmap_check_info	*rsrci)
 {
 	struct list_head				worklist;
-	struct xfs_refcountbt_scrub_fragment		*cur;
-	struct xfs_refcountbt_scrub_fragment		*n;
+	struct xfs_scrub_refcountbt_fragment		*cur;
+	struct xfs_scrub_refcountbt_fragment		*n;
 	xfs_agblock_t					bno;
 	xfs_agblock_t					rbno;
 	xfs_agblock_t					next_rbno;
@@ -2059,13 +2062,13 @@ fail:
 	/* Delete fragments and work list. */
 	while (!list_empty(&worklist)) {
 		cur = list_first_entry(&worklist,
-				struct xfs_refcountbt_scrub_fragment, list);
+				struct xfs_scrub_refcountbt_fragment, list);
 		list_del(&cur->list);
 		kmem_free(cur);
 	}
 	while (!list_empty(&rsrci->fragments)) {
 		cur = list_first_entry(&rsrci->fragments,
-				struct xfs_refcountbt_scrub_fragment, list);
+				struct xfs_scrub_refcountbt_fragment, list);
 		list_del(&cur->list);
 		kmem_free(cur);
 	}
@@ -2082,8 +2085,8 @@ xfs_scrub_refcountbt_helper(
 	struct xfs_refcount_irec	irec;
 	struct xfs_rmap_irec		low;
 	struct xfs_rmap_irec		high;
-	struct xfs_refcountbt_scrub_rmap_check_info	rsrci;
-	struct xfs_refcountbt_scrub_fragment		*cur;
+	struct xfs_scrub_refcountbt_rmap_check_info	rsrci;
+	struct xfs_scrub_refcountbt_fragment		*cur;
 	xfs_agblock_t			eoag;
 	bool				is_freesp;
 	bool				has_inodes;
@@ -2144,7 +2147,7 @@ xfs_scrub_refcountbt_helper(
 		rsrci.rc = irec;
 		INIT_LIST_HEAD(&rsrci.fragments);
 		err2 = xfs_rmap_query_range(bs->rmap_cur, &low, &high,
-				&xfs_refcountbt_scrub_rmap_check, &rsrci);
+				&xfs_scrub_refcountbt_rmap_check, &rsrci);
 		if (err2 == 0) {
 			xfs_refcountbt_process_rmap_fragments(mp, &rsrci);
 			XFS_BTREC_SCRUB_CHECK(bs, irec.rc_refcount == rsrci.nr);
@@ -2152,7 +2155,7 @@ xfs_scrub_refcountbt_helper(
 
 		while (!list_empty(&rsrci.fragments)) {
 			cur = list_first_entry(&rsrci.fragments,
-					struct xfs_refcountbt_scrub_fragment,
+					struct xfs_scrub_refcountbt_fragment,
 					list);
 			list_del(&cur->list);
 			kmem_free(cur);
@@ -2646,6 +2649,7 @@ xfs_scrub_bmap(
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_RMAP:
 		/* No mappings to check. */
 		goto out_unlock;
 	case XFS_DINODE_FMT_EXTENTS:
@@ -2831,6 +2835,74 @@ xfs_scrub_rtsummary(
 	return -ENOENT;
 }
 
+/* Realtime reverse mapping. */
+
+/* Scrub a realtime rmapbt record. */
+STATIC int
+xfs_scrub_rtrmapbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_rmap_irec		irec;
+	bool				non_inode;
+	bool				is_bmbt;
+	bool				is_attr;
+	int				error;
+
+	error = xfs_rmap_btrec_to_irec(bs->cur, rec, &irec);
+	if (error)
+		return error;
+
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock < mp->m_sb.sb_rblocks)
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock < irec.rm_startblock +
+			irec.rm_blockcount);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock + irec.rm_blockcount <=
+			mp->m_sb.sb_rblocks)
+
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
+	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
+
+	XFS_BTREC_SCRUB_CHECK(bs, !is_bmbt);
+	XFS_BTREC_SCRUB_CHECK(bs, !non_inode);
+	XFS_BTREC_SCRUB_CHECK(bs, !is_attr);
+
+	return error;
+}
+
+/* Scrub the realtime rmap btree. */
+STATIC int
+xfs_scrub_rtrmapbt(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_scrub_btree		bs;
+	int				error;
+
+	if (sm->control || sm->flags)
+		return -EINVAL;
+
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	xfs_ilock(mp->m_rrmapip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+
+	bs.cur = xfs_rtrmapbt_init_cursor(mp, NULL, mp->m_rrmapip);
+	bs.scrub_rec = xfs_scrub_rtrmapbt_helper;
+	xfs_rmap_ino_bmbt_owner(&bs.oinfo, mp->m_sb.sb_rrmapino, XFS_DATA_FORK);
+	error = xfs_scrub_btree(&bs);
+	xfs_btree_del_cursor(bs.cur,
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
+	xfs_iunlock(mp->m_rrmapip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+
+	if (!error && bs.error)
+		error = bs.error;
+
+	return error;
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -2855,6 +2927,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_bmap_cow,	NULL},
 	{xfs_scrub_rtbitmap,	xfs_sb_version_hasrealtime},
 	{xfs_scrub_rtsummary,	xfs_sb_version_hasrealtime},
+	{xfs_scrub_rtrmapbt,	xfs_sb_version_hasrtrmapbt},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
