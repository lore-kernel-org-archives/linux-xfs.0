Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfDDRLC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Apr 2019 13:11:02 -0400
Date: Thu, 4 Apr 2019 10:10:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 46/36] xfs_scrub: remove pointless xfs_verify_error_info
 struct
Message-ID: <20190404171056.GR5147@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320200444.GJ1183@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320200444.GJ1183@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The xfs_verify_error_info structure is a strict subset of
media_verify_info so just pass that around.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/scrub/phase6.c b/scrub/phase6.c
index 91e4443e..e819e085 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -111,11 +111,6 @@ xfs_decode_special_owner(
 
 /* Routines to translate bad physical extents into file paths and offsets. */
 
-struct xfs_verify_error_info {
-	struct bitmap			*d_bad;		/* bytes */
-	struct bitmap			*r_bad;		/* bytes */
-};
-
 /* Report if this extent overlaps a bad region. */
 static bool
 xfs_report_verify_inode_bmap(
@@ -127,7 +122,7 @@ xfs_report_verify_inode_bmap(
 	struct xfs_bmap			*bmap,
 	void				*arg)
 {
-	struct xfs_verify_error_info	*vei = arg;
+	struct media_verify_state	*vs = arg;
 	struct bitmap			*bmp;
 
 	/* Only report errors for real extents. */
@@ -135,9 +130,9 @@ xfs_report_verify_inode_bmap(
 		return true;
 
 	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
-		bmp = vei->r_bad;
+		bmp = vs->r_bad;
 	else
-		bmp = vei->d_bad;
+		bmp = vs->d_bad;
 
 	if (!bitmap_test(bmp, bmap->bm_physical, bmap->bm_length))
 		return true;
@@ -277,23 +272,18 @@ xfs_report_verify_dirent(
 static bool
 xfs_report_verify_errors(
 	struct scrub_ctx		*ctx,
-	struct bitmap			*d_bad,
-	struct bitmap			*r_bad)
+	struct media_verify_state	*ve)
 {
-	struct xfs_verify_error_info	vei;
 	bool				moveon;
 
-	vei.d_bad = d_bad;
-	vei.r_bad = r_bad;
-
 	/* Scan the directory tree to get file paths. */
 	moveon = scan_fs_tree(ctx, xfs_report_verify_dir,
-			xfs_report_verify_dirent, &vei);
+			xfs_report_verify_dirent, ve);
 	if (!moveon)
 		return false;
 
 	/* Scan for unlinked files. */
-	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, &vei);
+	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, ve);
 }
 
 /* Report an IO error resulting from read-verify based off getfsmap. */
@@ -518,7 +508,7 @@ _("Could not create data device media verifier."));
 
 	/* Scan the whole dir tree to see what matches the bad extents. */
 	if (!bitmap_empty(vs.d_bad) || !bitmap_empty(vs.r_bad))
-		moveon = xfs_report_verify_errors(ctx, vs.d_bad, vs.r_bad);
+		moveon = xfs_report_verify_errors(ctx, &vs);
 
 	bitmap_free(&vs.r_bad);
 	bitmap_free(&vs.d_bad);
