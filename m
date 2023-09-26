Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF2DE7F148
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjI0APD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjI0ANC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:13:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E736273B
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:31:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8EDC433C7;
        Tue, 26 Sep 2023 23:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771067;
        bh=Ifvy7CnFx/Kus2WTlwoqt3iG8FK7ZcK1gL3ksOrjUhY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=c4mcL5Qtrh44UyfHev2SaSTs9HeeyQlyCr6Ry8qZHZc8Y2AYXrQ7eElQgcw5c82tg
         0BRWIh5OzFvbftDTUF3+XDuIfff5lj+kgMWXTD9KrqgwSOLlkzOq/cbRd/Hu/Yphj5
         wtjoT23x5/5Y2pRwW3FnQc845GcqwtmE2BphzuQTRLmQD2jU1Dz3fsny9yLiwW48x4
         gHsp1QmnqVz0Z/ct/3eoNowudfYMjUSao2CtUZZNqbgeDncJlCOfij/awLM+w1SVxP
         b6195xnY3RT7lGHY28ZA19sdNVJwg/we0EbY1r///P0T2y910CvhwDn0wnthfUruri
         pUNqj4myBxz+A==
Date:   Tue, 26 Sep 2023 16:31:07 -0700
Subject: [PATCH 1/1] xfs: make xchk_iget safer in the presence of corrupt
 inode btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577058815.3312834.1762190757505617356.stgit@frogsfrogsfrogs>
In-Reply-To: <169577058799.3312834.4066903607681044261.stgit@frogsfrogsfrogs>
References: <169577058799.3312834.4066903607681044261.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When scrub is trying to iget na inode, ensure that it won't end up
deadlocked on a cycle in the inode btree by using an empty transaction
to store all the buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    6 ++++--
 fs/xfs/scrub/common.h |   19 +++++++++++++++++++
 fs/xfs/scrub/inode.c  |    4 ++--
 3 files changed, 25 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index de24532fe0830..23944fcc1a6ca 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -733,6 +733,8 @@ xchk_iget(
 	xfs_ino_t		inum,
 	struct xfs_inode	**ipp)
 {
+	ASSERT(sc->tp != NULL);
+
 	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
 }
 
@@ -882,8 +884,8 @@ xchk_iget_for_scrubbing(
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
-	/* Try a regular untrusted iget. */
-	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	/* Try a safe untrusted iget. */
+	error = xchk_iget_safe(sc, sc->sm->sm_ino, &ip);
 	if (!error)
 		return xchk_install_handle_inode(sc, ip);
 	if (error == -ENOENT)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index cabdc0e16838c..a39dbe6be1e59 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -157,6 +157,25 @@ int xchk_iget_agi(struct xfs_scrub *sc, xfs_ino_t inum,
 void xchk_irele(struct xfs_scrub *sc, struct xfs_inode *ip);
 int xchk_install_handle_inode(struct xfs_scrub *sc, struct xfs_inode *ip);
 
+/*
+ * Safe version of (untrusted) xchk_iget that uses an empty transaction to
+ * avoid deadlocking on loops in the inobt.
+ */
+static inline int
+xchk_iget_safe(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp)
+{
+	int	error;
+
+	ASSERT(sc->tp == NULL);
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+	error = xchk_iget(sc, inum, ipp);
+	xchk_trans_cancel(sc);
+	return error;
+}
+
 /*
  * Don't bother cross-referencing if we already found corruption or cross
  * referencing discrepancies.
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 59d7912fb75f1..74b1ebb40a4c0 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -94,8 +94,8 @@ xchk_setup_inode(
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
-	/* Try a regular untrusted iget. */
-	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	/* Try a safe untrusted iget. */
+	error = xchk_iget_safe(sc, sc->sm->sm_ino, &ip);
 	if (!error)
 		return xchk_install_handle_iscrub(sc, ip);
 	if (error == -ENOENT)

