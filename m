Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938686AbdAIPkY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:24 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 27/32] xfs: ignore leaf attr ichdr.count in verifier during log replay
Date: Mon,  9 Jan 2017 16:38:58 +0100
Message-Id: <1483976343-661-28-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Eric Sandeen <sandeen@redhat.com>

commit 2e1d23370e75d7d89350d41b4ab58c7f6a0e26b2 upstream.

When we create a new attribute, we first create a shortform
attribute, and try to fit the new attribute into it.
If that fails, we copy the (empty) attribute into a leaf attribute,
and do the copy again.  Thus there can be a transient state where
we have an empty leaf attribute.

If we encounter this during log replay, the verifier will fail.
So add a test to ignore this part of the leaf attr verification
during log replay.

Thanks as usual to dchinner for spotting the problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8ea91f3..2852521 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -253,6 +253,7 @@ xfs_attr3_leaf_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_attr_leafblock *leaf = bp->b_addr;
+	struct xfs_perag *pag = bp->b_pag;
 	struct xfs_attr3_icleaf_hdr ichdr;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
@@ -273,7 +274,12 @@ xfs_attr3_leaf_verify(
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
 			return false;
 	}
-	if (ichdr.count == 0)
+	/*
+	 * In recovery there is a transient state where count == 0 is valid
+	 * because we may have transitioned an empty shortform attr to a leaf
+	 * if the attr didn't fit in shortform.
+	 */
+	if (pag && pag->pagf_init && ichdr.count == 0)
 		return false;
 
 	/* XXX: need to range check rest of attr header values */
-- 
2.1.4

