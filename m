Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F42C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381790AbiEEQMl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381903AbiEEQMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:12:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C445C759
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A0F3B82DF5
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615AEC385A4;
        Thu,  5 May 2022 16:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766910;
        bh=HHW52HHl966tXH812iZMBhy9wThDoRZUrDsnuIeuL6M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BTvWVUh5/8MVeDhSg0EoMoT/KePjsF8skvLhihZ8aAhJfnK5ZdqLlBQZ4kWebWAoZ
         ykXGllKwfWynr8wBZpvKKd2gV9tE+msXS34tF3sfh73RoQVIfis9EcZsiSYBFgkObA
         mRSlez17O/HXbcKxVhUhXUo5n5QDcRwUfqkp6I6fD4rmC1UbJq1JmRDon5QDiZXYw7
         LehboCe2IvVgLU7wnxAQEW7oGLaLcj/LtLpadjNOrUrWeWxU11dJm8sN6WANl1VN+u
         ljEJi5WkX5pfL2tOKkuLhiehjG3+1xmyp60P+QPM8TngBmh5tTJMeyRIwd83fTio/u
         5vnRVtDE1V3nw==
Subject: [PATCH 2/4] xfs_scrub: prepare phase3 for per-inogrp worker threads
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:08:29 -0700
Message-ID: <165176690995.252326.17449415006879561373.stgit@magnolia>
In-Reply-To: <165176689880.252326.13947902143386455815.stgit@magnolia>
References: <165176689880.252326.13947902143386455815.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the next patch, we're going to rewrite scrub_scan_all_inodes to
schedule per-inogrp workqueue items that will run the iterator function.
In other words, the worker threads in phase 3 wil soon cease to be
per-AG threads.

To prepare for this, we must modify phase 3 so that any writes to shared
state are protected by the appropriate per-AG locks.  As far as I can
tell, the only updates to shared state are the per-AG action lists, so
create some per-AG locks for phase 3 and create locked wrappers for the
action_list_* functions if we find things to repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase3.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index d659a779..65e903f2 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -26,6 +26,9 @@ struct scrub_inode_ctx {
 	/* Number of inodes scanned. */
 	struct ptcounter	*icount;
 
+	/* per-AG locks to protect the repair lists */
+	pthread_mutex_t		*locks;
+
 	/* Set to true to abort all threads. */
 	bool			aborted;
 
@@ -48,6 +51,24 @@ report_close_error(
 	str_errno(ctx, descr);
 }
 
+/*
+ * Defer all the repairs until phase 4, being careful about locking since the
+ * inode scrub threads are not per-AG.
+ */
+static void
+defer_inode_repair(
+	struct scrub_inode_ctx	*ictx,
+	xfs_agnumber_t		agno,
+	struct action_list	*alist)
+{
+	if (alist->nr == 0)
+		return;
+
+	pthread_mutex_lock(&ictx->locks[agno]);
+	action_list_defer(ictx->ctx, agno, alist);
+	pthread_mutex_unlock(&ictx->locks[agno]);
+}
+
 /* Run repair actions now and defer unfinished items for later. */
 static int
 try_inode_repair(
@@ -71,7 +92,7 @@ try_inode_repair(
 	if (ret)
 		return ret;
 
-	action_list_defer(ictx->ctx, agno, alist);
+	defer_inode_repair(ictx, agno, alist);
 	return 0;
 }
 
@@ -184,7 +205,7 @@ scrub_inode(
 	progress_add(1);
 
 	if (!error && !ictx->aborted)
-		action_list_defer(ctx, agno, &alist);
+		defer_inode_repair(ictx, agno, &alist);
 
 	if (fd >= 0) {
 		int	err2;
@@ -217,12 +238,21 @@ phase3_func(
 		return err;
 	}
 
+	ictx.locks = calloc(ctx->mnt.fsgeom.agcount, sizeof(pthread_mutex_t));
+	if (!ictx.locks) {
+		str_errno(ctx, _("creating per-AG repair list locks"));
+		err = ENOMEM;
+		goto out_ptcounter;
+	}
+
 	/*
 	 * If we already have ag/fs metadata to repair from previous phases,
 	 * we would rather not try to repair file metadata until we've tried
 	 * to repair the space metadata.
 	 */
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
+		pthread_mutex_init(&ictx.locks[agno], NULL);
+
 		if (!action_list_empty(&ctx->action_lists[agno]))
 			ictx.always_defer_repairs = true;
 	}
@@ -231,17 +261,21 @@ phase3_func(
 	if (!err && ictx.aborted)
 		err = ECANCELED;
 	if (err)
-		goto free;
+		goto out_locks;
 
 	scrub_report_preen_triggers(ctx);
 	err = ptcounter_value(ictx.icount, &val);
 	if (err) {
 		str_liberror(ctx, err, _("summing scanned inode counter"));
-		return err;
+		goto out_locks;
 	}
 
 	ctx->inodes_checked = val;
-free:
+out_locks:
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
+		pthread_mutex_destroy(&ictx.locks[agno]);
+	free(ictx.locks);
+out_ptcounter:
 	ptcounter_free(ictx.icount);
 	return err;
 }

