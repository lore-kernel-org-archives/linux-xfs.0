Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B15C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC6DF206CA
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vk5Tk/8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbgJLVMI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 17:12:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbgJLVMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 17:12:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09CL3kGq052334;
        Mon, 12 Oct 2020 21:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=8cqoPLTtq/NHfcvapZt8mGoKzzMKd8h2pZPnM4dn3ak=;
 b=Vk5Tk/8CjszzCLiJ6CQVZGxNwuWXWQbFU9yda4Sd9hnFr3DrlAGFpxqMoF8250KbDn1b
 mDsu+2Lu77o7OYn0lhobq6DtpzTSfwhIq5el/OuUF0+1DY5NZUBJhfOxMFDEia+vx2XE
 bm8SXJMIJcs9r7Fdwdv2Ku3Z7XEfY1K+Q+OtJheAVdcqFcDbXSZA+C0THiin9QcvSyY0
 tOqb0LFXPmuUNfCSuSvic2U5NVu4HU6awvjY6ea+1mXJd0rSfWN0JU0AbKVp06QbwnQy
 XtVw022Kim0IQhxzlaJEnO6FpcMFC9tgs/ND304lVJIyLs4kRl95nJiPGDMh6/F5H/W9 yA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 343vae5ghe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Oct 2020 21:12:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09CLBAFI003576;
        Mon, 12 Oct 2020 21:11:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 343pux38gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 21:11:59 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09CLBxmp008649;
        Mon, 12 Oct 2020 21:11:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Oct 2020 14:11:59 -0700
Date:   Mon, 12 Oct 2020 14:11:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Machek <pavel@ucw.cz>, xfs <linux-xfs@vger.kernel.org>
Cc:     kernel list <linux-kernel@vger.kernel.org>, dchinner@redhat.com,
        sandeen@redhat.com
Subject: [PATCH] xfs: fix Kconfig asking about XFS_SUPPORT_V4 when XFS_FS=n
Message-ID: <20201012211157.GE6559@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9772 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=1 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010120160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9772 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010120159
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Pavel Machek complained that the question about supporting deprecated
XFS v4 comes up even when XFS is disabled.  This clearly makes no sense,
so fix Kconfig.

Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 5422227e9e93..9fac5ea8d0e4 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -24,6 +24,7 @@ config XFS_FS
 
 config XFS_SUPPORT_V4
 	bool "Support deprecated V4 (crc=0) format"
+	depends on XFS_FS
 	default y
 	help
 	  The V4 filesystem format lacks certain features that are supported
