Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2B2C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC6932186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sFaK6ACI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfHZV2f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:28:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV2f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:28:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLQwc5003378;
        Mon, 26 Aug 2019 21:28:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dJj9q43Nnaj54wtnFd2i949EJDJ87rxxiMEOx5PxY48=;
 b=sFaK6ACIMMBEBMxP0XVlyvssjRqvf+TgBjNa9stE45mKQbywtZrFflsTivJMxJ5kAIzS
 LbTINeMzIrzvDzR1auA9Hr9SFu3bgNAbMw+iViRu//LpfjBaRWq0yXFIqOJBCDvI/tE1
 /E7iWbDc0ywmNNr7EDDI3lxAWUFfnXLkbrs9xY/lV+6BVYZ4zaW+XC+GQYjbEQPeKjjl
 0jtbxexyeZo+D+Qb1z5XGQ/snzHJ5h/pW2LtGUpZKgjDr5mQ39bdQtep5cKdXE5tCa/8
 CHd6kaJChN29kNvifZsSmNP+Nnk64HuVlEcyllz+W17UpIoUqPbmynzQafHR+XjXwb7T 3Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2umqbe8083-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIUdC170206;
        Mon, 26 Aug 2019 21:28:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2umj27861x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLSVCj005742;
        Mon, 26 Aug 2019 21:28:31 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:28:31 -0700
Subject: [PATCH 02/13] libfrog: fix missing error checking in workqueue code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:28:30 -0700
Message-ID: <156685491069.2841546.5453029918616732727.stgit@magnolia>
In-Reply-To: <156685489821.2841546.10616502094098044568.stgit@magnolia>
References: <156685489821.2841546.10616502094098044568.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix all the places in the workqueue code where we fail to check return
values and blindly keep going when we shouldn't.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/workqueue.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)


diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index a806da3e..24b22bf6 100644
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
@@ -116,11 +135,16 @@ workqueue_add(
 	wi->next = NULL;
 
 	/* Now queue the new work structure to the work queue. */
-	pthread_mutex_lock(&wq->lock);
+	ret = pthread_mutex_lock(&wq->lock);
+	if (ret)
+		goto out_item;
+
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
@@ -129,6 +153,9 @@ workqueue_add(
 	pthread_mutex_unlock(&wq->lock);
 
 	return 0;
+out_item:
+	free(wi);
+	return ret;
 }
 
 /*

