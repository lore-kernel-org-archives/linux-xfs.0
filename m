Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FF7C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3F7C20872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:33:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sMaEHlLG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406475AbgJZXda (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:33:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35930 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406472AbgJZXda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:33:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP0Sh157925;
        Mon, 26 Oct 2020 23:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=a1NO4cng35BRNT/s5YlGOjzKpDkAssMR9dqnWzD/0I0=;
 b=sMaEHlLG76KRVzlkmaOSdnmwEYhMTERuQLc44P53XtPFYCbAD1ZW7YYIsKTv5z6TbpI3
 kuTD1mcItbgxP0lQlzpZUvTQnUn2cVXLtMyiKqDniYROuHlE8cBAMt5ALrcqUd14nxw3
 38OevCt90sqhhvyg96hWXKTBmuB/1FyFd5zcyAUli0gBR9vdKXAfUlud8jbyL7X2y4WS
 rDSscS9XgS2bNEbJaVX4MfDvEujuNGalzEgZa3CUstI90o7dnZTmRFtkEwew/7pdbJdQ
 umZ88pMBLFjKS1BAYDsbhpzOBvKnTYTdmmmTEOTqfnDCc2iO1GLqKu912R0e7KcGDnHS sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:33:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxI6110453;
        Mon, 26 Oct 2020 23:33:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5wfrd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNXQU3007054;
        Mon, 26 Oct 2020 23:33:26 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:20 -0700
Subject: [PATCH 2/9] xfs: use the finobt block counts to speed up mount times
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:19 -0700
Message-ID: <160375519943.880355.16533167901394366067.stgit@magnolia>
In-Reply-To: <160375518573.880355.12052697509237086329.stgit@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 1ac35f061af011442eeb731632f6daae991ecf7c

Now that we have reliable finobt block counts, use them to speed up the
per-AG block reservation calculations at mount time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ialloc_btree.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 3ed87d1c7251..1edf69ffa96b 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -693,6 +693,28 @@ xfs_inobt_count_blocks(
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
@@ -710,7 +732,11 @@ xfs_finobt_calc_reserves(
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
 

