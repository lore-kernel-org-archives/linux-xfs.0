Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750838AbeCFK0k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 05:26:40 -0500
From: Vratislav Bendel <vbendel@redhat.com>
Subject: [PATCH] xfs: Correctly invert xfs_buftarg LRU isolation logic
Date: Tue,  6 Mar 2018 11:26:38 +0100
Message-Id: <20180306102638.25322-1-vbendel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org

Due to an inverted logic mistake in xfs_buftarg_isolate()
the xfs_buffers with zero b_lru_ref will take another trip
around LRU, while isolating buffers with non-zero b_lru_ref.

Additionally those isolated buffers end up right back on the LRU
once they are released, because b_lru_ref remains elevated.

Fix that circuitous route by leaving them on the LRU
as originally intended.

Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d1da2ee9e6db..ac669a10c62f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1708,7 +1708,7 @@ xfs_buftarg_isolate(
 	 * zero. If the value is already zero, we need to reclaim the
 	 * buffer, otherwise it gets another trip through the LRU.
 	 */
-	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
 		spin_unlock(&bp->b_lock);
 		return LRU_ROTATE;
 	}
-- 
2.14.3

