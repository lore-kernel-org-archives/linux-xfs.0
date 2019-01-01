Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58186 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAACZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:25:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012P0JR174294
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:31 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pnxedxaxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:25:31 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012PUtK002282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:30 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012PT9P009616
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:30 GMT
Subject: [PATCH 10/20] xfs: add realtime rmap btree block detection to log
 recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:25:24 -0800
Message-ID: <154630952472.8108.1730851391064151054.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
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
index 0f432bc33826..7b0fbd2be5f1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2292,6 +2292,7 @@ xlog_recover_get_buf_lsn(
 		uuid = &btb->bb_u.s.bb_uuid;
 		break;
 	}
+	case XFS_RTRMAP_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;
@@ -2454,6 +2455,9 @@ xlog_recover_validate_buf_type(
 		case XFS_BMAP_MAGIC:
 			bp->b_ops = &xfs_bmbt_buf_ops;
 			break;
+		case XFS_RTRMAP_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrmapbt_buf_ops;
+			break;
 		case XFS_RMAP_CRC_MAGIC:
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;
