Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD8CC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbiLaA0d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiLaA0b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:26:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D83DD104
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:26:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1896D61D32
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75762C433EF;
        Sat, 31 Dec 2022 00:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446389;
        bh=TMC33eobktZCpnOmuaYAzShuzCyBcOJe4jPe+TO90pw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m4NYjhrAFuHpcPlkKGkHrmEtfgvYMrxh3pxo9/zOcJRcY3qtG4LmMainhO3P+QCYE
         athe8UwLShxjUn9W7wxntoPoFjk0S0P/78eB/Xcz/BueN404wcR8Pg4kDyNe2ScBM2
         UZU04Ux774PVEO4n7wXCgMAgGwLxPy2NvdtUrmlW3Q53/kicsbEGknwB6eqWHDHA00
         Ow/4Bo1MuxzrTiMTvKrvy5ok9S/XAWKl9YzcOBz6hOE3Saadvz8/zx3nUMbIfZbItx
         YmNw5BoVvH9O60BYJmzTv8e9WdrgYGliJmdRyAuad3IyzNqexmPMmO2OGvkRvEEZkF
         vCd3q4xuREekQ==
Subject: [PATCH 3/6] xfs_scrub: split up the mustfix repairs and difficulty
 assessment functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:14 -0800
Message-ID: <167243869406.715119.14090598266613507121.stgit@magnolia>
In-Reply-To: <167243869365.715119.17881025524336922669.stgit@magnolia>
References: <167243869365.715119.17881025524336922669.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, action_list_find_mustfix does two things -- it figures out
which repairs must be tried during phase 2 to enable the inode scan in
phase 3; and it figures out if xfs_scrub should warn about secondary and
primary metadata corruption that might make repair difficult.

Split these into separate functions to make each more coherent.  A long
time from now we'll need this to enable warnings about difficult rt
repairs, but for now this is merely a code cleanup.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |   15 +++++++--------
 scrub/repair.c |   38 +++++++++++++++++++++++++++-----------
 scrub/repair.h |   10 +++++++---
 3 files changed, 41 insertions(+), 22 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 7b6933a7475..360426c5fb0 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -42,9 +42,8 @@ scan_ag_metadata(
 	struct scan_ctl			*sctl = arg;
 	struct action_list		alist;
 	struct action_list		immediate_alist;
-	unsigned long long		broken_primaries;
-	unsigned long long		broken_secondaries;
 	char				descr[DESCR_BUFSZ];
+	unsigned int			difficulty;
 	int				ret;
 
 	if (sctl->aborted)
@@ -79,12 +78,12 @@ scan_ag_metadata(
 	 * the inobt from rmapbt data, but if the rmapbt is broken even
 	 * at this early phase then we are sunk.
 	 */
-	broken_secondaries = 0;
-	broken_primaries = 0;
-	action_list_find_mustfix(&alist, &immediate_alist,
-			&broken_primaries, &broken_secondaries);
-	if (broken_secondaries && !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
-		if (broken_primaries)
+	difficulty = action_list_difficulty(&alist);
+	action_list_find_mustfix(&alist, &immediate_alist);
+
+	if ((difficulty & REPAIR_DIFFICULTY_SECONDARY) &&
+	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+		if (difficulty & REPAIR_DIFFICULTY_PRIMARY)
 			str_info(ctx, descr,
 _("Corrupt primary and secondary block mapping metadata."));
 		else
diff --git a/scrub/repair.c b/scrub/repair.c
index 1ca8331bb04..814a385ce29 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -282,9 +282,7 @@ xfs_action_item_compare(
 void
 action_list_find_mustfix(
 	struct action_list		*alist,
-	struct action_list		*immediate_alist,
-	unsigned long long		*broken_primaries,
-	unsigned long long		*broken_secondaries)
+	struct action_list		*immediate_alist)
 {
 	struct action_item		*n;
 	struct action_item		*aitem;
@@ -293,25 +291,43 @@ action_list_find_mustfix(
 		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
 			continue;
 		switch (aitem->type) {
-		case XFS_SCRUB_TYPE_RMAPBT:
-			(*broken_secondaries)++;
-			break;
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
 			alist->nr--;
 			list_move_tail(&aitem->list, &immediate_alist->list);
 			immediate_alist->nr++;
-			fallthrough;
+			break;
+		}
+	}
+}
+
+/* Determine if primary or secondary metadata are inconsistent. */
+unsigned int
+action_list_difficulty(
+	const struct action_list	*alist)
+{
+	struct action_item		*aitem, *n;
+	unsigned int			ret = 0;
+
+	list_for_each_entry_safe(aitem, n, &alist->list, list) {
+		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
+			continue;
+
+		switch (aitem->type) {
+		case XFS_SCRUB_TYPE_RMAPBT:
+			ret |= REPAIR_DIFFICULTY_SECONDARY;
+			break;
+		case XFS_SCRUB_TYPE_FINOBT:
+		case XFS_SCRUB_TYPE_INOBT:
 		case XFS_SCRUB_TYPE_BNOBT:
 		case XFS_SCRUB_TYPE_CNTBT:
 		case XFS_SCRUB_TYPE_REFCNTBT:
-			(*broken_primaries)++;
-			break;
-		default:
-			abort();
+			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}
 	}
+
+	return ret;
 }
 
 /*
diff --git a/scrub/repair.h b/scrub/repair.h
index 969871bd8bf..4c3fd718575 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -28,9 +28,13 @@ void action_list_discard(struct action_list *alist);
 void action_list_splice(struct action_list *dest, struct action_list *src);
 
 void action_list_find_mustfix(struct action_list *actions,
-		struct action_list *immediate_alist,
-		unsigned long long *broken_primaries,
-		unsigned long long *broken_secondaries);
+		struct action_list *immediate_alist);
+
+/* Primary metadata is corrupt */
+#define REPAIR_DIFFICULTY_PRIMARY	(1U << 0)
+/* Secondary metadata is corrupt */
+#define REPAIR_DIFFICULTY_SECONDARY	(1U << 1)
+unsigned int action_list_difficulty(const struct action_list *actions);
 
 /*
  * Only ask the kernel to repair this object if the kernel directly told us it

