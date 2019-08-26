Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD5EC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EDB92186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tcz5JVvR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfHZV3i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:29:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728596AbfHZV3i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:29:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDuLi001346;
        Mon, 26 Aug 2019 21:29:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=o8oCYX2TrPhXcPo7Zx7xqrMalOrbv30bVL3T3MDc6gg=;
 b=Tcz5JVvRPS5oZm1uRFFIN8ToVFf/0+vsWTdakK2Tm/slHk+ab/XsF5WrJK85SsMq75za
 ZvsLwf5LUFs9Lzx0detjygqJsg0dO2iBNtLMtnwpJlf3dsTybuEIx6oPfwdFk1Ln5u5B
 jG6DxYkEfhLm96fSR49lEaV4wE3P6tX6lYznL+y+SKowS0XUg/gXLcKeyARXLU/Th7IS
 JNYe435PdmFYTm/2JRm/GjBHnKA4R43Df/MqvTa4fR9DlVn7geRxXvauhWz4MJ/9fBoc
 kZ0nW40WSyzT8+3oI6towq4rUjKhmw3qP88e7v9lv52n1KT6dJruhnrQv14wAHsZmzZc Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2umpxx05c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIcRX169566;
        Mon, 26 Aug 2019 21:29:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7wyw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:35 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLTZ9t006254;
        Mon, 26 Aug 2019 21:29:35 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:29:35 -0700
Subject: [PATCH 11/13] xfs_scrub: check progress bar timedwait failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:29:34 -0700
Message-ID: <156685497449.2841546.7301983641781457889.stgit@magnolia>
In-Reply-To: <156685489821.2841546.10616502094098044568.stgit@magnolia>
References: <156685489821.2841546.10616502094098044568.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
index 6d4f2c36..14eaf8d3 100644
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

