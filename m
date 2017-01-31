Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40047 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752915AbdAaAXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2017 19:23:43 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0V0Ng3x017674
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v0V0Ng6m011042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:42 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v0V0NgXT002122
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:42 GMT
Subject: [PATCH 5/7] xfs: verify free block header fields
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 30 Jan 2017 16:23:40 -0800
Message-ID: <148582222091.12293.17492997585015211348.stgit@birch.djwong.org>
In-Reply-To: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Perform basic sanity checking of the directory free block header
fields so that we avoid hanging the system on invalid data.

(Granted that just means that now we shutdown on directory write,
but that seems better than hanging...)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |   51 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 75a5574..fd17228 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -155,6 +155,42 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 	.verify_write = xfs_dir3_free_write_verify,
 };
 
+/* Everything ok in the free block header? */
+static bool
+xfs_dir3_free_header_check(
+	struct xfs_inode	*dp,
+	xfs_dablk_t		fbno,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	unsigned int		firstdb;
+	int			maxbests;
+
+	maxbests = dp->d_ops->free_max_bests(mp->m_dir_geo);
+	firstdb = (xfs_dir2_da_to_db(mp->m_dir_geo, fbno) -
+		   xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET)) *
+			maxbests;
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
+
+		if (be32_to_cpu(hdr3->firstdb) != firstdb)
+			return false;
+		if (be32_to_cpu(hdr3->nvalid) > maxbests)
+			return false;
+		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
+			return false;
+	} else {
+		struct xfs_dir2_free_hdr *hdr = bp->b_addr;
+
+		if (be32_to_cpu(hdr->firstdb) != firstdb)
+			return false;
+		if (be32_to_cpu(hdr->nvalid) > maxbests)
+			return false;
+		if (be32_to_cpu(hdr->nvalid) < be32_to_cpu(hdr->nused))
+			return false;
+	}
+	return true;
+}
 
 static int
 __xfs_dir3_free_read(
@@ -168,11 +204,22 @@ __xfs_dir3_free_read(
 
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_free_buf_ops);
+	if (err || !(*bpp))
+		return err;
+
+	/* Check things that we can't do in the verifier. */
+	if (!xfs_dir3_free_header_check(dp, fbno, *bpp)) {
+		xfs_buf_ioerror(*bpp, -EFSCORRUPTED);
+		xfs_verifier_error(*bpp);
+		xfs_trans_brelse(tp, *bpp);
+		return -EFSCORRUPTED;
+	}
 
 	/* try read returns without an error or *bpp if it lands in a hole */
-	if (!err && tp && *bpp)
+	if (tp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_FREE_BUF);
-	return err;
+
+	return 0;
 }
 
 int

