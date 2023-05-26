Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAF6C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbjEZBqI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241964AbjEZBqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B860CE43
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B23C64C3A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CB3C433EF;
        Fri, 26 May 2023 01:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065557;
        bh=/LTZk+c3t2g1qlYmX99bkA/ecWvCNAuXVBiCKbyNt8s=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ssOKiLhTACVB9Hlo8VMuUyI79Ry5AqzX3UY01tIdOiuD8SaG7BE8BxbFurRUvEovX
         hqOV71MSDrc4/GiRx2xyPvnLKqh4Y5Z2xxAqNOpfq72LXuT8Bf1eS3ADFGm4AerwRB
         jbfrP4cZwlBCaR9QmFzEH1TYegVNr84vgRDEvOZybeI/AjjjjkFvnYLecFrdintwiB
         t7mByBvjreLUsQk9cRdLaIz5kbJ5KClKcPDdi1pxvjBWahgm7ZlH7D2s2hmHiwiP14
         yN1La1fbnyU0kUpWMPelyT4cfzR0Zy2QY4fu0KW09Q8+L4KRC4ykK5AJDvH/Yv9R4P
         dZ4HvczE5tZ9Q==
Date:   Thu, 25 May 2023 18:45:57 -0700
Subject: [PATCH 8/9] xfs_scrub: retry incomplete repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072129.3743400.16030572299993090113.stgit@frogsfrogsfrogs>
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

If a repair says it didn't do anything on account of not being able to
complete a scan of the metadata, retry the repair a few times; if even
that doesn't work, we can delay it to phase 4.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c        |   15 ++++++++++++++-
 scrub/scrub.c         |    3 +--
 scrub/scrub_private.h |   10 ++++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 44e74306ba8..824fb7fc283 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -58,6 +58,7 @@ xfs_repair_metadata(
 	struct xfs_scrub_metadata	oldm;
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	bool				repair_only;
+	unsigned int			tries = 0;
 	int				error;
 
 	/*
@@ -99,6 +100,7 @@ xfs_repair_metadata(
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
+retry:
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	switch (error) {
 	case 0:
@@ -179,9 +181,20 @@ _("Read-only filesystem; cannot make changes."));
 		return CHECK_DONE;
 	}
 
+	/*
+	 * If the kernel says the repair was incomplete or that there was a
+	 * cross-referencing discrepancy but no obvious corruption, we'll try
+	 * the repair again, just in case the fs was busy.  Only retry so many
+	 * times.
+	 */
+	if (want_retry(&meta) && tries < 10) {
+		tries++;
+		goto retry;
+	}
+
 	if (repair_flags & XRM_FINAL_WARNING)
 		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
-	if (needs_repair(&meta)) {
+	if (needs_repair(&meta) || is_incomplete(&meta)) {
 		/*
 		 * Still broken; if we've been told not to complain then we
 		 * just requeue this and try again later.  Otherwise we
diff --git a/scrub/scrub.c b/scrub/scrub.c
index e611e05f527..7d515df0ba1 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -137,8 +137,7 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (tries < 10 && (is_incomplete(meta) ||
-			   (xref_disagrees(meta) && !is_corrupt(meta)))) {
+	if (want_retry(meta) && tries < 10) {
 		tries++;
 		goto retry;
 	}
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index 0f06df255f2..c1b4a16c9ef 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -49,6 +49,16 @@ static inline bool needs_repair(struct xfs_scrub_metadata *sm)
 	return is_corrupt(sm) || xref_disagrees(sm);
 }
 
+/*
+ * We want to retry an operation if the kernel says it couldn't complete the
+ * scan/repair; or if there were cross-referencing problems but the object was
+ * not obviously corrupt.
+ */
+static inline bool want_retry(struct xfs_scrub_metadata *sm)
+{
+	return is_incomplete(sm) || (xref_disagrees(sm) && !is_corrupt(sm));
+}
+
 void scrub_warn_incomplete_scrub(struct scrub_ctx *ctx, struct descr *dsc,
 		struct xfs_scrub_metadata *meta);
 

