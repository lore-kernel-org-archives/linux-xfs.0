Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B19C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3053F21872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="evoRZAcL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfHZV2l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:28:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50110 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:28:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLRGKQ003532;
        Mon, 26 Aug 2019 21:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=eTuBneiHAcFTQAbhxZWDgHa8gZ3J2OWkabMt1qdnmBQ=;
 b=evoRZAcLjiQmtPdn3xuujCGnTm7113rWDngMa75qJmhTzmIebknLMrLvQPtAn69mPq9C
 xebZ+zE9NkRDMpg2wANTtL7vN6I81K+DQ8JrymHVdvV5QeVW0RLyK+yCF5gZFq2xVKt3
 VvWxwwz667RhRdcA8AxDqK/lXW1txGlkIOUqF5wg8WG1uORpgS9J155J9Xv0Pdxz+1tQ
 Q4vVg8C9QvlgvBn/tV60O4mZH3oJ7+XE4d/dUQ8b91sjtPtAX3TB0Y32tycacQ63jlYZ
 Y0oaMKfOkwGpZRBrZhkXUmLOlOyhDKyi9PJOM4V4SumUZ9DNRh3pyiWEMLlxhq1hDMDS Zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2umqbe808h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLItij185003;
        Mon, 26 Aug 2019 21:28:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2umj2xvwcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:38 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLScab003523;
        Mon, 26 Aug 2019 21:28:38 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:28:37 -0700
Subject: [PATCH 03/13] libfrog: split workqueue destroy functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:28:36 -0700
Message-ID: <156685491681.2841546.10288908079957257602.stgit@magnolia>
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

Split the workqueue destroy function into two parts -- one to signal all
the threads to exit and wait for them, and a second one that actually
destroys all the memory associated with the workqueue.  This mean we can
report latent workqueue errors independent of the freeing function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/workqueue.h |    2 ++
 libfrog/workqueue.c |   45 +++++++++++++++++++++++++++++++++++++--------
 repair/threads.c    |    6 ++++++
 scrub/fscounters.c  |   11 ++++++++++-
 scrub/inodes.c      |    5 +++++
 scrub/phase2.c      |    5 +++++
 scrub/phase4.c      |    6 ++++++
 scrub/read_verify.c |    1 +
 scrub/spacemap.c    |    5 +++++
 scrub/vfs.c         |    5 +++++
 10 files changed, 82 insertions(+), 9 deletions(-)


diff --git a/include/workqueue.h b/include/workqueue.h
index c45dc4fb..024ce144 100644
--- a/include/workqueue.h
+++ b/include/workqueue.h
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
 
 #endif	/* _WORKQUEUE_H_ */
diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 24b22bf6..503fe227 100644
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
@@ -160,22 +163,48 @@ workqueue_add(
 
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
+	ret = pthread_mutex_lock(&wq->lock);
+	if (ret)
+		return ret;
+
+	wq->terminate = true;
+	pthread_mutex_unlock(&wq->lock);
+
+	ret = pthread_cond_broadcast(&wq->wakeup);
+	if (ret)
+		return ret;
 
-	pthread_mutex_lock(&wq->lock);
-	wq->terminate = 1;
+	for (i = 0; i < wq->thread_count; i++) {
+		ret = pthread_join(wq->threads[i], NULL);
+		if (ret)
+			return ret;
+	}
+
+	ret = pthread_mutex_lock(&wq->lock);
+	if (ret)
+		return ret;
+
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
index ee07da9e..712a2b37 100644
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
index dcce2df0..ef12a692 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -253,6 +253,11 @@ xfs_scan_all_inodes(
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
index 8c8aad97..6b4755a1 100644
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
index 10199ca1..79c8a6b8 100644
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
index c7e34cf5..7d95ab00 100644
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
index 03d05eed..7fe03163 100644
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
index e5ed5d83..8aa58d6e 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -239,6 +239,11 @@ scan_fs_tree(
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

