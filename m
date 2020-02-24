Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AEFC35669
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1479A20675
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBXD7I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 22:59:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727168AbgBXD7I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 22:59:08 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O3sDMr076392;
        Sun, 23 Feb 2020 22:58:59 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yb1c5radc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:59 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01O3uAKn080232;
        Sun, 23 Feb 2020 22:58:58 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yb1c5rad5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:58 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01O3tL95020351;
        Mon, 24 Feb 2020 03:58:58 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 2yaux6cau6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 03:58:57 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O3wucV43974988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 03:58:56 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B9456E052;
        Mon, 24 Feb 2020 03:58:56 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD8DB6E04C;
        Mon, 24 Feb 2020 03:58:53 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.91.136])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 03:58:53 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: [PATCH V4 RESEND 2/7] xfsprogs: xfs_attr_calc_size: Use local variables to track individual space components
Date:   Mon, 24 Feb 2020 09:31:31 +0530
Message-Id: <20200224040136.31078-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200224040136.31078-1-chandanrlinux@gmail.com>
References: <20200224040136.31078-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_07:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 suspectscore=1 adultscore=0
 mlxlogscore=978 bulkscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The size calculated by xfs_attr_calc_size() is a sum of three components,
1. Number of dabtree blocks
2. Number of Bmbt blocks
3. Number of remote blocks

This commit introduces new local variables to track these numbers explicitly.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index e67d2eef..6f60f718 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -142,8 +142,10 @@ xfs_attr_calc_size(
 	int			*local)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
+	unsigned int		total_dablks;
+	unsigned int		bmbt_blks;
+	unsigned int		rmt_blks;
 	int			size;
-	int			nblks;
 
 	/*
 	 * Determine space new attribute will use, and if it would be
@@ -151,23 +153,26 @@ xfs_attr_calc_size(
 	 */
 	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
 			args->valuelen, local);
-	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
+	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
+	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
 	if (*local) {
 		if (size > (args->geo->blksize / 2)) {
 			/* Double split possible */
-			nblks *= 2;
+			total_dablks *= 2;
+			bmbt_blks *= 2;
 		}
+		rmt_blks = 0;
 	} else {
 		/*
 		 * Out of line attribute, cannot double split, but
 		 * make room for the attribute value itself.
 		 */
-		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
-		nblks += dblocks;
-		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
+		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
+		bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, rmt_blks,
+				XFS_ATTR_FORK);
 	}
 
-	return nblks;
+	return total_dablks + rmt_blks + bmbt_blks;
 }
 
 STATIC int
-- 
2.19.1

