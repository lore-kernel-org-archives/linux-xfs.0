Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BD8CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B2DE21872
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:53:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g5ViDYEs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbfJVSxF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:53:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56382 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387791AbfJVSxF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:53:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiQNZ091102;
        Tue, 22 Oct 2019 18:53:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=14o45CN5K+jvceA87eRccVHTjJAiCc/54SPVGNKNEeU=;
 b=g5ViDYEsYg+K5MaYKvHOie02dagPYTQ2RcCytU81Ef27BYR+lCaAr/fBfxosssW28qmQ
 OEmAMASZzqQPQ/Ajhbs3Pc1NwCHuGzukVyysfAO7O9b34Ca2VJ+jGk79RZ5AXuu/azB7
 PLKz7aMHgbSJ6beGEDgAtb5NwOpRLY5YWC2ZHn7jOBj6y8lFVz7uYynNKTL5f16ZNvjl
 MKCgjfsUAPCJu9FfbzMcxvXU11raIl6Nyq8PsaK1HPUmbBB2I2XL3O67y5NiFtB7IXNb
 kTAUkAjJw23sFMbnLg6mrXtBg5iGo1W2tG4mvYjwfqyjznMJ/X3MxlVhuJhhKFB6gUYh HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqteprrwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:53:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhkpJ148073;
        Tue, 22 Oct 2019 18:53:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vsp401anc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:53:00 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIqxx8000840;
        Tue, 22 Oct 2019 18:52:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:52:58 -0700
Subject: [PATCH 5/7] libfrog: convert ptvar.c functions to negative error
 codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Tue, 22 Oct 2019 11:52:57 -0700
Message-ID: <157177037791.1462916.16575122338312777960.stgit@magnolia>
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
 libfrog/ptvar.c     |    8 ++++----
 scrub/counter.c     |    6 +++---
 scrub/descr.c       |    2 +-
 scrub/phase7.c      |    8 ++++----
 scrub/read_verify.c |    8 ++++----
 5 files changed, 16 insertions(+), 16 deletions(-)


diff --git a/libfrog/ptvar.c b/libfrog/ptvar.c
index f375df3a..7ac8c541 100644
--- a/libfrog/ptvar.c
+++ b/libfrog/ptvar.c
@@ -54,15 +54,15 @@ ptvar_alloc(
 
 	ptv = malloc(PTVAR_SIZE(nr, size));
 	if (!ptv)
-		return errno;
+		return -errno;
 	ptv->data_size = size;
 	ptv->nr_counters = nr;
 	ptv->nr_used = 0;
 	memset(ptv->data, 0, nr * size);
-	ret = pthread_mutex_init(&ptv->lock, NULL);
+	ret = -pthread_mutex_init(&ptv->lock, NULL);
 	if (ret)
 		goto out;
-	ret = pthread_key_create(&ptv->key, NULL);
+	ret = -pthread_key_create(&ptv->key, NULL);
 	if (ret)
 		goto out_mutex;
 
@@ -99,7 +99,7 @@ ptvar_get(
 		pthread_mutex_lock(&ptv->lock);
 		assert(ptv->nr_used < ptv->nr_counters);
 		p = &ptv->data[(ptv->nr_used++) * ptv->data_size];
-		ret = pthread_setspecific(ptv->key, p);
+		ret = -pthread_setspecific(ptv->key, p);
 		if (ret)
 			goto out_unlock;
 		pthread_mutex_unlock(&ptv->lock);
diff --git a/scrub/counter.c b/scrub/counter.c
index 1bb726dc..6d91eb6e 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -38,7 +38,7 @@ ptcounter_alloc(
 	p = malloc(sizeof(struct ptcounter));
 	if (!p)
 		return errno;
-	ret = ptvar_alloc(nr, sizeof(uint64_t), &p->var);
+	ret = -ptvar_alloc(nr, sizeof(uint64_t), &p->var);
 	if (ret) {
 		free(p);
 		return ret;
@@ -67,7 +67,7 @@ ptcounter_add(
 
 	p = ptvar_get(ptc->var, &ret);
 	if (ret)
-		return ret;
+		return -ret;
 	*p += nr;
 	return 0;
 }
@@ -92,5 +92,5 @@ ptcounter_value(
 	uint64_t		*sum)
 {
 	*sum = 0;
-	return ptvar_foreach(ptc->var, ptcounter_val_helper, sum);
+	return -ptvar_foreach(ptc->var, ptcounter_val_helper, sum);
 }
diff --git a/scrub/descr.c b/scrub/descr.c
index 7f65a4e0..a863c065 100644
--- a/scrub/descr.c
+++ b/scrub/descr.c
@@ -89,7 +89,7 @@ descr_init_phase(
 	int			ret;
 
 	assert(descr_ptvar == NULL);
-	ret = ptvar_alloc(nr_threads, DESCR_BUFSZ, &descr_ptvar);
+	ret = -ptvar_alloc(nr_threads, DESCR_BUFSZ, &descr_ptvar);
 	if (ret)
 		str_liberror(ctx, ret, _("creating description buffer"));
 
diff --git a/scrub/phase7.c b/scrub/phase7.c
index f25a8765..f8410439 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -39,8 +39,8 @@ count_block_summary(
 
 	counts = ptvar_get((struct ptvar *)arg, &ret);
 	if (ret) {
-		str_liberror(ctx, ret, _("retrieving summary counts"));
-		return ret;
+		str_liberror(ctx, -ret, _("retrieving summary counts"));
+		return -ret;
 	}
 	if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
 		return 0;
@@ -135,7 +135,7 @@ phase7_func(
 		return error;
 	}
 
-	error = ptvar_alloc(scrub_nproc(ctx), sizeof(struct summary_counts),
+	error = -ptvar_alloc(scrub_nproc(ctx), sizeof(struct summary_counts),
 			&ptvar);
 	if (error) {
 		str_liberror(ctx, error, _("setting up block counter"));
@@ -146,7 +146,7 @@ phase7_func(
 	error = scrub_scan_all_spacemaps(ctx, count_block_summary, ptvar);
 	if (error)
 		goto out_free;
-	error = ptvar_foreach(ptvar, add_summaries, &totalcount);
+	error = -ptvar_foreach(ptvar, add_summaries, &totalcount);
 	if (error) {
 		str_liberror(ctx, error, _("counting blocks"));
 		goto out_free;
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 82605c8c..bfee3a66 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -119,7 +119,7 @@ read_verify_pool_alloc(
 	rvp->ctx = ctx;
 	rvp->disk = disk;
 	rvp->ioerr_fn = ioerr_fn;
-	ret = ptvar_alloc(submitter_threads, sizeof(struct read_verify),
+	ret = -ptvar_alloc(submitter_threads, sizeof(struct read_verify),
 			&rvp->rvstate);
 	if (ret)
 		goto out_counter;
@@ -338,7 +338,7 @@ read_verify_schedule_io(
 
 	rv = ptvar_get(rvp->rvstate, &ret);
 	if (ret)
-		return ret;
+		return -ret;
 	req_end = start + length;
 	rv_end = rv->io_start + rv->io_length;
 
@@ -386,7 +386,7 @@ force_one_io(
 	if (rv->io_length == 0)
 		return 0;
 
-	return read_verify_queue(rvp, rv);
+	return -read_verify_queue(rvp, rv);
 }
 
 /* Force any stashed IOs into the verifier. */
@@ -396,7 +396,7 @@ read_verify_force_io(
 {
 	assert(rvp->readbuf);
 
-	return ptvar_foreach(rvp->rvstate, force_one_io, rvp);
+	return -ptvar_foreach(rvp->rvstate, force_one_io, rvp);
 }
 
 /* How many bytes has this process verified? */

