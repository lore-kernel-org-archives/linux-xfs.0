Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36EDC53210
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLaAam (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbiLaAal (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:30:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1880E1EAC9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:30:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A933D61D4E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C2FC433EF;
        Sat, 31 Dec 2022 00:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446638;
        bh=coN6UL/W+xhy2N0adpIcmp/JiBh2EbEQoLE55uda76E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fQGfo/8SONUw44n8B+RmtTsX/9RNuyO405hMXsWvShls1Q0eNS0YW398kNR+ShWBE
         HhLfWqzfv0tpkqDGrrqPmaf6pqR83/BdrXTbP6TBRh7uixZZ7EEW9KTtXbwkaWJWnv
         f9ZqfI7adAa/zNr8iLaEPutQbTp5lIX2mTsI/rWlW3ibTH5CrlMCwklQFpLSKwaLhj
         HhQ5HUVNEC89ExT/QLRpbiDQApY0mty7A2bbLDiBtb9CCiQm2SBctGEn0HbP83bbnC
         WfPyExh4SjEoFzW0IKEZW0osIHMgLSDOOXs567cYNm/A+7tVCqGFT9LqhlWe3zKD/V
         TV5RcGemRQYHw==
Subject: [PATCH 4/5] xfs_scrub: hoist repair retry loop to repair_item_class
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:21 -0800
Message-ID: <167243870154.716382.4065561229338671158.stgit@magnolia>
In-Reply-To: <167243870099.716382.3489355808439125232.stgit@magnolia>
References: <167243870099.716382.3489355808439125232.stgit@magnolia>
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
index 9cce421223b..d0434e3d6d1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -57,7 +57,6 @@ xfs_repair_metadata(
 	struct xfs_scrub_metadata	oldm;
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	bool				repair_only;
-	unsigned int			tries = 0;
 	int				error;
 
 	/*
@@ -99,7 +98,6 @@ xfs_repair_metadata(
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
-retry:
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	switch (error) {
 	case 0:
@@ -184,10 +182,8 @@ _("Read-only filesystem; cannot make changes."));
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
@@ -532,6 +528,7 @@ repair_item_class(
 	unsigned int			flags)
 {
 	struct xfs_fd			xfd;
+	struct scrub_item		old_sri;
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	unsigned int			scrub_type;
 	int				error = 0;
@@ -566,9 +563,15 @@ repair_item_class(
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
index ccc6a7a4047..d3d96a85903 100644
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
index 797b872246d..e1ce6ed2f59 100644
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
index b54384c2091..6380779c90b 100644
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

