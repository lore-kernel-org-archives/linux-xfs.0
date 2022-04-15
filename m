Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF5FC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 23:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiDPAAL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 20:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbiDPAAI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Apr 2022 20:00:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F2F9024B
        for <linux-xfs@vger.kernel.org>; Fri, 15 Apr 2022 16:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA1D9B82078
        for <linux-xfs@vger.kernel.org>; Fri, 15 Apr 2022 23:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F87C385A5;
        Fri, 15 Apr 2022 23:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650067056;
        bh=i3k5nxgs9Qz74Tjt8VpFw2K2fkz8zVFVZGHGwCDSIi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aBWbvnsD/NYphUeR4Gwd9TIGYImkSoH3kOzGbRW67FNxCoHBzffBxV8S075CAr5ab
         YA2re5NnATR029Iw2OscKLeVSsp/td8Y8vBXbLTo3p89DX2KuoTMdabhhl0ua/FxAI
         kpxXt8uPi6o8Fmk2WAs+8y2zR7sg7sRElL6LqBlGT8c9wZuXrcsiCUdS+5GvHZ+1pp
         WCVtRpE2axj28Y7zCLcnEsYepMUwfAHtKHic3MINbquQljcYipVeHsRLvWyyLFYyFD
         KUCS4Q9sjxdFDap5KtVSqKBp1J5HF+kGV3R1KbdJ3TF9gooObUg8DSVxuJuUx42zEO
         R+TDUXbV/2drg==
Date:   Fri, 15 Apr 2022 16:57:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 5/4] mkfs: improve log extent validation
Message-ID: <20220415235735.GD17025@magnolia>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164996213753.226891.14458233911347178679.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the standard libxfs fsblock verifiers to check the start and end of
the internal log.  The current code does not catch the case of a
(segmented) fsblock that is beyond agf_blocks but not so large to change
the agno part of the segmented fsblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/xfs_mkfs.c          |   10 ++++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 064fb48c..f34a0483 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -207,6 +207,7 @@
 #define xfs_verify_agino		libxfs_verify_agino
 #define xfs_verify_cksum		libxfs_verify_cksum
 #define xfs_verify_dir_ino		libxfs_verify_dir_ino
+#define xfs_verify_fsbext		libxfs_verify_fsbext
 #define xfs_verify_fsbno		libxfs_verify_fsbno
 #define xfs_verify_ino			libxfs_verify_ino
 #define xfs_verify_rtbno		libxfs_verify_rtbno
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0b1fb746..b932acaa 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3218,15 +3218,13 @@ align_internal_log(
 	int			sunit,
 	int			max_logblocks)
 {
-	uint64_t		logend;
-
 	/* round up log start if necessary */
 	if ((cfg->logstart % sunit) != 0)
 		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
 
 	/* If our log start overlaps the next AG's metadata, fail. */
-	if (XFS_FSB_TO_AGBNO(mp, cfg->logstart) <= XFS_AGFL_BLOCK(mp)) {
-			fprintf(stderr,
+	if (!libxfs_verify_fsbno(mp, cfg->logstart)) {
+		fprintf(stderr,
 _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
   "within an allocation group.\n"),
 			(long long) cfg->logstart);
@@ -3237,8 +3235,7 @@ _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
 	align_log_size(cfg, sunit, max_logblocks);
 
 	/* check the aligned log still starts and ends in the same AG. */
-	logend = cfg->logstart + cfg->logblocks - 1;
-	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend)) {
+	if (!libxfs_verify_fsbext(mp, cfg->logstart, cfg->logblocks)) {
 		fprintf(stderr,
 _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
   "Must fit within an allocation group.\n"),
@@ -3465,6 +3462,7 @@ start_superblock_setup(
 	sbp->sb_agblocks = (xfs_agblock_t)cfg->agsize;
 	sbp->sb_agblklog = (uint8_t)log2_roundup(cfg->agsize);
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
+	sbp->sb_dblocks = (xfs_rfsblock_t)cfg->dblocks;
 
 	sbp->sb_inodesize = (uint16_t)cfg->inodesize;
 	sbp->sb_inodelog = (uint8_t)cfg->inodelog;
