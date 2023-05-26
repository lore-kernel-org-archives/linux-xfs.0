Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5337DC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjEZBre (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241965AbjEZBrd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:47:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACAFE42
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 302F664868
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E433C433D2;
        Fri, 26 May 2023 01:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065635;
        bh=DaH9MfiMbi5ynuGTGJIVeXF95MZ9hkvA6gGDBWDNhns=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=htycBFMOsR993Vr+ZdOQYjmu+zMxhKo5GG4Lh86zCjYhGZDTR1MxbTVQtuvsZPyCu
         5dh5LfwGytyhFoxJS7T+hvY+yVmrdUPy/9lT5aYHS593+j7g+BRgOiO5CdTflEemDV
         pFmFjFvsbD8cZ2+jjF+mzqtb2hLWYRvqQUE/3nNePyQ/oLOCA7l/akeAnKoPtwhXfA
         S4j5vLjprUQJsEIpHeHVBvjXltG0rrYE9UaFJtDTyKYyNP72T1cyIzJohR4umb9gGv
         5dMI6Ls45U56QO6Lh6dzjrGgxiGVVGoGgfjduEy1wjl/l6xsTvHhSKVDw1RSBCcKwk
         cEjbdEDC5UENg==
Date:   Thu, 25 May 2023 18:47:15 -0700
Subject: [PATCH 4/5] xfs_scrub: hoist repair retry loop to repair_item_class
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072467.3744014.6207747156950382346.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072412.3744014.10740186421005934865.stgit@frogsfrogsfrogs>
References: <168506072412.3744014.10740186421005934865.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For metadata repair calls, move the ioctl retry and freeze permission
tracking into scrub_item.  This enables us to move the repair retry loop
out of xfs_repair_metadata and into its caller to remove a long
backwards jump, and gets us closer to vectorizing scrub calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c        |   21 ++++++++++++---------
 scrub/scrub.c         |   32 ++++++++++++++++++++++++++++++--
 scrub/scrub.h         |    6 ++++++
 scrub/scrub_private.h |   14 ++++++++++++++
 4 files changed, 62 insertions(+), 11 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 0895b564dd2..b49f2c7a8e1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -58,7 +58,6 @@ xfs_repair_metadata(
 	struct xfs_scrub_metadata	oldm;
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	bool				repair_only;
-	unsigned int			tries = 0;
 	int				error;
 
 	/*
@@ -100,7 +99,6 @@ xfs_repair_metadata(
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
-retry:
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	switch (error) {
 	case 0:
@@ -187,10 +185,8 @@ _("Read-only filesystem; cannot make changes."));
 	 * the repair again, just in case the fs was busy.  Only retry so many
 	 * times.
 	 */
-	if (want_retry(&meta) && tries < 10) {
-		tries++;
-		goto retry;
-	}
+	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+		return 0;
 
 	if (repair_flags & XRM_FINAL_WARNING)
 		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
@@ -541,6 +537,7 @@ repair_item_class(
 	unsigned int			flags)
 {
 	struct xfs_fd			xfd;
+	struct scrub_item		old_sri;
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	unsigned int			scrub_type;
 	int				error = 0;
@@ -575,9 +572,15 @@ repair_item_class(
 		    !repair_item_dependencies_ok(sri, scrub_type))
 			continue;
 
-		error = xfs_repair_metadata(ctx, xfdp, scrub_type, sri, flags);
-		if (error)
-			break;
+		sri->sri_tries[scrub_type] = SCRUB_ITEM_MAX_RETRIES;
+		do {
+			memcpy(&old_sri, sri, sizeof(old_sri));
+			error = xfs_repair_metadata(ctx, xfdp, scrub_type, sri,
+					flags);
+			if (error)
+				return error;
+		} while (scrub_item_call_kernel_again(sri, scrub_type,
+					repair_mask, &old_sri));
 
 		/* Maybe update progress if we fixed the problem. */
 		if (!(flags & XRM_NOPROGRESS) &&
diff --git a/scrub/scrub.c b/scrub/scrub.c
index b74ecfd9620..158ce67cc86 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -268,6 +268,34 @@ scrub_item_schedule_group(
 	}
 }
 
+/* Decide if we call the kernel again to finish scrub/repair activity. */
+bool
+scrub_item_call_kernel_again(
+	struct scrub_item	*sri,
+	unsigned int		scrub_type,
+	uint8_t			work_mask,
+	const struct scrub_item	*old)
+{
+	uint8_t			statex;
+
+	/* If there's nothing to do, we're done. */
+	if (!(sri->sri_state[scrub_type] & work_mask))
+		return false;
+
+	/*
+	 * We are willing to go again if the last call had any effect on the
+	 * state of the scrub item that the caller cares about, if the freeze
+	 * flag got set, or if the kernel asked us to try again...
+	 */
+	statex = sri->sri_state[scrub_type] ^ old->sri_state[scrub_type];
+	if (statex & work_mask)
+		return true;
+	if (sri->sri_tries[scrub_type] != old->sri_tries[scrub_type])
+		return true;
+
+	return false;
+}
+
 /* Run all the incomplete scans on this scrub principal. */
 int
 scrub_item_check_file(
@@ -383,9 +411,9 @@ scrub_item_dump(
 		unsigned int	g = 1U << xfrog_scrubbers[i].group;
 
 		if (g & group_mask)
-			printf("[%u]: type '%s' state 0x%x\n", i,
+			printf("[%u]: type '%s' state 0x%x tries %u\n", i,
 					xfrog_scrubbers[i].name,
-					sri->sri_state[i]);
+					sri->sri_state[i], sri->sri_tries[i]);
 	}
 	fflush(stdout);
 }
diff --git a/scrub/scrub.h b/scrub/scrub.h
index d4e6237df3c..b3d2f824bd1 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -45,6 +45,9 @@ enum xfrog_scrub_group;
 				 SCRUB_ITEM_XFAIL | \
 				 SCRUB_ITEM_XCORRUPT)
 
+/* Maximum number of times we'll retry a scrub ioctl call. */
+#define SCRUB_ITEM_MAX_RETRIES	10
+
 struct scrub_item {
 	/*
 	 * Information we need to call the scrub and repair ioctls.  Per-AG
@@ -58,6 +61,9 @@ struct scrub_item {
 
 	/* Scrub item state flags, one for each XFS_SCRUB_TYPE. */
 	__u8			sri_state[XFS_SCRUB_TYPE_NR];
+
+	/* Track scrub and repair call retries for each scrub type. */
+	__u8			sri_tries[XFS_SCRUB_TYPE_NR];
 };
 
 #define foreach_scrub_type(loopvar) \
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index c1b4a16c9ef..1baded653f7 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -89,4 +89,18 @@ scrub_item_type_boosted(
 	return sri->sri_state[scrub_type] & SCRUB_ITEM_BOOST_REPAIR;
 }
 
+/* Decide if we want to retry this operation and update bookkeeping if yes. */
+static inline bool
+scrub_item_schedule_retry(struct scrub_item *sri, unsigned int scrub_type)
+{
+	if (sri->sri_tries[scrub_type] == 0)
+		return false;
+	sri->sri_tries[scrub_type]--;
+	return true;
+}
+
+bool scrub_item_call_kernel_again(struct scrub_item *sri,
+		unsigned int scrub_type, uint8_t work_mask,
+		const struct scrub_item *old);
+
 #endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */

