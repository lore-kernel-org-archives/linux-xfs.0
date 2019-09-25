Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA85C4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5403E21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UY/LDeG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfIYVey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfIYVey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYSgC009989;
        Wed, 25 Sep 2019 21:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=j3PUoWYx1JvXN9iihHFnkN0vC285z5COzqo7Ij20d2c=;
 b=UY/LDeG/OFZKv+RidFCjPpLpOFywovNEQztHJwxGXUw7e/ldUVBhcp1yOgfSl4OMTQsB
 xQmgO62fxPeJO7ac4U7VBtRumVAxnvtyX07CyLwLD4Qf7N2yxhgMHoaUOkOLYQqyzONN
 IzWHrKOQMt6BCnuN6h1STFW696j7k1V+ga5iInvFQw3MS3s1OuFODTtLxv8Av7XtUySn
 MemCT8gl5NUm694NC+BH74X4XmEbkMEOJGgZJ1HC2Uqy2G9EwUChOAM1b83zAbzGjTf8
 MgW/Y2r5Kq/18P4onoYijk/+M1CEoglsEvQmlf5ZVmV7XMMgfiLytSMgYa+61atfT016 Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btq7hr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYTAu097832;
        Wed, 25 Sep 2019 21:34:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2v82qakr5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLXhIc014668;
        Wed, 25 Sep 2019 21:33:43 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:33:42 -0700
Subject: [PATCH 03/13] libfrog: split workqueue destroy functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:33:41 -0700
Message-ID: <156944722163.297677.13367863143814852108.stgit@magnolia>
In-Reply-To: <156944720314.297677.12837037497727069563.stgit@magnolia>
References: <156944720314.297677.12837037497727069563.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Split the workqueue destroy function into two parts -- one to signal all
the threads to exit and wait for them, and a second one that actually
destroys all the memory associated with the workqueue.  This mean we can
report latent workqueue errors independent of the freeing function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/workqueue.c |   37 ++++++++++++++++++++++++++++++-------
 libfrog/workqueue.h |    2 ++
 repair/threads.c    |    6 ++++++
 scrub/fscounters.c  |   11 ++++++++++-
 scrub/inodes.c      |    5 +++++
 scrub/phase2.c      |    5 +++++
 scrub/phase4.c      |    6 ++++++
 scrub/read_verify.c |    1 +
 scrub/spacemap.c    |    5 +++++
 scrub/vfs.c         |    5 +++++
 10 files changed, 75 insertions(+), 8 deletions(-)


diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 48038363..07f11a7b 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -82,6 +82,7 @@ workqueue_create(
 		goto out_mutex;
 	}
 	wq->terminate = false;
+	wq->terminated = false;
 
 	for (i = 0; i < nr_workers; i++) {
 		err = pthread_create(&wq->threads[i], NULL, workqueue_thread,
@@ -119,6 +120,8 @@ workqueue_add(
 	struct workqueue_item	*wi;
 	int			ret;
 
+	assert(!wq->terminated);
+
 	if (wq->thread_count == 0) {
 		func(wq, index, arg);
 		return 0;
@@ -157,22 +160,42 @@ workqueue_add(
 
 /*
  * Wait for all pending work items to be processed and tear down the
- * workqueue.
+ * workqueue thread pool.
  */
-void
-workqueue_destroy(
+int
+workqueue_terminate(
 	struct workqueue	*wq)
 {
 	unsigned int		i;
+	int			ret;
+
+	pthread_mutex_lock(&wq->lock);
+	wq->terminate = true;
+	pthread_mutex_unlock(&wq->lock);
+
+	ret = pthread_cond_broadcast(&wq->wakeup);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < wq->thread_count; i++) {
+		ret = pthread_join(wq->threads[i], NULL);
+		if (ret)
+			return ret;
+	}
 
 	pthread_mutex_lock(&wq->lock);
-	wq->terminate = 1;
+	wq->terminated = true;
 	pthread_mutex_unlock(&wq->lock);
 
-	pthread_cond_broadcast(&wq->wakeup);
+	return 0;
+}
 
-	for (i = 0; i < wq->thread_count; i++)
-		pthread_join(wq->threads[i], NULL);
+/* Tear down the workqueue. */
+void
+workqueue_destroy(
+	struct workqueue	*wq)
+{
+	assert(wq->terminated);
 
 	free(wq->threads);
 	pthread_mutex_destroy(&wq->lock);
diff --git a/libfrog/workqueue.h b/libfrog/workqueue.h
index a1f3a57c..a56d1cf1 100644
--- a/libfrog/workqueue.h
+++ b/libfrog/workqueue.h
@@ -30,12 +30,14 @@ struct workqueue {
 	unsigned int		item_count;
 	unsigned int		thread_count;
 	bool			terminate;
+	bool			terminated;
 };
 
 int workqueue_create(struct workqueue *wq, void *wq_ctx,
 		unsigned int nr_workers);
 int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
 		uint32_t index, void *arg);
+int workqueue_terminate(struct workqueue *wq);
 void workqueue_destroy(struct workqueue *wq);
 
 #endif	/* __LIBFROG_WORKQUEUE_H__ */
diff --git a/repair/threads.c b/repair/threads.c
index d2190920..9b7241e3 100644
--- a/repair/threads.c
+++ b/repair/threads.c
@@ -56,5 +56,11 @@ void
 destroy_work_queue(
 	struct workqueue	*wq)
 {
+	int			err;
+
+	err = workqueue_terminate(wq);
+	if (err)
+		do_error(_("cannot terminate worker item, error = [%d] %s\n"),
+				err, strerror(err));
 	workqueue_destroy(wq);
 }
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 669c5ab0..98aa3826 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -102,7 +102,7 @@ xfs_count_all_inodes(
 	struct xfs_count_inodes	*ci;
 	xfs_agnumber_t		agno;
 	struct workqueue	wq;
-	bool			moveon;
+	bool			moveon = true;
 	int			ret;
 
 	ci = calloc(1, sizeof(struct xfs_count_inodes) +
@@ -126,8 +126,17 @@ xfs_count_all_inodes(
 			break;
 		}
 	}
+
+	ret = workqueue_terminate(&wq);
+	if (ret) {
+		moveon = false;
+		str_liberror(ctx, ret, _("finishing icount work"));
+	}
 	workqueue_destroy(&wq);
 
+	if (!moveon)
+		goto out_free;
+
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
 		*count += ci->counters[agno];
 	moveon = ci->moveon;
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 644a6372..c459a3b4 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -256,6 +256,11 @@ xfs_scan_all_inodes(
 		}
 	}
 
+	ret = workqueue_terminate(&wq);
+	if (ret) {
+		si.moveon = false;
+		str_liberror(ctx, ret, _("finishing bulkstat work"));
+	}
 	workqueue_destroy(&wq);
 
 	return si.moveon;
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 1d2244a4..d92b7e29 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -161,6 +161,11 @@ xfs_scan_metadata(
 	}
 
 out:
+	ret = workqueue_terminate(&wq);
+	if (ret) {
+		moveon = false;
+		str_liberror(ctx, ret, _("finishing scrub work"));
+	}
 	workqueue_destroy(&wq);
 	return moveon;
 }
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 903da6d2..eb30c189 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -90,6 +90,12 @@ xfs_process_action_items(
 		if (!moveon)
 			break;
 	}
+
+	ret = workqueue_terminate(&wq);
+	if (ret) {
+		moveon = false;
+		str_liberror(ctx, ret, _("finishing repair work"));
+	}
 	workqueue_destroy(&wq);
 
 	pthread_mutex_lock(&ctx->lock);
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index ff4d3572..bb8f09a8 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -120,6 +120,7 @@ void
 read_verify_pool_flush(
 	struct read_verify_pool		*rvp)
 {
+	workqueue_terminate(&rvp->wq);
 	workqueue_destroy(&rvp->wq);
 }
 
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 4258e318..91e8badb 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -230,6 +230,11 @@ xfs_scan_all_spacemaps(
 		}
 	}
 out:
+	ret = workqueue_terminate(&wq);
+	if (ret) {
+		sbx.moveon = false;
+		str_liberror(ctx, ret, _("finishing fsmap work"));
+	}
 	workqueue_destroy(&wq);
 
 	return sbx.moveon;
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 0cff2e3f..49d689af 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -250,6 +250,11 @@ scan_fs_tree(
 	assert(sft.nr_dirs == 0);
 	pthread_mutex_unlock(&sft.lock);
 
+	ret = workqueue_terminate(&wq);
+	if (ret) {
+		sft.moveon = false;
+		str_liberror(ctx, ret, _("finishing directory scan work"));
+	}
 out_wq:
 	workqueue_destroy(&wq);
 	return sft.moveon;

