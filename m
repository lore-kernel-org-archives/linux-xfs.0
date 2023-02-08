Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC72C05027
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjBHRwr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjBHRwq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:46 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99827AB7
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:45 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id i2so6783821ple.13
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TMifxjfrKC/qXYdEhYAkRn8dKe1kAeNkoWBqs0MUaZA=;
        b=jF3bNfd5Efuy6r7dJybNunJgE9/flqA/BcrydsU9yV0nsCMwKiHX65o5k3LJzRu0pQ
         LSxaGLuE9kKUNmETUFP10jlIp3vBuGX9UP3L7CMdsGfjXrPIOYHkcVpc+K5MIGB4h0ir
         8E/RkJ9r0dR/HQ2p5Wn9gzhxb22vcxy/MFVA+PKpZSg+KtIEzzpnUfInrN01ITIDRTxh
         27rzPtrt9YcFl5AU2/J1EnNWq156k6hQU/l1CgymcCIZ/dVjbugOPrsUbKvXvpimqPUs
         e5SmCcdMskRHlY1enSmWMtW0c01go02n3ZU0wFRmZJ5i7sxKQehoSPXdEatewHGb/Xzo
         UG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TMifxjfrKC/qXYdEhYAkRn8dKe1kAeNkoWBqs0MUaZA=;
        b=PK9qG24ycbvO5d4VDwvIvtykYPr7IbU4EXoTtak0wvrGlmtl4FYqqFGKRkpwQ3Yoee
         SxqYGhM1myUFsAK7HuDG4YYecHUi+Kgn636MczBkKOpDrN4lmNWnva4BaTTI7Ofgrf9X
         k0pfrzBCETKSbsizvVaUV1bcodat1XkMBdcVd1eXw9JNmWCGKyNzHJbsB42JMXLQtEk6
         e5EeFIWNLrpi0l0jZAhphDIS1H6qvGBV+Lq1ryaTXMeUHRfMt1sS7oH2dOc5iZyG0hdo
         6KWKYlkNG+2UCq5LclorwfKBn9c1wf+BfY9VEaBixHyEIxjY0HklKs1w/x4khsa2Bu5L
         G3dg==
X-Gm-Message-State: AO0yUKVnnEZHcwj/IA07d/yHtHTpklxaAGFe3qKw3SNc8TB9lAUo/pwD
        R2cFfeofx3JCNzF8A+UoKO7Z5AdG9UMjpw==
X-Google-Smtp-Source: AK7set8yJqhoPDqhqDi/ohCvM5y7Hu6H8uaBZijwQfpe/KajVHz2vozH4JvPwnsI6y4LrvKQEW0yQQ==
X-Received: by 2002:a17:902:e2c2:b0:198:e94a:64b5 with SMTP id l2-20020a170902e2c200b00198e94a64b5mr6222395plc.10.1675878764993;
        Wed, 08 Feb 2023 09:52:44 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:44 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 05/10] xfs: validate v5 feature fields
Date:   Wed,  8 Feb 2023 09:52:23 -0800
Message-Id: <20230208175228.2226263-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit f0f5f658065a5af09126ec892e4c383540a1c77f ]

We don't check that the v4 feature flags taht v5 requires to be set
are actually set anywhere. Do this check when we see that the
filesystem is a v5 filesystem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 68 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 72c05485c870..04e2a57313fa 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -30,6 +30,47 @@
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
  */
 
+/*
+ * Check that all the V4 feature bits that the V5 filesystem format requires are
+ * correctly set.
+ */
+static bool
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
@@ -37,9 +78,19 @@ bool
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
@@ -51,12 +102,6 @@ xfs_sb_good_version(
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
@@ -264,12 +309,15 @@ xfs_validate_sb_common(
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
2.39.1.519.gcb327c4b5f-goog

