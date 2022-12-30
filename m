Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6859C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiLaB3v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiLaB3u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:29:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971AF1DF3A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:29:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33D6761CBC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9173CC433EF;
        Sat, 31 Dec 2022 01:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450188;
        bh=8srK5RWwn8vJFyd3rd1rKd8W+EErFGCXh+Dw72oUsMY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SnADZ27aaaiAzUIulOUvZBQ3xh7X78mqRnoX0d31VG0T12xj/dILPF+7Xh3gLdq7C
         bjauw2LhJ2mL0kYROB9Zdr8mkDxPWojbKOxUaGxWN5D+x6sY/39fxn58kcU9Jaa4b9
         c7l5SMGMtNBsh7Z/zIEk3l6+RQArfV/ahxha0bneviKmcaLbyATaW1w4SX8DfHlN4y
         NFk1uIHjgySSTGwEj/nGqCv6e8WOAq71ruxhRoboBdjcb4llZEXQlQQK1NkSrAQVaE
         zAaspKvo3wKQ5lW62Afje/x1FUwzeLhEtKv9dwdWNrhZBGLjui63mtCMWjbPUtXPdt
         tMqdQqSqeQcgw==
Subject: [PATCH 09/22] xfs: check that rtblock extents do not overlap with the
 rt group metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:54 -0800
Message-ID: <167243867397.712847.17825138506134800655.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_types.c |   46 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index b1fa715e5f39..34d02b2bfdd1 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
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

