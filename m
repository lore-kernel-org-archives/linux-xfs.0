Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C8AC001B0
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 22:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjF0Wob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 18:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjF0Wo2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 18:44:28 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44302947
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:22 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-668730696a4so2754812b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687905862; x=1690497862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4O2k46lv/gI7xyqpvXtBgdwqM0g/QagZozuLf4U9K4c=;
        b=cKgdrZ43YU4na7peEhU2pWxrT3ycVrcStWKlDD3d2SXyyHQ7Gjh4tFS42r8SJJiH/6
         /zUvTh93MiFUtvP/TE9L811XX2NhSCzEH1QuSQcW6uJy/ovkdhFpHhnNnZpcxxQapB7g
         nX4xeBx+GTklHAdtT6qGawUEtlumdu3EFexBoXxeveA1Q29hzIPGCs51wDWz6hLQZKTv
         LsUg13Q4jpjrOOBbPTaIWTOWu8DfBrb629f2GL/PMcBHZ2kcoN0YU0Rm4OqoNULWeLzb
         dtpSPFqCDE9m89SGLt6h2ptDUkOXkYCwHSNI/mPe4eu8ECPrd5NdXithj+aAJUCEwZVh
         mcbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687905862; x=1690497862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4O2k46lv/gI7xyqpvXtBgdwqM0g/QagZozuLf4U9K4c=;
        b=C94+GuXpolvh+I1JHhgM5QYneJbs9P9DJCyRNpZ35wqytRTIndtK2ams9aW2OLsa4w
         r5uSSxSIysWqhubjtmULJeB1kDDj70s0SvGZdRJiRcbRDvpSeFAfaBiZDEPg9IOew1UK
         6NnuhY8gQ7ekT/sAc7tNKCqfHsK2S56nuxqP+Y0TQqAdYzJSqvS7vuHjqp8RRQdCxdAU
         8sCprtU8qiLcnHLeY4NnVD1I89kXftuUuPi5+l6w4TpFT3uONuVwDgZYjodOk1AZrWhu
         JEhCUbMmrJeyHoBmQ37JLOsxnD46jHcZY7FySumPI3m15nDKlv5Cknlp/V0B5CB5jR72
         I20A==
X-Gm-Message-State: AC+VfDwTH+Twc7AQberqwn65hlUSgxypFgabSy/hE4ZZOUAXIAIyLeAy
        cNfQ8sexSeHUMQ2aB5ZBLM30DCfWr7joIcWFjrk=
X-Google-Smtp-Source: ACHHUZ67g6fUTtjziPJRgLpZIRQA/oKWq6w5y0mzV755YfeWH4uh55MmcDS+M5kxUbWXnjw+4Rwd2w==
X-Received: by 2002:a05:6a00:3919:b0:643:aa8d:8cd7 with SMTP id fh25-20020a056a00391900b00643aa8d8cd7mr24682916pfb.32.1687905861960;
        Tue, 27 Jun 2023 15:44:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id y11-20020a62b50b000000b0063f0068cf6csm5878864pfe.198.2023.06.27.15.44.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 15:44:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qEHPz-00Gzwh-1m
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qEHPz-009ZmV-0e
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: journal geometry is not properly bounds checked
Date:   Wed, 28 Jun 2023 08:44:10 +1000
Message-Id: <20230627224412.2242198-7-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230627224412.2242198-1-david@fromorbit.com>
References: <20230627224412.2242198-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If the journal geometry results in a sector or log stripe unit
validation problem, it indicates that we cannot set the log up to
safely write to the the journal. In these cases, we must abort the
mount because the corruption needs external intervention to resolve.
Similarly, a journal that is too large cannot be written to safely,
either, so we shouldn't allow those geometries to mount, either.

If the log is too small, we risk having transaction reservations
overruning the available log space and the system hanging waiting
for space it can never provide. This is purely a runtime hang issue,
not a corruption issue as per the first cases listed above. We abort
mounts of the log is too small for V5 filesystems, but we must allow
v4 filesystems to mount because, historically, there was no log size
validity checking and so some systems may still be out there with
undersized logs.

The problem is that on V4 filesystems, when we discover a log
geometry problem, we skip all the remaining checks and then allow
the log to continue mounting. This mean that if one of the log size
checks fails, we skip the log stripe unit check. i.e. we allow the
mount because a "non-fatal" geometry is violated, and then fail to
check the hard fail geometries that should fail the mount.

Move all these fatal checks to the superblock verifier, and add a
new check for the two log sector size geometry variables having the
same values. This will prevent any attempt to mount a log that has
invalid or inconsistent geometries long before we attempt to mount
the log.

However, for the minimum log size checks, we can only do that once
we've setup up the log and calculated all the iclog sizes and
roundoffs. Hence this needs to remain in the log mount code after
the log has been initialised. It is also the only case where we
should allow a v4 filesystem to continue running, so leave that
handling in place, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 56 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log.c       | 47 +++++++++++------------------------
 2 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ba0f17bc1dc0..5e174685a77c 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -412,7 +412,6 @@ xfs_validate_sb_common(
 	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
 	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
 	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
-	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
 	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
 	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) < XFS_MIN_AG_BYTES	||
 	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) > XFS_MAX_AG_BYTES	||
@@ -430,6 +429,61 @@ xfs_validate_sb_common(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Logs that are too large are not supported at all. Reject them
+	 * outright. Logs that are too small are tolerated on v4 filesystems,
+	 * but we can only check that when mounting the log. Hence we skip
+	 * those checks here.
+	 */
+	if (sbp->sb_logblocks > XFS_MAX_LOG_BLOCKS) {
+		xfs_notice(mp,
+		"Log size 0x%x blocks too large, maximum size is 0x%llx blocks",
+			 sbp->sb_logblocks, XFS_MAX_LOG_BLOCKS);
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_FSB_TO_B(mp, sbp->sb_logblocks) > XFS_MAX_LOG_BYTES) {
+		xfs_warn(mp,
+		"log size 0x%llx bytes too large, maximum size is 0x%llx bytes",
+			 XFS_FSB_TO_B(mp, sbp->sb_logblocks),
+			 XFS_MAX_LOG_BYTES);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Do not allow filesystems with corrupted log sector or stripe units to
+	 * be mounted. We cannot safely size the iclogs or write to the log if
+	 * the log stripe unit is not valid.
+	 */
+	if (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT) {
+		if (sbp->sb_logsectsize != (1U << sbp->sb_logsectlog)) {
+			xfs_notice(mp,
+			"log sector size in bytes/log2 (0x%x/0x%x) must match",
+				sbp->sb_logsectsize, 1U << sbp->sb_logsectlog);
+			return -EFSCORRUPTED;
+		}
+	} else if (sbp->sb_logsectsize || sbp->sb_logsectlog) {
+		xfs_notice(mp,
+		"log sector size in bytes/log2 (0x%x/0x%x) are not zero",
+			sbp->sb_logsectsize, sbp->sb_logsectlog);
+		return -EFSCORRUPTED;
+	}
+
+	if (sbp->sb_logsunit > 1) {
+		if (sbp->sb_logsunit % sbp->sb_blocksize) {
+			xfs_notice(mp,
+		"log stripe unit 0x%x bytes must be a multiple of block size",
+				sbp->sb_logsunit);
+			return -EFSCORRUPTED;
+		}
+		if (sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE) {
+			xfs_notice(mp,
+		"log stripe unit 0x%x bytes over maximum size (0x%x bytes)",
+				sbp->sb_logsunit, XLOG_MAX_RECORD_BSIZE);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	/* Validate the realtime geometry; stolen from xfs_repair */
 	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
 	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE) {
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fc61cc024023..79004d193e54 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -639,7 +639,6 @@ xfs_log_mount(
 	int		num_bblks)
 {
 	struct xlog	*log;
-	bool		fatal = xfs_has_crc(mp);
 	int		error = 0;
 	int		min_logfsbs;
 
@@ -663,53 +662,37 @@ xfs_log_mount(
 	mp->m_log = log;
 
 	/*
-	 * Validate the given log space and drop a critical message via syslog
-	 * if the log size is too small that would lead to some unexpected
-	 * situations in transaction log space reservation stage.
+	 * Now that we have set up the log and it's internal geometry
+	 * parameters, we can validate the given log space and drop a critical
+	 * message via syslog if the log size is too small. A log that is too
+	 * small can lead to unexpected situations in transaction log space
+	 * reservation stage. The superblock verifier has already validated all
+	 * the other log geometry constraints, so we don't have to check those
+	 * here.
 	 *
-	 * Note: we can't just reject the mount if the validation fails.  This
-	 * would mean that people would have to downgrade their kernel just to
-	 * remedy the situation as there is no way to grow the log (short of
-	 * black magic surgery with xfs_db).
+	 * Note: For v4 filesystems, we can't just reject the mount if the
+	 * validation fails.  This would mean that people would have to
+	 * downgrade their kernel just to remedy the situation as there is no
+	 * way to grow the log (short of black magic surgery with xfs_db).
 	 *
-	 * We can, however, reject mounts for CRC format filesystems, as the
+	 * We can, however, reject mounts for V5 format filesystems, as the
 	 * mkfs binary being used to make the filesystem should never create a
 	 * filesystem with a log that is too small.
 	 */
 	min_logfsbs = xfs_log_calc_minimum_size(mp);
-
 	if (mp->m_sb.sb_logblocks < min_logfsbs) {
 		xfs_warn(mp,
 		"Log size %d blocks too small, minimum size is %d blocks",
 			 mp->m_sb.sb_logblocks, min_logfsbs);
-		error = -EINVAL;
-	} else if (mp->m_sb.sb_logblocks > XFS_MAX_LOG_BLOCKS) {
-		xfs_warn(mp,
-		"Log size %d blocks too large, maximum size is %lld blocks",
-			 mp->m_sb.sb_logblocks, XFS_MAX_LOG_BLOCKS);
-		error = -EINVAL;
-	} else if (XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks) > XFS_MAX_LOG_BYTES) {
-		xfs_warn(mp,
-		"log size %lld bytes too large, maximum size is %lld bytes",
-			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
-			 XFS_MAX_LOG_BYTES);
-		error = -EINVAL;
-	} else if (mp->m_sb.sb_logsunit > 1 &&
-		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
-		xfs_warn(mp,
-		"log stripe unit %u bytes must be a multiple of block size",
-			 mp->m_sb.sb_logsunit);
-		error = -EINVAL;
-		fatal = true;
-	}
-	if (error) {
+
 		/*
 		 * Log check errors are always fatal on v5; or whenever bad
 		 * metadata leads to a crash.
 		 */
-		if (fatal) {
+		if (xfs_has_crc(mp)) {
 			xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
 			ASSERT(0);
+			error = -EINVAL;
 			goto out_free_log;
 		}
 		xfs_crit(mp, "Log size out of supported range.");
-- 
2.40.1

