Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D27DC7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjFEPhe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbjFEPhc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989DAFF
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CFD2621D8
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852B5C433EF;
        Mon,  5 Jun 2023 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979450;
        bh=ewtMeBAX8pSfOuzp6vIiJnlxHsUgNx/HwJrD+QF7G88=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EevYRwfpZ3ZNPW6FwreGtGyxQrd3n6yJ4YjibBi+cStUXuKd6+9rYoh7GlScC7Xb0
         WCpRS6BeHepX8sgpU2HH2163DqMWwrmEGX2vOXEwqD+I2PzDrqg27oahZgv1ISXpF0
         5tdGBeC5zjVTwvyFNEM7eVbQ/iDCdDUXplg2Xsj1BYq3JRpqAGm34fsLf6wwX4q5lg
         VbTiCnSYzJppMWOG44p28bFkKsy405e6XOBWLNldTPrc/NYIWffLGJoiVCJauP3qO0
         pBZMPP8xzi1BqaJEzXFFMeoZWcNGMigl6eiUxejS65Z7nyTdvJg+faMH3x3OwzR7Va
         YmI3PpncaJM3Q==
Subject: [PATCH 2/2] xfs_repair: always perform extended xattr checks on
 uncertain inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:30 -0700
Message-ID: <168597945009.1226372.4924137788610504146.stgit@frogsfrogsfrogs>
In-Reply-To: <168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs>
References: <168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're processing uncertain inodes, we need to perform the extended
checks on the xattr structure, because the processing might decide that
an uncertain inode is in fact a certain inode, and to restore it to the
filesystem.  If that's the case, xfs_repair fails to catch problems in
the attr structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 0e09132b0b1..cf6a5e399d4 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -1289,10 +1289,12 @@ process_uncertain_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
 			 * process the inode record we just added
 			 * to the good inode tree.  The inode
 			 * processing may add more records to the
-			 * uncertain inode lists.
+			 * uncertain inode lists.  always process the
+			 * extended attribute structure because we might
+			 * decide that some inodes are still in use
 			 */
 			if (process_inode_chunk(mp, agno, igeo->ialloc_inos,
-						nrec, 1, 0, 0, &bogus))  {
+						nrec, 1, 0, 1, &bogus))  {
 				/* XXX - i/o error, we've got a problem */
 				abort();
 			}

