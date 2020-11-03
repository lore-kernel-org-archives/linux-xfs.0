Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27AA3C388F9
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 17:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9757221FB
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 17:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SBEY3kH5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgKCRad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 12:30:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45890 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgKCRad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 12:30:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3HSrJX095703
        for <linux-xfs@vger.kernel.org>; Tue, 3 Nov 2020 17:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=9XPuydKCu1rK4NyJ6Py5q+bTHnL3BekNOTgCiNnJGAM=;
 b=SBEY3kH5TN4cB9Tjg/mjVW7zXtUphteAAo1iU7CYdVrhCZjR0ccGtndgVZWty8a2Bx5C
 r1PrGqenKBiy+BrjsJF3Lxhuos/HBHqsBP7VA371lN+X9wSWh0KqsIBKX6qxNRRlKOVr
 z2ddAW6Ic4yw/I9XeHlq9wjX2Yt8xD+wMyaiV3YE6lEzsBgHWNX35FukVKcAQa/UW6wD
 wLeQzF/B3z8A1LmM3Ic2mbNDFa9SGfgAEKL3gaLSPiuceuWFukIxyV+qzUIOFI8rBtjR
 RksNkDJOaXDWxJwKD3SXZ8eZhg0gs9GbDHgG9Jei/dktfOGMV2oNuDdjXSH5izxOu3+F ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34hhw2jhxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 17:30:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3HPiNc192523
        for <linux-xfs@vger.kernel.org>; Tue, 3 Nov 2020 17:28:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34hvrw6me8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 17:28:32 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A3HSVm3001118
        for <linux-xfs@vger.kernel.org>; Tue, 3 Nov 2020 17:28:31 GMT
Received: from localhost (/10.159.234.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 09:28:27 -0800
Date:   Tue, 3 Nov 2020 09:28:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix scrub flagging rtinherit even if there is no rt
 device
Message-ID: <20201103172827.GE7123@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=1 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=1 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030118
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The kernel has always allowed directories to have the rtinherit flag
set, even if there is no rt device, so this check is wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 3aa85b64de36..bb25ff1b770d 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -121,8 +121,7 @@ xchk_inode_flags(
 		goto bad;
 
 	/* rt flags require rt device */
-	if ((flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) &&
-	    !mp->m_rtdev_targp)
+	if ((flags & XFS_DIFLAG_REALTIME) && !mp->m_rtdev_targp)
 		goto bad;
 
 	/* new rt bitmap flag only valid for rbmino */
