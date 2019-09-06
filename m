Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC19C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6775206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AGPORCwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387623AbfIFDgc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:36:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390521AbfIFDgc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:36:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Xpo5104779;
        Fri, 6 Sep 2019 03:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=s8P9pZTcX3/SDa0za7d0YID3+cChZYOB+aOmdjhZP0c=;
 b=AGPORCwUn5WKRg0VPrQldlLFUKbdi3+GedMi2PbuUJy7T0/Y1hFnXcPdjJB+M2Kl9wD4
 mVneq7ybf1hm0bxgU1uo7+kTkS+mFiHfb3KugUguvxaDBF/IsE53Zw/bnD5c3Zjn5rN+
 T2jAx0VzIxZ9uDr0CFdiIq1zqhonP4xj02bj9pQhTGOMHIgELTA5O7BMdJpGazuuBeSy
 Cs8Hpkn4sZn90UMZu98jUyJdz4DhJBWZDXdeIiOghuS0eVfEvmcFsxch5Bvfp7v6S9FD
 9hM0CR0xxG/ZXdEbpsPyRcn8EvwGIGtoto0v5DfYoY7tBcubT/pifyQjFMFHXH8Qn+yo sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uuf5f830v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XaBW188783;
        Fri, 6 Sep 2019 03:36:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2utpmc75ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:29 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863aSnb004764;
        Fri, 6 Sep 2019 03:36:28 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:36:27 -0700
Subject: [PATCH 02/13] libfrog: fix missing error checking in workqueue code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:36:27 -0700
Message-ID: <156774098739.2644719.3779575154856756310.stgit@magnolia>
In-Reply-To: <156774097496.2644719.4441145106129821110.stgit@magnolia>
References: <156774097496.2644719.4441145106129821110.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix all the places in the workqueue code where we fail to check return
values and blindly keep going when we shouldn't.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/workqueue.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)


diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index a806da3e..48038363 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -67,12 +67,20 @@ workqueue_create(
 	int			err = 0;
 
 	memset(wq, 0, sizeof(*wq));
-	pthread_cond_init(&wq->wakeup, NULL);
-	pthread_mutex_init(&wq->lock, NULL);
+	err = pthread_cond_init(&wq->wakeup, NULL);
+	if (err)
+		return err;
+	err = pthread_mutex_init(&wq->lock, NULL);
+	if (err)
+		goto out_cond;
 
 	wq->wq_ctx = wq_ctx;
 	wq->thread_count = nr_workers;
 	wq->threads = malloc(nr_workers * sizeof(pthread_t));
+	if (!wq->threads) {
+		err = errno;
+		goto out_mutex;
+	}
 	wq->terminate = false;
 
 	for (i = 0; i < nr_workers; i++) {
@@ -82,9 +90,19 @@ workqueue_create(
 			break;
 	}
 
+	/*
+	 * If we encounter errors here, we have to signal and then wait for all
+	 * the threads that may have been started running before we can destroy
+	 * the workqueue.
+	 */
 	if (err)
 		workqueue_destroy(wq);
 	return err;
+out_mutex:
+	pthread_mutex_destroy(&wq->lock);
+out_cond:
+	pthread_cond_destroy(&wq->wakeup);
+	return err;
 }
 
 /*
@@ -99,6 +117,7 @@ workqueue_add(
 	void			*arg)
 {
 	struct workqueue_item	*wi;
+	int			ret;
 
 	if (wq->thread_count == 0) {
 		func(wq, index, arg);
@@ -118,9 +137,11 @@ workqueue_add(
 	/* Now queue the new work structure to the work queue. */
 	pthread_mutex_lock(&wq->lock);
 	if (wq->next_item == NULL) {
-		wq->next_item = wi;
 		assert(wq->item_count == 0);
-		pthread_cond_signal(&wq->wakeup);
+		ret = pthread_cond_signal(&wq->wakeup);
+		if (ret)
+			goto out_item;
+		wq->next_item = wi;
 	} else {
 		wq->last_item->next = wi;
 	}
@@ -129,6 +150,9 @@ workqueue_add(
 	pthread_mutex_unlock(&wq->lock);
 
 	return 0;
+out_item:
+	free(wi);
+	return ret;
 }
 
 /*

