Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6B4C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 370DC206CD
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="z2qI6GOK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIBC4Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:56:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50654 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIBC4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:56:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822t5on003433;
        Wed, 2 Sep 2020 02:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OnkVnIhdtSp8kPFGqZr/s1dT2+oAyW9ZmWlLwbLlzPE=;
 b=z2qI6GOKDvNrtbu7yztR4rrVv8ovug4nPkHcop1J71bI1CW6JmovEu89T2mvdaci1u4B
 vQpI5NVFZCQDxI06/oo8CUgD+6TOzp+/k2cOf94zDI+jl5fnVWHrZ85HjYBAeiqhrtA/
 FTr3BjcEUqXhbP4+pWAufonFGX55oAbUh86bs8Nx0rVUIRSTX5a64dbFSZYLjmiOb6nu
 zjR2lHulSP54Xi74l0p48ftQZMNzrI+hjMOyNEK9VVWVJYsIMXRg+Jw1drycFVr2R6Au
 jQLFR9iDBgHyHvhD2ubh75Y06QBgQT7aMH2yx+ps7UuIpjC9rJpk+TLalmjbCGcHBLC7 vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eeqyvhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:56:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822tCOg037777;
        Wed, 2 Sep 2020 02:56:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3380kp8hqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:56:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0822uJwY028164;
        Wed, 2 Sep 2020 02:56:19 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:56:19 -0700
Subject: [PATCH 4/5] xfs: support inode btree blockcounts in online repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 01 Sep 2020 19:56:17 -0700
Message-ID: <159901537765.547164.7777551130535148618.stgit@magnolia>
In-Reply-To: <159901535219.547164.1381621861988558776.stgit@magnolia>
References: <159901535219.547164.1381621861988558776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=2 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
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
 fs/xfs/scrub/agheader_repair.c   |   24 ++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 1df04e48bd87..219f57f4b5a7 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -504,19 +504,29 @@ xfs_inobt_commit_staged_btree(
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
index bca2ab1d4be9..401f71579ce6 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -810,10 +810,34 @@ xrep_agi_calc_from_btrees(
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
+	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
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

