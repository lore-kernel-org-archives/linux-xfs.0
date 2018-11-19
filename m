Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55865 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730845AbeKTHbA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 02:31:00 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj7-0000XO-0R
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj6-0002Ft-VV
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] xfs: uncached buffer tracing needs to print bno
Date: Tue, 20 Nov 2018 08:04:54 +1100
Message-Id: <20181119210459.8506-3-david@fromorbit.com>
In-Reply-To: <20181119210459.8506-1-david@fromorbit.com>
References: <20181119210459.8506-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Useless:

xfs_buf_get_uncached: dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
xfs_buf_unlock:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
xfs_buf_submit:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
xfs_buf_hold:         dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
xfs_buf_iowait:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
xfs_buf_iodone:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
xfs_buf_iowait_done:  dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
xfs_buf_rele:         dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...

Useful:


xfs_buf_get_uncached: dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
xfs_buf_unlock:       dev 253:32 bno 0xffffffffffffffff nblks 0x1 ...
xfs_buf_submit:       dev 253:32 bno 0x200b5 nblks 0x1 ...
xfs_buf_hold:         dev 253:32 bno 0x200b5 nblks 0x1 ...
xfs_buf_iowait:       dev 253:32 bno 0x200b5 nblks 0x1 ...
xfs_buf_iodone:       dev 253:32 bno 0x200b5 nblks 0x1 ...
xfs_buf_iowait_done:  dev 253:32 bno 0x200b5 nblks 0x1 ...
xfs_buf_rele:         dev 253:32 bno 0x200b5 nblks 0x1 ...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trace.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3043e5ed6495..8a6532aae779 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -280,7 +280,10 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 	),
 	TP_fast_assign(
 		__entry->dev = bp->b_target->bt_dev;
-		__entry->bno = bp->b_bn;
+		if (bp->b_bn == XFS_BUF_DADDR_NULL)
+			__entry->bno = bp->b_maps[0].bm_bn;
+		else
+			__entry->bno = bp->b_bn;
 		__entry->nblks = bp->b_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
-- 
2.19.1
