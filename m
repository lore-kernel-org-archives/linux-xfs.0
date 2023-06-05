Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 844A3C7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbjFEPgY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbjFEPgV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:36:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8611100
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:36:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7405C62729
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81C9C433D2;
        Mon,  5 Jun 2023 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979372;
        bh=AtWrZF+PqFBkN3IJr/f7kxl9CYcAZ/eP4kk0Uk+1aq4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CmlyN4/e/b2e73I9QY+mZdtG3+kS3VdtJzzVpvn5DW9tMRLBAydKn7jayAy4oAksc
         PoZIP2iS6+jy1uCQsrVmFFZG2qp2Eo/6YrJmpOag1kEc6UhmswZFTndMj+kUMe0jDX
         Ox+JhrY+gVrM7znsRAdOa4t36+xIXy6G7Rkns0vosEVIp1KmJaDrGveSvChRRYmaY1
         hHfPQrRloCJxxqiiT0aMv87xKf3fW2xP60amLv/YVLzXdkDxzZ34u518nJq7SwvKiy
         Y96SVuXad94i/6TB3YOsLNv3GN0APkD/71uIApmsZOHNvz9wuVf4UPFN56yzqw0xBD
         nNxY0c6G9RaXg==
Subject: [PATCH 1/3] xfs_repair: check low keys of rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:36:12 -0700
Message-ID: <168597937229.1225991.10603448478250564655.stgit@frogsfrogsfrogs>
In-Reply-To: <168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs>
References: <168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For whatever reason, we only check the high keys in an rmapbt node
block.  We should be checking the low keys and the high keys, so fix
this gap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/scan.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)


diff --git a/repair/scan.c b/repair/scan.c
index 7b72013153d..d66ce60cbb3 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -992,6 +992,7 @@ scan_rmapbt(
 	uint64_t		lastowner = 0;
 	uint64_t		lastoffset = 0;
 	struct xfs_rmap_key	*kp;
+	struct xfs_rmap_irec	oldkey;
 	struct xfs_rmap_irec	key = {0};
 	struct xfs_perag	*pag;
 
@@ -1211,7 +1212,7 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	}
 
 	/* check the node's high keys */
-	for (i = 0; !isroot && i < numrecs; i++) {
+	for (i = 0; i < numrecs; i++) {
 		kp = XFS_RMAP_HIGH_KEY_ADDR(block, i + 1);
 
 		key.rm_flags = 0;
@@ -1231,6 +1232,35 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				i, agno, bno, name);
 	}
 
+	/* check for in-order keys */
+	for (i = 0; i < numrecs; i++)  {
+		kp = XFS_RMAP_KEY_ADDR(block, i + 1);
+
+		key.rm_flags = 0;
+		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
+		key.rm_owner = be64_to_cpu(kp->rm_owner);
+		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
+				&key)) {
+			/* Look for impossible flags. */
+			do_warn(
+_("invalid flags in key %u of %s btree block %u/%u\n"),
+				i, name, agno, bno);
+			suspect++;
+			continue;
+		}
+		if (i == 0) {
+			oldkey = key;
+			continue;
+		}
+		if (rmap_diffkeys(&oldkey, &key) > 0) {
+			do_warn(
+_("out of order key %u in %s btree block (%u/%u)\n"),
+				i, name, agno, bno);
+			suspect++;
+		}
+		oldkey = key;
+	}
+
 	pag = libxfs_perag_get(mp, agno);
 	for (i = 0; i < numrecs; i++)  {
 		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);

