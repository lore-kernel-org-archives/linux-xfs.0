Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557E7C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D87206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kcr9xVDv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388688AbfIFDg4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:36:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42672 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387624AbfIFDg4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:36:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YFvo074394;
        Fri, 6 Sep 2019 03:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=CVff4CSW93m4xJ2YRk+C3BNTVL2W8grW+5LXu/d/sFQ=;
 b=kcr9xVDvU6amMUtg/qLKoRAytwrBHQqf8mEMwasx1Ocp/4TwZkT4aj9SfOsNESBXHuin
 kOKSK2NsyH/wvbLXq6gocz58yfZAXHoXSfIYQCn3w+WlOv4zKiklzGSIqX1irBw22NYv
 FJ5F35gCLDURN6sM73qhtkmq7qeggbG6/y/txszIqgXK7/FuEGs6msVPeF+NCf+f15wV
 MvYrq5caQGiIb9R94QkTzVvkxb5gt3wM+oEgOFq1PerPs4elQgSgwlGOMibx+bReuNZM
 RnzYVw9TxcAHMS4chws94goETDYLfC9ACAcRhgCOOuaMYrYlifDBL55zByFLHDO6/bdd ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uuf51g360-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XTf8188609;
        Fri, 6 Sep 2019 03:36:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2utpmc75me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863are0004887;
        Fri, 6 Sep 2019 03:36:53 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:36:52 -0700
Subject: [PATCH 06/13] libfrog: add missing per-thread variable error
 handling
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:36:52 -0700
Message-ID: <156774101226.2644719.10512779001456813045.stgit@magnolia>
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

Add missing return value checks for everything that the per-thread
variable code calls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/ptvar.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)


diff --git a/libfrog/ptvar.c b/libfrog/ptvar.c
index 6cb58208..55324b71 100644
--- a/libfrog/ptvar.c
+++ b/libfrog/ptvar.c
@@ -44,8 +44,12 @@ ptvar_alloc(
 	int		ret;
 
 #ifdef _SC_LEVEL1_DCACHE_LINESIZE
+	long		l1_dcache;
+
 	/* Try to prevent cache pingpong by aligning to cacheline size. */
-	size = max(size, sysconf(_SC_LEVEL1_DCACHE_LINESIZE));
+	l1_dcache = sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
+	if (l1_dcache > 0)
+		size = roundup(size, l1_dcache);
 #endif
 
 	ptv = malloc(PTVAR_SIZE(nr, size));
@@ -88,17 +92,26 @@ ptvar_get(
 	int		*retp)
 {
 	void		*p;
+	int		ret;
 
 	p = pthread_getspecific(ptv->key);
 	if (!p) {
 		pthread_mutex_lock(&ptv->lock);
 		assert(ptv->nr_used < ptv->nr_counters);
 		p = &ptv->data[(ptv->nr_used++) * ptv->data_size];
-		pthread_setspecific(ptv->key, p);
+		ret = pthread_setspecific(ptv->key, p);
+		if (ret)
+			goto out_unlock;
 		pthread_mutex_unlock(&ptv->lock);
 	}
 	*retp = 0;
 	return p;
+
+out_unlock:
+	ptv->nr_used--;
+	pthread_mutex_unlock(&ptv->lock);
+	*retp = ret;
+	return NULL;
 }
 
 /* Iterate all of the per-thread variables. */

