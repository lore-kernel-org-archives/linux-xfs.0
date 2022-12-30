Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A9AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiLaAdC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiLaAdB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:33:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CE814006
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:33:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71A1DB80883
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A20C433EF;
        Sat, 31 Dec 2022 00:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446778;
        bh=paKWJ62A0KpEakAT5JYOS1fMjV1u+J0sCcJ9WFUVMnU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LhrSpq8k36h/zF9b86IJDIDo0iJpuPLyIzshbCIDc27wkq1tNi1pbTTNYxk8zvhfV
         PlN+Z+d5s49T3VPZCqC8NYD3a74jXxdfNS5vZjgyQaSX0ZihHo+nZwL3qA9KS8ZdWz
         Bwoge1pkH9cuMJa/H+kSl9mai6xVBmYTweJLtZ29zh2QoCEYMjDYjIIWqdDYoQO5At
         Xb0JJOi6jBVLdWphThhDKZ4I+07JLAPBtm7lNfaEHYgq0kiye1jtpLDeXo+CabRjW+
         /XsoCwDEL9RJ9wQb7AQWe/MRNDGUK1MYhks9t2Hruz/UW+70GPw1pSnDtnaxtQ5Kav
         qf1nvcnsEdwHA==
Subject: [PATCH 4/7] xfs_scrub: fix the work estimation for phase 8
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:28 -0800
Message-ID: <167243870802.716924.2818760920067531576.stgit@magnolia>
In-Reply-To: <167243870748.716924.8460607901853339412.stgit@magnolia>
References: <167243870748.716924.8460607901853339412.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If there are latent errors on the filesystem, we aren't going to do any
work during phase 8 and it makes no sense to add that into the work
estimate for the progress bar.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 80f86f9ecd9..789ef2b2b4e 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -21,23 +21,35 @@
 
 /* Phase 8: Trim filesystem. */
 
-/* Trim the filesystem, if desired. */
-int
-phase8_func(
+static inline bool
+fstrim_ok(
 	struct scrub_ctx	*ctx)
 {
-	if (action_list_empty(ctx->fs_repair_list) &&
-	    action_list_empty(ctx->file_repair_list))
-		goto maybe_trim;
-
 	/*
 	 * If errors remain on the filesystem, do not trim anything.  We don't
 	 * have any threads running, so it's ok to skip the ctx lock here.
 	 */
-	if (ctx->corruptions_found || ctx->unfixable_errors != 0)
+	if (!action_list_empty(ctx->fs_repair_list))
+		return false;
+	if (!action_list_empty(ctx->file_repair_list))
+		return false;
+
+	if (ctx->corruptions_found != 0)
+		return false;
+	if (ctx->unfixable_errors != 0)
+		return false;
+
+	return true;
+}
+
+/* Trim the filesystem, if desired. */
+int
+phase8_func(
+	struct scrub_ctx	*ctx)
+{
+	if (!fstrim_ok(ctx))
 		return 0;
 
-maybe_trim:
 	fstrim(ctx);
 	progress_add(1);
 	return 0;
@@ -51,7 +63,11 @@ phase8_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = 1;
+	*items = 0;
+
+	if (fstrim_ok(ctx))
+		*items = 1;
+
 	*nr_threads = 1;
 	*rshift = 0;
 	return 0;

