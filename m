Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37130 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753043AbcK3WkU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Nov 2016 17:40:20 -0500
Subject: [PATCH 1/2] xfs: set AGI buffer type in xlog_recover_clear_agi_bucket
References: <203e6e5c-7663-b49b-36af-5885aa1f461a@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4a62db7d-d3aa-9ad7-4b28-87964f312e15@sandeen.net>
Date: Wed, 30 Nov 2016 16:40:18 -0600
MIME-Version: 1.0
In-Reply-To: <203e6e5c-7663-b49b-36af-5885aa1f461a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

xlog_recover_clear_agi_bucket didn't set the
type to XFS_BLFT_AGI_BUF, so we got a warning during log
replay (or an ASSERT on a debug build).

    XFS (md0): Unknown buffer type 0!
    XFS (md0): _xfs_buf_ioapply: no ops on block 0xaea8802/0x1

Fix this, as was done in f19b872b for 2 other locations
with the same problem.

cc: <stable@vger.kernel.org> # 3.10 to current
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9b3d7c7..2d91f5a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4929,6 +4929,7 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
 	offset = offsetof(xfs_agi_t, agi_unlinked) +
 		 (sizeof(xfs_agino_t) * bucket);
+	xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
 	xfs_trans_log_buf(tp, agibp, offset,
 			  (offset + sizeof(xfs_agino_t) - 1));
 

