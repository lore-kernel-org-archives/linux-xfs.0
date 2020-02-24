Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DADC35669
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DC9420828
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBXD6Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 22:58:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727210AbgBXD6Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 22:58:16 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O3tIT1134139;
        Sun, 23 Feb 2020 22:58:12 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb1pfyhw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:12 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01O3vrZj144810;
        Sun, 23 Feb 2020 22:58:12 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb1pfyhvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:11 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01O3v7jm030694;
        Mon, 24 Feb 2020 03:58:11 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 2yaux5vat3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 03:58:10 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O3w9fa48562556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 03:58:09 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72A0B6A04F;
        Mon, 24 Feb 2020 03:58:09 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C7C76A054;
        Mon, 24 Feb 2020 03:58:06 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.91.136])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 03:58:06 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: [PATCH V4 RESEND 3/7] xfs: xfs_attr_calc_size: Calculate Bmbt blks only once
Date:   Mon, 24 Feb 2020 09:30:40 +0530
Message-Id: <20200224040044.30923-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200224040044.30923-1-chandanrlinux@gmail.com>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_07:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=857
 clxscore=1034 suspectscore=1 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 phishscore=0 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The number of Bmbt blocks that is required can be calculated only once by
passing the sum of total number of dabtree blocks and remote blocks to
XFS_NEXTENTADD_SPACE_RES() macro.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 942ba552e0bdd..a708b142f69b6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -154,12 +154,10 @@ xfs_attr_calc_size(
 	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
 			args->valuelen, local);
 	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
-	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
 	if (*local) {
 		if (size > (args->geo->blksize / 2)) {
 			/* Double split possible */
 			total_dablks *= 2;
-			bmbt_blks *= 2;
 		}
 		rmt_blks = 0;
 	} else {
@@ -168,10 +166,11 @@ xfs_attr_calc_size(
 		 * make room for the attribute value itself.
 		 */
 		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
-		bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, rmt_blks,
-				XFS_ATTR_FORK);
 	}
 
+	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
+			XFS_ATTR_FORK);
+
 	return total_dablks + rmt_blks + bmbt_blks;
 }
 
-- 
2.19.1

