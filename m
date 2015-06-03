Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3757E7FAD
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 01:05:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16978304032
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 23:05:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	eLjyc2oiNprbShQa for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 23:05:12 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Z01nQ-0001Dk-Qw
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Z01nQ-0002w4-Pk
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/20] xfs: add rmap btree block detection to log recovery
Date: Wed,  3 Jun 2015 16:04:55 +1000
Message-Id: <1433311497-10245-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1433311497-10245-1-git-send-email-david@fromorbit.com>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

So such blocks can be correctly identified and have their operations
structutes attached to validate recovery has not resulted in a
correct block.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5dad26c..239b19c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1848,6 +1848,7 @@ xlog_recover_get_buf_lsn(
 	case XFS_ABTC_CRC_MAGIC:
 	case XFS_ABTB_MAGIC:
 	case XFS_ABTC_MAGIC:
+	case XFS_RMAP_CRC_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
 	case XFS_IBT_MAGIC: {
 		struct xfs_btree_block *btb = blk;
@@ -2001,6 +2002,9 @@ xlog_recover_validate_buf_type(
 		case XFS_BMAP_MAGIC:
 			bp->b_ops = &xfs_bmbt_buf_ops;
 			break;
+		case XFS_RMAP_CRC_MAGIC:
+			bp->b_ops = &xfs_rmapbt_buf_ops;
+			break;
 		default:
 			xfs_warn(mp, "Bad btree block magic!");
 			ASSERT(0);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
