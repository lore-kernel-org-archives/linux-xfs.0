Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE630C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbiLaALM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLaALL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:11:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D8FC29
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:11:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44FC061CE0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BF3C433D2;
        Sat, 31 Dec 2022 00:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445469;
        bh=awcHuqGoimXcM7W9zQ8mpwOpSiLy90+Xro0Zs3S/O5Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mLbmwWyOc07APfoPvm7ZMeiu66vmoVfG6fThRK25/WmQEg4uCX8Ow1/Q1SURE3eXU
         hX5SZcJ5xx91inMkUi3ipONY5qrltgJWgsvQx9jP7c1GsfkmKVb6+WMN4ha8zF7Fep
         LbRi6kUGT4xBETX0rMiFubGMoJ/njS5Mb1zYGp2twwGqkZZcK2mYYTTJxkRYwWue1H
         0sovsCaTrpXPbc3RmQTLmkjRfj4DZnncNN+W3tmTZ0fIocC9HojS1TdV9Wr/NhxjRR
         hmLbk1UGPZTntICa0+n1mI+dbDCrKQkE+DLc/oS4CJhL2JPDHzLWUy5U6QWDvaNTSK
         gfHwA5MQJ5Isg==
Subject: [PATCH 4/4] xfs_scrub: upload clean bills of health
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:38 -0800
Message-ID: <167243865870.711359.9515498282457862448.stgit@magnolia>
In-Reply-To: <167243865816.711359.1865490497957941966.stgit@magnolia>
References: <167243865816.711359.1865490497957941966.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If scrub terminates with a clean bill of health, tell the kernel that
the result of the scan is that everything's healthy.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |   38 ++++++++++++++++++++++++++++++++++++++
 scrub/repair.c |   15 +++++++++++++++
 scrub/repair.h |    1 +
 scrub/scrub.c  |    9 +++++++++
 scrub/scrub.h  |    1 +
 5 files changed, 64 insertions(+)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 2daf5c7bb38..cecb5e861f4 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -44,6 +44,40 @@ xfs_shutdown_fs(
 		str_errno(ctx, ctx->mntpoint);
 }
 
+/*
+ * If we haven't found /any/ problems at all, tell the kernel that we're giving
+ * the filesystem a clean bill of health.
+ */
+static int
+report_to_kernel(
+	struct scrub_ctx	*ctx)
+{
+	struct action_list	alist;
+	int			ret;
+
+	if (!ctx->scrub_setup_succeeded || ctx->corruptions_found ||
+	    ctx->runtime_errors || ctx->unfixable_errors ||
+	    ctx->warnings_found)
+		return 0;
+
+	action_list_init(&alist);
+	ret = scrub_clean_health(ctx, &alist);
+	if (ret)
+		return ret;
+
+	/*
+	 * Complain if we cannot fail the clean bill of health, unless we're
+	 * just testing repairs.
+	 */
+	if (action_list_length(&alist) > 0 &&
+	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+		str_info(ctx, _("Couldn't upload clean bill of health."), NULL);
+		action_list_discard(&alist);
+	}
+
+	return 0;
+}
+
 /* Clean up the XFS-specific state data. */
 int
 scrub_cleanup(
@@ -51,6 +85,10 @@ scrub_cleanup(
 {
 	int			error;
 
+	error = report_to_kernel(ctx);
+	if (error)
+		return error;
+
 	action_lists_free(&ctx->action_lists);
 	if (ctx->fshandle)
 		free_handle(ctx->fshandle, ctx->fshandle_len);
diff --git a/scrub/repair.c b/scrub/repair.c
index 8a1ae0226a0..bb0faceca69 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -172,6 +172,21 @@ action_lists_alloc(
 	return 0;
 }
 
+/* Discard repair list contents. */
+void
+action_list_discard(
+	struct action_list		*alist)
+{
+	struct action_item		*aitem;
+	struct action_item		*n;
+
+	list_for_each_entry_safe(aitem, n, &alist->list, list) {
+		alist->nr--;
+		list_del(&aitem->list);
+		free(aitem);
+	}
+}
+
 /* Free the repair lists. */
 void
 action_lists_free(
diff --git a/scrub/repair.h b/scrub/repair.h
index 102e5779c70..d7a3a9e7cff 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -24,6 +24,7 @@ static inline bool action_list_empty(const struct action_list *alist)
 
 unsigned long long action_list_length(struct action_list *alist);
 void action_list_add(struct action_list *dest, struct action_item *item);
+void action_list_discard(struct action_list *alist);
 void action_list_splice(struct action_list *dest, struct action_list *src);
 
 void action_list_find_mustfix(struct action_list *actions,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 7f80b2de211..975dd8efbbc 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -444,6 +444,15 @@ scrub_nlinks(
 	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_NLINKS, 0, alist);
 }
 
+/* Update incore health records if we were clean. */
+int
+scrub_clean_health(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, 0, alist);
+}
+
 /* How many items do we have to check? */
 unsigned int
 scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 430ad0fbd83..0622677376c 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -29,6 +29,7 @@ int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_clean_health(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

