Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 173FAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiLaA30 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235583AbiLaA3G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:29:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9DE1E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:29:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69EC561D3E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA231C433D2;
        Sat, 31 Dec 2022 00:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446544;
        bh=khK6i/zrvDEnxOYr9g+ON7FbIBrB7/utzpBc0YK49Sc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nFZXmAqXwV/TMiO+9XCmRrkCJmwPGSEzlTeo82R+652XqFkpJs1ldvb90aZ1VrKEC
         y2UmFDr8tq1WoJHmU7XY18KNXK1e4w2ATsk+5H0DIIiBZeruIBC2SkwzeRjgIU1Ayv
         26wA73BzhwIuyLjHVsxKHUkqkgszoHCz4+TDRiDvr0H/UCzAjhvHggUmIxEVuzlVZG
         lr22ScInB1Qs8hy+fsV7MxScb+p/TfJXa6U5EAQgQ5U4DLZHx/CVXeiqErSX7JyaKA
         kEIsCG973wbWn0vvOcjjaH5fdPe14Yx9qBXZxf02I3XSil+9KXjJ5tdAARN/1wY1f3
         Yr2wDqT/qNwpQ==
Subject: [PATCH 7/9] xfs_scrub: check dependencies of a scrub type before
 repairing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:18 -0800
Message-ID: <167243869806.715746.18228141058609604189.stgit@magnolia>
In-Reply-To: <167243869711.715746.14725730988345960302.stgit@magnolia>
References: <167243869711.715746.14725730988345960302.stgit@magnolia>
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
index 7ad4f6cfe8a..8624167246a 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -488,6 +488,29 @@ action_list_process(
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
@@ -527,6 +550,15 @@ repair_item_class(
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
index 0d5738dc692..75595f43ee9 100644
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

