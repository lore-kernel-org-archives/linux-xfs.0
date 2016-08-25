Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37FE58084
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:45:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8DB9AAC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:43 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id AQROxnq6WKyN4i1Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:45:41 -0700 (PDT)
Subject: [PATCH 20/20] xfs: cross-reference the realtime rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:45:32 -0700
Message-ID: <147216873241.3688.11988964019948967528.stgit@birch.djwong.org>
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

When we're scrubbing the realtime metadata, cross-reference
the rtrmapt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_scrub.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index f0cd21f..61c99ea 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -2405,8 +2405,15 @@ xfs_scrub_bmap_extent(
 	}
 
 	/* Cross-reference with rmapbt. */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && !info->is_rt) {
-		xcur = xfs_rmapbt_init_cursor(mp, NULL, agf_bp, agno);
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		if (!info->is_rt)
+			xcur = xfs_rmapbt_init_cursor(mp, NULL, agf_bp, agno);
+		else {
+			xfs_ilock(mp->m_rrmapip, XFS_ILOCK_SHARED |
+						 XFS_ILOCK_RTBITMAP);
+			xcur = xfs_rtrmapbt_init_cursor(mp, NULL,
+					mp->m_rrmapip);
+		}
 
 		if (info->whichfork == XFS_COW_FORK) {
 			owner = XFS_RMAP_OWN_COW;
@@ -2495,6 +2502,9 @@ skip_rmap_xref:
 		/* Free cursor. */
 		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
 						  XFS_BTREE_NOERROR);
+		if (info->is_rt)
+			xfs_iunlock(mp->m_rrmapip, XFS_ILOCK_SHARED |
+						   XFS_ILOCK_RTBITMAP);
 	}
 
 	/*
@@ -2768,10 +2778,12 @@ xfs_scrub_rtbitmap(
 {
 	struct xfs_mount		*mp = ip->i_mount;
 	struct xfs_buf			*bp = NULL;
+	struct xfs_btree_cur		*cur = NULL;
 	xfs_rtblock_t			rtstart;
 	xfs_rtblock_t			rtend;
 	xfs_rtblock_t			block;
 	xfs_rtblock_t			rem;
+	bool				has_rmap;
 	int				is_free;
 	int				error = 0;
 	int				err2 = 0;
@@ -2780,6 +2792,10 @@ xfs_scrub_rtbitmap(
 		return -EINVAL;
 
 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		xfs_ilock(mp->m_rrmapip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+		cur = xfs_rtrmapbt_init_cursor(mp, NULL, mp->m_rrmapip);
+	}
 
 	/* Iterate the bitmap, looking for discrepancies. */
 	rtstart = 0;
@@ -2807,6 +2823,14 @@ xfs_scrub_rtbitmap(
 			break;
 		XFS_SCRUB_CHECK(mp, bp, "rtbitmap", rtend >= rtstart);
 
+		/* Cross-reference the rtrmapbt. */
+		if (cur && is_free) {
+			err2 = xfs_rmap_has_record(cur, rtstart,
+					rtend - rtstart + 1, &has_rmap);
+			if (!err2)
+				XFS_SCRUB_CHECK(mp, bp, "rtbitmap", !has_rmap);
+		}
+
 		xfs_buf_relse(bp);
 		bp = NULL;
 		rem -= rtend - rtstart + 1;
@@ -2816,6 +2840,11 @@ xfs_scrub_rtbitmap(
 out_unlock:
 	if (bp)
 		xfs_buf_relse(bp);
+	if (cur) {
+		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+		xfs_iunlock(mp->m_rrmapip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+	}
 	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	if (!error && err2)
 		error = err2;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
