Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F9CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381766AbiEEQMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381763AbiEEQL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:11:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21275C757
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7570DB82DF4
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AB7C385B1;
        Thu,  5 May 2022 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766879;
        bh=OWdmII1W83w19WHThpryaAFKcvNU9+CFWSE9wuhzKCw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ORnVN7yt6WXH5iPDO7KNCgl0hEh6J29GOx5f6IOAKqJ99ohdwpibgwjddZF/75mGa
         Hc/ebjDt5oCJdNLQ5IYFEmeFDscjQYk86Zf7uVIFq4OLVNGz1o9Bv43UXwYzudRPKa
         dGA4KlD+T5ls021RkS1GrWStalZJmGPp8r74oquLj8s+1PQG/Yx0Jtl4FslcjX8X+h
         K0aC9OeF60ezFHloMnp9hIq/gKcCpgI+NSFq5tT0fQxjJ0Mu+93H4r3/tnKJLA6oM8
         UWuEGTN/pEhfkMvNGl5qw7UZggnt/RvaTXPvEdU5w9deieKX4VZe82bhVD34TmxntE
         bejHDz7LcEG9w==
Subject: [PATCH 3/6] xfs_scrub: fall back to scrub-by-handle if opening
 handles fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:07:58 -0700
Message-ID: <165176687875.252160.5549725159066325199.stgit@magnolia>
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

Back when I originally wrote xfs_scrub, I decided that phase 3 (the file
scrubber) should try to open all regular files by handle to pin the file
during the scrub.  At the time, I decided that an ESTALE return value
should cause the entire inode group (aka an inobt record) to be
rescanned for thoroughness reasons.

Over the past four years, I've realized that checking the return value
here isn't necessary.  For most runtime errors, we already fall back to
scrubbing with the file handle, at a fairly small performance cost.

For ESTALE, if the file has been freed and reallocated, its metadata has
been rewritten completely since bulkstat, so it's not necessary to check
it for latent disk errors.  If the file was freed, we can simply move on
to the next file.  If the filesystem is corrupt enough that
open-by-handle fails (this also results in ESTALE), we actually /want/
to fall back to scrubbing that file by handle, not rescanning the entire
inode group.

Therefore, remove the ESTALE check and leave a comment detailing these
findings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase3.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index 7da11299..d22758c1 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -65,18 +65,26 @@ scrub_inode(
 	 * cost of opening the handle (looking up the inode in the inode btree,
 	 * grabbing the inode, checking the generation) with every scrub call.
 	 *
+	 * Ignore any runtime or corruption related errors here because we can
+	 * fall back to scrubbing by handle.  ESTALE can be ignored for the
+	 * following reasons:
+	 *
+	 *  - If the file has been deleted since bulkstat, there's nothing to
+	 *    check.  Scrub-by-handle returns ENOENT for such inodes.
+	 *  - If the file has been deleted and reallocated since bulkstat,
+	 *    its ondisk metadata have been rewritten and is assumed to be ok.
+	 *    Scrub-by-handle also returns ENOENT if the generation doesn't
+	 *    match.
+	 *  - The file itself is corrupt and cannot be loaded.  In this case,
+	 *    we fall back to scrub-by-handle.
+	 *
 	 * Note: We cannot use this same trick for directories because the VFS
 	 * will try to reconnect directory file handles to the root directory
 	 * by walking '..' entries upwards, and loops in the dirent index
 	 * btree will cause livelocks.
-	 *
-	 * ESTALE means we scan the whole cluster again.
 	 */
-	if (S_ISREG(bstat->bs_mode)) {
+	if (S_ISREG(bstat->bs_mode))
 		fd = scrub_open_handle(handle);
-		if (fd < 0 && errno == ESTALE)
-			return ESTALE;
-	}
 
 	/* Scrub the inode. */
 	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_INODE, &alist);

