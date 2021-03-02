Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E19C4361A
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5AA61477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245678AbhCCDQD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360800AbhCBW3w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D3A664F35;
        Tue,  2 Mar 2021 22:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724145;
        bh=tShhxszLZHSRa7LAtlaYBEFBalkhk7W2Veu/Af6sKYc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jmz/WFPa0tbO81IT9jtx2IONjPiWpNZvZsHmybfYBOpHg88GWndxXZs4iPyBdda0g
         U/sFja91Bj4SpMIjDyfyYDCkUAX5/poXakEpfA6R2pznCrn+Ok/ljScbl33OJgdDst
         xcV0k2rbvcWzAQrOKrMvYzt+sFZp7fIMBUIDuuViBvi5p9qDF61QvNDo27j+MuAz4O
         seDdTIpfPGrJuOrY4P5qUnmSVKOS3Fq1LPaOJmNnvOVBOhBgAXlA35KX0z+QxDTpCs
         j3nqgOYOyZy2gDFn7HWIaFT+aZPYFkg1LmxNt2V9L7rdqG8jKVOg7/5Sat8nnhkyI0
         P37hxtx0v/hcw==
Subject: [PATCH 5/7] xfs: set the scrub AG number in xchk_ag_read_headers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 02 Mar 2021 14:29:04 -0800
Message-ID: <161472414479.3421582.13278274089212153461.stgit@magnolia>
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

Since xchk_ag_read_headers initializes fields in struct xchk_ag, we
might as well set the AG number and save the callers the trouble.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   18 ++++++------------
 fs/xfs/scrub/common.c   |   16 +++++++---------
 fs/xfs/scrub/common.h   |    3 +--
 3 files changed, 14 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index ae8e2e0ac64a..afe60a9ca93f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -508,7 +508,7 @@ xchk_agf(
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_agf		*agf;
 	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	xfs_agnumber_t		agno = sc->sm->sm_agno;
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		eoag;
 	xfs_agblock_t		agfl_first;
@@ -518,9 +518,7 @@ xchk_agf(
 	int			level;
 	int			error = 0;
 
-	agno = sc->sa.agno = sc->sm->sm_agno;
-	error = xchk_ag_read_headers(sc, agno, &sc->sa.agi_bp,
-			&sc->sa.agf_bp, &sc->sa.agfl_bp);
+	error = xchk_ag_read_headers(sc, agno, &sc->sa);
 	if (!xchk_process_error(sc, agno, XFS_AGF_BLOCK(sc->mp), &error))
 		goto out;
 	xchk_buffer_recheck(sc, sc->sa.agf_bp);
@@ -691,14 +689,12 @@ xchk_agfl(
 {
 	struct xchk_agfl_info	sai;
 	struct xfs_agf		*agf;
-	xfs_agnumber_t		agno;
+	xfs_agnumber_t		agno = sc->sm->sm_agno;
 	unsigned int		agflcount;
 	unsigned int		i;
 	int			error;
 
-	agno = sc->sa.agno = sc->sm->sm_agno;
-	error = xchk_ag_read_headers(sc, agno, &sc->sa.agi_bp,
-			&sc->sa.agf_bp, &sc->sa.agfl_bp);
+	error = xchk_ag_read_headers(sc, agno, &sc->sa);
 	if (!xchk_process_error(sc, agno, XFS_AGFL_BLOCK(sc->mp), &error))
 		goto out;
 	if (!sc->sa.agf_bp)
@@ -846,7 +842,7 @@ xchk_agi(
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_agi		*agi;
 	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	xfs_agnumber_t		agno = sc->sm->sm_agno;
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		eoag;
 	xfs_agino_t		agino;
@@ -857,9 +853,7 @@ xchk_agi(
 	int			level;
 	int			error = 0;
 
-	agno = sc->sa.agno = sc->sm->sm_agno;
-	error = xchk_ag_read_headers(sc, agno, &sc->sa.agi_bp,
-			&sc->sa.agf_bp, &sc->sa.agfl_bp);
+	error = xchk_ag_read_headers(sc, agno, &sc->sa);
 	if (!xchk_process_error(sc, agno, XFS_AGI_BLOCK(sc->mp), &error))
 		goto out;
 	xchk_buffer_recheck(sc, sc->sa.agi_bp);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 53456f3de881..45c5bf37daaa 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -402,22 +402,22 @@ int
 xchk_ag_read_headers(
 	struct xfs_scrub	*sc,
 	xfs_agnumber_t		agno,
-	struct xfs_buf		**agi,
-	struct xfs_buf		**agf,
-	struct xfs_buf		**agfl)
+	struct xchk_ag		*sa)
 {
 	struct xfs_mount	*mp = sc->mp;
 	int			error;
 
-	error = xfs_ialloc_read_agi(mp, sc->tp, agno, agi);
+	sa->agno = agno;
+
+	error = xfs_ialloc_read_agi(mp, sc->tp, agno, &sa->agi_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGI))
 		goto out;
 
-	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, agf);
+	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &sa->agf_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGF))
 		goto out;
 
-	error = xfs_alloc_read_agfl(mp, sc->tp, agno, agfl);
+	error = xfs_alloc_read_agfl(mp, sc->tp, agno, &sa->agfl_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGFL))
 		goto out;
 	error = 0;
@@ -547,9 +547,7 @@ xchk_ag_init(
 {
 	int			error;
 
-	sa->agno = agno;
-	error = xchk_ag_read_headers(sc, agno, &sa->agi_bp,
-			&sa->agf_bp, &sa->agfl_bp);
+	error = xchk_ag_read_headers(sc, agno, sa);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 2e50d146105d..bf94b2db0b96 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -120,8 +120,7 @@ int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
 void xchk_perag_get(struct xfs_mount *mp, struct xchk_ag *sa);
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
-		struct xfs_buf **agi, struct xfs_buf **agf,
-		struct xfs_buf **agfl);
+		struct xchk_ag *sa);
 void xchk_ag_btcur_free(struct xchk_ag *sa);
 int xchk_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc, struct xfs_btree_cur *cur,

