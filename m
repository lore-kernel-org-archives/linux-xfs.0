Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05EAC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbjEZB7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjEZB7R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C0218D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4B964C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A22C433EF;
        Fri, 26 May 2023 01:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066355;
        bh=osKB8ihm8qhzVqxbp3cOe16JMnO02+AAEzNqQ0L+0ps=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=X8oblhT25DcwXKKwOXNIGPzDKXRRwt+286BGPgzZarDptiZRMSGLz2W+WjuNKtDhO
         CeUmOhfQBEzjT+dAyPHXQ0EyZ+vpEkoRelXyFylw98yBPj8jzwQpRNyqP8Xbup7M8x
         nqe5ZocsNWYK5urQPPirxqMwrZs2guEpeAEuvqWWQ0YI99jnIMdceP7RIFwxoQI1tj
         0rpcN3Lxk7fBXKpf1B/hz3/ADZ6ILv+5xRFALihjHv2ydR/5PgvKq/QWtuqyUeCLKf
         1onRnfy5+widAlvwfMULaG9IJi8vkVaUGK/vL56Mh6ecd2ivPjzP0IbLAoa7N92+ED
         fmmQDCtbouWvw==
Date:   Thu, 25 May 2023 18:59:14 -0700
Subject: [PATCH 1/3] xfs_scrub: automatic downgrades to dry-run mode in
 service mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075571.3746649.10332061762152223423.stgit@frogsfrogsfrogs>
In-Reply-To: <168506075558.3746649.11825051260686897396.stgit@frogsfrogsfrogs>
References: <168506075558.3746649.11825051260686897396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When service mode is enabled, xfs_scrub is being run within the context
of a systemd service.  The service description language doesn't have any
particularly good constructs for adding in a '-n' argument if the
filesystem is readonly, which means that xfs_scrub is passed a path, and
needs to switch to dry-run mode on its own if the fs is mounted
readonly or the kernel doesn't support repairs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |   13 +++++++++++++
 scrub/repair.c |   33 +++++++++++++++++++++++++++++++++
 scrub/repair.h |    2 ++
 3 files changed, 48 insertions(+)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 2a63563cc3d..c9b21e9fc82 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -216,6 +216,19 @@ _("Kernel metadata scrubbing facility is not available."));
 		return ECANCELED;
 	}
 
+	/*
+	 * Normally, callers are required to pass -n if the provided path is a
+	 * readonly filesystem or the kernel wasn't built with online repair
+	 * enabled.  However, systemd services are not scripts and cannot
+	 * determine either of these conditions programmatically.  Change the
+	 * behavior to dry-run mode if either condition is detected.
+	 */
+	if (repair_want_service_downgrade(ctx)) {
+		str_info(ctx, ctx->mntpoint,
+_("Filesystem cannot be repaired in service mode, downgrading to dry-run mode."));
+		ctx->mode = SCRUB_MODE_DRY_RUN;
+	}
+
 	/* Do we need kernel-assisted metadata repair? */
 	if (ctx->mode != SCRUB_MODE_DRY_RUN && !can_repair(ctx)) {
 		str_error(ctx, ctx->mntpoint,
diff --git a/scrub/repair.c b/scrub/repair.c
index 079a9edf77e..ed0179a4fa7 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -45,6 +45,39 @@ static const unsigned int repair_deps[XFS_SCRUB_TYPE_NR] = {
 };
 #undef DEP
 
+/*
+ * Decide if we want an automatic downgrade to dry-run mode.  This is only
+ * for service mode, where we are fed a path and have to figure out if the fs
+ * is repairable or not.
+ */
+bool
+repair_want_service_downgrade(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_metadata	meta = {
+		.sm_type		= XFS_SCRUB_TYPE_PROBE,
+		.sm_flags		= XFS_SCRUB_IFLAG_REPAIR,
+	};
+	int				error;
+
+	if (ctx->mode == SCRUB_MODE_DRY_RUN)
+		return false;
+	if (!is_service)
+		return false;
+	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
+		return false;
+
+	error = -xfrog_scrub_metadata(&ctx->mnt, &meta);
+	switch (error) {
+	case EROFS:
+	case ENOTRECOVERABLE:
+	case EOPNOTSUPP:
+		return true;
+	}
+
+	return false;
+}
+
 /* Repair some metadata. */
 static int
 xfs_repair_metadata(
diff --git a/scrub/repair.h b/scrub/repair.h
index 2ca00bef64a..408a58b81f5 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -102,4 +102,6 @@ repair_item_completely(
 	return repair_item(ctx, sri, XRM_FINAL_WARNING | XRM_NOPROGRESS);
 }
 
+bool repair_want_service_downgrade(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_REPAIR_H_ */

