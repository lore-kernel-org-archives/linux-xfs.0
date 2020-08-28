Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A016C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 02:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A34A20848
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 02:36:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e4XG0FGO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgH1Cgt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 22:36:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgH1Cgt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 22:36:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S2ZnBe091720;
        Fri, 28 Aug 2020 02:36:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OQ4S0WhniHSYyACFmDxQU36QzJ1+3MBwg53lzB7CH/I=;
 b=e4XG0FGOTL5z4ZHGd1E5QpPYvnMNTSoSLuK5/g0O+Xv9VNS77/qf4huoATlUgT1ST30o
 XeAAUMUhRfORNxKo4cgRtO1c4EetE2YjUaojWkSAiS2E3sbx+J+OjhX5b33MTcOSpBB8
 js7GaeO+UHucIcHjNY0IPsGa0NDcEfGYSkKk+V3Qtnv45R/fvJ9gAka4YoGlXnjylL30
 ifMxI4tiLcKLT0Vexh5rcqX+HtNEUnBqlTazp0CC4wGTU62+ukkzqweSOvwhLuAb7g5C
 e9hMB47h0pYkou8IyZt50E0UdrdQ3k70RFuQ0yhUHqEkjnKa64pmd4SNXQ8NBxnze+gu Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 333w6u85hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 02:36:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S2Yxm1138555;
        Fri, 28 Aug 2020 02:36:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 333ru280r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 02:36:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07S2aiqt023807;
        Fri, 28 Aug 2020 02:36:44 GMT
Received: from localhost (/10.159.133.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 19:36:44 -0700
Subject: [PATCH 2/5] xfs: use the finobt block counts to speed up mount times
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Aug 2020 19:36:43 -0700
Message-ID: <159858220352.3058056.14870764546265114620.stgit@magnolia>
In-Reply-To: <159858219107.3058056.6897728273666872031.stgit@magnolia>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we have reliable finobt block counts, use them to speed up the
per-AG block reservation calculations at mount time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index ee9d407ab9da..a5461091ba7b 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -694,6 +694,28 @@ xfs_inobt_count_blocks(
 	return error;
 }
 
+/* Read finobt block count from AGI header. */
+static int
+xfs_finobt_read_blocks(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*tree_blocks)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_agi		*agi;
+	int			error;
+
+	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	if (error)
+		return error;
+
+	agi = agbp->b_addr;
+	*tree_blocks = be32_to_cpu(agi->agi_fblocks);
+	xfs_trans_brelse(tp, agbp);
+	return 0;
+}
+
 /*
  * Figure out how many blocks to reserve and how many are used by this btree.
  */
@@ -711,7 +733,11 @@ xfs_finobt_calc_reserves(
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
 		return 0;
 
-	error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO, &tree_len);
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
+		error = xfs_finobt_read_blocks(mp, tp, agno, &tree_len);
+	else
+		error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO,
+				&tree_len);
 	if (error)
 		return error;
 

