Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5ABFCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CF3F20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KxdBTScT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbfJVSxT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:53:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53952 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388066AbfJVSxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:53:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiBOc089151;
        Tue, 22 Oct 2019 18:53:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=awVe2DE+Sc7Ta++Vj6Oagp3yYy09jPDvtoyzlpkjeuQ=;
 b=KxdBTScTPLuN8Apxg0KAJan6YdxeT+5jEX9NcHE1WUy/ZubBS3jE1VpNyvOMwdRWS+MV
 /mLSwoUUK1ntoiVKik3rRMcok4ZYK3xKv4dLKQqBhy01eRZPvHxUQNS53oKy9qj1okLE
 2yXviWh/z3H1kN1Qy4Ej4jDswX095Ys5xS5CS4RIT+NkhG8obxBmMbQTnaUABKuFM3bx
 enrKu4M4TNCyF7bAWkMA5WLd4/g/R27qqrHGk8RLxIMWdCQCAtlArpqkvVUrdJNDqxVO
 o21NEKbXLF4obpfcxTbevVowsYJ1T73aTU6JZzl+6ylto8Mm8Zk9rutcvp4nnIB7zeme cQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vqu4qrm0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:53:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiL3K070447;
        Tue, 22 Oct 2019 18:53:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vsx2rkxc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:53:13 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIrBGX005979;
        Tue, 22 Oct 2019 18:53:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:53:11 -0700
Subject: [PATCH 7/7] libfrog: convert workqueue.c functions to negative
 error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Tue, 22 Oct 2019 11:53:10 -0700
Message-ID: <157177039067.1462916.13652529629535421600.stgit@magnolia>
In-Reply-To: <157177034582.1462916.12588287391821422188.stgit@magnolia>
References: <157177034582.1462916.12588287391821422188.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libfrog functions to return negative error codes like libxfs
does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index a93bba3d..fe3de428 100644
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
 		if (ret) {
 			pthread_mutex_unlock(&wq->lock);
 			free(wi);
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
index e1fafc9f..099489d8 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -232,7 +232,7 @@ scrub_scan_all_inodes(
 	struct workqueue	wq;
 	int			ret;
 
-	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
+	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating bulkstat workqueue"));
@@ -240,7 +240,7 @@ scrub_scan_all_inodes(
 	}
 
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, scan_ag_inodes, agno, &si);
+		ret = -workqueue_add(&wq, scan_ag_inodes, agno, &si);
 		if (ret) {
 			si.aborted = true;
 			str_liberror(ctx, ret, _("queueing bulkstat work"));
@@ -248,7 +248,7 @@ scrub_scan_all_inodes(
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
index 1c1de906..af9b493e 100644
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
index bfee3a66..be30f268 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -123,7 +123,7 @@ read_verify_pool_alloc(
 			&rvp->rvstate);
 	if (ret)
 		goto out_counter;
-	ret = workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
+	ret = -workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,
 			verifier_threads == 1 ? 0 : verifier_threads);
 	if (ret)
 		goto out_rvstate;
@@ -156,7 +156,7 @@ int
 read_verify_pool_flush(
 	struct read_verify_pool		*rvp)
 {
-	return workqueue_terminate(&rvp->wq);
+	return -workqueue_terminate(&rvp->wq);
 }
 
 /* Finish up any read verification work and tear it down. */
@@ -303,7 +303,7 @@ read_verify_queue(
 
 	memcpy(tmp, rv, sizeof(*tmp));
 
-	ret = workqueue_add(&rvp->wq, read_verify, 0, tmp);
+	ret = -workqueue_add(&rvp->wq, read_verify, 0, tmp);
 	if (ret) {
 		free(tmp);
 		rvp->runtime_error = ret;
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

