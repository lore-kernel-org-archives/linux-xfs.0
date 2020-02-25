Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFF6C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10D9820732
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yL/YHpeE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgBYALE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:11:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYALE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:11:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07smx050183;
        Tue, 25 Feb 2020 00:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=I7L9ZPXUlcA7imRAcMq7KwB/3WM644xucmULsSHfiIM=;
 b=yL/YHpeEwxeqJpCCmDJ1jwHhprVNZhIU1WqyRpY6LrO/JaXPkIjgcd48QR7LcHd9ORuS
 amUklJd80l4HpjiMrpUYPghoTrbolHqn0WcoH3tKeXs6c8Tmr4AnVs1nLEarX9VPGr8R
 6cql1VqkIQ0LxTqhiGt242Vo01BoCYyU9LVpSCuNGk1mkavPuQ1gq1KwlmggHwSiShNN
 fFQ6apz7K9egQemXuolz/+yseez04g1egaqaV/KhriYFcZakx8C7BCkb4dTwssLLiEbu
 sKls6ULvYdu8vmsMnetlT1WH1fWbJfd35wVYV/JhNswNa2o5/3MikeUa+zjer2QPViOT pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q355-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P089R0014528;
        Tue, 25 Feb 2020 00:11:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ybdshxvmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:01 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0B0ZF031642;
        Tue, 25 Feb 2020 00:11:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:11:00 -0800
Subject: [PATCH 5/7] mkfs: check that metadata updates have been committed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:10:59 -0800
Message-ID: <158258945969.451075.3231072619586225611.stgit@magnolia>
In-Reply-To: <158258942838.451075.5401001111357771398.stgit@magnolia>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that all the metadata we wrote in the process of formatting
the filesystem have been written correctly, or exit with failure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1f5d2105..1038e604 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3940,13 +3940,16 @@ main(
 	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
-	libxfs_umount(mp);
+	/* Report failure if anything failed to get written to our new fs. */
+	error = -libxfs_umount(mp);
+	if (error)
+		exit(1);
+
 	if (xi.rtdev)
 		libxfs_device_close(xi.rtdev);
 	if (xi.logdev && xi.logdev != xi.ddev)
 		libxfs_device_close(xi.logdev);
 	libxfs_device_close(xi.ddev);
 	libxfs_destroy();
-
 	return 0;
 }

