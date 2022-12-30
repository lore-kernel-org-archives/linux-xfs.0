Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1F9C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbiL3XVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:21:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F1D1D0DD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:21:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E140B81DAE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC930C433EF;
        Fri, 30 Dec 2022 23:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442495;
        bh=NGy9oZgEJrmoBdvenvTFp3i4FSjQwAk+dVk7O7mESe0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DA1gOS4yfEFjIBG8pHo3lCdhZirwOtlXpH/fqo5KLOW2vv/uGB9rTLnCd83D7kjZL
         hlhuWdd+I+F1rFAOl3VDoXUDClV2UibYWMFcd3bII9EF74QjSF8WGPlStmSJ8B2WMU
         JyVxZOb0X6y7jk0SzbyW5dOzp2i8m73MCVckNGhZvIHj9eELSPM6yAMkiEQwpZ+fYW
         FQwAyCwQBr9ln+SRfFFjOkZWdNGJgoMqtV4UTvpio1UrLcWsJA8UJIfTtddx/Q7KE0
         t1yOjy9liHLkYDJWPq3YYWh+td4NUkooIAon0y3ah2iK3pbEYXiOSsaQKOdR8RhZcl
         9Koc9czLfnJPA==
Subject: [PATCH 6/9] xfs: rearrange xrep_reap_block to make future code flow
 easier
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834767.691918.16687745779142964529.stgit@magnolia>
In-Reply-To: <167243834673.691918.7562784486565988430.stgit@magnolia>
References: <167243834673.691918.7562784486565988430.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rearrange the logic inside xrep_reap_block to make it more obvious that
crosslinked metadata blocks are handled differently.  Add a couple of
tracepoints so that we can tell what's going on at the end of a btree
rebuild operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    6 +++---
 fs/xfs/scrub/reap.c            |   19 ++++++++++++++-----
 fs/xfs/scrub/trace.h           |   17 ++++++++---------
 3 files changed, 25 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 53863560ab0f..629f2a681485 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -645,13 +645,13 @@ xrep_agfl_fill(
 	xfs_fsblock_t		fsbno = start;
 	int			error;
 
+	trace_xrep_agfl_insert(sc->sa.pag, XFS_FSB_TO_AGBNO(sc->mp, start),
+			len);
+
 	while (fsbno < start + len && af->fl_off < af->flcount)
 		af->agfl_bno[af->fl_off++] =
 				cpu_to_be32(XFS_FSB_TO_AGBNO(sc->mp, fsbno++));
 
-	trace_xrep_agfl_insert(sc->mp, sc->sa.pag->pag_agno,
-			XFS_FSB_TO_AGBNO(sc->mp, start), len);
-
 	error = xbitmap_set(&af->used_extents, start, fsbno - 1);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 74c150f38a33..00cdc0e9063e 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -175,8 +175,6 @@ xrep_reap_block(
 	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
 
-	trace_xrep_dispose_btree_extent(sc->mp, agno, agbno, 1);
-
 	/* We don't support reaping file extents yet. */
 	if (sc->ip != NULL || sc->sa.pag->pag_agno != agno) {
 		ASSERT(0);
@@ -206,10 +204,21 @@ xrep_reap_block(
 	 * to run xfs_repair.
 	 */
 	if (has_other_rmap) {
+		trace_xrep_dispose_unmap_extent(sc->sa.pag, agbno, 1);
+
 		error = xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
 				1, rs->oinfo);
-	} else if (rs->resv == XFS_AG_RESV_AGFL) {
-		xrep_block_reap_binval(sc, fsbno);
+		if (error)
+			return error;
+
+		goto roll_out;
+	}
+
+	trace_xrep_dispose_free_extent(sc->sa.pag, agbno, 1);
+
+	xrep_block_reap_binval(sc, fsbno);
+
+	if (rs->resv == XFS_AG_RESV_AGFL) {
 		error = xrep_put_freelist(sc, agbno);
 	} else {
 		/*
@@ -219,7 +228,6 @@ xrep_reap_block(
 		 * every 100 or so EFIs so that we don't exceed the log
 		 * reservation.
 		 */
-		xrep_block_reap_binval(sc, fsbno);
 		__xfs_free_extent_later(sc->tp, fsbno, 1, rs->oinfo, true);
 		rs->deferred++;
 		need_roll = rs->deferred > 100;
@@ -227,6 +235,7 @@ xrep_reap_block(
 	if (error || !need_roll)
 		return error;
 
+roll_out:
 	rs->deferred = 0;
 	return xrep_roll_ag_trans(sc);
 }
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 030ea76f1c90..5c4375397f24 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -730,9 +730,8 @@ TRACE_EVENT(xchk_refcount_incorrect,
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
 DECLARE_EVENT_CLASS(xrep_extent_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, agbno, len),
+	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(pag, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -740,8 +739,8 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
@@ -753,10 +752,10 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 );
 #define DEFINE_REPAIR_EXTENT_EVENT(name) \
 DEFINE_EVENT(xrep_extent_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len), \
-	TP_ARGS(mp, agno, agbno, len))
-DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_btree_extent);
+	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len), \
+	TP_ARGS(pag, agbno, len))
+DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_unmap_extent);
+DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_free_extent);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
 DECLARE_EVENT_CLASS(xrep_rmap_class,

