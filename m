Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF0BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbiEEQJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381707AbiEEQI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787ED62DC
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 389E3B82C77
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE086C385A8;
        Thu,  5 May 2022 16:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766715;
        bh=nOZSWb0ZUMwXuSZ0ETof7UF7foTN/et6hRgbKblpUTA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cHFTSzbE5332ySQYIAjXO8qB8JegCZZ9mSrGBlis1yWPKdbxj/9q8B4vn4vC70wwm
         UFR6Jc0J+/dfSCXRU5C2n5nnitHvq8uAaYNRGaJ4l6qamobhTUqeI0DDXdmBPelC0O
         o+GlcEW5O2GMoDFmUoMiTivOgjt6/6NG3IdchbP/gT3liYYVH0yd5T1d3RxxnZQrnl
         Xs6f1RxTaifOlQK2cRpNeGg8QyWmQGfybHvUL+t4IjQhCYL9OK4xXeXFJmBq0b67y1
         jIXX/PzaS+V63DLYgeRnEwQN3TwQ7vqwSQkDjnf/JqBOud/HY8w6/ylSWc0xou9ocj
         W7+dSd8gxHIHw==
Subject: [PATCH 1/6] mkfs: fix missing validation of -l size against maximum
 internal log size
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:05:14 -0700
Message-ID: <165176671447.248587.1005282634808970751.stgit@magnolia>
In-Reply-To: <165176670883.248587.2509972137741301804.stgit@magnolia>
References: <165176670883.248587.2509972137741301804.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a sysadmin specifies a log size explicitly, we don't actually check
that against the maximum internal log size that we compute for the
default log size computation.  We're going to add more validation soon,
so refactor the max internal log blocks into a common variable and
add a check.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6d0af86d..e11b39d7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3275,6 +3275,7 @@ calculate_log_size(
 {
 	struct xfs_sb		*sbp = &mp->m_sb;
 	int			min_logblocks;	/* absolute minimum */
+	int			max_logblocks;	/* absolute max for this AG */
 	struct xfs_mount	mount;
 
 	/* we need a temporary mount to calculate the minimum log size. */
@@ -3314,6 +3315,18 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 		return;
 	}
 
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
+	max_logblocks = libxfs_alloc_ag_max_usable(mp) - 1;
+
 	/* internal log - if no size specified, calculate automatically */
 	if (!cfg->logblocks) {
 		/* Use a 2048:1 fs:log ratio for most filesystems */
@@ -3328,21 +3341,9 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 		if (cfg->dblocks < MEGABYTES(300, cfg->blocklog))
 			cfg->logblocks = min_logblocks;
 
-		/* Ensure the chosen size meets minimum log size requirements */
+		/* Ensure the chosen size fits within log size requirements */
 		cfg->logblocks = max(min_logblocks, cfg->logblocks);
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
+		cfg->logblocks = min(cfg->logblocks, max_logblocks);
 
 		/* and now clamp the size to the maximum supported size */
 		cfg->logblocks = min(cfg->logblocks, XFS_MAX_LOG_BLOCKS);
@@ -3350,6 +3351,13 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 			cfg->logblocks = XFS_MAX_LOG_BYTES >> cfg->blocklog;
 
 		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
+	} else if (cfg->logblocks > max_logblocks) {
+		/* check specified log size */
+		fprintf(stderr,
+_("internal log size %lld too large, must be less than %d\n"),
+			(long long)cfg->logblocks,
+			max_logblocks);
+		usage();
 	}
 
 	if (cfg->logblocks > sbp->sb_agblocks - libxfs_prealloc_blocks(mp)) {

