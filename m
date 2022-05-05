Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5EBC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241009AbiEEQMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381822AbiEEQMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:12:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE1E5C85F
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:08:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F384E61DBE
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE25C385A8;
        Thu,  5 May 2022 16:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766890;
        bh=HdJfONLbfTM3LAkbJ5YL7SOdNc/G5rZ4V2QX5NWeRrw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WSd10nU1rJcJjUKlQwtE8Ila6j258y/qgoxmmZ8ub9B9b9Q9K3Tk26AWEl41vYE6U
         tOXZR2Lsx+osJSbP4ocEFBY84FUJ8uRUCE1SEPOcdMzZevnNFnZkFBzpFB0j3twEnC
         jx1+pZw32huDjMV9AFa/4f+raClmnOIcBDmIEi49Z9t8MbV3PVBJoKf5csbI6ehXEu
         JsKdZXiOuMWtisHJDNOBfChdL7ycZHLVY6YgnwtuC1mQEW7IdWwa9ChAiuT4FS0e9f
         2+5OIKPQSivHv0qCjEI8ma6JfemkAuPxX/mczQpBMYeO3QAyVPlccQ2YzXoPlX0sb1
         hnbSHs/y39Kfw==
Subject: [PATCH 5/6] xfs_scrub: make phase 4 go straight to fstrim if nothing
 to fix
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:08:09 -0700
Message-ID: <165176688994.252160.6045763886457820977.stgit@magnolia>
In-Reply-To: <165176686186.252160.2880340500532409944.stgit@magnolia>
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If there's nothing to repair in phase 4, there's no need to hold up the
FITRIM call to do the summary count scan that prepares us to repair
filesystem metadata.  Rearrange this a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase4.c |   51 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 9 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 6ed7210f..ad26d9d5 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -95,15 +95,32 @@ repair_everything(
 	if (aborted)
 		return ECANCELED;
 
-	pthread_mutex_lock(&ctx->lock);
-	if (ctx->corruptions_found == 0 && ctx->unfixable_errors == 0 &&
-	    want_fstrim) {
+	return 0;
+}
+
+/* Decide if we have any repair work to do. */
+static inline bool
+have_action_items(
+	struct scrub_ctx	*ctx)
+{
+	xfs_agnumber_t		agno;
+
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
+		if (action_list_length(&ctx->action_lists[agno]) > 0)
+			return true;
+	}
+
+	return false;
+}
+
+/* Trim the unused areas of the filesystem if the caller asked us to. */
+static void
+trim_filesystem(
+	struct scrub_ctx	*ctx)
+{
+	if (want_fstrim)
 		fstrim(ctx);
-		progress_add(1);
-	}
-	pthread_mutex_unlock(&ctx->lock);
-
-	return 0;
+	progress_add(1);
 }
 
 /* Fix everything that needs fixing. */
@@ -113,6 +130,9 @@ phase4_func(
 {
 	int			ret;
 
+	if (!have_action_items(ctx))
+		goto maybe_trim;
+
 	/*
 	 * Check the summary counters early.  Normally we do this during phase
 	 * seven, but some of the cross-referencing requires fairly-accurate
@@ -123,7 +143,20 @@ phase4_func(
 	if (ret)
 		return ret;
 
-	return repair_everything(ctx);
+	ret = repair_everything(ctx);
+	if (ret)
+		return ret;
+
+	/*
+	 * If errors remain on the filesystem, do not trim anything.  We don't
+	 * have any threads running, so it's ok to skip the ctx lock here.
+	 */
+	if (ctx->corruptions_found || ctx->unfixable_errors == 0)
+		return 0;
+
+maybe_trim:
+	trim_filesystem(ctx);
+	return 0;
 }
 
 /* Estimate how much work we're going to do. */

