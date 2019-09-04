Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D0FC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4850C22CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PS6IlbmZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfIDEiH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:38:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59460 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfIDEiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:38:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844ax00040821;
        Wed, 4 Sep 2019 04:37:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SJYNeUerDO1JT9amnIqjS70n4e68gut9on6cEzpLmcM=;
 b=PS6IlbmZJkOS/ZxQx21BWAUT3slhmgDpJgJ7isDjtJ0Ttj11DTXvTyev4dX6UsVxljvP
 vsnvle+kqdNS/M+GxOwtnecczNmfO/CWEOD1kzJyYbgZ0CQtENvSIRdEnWoWFtzNPUWp
 Ezp/jNIObV6W6ToxiBmbVfkkUb2dtzC/f0kHd1pgseoii3AiHciVTjHNG9+1aoqR2HlF
 AVHWEnf87Ze56lPgDqtY2Rt8eeJmvjQSeagYHWSMRfhaEhcYwozoRHwUGHYEl9X+xKbv
 Uj3RInB1kxi3YIrMqCDFQOF4QFehE5v6NdcQEFsrkLQfUWNu5oXbFL4Npk/jgwe51kG9 Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ut6d1r0cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844Wndq022697;
        Wed, 4 Sep 2019 04:37:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2usu51c5a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:55 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844bsPe024325;
        Wed, 4 Sep 2019 04:37:54 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:37:54 -0700
Subject: [PATCH 07/10] xfs_db: use precomputed inode geometry values
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Tue, 03 Sep 2019 21:37:53 -0700
Message-ID: <156757187309.1838441.9204486319983263288.stgit@magnolia>
In-Reply-To: <156757182283.1838441.193482978701233436.stgit@magnolia>
References: <156757182283.1838441.193482978701233436.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the precomputed inode geometry values instead of open-coding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

