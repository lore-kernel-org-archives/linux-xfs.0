Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731711AbeGSQJN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 12:09:13 -0400
Date: Thu, 19 Jul 2018 08:25:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 1/8] xfs: check leaf attribute block freemap in verifier
Message-ID: <20180719152516.GG4813@magnolia>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192903434.31685.282625226695514597.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192903434.31685.282625226695514597.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the leaf attribute freemap when we're verifying the block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
v2: add comments about alignment
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 76e90046731c..a673037c7d37 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -244,6 +244,8 @@ xfs_attr3_leaf_verify(
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_perag		*pag = bp->b_pag;
 	struct xfs_attr_leaf_entry	*entries;
+	uint16_t			end;
+	int				i;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
@@ -289,6 +291,26 @@ xfs_attr3_leaf_verify(
 	/* XXX: need to range check rest of attr header values */
 	/* XXX: hash order check? */
 
+	/*
+	 * Quickly check the freemap information.  Attribute data has to be
+	 * aligned to 4-byte boundaries, and likewise for the free space.
+	 */
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		if (ichdr.freemap[i].base > mp->m_attr_geo->blksize)
+			return __this_address;
+		if (ichdr.freemap[i].base & 0x3)
+			return __this_address;
+		if (ichdr.freemap[i].size > mp->m_attr_geo->blksize)
+			return __this_address;
+		if (ichdr.freemap[i].size & 0x3)
+			return __this_address;
+		end = ichdr.freemap[i].base + ichdr.freemap[i].size;
+		if (end < ichdr.freemap[i].base)
+			return __this_address;
+		if (end > mp->m_attr_geo->blksize)
+			return __this_address;
+	}
+
 	return NULL;
 }
 
