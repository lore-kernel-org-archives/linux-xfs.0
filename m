Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EE3797E3A
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:25:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0FA88F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:01 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gGwBvTe2fxlUcC6u (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:25:00 -0700 (PDT)
Subject: [PATCH 066/119] xfs: add refcount btree block detection to log
	recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:24:55 -0700
Message-ID: <146612669508.12839.12845120903495427776.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Teach log recovery how to deal with refcount btree blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ee37dc5..2235d94 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2238,6 +2238,7 @@ xlog_recover_get_buf_lsn(
 	case XFS_ABTB_MAGIC:
 	case XFS_ABTC_MAGIC:
 	case XFS_RMAP_CRC_MAGIC:
+	case XFS_REFC_CRC_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
 	case XFS_IBT_MAGIC: {
 		struct xfs_btree_block *btb = blk;
@@ -2409,6 +2410,9 @@ xlog_recover_validate_buf_type(
 		case XFS_RMAP_CRC_MAGIC:
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;
+		case XFS_REFC_CRC_MAGIC:
+			bp->b_ops = &xfs_refcountbt_buf_ops;
+			break;
 		default:
 			xfs_warn(mp, "Bad btree block magic!");
 			ASSERT(0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
