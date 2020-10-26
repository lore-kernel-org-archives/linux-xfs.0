Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB3FC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0232207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:33:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gyqeOjc2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406479AbgJZXde (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:33:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54058 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406478AbgJZXde (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:33:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOqga164732;
        Mon, 26 Oct 2020 23:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PwgcSs21vrztNq6eyIkDNDg67NlH36y4MkDdfOlGPCg=;
 b=gyqeOjc2JUyfXKarXzIYhRJzVSK6akCzSSNwLLj9h2dnDYQO6ez6Fcp/6pq3nNl3Onfw
 YeBs228wAGHXnItI5EhtKmKoQ2qUbPAazqnLa9/Pj9vXnx+sACkS0FHF6z7V7ZrobKIQ
 vEVnUatarNN3hsb0z+J90Aa/g/81HaWMgmJJzB/h4qsql6JVmGMkLthIZkNVJMfMGAB2
 Iq2FKJ+pn3sz9zqWEVKGi7hPeap3jhd6dsraM2DZZmYIoAd3GYFJM+aBJNJlLxrX+BxG
 ugI20pKFUtJRFa/m3d7f2K56sZmsb3GmCiPKMAW2gHkqtUs729WoeMuBgLXlebrUH0y7 YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm3vumy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:33:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQE2g032468;
        Mon, 26 Oct 2020 23:33:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34cx1q2at5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNXQ7Z028466;
        Mon, 26 Oct 2020 23:33:26 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:26 -0700
Subject: [PATCH 3/9] xfs: support inode btree blockcounts in online repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:25 -0700
Message-ID: <160375520560.880355.17375467362387234849.stgit@magnolia>
In-Reply-To: <160375518573.880355.12052697509237086329.stgit@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 11f744234f052922db4ed77dad35862b3d3164cf

Add the necessary bits to the online repair code to support logging the
inode btree counters when rebuilding the btrees, and to support fixing
the counters when rebuilding the AGI.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ialloc_btree.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 1edf69ffa96b..953417151820 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -500,19 +500,29 @@ xfs_inobt_commit_staged_btree(
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

