Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DABFE7F07
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:42:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F5B9304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1JpIekqy8XTTDRvV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:30 -0700 (PDT)
Subject: [PATCH 20/25] xfs: cross-reference extents with AG header
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:42:21 -0700
Message-ID: <147216854170.3108.4876331933510244657.stgit@birch.djwong.org>
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

Ensure that none of the AG btree records overlap the AG sb/agf/agfl/agi
headers except for the XFS_RMAP_OWN_FS rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_scrub.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)


diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 66365e2..63a7434 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -434,6 +434,30 @@ xfs_scrub_put_ag_headers(
 	*agi_bpp = *agf_bpp = NULL;
 }
 
+/* Does this AG extent cover the AG headers? */
+STATIC bool
+xfs_scrub_extent_covers_ag_head(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len)
+{
+	xfs_agblock_t		bno;
+
+	bno = XFS_SB_BLOCK(mp);
+	if (bno >= agbno && bno < agbno + len)
+		return true;
+	bno = XFS_AGF_BLOCK(mp);
+	if (bno >= agbno && bno < agbno + len)
+		return true;
+	bno = XFS_AGFL_BLOCK(mp);
+	if (bno >= agbno && bno < agbno + len)
+		return true;
+	bno = XFS_AGI_BLOCK(mp);
+	if (bno >= agbno && bno < agbno + len)
+		return true;
+	return false;
+}
+
 /*
  * For scrub, grab the AGI and the AGF headers, in that order.
  * Locking order requires us to get the AGI before the AGF.
@@ -1013,6 +1037,10 @@ xfs_scrub_agfl(
 		XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL",
 				agbno < eoag);
 
+		/* Cross-reference with the AG headers. */
+		XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL",
+				!xfs_scrub_extent_covers_ag_head(mp, agbno, 1));
+
 		/* Cross-reference with the bnobt. */
 		err2 = xfs_alloc_has_record(xcur, agbno, 1, &is_freesp);
 		if (!err2)
@@ -1117,6 +1145,10 @@ xfs_scrub_allocbt_helper(
 	XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
 			be32_to_cpu(agf->agf_length));
 
+	/* Make sure we don't cover the AG headers. */
+	XFS_BTREC_SCRUB_CHECK(bs,
+			!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 	/*
 	 * Ensure there's a corresponding cntbt/bnobt record matching
 	 * this bnobt/cntbt record, respectively.
@@ -1233,6 +1265,10 @@ xfs_scrub_iallocbt_helper(
 		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
 				eoag);
 
+		/* Make sure we don't cover the AG headers. */
+		XFS_BTREC_SCRUB_CHECK(bs,
+				!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 		/* Cross-reference with the bnobt. */
 		err2 = xfs_alloc_has_record(bs->bno_cur, bno, len,
 				&is_freesp);
@@ -1267,6 +1303,10 @@ xfs_scrub_iallocbt_helper(
 		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
 				eoag);
 
+		/* Make sure we don't cover the AG headers. */
+		XFS_BTREC_SCRUB_CHECK(bs,
+				!xfs_scrub_extent_covers_ag_head(mp, bno, len));
+
 		/* Cross-reference with the bnobt. */
 		err2 = xfs_alloc_has_record(bs->bno_cur, bno, len,
 				&is_freesp);
@@ -1378,6 +1418,11 @@ xfs_scrub_rmapbt_helper(
 	XFS_BTREC_SCRUB_CHECK(bs, !non_inode || !(is_bmbt || is_unwritten ||
 			is_attr));
 
+	/* Make sure only the AG header owner maps to the AG header. */
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_owner == XFS_RMAP_OWN_FS ||
+			!xfs_scrub_extent_covers_ag_head(mp, irec.rm_startblock,
+				irec.rm_blockcount));
+
 	/* check there's no record in freesp btrees */
 	err2 = xfs_alloc_has_record(bs->bno_cur, irec.rm_startblock,
 			irec.rm_blockcount, &is_freesp);
@@ -1452,6 +1497,10 @@ xfs_scrub_refcountbt_helper(
 			irec.rc_blockcount <= eoag);
 	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_refcount >= 1);
 
+	/* Make sure we don't cover the AG headers. */
+	XFS_BTREC_SCRUB_CHECK(bs, !xfs_scrub_extent_covers_ag_head(mp,
+			irec.rc_startblock, irec.rc_blockcount));
+
 	/* Cross-reference with the bnobt. */
 	err2 = xfs_alloc_has_record(bs->bno_cur, irec.rc_startblock,
 			irec.rc_blockcount, &is_freesp);
@@ -1639,6 +1688,11 @@ xfs_scrub_bmap_extent(
 		if (error)
 			goto out;
 
+		/* Make sure we don't cover the AG headers. */
+		XFS_INO_SCRUB_CHECK(ip, bp, info->type, info->is_rt ||
+				!xfs_scrub_extent_covers_ag_head(mp, bno,
+					irec->br_blockcount));
+
 		/* Cross-reference with the bnobt. */
 		xcur = xfs_allocbt_init_cursor(mp, NULL, agf_bp, agno,
 				XFS_BTNUM_BNO);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
