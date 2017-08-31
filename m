Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48406 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbdHaUea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:34:30 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKYTAm014669
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKYSFa021557
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:29 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7VKYSOd024373
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:28 GMT
Subject: [PATCH 10/19] xfs: add realtime rmap btree block detection to log
 recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:34:26 -0700
Message-ID: <150421166619.17458.12957280842198069143.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Identify rtrmapbt blocks in the log correctly so that we can
validate them during log recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6c72bdf..cfe37fc 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2257,6 +2257,7 @@ xlog_recover_get_buf_lsn(
 		uuid = &btb->bb_u.s.bb_uuid;
 		break;
 	}
+	case XFS_RTRMAP_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;
@@ -2419,6 +2420,9 @@ xlog_recover_validate_buf_type(
 		case XFS_BMAP_MAGIC:
 			bp->b_ops = &xfs_bmbt_buf_ops;
 			break;
+		case XFS_RTRMAP_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrmapbt_buf_ops;
+			break;
 		case XFS_RMAP_CRC_MAGIC:
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;

