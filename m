Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38FBC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9794221D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e7gadxLl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfIYVef (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43150 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbfIYVef (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYWWV010234;
        Wed, 25 Sep 2019 21:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=CVff4CSW93m4xJ2YRk+C3BNTVL2W8grW+5LXu/d/sFQ=;
 b=e7gadxLl46bWpdesFgit9x3N+S/mc23MnIpO//xJuCVVPGwMdpnIyqtkYXUGMf4w8nXd
 uOBP12HBxEeH6H3YQlhbuB8ZEN50qlhk107Bm/PGtVAazPhxZlZ58jFE8YtT8YMR3CkR
 ovqVBFxt70Xs99usGWi/iTSZ4CkSXDuL1uikWp3O/W+dT5adpxzCB+OxxrfKPjLbnaQy
 9JOvYbkllQJpaVH7ZlItxdR/RJmFyWNXTNNgz3YLau0JPaX7DWLC9K3CGf/vR7B2hsMT
 64rxMP56v27p1/4onC28qzKOIw9wQAqu3qp2KvS1jHJexld/bPVoml1/DQiEbextkgvo uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btq7hmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRF8011346;
        Wed, 25 Sep 2019 21:34:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v829w4x81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLY1VM014760;
        Wed, 25 Sep 2019 21:34:01 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:34:01 -0700
Subject: [PATCH 06/13] libfrog: add missing per-thread variable error
 handling
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:33:59 -0700
Message-ID: <156944723982.297677.3080857602921528738.stgit@magnolia>
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

