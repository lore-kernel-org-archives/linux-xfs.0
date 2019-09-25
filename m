Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4027C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CD6221D82
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TBUY6qne"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfIYVfv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:35:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60090 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfIYVfu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:35:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYUSR054868;
        Wed, 25 Sep 2019 21:35:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=WkbcaJHkS8rdDMhvUiKpSlk5IADFevQ33FKLAbeCXSk=;
 b=TBUY6qneo8AB23K7bJVm4HTYxehZIS3uzJLb+TuCLv9nMRTiS/72q3rWf5kNzv6b5dew
 zMefsewNrZMm3duaWevBcQwFh3+rq24jG2nx8ti+Jg679Mr6vdL6sHpoYczyvh7toIch
 z6IFAjFYs3vDAu5wG24HLPWCgUxCfapRf02DiABh4HTC1ymcK2NFAyJ4awiQSuWhePaU
 FA/FhdaPJpRRZvA66aT1Nc/RlG1vg4LPoKWXJojJuwnZTxSXIOU3irmwEJGicELshIzO
 uYF9k+UqDgS9NorCXd8iYKmztTYsmgtlb1TULq92bREG7Ay+rebZzPktiBHJjxDqpOT6 Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v5cgr7f17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYTd3078901;
        Wed, 25 Sep 2019 21:35:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2v82tkreqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLXtff014743;
        Wed, 25 Sep 2019 21:33:55 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:33:55 -0700
Subject: [PATCH 05/13] libfrog: fix per-thread variable error communication
 problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:33:53 -0700
Message-ID: <156944723373.297677.14195377254199450505.stgit@magnolia>
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

Convert all the per-thread variable functions away from the libc-style
indirect errno return to return error values directly to callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/ptvar.c     |   26 +++++++++++++++-----------
 libfrog/ptvar.h     |    8 ++++----
 scrub/counter.c     |   13 ++++++++-----
 scrub/phase7.c      |   24 ++++++++++++++++--------
 scrub/read_verify.c |   16 +++++++++++-----
 5 files changed, 54 insertions(+), 33 deletions(-)


diff --git a/libfrog/ptvar.c b/libfrog/ptvar.c
index c9296835..6cb58208 100644
--- a/libfrog/ptvar.c
+++ b/libfrog/ptvar.c
@@ -33,11 +33,12 @@ struct ptvar {
 };
 #define PTVAR_SIZE(nr, sz) (sizeof(struct ptvar) + ((nr) * (size)))
 
-/* Initialize per-thread counter. */
-struct ptvar *
-ptvar_init(
+/* Allocate a new per-thread counter. */
+int
+ptvar_alloc(
 	size_t		nr,
-	size_t		size)
+	size_t		size,
+	struct ptvar	**pptv)
 {
 	struct ptvar	*ptv;
 	int		ret;
@@ -49,7 +50,7 @@ ptvar_init(
 
 	ptv = malloc(PTVAR_SIZE(nr, size));
 	if (!ptv)
-		return NULL;
+		return errno;
 	ptv->data_size = size;
 	ptv->nr_counters = nr;
 	ptv->nr_used = 0;
@@ -60,13 +61,14 @@ ptvar_init(
 	ret = pthread_key_create(&ptv->key, NULL);
 	if (ret)
 		goto out_mutex;
-	return ptv;
 
+	*pptv = ptv;
+	return 0;
 out_mutex:
 	pthread_mutex_destroy(&ptv->lock);
 out:
 	free(ptv);
-	return NULL;
+	return ret;
 }
 
 /* Free per-thread counter. */
@@ -82,7 +84,8 @@ ptvar_free(
 /* Get a reference to this thread's variable. */
 void *
 ptvar_get(
-	struct ptvar	*ptv)
+	struct ptvar	*ptv,
+	int		*retp)
 {
 	void		*p;
 
@@ -94,23 +97,24 @@ ptvar_get(
 		pthread_setspecific(ptv->key, p);
 		pthread_mutex_unlock(&ptv->lock);
 	}
+	*retp = 0;
 	return p;
 }
 
 /* Iterate all of the per-thread variables. */
-bool
+int
 ptvar_foreach(
 	struct ptvar	*ptv,
 	ptvar_iter_fn	fn,
 	void		*foreach_arg)
 {
 	size_t		i;
-	bool		ret = true;
+	int		ret;
 
 	pthread_mutex_lock(&ptv->lock);
 	for (i = 0; i < ptv->nr_used; i++) {
 		ret = fn(ptv, &ptv->data[i * ptv->data_size], foreach_arg);
-		if (!ret)
+		if (ret)
 			break;
 	}
 	pthread_mutex_unlock(&ptv->lock);
diff --git a/libfrog/ptvar.h b/libfrog/ptvar.h
index a8803c64..42865c0b 100644
--- a/libfrog/ptvar.h
+++ b/libfrog/ptvar.h
@@ -8,11 +8,11 @@
 
 struct ptvar;
 
-typedef bool (*ptvar_iter_fn)(struct ptvar *ptv, void *data, void *foreach_arg);
+typedef int (*ptvar_iter_fn)(struct ptvar *ptv, void *data, void *foreach_arg);
 
-struct ptvar *ptvar_init(size_t nr, size_t size);
+int ptvar_alloc(size_t nr, size_t size, struct ptvar **pptv);
 void ptvar_free(struct ptvar *ptv);
-void *ptvar_get(struct ptvar *ptv);
-bool ptvar_foreach(struct ptvar *ptv, ptvar_iter_fn fn, void *foreach_arg);
+void *ptvar_get(struct ptvar *ptv, int *ret);
+int ptvar_foreach(struct ptvar *ptv, ptvar_iter_fn fn, void *foreach_arg);
 
 #endif /* __LIBFROG_PTVAR_H__ */
diff --git a/scrub/counter.c b/scrub/counter.c
index 43444927..49ffbfea 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -32,12 +32,13 @@ ptcounter_init(
 	size_t			nr)
 {
 	struct ptcounter	*p;
+	int			ret;
 
 	p = malloc(sizeof(struct ptcounter));
 	if (!p)
 		return NULL;
-	p->var = ptvar_init(nr, sizeof(uint64_t));
-	if (!p->var) {
+	ret = ptvar_alloc(nr, sizeof(uint64_t), &p->var);
+	if (ret) {
 		free(p);
 		return NULL;
 	}
@@ -60,12 +61,14 @@ ptcounter_add(
 	int64_t			nr)
 {
 	uint64_t		*p;
+	int			ret;
 
-	p = ptvar_get(ptc->var);
+	p = ptvar_get(ptc->var, &ret);
+	assert(ret == 0);
 	*p += nr;
 }
 
-static bool
+static int
 ptcounter_val_helper(
 	struct ptvar		*ptv,
 	void			*data,
@@ -75,7 +78,7 @@ ptcounter_val_helper(
 	uint64_t		*count = data;
 
 	*sum += *count;
-	return true;
+	return 0;
 }
 
 /* Return the approximate value of this counter. */
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 308b8bb3..bc959f5b 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -36,8 +36,13 @@ xfs_record_block_summary(
 {
 	struct summary_counts	*counts;
 	unsigned long long	len;
+	int			ret;
 
-	counts = ptvar_get((struct ptvar *)arg);
+	counts = ptvar_get((struct ptvar *)arg, &ret);
+	if (ret) {
+		str_liberror(ctx, ret, _("retrieving summary counts"));
+		return false;
+	}
 	if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
 		return true;
 	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
@@ -68,7 +73,7 @@ xfs_record_block_summary(
 }
 
 /* Add all the summaries in the per-thread counter */
-static bool
+static int
 xfs_add_summaries(
 	struct ptvar		*ptv,
 	void			*data,
@@ -80,7 +85,7 @@ xfs_add_summaries(
 	total->dbytes += item->dbytes;
 	total->rbytes += item->rbytes;
 	total->agbytes += item->agbytes;
-	return true;
+	return 0;
 }
 
 /*
@@ -131,9 +136,10 @@ xfs_scan_summary(
 		return false;
 	}
 
-	ptvar = ptvar_init(scrub_nproc(ctx), sizeof(struct summary_counts));
-	if (!ptvar) {
-		str_errno(ctx, ctx->mntpoint);
+	error = ptvar_alloc(scrub_nproc(ctx), sizeof(struct summary_counts),
+			&ptvar);
+	if (error) {
+		str_liberror(ctx, error, _("setting up block counter"));
 		return false;
 	}
 
@@ -141,9 +147,11 @@ xfs_scan_summary(
 	moveon = xfs_scan_all_spacemaps(ctx, xfs_record_block_summary, ptvar);
 	if (!moveon)
 		goto out_free;
-	moveon = ptvar_foreach(ptvar, xfs_add_summaries, &totalcount);
-	if (!moveon)
+	error = ptvar_foreach(ptvar, xfs_add_summaries, &totalcount);
+	if (error) {
+		str_liberror(ctx, error, _("counting blocks"));
 		goto out_free;
+	}
 	ptvar_free(ptvar);
 
 	/* Scan the whole fs. */
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index e59d3e67..95987a9b 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -91,9 +91,9 @@ read_verify_pool_init(
 	rvp->ctx = ctx;
 	rvp->disk = disk;
 	rvp->ioerr_fn = ioerr_fn;
-	rvp->rvstate = ptvar_init(submitter_threads,
-			sizeof(struct read_verify));
-	if (rvp->rvstate == NULL)
+	error = ptvar_alloc(submitter_threads, sizeof(struct read_verify),
+			&rvp->rvstate);
+	if (error)
 		goto out_counter;
 	/* Run in the main thread if we only want one thread. */
 	if (nproc == 1)
@@ -220,9 +220,12 @@ read_verify_schedule_io(
 	struct read_verify		*rv;
 	uint64_t			req_end;
 	uint64_t			rv_end;
+	int				ret;
 
 	assert(rvp->readbuf);
-	rv = ptvar_get(rvp->rvstate);
+	rv = ptvar_get(rvp->rvstate, &ret);
+	if (ret)
+		return false;
 	req_end = start + length;
 	rv_end = rv->io_start + rv->io_length;
 
@@ -259,9 +262,12 @@ read_verify_force_io(
 {
 	struct read_verify		*rv;
 	bool				moveon;
+	int				ret;
 
 	assert(rvp->readbuf);
-	rv = ptvar_get(rvp->rvstate);
+	rv = ptvar_get(rvp->rvstate, &ret);
+	if (ret)
+		return false;
 	if (rv->io_length == 0)
 		return true;
 

