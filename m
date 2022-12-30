Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72CFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbiLaCbz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiLaCby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:31:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047EB26D9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:31:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA568B81E74
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBEDC433D2;
        Sat, 31 Dec 2022 02:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453911;
        bh=0LhhCwyee2U3iZxGvjHF3U7N5UMf+OjFv/Ws7WWjwas=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=T9skBGFQdHKU1dDiQliYf0DvFyaNjSNzbRf1D/3adMo/us5F48DeQldQLNi3jQQ1j
         v9ARwmzaApsqqr7JHkglSpLEQqM799W8bDPakZ1cqqk5dYZjeUjme7mhuleWDXe7LH
         UMMwvrvqA8wxJsvGYg1lQWqNkfuxUEA4iteJND5SqMfjqkpclIbAsXbGV3joKdG871
         jEuRdt2Ukz3rQn6nAHdipqg8mnLsIlzRCG83fhW5yLinV8vo9OybSUFci1y7/iH0Sh
         StyQyUCISvqFLxW31nqKdvATHHQXiO/VTHEgTFbPV/6m7/gKw7qfq+dEgeCrlW34Vf
         dpuKe7fyltZMA==
Subject: [PATCH 07/45] xfs: check that rtblock extents do not overlap with the
 rt group metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:44 -0800
Message-ID: <167243878459.731133.6551854440644710834.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The ondisk format specifies that the start of each realtime group must
have a superblock so that rt space mappings never cross an rtgroup
boundary.  Check that rt block pointers obey this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_types.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index f5eab8839e3..6488cda24e8 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -13,6 +13,8 @@
 #include "xfs_mount.h"
 #include "xfs_ag.h"
 #include "xfs_imeta.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 
 /*
@@ -133,6 +135,26 @@ xfs_verify_dir_ino(
 	return xfs_verify_ino(mp, ino);
 }
 
+/*
+ * Verify that an rtgroup block number pointer neither points outside the
+ * rtgroup nor points at static metadata.
+ */
+static inline bool
+xfs_verify_rgno_rgbno(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno)
+{
+	xfs_rgblock_t		eorg;
+
+	eorg = xfs_rtgroup_block_count(mp, rgno);
+	if (rgbno >= eorg)
+		return false;
+	if (rgbno < mp->m_sb.sb_rextsize)
+		return false;
+	return true;
+}
+
 /*
  * Verify that an realtime block number pointer doesn't point off the
  * end of the realtime device.
@@ -142,7 +164,20 @@ xfs_verify_rtbno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	return rtbno < mp->m_sb.sb_rblocks;
+	xfs_rgnumber_t		rgno;
+	xfs_rgblock_t		rgbno;
+
+	if (rtbno >= mp->m_sb.sb_rblocks)
+		return false;
+
+	if (!xfs_has_rtgroups(mp))
+		return true;
+
+	rgbno = xfs_rtb_to_rgbno(mp, rtbno, &rgno);
+	if (rgno >= mp->m_sb.sb_rgcount)
+		return false;
+
+	return xfs_verify_rgno_rgbno(mp, rgno, rgbno);
 }
 
 /* Verify that a realtime device extent is fully contained inside the volume. */
@@ -158,7 +193,14 @@ xfs_verify_rtbext(
 	if (!xfs_verify_rtbno(mp, rtbno))
 		return false;
 
-	return xfs_verify_rtbno(mp, rtbno + len - 1);
+	if (!xfs_verify_rtbno(mp, rtbno + len - 1))
+		return false;
+
+	if (xfs_has_rtgroups(mp) &&
+	    xfs_rtb_to_rgno(mp, rtbno) != xfs_rtb_to_rgno(mp, rtbno + len - 1))
+		return false;
+
+	return true;
 }
 
 /* Calculate the range of valid icount values. */

