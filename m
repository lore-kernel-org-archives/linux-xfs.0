Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C0FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbiLaAia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAi3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:38:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426B61E3EE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F18AB81E08
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF686C433EF;
        Sat, 31 Dec 2022 00:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447105;
        bh=b3uBDNBAtgBrsC8AD3lRbBrYIOxZJ6rdhEyl1jgRG3c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qMX1tpWvTUj7TEfI6uodZAPx7UwjhPI0MJBtRVAcD43+7FytiHVJb5Ns33Azo+Ano
         lD57w0bMcCTt4IGLbvRWP2/30ZlCJntan2Cz1S8NWvGfYpDQp1uyAoi+HTxTmPvVl+
         zOg3HYfo2YMVBUrrlDNNsZFV2eh3/0dBTgdfdGwKYFHD6neXpTC5fbf9nVSNgfXler
         +oq27GdeOqAgE5dm+VTwKlg5WQkk8Nu5BERVM8ZDa1UZXNrIvBJZGG8T1I8N5cgnlP
         xOnLGLDtIqB7rAt5F5o8GhqpnPzrFAmkPZkLmlJKXWWuFXg4s8RpodSnljYKPplsG9
         yOAkYWi42BIFA==
Subject: [PATCH 1/2] xfs_scrub: automatic downgrades to dry-run mode in
 service mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:41 -0800
Message-ID: <167243872126.718904.228439789394159482.stgit@magnolia>
In-Reply-To: <167243872112.718904.9124514098518120883.stgit@magnolia>
References: <167243872112.718904.9124514098518120883.stgit@magnolia>
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
index 80fd0c6e27c..7b9caa4258c 100644
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
index cf17bbd8d0e..127055f2f61 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -44,6 +44,39 @@ static const unsigned int repair_deps[XFS_SCRUB_TYPE_NR] = {
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
index 639ab2370e0..c4b9b5799e2 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -102,4 +102,6 @@ repair_item_completely(
 	return repair_item(ctx, sri, XRM_FINAL_WARNING | XRM_NOPROGRESS);
 }
 
+bool repair_want_service_downgrade(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_REPAIR_H_ */

