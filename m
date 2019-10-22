Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7892CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE51A218AE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qoRMCqr7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732820AbfJVSv4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:51:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54984 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732818AbfJVSvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:51:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiBhM090992;
        Tue, 22 Oct 2019 18:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9gBaYLDCGK4QiZuprffTvuhqhJLVXVnvcedyYW9VZhw=;
 b=qoRMCqr7b+XavxRoUaRbLQLmqR7HgWSTVmc7BsVQuUHf32cRR9hAUqWMorPNPX23r/Bk
 GRqPhGXBr6GwJQ7U/klXbAxM6Nwrzm8WgcIwnq+xOBSel3VO9cDnHeiiIYg0eyvhqc87
 z+8D37GXXUutxWu6ChLVGT6FTHLlprN8XyYLfEKtVBX3PtWSQYeUhQdAKR5xcnqTYIDM
 iLJ+TCbWGe9A8hc063epWcDWUl2W1of++J7+mjG9VKIm+6A5e8kbgAo4fKeskFswX7y7
 qVbM5qemQr5c/LGQMFXQaKTeIeIzLP6n5DnU576gLToGBaC9sRHhXmw0w+h/5NdAsLj5 XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqteprrpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:51:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiOFN070537;
        Tue, 22 Oct 2019 18:51:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vsx2rkttb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:51:53 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIppdi005094;
        Tue, 22 Oct 2019 18:51:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:51:51 -0700
Subject: [PATCH 13/18] xfs_scrub: remove moveon from phase 4 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:51:50 -0700
Message-ID: <157177031075.1461658.2997489260715360653.stgit@magnolia>
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

Replace the moveon returns in the phase 4 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase4.c |   86 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 37 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index c6de1cd4..f9dcf9c8 100644
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
@@ -42,78 +42,73 @@ xfs_repair_ag(
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
-	if (moveon &&
-	    ctx->corruptions_found == 0 &&
-	    ctx->unfixable_errors == 0 &&
+	if (ctx->corruptions_found == 0 && ctx->unfixable_errors == 0 &&
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
@@ -126,14 +121,21 @@ xfs_repair_fs(
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
@@ -148,5 +150,15 @@ xfs_estimate_repair_work(
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

