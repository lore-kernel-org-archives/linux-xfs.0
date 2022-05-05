Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE24C43217
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381822AbiEEQMG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381779AbiEEQMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:12:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B855C846
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 379C0B82DF4
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1424C385A4;
        Thu,  5 May 2022 16:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766884;
        bh=37/FCvXPlaXwxX4p+kwzEO8LPJQRXtqm8KiHMg/7cGQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CHr6J71hI79fhDYIhLlFvuiVIxQAX6UWSWM/wtBQRVSywV38gPa3VX0niFhrDh38K
         lte3U/milxPdb0zZpFxL4MasFBCxEY/5iHtaXoZ0wYZVzhEIlkem3fYAOL94761f8G
         E9MG/1SACIpckZ1AKQw4XBzT7iIqe45CV546aCacEI1sYwh7rV214lTpLqwyaIbtqE
         Nn2raoous8b/GC9oFW+k7nndZJ8XkW+N7eC7Ier9HeI8Y4uz4XhBN46UPNAVDPlSuf
         CkJfm+9wREVwdrZ6K/tgnFbIvKhwl4TVLgSZLKpnsCgPV8LudGlYKSnY8/ur7YwK7n
         /xG+IEwKJS8dg==
Subject: [PATCH 4/6] xfs_scrub: don't try any file repairs during phase 3 if
 AG metadata bad
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:08:04 -0700
Message-ID: <165176688430.252160.7374263325275359962.stgit@magnolia>
In-Reply-To: <165176686186.252160.2880340500532409944.stgit@magnolia>
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, phase 3 tries to repair file metadata even after phase 2
tells us that there are problems with the AG metadata.  While this
generally won't cause too many problems since the repair code will bail
out on any obvious corruptions it finds, this isn't totally foolproof.
If the filesystem space metadata are not in good shape, we want to queue
the file repairs to run /after/ the space metadata repairs in phase 4.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase3.c |   50 +++++++++++++++++++++++++++++++++++++++++++++-----
 scrub/repair.h |    6 ++++++
 2 files changed, 51 insertions(+), 5 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index d22758c1..fd8e5419 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -21,8 +21,16 @@
 /* Phase 3: Scan all inodes. */
 
 struct scrub_inode_ctx {
+	struct scrub_ctx	*ctx;
+
+	/* Number of inodes scanned. */
 	struct ptcounter	*icount;
+
+	/* Set to true to abort all threads. */
 	bool			aborted;
+
+	/* Set to true if we want to defer file repairs to phase 4. */
+	bool			always_defer_repairs;
 };
 
 /* Report a filesystem error that the vfs fed us on close. */
@@ -40,6 +48,24 @@ report_close_error(
 	str_errno(ctx, descr);
 }
 
+/* Run repair actions now and defer unfinished items for later. */
+static int
+try_inode_repair(
+	struct scrub_inode_ctx	*ictx,
+	xfs_agnumber_t		agno,
+	struct action_list	*alist)
+{
+	/*
+	 * If at the start of phase 3 we already had ag/rt metadata repairs
+	 * queued up for phase 4, leave the action list untouched so that file
+	 * metadata repairs will be deferred in scan order until phase 4.
+	 */
+	if (ictx->always_defer_repairs)
+		return 0;
+
+	return action_list_process_or_defer(ictx->ctx, agno, alist);
+}
+
 /* Verify the contents, xattrs, and extent maps of an inode. */
 static int
 scrub_inode(
@@ -91,7 +117,7 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	error = action_list_process_or_defer(ctx, agno, &alist);
+	error = try_inode_repair(ictx, agno, &alist);
 	if (error)
 		goto out;
 
@@ -106,7 +132,7 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	error = action_list_process_or_defer(ctx, agno, &alist);
+	error = try_inode_repair(ictx, agno, &alist);
 	if (error)
 		goto out;
 
@@ -132,7 +158,7 @@ scrub_inode(
 		goto out;
 
 	/* Try to repair the file while it's open. */
-	error = action_list_process_or_defer(ctx, agno, &alist);
+	error = try_inode_repair(ictx, agno, &alist);
 	if (error)
 		goto out;
 
@@ -147,7 +173,10 @@ scrub_inode(
 		ictx->aborted = true;
 	}
 	progress_add(1);
-	action_list_defer(ctx, agno, &alist);
+
+	if (!error && !ictx->aborted)
+		action_list_defer(ctx, agno, &alist);
+
 	if (fd >= 0) {
 		int	err2;
 
@@ -168,8 +197,9 @@ int
 phase3_func(
 	struct scrub_ctx	*ctx)
 {
-	struct scrub_inode_ctx	ictx = { NULL };
+	struct scrub_inode_ctx	ictx = { .ctx = ctx };
 	uint64_t		val;
+	xfs_agnumber_t		agno;
 	int			err;
 
 	err = ptcounter_alloc(scrub_nproc(ctx), &ictx.icount);
@@ -178,6 +208,16 @@ phase3_func(
 		return err;
 	}
 
+	/*
+	 * If we already have ag/fs metadata to repair from previous phases,
+	 * we would rather not try to repair file metadata until we've tried
+	 * to repair the space metadata.
+	 */
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
+		if (!action_list_empty(&ctx->action_lists[agno]))
+			ictx.always_defer_repairs = true;
+	}
+
 	err = scrub_scan_all_inodes(ctx, scrub_inode, &ictx);
 	if (!err && ictx.aborted)
 		err = ECANCELED;
diff --git a/scrub/repair.h b/scrub/repair.h
index 1994c50a..4261be49 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -16,6 +16,12 @@ int action_lists_alloc(size_t nr, struct action_list **listsp);
 void action_lists_free(struct action_list **listsp);
 
 void action_list_init(struct action_list *alist);
+
+static inline bool action_list_empty(const struct action_list *alist)
+{
+	return list_empty(&alist->list);
+}
+
 size_t action_list_length(struct action_list *alist);
 void action_list_add(struct action_list *dest, struct action_item *item);
 void action_list_splice(struct action_list *dest, struct action_list *src);

