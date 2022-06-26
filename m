Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8D1C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jun 2022 22:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiFZWEI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 18:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiFZWEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 18:04:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8F02DC6
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 15:04:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EA6660FE4
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 22:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F576C3411D;
        Sun, 26 Jun 2022 22:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656281044;
        bh=qbpW8fOWnJLJvicQPmtuPflMJdwJSLnDgVwB01zm3dw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XNqfRV2qUDiVoYV5/CeQicsmNi9fwEtaBDKg3XpSdpYovT5TadMHGt8m+08q16wW3
         61TKuAk5oOE/bJdpHfS699NQrLhlf7yHf8CeHpuc+typ/En/RGuSPhIlDIsJO9DZ/K
         KpPx0gQ8IXRfGGPRnEZf0yPTkLtmv9HfLBco+YOeXk2q4sSe+yyEg/X7/UQRAC6O0/
         yV7/4I1FIgaHlipxywERIY/wRkgwmKMYuMmkPJp5rtlyA3UToFhmb6eMmVJgrolcce
         AVOssOZtv72vkN+FUZfvd8KmsFF+URtH9gfxCJD00/lMn7UqNtUg0YGcr/WqiSbLHh
         HczWthc1jHyHA==
Subject: [PATCH 3/3] xfs: dont treat rt extents beyond EOF as eofblocks to be
 cleared
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 26 Jun 2022 15:04:04 -0700
Message-ID: <165628104422.4040423.6482533913763183686.stgit@magnolia>
In-Reply-To: <165628102728.4040423.16023948770805941408.stgit@magnolia>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

On a system with a realtime volume and a 28k realtime extent,
generic/491 fails because the test opens a file on a frozen filesystem
and closing it causes xfs_release -> xfs_can_free_eofblocks to
mistakenly think that the the blocks of the realtime extent beyond EOF
are posteof blocks to be freed.  Realtime extents cannot be partially
unmapped, so this is pointless.  Worse yet, this triggers posteof
cleanup, which stalls on a transaction allocation, which is why the test
fails.

Teach the predicate to account for realtime extents properly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 52be58372c63..85e1a26c92e8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -686,6 +686,8 @@ xfs_can_free_eofblocks(
 	 * forever.
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
+	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
+		end_fsb = roundup_64(end_fsb, mp->m_sb.sb_rextsize);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
 		return false;

