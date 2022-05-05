Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C04EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381640AbiEEQJG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378685AbiEEQJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:09:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4341275C
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1078B82C77
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF6AC385A8;
        Thu,  5 May 2022 16:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766720;
        bh=fvcuapUXudwFUP5sxC7RhHjyh4f4aIagvAvgV//P3TU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DAo18qAtzOhlIcssiuRk/q1wwRk2BtXRZFwbqJiD6cTQQMIm5u4lCAZHryPKHrdPD
         38pjsW8HMXPV2f/WjFDK3nL7emubowJb6NFY+pcrCvJQyQUrRMpjxgOspcEJ53LFWD
         3xN+hsQFfRDnU1TLGmZvB2FRPEK8agIkW3Qf1N3Tw53UaQrWy5yaJ2l8kL2+1CCFCp
         o95P2IpXaqVnooFYpmlkf4xO032pM7N6L1jrvRzuzTTIOlZeG58YX0f+E5/MuqnGCN
         v/uuwq9uPatyHFxVUQFrlsp50AgoI5MvSXffxhtm6XgYDBGRWgbAJYpNU6h4Ufma5j
         n0xDrmaAh5zwA==
Subject: [PATCH 2/6] mkfs: reduce internal log size when log stripe units are
 in play
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:05:20 -0700
Message-ID: <165176672013.248587.308256009964095950.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

