Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48164 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753244AbeDRCr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:47:29 -0400
Subject: [PATCH 06/11] xfs_repair: invalidate dirty dir buffers when we zap
 a directory
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:47:09 -0700
Message-ID: <152401962935.13319.6277644218474872245.stgit@magnolia>
In-Reply-To: <152401958920.13319.10756339531174871801.stgit@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we decide to rebuild a directory in phase 6, we need to find and
invalidate all of the old directory buffers so that they don't get
written out, which can trigger write verifier errors when we finish.
This fixes the write verifier errors in phase 7 that can occur via
xfs/382.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase6.c          |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 09f1428..3b36e0e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -100,6 +100,7 @@
 #define xfs_dir2_data_make_free		libxfs_dir2_data_make_free
 #define xfs_dir2_data_use_free		libxfs_dir2_data_use_free
 #define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
+#define xfs_da_get_buf			libxfs_da_get_buf
 
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_to_disk		libxfs_inode_to_disk
diff --git a/repair/phase6.c b/repair/phase6.c
index 498a3b5..2005e40 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1311,6 +1311,48 @@ entry_junked(
 	return !no_modify;
 }
 
+/* Find and invalidate all the directory's buffers. */
+static int
+dir_binval(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	rec;
+	struct xfs_ifork	*ifp;
+	struct xfs_da_geometry	*geo;
+	struct xfs_buf		*bp;
+	xfs_dablk_t		dabno, end_dabno;
+	int			error = 0;
+
+	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
+	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
+		return 0;
+
+	geo = tp->t_mountp->m_dir_geo;
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	for_each_xfs_iext(ifp, &icur, &rec) {
+		dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
+				geo->fsbcount - 1);
+		end_dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
+				rec.br_blockcount);
+		for (; dabno <= end_dabno; dabno += geo->fsbcount) {
+			bp = NULL;
+			error = -libxfs_da_get_buf(tp, ip, dabno, -2, &bp,
+					whichfork);
+			if (error)
+				return error;
+			if (!bp)
+				continue;
+			libxfs_trans_binval(tp, bp);
+			libxfs_trans_brelse(tp, bp);
+		}
+	}
+
+	return error;
+}
+
 /*
  * Unexpected failure during the rebuild will leave the entries in
  * lost+found on the next run
@@ -1361,6 +1403,10 @@ longform_dir2_rebuild(
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
 
+	error = dir_binval(tp, ip, XFS_DATA_FORK);
+	if (error)
+		res_failed(error);
+
 	if ((error = -libxfs_bmap_last_offset(ip, &lastblock, XFS_DATA_FORK)))
 		do_error(_("xfs_bmap_last_offset failed -- error - %d\n"),
 			error);

