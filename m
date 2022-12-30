Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBC4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbiLaB4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiLaB4h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:56:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7A3A19D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:56:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76D1961C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D412AC433D2;
        Sat, 31 Dec 2022 01:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451795;
        bh=G1YF0RANLr8MRX4xpE1edrgpIqOdx5gB7Xc9+v09PgU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vt25lnLlpg5CacWHBInzMK8Vf1Ft8HeZB3MJabcv3KxOjLI+EnAzxECqTyz4lnoLN
         PLf23pIMgPRKikn6mfXXg+VZyrhGOGXkuZ7SHzwRo4TkYOS+Zy8+NLLUS9iQ6ZtBjY
         Uq5rhvK/Niy6nFUEzjsBF+xWceKhglIL0U3PCCYnaqAT6D/U/bqRIdOeK87+duS2ju
         eS0lc7hlXjrl9cVWCMQPeI2qLlAsnTL3/PvwJ+MJ42NpEUOMWm7T1tjEMLaPcEoS70
         T3LQ0X4/wtUAEEVl9kPrlf0gXT2AeoV1sJsm29oNAKBANsBNwl6vcjBzGwgxFxpzPf
         vlRPZerCD5aAA==
Subject: [PATCH 33/42] xfs: allow dquot rt block count to exceed rt blocks on
 reflink fs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:33 -0800
Message-ID: <167243871365.717073.11026110278057252995.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the quota scrubber to allow dquots where the realtime block count
exceeds the block count of the rt volume if reflink is enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 714bd4c0753a..2d2064126bc9 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -139,12 +139,18 @@ xchk_quota_item(
 		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
 					offset);
+		if (mp->m_sb.sb_rblocks < dq->q_rtb.count)
+			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
+					offset);
 	} else {
 		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 					offset);
+		if (mp->m_sb.sb_rblocks < dq->q_rtb.count)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
+					offset);
 	}
-	if (dq->q_ino.count > fs_icount || dq->q_rtb.count > mp->m_sb.sb_rblocks)
+	if (dq->q_ino.count > fs_icount)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/*

