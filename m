Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A76C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8C62186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XRpvc8s2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbfHZV30 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:29:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48900 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV30 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:29:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLEqee161918;
        Mon, 26 Aug 2019 21:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=NnBrRSsM08n2PZatfIagb1iyvnUqd2XnP7pSVrCkzsU=;
 b=XRpvc8s2tnkW+zGZciZtW3utBFt3q75YUi4mi7vvEpDi5o7zY8J8VcVSYzP3tUXKjRVN
 P8yoIDivnOEyMBFrwWDIvnt2MsHkty7JMiG/Xx8uRdhooS+wc/3DofMYLrxTX8fUoa7m
 AtOofEe/pwZbzsSAkM5903Xj/XHPIGPG2G4lmBSrBl2Z6X1ptFSiHZ2EknXfzvWf0DOY
 aK3rlhh3abdni83Qf9HxiLnLAwMMWYuZ4sZY3s+2dqFnAowiX6zX0HLPaoBzdPh5YiKP
 vNxnY2DilncSY4cA0gJC3AdDYNxGb2L/1YojJNUU3q/HO3Uh1RHxj/XbX8B20LXZmw6Y IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2umq5t823x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIQck024952;
        Mon, 26 Aug 2019 21:29:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2umj1tk5xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:23 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLTN3N028717;
        Mon, 26 Aug 2019 21:29:23 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:29:22 -0700
Subject: [PATCH 09/13] xfs_scrub: fix per-thread counter error communication
 problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:29:21 -0700
Message-ID: <156685496182.2841546.117921668752691817.stgit@magnolia>
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

Fix all the places in the per-thread counter functions either we fail to
check for runtime errors or fail to communicate them properly to
callers.  Then fix all the callers to report the error messages instead
of hiding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/counter.c     |   33 ++++++++++++++++++---------------
 scrub/counter.h     |    6 +++---
 scrub/phase3.c      |   23 +++++++++++++++++------
 scrub/progress.c    |   12 +++++++++---
 scrub/read_verify.c |    9 ++++++---
 5 files changed, 53 insertions(+), 30 deletions(-)


diff --git a/scrub/counter.c b/scrub/counter.c
index 76a40532..54bdbb03 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -26,23 +26,25 @@ struct ptcounter {
 	struct ptvar	*var;
 };
 
-/* Initialize per-thread counter. */
-struct ptcounter *
-ptcounter_init(
-	size_t			nr)
+/* Allocate per-thread counter. */
+int
+ptcounter_alloc(
+	size_t			nr,
+	struct ptcounter	**pp)
 {
 	struct ptcounter	*p;
 	int			ret;
 
 	p = malloc(sizeof(struct ptcounter));
 	if (!p)
-		return NULL;
+		return errno;
 	ret = ptvar_alloc(nr, sizeof(uint64_t), &p->var);
 	if (ret) {
 		free(p);
-		return NULL;
+		return ret;
 	}
-	return p;
+	*pp = p;
+	return 0;
 }
 
 /* Free per-thread counter. */
@@ -55,7 +57,7 @@ ptcounter_free(
 }
 
 /* Add a quantity to the counter. */
-void
+int
 ptcounter_add(
 	struct ptcounter	*ptc,
 	int64_t			nr)
@@ -64,8 +66,10 @@ ptcounter_add(
 	int			ret;
 
 	p = ptvar_get(ptc->var, &ret);
-	assert(ret == 0);
+	if (ret)
+		return ret;
 	*p += nr;
+	return 0;
 }
 
 static int
@@ -82,12 +86,11 @@ ptcounter_val_helper(
 }
 
 /* Return the approximate value of this counter. */
-uint64_t
+int
 ptcounter_value(
-	struct ptcounter	*ptc)
+	struct ptcounter	*ptc,
+	uint64_t		*sum)
 {
-	uint64_t		sum = 0;
-
-	ptvar_foreach(ptc->var, ptcounter_val_helper, &sum);
-	return sum;
+	*sum = 0;
+	return ptvar_foreach(ptc->var, ptcounter_val_helper, sum);
 }
diff --git a/scrub/counter.h b/scrub/counter.h
index 6c501b85..01b65056 100644
--- a/scrub/counter.h
+++ b/scrub/counter.h
@@ -7,9 +7,9 @@
 #define XFS_SCRUB_COUNTER_H_
 
 struct ptcounter;
-struct ptcounter *ptcounter_init(size_t nr);
+int ptcounter_alloc(size_t nr, struct ptcounter **pp);
 void ptcounter_free(struct ptcounter *ptc);
-void ptcounter_add(struct ptcounter *ptc, int64_t nr);
-uint64_t ptcounter_value(struct ptcounter *ptc);
+int ptcounter_add(struct ptcounter *ptc, int64_t nr);
+int ptcounter_value(struct ptcounter *ptc, uint64_t *sum);
 
 #endif /* XFS_SCRUB_COUNTER_H_ */
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 7f1c528a..399f0e92 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -139,7 +139,12 @@ xfs_scrub_inode(
 		goto out;
 
 out:
-	ptcounter_add(icount, 1);
+	error = ptcounter_add(icount, 1);
+	if (error) {
+		str_liberror(ctx, error,
+				_("incrementing scanned inode counter"));
+		return false;
+	}
 	progress_add(1);
 	xfs_action_list_defer(ctx, agno, &alist);
 	if (fd >= 0) {
@@ -158,12 +163,14 @@ xfs_scan_inodes(
 	struct scrub_ctx	*ctx)
 {
 	struct scrub_inode_ctx	ictx;
+	uint64_t		val;
+	int			err;
 	bool			ret;
 
 	ictx.moveon = true;
-	ictx.icount = ptcounter_init(scrub_nproc(ctx));
-	if (!ictx.icount) {
-		str_info(ctx, ctx->mntpoint, _("Could not create counter."));
+	err = ptcounter_alloc(scrub_nproc(ctx), &ictx.icount);
+	if (err) {
+		str_liberror(ctx, err, _("creating scanned inode counter"));
 		return false;
 	}
 
@@ -173,8 +180,12 @@ xfs_scan_inodes(
 	if (!ictx.moveon)
 		goto free;
 	xfs_scrub_report_preen_triggers(ctx);
-	ctx->inodes_checked = ptcounter_value(ictx.icount);
-
+	err = ptcounter_value(ictx.icount, &val);
+	if (err) {
+		str_liberror(ctx, err, _("summing scanned inode counter"));
+		return false;
+	}
+	ctx->inodes_checked = val;
 free:
 	ptcounter_free(ictx.icount);
 	return ictx.moveon;
diff --git a/scrub/progress.c b/scrub/progress.c
index d0afe90a..e5ea1e90 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -119,6 +119,8 @@ progress_report_thread(void *arg)
 
 	pthread_mutex_lock(&pt.lock);
 	while (1) {
+		uint64_t	progress_val;
+
 		/* Every half second. */
 		ret = clock_gettime(CLOCK_REALTIME, &abstime);
 		if (ret)
@@ -131,7 +133,9 @@ progress_report_thread(void *arg)
 		pthread_cond_timedwait(&pt.wakeup, &pt.lock, &abstime);
 		if (pt.terminate)
 			break;
-		progress_report(ptcounter_value(pt.ptc));
+		ret = ptcounter_value(pt.ptc, &progress_val);
+		if (!ret)
+			progress_report(progress_val);
 	}
 	pthread_mutex_unlock(&pt.lock);
 	return NULL;
@@ -187,9 +191,11 @@ progress_init_phase(
 	pt.twiddle = 0;
 	pt.terminate = false;
 
-	pt.ptc = ptcounter_init(nr_threads);
-	if (!pt.ptc)
+	ret = ptcounter_alloc(nr_threads, &pt.ptc);
+	if (ret) {
+		str_liberror(ctx, ret, _("allocating progress counter"));
 		goto out_max;
+	}
 
 	ret = pthread_create(&pt.thread, NULL, progress_report_thread, NULL);
 	if (ret)
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 2cd4edfa..425342b4 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -84,8 +84,8 @@ read_verify_pool_init(
 			RVP_IO_MAX_SIZE);
 	if (error || !rvp->readbuf)
 		goto out_free;
-	rvp->verified_bytes = ptcounter_init(nproc);
-	if (!rvp->verified_bytes)
+	error = ptcounter_alloc(nproc, &rvp->verified_bytes);
+	if (error)
 		goto out_buf;
 	rvp->miniosz = miniosz;
 	rvp->ctx = ctx;
@@ -282,5 +282,8 @@ uint64_t
 read_verify_bytes(
 	struct read_verify_pool		*rvp)
 {
-	return ptcounter_value(rvp->verified_bytes);
+	uint64_t			ret;
+
+	ptcounter_value(rvp->verified_bytes, &ret);
+	return ret;
 }

