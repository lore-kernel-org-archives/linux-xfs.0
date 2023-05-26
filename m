Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6403C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbjEZBpt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240830AbjEZBpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:45:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99591A7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 754D364868
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD4C4339B;
        Fri, 26 May 2023 01:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065541;
        bh=ACWUbAJPvwy6v8VSuyozjniiUh2MxvCPIm2rfDLUR9I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uPdhzFV6JfMSA08/6YKUB+D3Wwau3b4S7pK0fOM9opU4WLtWL6b6TzyjLHdbTYhOb
         DQ9HYp2/Y8JCdem5fchvxit4ATsa4eV0ss/byhmNCoh6Sl0zvxI+Lt/UNJ2cCO/s+X
         kDEPJUE8qmtFgqw5AYLFXoMyPrpoyAqzm6w1xxs6S+peU4/9EILyBqP/NYenFB3OCP
         dfT8TMW2zXKrFWTXwi4u7HxTpolD89gMwZCwaaJ9BMMEai3xZjhp6+hos/QBS8D2xI
         JUIjvvifLF7Evv+oyMlLnbxQ+GQ2e7sWn0SM1BGCF/otOqLpqtFruig2aiXkQInXLZ
         SjUrPI6auHpTg==
Date:   Thu, 25 May 2023 18:45:41 -0700
Subject: [PATCH 7/9] xfs_scrub: check dependencies of a scrub type before
 repairing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072115.3743400.3644762672989077433.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072015.3743400.5119599474014297677.stgit@frogsfrogsfrogs>
References: <168506072015.3743400.5119599474014297677.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have a map of a scrub type to its dependent scrub types, use
this information to avoid trying to fix higher level metadata before the
lower levels have passed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |   32 ++++++++++++++++++++++++++++++++
 scrub/scrub.h  |    5 +++++
 2 files changed, 37 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index 9de34eada04..44e74306ba8 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -497,6 +497,29 @@ action_list_process(
 	return ret;
 }
 
+/* Decide if the dependent scrub types of the given scrub type are ok. */
+static bool
+repair_item_dependencies_ok(
+	const struct scrub_item	*sri,
+	unsigned int		scrub_type)
+{
+	unsigned int		dep_mask = repair_deps[scrub_type];
+	unsigned int		b;
+
+	for (b = 0; dep_mask && b < XFS_SCRUB_TYPE_NR; b++, dep_mask >>= 1) {
+		if (!(dep_mask & 1))
+			continue;
+		/*
+		 * If this lower level object also needs repair, we can't fix
+		 * the higher level item.
+		 */
+		if (sri->sri_state[b] & SCRUB_ITEM_NEEDSREPAIR)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * For a given filesystem object, perform all repairs of a given class
  * (corrupt, xcorrupt, xfail, preen) if the repair item says it's needed.
@@ -536,6 +559,15 @@ repair_item_class(
 		if (!(sri->sri_state[scrub_type] & repair_mask))
 			continue;
 
+		/*
+		 * Don't try to repair higher level items if their lower-level
+		 * dependencies haven't been verified, unless this is our last
+		 * chance to fix things without complaint.
+		 */
+		if (!(flags & XRM_FINAL_WARNING) &&
+		    !repair_item_dependencies_ok(sri, scrub_type))
+			continue;
+
 		fix = xfs_repair_metadata(ctx, xfdp, scrub_type, sri, flags);
 		switch (fix) {
 		case CHECK_DONE:
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 1cc638e88d7..a6f1f4c8573 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -43,6 +43,11 @@ enum check_outcome {
 #define SCRUB_ITEM_REPAIR_XREF	(SCRUB_ITEM_XFAIL | \
 				 SCRUB_ITEM_XCORRUPT)
 
+/* Mask of bits signalling that a piece of metadata requires attention. */
+#define SCRUB_ITEM_NEEDSREPAIR	(SCRUB_ITEM_CORRUPT | \
+				 SCRUB_ITEM_XFAIL | \
+				 SCRUB_ITEM_XCORRUPT)
+
 struct scrub_item {
 	/*
 	 * Information we need to call the scrub and repair ioctls.  Per-AG

