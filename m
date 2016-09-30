Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48366 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935036AbcI3DHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:07:23 -0400
Subject: [PATCH 16/63] xfs: add refcount btree block detection to log
 recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:07:19 -0700
Message-ID: <147520483986.29434.3560778607193637899.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Identify refcountbt blocks in the log correctly so that we can
validate them during log recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7def672..622881a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2245,6 +2245,7 @@ xlog_recover_get_buf_lsn(
 	case XFS_ABTB_MAGIC:
 	case XFS_ABTC_MAGIC:
 	case XFS_RMAP_CRC_MAGIC:
+	case XFS_REFC_CRC_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
 	case XFS_IBT_MAGIC: {
 		struct xfs_btree_block *btb = blk;
@@ -2418,6 +2419,9 @@ xlog_recover_validate_buf_type(
 		case XFS_RMAP_CRC_MAGIC:
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;
+		case XFS_REFC_CRC_MAGIC:
+			bp->b_ops = &xfs_refcountbt_buf_ops;
+			break;
 		default:
 			warnmsg = "Bad btree block magic!";
 			break;

