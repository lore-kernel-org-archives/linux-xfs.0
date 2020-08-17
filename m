Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA45C433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7EBB2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b1+aDKcp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgHQW6o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:58:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgHQW6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:58:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwLmh164217;
        Mon, 17 Aug 2020 22:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/lDMMuf19pkPwalcpYnbJOLa9uMieT610+hZqZXat8k=;
 b=b1+aDKcp6+3cNHfK2MzApohK3xg4cq955Dp+LQGJmQn0ylEmv/98ZOEG91xtHDsPkXKI
 mU4+9sXaTolqvkwteILYbppA1Dzewz21ij1ZFAus07dP276oqkXbQUiNW9iGJo2RX0V+
 AzIQbdlWoD1PSvocbSTSCrDsI4rK1tc5x6NctOPoHuCeQB3CMmWjdfOviRHypXRyhYOy
 wKgysKOXYMMRuwADYvuzc5jbaFoWqxqQseE9k2SUCBXuwh9J0BoYP/5Qvsj8nr0ra3gB
 VwnCz009nyqcOjDOhC7Rxfn7uNG67zbRrFju36Nwwd9Bd1eHXnbUwZsPfgjPC8QTsF4D /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74r1mr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:58:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvjRX113907;
        Mon, 17 Aug 2020 22:58:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32xsm18pe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:58:39 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMwcAl017698;
        Mon, 17 Aug 2020 22:58:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:58:37 -0700
Subject: [PATCH 5/7] xfs_repair: regenerate inode btree block counters in AGI
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:58:36 -0700
Message-ID: <159770511687.3958545.383115865231736129.stgit@magnolia>
In-Reply-To: <159770508586.3958545.417872750558976156.stgit@magnolia>
References: <159770508586.3958545.417872750558976156.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Reset both inode btree block counters in the AGI when rebuilding the
metadata indexes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/repair/phase5.c b/repair/phase5.c
index 446f7ec0a1db..b97d23809f3c 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -172,6 +172,11 @@ build_agi(
 				cpu_to_be32(btr_fino->newbt.afake.af_levels);
 	}
 
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		agi->agi_iblocks = cpu_to_be32(btr_ino->newbt.afake.af_blocks);
+		agi->agi_fblocks = cpu_to_be32(btr_fino->newbt.afake.af_blocks);
+	}
+
 	libxfs_buf_mark_dirty(agi_buf);
 	libxfs_buf_relse(agi_buf);
 }

