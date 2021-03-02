Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A243CC43603
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7445061494
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245681AbhCCDQG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360799AbhCBW3w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4DA964F16;
        Tue,  2 Mar 2021 22:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724150;
        bh=VdaL3LjLF3r26CVf9OcE7c5V7tl0Z16sleWqeL5lvbk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sA2BxfYI3dv226u+YVhza1oW0PGcrjDlelbLmdTIG7kP+7F+VqMgcMQ7NW7Mpu4LT
         HBYwGaLdXmJUwjXHZzfVXZXnRPIUD9indqim2a6WN1rp+YBJvXNVxDXwmx3VXO0iWN
         VztkdkQfggMcqD6YJLJMYX/ctRV4zWyxu1Uoi9gsONNJyhCKt/n98ZbXKhpB/HyYvv
         94QdwjNK1tF1OzFkn/VSwDTchlKEltWcKliFFpwVATzLb23Gcbgq6RELhbAhuf3+tU
         j+YaiG9mv40XQVMJM27cUhgDfJbV//1powDlbO56RlJXFAKi5KD/v7qQkJRQw+sgHe
         f5+fQVnuGM0hg==
Subject: [PATCH 6/7] xfs: remove return value from xchk_ag_btcur_init
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 02 Mar 2021 14:29:10 -0800
Message-ID: <161472415044.3421582.2179320230294749858.stgit@magnolia>
In-Reply-To: <161472411627.3421582.2040330025988154363.stgit@magnolia>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Functions called by this function cannot fail, so get rid of the return
and error checking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   15 +++------------
 fs/xfs/scrub/common.c   |    7 +++----
 fs/xfs/scrub/common.h   |    2 +-
 3 files changed, 7 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index afe60a9ca93f..749faa17f8e2 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -477,16 +477,13 @@ xchk_agf_xref(
 {
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		agbno;
-	int			error;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
 	agbno = XFS_AGF_BLOCK(mp);
 
-	error = xchk_ag_btcur_init(sc, &sc->sa);
-	if (error)
-		return;
+	xchk_ag_btcur_init(sc, &sc->sa);
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_agf_xref_freeblks(sc);
@@ -660,16 +657,13 @@ xchk_agfl_xref(
 {
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		agbno;
-	int			error;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
 	agbno = XFS_AGFL_BLOCK(mp);
 
-	error = xchk_ag_btcur_init(sc, &sc->sa);
-	if (error)
-		return;
+	xchk_ag_btcur_init(sc, &sc->sa);
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
@@ -813,16 +807,13 @@ xchk_agi_xref(
 {
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		agbno;
-	int			error;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
 	agbno = XFS_AGI_BLOCK(mp);
 
-	error = xchk_ag_btcur_init(sc, &sc->sa);
-	if (error)
-		return;
+	xchk_ag_btcur_init(sc, &sc->sa);
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 45c5bf37daaa..da60e7d1f895 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -452,7 +452,7 @@ xchk_ag_btcur_free(
 }
 
 /* Initialize all the btree cursors for an AG. */
-int
+void
 xchk_ag_btcur_init(
 	struct xfs_scrub	*sc,
 	struct xchk_ag		*sa)
@@ -502,8 +502,6 @@ xchk_ag_btcur_init(
 		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
 				sa->agf_bp, agno);
 	}
-
-	return 0;
 }
 
 /* Release the AG header context and btree cursors. */
@@ -551,7 +549,8 @@ xchk_ag_init(
 	if (error)
 		return error;
 
-	return xchk_ag_btcur_init(sc, sa);
+	xchk_ag_btcur_init(sc, sa);
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index bf94b2db0b96..5e2c6f693503 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -122,7 +122,7 @@ void xchk_perag_get(struct xfs_mount *mp, struct xchk_ag *sa);
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
 void xchk_ag_btcur_free(struct xchk_ag *sa);
-int xchk_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
+void xchk_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		const struct xfs_owner_info *oinfo, xfs_filblks_t *blocks);
 

