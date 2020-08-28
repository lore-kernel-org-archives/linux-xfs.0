Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08ACC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 02:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADDC920848
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 02:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wjiWo9U3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgH1ChB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 22:37:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgH1ChB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 22:37:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S2Y8tZ027989;
        Fri, 28 Aug 2020 02:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QjI1FHjbeShmSVCB1eFUc4iaq67iUAQs5usD6rezxfM=;
 b=wjiWo9U3FJR6g9CWNpx2r3IEeH+jkwvKsIGtXSpXe3FmD/gOW3H8AROPDh6Gz54r2CLr
 zl1+rjvXBpMufzYzx1428yueCQJH9fxhoQ6KvD6Sw4o4iHnpFr0SeLrOAFNJO70cWnq6
 keZjv7IfEFKt3gJe1vRRL1NDGe1Rm674vCQlX5wn7/Q1kbQo2cXzCi0mHjpmy/RJIjXP
 8dq3x1lHmnAKiMd7AIGApdyRSBvXbgYYY48OD1pQXmdeI4I/X13LxVTCS/lksF37FyGN
 CU8BVgWBvn5Ru0pmSJ6eoExmNbnbWk6xEzrX2Dh4NiYra0/V5viCR7KnH0eoQFtmFOb+ nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 333dbs9ks7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 02:36:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S2Yusv091672;
        Fri, 28 Aug 2020 02:36:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 333r9p5bay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 02:36:58 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07S2auPa018965;
        Fri, 28 Aug 2020 02:36:57 GMT
Received: from localhost (/10.159.133.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 19:36:56 -0700
Subject: [PATCH 4/5] xfs: support inode btree blockcounts in online repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Aug 2020 19:36:55 -0700
Message-ID: <159858221586.3058056.4012330529904111156.stgit@magnolia>
In-Reply-To: <159858219107.3058056.6897728273666872031.stgit@magnolia>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add the necessary bits to the online repair code to support logging the
inode btree counters when rebuilding the btrees, and to support fixing
the counters when rebuilding the AGI.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |   16 +++++++++++++---
 fs/xfs/scrub/agheader_repair.c   |   23 +++++++++++++++++++++++
 2 files changed, 36 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index a5461091ba7b..1d419eb4e04c 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -501,19 +501,29 @@ xfs_inobt_commit_staged_btree(
 {
 	struct xfs_agi		*agi = agbp->b_addr;
 	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+	int			fields;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
 	if (cur->bc_btnum == XFS_BTNUM_INO) {
+		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
 		agi->agi_root = cpu_to_be32(afake->af_root);
 		agi->agi_level = cpu_to_be32(afake->af_levels);
-		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
+		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
+			agi->agi_iblocks = cpu_to_be32(afake->af_blocks);
+			fields |= XFS_AGI_IBLOCKS;
+		}
+		xfs_ialloc_log_agi(tp, agbp, fields);
 		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
 	} else {
+		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
 		agi->agi_free_root = cpu_to_be32(afake->af_root);
 		agi->agi_free_level = cpu_to_be32(afake->af_levels);
-		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREE_ROOT |
-					     XFS_AGI_FREE_LEVEL);
+		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
+			agi->agi_fblocks = cpu_to_be32(afake->af_blocks);
+			fields |= XFS_AGI_IBLOCKS;
+		}
+		xfs_ialloc_log_agi(tp, agbp, fields);
 		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
 	}
 }
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index bca2ab1d4be9..efa8152a0139 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -810,10 +810,33 @@ xrep_agi_calc_from_btrees(
 	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
 	if (error)
 		goto err;
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		xfs_agblock_t	blocks;
+
+		error = xfs_btree_count_blocks(cur, &blocks);
+		if (error)
+			goto err;
+		agi->agi_iblocks = cpu_to_be32(blocks);
+	}
 	xfs_btree_del_cursor(cur, error);
 
 	agi->agi_count = cpu_to_be32(count);
 	agi->agi_freecount = cpu_to_be32(freecount);
+
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		xfs_agblock_t	blocks;
+
+		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
+				XFS_BTNUM_FINO);
+		if (error)
+			goto err;
+		error = xfs_btree_count_blocks(cur, &blocks);
+		if (error)
+			goto err;
+		xfs_btree_del_cursor(cur, error);
+		agi->agi_fblocks = cpu_to_be32(blocks);
+	}
+
 	return 0;
 err:
 	xfs_btree_del_cursor(cur, error);

