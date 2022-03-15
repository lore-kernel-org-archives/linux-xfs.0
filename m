Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F878C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 23:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352571AbiCOXYo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352569AbiCOXYo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 19:24:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4692C102
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 16:23:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEBA5B8190D
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 23:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF7AC340ED;
        Tue, 15 Mar 2022 23:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386608;
        bh=cAT0yTU6YB/iw1ga49ZwvqPHKg2NGbXXGsN/uAA/N38=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jm3yhOGjAA1cDw7nx4/45T/avIBR13ud78IS9Udgo2TuaaLVg7O0b65eHXfRpSLSJ
         l1wnk6ri7PDaun5wgYbpXXZqDRwJQ6CMdtfGOcBokjNYOKCuIEm01qnF1bhl12Sc+o
         ZsamdFwJUZo878ewaA+twFIIxmuK9VCpoLJRE0EdyG9ZqoYqmTjNr9cSraozbHXhCN
         9UWnUHRmQHuR+GXxGUtIScKLnq7/eVzaLmPE6fQsceBkTmIISpQjhv69KkIEDGCy7g
         9DdUfWfHDE13O2SCnwfr3LmuFnbAzL6KpdiX4G/8ica50Oko5OTgL2uxMtWdkn84rt
         t+XXLx8dDCnqQ==
Subject: [PATCH 1/5] mkfs: hoist the internal log size clamp code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 15 Mar 2022 16:23:28 -0700
Message-ID: <164738660804.3191861.18340705401255216811.stgit@magnolia>
In-Reply-To: <164738660248.3191861.2400129607830047696.stgit@magnolia>
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the code that clamps the computation of the internal log size so
that we can begin to enhnace mkfs without turning calculate_log_size
into more spaghetti.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 96682f9a..b97bd360 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3259,6 +3259,34 @@ validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
 	}
 }
 
+static void
+clamp_internal_log_size(
+	struct mkfs_params	*cfg,
+	struct xfs_mount	*mp,
+	int			min_logblocks)
+{
+	/* Ensure the chosen size meets minimum log size requirements */
+	cfg->logblocks = max(min_logblocks, cfg->logblocks);
+
+	/*
+	 * Make sure the log fits wholly within an AG
+	 *
+	 * XXX: If agf->freeblks ends up as 0 because the log uses all
+	 * the free space, it causes the kernel all sorts of problems
+	 * with per-ag reservations. Right now just back it off one
+	 * block, but there's a whole can of worms here that needs to be
+	 * opened to decide what is the valid maximum size of a log in
+	 * an AG.
+	 */
+	cfg->logblocks = min(cfg->logblocks,
+			     libxfs_alloc_ag_max_usable(mp) - 1);
+
+	/* and now clamp the size to the maximum supported size */
+	cfg->logblocks = min(cfg->logblocks, XFS_MAX_LOG_BLOCKS);
+	if ((cfg->logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES)
+		cfg->logblocks = XFS_MAX_LOG_BYTES >> cfg->blocklog;
+}
+
 static void
 calculate_log_size(
 	struct mkfs_params	*cfg,
@@ -3331,26 +3359,7 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 			cfg->logblocks = cfg->logblocks >> cfg->blocklog;
 		}
 
-		/* Ensure the chosen size meets minimum log size requirements */
-		cfg->logblocks = max(min_logblocks, cfg->logblocks);
-
-		/*
-		 * Make sure the log fits wholly within an AG
-		 *
-		 * XXX: If agf->freeblks ends up as 0 because the log uses all
-		 * the free space, it causes the kernel all sorts of problems
-		 * with per-ag reservations. Right now just back it off one
-		 * block, but there's a whole can of worms here that needs to be
-		 * opened to decide what is the valid maximum size of a log in
-		 * an AG.
-		 */
-		cfg->logblocks = min(cfg->logblocks,
-				     libxfs_alloc_ag_max_usable(mp) - 1);
-
-		/* and now clamp the size to the maximum supported size */
-		cfg->logblocks = min(cfg->logblocks, XFS_MAX_LOG_BLOCKS);
-		if ((cfg->logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES)
-			cfg->logblocks = XFS_MAX_LOG_BYTES >> cfg->blocklog;
+		clamp_internal_log_size(cfg, mp, min_logblocks);
 
 		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
 	}

