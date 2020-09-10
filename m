Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D172C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F95207EA
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZeRuluzL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgIJFhF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 01:37:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58704 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgIJFhD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 01:37:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A5aASo028158;
        Thu, 10 Sep 2020 05:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eXRzsMyp/wWL3otupuUz6nvfvjizHyn9B4RFVqlYJlA=;
 b=ZeRuluzLTocHzyyHim+vU3bTPwxja/RFfaZLWSLb5U3uUke8FdZnDVahvcYHzSPeib2x
 Da8jLJtbhcbFAfIpXitZYrMKhoTD4wZTp65YGvZ8p3PysPGZXfcxIyxoNCzJODeZImWk
 ZZ89RPAkI2KBUgbzNot3xeSCt6WaDSTm1SmtQhWclwAij5G5/FnBuAzbeWi69nhfBxik
 x0H1HBWlQM1bJ1jSBXRMNeZaljz+wUkcXZqCDVLcS+bHBAm5MsHiRBdavjHB43ACBS1X
 kPQfwqIzKcONjoBrdVI6ohzgtYv2f50+Lyv6LKO61d3PVYXjpX1+pZ8NTtc/6aTmyURy AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33c23r5u42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 05:36:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A5ZX6e031335;
        Thu, 10 Sep 2020 05:36:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33cmeu753y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 05:36:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08A5awiU021513;
        Thu, 10 Sep 2020 05:36:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 22:36:58 -0700
Subject: [PATCH 2/2] xfs: don't propagate RTINHERIT -> REALTIME when there is
 no rtdev
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 09 Sep 2020 22:36:57 -0700
Message-ID: <159971621697.1311472.12347305476746590593.stgit@magnolia>
In-Reply-To: <159971620202.1311472.11867327944494045509.stgit@magnolia>
References: <159971620202.1311472.11867327944494045509.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=914 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=924 mlxscore=0 bulkscore=0 suspectscore=1 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100053
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
index 4c520cc10191..ab43ccb88ee7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -733,7 +733,8 @@ xfs_inode_propagate_flags(
 		if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 			di_flags |= XFS_DIFLAG_PROJINHERIT;
 	} else if (S_ISREG(mode)) {
-		if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+		if ((pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) &&
+		    xfs_sb_version_hasrealtime(&ip->i_mount->m_sb))
 			di_flags |= XFS_DIFLAG_REALTIME;
 		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
 			di_flags |= XFS_DIFLAG_EXTSIZE;

