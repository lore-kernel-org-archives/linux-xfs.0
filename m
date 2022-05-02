Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D10C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 08:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344335AbiEBIYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 04:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383745AbiEBIXy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 04:23:54 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 925B86317
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 01:20:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4A44610E666F
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 18:20:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nlRI4-0073Tn-PV
        for linux-xfs@vger.kernel.org; Mon, 02 May 2022 18:20:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nlRI4-004WML-O7
        for linux-xfs@vger.kernel.org;
        Mon, 02 May 2022 18:20:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: validate v5 feature fields
Date:   Mon,  2 May 2022 18:20:18 +1000
Message-Id: <20220502082018.1076561-5-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502082018.1076561-1-david@fromorbit.com>
References: <20220502082018.1076561-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=626f9446
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=YMDFXDUo5hmWN72gFVsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because stupid dumb fuzzers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 67 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ec6eec5c0e02..d1afe0d43d7f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -30,6 +30,46 @@
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
  */
 
+/*
+ * Validate all the compulsory V4 feature bits are set on a V5 filesystem.
+ */
+bool
+xfs_sb_validate_v5_features(
+	struct xfs_sb	*sbp)
+{
+	/* We must not have any unknown V4 feature bits set */
+	if (sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS)
+		return false;
+
+	/*
+	 * The CRC bit is considered an invalid V4 flag, so we have to add it
+	 * manually to the OKBITS mask.
+	 */
+	if (sbp->sb_features2 & ~(XFS_SB_VERSION2_OKBITS |
+				  XFS_SB_VERSION2_CRCBIT))
+		return false;
+
+	/* Now check all the required V4 feature flags are set. */
+
+#define V5_VERS_FLAGS	(XFS_SB_VERSION_NLINKBIT	| \
+			XFS_SB_VERSION_ALIGNBIT		| \
+			XFS_SB_VERSION_LOGV2BIT		| \
+			XFS_SB_VERSION_EXTFLGBIT	| \
+			XFS_SB_VERSION_DIRV2BIT		| \
+			XFS_SB_VERSION_MOREBITSBIT)
+
+#define V5_FEAT_FLAGS	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
+			XFS_SB_VERSION2_ATTR2BIT	| \
+			XFS_SB_VERSION2_PROJID32BIT	| \
+			XFS_SB_VERSION2_CRCBIT)
+
+	if ((sbp->sb_versionnum & V5_VERS_FLAGS) != V5_VERS_FLAGS)
+		return false;
+	if ((sbp->sb_features2 & V5_FEAT_FLAGS) != V5_FEAT_FLAGS)
+		return false;
+	return true;
+}
+
 /*
  * We support all XFS versions newer than a v4 superblock with V2 directories.
  */
@@ -37,9 +77,19 @@ bool
 xfs_sb_good_version(
 	struct xfs_sb	*sbp)
 {
-	/* all v5 filesystems are supported */
+	/*
+	 * All v5 filesystems are supported, but we must check that all the
+	 * required v4 feature flags are enabled correctly as the code checks
+	 * those flags and not for v5 support.
+	 */
 	if (xfs_sb_is_v5(sbp))
-		return true;
+		return xfs_sb_validate_v5_features(sbp);
+
+	/* We must not have any unknown v4 feature bits set */
+	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
+	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
+	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
+		return false;
 
 	/* versions prior to v4 are not supported */
 	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
@@ -51,12 +101,6 @@ xfs_sb_good_version(
 	if (!(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT))
 		return false;
 
-	/* And must not have any unknown v4 feature bits set */
-	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
-	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
-	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
-		return false;
-
 	/* It's a supported v4 filesystem */
 	return true;
 }
@@ -267,12 +311,15 @@ xfs_validate_sb_common(
 	bool			has_dalign;
 
 	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
-		xfs_warn(mp, "bad magic number");
+		xfs_warn(mp,
+"Superblock has bad magic number 0x%x. Not an XFS filesystem?",
+			be32_to_cpu(dsb->sb_magicnum));
 		return -EWRONGFS;
 	}
 
 	if (!xfs_sb_good_version(sbp)) {
-		xfs_warn(mp, "bad version");
+		xfs_warn(mp,
+"Superblock has unknown features enabled or corrupted feature masks.");
 		return -EWRONGFS;
 	}
 
-- 
2.35.1

