Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4109FC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 146372332B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FwUZYNgB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbfHTUcV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:32:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730863AbfHTUcV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:32:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTM8C166384;
        Tue, 20 Aug 2019 20:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=W+eyDiduH01AuRlKvJoDJWjH3iqVWD+QgIZFQD+V264=;
 b=FwUZYNgB3satGwFu4iGNtx5GJlaLyH3v6cg35H+vNcLp94t+AUkQ8PrgfBOxyNpwLgqv
 WaApDGZT3RPCcUkw5wC5aqngPgv5YmwsRcW+oVk7EGTxWBkByLibQi4Z/+pDJw2/6xYW
 FSJJuXBlK5Q4np0xz3TrMCJWhSqDLkzJn1xLkKjip1V+c+OZnhqEU9G91TM5l1eb40IR
 43AZamecqBwgNSNRilFKSGj6oRMeNk03OLKzprSxGhLx4VqWp3KdtJGaQYAgPzU0lZjs
 H8C4Ii6j3LWEx3DtSTWThe16kjBadoUaQhs9RtQxvf4ZATxGtKSDYhoGWbxfteRzKC7K TQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uea7qs0pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:32:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKSpiT160338;
        Tue, 20 Aug 2019 20:32:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ug1g9rkxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:32:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKWIgS021953;
        Tue, 20 Aug 2019 20:32:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:32:17 -0700
Subject: [PATCH 10/12] xfs_db: use precomputed inode geometry values
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:32:17 -0700
Message-ID: <156633313698.1215978.12801273719077418862.stgit@magnolia>
In-Reply-To: <156633307176.1215978.17394956977918540525.stgit@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the precomputed inode geometry values instead of open-coding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/inode.c      |    8 +++-----
 repair/dinode.c |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)


diff --git a/db/inode.c b/db/inode.c
index 73dd118d..d8d69ffb 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -657,16 +657,14 @@ set_cur_inode(
 	    igeo->inoalign_mask) {
 		xfs_agblock_t	chunk_agbno;
 		xfs_agblock_t	offset_agbno;
-		int		blks_per_cluster;
 
-		blks_per_cluster = igeo->inode_cluster_size >>
-							mp->m_sb.sb_blocklog;
 		offset_agbno = agbno & igeo->inoalign_mask;
 		chunk_agbno = agbno - offset_agbno;
 		cluster_agbno = chunk_agbno +
-			((offset_agbno / blks_per_cluster) * blks_per_cluster);
+			((offset_agbno / M_IGEO(mp)->blocks_per_cluster) *
+			 M_IGEO(mp)->blocks_per_cluster);
 		offset += ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock);
-		numblks = XFS_FSB_TO_BB(mp, blks_per_cluster);
+		numblks = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	} else
 		cluster_agbno = agbno;
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 56992dd2..f5e88cc3 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -768,7 +768,7 @@ get_agino_buf(
 	 * we must find the buffer for its cluster, add the appropriate
 	 * offset, and return that.
 	 */
-	cluster_size = max(igeo->inode_cluster_size, mp->m_sb.sb_blocksize);
+	cluster_size = igeo->inode_cluster_size;
 	ino_per_cluster = cluster_size / mp->m_sb.sb_inodesize;
 	cluster_agino = agino & ~(ino_per_cluster - 1);
 	cluster_blks = XFS_FSB_TO_DADDR(mp, max(1,

