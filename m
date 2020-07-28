Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E83C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 04:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7691C206D7
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 04:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GEMrco2X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbgG1Eca (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 00:32:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgG1Ec3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 00:32:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S4RaW2098719
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=6tWQsi7gFCybvNFBNAXKImOpWGi5Og56Nwu0QYwME3k=;
 b=GEMrco2XtItQ/o7ENsVdfGpOxzgF/kODSLuRxpHO56SrI1MLQ7L1FTETv3hnAk4EH7SO
 0lzds3Zr1DQRKBCQHO/gbxHFKciwU1zxOTLSquBxAvRfbL+868bI9VpDBJB9QaSc4Fgj
 LQHYZdIW3/RyW/C0f2pILS3WiscP87TvKNuoGe8Ou4amzyH0qaxtdpV2S2wurQol2kF4
 ilcTOiln5CIGGJg1xXgw0Z1pub9Opjk2mAajdoogPk6fX6AGYP2xWFAXTG7e40vAFK+8
 n7mwMUyNuSyzXvp+xpLMjJsQ/8i3x3mQwWPWMjkqCQ3P0jFmWDZj1uIXS3BBaDsXSwDM eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32hu1jd3v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S4SjaZ061211
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32hu5tjykq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:27 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06S4WRT8001041
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2020 04:32:27 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 21:32:27 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 1/2] xfs: Fix compiler warning in xfs_attr_node_removename_setup
Date:   Mon, 27 Jul 2020 21:32:19 -0700
Message-Id: <20200728043220.17231-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728043220.17231-1-allison.henderson@oracle.com>
References: <20200728043220.17231-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007280032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=1 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix compiler warning for variable 'blk' set but not used in
xfs_attr_node_removename_setup.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d4583a0..e5ec9ed 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1174,15 +1174,14 @@ int xfs_attr_node_removename_setup(
 	struct xfs_da_state	**state)
 {
 	int			error;
-	struct xfs_da_state_blk	*blk;
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
 		return error;
 
-	blk = &(*state)->path.blk[(*state)->path.active - 1];
-	ASSERT(blk->bp != NULL);
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
+	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
+		XFS_ATTR_LEAF_MAGIC);
 
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_leaf_mark_incomplete(args, *state);
-- 
2.7.4

