Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57893 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbdIQVHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/47] xfs: check _alloc_read_agf buffer pointer before using
Date: Sun, 17 Sep 2017 14:06:38 -0700
Message-Id: <20170917210712.10804-14-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 10479e2dea83d4c421ad05dfc55d918aa8dfc0cd upstream.

In some circumstances, _alloc_read_agf can return an error code of zero
but also a null AGF buffer pointer.  Check for this and jump out.

Fixes-coverity-id: 1415250
Fixes-coverity-id: 1415320
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 4 ++++
 fs/xfs/xfs_reflink.c         | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index e17016163542..d71cb63cdea3 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1640,6 +1640,10 @@ xfs_refcount_recover_cow_leftovers(
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		goto out_trans;
+	if (!agbp) {
+		error = -ENOMEM;
+		goto out_trans;
+	}
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 
 	/* Find all the leftover CoW staging extents. */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 350fc64441b1..0015c19c7455 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -169,6 +169,8 @@ xfs_reflink_find_shared(
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
 	if (error)
 		return error;
+	if (!agbp)
+		return -ENOMEM;
 
 	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
 
-- 
2.14.1

