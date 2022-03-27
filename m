Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEB0C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Mar 2022 16:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbiC0RAX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Mar 2022 13:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiC0RAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Mar 2022 13:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F663527F
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 09:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05162B80DA0
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 16:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6E4C340EC;
        Sun, 27 Mar 2022 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648400319;
        bh=dlk5B4nt3aQvpm5Y8JMdk0n7CtualWE8gUJam6O0b+A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z5wZ8qEg85ijYEDTErmZWuot13gRc+b2g+d9S8AfecZXG+t5UcFcMRy/dgvltPagh
         Ewxl127086ZsfWH5qCVzMp0UUOgodOqOju0pGaNKKPcsCBmX63ejV4BXxN3te0/tbG
         sZktwOTmJcCP6Jm5RJCyymWtSKSP8eTOGEikxEGw123FJBiEXOfimqnfhjXh11zmfs
         bz0G1dGFpOsmxN2Excyocr+vGICePJjMKPddUF9Tl4h7o1QPwBWAWWAS/OkIZArY4a
         6IH9UfsOvlafHKan6wUX1BFwElNLbWjy5cwGzsCsGylTC56lwXtP2YzuBhGrB3YW5/
         SDuOev+P42qbQ==
Subject: [PATCH 4/6] xfs: always succeed at setting the reserve pool size
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 27 Mar 2022 09:58:39 -0700
Message-ID: <164840031922.54920.3945394555613593655.stgit@magnolia>
In-Reply-To: <164840029642.54920.17464512987764939427.stgit@magnolia>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Nowadays, xfs_mod_fdblocks will always choose to fill the reserve pool
with freed blocks before adding to fdblocks.  Therefore, we can change
the behavior of xfs_reserve_blocks slightly -- setting the target size
of the pool should always succeed, since a deficiency will eventually
be made up as blocks get freed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3c6d9d6836ef..5c2bea1e12a8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -434,11 +434,14 @@ xfs_reserve_blocks(
 	 * The code below estimates how many blocks it can request from
 	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
 	 * race since fdblocks updates are not always coordinated via
-	 * m_sb_lock.
+	 * m_sb_lock.  Set the reserve size even if there's not enough free
+	 * space to fill it because mod_fdblocks will refill an undersized
+	 * reserve when it can.
 	 */
 	free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
 	delta = request - mp->m_resblks;
+	mp->m_resblks = request;
 	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
@@ -455,10 +458,8 @@ xfs_reserve_blocks(
 		 * Update the reserve counters if blocks have been successfully
 		 * allocated.
 		 */
-		if (!error) {
-			mp->m_resblks += fdblks_delta;
+		if (!error)
 			mp->m_resblks_avail += fdblks_delta;
-		}
 	}
 out:
 	if (outval) {

