Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3C0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbiLaBQG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiLaBQF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:16:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDE7267A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:16:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0E1F61D76
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B053C433EF;
        Sat, 31 Dec 2022 01:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449363;
        bh=IUq+uTtRhJRY47zdelTje8W+8i/0bgteo7TdGj2BOVw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f43mVKyCZY3zpxoNNar4/k/hcdR/S4x+3c1HGrjUilKQ5zccORoOnNyL7TmmO4ZzN
         G8ZwHHn668yya3bWaKuIsYbnUPQZLOuQyglqG4KL5yXUWgRoeX+OOvuT1doi/EUoGZ
         oU3eLuhU231+8eLbc9XQ0DPx083CcF81enUpBmLw74okDwyVNw4EdMJg79/cwDM7iD
         V6+Yrk9x22fw01QhEFM6o2CrzK/fy9LWzZtVfwH8LOTBfSzu3mCY6TlZ8W+phmNFqj
         D2wss2ctBE1o7hoYdR83uffoCGUbmOAOkuy7VsfzD2KhixklW4cnuKmik6g+cShjz/
         devMnUihqve8w==
Subject: [PATCH 22/23] xfs: don't check secondary super inode pointers when
 metadir enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:27 -0800
Message-ID: <167243864769.708110.11113843210077455683.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When metadata directories are enabled, the rt and quota inodes are no
longer pointed to by the superblock, so it doesn't make sense to check
these.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index fb2f32a2af5d..e5edba4219fd 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -144,11 +144,16 @@ xchk_superblock(
 	if (sb->sb_rootino != cpu_to_be64(mp->m_sb.sb_rootino))
 		xchk_block_set_preen(sc, bp);
 
-	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
-		xchk_block_set_preen(sc, bp);
+	if (xfs_has_metadir(sc->mp)) {
+		if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_metadirino))
+			xchk_block_set_preen(sc, bp);
+	} else {
+		if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
+			xchk_block_set_preen(sc, bp);
 
-	if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
-		xchk_block_set_preen(sc, bp);
+		if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
+			xchk_block_set_preen(sc, bp);
+	}
 
 	if (sb->sb_rextsize != cpu_to_be32(mp->m_sb.sb_rextsize))
 		xchk_block_set_corrupt(sc, bp);
@@ -225,11 +230,13 @@ xchk_superblock(
 	 * sb_icount, sb_ifree, sb_fdblocks, sb_frexents
 	 */
 
-	if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
-		xchk_block_set_preen(sc, bp);
+	if (!xfs_has_metadir(sc->mp)) {
+		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
+			xchk_block_set_preen(sc, bp);
 
-	if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
-		xchk_block_set_preen(sc, bp);
+		if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
+			xchk_block_set_preen(sc, bp);
+	}
 
 	/*
 	 * Skip the quota flags since repair will force quotacheck.
@@ -338,8 +345,10 @@ xchk_superblock(
 		if (sb->sb_spino_align != cpu_to_be32(mp->m_sb.sb_spino_align))
 			xchk_block_set_corrupt(sc, bp);
 
-		if (sb->sb_pquotino != cpu_to_be64(mp->m_sb.sb_pquotino))
-			xchk_block_set_preen(sc, bp);
+		if (!xfs_has_metadir(sc->mp)) {
+			if (sb->sb_pquotino != cpu_to_be64(mp->m_sb.sb_pquotino))
+				xchk_block_set_preen(sc, bp);
+		}
 
 		/* Don't care about sb_lsn */
 	}

