Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EE5C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjEZBuk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D882189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B74FD64C3E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FE6C433EF;
        Fri, 26 May 2023 01:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065838;
        bh=CP3ZZQhRfVIVvl6orSYqsq/BrtGUdqvdULFwwwx+q8A=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=sEoUyBvQu9JZY5tEIfOj3T7+Kxs9YPOMYtsUBi1yTMTflOD6JjEAM5QBWw5qm+PK5
         CjtjcTJYC3Rb4oInbnI3qb8NlEfueJ1VuiXmsAIrWmfdJEimWr0IE5qE2deHaybDvT
         FzY/5Nw4P2sp2s4VhCp7LzsQO1VreXb6lRRu4QC2XuzSkFpetlI1BCbPpInPRe4NeP
         T1L4DE3vg9y/0pHOD/mIPo7RUWI4Gfl4otHoUIICFyl1WugJsw6XyxkyysIe+7yvb0
         XbvdkkYLGRlUyU7qWVghrc4z7A5s8qciy74uzVmQlkUJ1/DqgsupcoDNuZx5ryMmHf
         aa8dkf3gC4xBA==
Date:   Thu, 25 May 2023 18:50:37 -0700
Subject: [PATCH 8/8] xfs_scrub: improve progress meter for phase 8 fstrimming
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073187.3744829.17413889298796078259.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
References: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, progress reporting in phase 8 is awful, because we stall at
0% until jumping to 100%.  Since we're now performing sub-AG fstrim
calls to limit the latency impacts to the rest of the system, we might
as well limit the FSTRIM scan size so that we can report status updates
to the user more regularly.  Doing so also facilitates CPU usage control
during phase 8.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   59 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 19 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index ac64c82980e..5d2a57c83f9 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -45,6 +45,13 @@ fstrim_ok(
 	return true;
 }
 
+/*
+ * Limit the amount of fstrim scanning that we let the kernel do in a single
+ * call so that we can implement decent progress reporting and CPU resource
+ * control.  Pick a prime number of gigabytes for interest.
+ */
+#define FSTRIM_MAX_BYTES	(11ULL << 30)
+
 /* Trim a certain range of the filesystem. */
 static int
 fstrim_fsblocks(
@@ -56,18 +63,31 @@ fstrim_fsblocks(
 	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
 	int			error;
 
-	error = fstrim(ctx, start, len);
-	if (error == EOPNOTSUPP)
-		return 0;
-	if (error) {
-		char		descr[DESCR_BUFSZ];
-
-		snprintf(descr, sizeof(descr) - 1,
-				_("fstrim start 0x%llx len 0x%llx"),
-				(unsigned long long)start,
-				(unsigned long long)len);
-		str_liberror(ctx, error, descr);
-		return error;
+	while (len > 0) {
+		uint64_t	run;
+
+		run = min(len, FSTRIM_MAX_BYTES);
+
+		error = fstrim(ctx, start, run);
+		if (error == EOPNOTSUPP) {
+			/* Pretend we finished all the work. */
+			progress_add(len);
+			return 0;
+		}
+		if (error) {
+			char		descr[DESCR_BUFSZ];
+
+			snprintf(descr, sizeof(descr) - 1,
+					_("fstrim start 0x%llx run 0x%llx"),
+					(unsigned long long)start,
+					(unsigned long long)run);
+			str_liberror(ctx, error, descr);
+			return error;
+		}
+
+		progress_add(run);
+		len -= run;
+		start += run;
 	}
 
 	return 0;
@@ -90,13 +110,13 @@ fstrim_datadev(
 		 * partial-AG discard implementation, which cycles the AGF lock
 		 * to prevent foreground threads from stalling.
 		 */
+		progress_add(geo->blocksize);
 		fsbcount = min(geo->datablocks - fsbno + 1, geo->agblocks);
 		error = fstrim_fsblocks(ctx, fsbno + 1, fsbcount);
 		if (error)
 			return error;
 	}
 
-	progress_add(1);
 	return 0;
 }
 
@@ -119,12 +139,13 @@ phase8_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = 0;
-
-	if (fstrim_ok(ctx))
-		*items = 1;
-
+	if (fstrim_ok(ctx)) {
+		*items = cvt_off_fsb_to_b(&ctx->mnt,
+				ctx->mnt.fsgeom.datablocks);
+	} else {
+		*items = 0;
+	}
 	*nr_threads = 1;
-	*rshift = 0;
+	*rshift = 30; /* GiB */
 	return 0;
 }

