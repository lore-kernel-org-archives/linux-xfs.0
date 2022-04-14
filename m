Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FDDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 18:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbiDNSvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 14:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiDNSvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 14:51:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C87DBD0E
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 11:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13ABD61A69
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 18:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E2AC385A9;
        Thu, 14 Apr 2022 18:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649962149;
        bh=XD2gLJOTd8L/tvJ61Ch44Mx4zUm5x9c0TDqIP7Q6CtE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ne7y8BCPypB4nSPiQdT04KrwbLZ0SEZn2pO9gvI6eTxUetoTzeTtrTnJYztNsLs7O
         Dbt9Jvt+d7+6ZjZNeA37lM8EgrazZ4NL9m4QBS5PeXW0sgAjTRXhpGAYeeZ8atKJH+
         yBl2yb8vX8VNBs/Rj/VpsiUEtaGqF05cC35lpDXbVY/cus8MilE1yo4jNlNrTx6QUf
         64/AGTilPjUy+T7ropqz571HzkZDHW5l7dAIA7kSfklUIvJx2HY/lgG3tugpVOay1g
         kS3IuPpW1nYUMjIJdxzcOfbwd1Rm6uzU9aZ5s79w08HlXXQWi41QjelqeRDweIxdcl
         ep8mJnVlbZUyg==
Subject: [PATCH 2/4] mkfs: reduce internal log size when log stripe units are
 in play
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 11:49:09 -0700
Message-ID: <164996214899.226891.5031116645577578021.stgit@magnolia>
In-Reply-To: <164996213753.226891.14458233911347178679.stgit@magnolia>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, one can feed mkfs a combination of options like this:

$ truncate -s 6366g /tmp/a ; mkfs.xfs -f /tmp/a -d agcount=3200 -d su=256k,sw=4
meta-data=/tmp/a                 isize=512    agcount=3200, agsize=521536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=1668808704, imaxpct=5
         =                       sunit=64     swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521536, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Metadata corruption detected at 0x55e88052c6b6, xfs_agf block 0x1/0x200
libxfs_bwrite: write verifier failed on xfs_agf bno 0x1/0x1
mkfs.xfs: writing AG headers failed, err=117

The format fails because the internal log size sizing algorithm
specifies a log size of 521492 blocks to avoid taking all the space in
the AG, but align_log_size sees the stripe unit and rounds that up to
the next stripe unit, which is 521536 blocks.

Fix this problem by rounding the log size down if rounding up would
result in a log that consumes more space in the AG than we allow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e11b39d7..eb4d7fa9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3180,9 +3180,10 @@ sb_set_features(
 static void
 align_log_size(
 	struct mkfs_params	*cfg,
-	int			sunit)
+	int			sunit,
+	int			max_logblocks)
 {
-	uint64_t	tmp_logblocks;
+	uint64_t		tmp_logblocks;
 
 	/* nothing to do if it's already aligned. */
 	if ((cfg->logblocks % sunit) == 0)
@@ -3199,7 +3200,8 @@ _("log size %lld is not a multiple of the log stripe unit %d\n"),
 
 	/* If the log is too large, round down instead of round up */
 	if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
-	    ((tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES)) {
+	    ((tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES) ||
+	    tmp_logblocks > max_logblocks) {
 		tmp_logblocks = (cfg->logblocks / sunit) * sunit;
 	}
 	cfg->logblocks = tmp_logblocks;
@@ -3213,7 +3215,8 @@ static void
 align_internal_log(
 	struct mkfs_params	*cfg,
 	struct xfs_mount	*mp,
-	int			sunit)
+	int			sunit,
+	int			max_logblocks)
 {
 	uint64_t		logend;
 
@@ -3231,7 +3234,7 @@ _("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
 	}
 
 	/* round up/down the log size now */
-	align_log_size(cfg, sunit);
+	align_log_size(cfg, sunit, max_logblocks);
 
 	/* check the aligned log still starts and ends in the same AG. */
 	logend = cfg->logstart + cfg->logblocks - 1;
@@ -3309,7 +3312,7 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 		cfg->logstart = 0;
 		cfg->logagno = 0;
 		if (cfg->lsunit)
-			align_log_size(cfg, cfg->lsunit);
+			align_log_size(cfg, cfg->lsunit, XFS_MAX_LOG_BLOCKS);
 
 		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
 		return;
@@ -3386,9 +3389,9 @@ _("log ag number %lld too large, must be less than %lld\n"),
 	 * Align the logstart at stripe unit boundary.
 	 */
 	if (cfg->lsunit) {
-		align_internal_log(cfg, mp, cfg->lsunit);
+		align_internal_log(cfg, mp, cfg->lsunit, max_logblocks);
 	} else if (cfg->dsunit) {
-		align_internal_log(cfg, mp, cfg->dsunit);
+		align_internal_log(cfg, mp, cfg->dsunit, max_logblocks);
 	}
 	validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
 }

