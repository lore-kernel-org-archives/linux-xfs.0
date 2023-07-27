Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3E1EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjG0WcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbjG0WcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:32:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9D02D64
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE18861F3E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13418C433C7;
        Thu, 27 Jul 2023 22:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497127;
        bh=jhRMCRan4pkX1bkajpOegM9wa8hITUaOX2gVcZCQz/4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FS3Tb56fKpe7ZUL8a3Yk7nb5/0q3Je+kQfs7ZTdNSXX1FI1wdEQFEd1xiM2soZo2U
         7+CaUlA4A0uxLGVX0J9n6M1X01pbVP4bgMb1slaICa9RVc8f2J+mzJ32yF/5CBgwOJ
         BqUS+cx+Rh1iudYP9sLL2IAyC5+emHHhc/wl7WgI5KfnnZqECbGKvpDiyd4RkOhKaP
         bquMN5TOqdN5HcixpSeki3gLCepyt34AW2AiD+jG9D5t7qQ0dBlnitVwi6BkyZCMzf
         uLHYe7Erwav80rjAFphG6L1OhDDJrkBjbBv5LlzCiGlG7XqlQS0UUVnixgUuAHxq5C
         rYPREklc/ETdA==
Date:   Thu, 27 Jul 2023 15:32:06 -0700
Subject: [PATCH 2/2] xfs: don't check reflink iflag state when checking cow
 fork
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626106.922440.13948839161637382689.stgit@frogsfrogsfrogs>
In-Reply-To: <169049626076.922440.10606459711846791721.stgit@frogsfrogsfrogs>
References: <169049626076.922440.10606459711846791721.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Any inode on a reflink filesystem can have a cow fork, even if the inode
does not have the reflink iflag set.  This happens either because the
inode once had the iflag set but does not now, because we don't free the
incore cow fork until the icache deletes the inode; or because we're
running in alwayscow mode.

Either way, we can collapse both of the xfs_is_reflink_inode calls into
one, and change it to xfs_has_reflink, now that the bmap checker will
return ENOENT if there is no pointer to the incore fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index f1e732d4fefdf..75588915572e9 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -850,8 +850,8 @@ xchk_bmap(
 
 	switch (whichfork) {
 	case XFS_COW_FORK:
-		/* No CoW forks on non-reflink inodes/filesystems. */
-		if (!xfs_is_reflink_inode(ip)) {
+		/* No CoW forks on non-reflink filesystems. */
+		if (!xfs_has_reflink(mp)) {
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 			return 0;
 		}
@@ -955,8 +955,5 @@ int
 xchk_bmap_cow(
 	struct xfs_scrub	*sc)
 {
-	if (!xfs_is_reflink_inode(sc->ip))
-		return -ENOENT;
-
 	return xchk_bmap(sc, XFS_COW_FORK);
 }

