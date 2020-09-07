Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE70C43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 18:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C7120738
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 18:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GCHN0Ec2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgIGSCV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 14:02:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgIGSCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 14:02:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087I050R062797
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EcpYCzOoOwZcitK7phyRNm3PE4GFHcgFM+c2LqSGOFg=;
 b=GCHN0Ec2aF7NdRr59r7fjcc1qc2U58TZ9Z0uDsIHeaLcYIHTqoFcsN8GjVKFviGR9a/e
 arMGxdrwsuSjdwC9WtmznCIJMBFBWXp+bxZTcvW0mYzaa1QdTAORAM1Ho0jmuRgtqyt4
 OZs880StRFGuqJw1Hi0SqIUtvIi8HqyoKrw2cVmK/uMBxJjwFruk5pQj1G52DypbZjAt
 jdqIsUJZWt3+5slO3IWhwksevvoy+luHJN+L2zFk0fe6Cq2waSE0BtsZOiRwfk0nPVjX
 ppBRmmrcz5flcQrFTq5XFUsUKvDnYcivwuMOuDfyiUbxDUoLNkEYar632kkTIh24cSba 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33c3amqhj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Sep 2020 18:02:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087I0BdF098797
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:02:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33cmkuv0xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Sep 2020 18:02:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087I2HVj006648
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:02:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 11:01:09 -0700
Subject: [PATCH 1/3] xfs: don't propagate RTINHERIT -> REALTIME when there is
 no rtdev
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 11:01:08 -0700
Message-ID: <159950166858.582172.16284988680675778406.stgit@magnolia>
In-Reply-To: <159950166214.582172.6124562615225976168.stgit@magnolia>
References: <159950166214.582172.6124562615225976168.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=892 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=902 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While running generic/042 with -drtinherit=1 set in MKFS_OPTIONS, I
observed that the kernel will gladly set the realtime flag on any file
created on the loopback filesystem even though that filesystem doesn't
actually have a realtime device attached.  This leads to verifier
failures and doesn't make any sense, so be smarter about this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c06129cffba9..10312e1ae60c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -870,7 +870,8 @@ xfs_ialloc(
 				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 					di_flags |= XFS_DIFLAG_PROJINHERIT;
 			} else if (S_ISREG(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+				if ((pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) &&
+				    xfs_sb_version_hasrealtime(&mp->m_sb))
 					di_flags |= XFS_DIFLAG_REALTIME;
 				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSIZE;

