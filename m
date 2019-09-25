Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1D0C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F69621D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qyPOFTXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfIYVem (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbfIYVel (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYNmT057949;
        Wed, 25 Sep 2019 21:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rO1xdgdP7mc5eMTSJb07Snh24FizECXgUy//Th9QZNY=;
 b=qyPOFTXusm5zgPBSUwPl+vT7rxGMearu/bKtvyIVr9WQ3M+TZVVYdrV+Utnjjb8IPR70
 T4+4apxY5AzEXUei72G93OXszkB2rNL08jFPjp1GjjSoqBBTXqYyVUni22uiRWbJK9g+
 dNqd2oE1QkB61CsPZQPn9JrFYCJDdpYwXMKVSn3jplp7pAXiMqYzot4jDOrDaWn44FA4
 2a4AWp0DGMifFyZQLP2zGJ5wHUucDmTuWesNRuqJ+whgeSMgzo47y5dHjj2qD3fKaJU5
 bu0V96VaJ9vlK2+LduOyWDpupiYkZjicwJAITOsnY3lmpK20DV42jLExLvhjdmOBrG7n ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tyh0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYPLo023748;
        Wed, 25 Sep 2019 21:34:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v7vnyunpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLYYI0014434;
        Wed, 25 Sep 2019 21:34:35 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:34:34 -0700
Subject: [PATCH 11/13] xfs_scrub: check progress bar timedwait failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:34:30 -0700
Message-ID: <156944727002.297677.2767314073387682430.stgit@magnolia>
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

