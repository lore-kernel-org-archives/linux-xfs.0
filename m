Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E0CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbiL3Wnf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiL3Wnf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:43:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60BD1573A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:43:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4380B61C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12BEC433D2;
        Fri, 30 Dec 2022 22:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440213;
        bh=n9xuBPMoWB/lqzVXqSQaEdtFml/fa+QjwYWzpXpzj5w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rCmvYORpmqOKNgBvoCPfcxtb01SXcx7bVx0bC4HIZv061HfXCe/34aQAZ9RMoqqD8
         swBAsGzvDbl6tBnH6P2TtyhCzGzfX66CMFEIRFwXj3Lyn+g09z1QS+U64M0VQbInCH
         u8vzxfKkdLuanArwc3ju3Yz6f8iQdsQhgB7UOLMI+WsfejYGl6w+MLwmtZbBMev0gC
         9rPDRKn0/oMmWEtfXGhOp6B6RRwGzOfW/l3GYtteXQjykygMxhCmvn2+iWlPAHwsNA
         GZX0vhEKKBWEfuVXoOcJGlwAz+OlmxQelETIAbYEElJuZyu8puLqlPAQJtO5bw8FVS
         7+JTVAQ+MaGFQ==
Subject: [PATCH 1/4] xfs: remove pointless shadow variable from
 xfs_difree_inobt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:29 -0800
Message-ID: <167243828906.684591.14827402266157881387.stgit@magnolia>
In-Reply-To: <167243828888.684591.12405031427937736396.stgit@magnolia>
References: <167243828888.684591.12405031427937736396.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In xfs_difree_inobt, the pag passed in was previously used to look up
the AGI buffer.  There's no need to extract it again, so remove the
shadow variable and shut up -Wshadow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2451db4c687c..aab83f17d1a5 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1980,8 +1980,6 @@ xfs_difree_inobt(
 	 */
 	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
-		struct xfs_perag	*pag = agbp->b_pag;
-
 		xic->deleted = true;
 		xic->first_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno,
 				rec.ir_startino);

