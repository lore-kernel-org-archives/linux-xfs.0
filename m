Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EA6C4708E
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbiLaA30 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiLaA3W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:29:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2E71E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:29:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED10761D3E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2A5C433EF;
        Sat, 31 Dec 2022 00:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446560;
        bh=SMX8a96RM7v3kAMtIgo4WE60AO6p59BH9Hn+vb1Djew=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pcjEW1TkBgDLgihWl7FyksgkHjGOnHPZ/fLs25Ri+CeqLxY6cyWxaE478fiYeI9Dr
         r4dqKzli1r9DReziWDI0U406IjdvGyL9uSjD3/9tIt2hIblLCf/J0jUpEVaWYp+oQv
         hVtkZZNXPc9zxpM/oB7sa1Kwn8TSKAVCWfeJ3/16OJBj7IATeIzAwspW3d21sb53b5
         cfzsZ1jD2Al1VgbmSMekE4ilKWRfY85Mj2i7xbT/fLgR8Za6h4jzcDlFUKgK8Euy5/
         vBKBJxId5Z2Dh4ELj51XtyENWQ+YyMPdj3AUyP1xG1VI8HWP/ujbB/Amddr0U78VA4
         caqT7dvlZSm0A==
Subject: [PATCH 8/9] xfs_scrub: retry incomplete repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:18 -0800
Message-ID: <167243869820.715746.7386680567080978081.stgit@magnolia>
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
index 8624167246a..c1ab03d6f02 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -57,6 +57,7 @@ xfs_repair_metadata(
 	struct xfs_scrub_metadata	oldm;
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	bool				repair_only;
+	unsigned int			tries = 0;
 	int				error;
 
 	/*
@@ -98,6 +99,7 @@ xfs_repair_metadata(
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
+retry:
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	switch (error) {
 	case 0:
@@ -176,9 +178,20 @@ _("Read-only filesystem; cannot make changes."));
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
index b970d1cfe90..699e9aa3940 100644
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
index eafb750b0d1..b54384c2091 100644
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
 

