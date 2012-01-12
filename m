Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CHPL66008500 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 11:25:21 -0600
Received: from ustc.edu.cn (smtp2.ustc.edu.cn [202.38.64.46]) by cuda.sgi.com
	with SMTP id WQHGBbtdZNBfJ5Na for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 09:25:18 -0800 (PST)
Date: Fri, 13 Jan 2012 01:30:28 +0800
From: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
Subject: [PATCH] xfs: remove unecessary AIL push wakeups
Message-ID: <20120113013028.6802d878@ustc>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, elder@kernel.org
Cc: linux-kernel@vger.kernel.org


In commit 0030807c66("xfs: revert to using a kthread for AIL pushing"),
AIL pushing is revert back to use a kthread. But unfortunately, it
introduced a regression: there are unnecessary AIL push wakeups during
idle, ~20 wakeups/s. This change remove the wakeups by reverting a bit
more: set "tout" value as zero during idle.

Signed-off-by: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
---
 fs/xfs/xfs_trans_ail.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index ed9252b..2014387 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -508,7 +508,7 @@ out_done:
 		ailp->xa_last_pushed_lsn = 0;
 		ailp->xa_log_flush = 0;
 
-		tout = 50;
+		tout = 0;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
 		 * We reached the target so wait a bit longer for I/O to
-- 
1.7.8.3


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
