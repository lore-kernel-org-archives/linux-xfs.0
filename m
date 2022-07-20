Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A0BFC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 23:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiGTXjY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 19:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiGTXjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 19:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7944949B42
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 16:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1590361DEE
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 23:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F91C3411E
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 23:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658360362;
        bh=nzmjyrqyFME9TqoLVLo3VDpv0Vrj4V3YH0MPWCarQHQ=;
        h=Date:From:To:Subject:From;
        b=Se6knHV8iTUqJt4KMuahCLpoFeA/tKfJ5aDprdfI3M/ITuHajvLJFfM6m5jNJfUlq
         oyS0MaQfF7EXduUnjF205wyTPkJM8DkAcW9qyVCs7mYuNNg5jkDIp0UPv9IIf2Na/Z
         kKA/H6yC3BUx4GO9kPM9PUPcJnfb6u6F1UMDhuJ0xlbBtv84wS/JBphUK7VdjjE3Pa
         O1VxX8+NgUowDgqollgrw21KBQrVB54vSk3cVOPdT7IsRwwxiIvpEHOjlc69cX81QW
         2pSWdo8tDndXn4tiCmtNWfhQcvZ6FfSS+ZBM6uh0IGFgXzA1/ZjxmSFDZmNRoK6waC
         TeJzHljo9Oszg==
Date:   Wed, 20 Jul 2022 16:39:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [RFC[RAP] PATCH] xfs: fix unit conversion error in
 xfs_log_calc_max_attrsetm_res
Message-ID: <YtiSKY1OcPAg+p52@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Dave and I were discussing some recent test regressions as a result of
me turning on nrext64=1 on realtime filesystems, when we noticed that
the minimum log size of a 32M filesystem jumped from 954 blocks to 4287
blocks.

Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that @size
contains the maximum estimated amount of space needed for a local format
xattr, in bytes, but we feed this quantity to XFS_NEXTENTADD_SPACE_RES,
which requires units of blocks.  This has resulted in an overestimation
of the minimum log size over the years.

We should nominally correct this, but there's a backwards compatibility
problem -- if we enable it now, the minimum log size will decrease.  If
a corrected mkfs formats a filesystem with this new smaller log size, a
user will encounter mount failures on an old uncorrected kernel due to
the larger minimum log size computations there.

However, the large extent counters feature is still EXPERIMENTAL, so we
can gate the correction on that feature (or any features that get added
after that) being enabled.  Any filesystem with nrext64 or any of the
as-yet-undefined feature bits turned on will be rejected by old
uncorrected kernels, so this should be safe even in the upgrade case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412..8fcfd8dd7935 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -16,6 +16,38 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trace.h"
 
+/*
+ * Decide if the filesystem has the large extent count feature or any feature
+ * added after that.
+ */
+static inline bool
+xfs_is_after_nrext64_epoch(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return false;
+
+	if (xfs_sb_has_compat_feature(&mp->m_sb, ~0))
+		return true;
+
+	if (xfs_sb_has_ro_compat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
+				  XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
+				  XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+				  XFS_SB_FEAT_RO_COMPAT_INOBTCNT)))
+		return true;
+
+	if (xfs_sb_has_incompat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
+				  XFS_SB_FEAT_INCOMPAT_SPINODES |
+				  XFS_SB_FEAT_INCOMPAT_META_UUID |
+				  XFS_SB_FEAT_INCOMPAT_BIGTIME |
+				  XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)))
+		return true;
+
+	return false;
+}
+
 /*
  * Calculate the maximum length in bytes that would be required for a local
  * attribute value as large attributes out of line are not logged.
@@ -31,6 +63,16 @@ xfs_log_calc_max_attrsetm_res(
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
+
+	/*
+	 * Starting with the large extent count feature, every new fs feature
+	 * corrects a unit conversion error in the xattr transaction
+	 * reservation code that resulted in oversized minimum log size
+	 * computations.
+	 */
+	if (xfs_is_after_nrext64_epoch(mp))
+		size = XFS_B_TO_FSB(mp, size);
+
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
 	return  M_RES(mp)->tr_attrsetm.tr_logres +
