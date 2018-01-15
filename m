Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbeAOULD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jan 2018 15:11:03 -0500
Date: Mon, 15 Jan 2018 12:05:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 4/5] xfs: attr leaf verifier needs to check for obviously
 bad count
Message-ID: <20180115200527.GE5602@magnolia>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579466415.8694.4992590880368427655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151579466415.8694.4992590880368427655.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

In the attribute leaf verifier, we can check for obviously bad values of
firstused and count so that later attempts at lasthash don't run off the
end of the memory buffer.  Found by ones fuzzing hdr.count in xfs/400 with
KASAN.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: strengthen checking, clarify what we're testing via comments
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6fddce7..f1a1c60 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -249,12 +249,13 @@ xfs_attr3_leaf_hdr_to_disk(
 
 static xfs_failaddr_t
 xfs_attr3_leaf_verify(
-	struct xfs_buf		*bp)
+	struct xfs_buf			*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_attr_leafblock *leaf = bp->b_addr;
-	struct xfs_perag *pag = bp->b_pag;
-	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = bp->b_target->bt_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_perag		*pag = bp->b_pag;
+	struct xfs_attr_leaf_entry	*entries;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
@@ -282,6 +283,21 @@ xfs_attr3_leaf_verify(
 	if (pag && pag->pagf_init && ichdr.count == 0)
 		return __this_address;
 
+	/*
+	 * firstused is the block offset of the first name info structure.
+	 * Make sure it doesn't go off the block or crash into the header.
+	 */
+	if (ichdr.firstused > mp->m_attr_geo->blksize)
+		return __this_address;
+	if (ichdr.firstused < xfs_attr3_leaf_hdr_size(leaf))
+		return __this_address;
+
+	/* Make sure the entries array doesn't crash into the name info. */
+	entries = xfs_attr3_leaf_entryp(bp->b_addr);
+	if ((char *)&entries[ichdr.count] >=
+	    (char *)bp->b_addr + ichdr.firstused)
+		return __this_address;
+
 	/* XXX: need to range check rest of attr header values */
 	/* XXX: hash order check? */
 
