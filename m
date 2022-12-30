Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C94DC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiL3Wkr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3Wkq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:40:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1056CD63
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6F67B81C06
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868F0C433EF;
        Fri, 30 Dec 2022 22:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440042;
        bh=NrxX+RtVCV+DTBmpO5khKdPGieXVCP6nhNg7YtB35fc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=adJnoaBRng+ogHo58EGGUs+nsHzijA9EfluTA49ye93KYpMcNgg/+qNB7clNAgmpQ
         gS+PXTF5zxagV/DLNR6/ssM8YttM+Pk4bqK/R9kZKxHWMWMxIS3xiNl1pGs5tQJSpX
         /DzU53LmnqwpXZ+paLI5c/s5SW8bL+z0jgWzzgWHoxHtaa97jqzbBZEwxslPWUwLL3
         PweCC7gbqtyRRr4T0WYaEp9jZDDWV/ifAkzNi1HgUy+78k38OhYgyBDOUMCFYAuyHd
         clwPGj9g6w9mjExKViBjsht4bLdncY4O06y1njsIXsWtaYz6Etbh3WVJkB+O7LrlNq
         Rk7MwnNbMyE/A==
Subject: [PATCH 3/3] xfs: hoist inode record alignment checks from scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:15 -0800
Message-ID: <167243827583.684088.2409271075220837586.stgit@magnolia>
In-Reply-To: <167243827537.684088.11219968589590305107.stgit@magnolia>
References: <167243827537.684088.11219968589590305107.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the inobt record alignment checks from xchk_iallocbt_rec into
xfs_inobt_check_irec so that they are applied everywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |    4 ++++
 fs/xfs/scrub/ialloc.c      |    6 ------
 2 files changed, 4 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b6f76935504e..2451db4c687c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -103,8 +103,12 @@ xfs_inobt_check_irec(
 {
 	uint64_t			realfree;
 
+	/* Record has to be properly aligned within the AG. */
 	if (!xfs_verify_agino(cur->bc_ag.pag, irec->ir_startino))
 		return __this_address;
+	if (!xfs_verify_agino(cur->bc_ag.pag,
+				irec->ir_startino + XFS_INODES_PER_CHUNK - 1))
+		return __this_address;
 	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
 	    irec->ir_count > XFS_INODES_PER_CHUNK)
 		return __this_address;
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 9aec5a793397..b85f0cd00bc2 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -413,7 +413,6 @@ xchk_iallocbt_rec(
 	const union xfs_btree_rec	*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
-	struct xfs_perag		*pag = bs->cur->bc_ag.pag;
 	struct xchk_iallocbt		*iabt = bs->private;
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
@@ -431,11 +430,6 @@ xchk_iallocbt_rec(
 	}
 
 	agino = irec.ir_startino;
-	/* Record has to be properly aligned within the AG. */
-	if (!xfs_verify_agino(pag, agino + XFS_INODES_PER_CHUNK - 1)) {
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-		goto out;
-	}
 
 	xchk_iallocbt_rec_alignment(bs, &irec);
 	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)

