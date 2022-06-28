Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C915C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiF1Uta (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiF1Ut3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A1B2CDF4
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6415CB81E06
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F37C341C8;
        Tue, 28 Jun 2022 20:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449366;
        bh=AsL0IbpD2QaTM/8TX79QVg1uWB16DQMxlCc9QgURotM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VaNjiPOPANoZigjdzHR83xTdJf9uyLkia2Z+B5JTu0UQ13MBz/Z6D/5wjfaJe1ocV
         cKiuRhhbwu+xuujJYWxnLkyT3nF1QuCQQGOnSkQfoInHIKtqrKe+6YeWD0UABH8VRp
         L3KhwtlaVPumz6blfeKgx/fBSCAB1AdOIV4Akpbi31weQGTCuFiQQdTiPEaNWQ6EUF
         319fvB7AJmQyBWw3VXHZi9otIuSNeS6mbaIIENjZR10tetSzl3+zWg8eNfMaMyclSO
         4d1Vm0t9sGonEXNSpTi/tjBSM/LxiyCkNwkOqg+rdC01Ju/qyf3fb0++XQMt0zdbrm
         e+JoGrxC2qONg==
Subject: [PATCH 2/6] xfs_repair: clear DIFLAG2_NREXT64 when filesystem doesn't
 support nrext64
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:25 -0700
Message-ID: <165644936573.1089996.11135224585697421312.stgit@magnolia>
In-Reply-To: <165644935451.1089996.13716062701488693755.stgit@magnolia>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clear the nrext64 inode flag if the filesystem doesn't have the nrext64
feature enabled in the superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 00de31fb..547c5833 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2690,6 +2690,25 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			}
 		}
 
+		if (xfs_dinode_has_large_extent_counts(dino) &&
+		    !xfs_has_large_extent_counts(mp)) {
+			if (!uncertain) {
+				do_warn(
+	_("inode %" PRIu64 " is marked large extent counts but file system does not support large extent counts\n"),
+					lino);
+			}
+			flags2 &= ~XFS_DIFLAG2_NREXT64;
+
+			if (no_modify) {
+				do_warn(_("would zero extent counts.\n"));
+			} else {
+				do_warn(_("zeroing extent counts.\n"));
+				dino->di_nextents = 0;
+				dino->di_anextents = 0;
+				*dirty = 1;
+			}
+		}
+
 		if (!verify_mode && flags2 != be64_to_cpu(dino->di_flags2)) {
 			if (!no_modify) {
 				do_warn(_("fixing bad flags2.\n"));

