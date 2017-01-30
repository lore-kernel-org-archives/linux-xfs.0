Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:50239 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754098AbdA3Sss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2017 13:48:48 -0500
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 14/14] xfs: use atomic_dec_not_zero()
Date: Mon, 30 Jan 2017 19:48:44 +0100
Message-Id: <20170130184844.19290-1-fabf@skynet.be>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, Fabian Frederick <fabf@skynet.be>

instead of atomic_add_unless(value, -1, 0)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ac3b4db..51b2167 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1684,7 +1684,7 @@ xfs_buftarg_isolate(
 	 * zero. If the value is already zero, we need to reclaim the
 	 * buffer, otherwise it gets another trip through the LRU.
 	 */
-	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+	if (!atomic_dec_not_zero(&bp->b_lru_ref)) {
 		spin_unlock(&bp->b_lock);
 		return LRU_ROTATE;
 	}
-- 
2.9.3

