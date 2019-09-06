Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD83C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24866206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TkY3hE/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392140AbfIFDh3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:37:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36210 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392138AbfIFDh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:37:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Xw0E105085;
        Fri, 6 Sep 2019 03:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rO1xdgdP7mc5eMTSJb07Snh24FizECXgUy//Th9QZNY=;
 b=TkY3hE/95gCJU36oxFtQPUEjZWVrrMJExl5l9gqGpSqAkvZy+syLocKY3yRn/3xln+Pm
 GZ3bcqSQ93EMsuANm9so8x5qEXVgiaUwj3w++yyuHZJjxWleEE/707knsPrBphO7PMG8
 iwFoxQWvgEQcYVh22EdTQWAwvjoE4MaJk/6Vh/rf/pjmolxI/jJ/UOcTiYS44COhAtW4
 qT20NDkXfJobvD37G44h6sh91Enpe2elPKf8TzC8pMjAC7jGvrY+l3e9UdEDkHol8g5S
 BFDAN1nEExFYewAs4Ez8wvkBvs1vu1AEcIudMW/aEODJ5/LZdOLTte7OMe23W4y+NLBM Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uuf5f8335-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YVBr103636;
        Fri, 6 Sep 2019 03:37:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2uud7p2rsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863bPqp019259;
        Fri, 6 Sep 2019 03:37:25 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:37:25 -0700
Subject: [PATCH 11/13] xfs_scrub: check progress bar timedwait failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:37:24 -0700
Message-ID: <156774104464.2644719.15234278628058661215.stgit@magnolia>
In-Reply-To: <156774097496.2644719.4441145106129821110.stgit@magnolia>
References: <156774097496.2644719.4441145106129821110.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check for failures in the timedwait for progressbar reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/progress.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/progress.c b/scrub/progress.c
index 5fda4ccb..e93b607f 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -130,7 +130,9 @@ progress_report_thread(void *arg)
 			abstime.tv_sec++;
 			abstime.tv_nsec -= NSEC_PER_SEC;
 		}
-		pthread_cond_timedwait(&pt.wakeup, &pt.lock, &abstime);
+		ret = pthread_cond_timedwait(&pt.wakeup, &pt.lock, &abstime);
+		if (ret && ret != ETIMEDOUT)
+			break;
 		if (pt.terminate)
 			break;
 		ret = ptcounter_value(pt.ptc, &progress_val);

