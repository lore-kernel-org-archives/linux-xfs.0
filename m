Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB7FC433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Jan 2022 23:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiAHXWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Jan 2022 18:22:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55664 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbiAHXWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Jan 2022 18:22:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD5CBB80972
        for <linux-xfs@vger.kernel.org>; Sat,  8 Jan 2022 23:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE3EC36AE5;
        Sat,  8 Jan 2022 23:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641684125;
        bh=LZS84ZFtEfdHRs+KQCtFhv/10MnFJ6jm6gVW/0m68gw=;
        h=Date:From:To:Cc:Subject:From;
        b=oxBg/U6j8W1m7HHUxQRLLvnYN8pPNaG1IY0Co5t4rCEWNLgpLm6+uvPC1G5hYEVwB
         QqECHWNva3PU5dj+yoGLEcPwWN9FFubhL/r2iahxdsjPflJTiQW26+N8EzbPBfL3l1
         P6s5cku1TWOF0qNYMBURdAfnPIbsr4Yy73iHM0Izp0i9VrRhig3Mkq35vomgjcRl+u
         4L/l1gOTfyhUSzUS8pPtKnGPtuSRW126cFKb2UTltchbAEEzttJv4+gr6TmAew7qb2
         ohnZsijGMszX9tzYn7P1vlea/6ezemapA+3/IaDPeaq88BKETE5+oDfiQbkP/t1ekh
         Q76RhWOON04ow==
Date:   Sat, 8 Jan 2022 15:22:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix online fsck handling of v5 feature bits on
 secondary supers
Message-ID: <20220108232203.GU656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While I was auditing the code in xfs_repair that adds feature bits to
existing V5 filesystems, I decided to have a look at how online fsck
handles feature bits, and I found a few problems:

1) ATTR2 is added to the primary super when an xattr is set to a file,
but that isn't consistently propagated to secondary supers.  This isn't
a corruption, merely a discrepancy that repair will fix if it ever has
to restore the primary from a secondary.  Hence, if we find a mismatch
on a secondary, this is a preen condition, not a corruption.

2) There are more compat and ro_compat features now than there used to
be, but we mask off the newer features from testing.  This means we
ignore inconsistencies in the INOBTCOUNT and BIGTIME features, which is
wrong.  Get rid of the masking and compare directly.

3) NEEDSREPAIR, when set on a secondary, is ignored by everyone.  Hence
a mismatch here should also be flagged for preening, and online repair
should clear the flag.  Right now we ignore it due to (2).

4) log_incompat features are ephemeral, since we can clear the feature
bit as soon as the log no longer contains live records for a particular
log feature.  As such, the only copy we care about is the one in the
primary super.  If we find any bits set in the secondary super, we
should flag that for preening, and clear the bits if the user elects to
repair it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c        |   53 ++++++++++++++++++++--------------------
 fs/xfs/scrub/agheader_repair.c |   12 +++++++++
 2 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index bed798792226..90aebfe9dc5f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -281,7 +281,7 @@ xchk_superblock(
 	features_mask = cpu_to_be32(XFS_SB_VERSION2_ATTR2BIT);
 	if ((sb->sb_features2 & features_mask) !=
 	    (cpu_to_be32(mp->m_sb.sb_features2) & features_mask))
-		xchk_block_set_corrupt(sc, bp);
+		xchk_block_set_preen(sc, bp);
 
 	if (!xfs_has_crc(mp)) {
 		/* all v5 fields must be zero */
@@ -290,39 +290,38 @@ xchk_superblock(
 				offsetof(struct xfs_dsb, sb_features_compat)))
 			xchk_block_set_corrupt(sc, bp);
 	} else {
-		/* Check compat flags; all are set at mkfs time. */
-		features_mask = cpu_to_be32(XFS_SB_FEAT_COMPAT_UNKNOWN);
-		if ((sb->sb_features_compat & features_mask) !=
-		    (cpu_to_be32(mp->m_sb.sb_features_compat) & features_mask))
+		/* compat features must match */
+		if (sb->sb_features_compat !=
+				cpu_to_be32(mp->m_sb.sb_features_compat))
 			xchk_block_set_corrupt(sc, bp);
 
-		/* Check ro compat flags; all are set at mkfs time. */
-		features_mask = cpu_to_be32(XFS_SB_FEAT_RO_COMPAT_UNKNOWN |
-					    XFS_SB_FEAT_RO_COMPAT_FINOBT |
-					    XFS_SB_FEAT_RO_COMPAT_RMAPBT |
-					    XFS_SB_FEAT_RO_COMPAT_REFLINK);
-		if ((sb->sb_features_ro_compat & features_mask) !=
-		    (cpu_to_be32(mp->m_sb.sb_features_ro_compat) &
-		     features_mask))
+		/* ro compat features must match */
+		if (sb->sb_features_ro_compat !=
+				cpu_to_be32(mp->m_sb.sb_features_ro_compat))
 			xchk_block_set_corrupt(sc, bp);
 
-		/* Check incompat flags; all are set at mkfs time. */
-		features_mask = cpu_to_be32(XFS_SB_FEAT_INCOMPAT_UNKNOWN |
-					    XFS_SB_FEAT_INCOMPAT_FTYPE |
-					    XFS_SB_FEAT_INCOMPAT_SPINODES |
-					    XFS_SB_FEAT_INCOMPAT_META_UUID);
-		if ((sb->sb_features_incompat & features_mask) !=
-		    (cpu_to_be32(mp->m_sb.sb_features_incompat) &
-		     features_mask))
-			xchk_block_set_corrupt(sc, bp);
+		/*
+		 * NEEDSREPAIR is ignored on a secondary super, so we should
+		 * clear it when we find it, though it's not a corruption.
+		 */
+		features_mask = cpu_to_be32(XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
+		if ((cpu_to_be32(mp->m_sb.sb_features_incompat) ^
+				sb->sb_features_incompat) & features_mask)
+			xchk_block_set_preen(sc, bp);
 
-		/* Check log incompat flags; all are set at mkfs time. */
-		features_mask = cpu_to_be32(XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN);
-		if ((sb->sb_features_log_incompat & features_mask) !=
-		    (cpu_to_be32(mp->m_sb.sb_features_log_incompat) &
-		     features_mask))
+		/* all other incompat features must match */
+		if ((cpu_to_be32(mp->m_sb.sb_features_incompat) ^
+				sb->sb_features_incompat) & ~features_mask)
 			xchk_block_set_corrupt(sc, bp);
 
+		/*
+		 * log incompat features protect newer log record types from
+		 * older log recovery code.  Log recovery doesn't check the
+		 * secondary supers, so we can clear these if needed.
+		 */
+		if (sb->sb_features_log_incompat)
+			xchk_block_set_preen(sc, bp);
+
 		/* Don't care about sb_crc */
 
 		if (sb->sb_spino_align != cpu_to_be32(mp->m_sb.sb_spino_align))
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index d7bfed52f4cd..6da7f2ca77de 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -52,6 +52,18 @@ xrep_superblock(
 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 
+	/*
+	 * Don't write out a secondary super with NEEDSREPAIR or log incompat
+	 * features set, since both are ignored when set on a secondary.
+	 */
+	if (xfs_has_crc(mp)) {
+		struct xfs_dsb		*sb = bp->b_addr;
+
+		sb->sb_features_incompat &=
+				~cpu_to_be32(XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
+		sb->sb_features_log_incompat = 0;
+	}
+
 	/* Write this to disk. */
 	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
