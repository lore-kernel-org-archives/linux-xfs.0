Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D74C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381638AbiEEQJU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381194AbiEEQJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:09:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8368412AA1
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35991B82DBE
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C079DC385A4;
        Thu,  5 May 2022 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766731;
        bh=SA53WfyDgEr+3es+e0OuZ2xcr6qcNRPBALidqnI/gHo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MlYWvSXY096DvYpFDy+1vtV1WFcRflrfvGfsEVddEZk6L02IltayZqrqAMlP6ET2G
         FMcY/Xz7k1IEvF2Fd9gzd1BTtISCH29+cYnv9J5gduSSeQjnbshSie1EV1qnYNQSYC
         lMIruC+ps+yu835Cil0X5xJ1i4pTKFsBcIiuB13YEkKv9TYRInroXDZMRxkWB9kOXD
         lg+spVrURdsyR5V7/LWkxA/KjYBF+UiDDepfP9W/O+9k1HCsqyACgwvq+aOay5UPsL
         FoQJYZFkS2RdTwifB20hC7WExFEzD+4XgGN4riA1sAvs4RmgKWIWawbNHr5hpZdFgy
         +CWf91NgQ27vQ==
Subject: [PATCH 4/6] mkfs: improve log extent validation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:05:31 -0700
Message-ID: <165176673136.248587.6619451710783383392.stgit@magnolia>
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

Use the standard libxfs fsblock verifiers to check the start and end of
the internal log.  The current code does not catch the case of a
(segmented) fsblock that is beyond agf_blocks but not so large to change
the agno part of the segmented fsblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/xfs_mkfs.c          |   10 ++++------
 2 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 8abbd231..370ad8b3 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -208,6 +208,7 @@
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

