Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDE1CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E735F20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UnvbJNGv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbfJVSwI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:52:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732564AbfJVSwI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:52:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiRfJ109610;
        Tue, 22 Oct 2019 18:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nVy87dfq86TLdO1khKxSxJVFpb5TTwiel/D3+7L414I=;
 b=UnvbJNGv+mqrTM7bIzXObtUSuf0y0hBeSqWqyBG6ehs83f9srs9bQYYfsS72+1c2hJ9F
 CYRl1muX+Q7tBYmuItvH8LR1krMspG+ULHiV79Lbwcm+5qzt9+GKc+g2Ge2sM69mvOu1
 ALWrPFF6aqFl/lUt2oF3jZssFiei8NR1nmvQJtzFoj6sF0P3fqexLwbV4OdvpdkRB4eC
 2pJUnxWo00vkZ7Wfyu4Kohk3Ik51J9T2jTd4k2dnmRQNN+QZBnWXp5638qPsGexya/xM
 WZqWtNOUMElGNJeasmLY+YCV2SMvP5+N/Nj6Tta516aYn98OZzueBVCH2DW35w55lFkp 0g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswtgvfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiNbY070477;
        Tue, 22 Oct 2019 18:52:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vsx2rkucu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:05 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIq4xn005292;
        Tue, 22 Oct 2019 18:52:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:52:04 -0700
Subject: [PATCH 15/18] xfs_scrub: remove moveon from phase 2 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:52:03 -0700
Message-ID: <157177032323.1461658.21686041578460153.stgit@magnolia>
In-Reply-To: <157177022106.1461658.18024534947316119946.stgit@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the phase 2 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase2.c |   88 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 33 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 7388b8e2..81b2b3dc 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -19,13 +19,13 @@
 
 /* Scrub each AG's metadata btrees. */
 static void
-xfs_scan_ag_metadata(
+scan_ag_metadata(
 	struct workqueue		*wq,
 	xfs_agnumber_t			agno,
 	void				*arg)
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*pmoveon = arg;
+	bool				*aborted = arg;
 	struct action_list		alist;
 	struct action_list		immediate_alist;
 	unsigned long long		broken_primaries;
@@ -33,6 +33,9 @@ xfs_scan_ag_metadata(
 	char				descr[DESCR_BUFSZ];
 	int				ret;
 
+	if (*aborted)
+		return;
+
 	action_list_init(&alist);
 	action_list_init(&immediate_alist);
 	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
@@ -84,48 +87,52 @@ _("Filesystem might not be repairable."));
 
 	/* Everything else gets fixed during phase 4. */
 	action_list_defer(ctx, agno, &alist);
-
 	return;
 err:
-	*pmoveon = false;
+	*aborted = true;
 }
 
 /* Scrub whole-FS metadata btrees. */
 static void
-xfs_scan_fs_metadata(
+scan_fs_metadata(
 	struct workqueue		*wq,
 	xfs_agnumber_t			agno,
 	void				*arg)
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*pmoveon = arg;
+	bool				*aborted = arg;
 	struct action_list		alist;
 	int				ret;
 
+	if (*aborted)
+		return;
+
 	action_list_init(&alist);
 	ret = xfs_scrub_fs_metadata(ctx, &alist);
-	if (ret)
-		*pmoveon = false;
+	if (ret) {
+		*aborted = true;
+		return;
+	}
 
 	action_list_defer(ctx, agno, &alist);
 }
 
 /* Scan all filesystem metadata. */
-bool
-xfs_scan_metadata(
+int
+phase2_func(
 	struct scrub_ctx	*ctx)
 {
 	struct action_list	alist;
 	struct workqueue	wq;
 	xfs_agnumber_t		agno;
-	bool			moveon = true;
-	int			ret;
+	bool			aborted = false;
+	int			ret, ret2;
 
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating scrub workqueue"));
-		return false;
+		return ret;
 	}
 
 	/*
@@ -135,48 +142,53 @@ xfs_scan_metadata(
 	 */
 	action_list_init(&alist);
 	ret = xfs_scrub_primary_super(ctx, &alist);
-	if (ret) {
-		moveon = false;
+	if (ret)
 		goto out;
-	}
 	ret = action_list_process_or_defer(ctx, 0, &alist);
-	if (ret) {
-		moveon = false;
+	if (ret)
 		goto out;
-	}
 
-	for (agno = 0; moveon && agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, xfs_scan_ag_metadata, agno, &moveon);
+	for (agno = 0; !aborted && agno < ctx->mnt.fsgeom.agcount; agno++) {
+		ret = workqueue_add(&wq, scan_ag_metadata, agno, &aborted);
 		if (ret) {
-			moveon = false;
 			str_liberror(ctx, ret, _("queueing per-AG scrub work"));
 			goto out;
 		}
 	}
 
-	if (!moveon)
+	if (aborted)
 		goto out;
 
-	ret = workqueue_add(&wq, xfs_scan_fs_metadata, 0, &moveon);
+	ret = workqueue_add(&wq, scan_fs_metadata, 0, &aborted);
 	if (ret) {
-		moveon = false;
 		str_liberror(ctx, ret, _("queueing per-FS scrub work"));
 		goto out;
 	}
 
 out:
-	ret = workqueue_terminate(&wq);
-	if (ret) {
-		moveon = false;
-		str_liberror(ctx, ret, _("finishing scrub work"));
+	ret2 = workqueue_terminate(&wq);
+	if (ret2) {
+		str_liberror(ctx, ret2, _("finishing scrub work"));
+		if (!ret && ret2)
+			ret = ret2;
 	}
 	workqueue_destroy(&wq);
-	return moveon;
+
+	if (!ret && aborted)
+		ret = ECANCELED;
+	return ret;
 }
 
-/* Estimate how much work we're going to do. */
 bool
-xfs_estimate_metadata_work(
+xfs_scan_metadata(
+	struct scrub_ctx	*ctx)
+{
+	return phase2_func(ctx) == 0;
+}
+
+/* Estimate how much work we're going to do. */
+int
+phase2_estimate(
 	struct scrub_ctx	*ctx,
 	uint64_t		*items,
 	unsigned int		*nr_threads,
@@ -185,5 +197,15 @@ xfs_estimate_metadata_work(
 	*items = scrub_estimate_ag_work(ctx);
 	*nr_threads = scrub_nproc(ctx);
 	*rshift = 0;
-	return true;
+	return 0;
+}
+
+bool
+xfs_estimate_metadata_work(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	return phase2_estimate(ctx, items, nr_threads, rshift) == 0;
 }

