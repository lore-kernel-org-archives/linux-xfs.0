Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D95BC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbjEZBnJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjEZBnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:43:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2292F18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB30660ADA
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3FBC433EF;
        Fri, 26 May 2023 01:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065386;
        bh=WF62gUfmkOjIW39D9UPYrVlkkwcXJwl1qZR2ryMttRg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=BCK6CIIA+sqUAmKuS4Kii5q7yb5S1RGiT8j+EfkjPlBCdyj3opRGA0x02A2UAelvO
         mEXvCua5j1bdSFocvCw2xrf4QhhFd/BRM0GYj6TDqgRrqcCnBo4WQ7CtdXwXKAweD1
         mxIlNvnA6tOmQezBPXSv4aZ3YcSLUVDPR+9UFfshvGaF0Zl0MCX7crg9z/TKGLoqkT
         DHBVVmQh1eF4zmy7IjGjMq/MXyvn04zweajBXiz0n5FKY9K3fb3G+4B9GNkwOfjq7z
         RXkqAdx/t2gFuzSevjokqkHlHiUmGI2muCXRQTVnzOalr6nQpJXjnZ3pgRxn7Zay3i
         88HG7z5sl6vhw==
Date:   Thu, 25 May 2023 18:43:05 -0700
Subject: [PATCH 3/6] xfs_scrub: split up the mustfix repairs and difficulty
 assessment functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071706.3742978.2813368752652678523.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
References: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
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
index 75993544158..8919387f0f6 100644
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
index 3a10e4c67f9..5d2d0684b7b 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -290,9 +290,7 @@ xfs_action_item_compare(
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
@@ -301,25 +299,43 @@ action_list_find_mustfix(
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
index cb843a463e0..1da61d68b29 100644
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

