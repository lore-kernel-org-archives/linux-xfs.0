Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386B1C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 009A4205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EiZ8dJbx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfIYVkv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:40:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36908 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfIYVkv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:40:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdQkP058410;
        Wed, 25 Sep 2019 21:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Yi07JyyAc7txp19Ifs4RsJ5A0dER2Oy6S9ZP/zjkDR0=;
 b=EiZ8dJbxjzr5yLj1nicEyUjW9nBGeYY7vhFwRX9/edE0xNuMLtwqfEyX2AMUjTPSEuGA
 LE9wUWpyWomHNKu6mYWHxRa0H8nYIIwqxjSFcs2J9mssiwqnU6F6qzgM7m/BdE5CETOb
 qAS2NA/qC+fhkj/6V6o4WVrxw4Gu0/BSlUNi/nRe/OznQ2AApKP8NP0Dg48WuxsUmYxL
 +6aU/BaqVEkO3bGGhiGVP5xF0vc7FekX8OBXXKBCZgJXaUPOCb9LPd134D28e6/ocIqy
 eR4EZPeLZq1bbDU6EGdb+3Y1NeIpof1LYE7QBif04pJCfnheQXLzCgvZOYSuoEkjwI7R tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgr7fmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdOkG033645;
        Wed, 25 Sep 2019 21:40:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuy17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:47 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLekSP017991;
        Wed, 25 Sep 2019 21:40:46 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:40:45 -0700
Subject: [PATCH 7/7] libfrog: convert workqueue.c functions to negative
 error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:40:44 -0700
Message-ID: <156944764443.302827.9383849728654952037.stgit@magnolia>
In-Reply-To: <156944760161.302827.4342305147521200999.stgit@magnolia>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libfrog functions to return negative error codes like libxfs
does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/workqueue.c |   25 +++++++++++++------------
 repair/threads.c    |    6 +++---
 scrub/fscounters.c  |    6 +++---
 scrub/inodes.c      |    6 +++---
 scrub/phase2.c      |    8 ++++----
 scrub/phase4.c      |    6 +++---
 scrub/read_verify.c |    6 +++---
 scrub/spacemap.c    |   10 +++++-----
 scrub/vfs.c         |    6 +++---
 9 files changed, 40 insertions(+), 39 deletions(-)


diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 07f11a7b..2269c413 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -56,7 +56,7 @@ workqueue_thread(void *arg)
 	return NULL;
 }
 
-/* Allocate a work queue and threads. */
+/* Allocate a work queue and threads.  Returns zero or negative error code. */
 int
 workqueue_create(
 	struct workqueue	*wq,
@@ -67,10 +67,10 @@ workqueue_create(
 	int			err = 0;
 
 	memset(wq, 0, sizeof(*wq));
-	err = pthread_cond_init(&wq->wakeup, NULL);
+	err = -pthread_cond_init(&wq->wakeup, NULL);
 	if (err)
 		return err;
-	err = pthread_mutex_init(&wq->lock, NULL);
+	err = -pthread_mutex_init(&wq->lock, NULL);
 	if (err)
 		goto out_cond;
 
@@ -78,14 +78,14 @@ workqueue_create(
 	wq->thread_count = nr_workers;
 	wq->threads = malloc(nr_workers * sizeof(pthread_t));
 	if (!wq->threads) {
-		err = errno;
+		err = -errno;
 		goto out_mutex;
 	}
 	wq->terminate = false;
 	wq->terminated = false;
 
 	for (i = 0; i < nr_workers; i++) {
-		err = pthread_create(&wq->threads[i], NULL, workqueue_thread,
+		err = -pthread_create(&wq->threads[i], NULL, workqueue_thread,
 				wq);
 		if (err)
 			break;
@@ -107,8 +107,9 @@ workqueue_create(
 }
 
 /*
- * Create a work item consisting of a function and some arguments and
- * schedule the work item to be run via the thread pool.
+ * Create a work item consisting of a function and some arguments and schedule
+ * the work item to be run via the thread pool.  Returns zero or a negative
+ * error code.
  */
 int
 workqueue_add(
@@ -129,7 +130,7 @@ workqueue_add(
 
 	wi = malloc(sizeof(struct workqueue_item));
 	if (!wi)
-		return errno;
+		return -errno;
 
 	wi->function = func;
 	wi->index = index;
@@ -141,7 +142,7 @@ workqueue_add(
 	pthread_mutex_lock(&wq->lock);
 	if (wq->next_item == NULL) {
 		assert(wq->item_count == 0);
-		ret = pthread_cond_signal(&wq->wakeup);
+		ret = -pthread_cond_signal(&wq->wakeup);
 		if (ret)
 			goto out_item;
 		wq->next_item = wi;
@@ -160,7 +161,7 @@ workqueue_add(
 
 /*
  * Wait for all pending work items to be processed and tear down the
- * workqueue thread pool.
+ * workqueue thread pool.  Returns zero or a negative error code.
  */
 int
 workqueue_terminate(
@@ -173,12 +174,12 @@ workqueue_terminate(
 	wq->terminate = true;
 	pthread_mutex_unlock(&wq->lock);
 
-	ret = pthread_cond_broadcast(&wq->wakeup);
+	ret = -pthread_cond_broadcast(&wq->wakeup);
 	if (ret)
 		return ret;
 
 	for (i = 0; i < wq->thread_count; i++) {
-		ret = pthread_join(wq->threads[i], NULL);
+		ret = -pthread_join(wq->threads[i], NULL);
 		if (ret)
 			return ret;
 	}
diff --git a/repair/threads.c b/repair/threads.c
index 9b7241e3..45ca2dd5 100644
--- a/repair/threads.c
+++ b/repair/threads.c
@@ -31,7 +31,7 @@ create_work_queue(
 {
 	int			err;
 
-	err = workqueue_create(wq, mp, nworkers);
+	err = -workqueue_create(wq, mp, nworkers);
 	if (err)
 		do_error(_("cannot create worker threads, error = [%d] %s\n"),
 				err, strerror(err));
@@ -46,7 +46,7 @@ queue_work(
 {
 	int			err;
 
-	err = workqueue_add(wq, func, agno, arg);
+	err = -workqueue_add(wq, func, agno, arg);
 	if (err)
 		do_error(_("cannot allocate worker item, error = [%d] %s\n"),
 				err, strerror(err));
@@ -58,7 +58,7 @@ destroy_work_queue(
 {
 	int			err;
 
-	err = workqueue_terminate(wq);
+	err = -workqueue_terminate(wq);
 	if (err)
 		do_error(_("cannot terminate worker item, error = [%d] %s\n"),
 				err, strerror(err));
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index a6b62f34..f9d64f8c 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -86,18 +86,18 @@ scrub_count_all_inodes(
 	if (!ci)
 		return errno;
 
-	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret)
 		goto out_free;
 
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount && !ci->error; agno++) {
-		ret = workqueue_add(&wq, count_ag_inodes, agno, ci);
+		ret = -workqueue_add(&wq, count_ag_inodes, agno, ci);
 		if (ret)
 			break;
 	}
 
-	ret2 = workqueue_terminate(&wq);
+	ret2 = -workqueue_terminate(&wq);
 	if (!ret && ret2)
 		ret = ret2;
 	workqueue_destroy(&wq);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 90d66c45..a0f62250 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -223,7 +223,7 @@ scrub_scan_all_inodes(
 	struct workqueue	wq;
 	int			ret;
 
-	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating bulkstat workqueue"));
@@ -231,7 +231,7 @@ scrub_scan_all_inodes(
 	}
 
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, scan_ag_inodes, agno, &si);
+		ret = -workqueue_add(&wq, scan_ag_inodes, agno, &si);
 		if (ret) {
 			si.aborted = true;
 			str_liberror(ctx, ret, _("queueing bulkstat work"));
@@ -239,7 +239,7 @@ scrub_scan_all_inodes(
 		}
 	}
 
-	ret = workqueue_terminate(&wq);
+	ret = -workqueue_terminate(&wq);
 	if (ret) {
 		si.aborted = true;
 		str_liberror(ctx, ret, _("finishing bulkstat work"));
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 45e0d712..c40d9d3b 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -128,7 +128,7 @@ phase2_func(
 	bool			aborted = false;
 	int			ret, ret2;
 
-	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating scrub workqueue"));
@@ -149,7 +149,7 @@ phase2_func(
 		goto out;
 
 	for (agno = 0; !aborted && agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, scan_ag_metadata, agno, &aborted);
+		ret = -workqueue_add(&wq, scan_ag_metadata, agno, &aborted);
 		if (ret) {
 			str_liberror(ctx, ret, _("queueing per-AG scrub work"));
 			goto out;
@@ -159,14 +159,14 @@ phase2_func(
 	if (aborted)
 		goto out;
 
-	ret = workqueue_add(&wq, scan_fs_metadata, 0, &aborted);
+	ret = -workqueue_add(&wq, scan_fs_metadata, 0, &aborted);
 	if (ret) {
 		str_liberror(ctx, ret, _("queueing per-FS scrub work"));
 		goto out;
 	}
 
 out:
-	ret2 = workqueue_terminate(&wq);
+	ret2 = -workqueue_terminate(&wq);
 	if (ret2) {
 		str_liberror(ctx, ret2, _("finishing scrub work"));
 		if (!ret && ret2)
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 50c2dbb8..b4fc6406 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -70,7 +70,7 @@ repair_everything(
 	bool				aborted = false;
 	int				ret;
 
-	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating repair workqueue"));
@@ -80,14 +80,14 @@ repair_everything(
 		if (action_list_length(&ctx->action_lists[agno]) == 0)
 			continue;
 
-		ret = workqueue_add(&wq, repair_ag, agno, &aborted);
+		ret = -workqueue_add(&wq, repair_ag, agno, &aborted);
 		if (ret) {
 			str_liberror(ctx, ret, _("queueing repair work"));
 			break;
 		}
 	}
 
-	ret = workqueue_terminate(&wq);
+	ret = -workqueue_terminate(&wq);
 	if (ret)
 		str_liberror(ctx, ret, _("finishing repair work"));
 	workqueue_destroy(&wq);
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index b7e9eb91..58e4e951 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -119,7 +119,7 @@ read_verify_pool_alloc(
 			&rvp->rvstate);
 	if (ret)
 		goto out_counter;
-	ret = workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
+	ret = -workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
 			verifier_threads == 1 ? 0 : verifier_threads);
 	if (ret)
 		goto out_rvstate;
@@ -152,7 +152,7 @@ int
 read_verify_pool_flush(
 	struct read_verify_pool		*rvp)
 {
-	return workqueue_terminate(&rvp->wq);
+	return -workqueue_terminate(&rvp->wq);
 }
 
 /* Finish up any read verification work and tear it down. */
@@ -299,7 +299,7 @@ read_verify_queue(
 
 	memcpy(tmp, rv, sizeof(*tmp));
 
-	ret = workqueue_add(&rvp->wq, read_verify, 0, tmp);
+	ret = -workqueue_add(&rvp->wq, read_verify, 0, tmp);
 	if (ret) {
 		free(tmp);
 		rvp->errors_seen = ret;
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index e56f090d..d427049f 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -203,14 +203,14 @@ scrub_scan_all_spacemaps(
 	xfs_agnumber_t		agno;
 	int			ret;
 
-	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating fsmap workqueue"));
 		return ret;
 	}
 	if (ctx->fsinfo.fs_rt) {
-		ret = workqueue_add(&wq, scan_rt_rmaps,
+		ret = -workqueue_add(&wq, scan_rt_rmaps,
 				ctx->mnt.fsgeom.agcount + 1, &sbx);
 		if (ret) {
 			sbx.aborted = true;
@@ -219,7 +219,7 @@ scrub_scan_all_spacemaps(
 		}
 	}
 	if (ctx->fsinfo.fs_log) {
-		ret = workqueue_add(&wq, scan_log_rmaps,
+		ret = -workqueue_add(&wq, scan_log_rmaps,
 				ctx->mnt.fsgeom.agcount + 2, &sbx);
 		if (ret) {
 			sbx.aborted = true;
@@ -228,7 +228,7 @@ scrub_scan_all_spacemaps(
 		}
 	}
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, scan_ag_rmaps, agno, &sbx);
+		ret = -workqueue_add(&wq, scan_ag_rmaps, agno, &sbx);
 		if (ret) {
 			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing per-AG fsmap work"));
@@ -236,7 +236,7 @@ scrub_scan_all_spacemaps(
 		}
 	}
 out:
-	ret = workqueue_terminate(&wq);
+	ret = -workqueue_terminate(&wq);
 	if (ret) {
 		sbx.aborted = true;
 		str_liberror(ctx, ret, _("finishing fsmap work"));
diff --git a/scrub/vfs.c b/scrub/vfs.c
index c807c9b9..76920923 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -97,7 +97,7 @@ queue_subdir(
 	new_sftd->rootdir = is_rootdir;
 
 	inc_nr_dirs(sft);
-	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
+	error = -workqueue_add(wq, scan_fs_dir, 0, new_sftd);
 	if (error) {
 		dec_nr_dirs(sft);
 		str_liberror(ctx, error, _("queueing directory scan work"));
@@ -242,7 +242,7 @@ scan_fs_tree(
 		goto out_mutex;
 	}
 
-	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating directory scan workqueue"));
@@ -268,7 +268,7 @@ scan_fs_tree(
 	assert(sft.nr_dirs == 0);
 	pthread_mutex_unlock(&sft.lock);
 
-	ret = workqueue_terminate(&wq);
+	ret = -workqueue_terminate(&wq);
 	if (ret) {
 		str_liberror(ctx, ret, _("finishing directory scan work"));
 		goto out_wq;

