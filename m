Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97911C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiJBSbc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiJBSbb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:31:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F2F3C14F
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9727F60F07
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AD2C433C1;
        Sun,  2 Oct 2022 18:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735489;
        bh=z9AuPPbaLpDCHHzdyFPsSlrWnHVse7BeBjoCQOmhQLY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RQfY7bZlYoYaoPlmHZ7asdY/cs5wu3XR8IbQCdzJbh0QV/BEko4VGR78g2KmEg/yq
         bVebSgsMo3KxcxsIZ4OxQBOgWPVXVgADn+MBCsi3uqyj6VSTWka1OFNeBGa4iR3sie
         MdZVZL2hJTThcnR6n3jOfurrHHUK//abTZwV2MJU8o3c06MNqDkFPt68tHKr5X7jOW
         4PmuBtLvDOxLlY16UF0RZUDc36Ivok5v6IjHdRWcUiHiq+sZyaTHx9xbLQ1NPnBq/K
         IVm4k5xUoclhi1TiSfnmiIkID/ak5gzgppkoXguymXu9E0rbKDeKRbDxcQAkdytsyx
         uTH/94irBv1JA==
Subject: [PATCH 4/6] xfs: check quota files for unwritten extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:09 -0700
Message-ID: <166473480929.1083927.16868038391470181366.stgit@magnolia>
In-Reply-To: <166473480864.1083927.11062319917293302327.stgit@magnolia>
References: <166473480864.1083927.11062319917293302327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach scrub to flag quota files containing unwritten extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index d15682e2f2a3..7b21e1012eff 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -14,6 +14,7 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
+#include "xfs_bmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
@@ -192,11 +193,12 @@ xchk_quota_data_fork(
 	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xchk_should_terminate(sc, &error))
 			break;
+
 		/*
-		 * delalloc extents or blocks mapped above the highest
+		 * delalloc/unwritten extents or blocks mapped above the highest
 		 * quota id shouldn't happen.
 		 */
-		if (isnullstartblock(irec.br_startblock) ||
+		if (!xfs_bmap_is_written_extent(&irec) ||
 		    irec.br_startoff > max_dqid_off ||
 		    irec.br_startoff + irec.br_blockcount - 1 > max_dqid_off) {
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,

