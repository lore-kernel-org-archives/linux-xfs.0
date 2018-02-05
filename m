Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752722AbeBERqD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 12:46:03 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 56A43C05090B
        for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2018 17:46:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38698608F0
        for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2018 17:46:03 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/4] xfs: shutdown if block allocation overruns tx reservation
Date: Mon,  5 Feb 2018 12:45:58 -0500
Message-Id: <20180205174601.51574-2-bfoster@redhat.com>
In-Reply-To: <20180205174601.51574-1-bfoster@redhat.com>
References: <20180205174601.51574-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The ->t_blk_res_used field tracks how many blocks have been used in
the current transaction. This should never exceed the block
reservation (->t_blk_res) for a particular transaction. We currently
assert this condition in the transaction block accounting code, but
otherwise take no additional action should this situation occur.

The overrun generally has no effect if space ends up being available
and the associated transaction commits. If the transaction is
duplicated, however, the current block usage is used to determine
the remaining block reservation to be transferred to the new
transaction. If usage exceeds reservation, this calculation
underflows and creates a transaction with an invalid and excessive
reservation. When the second transaction commits, the release of
unused blocks corrupts the in-core free space counters. With lazy
superblock accounting enabled, this inconsistency eventually
trickles to the on-disk superblock and corrupts the filesystem.

Replace the transaction block usage accounting assert with an
explicit overrun check. If the transaction overruns the reservation,
shutdown the filesystem immediately to prevent corruption. Add a new
assert to xfs_trans_dup() to catch any callers that might induce
this invalid state in the future.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 86f92df32c42..9f9f745c3dff 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -119,8 +119,11 @@ xfs_trans_dup(
 	/* We gave our writer reference to the new transaction */
 	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
+
+	ASSERT(tp->t_blk_res >= tp->t_blk_res_used);
 	ntp->t_blk_res = tp->t_blk_res - tp->t_blk_res_used;
 	tp->t_blk_res = tp->t_blk_res_used;
+
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
 	ntp->t_pflags = tp->t_pflags;
@@ -344,13 +347,14 @@ xfs_trans_mod_sb(
 		break;
 	case XFS_TRANS_SB_FDBLOCKS:
 		/*
-		 * Track the number of blocks allocated in the
-		 * transaction.  Make sure it does not exceed the
-		 * number reserved.
+		 * Track the number of blocks allocated in the transaction.
+		 * Make sure it does not exceed the number reserved. If so,
+		 * shutdown as this can lead to accounting inconsistency.
 		 */
 		if (delta < 0) {
 			tp->t_blk_res_used += (uint)-delta;
-			ASSERT(tp->t_blk_res_used <= tp->t_blk_res);
+			if (tp->t_blk_res_used > tp->t_blk_res)
+				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		}
 		tp->t_fdblocks_delta += delta;
 		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
-- 
2.13.6

