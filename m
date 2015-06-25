Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B3ED7FB2
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:40:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8D0BAC001
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:40:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id XQynHrGFglaSdBSj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:40:51 -0700 (PDT)
Subject: [PATCH 14/14] xfs: add reflink btree block detection to log recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:40:45 -0700
Message-ID: <20150625234045.4992.87666.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Teach log recovery how to deal with reflink btree blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3bbea4f..2175d06 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1849,6 +1849,7 @@ xlog_recover_get_buf_lsn(
 	case XFS_ABTB_MAGIC:
 	case XFS_ABTC_MAGIC:
 	case XFS_RMAP_CRC_MAGIC:
+	case XFS_RLBT_CRC_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
 	case XFS_IBT_MAGIC: {
 		struct xfs_btree_block *btb = blk;
@@ -2005,6 +2006,9 @@ xlog_recover_validate_buf_type(
 		case XFS_RMAP_CRC_MAGIC:
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;
+		case XFS_RLBT_CRC_MAGIC:
+			bp->b_ops = &xfs_reflinkbt_buf_ops;
+			break;
 		default:
 			xfs_warn(mp, "Bad btree block magic!");
 			ASSERT(0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
