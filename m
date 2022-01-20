Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49014C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345563AbiATA1s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:27:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48934 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345543AbiATA1s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:27:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C93DB81A7F
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE627C004E1;
        Thu, 20 Jan 2022 00:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638465;
        bh=p3puRW/CAnYP4DzSfwL1mEQ/UWEN+lz6RDrOX204SBE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a1kjzO52RCZ7rXcCeyIsH6HZ5JwLS6cQhYPDYAS8ylQ+0hPumt0esxnleCbOdUXGE
         C2EI+RgyyyfCkZfjQ766hmyTDP0XItB9vxsIZtWsDtAmTtT1F4dKCGnViRb4+HmKq9
         02DLUg/jQDeiZ9sKldQjqtO/hHRbYZHjY9ueEpekK+Cq41CquIcX/PKycOHLkrvxo6
         gG+57Y7o0c06ZgTqveCAKqVNpEb4nbXWYpKI+r7vZv/A+sWFSoQuqAmfcWXQ3W6Vwp
         htIRyB7+SvXejh168cP+vdvWR4Fe2SrKcNcnSjTCiIp/66rGGc7VP5A0YPtt+GHVLl
         j2keKg5mP1w5g==
Subject: [PATCH 1/2] xfs_repair: detect v5 featureset mismatches in secondary
 supers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:27:45 -0800
Message-ID: <164263846554.874349.9648959830870902900.stgit@magnolia>
In-Reply-To: <164263846006.874349.12874049913267940808.stgit@magnolia>
References: <164263846006.874349.12874049913267940808.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we detect and correct mismatches between the V5 features
described in the primary and the secondary superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)


diff --git a/repair/agheader.c b/repair/agheader.c
index d8f912f2..650ffb2e 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -220,6 +220,92 @@ compare_sb(xfs_mount_t *mp, xfs_sb_t *sb)
 	return(XR_OK);
 }
 
+/*
+ * If the fs feature bits on a secondary superblock don't match the
+ * primary, we need to update them.
+ */
+static inline int
+check_v5_feature_mismatch(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_sb		*sb)
+{
+	bool			dirty = false;
+
+	if (!xfs_has_crc(mp) || agno == 0)
+		return 0;
+
+	if (mp->m_sb.sb_features_compat != sb->sb_features_compat) {
+		if (no_modify) {
+			do_warn(
+	_("would fix compat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+					agno, mp->m_sb.sb_features_compat,
+					sb->sb_features_compat);
+		} else {
+			do_warn(
+	_("will fix compat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+					agno, mp->m_sb.sb_features_compat,
+					sb->sb_features_compat);
+			dirty = true;
+		}
+	}
+
+	if ((mp->m_sb.sb_features_incompat ^ sb->sb_features_incompat) &
+			~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR) {
+		if (no_modify) {
+			do_warn(
+	_("would fix incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+					agno, mp->m_sb.sb_features_incompat,
+					sb->sb_features_incompat);
+		} else {
+			do_warn(
+	_("will fix incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+					agno, mp->m_sb.sb_features_incompat,
+					sb->sb_features_incompat);
+			dirty = true;
+		}
+	}
+
+	if (mp->m_sb.sb_features_ro_compat != sb->sb_features_ro_compat) {
+		if (no_modify) {
+			do_warn(
+	_("would fix ro compat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+					agno, mp->m_sb.sb_features_ro_compat,
+					sb->sb_features_ro_compat);
+		} else {
+			do_warn(
+	_("will fix ro compat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+					agno, mp->m_sb.sb_features_ro_compat,
+					sb->sb_features_ro_compat);
+			dirty = true;
+		}
+	}
+
+	if (mp->m_sb.sb_features_log_incompat != sb->sb_features_log_incompat) {
+		if (no_modify) {
+			do_warn(
+	_("would fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+					agno, mp->m_sb.sb_features_log_incompat,
+					sb->sb_features_log_incompat);
+		} else {
+			do_warn(
+	_("will fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+					agno, mp->m_sb.sb_features_log_incompat,
+					sb->sb_features_log_incompat);
+			dirty = true;
+		}
+	}
+
+	if (!dirty)
+		return 0;
+
+	sb->sb_features_compat = mp->m_sb.sb_features_compat;
+	sb->sb_features_ro_compat = mp->m_sb.sb_features_ro_compat;
+	sb->sb_features_incompat = mp->m_sb.sb_features_incompat;
+	sb->sb_features_log_incompat = mp->m_sb.sb_features_log_incompat;
+	return XR_AG_SB_SEC;
+}
+
 /*
  * Possible fields that may have been set at mkfs time,
  * sb_inoalignmt, sb_unit, sb_width and sb_dirblklog.
@@ -452,6 +538,8 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
+	rval |= check_v5_feature_mismatch(mp, i, sb);
+
 	if (xfs_sb_version_needsrepair(sb)) {
 		if (i == 0) {
 			if (!no_modify)

