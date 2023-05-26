Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1D5C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjEZBtW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZBtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:49:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B1E189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E62CB63B77
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599AFC433D2;
        Fri, 26 May 2023 01:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065760;
        bh=uU+HJWrN+sNdZRqvW2pvoxk6RgzbH6Q+BoNwREvUj4o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jSNmnCBHt9h2Sco6W2NYNXERQaEG+yrK11b7DoaoKxcl1Jeb/T5fyArJCuc5ddFSN
         jbUvVSkpM3mJoQPC5AbdToMf0FsNf1RBv9hSHDDABmBqirer3OXxNXZ66QRRrzyGpq
         Dpe+ccI4zzGLgGjnx/9UVO0EDfnrGb82X3mVR2DyxHf5XClCRPK87wkvSWPnUYbn/8
         KegRZw2ATfAdy9pMRpmBSsxx1Poc/8+FC4GASIVd+pd3ICL+NoPlzWSZHX7Om/NYVV
         doHhY037H+mscNi4Nmoy+oGFettcKNQ8GxnIMfDJwUVEqHSN9wkT3hTyfyfLiG4mpu
         FHOoph39MVUxg==
Date:   Thu, 25 May 2023 18:49:19 -0700
Subject: [PATCH 3/8] xfs_scrub: collapse trim_filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073120.3744829.10203214850894975371.stgit@frogsfrogsfrogs>
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

Collapse this two-line helper into the main function since it's trivial.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index c6dabbd5eed..76648b30842 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -21,15 +21,6 @@
 
 /* Phase 8: Trim filesystem. */
 
-/* Trim the unused areas of the filesystem if the caller asked us to. */
-static void
-trim_filesystem(
-	struct scrub_ctx	*ctx)
-{
-	fstrim(ctx);
-	progress_add(1);
-}
-
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
@@ -47,7 +38,8 @@ phase8_func(
 		return 0;
 
 maybe_trim:
-	trim_filesystem(ctx);
+	fstrim(ctx);
+	progress_add(1);
 	return 0;
 }
 

