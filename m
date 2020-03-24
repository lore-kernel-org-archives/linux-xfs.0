Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76556C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 21:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DEB920714
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 21:01:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b1G8QZnw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgCXVBw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 17:01:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54730 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgCXVBw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 17:01:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKx2o3191562;
        Tue, 24 Mar 2020 21:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=i3ZMDf3hm/yuyQCJBK1JCyR5YIe2kSNbIE9B0MTI4+k=;
 b=b1G8QZnwxhCwhpdswL+Cp37z+U6ICMSsRLiJ597FLDlKB2i5G5JK6EIZr1TBX+mcbtBX
 synWaWjtXIxBjD3SALEeFchelmFFgyTYLfz+rVyyFwQTioFNa35QCxkhU5aCu+KOv0aR
 PyRkk6ACMTV5igX2SrT37lcpY+Sopy9DrBDyCuBDbGq5s+/R5em3Bykbhw2MUxEZmoLU
 34tJuu+uBTpd+P0H90IqpNVti05Pr0OCZmavmgkp5tikH23rvhS0S5zYvGyBIUTMCE/P
 v0846baGw6JhcOCadKq9uvfZ/lTP+JDODNU7FC7SfmkK1697SsSKOAPlDz2J4X+4lecX /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ywavm6np3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 21:01:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKwQIg105493;
        Tue, 24 Mar 2020 21:01:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yymbucv8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 21:01:48 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02OL1mmv032657;
        Tue, 24 Mar 2020 21:01:48 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 14:01:48 -0700
Date:   Tue, 24 Mar 2020 14:01:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH v2] xfs: preserve default grace interval during quotacheck
Message-ID: <20200324210146.GR29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240104
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When quotacheck runs, it zeroes all the timer fields in every dquot.
Unfortunately, it also does this to the root dquot, which erases any
preconfigured grace intervals and warning limits that the administrator
may have set.  Worse yet, the incore copies of those variables remain
set.  This cache coherence problem manifests itself as the grace
interval mysteriously being reset back to the defaults at the /next/
mount.

Fix it by not resetting the root disk dquot's timer and warning fields.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: just use a branch
---
 fs/xfs/xfs_qm.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 0ce334c51d73..ee175617630e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -889,12 +889,20 @@ xfs_qm_reset_dqcounts(
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;
-		ddq->d_btimer = 0;
-		ddq->d_itimer = 0;
-		ddq->d_rtbtimer = 0;
-		ddq->d_bwarns = 0;
-		ddq->d_iwarns = 0;
-		ddq->d_rtbwarns = 0;
+
+		/*
+		 * dquot id 0 stores the default grace period and the maximum
+		 * warning limit that were set by the administrator, so we
+		 * should not reset them.
+		 */
+		if (ddq->d_id != 0) {
+			ddq->d_btimer = 0;
+			ddq->d_itimer = 0;
+			ddq->d_rtbtimer = 0;
+			ddq->d_bwarns = 0;
+			ddq->d_iwarns = 0;
+			ddq->d_rtbwarns = 0;
+		}
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			xfs_update_cksum((char *)&dqb[j],
