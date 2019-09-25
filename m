Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF79BC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84025205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rc2FMCB4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfIYVjc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728696AbfIYVjb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdPe4058308;
        Wed, 25 Sep 2019 21:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uPCaCvq4kAEZoJrj50QdLII1h8aPkcsY428Dxb/DCsY=;
 b=rc2FMCB4/dIbabE1eS5PBkSD0YYWoJ9WXIKVoL4U9ZW2ftbbdp2GyyY+pQkUK12Q42OQ
 Ml/N9NsFk6P+rlvlykqRQr+e3iMrOC+7Oxvftb147oJWP2qWxKFdmTu4pBSSx3ONsA/c
 e2f6HJcGref4nIZKB72Vyb6oSxqYkKXX8Aw0NebVL1kS3Wu7z9hX4md50qKuzkAmRaWK
 QVjcArttKaSLc9lBQ3dShzEQvJ+ikdB3wsVgCjf2Oivww23Np62IJNOOaWpcgFz5bd+S
 0GYTsYAKvctmvXiesFnZRSeDXbufes2LLj3V4Y6SPlp6EK0SSROC1dKlg1B+aGxxVbfl VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgr7ffa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdPGT033711;
        Wed, 25 Sep 2019 21:39:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuvus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLdQ5Q018967;
        Wed, 25 Sep 2019 21:39:26 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:39:25 -0700
Subject: [PATCH 13/18] xfs_scrub: remove moveon from phase 4 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:39:24 -0700
Message-ID: <156944756460.301514.15082695260008371720.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the phase 4 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase4.c |   85 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 35 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index ba60a1db..9c9c3e8e 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -22,13 +22,13 @@
 
 /* Fix all the problems in our per-AG list. */
 static void
-xfs_repair_ag(
+repair_ag(
 	struct workqueue		*wq,
 	xfs_agnumber_t			agno,
 	void				*priv)
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*pmoveon = priv;
+	bool				*aborted = priv;
 	struct action_list		*alist;
 	size_t				unfixed;
 	size_t				new_unfixed;
@@ -42,76 +42,74 @@ xfs_repair_ag(
 	do {
 		ret = action_list_process(ctx, ctx->mnt.fd, alist, flags);
 		if (ret) {
-			*pmoveon = false;
+			*aborted = true;
 			return;
 		}
 		new_unfixed = action_list_length(alist);
 		if (new_unfixed == unfixed)
 			break;
 		unfixed = new_unfixed;
-	} while (unfixed > 0 && *pmoveon);
-
-	if (!*pmoveon)
-		return;
+		if (*aborted)
+			return;
+	} while (unfixed > 0);
 
 	/* Try once more, but this time complain if we can't fix things. */
 	flags |= ALP_COMPLAIN_IF_UNFIXED;
 	ret = action_list_process(ctx, ctx->mnt.fd, alist, flags);
 	if (ret)
-		*pmoveon = false;
+		*aborted = true;
 }
 
 /* Process all the action items. */
-static bool
-xfs_process_action_items(
+static int
+repair_everything(
 	struct scrub_ctx		*ctx)
 {
 	struct workqueue		wq;
 	xfs_agnumber_t			agno;
-	bool				moveon = true;
+	bool				aborted = false;
 	int				ret;
 
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating repair workqueue"));
-		return false;
+		return ret;
 	}
-	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		if (action_list_length(&ctx->action_lists[agno]) > 0) {
-			ret = workqueue_add(&wq, xfs_repair_ag, agno, &moveon);
-			if (ret) {
-				moveon = false;
-				str_liberror(ctx, ret,
-						_("queueing repair work"));
-				break;
-			}
-		}
-		if (!moveon)
+	for (agno = 0; !aborted && agno < ctx->mnt.fsgeom.agcount; agno++) {
+		if (action_list_length(&ctx->action_lists[agno]) == 0)
+			continue;
+
+		ret = workqueue_add(&wq, repair_ag, agno, &aborted);
+		if (ret) {
+			str_liberror(ctx, ret, _("queueing repair work"));
 			break;
+		}
 	}
 
 	ret = workqueue_terminate(&wq);
-	if (ret) {
-		moveon = false;
+	if (ret)
 		str_liberror(ctx, ret, _("finishing repair work"));
-	}
 	workqueue_destroy(&wq);
 
+	if (aborted)
+		return ECANCELED;
+
 	pthread_mutex_lock(&ctx->lock);
-	if (moveon && ctx->errors_found == 0 && ctx->unfixable_errors == 0 &&
+	if (ctx->errors_found == 0 &&
+	    ctx->unfixable_errors == 0 &&
 	    want_fstrim) {
 		fstrim(ctx);
 		progress_add(1);
 	}
 	pthread_mutex_unlock(&ctx->lock);
 
-	return moveon;
+	return 0;
 }
 
 /* Fix everything that needs fixing. */
-bool
-xfs_repair_fs(
+int
+phase4_func(
 	struct scrub_ctx	*ctx)
 {
 	int			ret;
@@ -124,14 +122,21 @@ xfs_repair_fs(
 	 */
 	ret = xfs_scrub_fs_summary(ctx, &ctx->action_lists[0]);
 	if (ret)
-		return false;
+		return ret;
 
-	return xfs_process_action_items(ctx);
+	return repair_everything(ctx);
 }
 
-/* Estimate how much work we're going to do. */
 bool
-xfs_estimate_repair_work(
+xfs_repair_fs(
+	struct scrub_ctx	*ctx)
+{
+	return phase4_func(ctx) == 0;
+}
+
+/* Estimate how much work we're going to do. */
+int
+phase4_estimate(
 	struct scrub_ctx	*ctx,
 	uint64_t		*items,
 	unsigned int		*nr_threads,
@@ -146,5 +151,15 @@ xfs_estimate_repair_work(
 	*items = need_fixing;
 	*nr_threads = scrub_nproc(ctx) + 1;
 	*rshift = 0;
-	return true;
+	return 0;
+}
+
+bool
+xfs_estimate_repair_work(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	return phase4_estimate(ctx, items, nr_threads, rshift) == 0;
 }

