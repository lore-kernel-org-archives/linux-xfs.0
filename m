Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810C4C4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5578F21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lf31nl59"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfIYVeb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbfIYVea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYTcF010157;
        Wed, 25 Sep 2019 21:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wFNAEg5YtbO6E4yspEc6n6KfAiklSqUX3m/88fxOJCs=;
 b=Lf31nl59lyqN3NVq6nG8uy96kJ1wwJpygGBk5ortPaBcWsQQ2NOzUBWuLaBD3eNOs5HZ
 +J7P4l+TrKWQtl+jVj6xzanVcQx0WCSQaOn5PccZ8fZUVcUCbamLZR53Hbchh5lI2vV5
 jTSTQN5Bf6s/6C9d3YgZuixCn+I2iuyme/QF4OBduQPI2ltWgb+O5T5s1Xk0JWV1B44H
 c2WsQWBf5Y0ErsU22kBJwSbPslpga2EycJQEXVQgWf1LbYbxh9lyMZqxOSrMpIkRf94q
 MARj18bxfJ1QE74TYTG7vrdmuun9a820op3pCdv1nIbNUWpXiQup7gFklPDOilAOtqTn OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btq7hm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRi5097688;
        Wed, 25 Sep 2019 21:34:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82qakrjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:27 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLYPV8014874;
        Wed, 25 Sep 2019 21:34:25 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:34:25 -0700
Subject: [PATCH 10/13] xfs_scrub: report all progressbar creation failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:34:24 -0700
Message-ID: <156944726395.297677.157416048420551315.stgit@magnolia>
In-Reply-To: <156944720314.297677.12837037497727069563.stgit@magnolia>
References: <156944720314.297677.12837037497727069563.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Always report failures when creating progress bars.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/progress.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/progress.c b/scrub/progress.c
index 08c7233e..5fda4ccb 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -198,8 +198,10 @@ progress_init_phase(
 	}
 
 	ret = pthread_create(&pt.thread, NULL, progress_report_thread, NULL);
-	if (ret)
+	if (ret) {
+		str_liberror(ctx, ret, _("creating progress reporting thread"));
 		goto out_ptcounter;
+	}
 
 	return true;
 

