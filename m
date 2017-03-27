Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43871 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbdC0IjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:39:14 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/26] xfs: verify free block header fields
Date: Mon, 27 Mar 2017 10:38:19 +0200
Message-Id: <20170327083837.11027-9-hch@lst.de>
In-Reply-To: <20170327083837.11027-1-hch@lst.de>
References: <20170327083837.11027-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit de14c5f541e78c59006bee56f6c5c2ef1ca07272 upstream.

Perform basic sanity checking of the directory free block header
fields so that we avoid hanging the system on invalid data.

(Granted that just means that now we shutdown on directory write,
but that seems better than hanging...)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 51 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 75a557432d0f..bbd1238852b3 100644
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
+	if (err || !*bpp)
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
-- 
2.11.0

